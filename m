Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B61F262A71
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgIIIgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:36:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbgIIIgB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Sep 2020 04:36:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599640559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BxG3m4nR+YU53uab+z7iQIRwHNJ3l863/1VrYJ0fNCg=;
        b=FT7fnmjvLvXlwI8zFI/tWp5WiHR88psNAMpLsPLvVX6c6yDWPpYc+6KT2XQ/5EN+s/PA9/
        dVGr0APIr65YrkxYnwuLdinD3QDMLUm8Q5SDSAlQYPjc+kNQ07EyOZ39YxmN/zcsbGS6+5
        9IOaNfhOfoOAN+SmxuqOpou3LZ1UiIQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-l4z03Bi6MkWa0yKC-2_ERw-1; Wed, 09 Sep 2020 04:35:58 -0400
X-MC-Unique: l4z03Bi6MkWa0yKC-2_ERw-1
Received: by mail-wm1-f69.google.com with SMTP id a144so563236wme.9
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 01:35:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BxG3m4nR+YU53uab+z7iQIRwHNJ3l863/1VrYJ0fNCg=;
        b=COOXJP6pC5z6pDMTXPtFn8V4hVp64bFt9crnv3DBTM0u82HrmGvX4LnKfpKsv2seSR
         1Rn3YokUZUsb4CGF4ZezNwS4uqDx2Z4aftxQk9yETRcJExG2gHUytZquLzcTdI+DWHm7
         WouEpNjewgtW2l2WYlcAO6cPdz9Jr+uUmgGP9cfgOXDCBMj3o0GbVD/Rom8GOSh8aQ/z
         mHKUJUv4Oq5VjGd9/NkjPcl0gjhdbVpH2LOttdeem31HmQ34yRFujOtNTbXJnZ7sickI
         yDLy9GkAkvJMG7FgXNK95UjNhb7bGRbPN1WFJLnHw3CiGRgbgPHDyBPNFfw6uvVlHi2p
         rKTg==
X-Gm-Message-State: AOAM5325G5dfimYpQpeABrxFmJYiVt2WRPY7NPzaId28hXJa4tdQzax2
        Hgm9AG94TJlKeEpFKZhQ2YPTfW/BTMtQKk+8iuwP2pZUhhXEllTzT4SoYSU26SxppR5JZpJKIB2
        NSSYQxjm1cpRr
X-Received: by 2002:a1c:bad5:: with SMTP id k204mr2518604wmf.111.1599640557059;
        Wed, 09 Sep 2020 01:35:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxU4GkzkooxdDUYfIcFo7UAIjKzbfraZwoqESsmxrN7yZFaybBNzbJ/XdCEGBZ7NL9hhZaeGw==
X-Received: by 2002:a1c:bad5:: with SMTP id k204mr2518578wmf.111.1599640556820;
        Wed, 09 Sep 2020 01:35:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a15sm3372141wrn.3.2020.09.09.01.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:35:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
Subject: Re: [PATCH 2/3] KVM: SVM: Move svm_complete_interrupts() into svm_vcpu_run()
In-Reply-To: <1599620119-12971-1-git-send-email-wanpengli@tencent.com>
References: <1599620119-12971-1-git-send-email-wanpengli@tencent.com>
Date:   Wed, 09 Sep 2020 10:35:55 +0200
Message-ID: <87eenbmjo4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Moving svm_complete_interrupts() into svm_vcpu_run() which can align VMX 
> and SVM with respect to completing interrupts.
>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/svm/svm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c61bc3b..74bcf0a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2938,8 +2938,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	if (npt_enabled)
>  		vcpu->arch.cr3 = svm->vmcb->save.cr3;
>  
> -	svm_complete_interrupts(svm);
> -
>  	if (is_guest_mode(vcpu)) {
>  		int vmexit;
>  
> @@ -3530,6 +3528,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
>  		svm_handle_mce(svm);
>  
> +	svm_complete_interrupts(svm);
> +
>  	vmcb_mark_all_clean(svm->vmcb);
>  	return exit_fastpath;
>  }

This seems to be the right thing to do, however, the amount of code
between kvm_x86_ops.run() and kvm_x86_ops.handle_exit() is non-trivial,
hope it won't blow up in testing...

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

One more thing:

VMX version does

        vmx_complete_interrupts(vmx);
        if (is_guest_mode(vcpu))
                return EXIT_FASTPATH_NONE;

and on SVM we analyze is_guest_mode() inside
svm_exit_handlers_fastpath() - should we also change that for
conformity?

-- 
Vitaly

