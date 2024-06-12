Return-Path: <kvm+bounces-19513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ACB9905E00
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C722B235CB
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995C3127E3F;
	Wed, 12 Jun 2024 21:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fB8clxDM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C4784E07
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718229184; cv=none; b=GfTSMi0ZaWVuelAahXt7wlIfprS1mscSn0x12470Bu0SaA5SQ1EgZu3Srzo05oZltXkpBakfeTYqUZJujJcpc1xU38wratk3wJf5lNqdyWKRLOpgo+k7io7rM7HJQkqT4Ycd+DtmK41uM/WLNi4Ja0qtSvUUJBUFmZ+c+TKdsbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718229184; c=relaxed/simple;
	bh=wusK4kc1FS+vHMjVpzL07yrjIW2g3Y3LcvsX2vuPaps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U9Hsv8vXqTDO2WWuBOcczr+ebk8ZihBSKY9F5a5WXSbE7U8jDeDT1Wh++PKmI7YLffkmCqeFS6ZrSc1poiViYD49iBt7wAnmGd0VOB01IS1YpT7I6TOq6HWBvr3NM3+5B9sgMrJQ3NH6XVmmhTjLoc1+uqjrMHFsTcb503AKVgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fB8clxDM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c2fe3c4133so216322a91.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718229183; x=1718833983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xc5E1XEOoOO6m8at8GOziJ7pGWON/gur52mgUSEksH0=;
        b=fB8clxDMfQn1hS6Z2I1gxumHpNNQjaVGN3szaluSHppL6hXntf8uxhdY9Js8lzGccg
         ggTTh5Z1SsyDNOSmoGSmxBnNJ7RqDqJPK1LD7+6QT480YauemTIvdv4pgjpMoybFHuby
         jIsATDnv+s5qGaXHuD8ZLAX43k5JNhmEfJzUM1mCvIhBAOyY1rWbTaPKvm5XNxf5AU0E
         ZzCe1ivh/IQrQhiiQ0RqvMIZvDjDkoAMW3hgwyWOuFsz2E8VFIAbZJCvjEK8qBfIYc4H
         5UB94XtiRSqYWhJv6kMFgHQh6e/d2upyP2zj/BW+PzWk66CpJ5p+jF3Xu8FegBkuKfTB
         y5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718229183; x=1718833983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xc5E1XEOoOO6m8at8GOziJ7pGWON/gur52mgUSEksH0=;
        b=Ini5yB1YC9fDTLyBLTkbj2uf1P3P+NGZJDImW48cMrk9r2FX7U03tp1e5QucD+FAS7
         LqOuNZ6iufMDSzdxn+kzUrHSFsH1tJIFR4b9eI7L/00dZ2+jFe3joGjxjoWYrCPkJaAY
         evhCeZcKre7420CjvgY8gTeyBn8lvrfdwzs0IUoFAR9EXPnnyzzolFOb6kXRT1kT8p5c
         rOmgYEykD5E8MGKOsqNsw1pQquEZnW9bMkRkAkCht8NNBFjrq526EGpNPkTGP9n7Wagf
         s2DcEUqE9UsVDZ3zfcWorgiRn2DAgZtXzXU2xM/5jXQzwDGujP81OQBuZ4tWzwVND7wi
         lF+g==
X-Forwarded-Encrypted: i=1; AJvYcCUQ3W2szIW9h9VVOe7L6n7hZQiziWwMCkmkA8VNNJY2X959Z4zKIey+xSXb1ud+wzyUwHte0Vfh/khrwdRgcIbgQ4y4
X-Gm-Message-State: AOJu0Yz6cvXi3pxc0m1nNZnnd5Z91fwktOqttZ+j3znO6a3L02HegASg
	NzclUEHq013bm3Y1v7SX14KGVmnVpzUDCAm59e3kWuZsNaRhsKKlmL06Z56TXPzYJEIZglKkTw1
	lDw==
X-Google-Smtp-Source: AGHT+IHbT5hnMTXfHXSrzZVzfM2ddDy1yTfVBw9Mcqt2XJ++35TEAMcRNhA5paiMB3+XTpPwciNXAbVip6c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:62c9:b0:2c2:c65f:52dc with SMTP id
 98e67ed59e1d1-2c4a770e8f6mr8577a91.6.1718229182634; Wed, 12 Jun 2024 14:53:02
 -0700 (PDT)
Date: Wed, 12 Jun 2024 14:53:01 -0700
In-Reply-To: <20240207172646.3981-10-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-10-xin3.li@intel.com>
Message-ID: <ZmoYvcbFBPJ5ARma@google.com>
Subject: Re: [PATCH v2 09/25] KVM: VMX: Switch FRED RSP0 between host and guest
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin3.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	shuah@kernel.org, vkuznets@redhat.com, peterz@infradead.org, 
	ravi.v.shankar@intel.com, xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 07, 2024, Xin Li wrote:
> Switch MSR_IA32_FRED_RSP0 between host and guest in
> vmx_prepare_switch_to_{host,guest}().
> 
> MSR_IA32_FRED_RSP0 is used during ring 3 event delivery only, thus
> KVM, running on ring 0, can run safely with guest FRED RSP0, i.e.,
> no need to switch between host/guest FRED RSP0 during VM entry and
> exit.
> 
> KVM should switch to host FRED RSP0 before returning to user level,
> and switch to guest FRED RSP0 before entering guest mode.

Heh, if only KVM had a framework that was specifically designed for context
switching MSRs on return to userspace.  Translation: please use the user_return_msr()
APIs.

> Signed-off-by: Xin Li <xin3.li@intel.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> ---
> 
> Changes since v1:
> * Don't use guest_cpuid_has() in vmx_prepare_switch_to_{host,guest}(),
>   which are called from IRQ-disabled context (Chao Gao).
> * Reset msr_guest_fred_rsp0 in __vmx_vcpu_reset() (Chao Gao).
> ---
>  arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h |  2 ++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b7b772183ee4..264378c3b784 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1337,6 +1337,16 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  	}
>  
>  	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
> +
> +	if (guest_can_use(vcpu, X86_FEATURE_FRED)) {
> +		/*
> +		 * MSR_IA32_FRED_RSP0 is top of task stack, which never changes.
> +		 * Thus it should be initialized only once.

Then grab the host value during vmx_hardware_setup().  And when you rebase on top
of the latest kvm-x86/next, there's a handy dandy "struct kvm_host_values kvm_host"
to track host MSR values (and similar state).

You could also use that for MSR_IA32_FRED_CONFIG and MSR_IA32_FRED_STKLVLS.

> +		 */
> +		if (unlikely(vmx->msr_host_fred_rsp0 == 0))
> +			vmx->msr_host_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
> +		wrmsrl(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
> +	}
>  #else
>  	savesegment(fs, fs_sel);
>  	savesegment(gs, gs_sel);
> @@ -1381,6 +1391,11 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
>  	invalidate_tss_limit();
>  #ifdef CONFIG_X86_64
>  	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
> +
> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_FRED)) {
> +		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
> +		wrmsrl(MSR_IA32_FRED_RSP0, vmx->msr_host_fred_rsp0);
> +	}
>  #endif
>  	load_fixmap_gdt(raw_smp_processor_id());
>  	vmx->guest_state_loaded = false;
> @@ -4889,6 +4904,8 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>  
>  #ifdef CONFIG_X86_64
>  	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
> +		vmx->msr_guest_fred_rsp0 = 0;

Eh, I wouldn't bother.  Arguably it's better to use __kvm_set_msr(), and "vmx"
is zero-allocated so this is unnecessary.

The GUEST_IA32_FRED_* VMCS fields need to be explicitly initialized because the
VMCS could (very theoretically) use a non-zero-based encoding scheme.

