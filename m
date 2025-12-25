Return-Path: <kvm+bounces-66693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C740CDE248
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 23:53:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2545F300C0C8
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 22:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43902BE035;
	Thu, 25 Dec 2025 22:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8eGu+1v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A15125F988
	for <kvm@vger.kernel.org>; Thu, 25 Dec 2025 22:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766703180; cv=none; b=aZBZFkYxglnzUTJbQ8SFNua+6dt6wdZ4XnWBkycRZ1aDhUrWHhMNHpqgrJHxdpVTQEH4XvOqgiu6oRRepHm3LLcZ3uGaaUtdiGnPAm7Ok84NzYFkHmT/qIDRnrJuLFFpzVTRX2uktTIoYwTypegu8M6WFsgywkzIbDhmmyQnEPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766703180; c=relaxed/simple;
	bh=+kqVhuGAp70JBRY0EW8eCqFm/v5Q7ApiuONFrnwt1ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEo2mMY9Bdn8gy9R6DYFjhXv6ilT53YM6Vqaoq7J/M9KAg66hZhT2Xur+lnLcmeZkMDlT1FNEz4WULNBg5YEPViMFIBXrDC7B/OqXl24I/pq5m2m08nuBGE49VuM2P52VNn7u1FKn+YQPFx6uBjG7qgEP184ODYS4dew6AQtU5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B8eGu+1v; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso7854383b3a.2
        for <kvm@vger.kernel.org>; Thu, 25 Dec 2025 14:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766703178; x=1767307978; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NhwH/JXEKKcfKOMiFKKzVSt+hz04mD15fU2MulSweNo=;
        b=B8eGu+1vFDuof49XEUJT4C1876VLVBkqcFv7zcQ6EG+nKSX75jiM2JEv0PCKOTAgC1
         CClCqfJYde7KFPyKHxbTIEuaqLMh/Eb4eUNrwhC6Lo05eGYrj628ktAfZI3S5ak+MEjR
         4YsQlqpxNeVhAh0JFZ3yHkErGpq+4ttrrp94TMlB/E6BkV9CeW14qtCm+mp/oe9tgNj7
         o6EYZ2ojQgIZpxZr0N/4RMR89KmBLaPG1kqEbX641hSLYBV4b025MK3ONufEt4BJJn3i
         D2dsXs7GnUr2gnsxYpaUPVf0caWGrGl6UeQHnaIL7UwoSmkX76OITzEsSluyijE2bDV0
         APrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766703178; x=1767307978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhwH/JXEKKcfKOMiFKKzVSt+hz04mD15fU2MulSweNo=;
        b=gIKzi7TwQvFfObnM7GoaGmAFuKC5pYF48bOVGEHSPYQzvj5rK2IE8d4TluilW+//NM
         f6rYAqTrJyLbcwT9/WiTHPEfqsfgcBNafpmHlkOTLLCtARsktst0XbMcvpGz4JdvQpwl
         aF5AzBXUO/6NRGgTxNGMqpVKAIFblNBaY6O9nLQEx2dvqRVqw1+YUWlKx03cXiiEcxKp
         ccE5Q2Ql2v8wGvpHPQn4lPukoq8RElBBJUPduzVK3Caz78LGiKNoyyn7G5UDlNshARz1
         Lcv42TSJOpws+VqB+4Hwd1hhbaye2lu2okO9ahkWDaX8S7DQY/DyBiAskW5pwSzOUFKz
         uiZg==
X-Forwarded-Encrypted: i=1; AJvYcCWqZLC/nUF25QEM49yoROOmdrYLyK7Aw+RvkK1mTc8roYXtnhStbjiw80+PIp0RMzLGdbc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYzMIwY97OmH4GuXbJXMAUzXMMfaijgPP4JZwtWjPp692+GVzQ
	jklHDGAJpKNH2BJbTWC+Ynv+cTWmvHodjvupz7knIFXo2nCguXmPpnnTVGTt+w==
X-Gm-Gg: AY/fxX7eUV0v+fHHN3IVdLeMPiZjAeWn2kmX/wLhWcMlzbKGvFng3SXjm5OUAWoSYuW
	XFdg6SVC9XjsX1J24Z3OVn14IKjOynUx7r0SGYCVU/z9w0jnf1W0VGGMxUKyr/vRjRbS1AcyI52
	ZFaGbxr8Ui5+x39uOaf2oCHkP3lNf0ydwo2SM5OXA3Rx1e0gJOBcUcr6wjbxMTBrqGc8wbff4Rs
	QWw8dCRKRtDb6G3CmsbqzpT4uJ98wIdX6sRVkSRrPTjpSeSuE29t4GfEAzlMnJ70x6bhE7TOrm0
	ZB/mmw9/bTAVu9ZwFBdwI9YfDPXQWoKWmBP5+LTYX/pMwX6DGmxdK3gtSLgSNp0Eib7TLato4GB
	5tk2n438UtPMRBcOuQiMc4bxmceL/4KOza6tssRwaIbVJmCU2V3P3UhM03mQqzYRswvpBqSwIb2
	InC+fJTQCEBw==
X-Google-Smtp-Source: AGHT+IHJoqJhJWA4uzBCGelajm/RKgdfLG5bGvfxJEnozG40ZRkQEb0/KncACBHBrJkoVGWLi9E4Cw==
X-Received: by 2002:a05:7023:a84:b0:11b:9386:8262 with SMTP id a92af1059eb24-12172314a24mr20348599c88.47.1766703177467;
        Thu, 25 Dec 2025 14:52:57 -0800 (PST)
Received: from localhost ([154.21.93.22])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254d369sm83681223c88.16.2025.12.25.14.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 14:52:56 -0800 (PST)
Date: Fri, 26 Dec 2025 06:52:53 +0800
From: Yao Yuan <yaoyuan0329os@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/5] x86, fpu: separate fpstate->xfd and guest XFD
Message-ID: <cv7xxlu3locjc66xku3hdubkictmpnoy7h2swcfxcn35po5had@nzyti7yhnbnn>
References: <20251224001249.1041934-1-pbonzini@redhat.com>
 <20251224001249.1041934-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224001249.1041934-3-pbonzini@redhat.com>

On Wed, Dec 24, 2025 at 01:12:46AM +0100, Paolo Bonzini wrote:
> Until now, fpstate->xfd has acted as both the guest value and the value
> that the host used when executing XSAVES and XRSTORS.  This is wrong: the
> data in the guest's FPU might not be initialized even if a bit is
> set in XFD and, when that happens, XRSTORing the guest FPU will fail
> with a #NM exception *on the host*.
>
> Instead, store the value of XFD together with XFD_ERR in struct
> fpu_guest; it will still be synchronized in fpu_load_guest_fpstate(), but
> the XRSTOR(S) operation will be able to load any valid state of the FPU
> independent of the XFD value.

Hi Paolo,

LGTM.

Reviewed-by: Yuan Yao <yaoyuan0329os@gmail.com>

>
> Cc: stable@vger.kernel.org
> Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/fpu/api.h   |  6 ++----
>  arch/x86/include/asm/fpu/types.h |  7 +++++++
>  arch/x86/kernel/fpu/core.c       | 19 ++++---------------
>  arch/x86/kernel/fpu/xstate.h     | 18 ++++++++++--------
>  arch/x86/kvm/x86.c               |  6 +++---
>  5 files changed, 26 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
> index 0820b2621416..ee9ba06b7dbe 100644
> --- a/arch/x86/include/asm/fpu/api.h
> +++ b/arch/x86/include/asm/fpu/api.h
> @@ -152,11 +152,9 @@ extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
>  extern int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures);
>
>  #ifdef CONFIG_X86_64
> -extern void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd);
> -extern void fpu_sync_guest_vmexit_xfd_state(void);
> +extern void fpu_sync_guest_vmexit_xfd_state(struct fpu_guest *gfpu);
>  #else
> -static inline void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd) { }
> -static inline void fpu_sync_guest_vmexit_xfd_state(void) { }
> +static inline void fpu_sync_guest_vmexit_xfd_state(struct fpu_guest *gfpu) { }
>  #endif
>
>  extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
> diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
> index 93e99d2583d6..7abe231e2ffe 100644
> --- a/arch/x86/include/asm/fpu/types.h
> +++ b/arch/x86/include/asm/fpu/types.h
> @@ -545,6 +545,13 @@ struct fpu_guest {
>  	 */
>  	u64				xfeatures;
>
> +	/*
> +	 * @xfd:			Save the guest value.  Note that this is
> +	 *				*not* fpstate->xfd, which is the value
> +	 *				the host uses when doing XSAVE/XRSTOR.
> +	 */
> +	u64				xfd;
> +
>  	/*
>  	 * @xfd_err:			Save the guest value.
>  	 */
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index a480fa8c65d5..ff17c96d290a 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -317,16 +317,6 @@ int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures)
>  EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features);
>
>  #ifdef CONFIG_X86_64
> -void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
> -{
> -	fpregs_lock();
> -	guest_fpu->fpstate->xfd = xfd;
> -	if (guest_fpu->fpstate->in_use)
> -		xfd_update_state(guest_fpu->fpstate);
> -	fpregs_unlock();
> -}
> -EXPORT_SYMBOL_FOR_KVM(fpu_update_guest_xfd);
> -
>  /**
>   * fpu_sync_guest_vmexit_xfd_state - Synchronize XFD MSR and software state
>   *
> @@ -339,14 +329,12 @@ EXPORT_SYMBOL_FOR_KVM(fpu_update_guest_xfd);
>   * Note: It can be invoked unconditionally even when write emulation is
>   * enabled for the price of a then pointless MSR read.
>   */
> -void fpu_sync_guest_vmexit_xfd_state(void)
> +void fpu_sync_guest_vmexit_xfd_state(struct fpu_guest *gfpu)
>  {
> -	struct fpstate *fpstate = x86_task_fpu(current)->fpstate;
> -
>  	lockdep_assert_irqs_disabled();
>  	if (fpu_state_size_dynamic()) {
> -		rdmsrq(MSR_IA32_XFD, fpstate->xfd);
> -		__this_cpu_write(xfd_state, fpstate->xfd);
> +		rdmsrq(MSR_IA32_XFD, gfpu->xfd);
> +		__this_cpu_write(xfd_state, gfpu->xfd);
>  	}
>  }
>  EXPORT_SYMBOL_FOR_KVM(fpu_sync_guest_vmexit_xfd_state);
> @@ -890,6 +878,7 @@ void fpu_load_guest_fpstate(struct fpu_guest *gfpu)
>  		fpregs_restore_userregs();
>
>  	fpregs_assert_state_consistent();
> +	xfd_set_state(gfpu->xfd);
>  	if (gfpu->xfd_err)
>  		wrmsrq(MSR_IA32_XFD_ERR, gfpu->xfd_err);
>  }
> diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
> index 52ce19289989..c0ce05bee637 100644
> --- a/arch/x86/kernel/fpu/xstate.h
> +++ b/arch/x86/kernel/fpu/xstate.h
> @@ -180,26 +180,28 @@ static inline void xfd_validate_state(struct fpstate *fpstate, u64 mask, bool rs
>  #endif
>
>  #ifdef CONFIG_X86_64
> -static inline void xfd_set_state(u64 xfd)
> +static inline void __xfd_set_state(u64 xfd)
>  {
>  	wrmsrq(MSR_IA32_XFD, xfd);
>  	__this_cpu_write(xfd_state, xfd);
>  }
>
> +static inline void xfd_set_state(u64 xfd)
> +{
> +	if (__this_cpu_read(xfd_state) != xfd)
> +		__xfd_set_state(xfd);
> +}
> +
>  static inline void xfd_update_state(struct fpstate *fpstate)
>  {
> -	if (fpu_state_size_dynamic()) {
> -		u64 xfd = fpstate->xfd;
> -
> -		if (__this_cpu_read(xfd_state) != xfd)
> -			xfd_set_state(xfd);
> -	}
> +	if (fpu_state_size_dynamic())
> +		xfd_set_state(fpstate->xfd);
>  }
>
>  extern int __xfd_enable_feature(u64 which, struct fpu_guest *guest_fpu);
>  #else
>  static inline void xfd_set_state(u64 xfd) { }
> -
> +static inline void __xfd_set_state(u64 xfd) { }
>  static inline void xfd_update_state(struct fpstate *fpstate) { }
>
>  static inline int __xfd_enable_feature(u64 which, struct fpu_guest *guest_fpu) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 01d95192dfc5..56fd082859bc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4261,7 +4261,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (data & ~kvm_guest_supported_xfd(vcpu))
>  			return 1;
>
> -		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
> +		vcpu->arch.guest_fpu.xfd = data;
>  		break;
>  	case MSR_IA32_XFD_ERR:
>  		if (!msr_info->host_initiated &&
> @@ -4617,7 +4617,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
>  			return 1;
>
> -		msr_info->data = vcpu->arch.guest_fpu.fpstate->xfd;
> +		msr_info->data = vcpu->arch.guest_fpu.xfd;
>  		break;
>  	case MSR_IA32_XFD_ERR:
>  		if (!msr_info->host_initiated &&
> @@ -11405,7 +11405,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	 * in #NM irqoff handler).
>  	 */
>  	if (vcpu->arch.xfd_no_write_intercept)
> -		fpu_sync_guest_vmexit_xfd_state();
> +		fpu_sync_guest_vmexit_xfd_state(&vcpu->arch.guest_fpu);
>
>  	kvm_x86_call(handle_exit_irqoff)(vcpu);
>
> --
> 2.52.0
>
>

