Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED3B485B90
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 23:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244879AbiAEWWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 17:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244860AbiAEWW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 17:22:28 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3118C061212
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 14:22:27 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso5878197pje.0
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 14:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sUkgqFDFiDtGVPAUgU6Xa5ITE/sInAze9iX46Pb2MMM=;
        b=hsw8ppEFMFavAQBLMRV81zeXSO4N9aaulrhq4zBMNKCIvOHYGwhepxxDE5YbvBogUL
         PqHhS6Xmpa0TYh63N01wJPn4zqRQpFNgm9oxqA4d5AlYKRYwrsUsP65RPp8OyR3x+ail
         OmUsFdsXixIG/2HXpIkLMYZX38j5tamqjcxIBeIznNt8gusyjVJD/odIX1Gvpd7Co0v/
         yvduhyMO2zYaEUvNaQBpHOOe+2sT1UUuduZli34eSLImebr84FFfnHJWIY7W9T/Do/7w
         ExMUUg37iCz/843yWtOeNScDqfXqPolmYi9Ksa2As5Lnc2cgxMWKs9rm2kKACJiQ4p+h
         dNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sUkgqFDFiDtGVPAUgU6Xa5ITE/sInAze9iX46Pb2MMM=;
        b=rbxCqqDAdOc+qzSX8nzu3taBnPGyAqWKYlxBZUVARsPev+rvuVnGniI7gFecZUK9oN
         rs9dYlJpuXxfJ4KjoACLgaT+HNd22ncDqPQ9qu0HbGBYBsijOhoFsTiCVrZYL4XLAoOF
         QuuhQdoq/+9KD82q009bXPCHALfDm7Q8iTFUlOXB1pbhjugjn0Cpqw/NmFASeZZzWJTo
         5aLJI4PfI8x/9qwJxG4undXGB1WaA7NfePIHM6EtqnFGP4OjutNI7McvEnmlTLIbbi0c
         ejCzbu/kMf47Y/0THBCS10K69/N9t2BKa0rGpZHaGdberhMGVCpta/t5A0hqeOuEa8Qy
         T4vQ==
X-Gm-Message-State: AOAM5326xvR2uZFXeDGmqKD7ZPgg7kCpvtrCgqwkdJ8Y4eVGzN09aCFO
        NtvaegSbOyC3/8NxJxbq9pMsIQ==
X-Google-Smtp-Source: ABdhPJzV0453KxEmLbbliY/F1QMex40PViYGaR8yL4+U0XEANUOTELIy6hs/rP6QmX4zFV3P9pUY2Q==
X-Received: by 2002:a17:90b:180a:: with SMTP id lw10mr6597393pjb.57.1641421346908;
        Wed, 05 Jan 2022 14:22:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x40sm102352pfu.185.2022.01.05.14.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 14:22:26 -0800 (PST)
Date:   Wed, 5 Jan 2022 22:22:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com, corbet@lwn.net,
        shuah@kernel.org, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v5 12/21] kvm: x86: Intercept #NM for saving IA32_XFD_ERR
Message-ID: <YdYaH7buoApEVPOg@google.com>
References: <20220105123532.12586-1-yang.zhong@intel.com>
 <20220105123532.12586-13-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105123532.12586-13-yang.zhong@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022, Yang Zhong wrote:
> @@ -6399,6 +6424,26 @@ static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
>  	kvm_after_interrupt(vcpu);
>  }
>  
> +static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Save xfd_err to guest_fpu before interrupt is enabled, so the
> +	 * MSR value is not clobbered by the host activity before the guest
> +	 * has chance to consume it.
> +	 *
> +	 * We should not blindly read xfd_err here, since this exception

Nit, avoid "we", and explain what KVM does (or doesn't) do, not what KVM "should"
do, e.g. just say

	 * Do not blindly read ...

> +	 * might be caused by L1 interception on a platform which doesn't
> +	 * support xfd at all.
> +	 *
> +	 * Do it conditionally upon guest_fpu::xfd. xfd_err matters
> +	 * only when xfd contains a non-zero value.
> +	 *
> +	 * Queuing exception is done in vmx_handle_exit. See comment there.

Another nit, it's worth explaining why XFD_ERR needs to be read here regardless
of is_guest_mode().  E.g.

	 * Injecting the #NM back into the guest is handled in the standard path
	 * as an #NM in L2 may be reflected into L1 as a VM-Exit.  Read XFD_ERR
	 * even if the #NM is from L2, as L1 may have exposed XFD to L2.

Side topic, in a follow up series/patch, it's probably worth adding support in
nested_vmx_prepare_msr_bitmap() to allow passthrough of the MSRs to L2.

> +	 */
> +	if (vcpu->arch.guest_fpu.fpstate->xfd)
> +		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> +}
> +
>  static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  {
>  	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
> @@ -6407,6 +6452,9 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  	/* if exit due to PF check for async PF */
>  	if (is_page_fault(intr_info))
>  		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
> +	/* if exit due to NM, handle before interrupts are enabled */

Nit, drop this comment, it's slightly misleading since the #NM isn't fully handled
here.  The comment in handle_nm_fault_irqoff() is more than sufficient.

> +	else if (is_nm_fault(intr_info))
> +		handle_nm_fault_irqoff(&vmx->vcpu);
>  	/* Handle machine checks before interrupts are enabled */
>  	else if (is_machine_check(intr_info))
>  		kvm_machine_check();
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 21ce65220e38..2c988f8ca616 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9953,6 +9953,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	if (test_thread_flag(TIF_NEED_FPU_LOAD))
>  		switch_fpu_return();
>  
> +	if (vcpu->arch.guest_fpu.xfd_err)
> +		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> +
>  	if (unlikely(vcpu->arch.switch_db_regs)) {
>  		set_debugreg(0, 7);
>  		set_debugreg(vcpu->arch.eff_db[0], 0);
> @@ -10016,6 +10019,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	static_call(kvm_x86_handle_exit_irqoff)(vcpu);
>  
> +	if (vcpu->arch.guest_fpu.xfd_err)
> +		wrmsrl(MSR_IA32_XFD_ERR, 0);
> +
>  	/*
>  	 * Consume any pending interrupts, including the possible source of
>  	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
