Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148CE32A6DA
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577740AbhCBPx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344316AbhCBBAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 20:00:31 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA16C061756
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 16:59:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id c19so760928pjq.3
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 16:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0GR2I3eJe2UtIfAfosihtW3UQR7rmpxULTI4sriWpkE=;
        b=YWheDAR6u6jQ+x+YoZGmL6mYfI1Sw94IDVOxSguz9c47Jb+lwwWG7XuzCWymPqMgc4
         wU9/uVt4DRkOdLZh3Z4B0BXd/NIecGPqsdqhBPYuVpaq6Hk3N8crCcRjMx1+Q1l7b/mq
         cwL4NFdo6ZWK4jq7JJZzFe1wdl3og4IumYeLlOJwXWAdE6h+ejJYOGrYLIjtPGiC2k5y
         RT+d5jTYJ9K4P6sjBtypb+d22oVF7tsBcgm/TaNADp5LdxnPmStOVsgCyg5MSh5rRarv
         Ybj/+7aJ5cujNzfoq023tyXUu6dESanahaj3cp89dLEd5hemfs9aUAUfsKQs5SiFHZzP
         d4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0GR2I3eJe2UtIfAfosihtW3UQR7rmpxULTI4sriWpkE=;
        b=bwldfKm1P6dLIoet2U0+5n6N8uWfHD1TESM2CdAxNob8ZV4CD0d/wagMfcNf8ed/Ff
         LZLgTasm7LDZQ7bSDmx7dagpelROEJ7Y+0vtA8N+syyXRFWdnxvcgJbbyTFuVkFVGIlu
         Oc04NgEP92lObgdb+lseHU4vrKIQotWNg3e+iwpM4tOeiQkujPIZ2i8vlkBm51K/YIOV
         uWFRuV0MaiepghE9mgfvy00X8khAQFopGCP+goQEPuYtHnhck9xQV7p0dB12mmBehcgf
         07Mici7mXxgeYZM7rFaLLaiix0ZVVR8abHLgBeLmuiYMW1tbqnQKcp6ryRJUkUuiSyyO
         d5lA==
X-Gm-Message-State: AOAM530CkcfwivjPlmrTdi660p/likosdzT9tPZw18NkYvDNt+nMxHAA
        Wr7lq4mb0Dj9Tc5xtDhTi2N7Wg==
X-Google-Smtp-Source: ABdhPJyQzP0940A7uVbKhp2s258qwAJB1kkcUlLzBHi9Sb2uTk5T4Tf5cZXaC9basCljEDUNSpleNg==
X-Received: by 2002:a17:902:8342:b029:e1:1465:4bf0 with SMTP id z2-20020a1709028342b02900e114654bf0mr1319395pln.76.1614646790066;
        Mon, 01 Mar 2021 16:59:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id z16sm17076140pgj.51.2021.03.01.16.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 16:59:49 -0800 (PST)
Date:   Mon, 1 Mar 2021 16:59:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wei.huang2@amd.com
Subject: Re: [PATCH] KVM: nSVM: Optimize L12 to L2 vmcb.save copies
Message-ID: <YD2N/4sDKS4RJdlR@google.com>
References: <20210301200844.2000-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301200844.2000-1-cavery@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021, Cathy Avery wrote:
>  	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
>  	svm_set_efer(&svm->vcpu, vmcb12->save.efer);
>  	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
>  	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);

Why not utilize VMCB_CR?

> -	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
> +	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = vmcb12->save.cr2;

Same question for VMCB_CR2.

Also, isn't writing svm->vmcb->save.cr2 unnecessary since svm_vcpu_run()
unconditionally writes it?

Alternatively, it shouldn't be too much work to add proper dirty tracking for
CR2.  VMX has to write the real CR2 every time because there's no VMCS field,
but I assume can avoid the write and dirty update on the majority of VMRUNs.

> +
>  	kvm_rax_write(&svm->vcpu, vmcb12->save.rax);
>  	kvm_rsp_write(&svm->vcpu, vmcb12->save.rsp);
>  	kvm_rip_write(&svm->vcpu, vmcb12->save.rip);
>  
>  	/* In case we don't even reach vcpu_run, the fields are not updated */
> -	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2;
>  	svm->vmcb->save.rax = vmcb12->save.rax;
>  	svm->vmcb->save.rsp = vmcb12->save.rsp;
>  	svm->vmcb->save.rip = vmcb12->save.rip;
>  
> -	svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
> -	svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
> -	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
> +	/* These bits will be set properly on the first execution when new_vmc12 is true */
> +	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
> +		svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
> +		svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
> +		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
> +	}
>  }
>  
>  static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 54610270f66a..9761a7ca8100 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1232,6 +1232,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	svm->asid = 0;
>  
>  	svm->nested.vmcb12_gpa = 0;
> +	svm->nested.last_vmcb12_gpa = 0;

We should use INVALID_PAGE, '0' is a legal physical address and could
theoretically get a false negative on the "new_vmcb12" check.

>  	vcpu->arch.hflags = 0;
>  
>  	if (!kvm_pause_in_guest(vcpu->kvm)) {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index fbbb26dd0f73..911868d4584c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -93,6 +93,7 @@ struct svm_nested_state {
>  	u64 hsave_msr;
>  	u64 vm_cr_msr;
>  	u64 vmcb12_gpa;
> +	u64 last_vmcb12_gpa;
>  
>  	/* These are the merged vectors */
>  	u32 *msrpm;
> @@ -247,6 +248,11 @@ static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
>  	vmcb->control.clean &= ~(1 << bit);
>  }
>  
> +static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
> +{
> +        return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
> +}
> +
>  static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
>  {
>  	return container_of(vcpu, struct vcpu_svm, vcpu);
> -- 
> 2.26.2
> 
