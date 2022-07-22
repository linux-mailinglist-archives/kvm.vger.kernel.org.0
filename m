Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F2457E68E
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 20:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbiGVSdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 14:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiGVSdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 14:33:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25FB81485
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 11:33:32 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id go3so5107708pjb.0
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 11:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=noDnWIH945nYgd1IiYOQ6TJtVYekdnDkLQnIipIagMU=;
        b=jVhPFnyqezO242A9rU/EcxTdX+FAeH8OuE27PfesXzWSky/o9OqxHPqlu1jhIBcG4P
         HuuyY/2BeItQYXyjdqD7rR6I5JHv4PwObRmJWn79HVdTtrcwBLu77JGwYaACBaQcrsdg
         UPeXEH78SV/8c3jWgOPSA3AN/lgMcxqvF9jKDxThSjGnA7V1L24uCn+o69bbHkWmHsSa
         xHxyuM3ERDTjMx+OQS7OtvXOull1CofacQb+GU/KQxMSDg0O7DPyQ0bNdg9uO4x9buBs
         CF/6HZKBv4nUA0bVUdy72SuU1jGygvLJfnXsDPF/BJE00VFB0x90dpa8q2rfignc1e9z
         PsHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=noDnWIH945nYgd1IiYOQ6TJtVYekdnDkLQnIipIagMU=;
        b=bIm0K/N4ycCf6wmlEuskfl3MyUGYzQr6jpL39lRsDipQAc09DhyRtu67JtPC2iTuqy
         Vi8JHcZSYG/1bvHGifch3sTEKZ2kI44OzJBO+gqwXYP816PycS2MTXKYmSrKtUWVi7Wu
         WBCQ2ZzwuJ6F8ILv8OltidWh8Ah5TKNE87ng48hmpOBrAgLCwO3llJZuv9w7ejG4ZQrL
         f3dI4MO+6QZQMHY2+KvqHdDnvYaGUGZHRB8L0i6oi1xaTXUFq/zrkVd/IJeKAdk6fQaD
         GRI/xPONkMuondBJ5kImjfRDdQ7tXUmIgc4wIx048k3TZ1FQ6zztdj0118v6VgCg/m1U
         estg==
X-Gm-Message-State: AJIora84UTELMjE0cskY7EdzElkyEkgosd0k1AmacsXkCBFFrE9xGbTM
        7xEQrrwYIoWPRFl5xkUEDN04/Q==
X-Google-Smtp-Source: AGRyM1vooHqa5wrwrNbFSpSF2H5z7YmhDdBJN9zSZYd034/OZ1dr/E7PbcgBA1tQXU9huTb7+YBNZA==
X-Received: by 2002:a17:90b:4f41:b0:1f0:4785:b9a8 with SMTP id pj1-20020a17090b4f4100b001f04785b9a8mr18151723pjb.224.1658514812148;
        Fri, 22 Jul 2022 11:33:32 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a16-20020aa78e90000000b0052b29fd7982sm4202604pfr.85.2022.07.22.11.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 11:33:31 -0700 (PDT)
Date:   Fri, 22 Jul 2022 18:33:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/25] KVM: VMX: Extend VMX controls macro shenanigans
Message-ID: <YtrtdylmyolAHToz@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-16-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714091327.1085353-16-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 286c88e285ea..89eaab3495a6 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -467,6 +467,113 @@ static inline u8 vmx_get_rvi(void)
>  	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
>  }
>  
> +#define __KVM_REQ_VMX_VM_ENTRY_CONTROLS				\
> +	(VM_ENTRY_LOAD_DEBUG_CONTROLS)
> +#ifdef CONFIG_X86_64
> +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> +		(__KVM_REQ_VMX_VM_ENTRY_CONTROLS |		\
> +		VM_ENTRY_IA32E_MODE)

This breaks 32-bit builds, but at least we know the assert works!

vmx_set_efer() toggles VM_ENTRY_IA32E_MODE without a CONFIG_X86_64 guard.  That
should be easy enough to fix since KVM should never allow EFER_LMA.  Compile 
tested patch at the bottom.

More problematic is that clang-13 doesn't like the new asserts, and even worse gives
a very cryptic error.  I don't have bandwidth to look into this at the moment, and
probably won't next week either.

ERROR: modpost: "__compiletime_assert_533" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "__compiletime_assert_531" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "__compiletime_assert_532" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "__compiletime_assert_530" [arch/x86/kvm/kvm-intel.ko] undefined!
make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
make[1]: *** [Makefile:1753: modules] Error 2
make[1]: *** Waiting for unfinished jobs....


> +#else
> +	#define KVM_REQ_VMX_VM_ENTRY_CONTROLS			\
> +		__KVM_REQ_VMX_VM_ENTRY_CONTROLS
> +#endif

EFER.LMA patch, compile tested only.

---
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 22 Jul 2022 18:26:21 +0000
Subject: [PATCH] KVM: VMX: Don't toggle VM_ENTRY_IA32E_MODE for 32-bit
 kernels/KVM

Don't toggle VM_ENTRY_IA32E_MODE in 32-bit kernels/KVM and instead bug
the VM if KVM attempts to run the guest with EFER.LMA=1.  KVM doesn't
support running 64-bit guests with 32-bit hosts.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bff97babf381..8623607e596d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2894,10 +2894,15 @@ int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		return 0;

 	vcpu->arch.efer = efer;
+#ifdef CONFIG_X86_64
 	if (efer & EFER_LMA)
 		vm_entry_controls_setbit(vmx, VM_ENTRY_IA32E_MODE);
 	else
 		vm_entry_controls_clearbit(vmx, VM_ENTRY_IA32E_MODE);
+#else
+	if (KVM_BUG_ON(efer & EFER_LMA, vcpu->kvm))
+		return 1;
+#endif

 	vmx_setup_uret_msrs(vmx);
 	return 0;

base-commit: e22e2665637151a321433b2bb705f5c3b8da40bc
--

