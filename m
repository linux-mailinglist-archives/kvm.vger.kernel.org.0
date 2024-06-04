Return-Path: <kvm+bounces-18828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 474F98FC009
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB9921F2284C
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DCC14F113;
	Tue,  4 Jun 2024 23:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RpD+wLOo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959F014D70B
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544369; cv=none; b=BnCkh/UBENI8519j1NCW4S7XM6Qn8dFDPh+YamTszmrNIYNLF17v3uETTDlvMS99wFq4GZj8KuCZlPMC4pFr/X79Mc3yf9ORTAtl9QK1jGioeJND6EGw8X5O73o2nCU0bmGfOE3vmSpTY/L6bDdWwQdoLHp9axkgoSLXeOtCMfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544369; c=relaxed/simple;
	bh=lH7OitCHRdT7V3xDkv0BZZ4kPK0J/p6LL7hzMRiZfmw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kJV64GvRB1V7uKMQ/22U5aIaakbbGFhM2HsoN2qGL7/C9lVtEfe52jn/mYGM657Q+tbQMi62rW5BKLoozt1TBPSloNTUD3k7gx+MTxmGH7C4ojO/Deqfv/jVuVTzWT2R+xwZ62/ejwNoSYFlRU3sbQ3JRQXD5dGjksO76Jk0hxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RpD+wLOo; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-629fe12b380so25633377b3.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544365; x=1718149165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wVPA1CVlxppPmfWI4RkOia/Fp2tCABe0o8VrZrea1qA=;
        b=RpD+wLOouwfK/fDVj5KMXUBeqnoU4EojDxq0Px5aX3Dl7M0kb0Mw5cgD43MTdGmCIF
         9Fd3AFgSN45jcvoKfLUEVBQKjFiN49RoTVZ/20/oCy3wscu/ExG7W7gmZaPdm0NkDlLD
         SkXfUY6Ivd1NcwOTHFi9GBPYa1tX3u1I6/sh7DNcH5KL1VNQkBBEFJXOcja6ERNIFJtH
         1YbrEKMl/qcLj/uZ6ZWIquvKS+amPcUa3vEer9PtwPjdK/jPVwKU99/1iS5bQ3PL8jsZ
         ya1SqifQh0voqp7tZGDwqeFjDMtWAIvHxtqmHsFL9zQSwe/k2FRLQzm51IZsEw7mP2Il
         3jaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544365; x=1718149165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wVPA1CVlxppPmfWI4RkOia/Fp2tCABe0o8VrZrea1qA=;
        b=Ul+LafOLroTK0ghZjj41kt/3k9LSCLf3ZktIinzbJZGPZ32vV4RdmwDzBZG4XNzONx
         Vz+UzXgPom0nRJWZTqFGpx+JQmSfTweLT+v8a1Oep3o75EF/HpQvKXjrhMF1v6V1ghfv
         oAz6pJanxAmcqBIIt8IdXgO9aH/GDnfExST8/XFoPlg/WnImaAEpAfLHU20JGMhfPcw1
         3zj4XzN/nTbqMsRSD3e3FdSfw+N4MF6Hg0jaXre7ZjF0Wbk1BUC91NBNeLCQG/18I051
         crQhl4avwzHHT3W+++Gs9GmH7jVnyntIOdaAiyjSaPqXAGD6e2nUzVRaaqFHMmRv1ke3
         vJRQ==
X-Gm-Message-State: AOJu0YyRFGjJfPem41XiPaGA8XO34XqllyirphP+lfS/js/PJcgq3/sH
	+yj1jtkN1GxrmKF/+aSz7miNx+vKEdAnOuatZ0gAc8upfqObh9wTiFvncbfRbMfIGX4EsYjtQ81
	0Dg==
X-Google-Smtp-Source: AGHT+IFhXHREMbaaMkh7ThxF7ZZZg81Q0yHJGIpV9KYfxsphttpecTRLSUmZiGMkIqgoZU13fHMYllj+Ipk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:85:b0:61b:e524:f91a with SMTP id
 00721157ae682-62cbb6644d9mr2040697b3.10.1717544365557; Tue, 04 Jun 2024
 16:39:25 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:47 -0700
In-Reply-To: <20240430005239.13527-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430005239.13527-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754375753.2780904.9220835490279179987.b4-ty@google.com>
Subject: Re: [PATCH 0/2] vPMU code refines
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 30 Apr 2024 08:52:37 +0800, Dapeng Mi wrote:
> This small patchset refines the ambiguous naming in kvm_pmu structure
> and use macros instead of magic numbers to manipulate FIXED_CTR_CTRL MSR
> to increase readability.
> 
> No logic change is introduced in this patchset.
> 
> Dapeng Mi (2):
>   KVM: x86/pmu: Change ambiguous _mask suffix to _rsvd in kvm_pmu
>   KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
> 
> [...]

Applied to kvm-x86 pmu, thanks!

[1/2] KVM: x86/pmu: Change ambiguous _mask suffix to _rsvd in kvm_pmu
      https://github.com/kvm-x86/linux/commit/0e102ce3d413
[2/2] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
      https://github.com/kvm-x86/linux/commit/75430c412a31

--
https://github.com/kvm-x86/linux/tree/next

