Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288A255CABD
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345645AbiF1MOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 08:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345638AbiF1MOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 08:14:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 401D22559A
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 05:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656418470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aiFneYnWaLi2y/lwyk0xtCtPW1xJaeDQIG0+th5sfkA=;
        b=EzfzkNeCxhx3y+hSV9A50xU2olr22NGJsH0BWjlkv/n3NegmCpGNqvFJ238HCIj5pzseWk
        6CAIAJ2cvg5Rfwt5rwImNIHrH0b8+7rwcxma9PwwgbPrjKWhMLqFfdlOm6np6/XcsEY2uy
        hH1Gx4LOlvXTwmkVbCLMQaTiJTnOQxI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-ti7Y26ouM3it6nWRBs4DJg-1; Tue, 28 Jun 2022 08:14:29 -0400
X-MC-Unique: ti7Y26ouM3it6nWRBs4DJg-1
Received: by mail-wm1-f70.google.com with SMTP id n15-20020a05600c4f8f00b0039c3e76d646so7018887wmq.7
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 05:14:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aiFneYnWaLi2y/lwyk0xtCtPW1xJaeDQIG0+th5sfkA=;
        b=HmEHkGBaUZ58WTABJoGs9aWeHXmMEn0wVOlX3H7Q8iqauJ3DXDXSULcWnQ2I3Iemfb
         VLj2aD20otEJCRE1B+UlgXF9LMjyvR4bchoP9AC7xFjeEoNNUSGV01j+YTWnxlDjk6Zh
         /ogGENAmRAwj0/0zoG8m6l9nZc6w493XjZKRjh1cC+9sbbb40JcjpySITgmEKw8KNWv2
         mQs3bxrAU1kVFshwU/+NcxHEPKIrJIzejaeiBd3wWGMcjb9uZjNuPRBIuOOZTbOdTqCA
         Lrqup5RyAKfDCZ+81lilt87WvLlQIb3H0JDzenGztBmbO9GVQF8o9HEbr72eOWkqfz9q
         lPNQ==
X-Gm-Message-State: AJIora83d4mvhDrhWt3jmJDlX6nHn7Eg7kXDiMdDeCVouM8qyPNeyTwF
        CN3MGRZ58Bqkz1TAYW9w6Yh8xhMK07xsiEHNIFef6/HgTwKK2SDjC4kcbWPNXT8UlSkBfO/u+wW
        OQDK1szdYRJl0
X-Received: by 2002:a05:600c:19cf:b0:3a0:3df0:867 with SMTP id u15-20020a05600c19cf00b003a03df00867mr21556957wmq.106.1656418468023;
        Tue, 28 Jun 2022 05:14:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tZuVISaBsKDBr4Vr2CI5+w4CnYPLYGgqSJp3ot7IJkUTGZI6jaYqP4Q3Taj+47wuRFF7PdiQ==
X-Received: by 2002:a05:600c:19cf:b0:3a0:3df0:867 with SMTP id u15-20020a05600c19cf00b003a03df00867mr21556924wmq.106.1656418467728;
        Tue, 28 Jun 2022 05:14:27 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w9-20020a5d6089000000b0020e5b4ebaecsm13594634wrt.4.2022.06.28.05.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 05:14:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     mail@anirudhrb.com, kumarpraveen@linux.microsoft.com,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        wei.liu@kernel.org, robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ilias Stamatis <ilstam@amazon.com>
Subject: Re: [PATCH v2] KVM: nVMX: Don't expose eVMCS unsupported fields to L1
In-Reply-To: <20220628103241.1785380-1-anrayabh@linux.microsoft.com>
References: <20220628103241.1785380-1-anrayabh@linux.microsoft.com>
Date:   Tue, 28 Jun 2022 14:14:25 +0200
Message-ID: <87bkudugri.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:

> When running cloud-hypervisor tests, VM entry into an L2 guest on KVM on
> Hyper-V fails with this splat (stripped for brevity):
>
> [ 1481.600386] WARNING: CPU: 4 PID: 7641 at arch/x86/kvm/vmx/nested.c:4563 nested_vmx_vmexit+0x70d/0x790 [kvm_intel]
> [ 1481.600427] CPU: 4 PID: 7641 Comm: vcpu2 Not tainted 5.15.0-1008-azure #9-Ubuntu
> [ 1481.600429] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 07/22/2021
> [ 1481.600430] RIP: 0010:nested_vmx_vmexit+0x70d/0x790 [kvm_intel]
> [ 1481.600447] Call Trace:
> [ 1481.600449]  <TASK>
> [ 1481.600451]  nested_vmx_reflect_vmexit+0x10b/0x440 [kvm_intel]
> [ 1481.600457]  __vmx_handle_exit+0xef/0x670 [kvm_intel]
> [ 1481.600467]  vmx_handle_exit+0x12/0x50 [kvm_intel]
> [ 1481.600472]  vcpu_enter_guest+0x83a/0xfd0 [kvm]
> [ 1481.600524]  vcpu_run+0x5e/0x240 [kvm]
> [ 1481.600560]  kvm_arch_vcpu_ioctl_run+0xd7/0x550 [kvm]
> [ 1481.600597]  kvm_vcpu_ioctl+0x29a/0x6d0 [kvm]
> [ 1481.600634]  __x64_sys_ioctl+0x91/0xc0
> [ 1481.600637]  do_syscall_64+0x5c/0xc0
> [ 1481.600667]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1481.600670] RIP: 0033:0x7f688becdaff
> [ 1481.600686]  </TASK>
>
> TSC multiplier field is currently not supported in EVMCS in KVM. It was
> previously not supported from Hyper-V but has been added since. Because
> it is not supported in KVM the use "TSC scaling control" is filtered out
> of vmcs_config by evmcs_sanitize_exec_ctrls().
>
> However, in nested_vmx_setup_ctls_msrs(), TSC scaling is exposed to L1.
> eVMCS unsupported fields are not sanitized. When L1 tries to launch an L2
> guest, vmcs12 has TSC scaling enabled. This propagates to vmcs02. But KVM
> doesn't set the TSC multiplier value because kvm_has_tsc_control is false.
> Due to this VM entry for L2 guest fails. (VM entry fails if
> "use TSC scaling" is 1 but TSC multiplier is 0.)
>
> To fix, in nested_vmx_setup_ctls_msrs(), sanitize the values read from MSRs
> by filtering out fields that are not supported by eVMCS.
>
> This is a stable-friendly intermediate fix. A more comprehensive fix is
> in progress [1] but is probably too complicated to safely apply to
> stable.
>
> [1]: https://lore.kernel.org/kvm/20220627160440.31857-1-vkuznets@redhat.com/
>
> Fixes: d041b5ea93352 ("KVM: nVMX: Enable nested TSC scaling")
> Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
> ---
>
> Changes since v1:
> - Sanitize all eVMCS unsupported fields instead of just TSC scaling.
>
> v1: https://lore.kernel.org/lkml/20220613161611.3567556-1-anrayabh@linux.microsoft.com/
>
> ---
>  arch/x86/kvm/vmx/nested.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f5cb18e00e78..f88d748c7cc6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6564,6 +6564,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  		msrs->pinbased_ctls_high);
>  	msrs->pinbased_ctls_low |=
>  		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (static_branch_unlikely(&enable_evmcs))
> +		msrs->pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
> +#endif
>  	msrs->pinbased_ctls_high &=
>  		PIN_BASED_EXT_INTR_MASK |
>  		PIN_BASED_NMI_EXITING |
> @@ -6580,6 +6584,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  	msrs->exit_ctls_low =
>  		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (static_branch_unlikely(&enable_evmcs))
> +		msrs->exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> +#endif
>  	msrs->exit_ctls_high &=
>  #ifdef CONFIG_X86_64
>  		VM_EXIT_HOST_ADDR_SPACE_SIZE |
> @@ -6600,6 +6608,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  		msrs->entry_ctls_high);
>  	msrs->entry_ctls_low =
>  		VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (static_branch_unlikely(&enable_evmcs))
> +		msrs->entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> +#endif
>  	msrs->entry_ctls_high &=
>  #ifdef CONFIG_X86_64
>  		VM_ENTRY_IA32E_MODE |
> @@ -6657,6 +6669,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  		      msrs->secondary_ctls_high);
>  
>  	msrs->secondary_ctls_low = 0;
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (static_branch_unlikely(&enable_evmcs))
> +		msrs->secondary_ctls_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
> +#endif
>  	msrs->secondary_ctls_high &=
>  		SECONDARY_EXEC_DESC |
>  		SECONDARY_EXEC_ENABLE_RDTSCP |

(In theory, threre's also EVMCS1_UNSUPPORTED_VMFUNC filtering out
VMX_VMFUNC_EPTP_SWITCHING (as eVMCS EPTP_LIST_ADDRESS) but it is not
used by KVM)

As I said in another thread, I think this is fine as a
stable@/intermediate fix. Assuming the way to go for mainline is my
"KVM: nVMX: Use vmcs_config for setting up nested VMX MSRs", this patch
won't be needed and can be reverted.

-- 
Vitaly

