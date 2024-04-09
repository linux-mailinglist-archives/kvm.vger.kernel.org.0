Return-Path: <kvm+bounces-13950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 522B589D02A
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45A891C2134D
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9665466E;
	Tue,  9 Apr 2024 02:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o7zPDv37"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9446553E37
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 02:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712628132; cv=none; b=oik9rE2/avQO2NJJVkKOa0PB1ZnJE0lZw6SN1wtMppvy79Zoc92S3D/dUSskCDY8x2tHZwtTCkpg+Sm8hefoBkRLAQnpWBQijk5dYbjSf8iMV7duZKve9dS+R9dySmpceK352ZWcPO4W1PI+AVUGL4c2KLdQFlBzpUXbuyoZh6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712628132; c=relaxed/simple;
	bh=jI+s4ADLS0AUp2OuvikaP10RD+xAePIr1NB6aWES2II=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=loPOaiv71IvFaTuxO6C92cdEpejqkncISSCgldEPHMmx6vRJVbz+gNnzCjF4taS0UlSXRih6mmD/GYESTrDc5RsehdzHDsS8Y/vHRTiWtoke7GF4GCRIVfEwaDcTdtuUkJ/pDgrET8BF0vjK4EDs2XXQy0YghF0ZJOVAfnvNSOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o7zPDv37; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6180514a5ffso17045977b3.0
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 19:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712628128; x=1713232928; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I/9Qg7KGNzFHHNKyCZNdrvRxR6/vuhSy2raPKaP9KdQ=;
        b=o7zPDv37XnfjaFI22DXRMSGIqvsuAFE8ySW9vMA7ciOLro0n/inKeP7nzJ0HYXQlD5
         kRpdRuUapEvjLvc5TTeAteUb1VZs/R2faRsYQvBmdY+cyZt/mcnzhFY4lDCUvKuxaQDj
         Of0plm7BDVfo7+ToDcYGefyHuwcHH8QM9eqxaqAz2RYsdP+FSTCj6SOw5iNc/27V5s/Y
         AEf2O8b1x2LX1xJ2QSEHR1FGwfBj8A1x6U8rRJ/KTkgzQlv2SpybajnV9Wbo8SfIX9An
         GzZaZpVN8+VIZE/T3jTlcDs+KkxNrfPoNyjYU+A619ZxE2Ccqm4tTqf72zB/aNccEnA7
         lJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712628128; x=1713232928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I/9Qg7KGNzFHHNKyCZNdrvRxR6/vuhSy2raPKaP9KdQ=;
        b=ma2MZyKPRaIF7XflWOaSDsZFHHkia7JNbRx8EZxpOE8cuGYtYACzpo5/K7nsZ3FRhS
         erM3K9TLyt6zJqA1Zz/e6Ls0lWyc0GCaoFZ4RRXCY+kEqZMQpsRbmU67/zjwkA0Zd9cJ
         vBSjXkNbBidnEmIQkDu1LqobcfPudCvpjn5Fdvr/fBK9nEc8QwRVZlCSvhBT8dpv/JRg
         qhZnwbjkjXWwwbRVJYYVZlpyBA9osL8JviuVDc2UcuFJW7uKqdQLH+vzaJ8GfLHeQClq
         fLY77MRXSHYY98SVBHddziaEY/AITLVKIrH7na0sShHNgf6DWGECJzkE2J+b3AweKl1P
         cXjQ==
X-Gm-Message-State: AOJu0YzMEAyvruYLsWCKT0nyDgYR15m+qzaB+t3+Mdm+oHEHcA73bQNL
	hn9F/UlLNJNnaw0yOc6lmPHFh9rMHFkSocMZ0ey1NSe7GmGaT/EWuW/NrhPxjgHQW1t3EmYfEU3
	Uug==
X-Google-Smtp-Source: AGHT+IG4wDA3Fz7BPEo0USQk77/KnMmvMTFS/8h5KGrzx+o+VcVEyzAqvxNynb6XccOlL91RUsAwmJT0QeU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c74d:0:b0:615:1c63:417e with SMTP id
 i13-20020a81c74d000000b006151c63417emr319167ywl.1.1712628128689; Mon, 08 Apr
 2024 19:02:08 -0700 (PDT)
Date: Mon,  8 Apr 2024 19:01:29 -0700
In-Reply-To: <20240309013641.1413400-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309013641.1413400-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171262712105.1419825.3878505678593336929.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/pmu: Globally enable GP counters at "RESET"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Babu Moger <babu.moger@amd.com>, Sandipan Das <sandipan.das@amd.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 08 Mar 2024 17:36:39 -0800, Sean Christopherson wrote:
> Globally enable GP counters in PERF_GLOBAL_CTRL when refreshing a vCPU's
> PMU to emulate the architecturally defined post-RESET behavior of the MSR.
> 
> Extend pmu_counters_test.c to verify the behavior.
> 
> Note, this is slightly different than what I "posted" before: it keeps
> PERF_GLOBAL_CTRL '0' if there are no counters.  That's technically not
> what the SDM dictates, but I went with the common sense route of
> interpreting the SDM to mean "globally enable all GP counters".
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/2] KVM: x86/pmu: Set enable bits for GP counters in PERF_GLOBAL_CTRL at "RESET"
      https://github.com/kvm-x86/linux/commit/de120e1d692d
[2/2] KVM: selftests: Verify post-RESET value of PERF_GLOBAL_CTRL in PMCs test
      https://github.com/kvm-x86/linux/commit/08a828249b16

--
https://github.com/kvm-x86/linux/tree/next

