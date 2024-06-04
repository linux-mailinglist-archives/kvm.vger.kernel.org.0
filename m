Return-Path: <kvm+bounces-18706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA868FA71E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 02:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A48231C22466
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 00:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94C78494;
	Tue,  4 Jun 2024 00:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="POQizCQL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDBC5680
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 00:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717461937; cv=none; b=VAePGgbpGVcb4V5orTsgkBM4nP16R6r5fkSugswq67puQd4ntb4eiUoo0bhetmps3SACvp6dWLA9zoPfzdqcWzzZW5EwsDwEyp/v+NXLWkfSmIK2PZek82D5HXi21B9V0geblUdA+K10kK5vQo6YNPTBe7SyiGGCdGx7bu2VLpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717461937; c=relaxed/simple;
	bh=0feO/7C+CrLgGRjOb5ae1CaJ7O4SHCcHI6Yy37sOBhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VeidZ9NAw8k1J66y5fgBewv3APUVw5AB8OGcI6fOTM9Dx2w4JRUSYX3xZlFhCQGFAJ0UnaHz5iNF399pq/BDUkcKk1W5rCDK713kUNktoJfVUIDmZSfvjo9zqJHXqlq/9YZbLkNYNUL2g22S9T/0ZDzwDzK0NNkgkKrUMG0pXsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=POQizCQL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70244a8998bso2509830b3a.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 17:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717461934; x=1718066734; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Bm5sO14VbwMd1xIPVmZquFgInZWUqDJbdvBe8VoG78=;
        b=POQizCQLBooCYBuuAVFjMjuPaUY6s0WvhqBuNap7OOV6sTO+diQg4pU1S5cLtFwt2l
         tKx86irXweu37F6G+lGQa+WBW+pqFYJKMRXOpn25hcS6TvMSoiMWGTbhn7LpxSevKtvn
         79H97BLzw5NgSSdRH6mTQKnIDrb4YOGLIL+ucg0hcag2L3Ab+ktFeRp6e5+kXhse8wi5
         9tSBARBRo5np0avYWAu4GXzeRKzGm9Eb2jaO/VX7rhqaiKL54hHz+Di9Xd3oY8Vh/nHT
         kALnedrWrOKl+78HqUcbVboxsXHP0NY2ZFzApluLvr8dJWdnPPBFM3fdx/jcUCM1vPEC
         vNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717461934; x=1718066734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Bm5sO14VbwMd1xIPVmZquFgInZWUqDJbdvBe8VoG78=;
        b=byNzVvx20hK1Md8er/E2LAXCmRAxNURA2ND5wUKGZVOm5iCFbNiTcBJyMaKZBwY5iw
         Sc89iVyALBTUUZxvpEZNjfEwD3ktfudLBOY67AGufnypt6/Qr9ZoAwSn4K4IlsiiuPuj
         R65t6sBac/qujQ97hNmyz4IogcSE5QH0Nwr1/9o4vHh3wMMvzs2tt9s3QmREaQnCiSwj
         c64Ju3Ne4FFrfgPA8KddqbSAFInbaZPbGARZhgSnLAJP5bC+FL/D6gtn40kbjrs1yYsd
         fY6OVwVU9JyN5aCSVR1kSZFp5LFwvFZA0mu6bANpNlvW8hZXJyb2gIBx1ZidX2l3454I
         DrRA==
X-Forwarded-Encrypted: i=1; AJvYcCXcgZSK9edx21+ogc2Jy/I6ptl6ErUCwZAbNvCSR1H8LGe6nSytKcFkqj3eZhfK1QFxc0rzSR3JT9P+1zPB1AfJZHlA
X-Gm-Message-State: AOJu0YwCMvGaXPsq69zCpmtuBnjlN/GL2kx4utTxYfJrOZfaI/JQz1Tg
	9N+WJfGcG85gCKFNWRUx4wqa8QOYhwMaua3A5RnyhfKP2nHM9Km3B5mmm/kbmLKAripzWZRWwBe
	MYw==
X-Google-Smtp-Source: AGHT+IFJPIM5O78GbEgTJkoYIbaMsDfaMyloYqJ1aZGLTAMlZeqHlKfhFkYbfVbqXlLT1sYbBZGJlR/eHek=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:27a1:b0:6ec:f407:ec0c with SMTP id
 d2e1a72fcca58-7024785a3ccmr349295b3a.2.1717461933286; Mon, 03 Jun 2024
 17:45:33 -0700 (PDT)
Date: Mon, 3 Jun 2024 17:45:31 -0700
In-Reply-To: <20240429060643.211-4-ravi.bangoria@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240429060643.211-1-ravi.bangoria@amd.com> <20240429060643.211-4-ravi.bangoria@amd.com>
Message-ID: <Zl5jqwWO4FyawPHG@google.com>
Subject: Re: [PATCH 3/3] KVM SVM: Add Bus Lock Detect support
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org, 
	james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com, 
	j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com, 
	michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 29, 2024, Ravi Bangoria wrote:
> Upcoming AMD uarch will support Bus Lock Detect. Add support for it
> in KVM. Bus Lock Detect is enabled through MSR_IA32_DEBUGCTLMSR and
> MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
> enabled. Add this dependency in the KVM.

This is woefully incomplete, e.g. db_interception() needs to be updated to decipher
whether the #DB is the responsbility of the host or of the guest.

Honestly, I don't see any point in virtualizing this in KVM.  As Jim alluded to,
what's far, far more interesting for KVM is "Bus Lock Threshold".  Virtualizing
this for the guest would have been nice to have during the initial split-lock #AC
support, but now I'm skeptical the complexity is worth the payoff.

I suppose we could allow it if #DB isn't interecepted, at which point the enabling
required is minimal?

> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> ---
>  arch/x86/kvm/svm/nested.c |  3 ++-
>  arch/x86/kvm/svm/svm.c    | 16 +++++++++++++++-
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 55b9a6d96bcf..6e93c2d9e7df 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -586,7 +586,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  	/* These bits will be set properly on the first execution when new_vmc12 is true */
>  	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
>  		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
> -		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
> +		/* DR6_RTM is not supported on AMD as of now. */
> +		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_FIXED_1 | DR6_RTM;
>  		vmcb_mark_dirty(vmcb02, VMCB_DR);
>  	}
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d1a9f9951635..60f3af9bdacb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1038,7 +1038,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
> -	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
> +	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
> +	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
>  			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
>  
> @@ -3119,6 +3120,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		if (data & DEBUGCTL_RESERVED_BITS)
>  			return 1;
>  
> +		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
> +			return 1;
> +
>  		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
>  		svm_update_lbrv(vcpu);
>  		break;
> @@ -5157,6 +5162,15 @@ static __init void svm_set_cpu_caps(void)
>  
>  	/* CPUID 0x8000001F (SME/SEV features) */
>  	sev_set_cpu_caps();
> +
> +	/*
> +	 * LBR Virtualization must be enabled to support BusLockTrap inside the
> +	 * guest, since BusLockTrap is enabled through MSR_IA32_DEBUGCTLMSR and
> +	 * MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
> +	 * enabled.
> +	 */
> +	if (!lbrv)
> +		kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
>  }
>  
>  static __init int svm_hardware_setup(void)
> -- 
> 2.44.0
> 

