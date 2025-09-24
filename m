Return-Path: <kvm+bounces-58696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E968B9B8C5
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AA1016B4D0
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308243168F6;
	Wed, 24 Sep 2025 18:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qBjfR1FY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0540117D2
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 18:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758739419; cv=none; b=pKm7bxh4ubxHofo2isku1IjarNs7q3Ap+DnImQN208o7WePcFAFC6L1okk/bIVBeOcvwRFbunSlT9BjgMG1gvpXG5esi3RZvqeB0Aqf8IRKU5CJPkTFe2p9tZir4qjOO0YtMi9ElgNxzz+vA3muDKLQH7zig8kwAtX4A5NaNxOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758739419; c=relaxed/simple;
	bh=kb79KWGuBhjbtd+Rw4+gbcRAfQjofezKNl5IbLEq5jM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M5UzaU3CLXRG8Y/DM3AI07gxRfbUDk+qBsMWpiQBPDpRUBroCCw+OapwmkWJckVMh0oWzKJ45Gvp1xNGea1n7tc7uo38S6TEQp/7r3OJgJ9ZweL/4x41UIhLDe8PVxMNVkyielXTRRaMwDrTsT4fy85zfRFgmOnMaBxnEWsGHOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qBjfR1FY; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2697410e7f9so2574955ad.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 11:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758739417; x=1759344217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IMxcEX841CrPql6fJPtvWxOpepuc8o+xuheZylrBA50=;
        b=qBjfR1FYVtFcaq6Y8XgHJ6YHozTDTZ3ksxxq495r2aVyB5bInIOWuxkwdJDtFuiTCw
         2WRzHqivClPPROGpssjFvxxsj7ztB1u9OrtC4DykNnHhooqVzyYZE3+hMgG9Fpe69Q44
         Z15mPRUJdQwDS0nfMesQSzKpQPZxEeeCO4SPQUL0+f1jgWHL3pAtpGSha8q6skuHf1Ml
         NmkVDZnRteo3mF24thKBGYXYgIMJcxXz7/DO0x4dLwggL07Yz2N/DLTCpkqZOyfQtgyi
         CaAXlnMz6+OmVwCw4MqMus9DmrnXVXLqYcfSt/00Xn2diKrKtM00CtsWBgZxaGbqBqvb
         kTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739417; x=1759344217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMxcEX841CrPql6fJPtvWxOpepuc8o+xuheZylrBA50=;
        b=fyC9Zb7JlEIKqAAWDjsKEi2xgFe1BDYwbJqsecu3qXhkTmQOYFKm6+m/1yaLH6G1DK
         rXcnpcmPIFpCbaSG8HUVFBiZ0khuawRIhcl2LcweAYRXw84SONhSQJcdwdfxlcZC5iUK
         7tGZlM/EWP8GnWGnnV4lFIkQTwpYG89fv9+8DrdZycG2ndQZz+85G4IDZYtECdrXHbfl
         UH8i3w7CuWiOyhUcmUmSqhUCGD8tiHMGxLKFeDYB7gtGDB2/f68R8/Jk42vid3bf8QS3
         RtM8OMIL7X+Une/32QOkzHA0kYvH9a8zjqH6dnOoCj5muMCaVtxvq8apEc43egFse1kQ
         z6eg==
X-Gm-Message-State: AOJu0YwPOdgpHW8pxBk1MvSGS05XavcV7skWhlYZIUnSg+wlAhbwq68D
	9ag3uA9VnbPJe8GbUgw8Cjo6t7zgUIemwnNa+bx8OM85n3RQbnCwNIaQidTQCdymwKD/F/0cqmx
	khiTZhA==
X-Google-Smtp-Source: AGHT+IGyODtBeaq+IfmR3encVEUbiZ9RdIzz7Vzm64UCp4Wg4z6IUEUIwpwz0WVX3nWnc5hBuzDHjuBwWrY=
X-Received: from plby5.prod.google.com ([2002:a17:902:ed45:b0:267:d14f:81f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2b0c:b0:275:6baa:d9
 with SMTP id d9443c01a7336-27ed4a56b08mr6782535ad.40.1758739417279; Wed, 24
 Sep 2025 11:43:37 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:07:37 -0700
In-Reply-To: <20250919214648.1585683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919214648.1585683-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175873630828.2145505.17688306817553365598.b4-ty@google.com>
Subject: Re: [PATCH v4 0/5] KVM: selftests: PMU fixes for GNR/SRF/CWF
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 19 Sep 2025 14:46:43 -0700, Sean Christopherson wrote:
> Fix KVM PMU selftests errors encountered on Granite Rapids (GNR),
> Sierra Forest (SRF) and Clearwater Forest (CWF).
> 
> The cover letter from v2 has gory details, as do the patches.
> 
> v4:
>  - Fix an unavailable_mask goof. [Dapeng]
>  - Fix a bitmask goof (missing BIT_ULL()). [Dapeng]
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/5] KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
      https://github.com/kvm-x86/linux/commit/210b09fa428c
[2/5] KVM: selftests: Track unavailable_mask for PMU events as 32-bit value
      https://github.com/kvm-x86/linux/commit/571fc2833ed0
[3/5] KVM: selftests: Reduce number of "unavailable PMU events" combos tested
      https://github.com/kvm-x86/linux/commit/1fcd3053aa1a
[4/5] KVM: selftests: Validate more arch-events in pmu_counters_test
      https://github.com/kvm-x86/linux/commit/2922b5958865
[5/5] KVM: selftests: Handle Intel Atom errata that leads to PMU event overcount
      https://github.com/kvm-x86/linux/commit/c435978e4ffe

--
https://github.com/kvm-x86/linux/tree/next

