Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BF7C1C1D
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 09:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbfI3He2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 03:34:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfI3He1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 03:34:27 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D370358E23
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 07:34:26 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id z205so5543220wmb.7
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 00:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2LyfeVR/pGPcAByVed65sXmuSd2eGSszSs4jdLRbVhI=;
        b=oW2mEHhRT1GQy2yUcn3TwMtuN1y+RLR1hagq4Z3Ul07V4C5WOY6r7jOMgmY1Zoa53s
         TBsw5o79ToWd2fxAFDI2AvaRMrYRYTrcbSrrJKiK3rlH0DA3mAjCX10CYj0VDg2VALV4
         vQGb52q6Mwg40FbUfXPTqoxLU+D0QSJM2qf4HYevnRaMdWAvy5Vuy29yMNpzDQOtuJR1
         EWNqC7CDO8NSVRX4xL0FikrnfLWVbF48bfk9967uEDMqfaJa/8182ZguzhHWYNrQqixB
         ESTU26VW//cjAbLTHaYZQxEeQcxQJ9mNHtcw1gaAkh2vHwM3ilX20XD2WMF6l/YJpqtJ
         CYgA==
X-Gm-Message-State: APjAAAWJvk+bs8VSifcs5uaZqs79OxooQqlWgFRnRHDlI09VU2xXXGL7
        vM9mnv2O1r6i2qJaf6NzQp+jx/uVQ+MWhQ1XstlX7+Ne/DuyPH0/x0M10OT4Pv+VwNReBGqJQuV
        oRk72TbLDoD7M
X-Received: by 2002:a5d:6812:: with SMTP id w18mr11635806wru.250.1569828865397;
        Mon, 30 Sep 2019 00:34:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzb3uPpbBSJw6hAuajHP156i0SSqaOvFtMA2qFztrlhviHziIM8b9Qevwekpf8+GL/0dzefog==
X-Received: by 2002:a5d:6812:: with SMTP id w18mr11635789wru.250.1569828865150;
        Mon, 30 Sep 2019 00:34:25 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g1sm9934934wrv.68.2019.09.30.00.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 00:34:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     tao3.xu@intel.com, sean.j.christopherson@intel.com,
        jmattson@google.com, Liran Alon <liran.alon@oracle.com>,
        pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Remove proprietary handling of unexpected exit-reasons
In-Reply-To: <20190929145018.120753-1-liran.alon@oracle.com>
References: <20190929145018.120753-1-liran.alon@oracle.com>
Date:   Mon, 30 Sep 2019 09:34:23 +0200
Message-ID: <874l0u5jb4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

> Commit bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit
> and handle WAITPKG vmexit") introduced proprietary handling of
> specific exit-reasons that should not be raised by CPU because
> KVM configures VMCS such that they should never be raised.
>
> However, since commit 7396d337cfad ("KVM: x86: Return to userspace
> with internal error on unexpected exit reason"), VMX & SVM
> exit handlers were modified to generically handle all unexpected
> exit-reasons by returning to userspace with internal error.
>
> Therefore, there is no need for proprietary handling of specific
> unexpected exit-reasons (This proprietary handling also introduced
> inconsistency for these exit-reasons to silently skip guest instruction
> instead of return to userspace on internal-error).
>
> Fixes: bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit")
>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>

(It's been awhile since in software world the word 'proprietary' became
an opposite of free/open-source to me so I have to admit your subject
line really got me interested :-)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>  arch/x86/kvm/vmx/vmx.c | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d4575ffb3cec..e31317fc8c95 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5538,14 +5538,6 @@ static int handle_encls(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> -static int handle_unexpected_vmexit(struct kvm_vcpu *vcpu)
> -{
> -	kvm_skip_emulated_instruction(vcpu);
> -	WARN_ONCE(1, "Unexpected VM-Exit Reason = 0x%x",
> -		vmcs_read32(VM_EXIT_REASON));
> -	return 1;
> -}
> -
>  /*
>   * The exit handlers return 1 if the exit was handled fully and guest execution
>   * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
> @@ -5597,15 +5589,11 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
>  	[EXIT_REASON_RDRAND]                  = handle_invalid_op,
>  	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
> -	[EXIT_REASON_XSAVES]                  = handle_unexpected_vmexit,
> -	[EXIT_REASON_XRSTORS]                 = handle_unexpected_vmexit,
>  	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
>  	[EXIT_REASON_INVPCID]                 = handle_invpcid,
>  	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
>  	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>  	[EXIT_REASON_ENCLS]		      = handle_encls,
> -	[EXIT_REASON_UMWAIT]                  = handle_unexpected_vmexit,
> -	[EXIT_REASON_TPAUSE]                  = handle_unexpected_vmexit,
>  };
>  
>  static const int kvm_vmx_max_exit_handlers =

-- 
Vitaly
