Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D0E31EE5B
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhBRSdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbhBRRm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 12:42:59 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21B8C0613D6
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:42:18 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id b21so1578291pgk.7
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=InRyD+Xla6obrQpV9LQcANEheEe1QGIC/pMhRnQojK0=;
        b=S9zZQxkRxkYHxFN6IJf3kMQKiVKqvmYE8fG9oCJCmhMXA/NRCoNe36+0xPhSUrEFCn
         ZPOTddfRbi+pD7FU6MCpcBqyVMGZa6UbrnzbVQrlIGOGljQR1mNgEoKJZGgPbc1q+x4j
         rRlqU3IhVN1qb/EAf039q5L4ClHn7xygQ3tA9+nvtIEcq/XhbbxDf2GeQ7LbxT5FLPne
         miO/lTWU3ZKkluvKIhYGr20iU6US2+4Y9DvOX0NzO3A3YgfgAQh+1A9m7A4J+WqdZ6H/
         FLC00XWDGj7Te7zpqNardG1xw50iC4GR0Hpj4halJS183obQTEZhTFNzEIFS77/m2mrC
         zuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=InRyD+Xla6obrQpV9LQcANEheEe1QGIC/pMhRnQojK0=;
        b=rZGvnTB/XZ0FWUkFHZldO2rnTummgu5XH1g0lLPEZsJiRMx7kbxns9q0ve4zs0EZVV
         Vd6aJ57J0rD42PAf+8u/pnDLfq7SST4VdWjNQzY2c4YHA/eWkKd23oK2zkJE73yxbYHL
         t2FmooeZCggDtpZ6ck/+W/xlZgtR1DUOdGyE+i6sjqRjJPwhrf3n+PdViL07Eltq73ho
         4l/NTm6CwAguGAP6tJwTk04bx732F/I9iS8Mpyt9aRo5bRhD7ysQXvFElYbaTyXEPDBr
         iWcfj7ewhrej1h/Q2eZ6c79YO3/HKQfgOMUZB1mzRHj2ikQ1ZneH/7Sx49ST9HZT4n3J
         h8sw==
X-Gm-Message-State: AOAM533zxaVxuwTGntQDkN2Wcs/R+e21TlJKzvlxlqqx2cjlDWQLWPeE
        P3MJ6PZ0s6IL4LjMweASn8xTz5SHHGwZrg==
X-Google-Smtp-Source: ABdhPJzG+iibL1c6LMDf6p5/bXLgME7e8UIfVaFqoe2uaYYoQijwStSXrMr/9GK9oi5BJG/YmvvNLQ==
X-Received: by 2002:a63:5f44:: with SMTP id t65mr169753pgb.321.1613670138321;
        Thu, 18 Feb 2021 09:42:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
        by smtp.gmail.com with ESMTPSA id ke13sm6008339pjb.44.2021.02.18.09.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 09:42:17 -0800 (PST)
Date:   Thu, 18 Feb 2021 09:42:11 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jroedel@suse.de,
        mlevitsk@redhat.com
Subject: Re: [PATCH] KVM: nSVM: prepare guest save area while is_guest_mode
 is true
Message-ID: <YC6m8xoRUDtn3V+y@google.com>
References: <20210218162831.1407616-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218162831.1407616-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021, Paolo Bonzini wrote:
> Right now, enter_svm_guest_mode is calling nested_prepare_vmcb_save and
> nested_prepare_vmcb_control.  This results in is_guest_mode being false
> until the end of nested_prepare_vmcb_control.
> 
> This is a problem because nested_prepare_vmcb_save can in turn cause
> changes to the intercepts and these have to be applied to the "host VMCB"
> (stored in svm->nested.hsave) and then merged with the VMCB12 intercepts
> into svm->vmcb.
> 
> In particular, without this change we forget to set the CR0 read and CR0
> write intercepts when running a real mode L2 guest with NPT disabled.
> The guest is therefore able to see the CR0.PG bit that KVM sets to
> enable "paged real mode".  This patch fixes the svm.flat mode_switch
> test case with npt=0.  There are no other problematic calls in
> nested_prepare_vmcb_save.

It might be worth explicitly pointing out that get_host_vmcb() in
svm_clr_intercept() and svm_set_intercept() will grab the wrong VMCB.
 
> The bug is present since commit 06fc7772690d ("KVM: SVM: Activate nested
> state only when guest state is complete", 2010-04-25).  Unfortunately,
> it is not clear from the commit message what issue exactly led to the
> change back then.  It was probably related to svm_set_cr0 however because
> the patch series cover letter[1] mentioned lazy FPU switching.

Aha!  It was indeed related to svm_set_cr0().  Specifically, the next patch,
commit 66a562f7e257 ("KVM: SVM: Make lazy FPU switching work with nested svm"),
added is_nested() checks in update_cr0_intercept() to merge L1's intercepts with
L0's intercepts.

I dug through all other is_nested() usage, none of them were reachable via the
world switch logic.

> [1] https://lore.kernel.org/kvm/1266493115-28386-1-git-send-email-joerg.roedel@amd.com/
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---
>  arch/x86/kvm/svm/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 92d3aaaac612..35891d9a1099 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -469,8 +469,8 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
>  
>  	svm->nested.vmcb12_gpa = vmcb12_gpa;
>  	load_nested_vmcb_control(svm, &vmcb12->control);
> -	nested_prepare_vmcb_save(svm, vmcb12);
>  	nested_prepare_vmcb_control(svm);
> +	nested_prepare_vmcb_save(svm, vmcb12);
>  
>  	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
>  				  nested_npt_enabled(svm));
> -- 
> 2.26.2
> 
