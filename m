Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA58561F0D
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 17:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiF3PTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 11:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbiF3PTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 11:19:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2A8A37AA3
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 08:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656602375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YuBa4kskIVPuEkGmG7+439Fcn87oYLE8R41NL6X8Zug=;
        b=BkPU+TqTptcNR2celvrqkKyNtAi/RpQcfyfL8wCX6m+rhOdmfyjBSiMKlhUOeQhgO5e/M6
        qu3rB1cZsNFNY+O0k0nGrpGjkaP6NG1C35yA7LJUpS0KzvSFBa4I+eE9KpkM1eHR4xC/Ks
        BoBviTbNNVSZAlValuhoqrk0h1/pnpg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-FIY5tUw0NQOQ2DRg4Xx8pw-1; Thu, 30 Jun 2022 11:19:33 -0400
X-MC-Unique: FIY5tUw0NQOQ2DRg4Xx8pw-1
Received: by mail-ed1-f72.google.com with SMTP id w22-20020a05640234d600b00435ba41dbaaso14557687edc.12
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 08:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YuBa4kskIVPuEkGmG7+439Fcn87oYLE8R41NL6X8Zug=;
        b=OTBbcYrwRhhTj7LSpZ4Ylx0UR1w/74l8Dkvb2TOOkwgfV0/FPybDxQeukzqoFmA67C
         j9JibyzBu37oo7gFKiCspPdb6Y1oVni8Ipugv0y30PY/6fCJOhYKuPLNUhLX2ERoy1rx
         J5sqvQQbTE5Rbt9fNm1hur2z4TakJ1K/rhwIeLcT8ruJfcSX7tKwn6nJc9TfvFkzZDzk
         PpNkMddpOGib02Sy67fV7BWzlR5dLN/aRBstVYoG2lslawpa/5n7LhQNb9Aq/8SDe8J6
         poosz9fxnr+2sikONV3Qam4aBwsf+zotlnB1hPI8UI5gna2WOqMOmmOSIyDiK2bxAcPr
         GGdw==
X-Gm-Message-State: AJIora+GqCjdqI8uBxs3AMQDHLOdAIZX/ZtJy21XKokLs1eP8PGgxABA
        zhh/r9I8orXs1S3yTVGyqX1DpbWJbMySiYt0YWWabsVXBnyXj68GyGNjCi+jmLwc9CbAV2DFnSN
        ZF6mcUOPvzFGX
X-Received: by 2002:a17:907:d90:b0:726:42bb:c8a0 with SMTP id go16-20020a1709070d9000b0072642bbc8a0mr8805338ejc.575.1656602372221;
        Thu, 30 Jun 2022 08:19:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v7AltquG+2YtPTq20ATbXx+G+hbUSpjeyVaIJS09P+cEaz65cuVlBl1UKp7ee5MwsTVzbOHw==
X-Received: by 2002:a17:907:d90:b0:726:42bb:c8a0 with SMTP id go16-20020a1709070d9000b0072642bbc8a0mr8805315ejc.575.1656602371936;
        Thu, 30 Jun 2022 08:19:31 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cb25-20020a0564020b7900b004359dafe822sm13358720edb.29.2022.06.30.08.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 08:19:31 -0700 (PDT)
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
In-Reply-To: <87bkudugri.fsf@redhat.com>
References: <20220628103241.1785380-1-anrayabh@linux.microsoft.com>
 <87bkudugri.fsf@redhat.com>
Date:   Thu, 30 Jun 2022 17:19:30 +0200
Message-ID: <87h742rxfh.fsf@redhat.com>
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

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:
>
>> When running cloud-hypervisor tests, VM entry into an L2 guest on KVM on
>> Hyper-V fails with this splat (stripped for brevity):
>>
>> [ 1481.600386] WARNING: CPU: 4 PID: 7641 at arch/x86/kvm/vmx/nested.c:4563 nested_vmx_vmexit+0x70d/0x790 [kvm_intel]
>> [ 1481.600427] CPU: 4 PID: 7641 Comm: vcpu2 Not tainted 5.15.0-1008-azure #9-Ubuntu
>> [ 1481.600429] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 07/22/2021
>> [ 1481.600430] RIP: 0010:nested_vmx_vmexit+0x70d/0x790 [kvm_intel]
>> [ 1481.600447] Call Trace:
>> [ 1481.600449]  <TASK>
>> [ 1481.600451]  nested_vmx_reflect_vmexit+0x10b/0x440 [kvm_intel]
>> [ 1481.600457]  __vmx_handle_exit+0xef/0x670 [kvm_intel]
>> [ 1481.600467]  vmx_handle_exit+0x12/0x50 [kvm_intel]
>> [ 1481.600472]  vcpu_enter_guest+0x83a/0xfd0 [kvm]
>> [ 1481.600524]  vcpu_run+0x5e/0x240 [kvm]
>> [ 1481.600560]  kvm_arch_vcpu_ioctl_run+0xd7/0x550 [kvm]
>> [ 1481.600597]  kvm_vcpu_ioctl+0x29a/0x6d0 [kvm]
>> [ 1481.600634]  __x64_sys_ioctl+0x91/0xc0
>> [ 1481.600637]  do_syscall_64+0x5c/0xc0
>> [ 1481.600667]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [ 1481.600670] RIP: 0033:0x7f688becdaff
>> [ 1481.600686]  </TASK>
>>
>> TSC multiplier field is currently not supported in EVMCS in KVM. It was
>> previously not supported from Hyper-V but has been added since. Because
>> it is not supported in KVM the use "TSC scaling control" is filtered out
>> of vmcs_config by evmcs_sanitize_exec_ctrls().
>>
>> However, in nested_vmx_setup_ctls_msrs(), TSC scaling is exposed to L1.
>> eVMCS unsupported fields are not sanitized. When L1 tries to launch an L2
>> guest, vmcs12 has TSC scaling enabled. This propagates to vmcs02. But KVM
>> doesn't set the TSC multiplier value because kvm_has_tsc_control is false.
>> Due to this VM entry for L2 guest fails. (VM entry fails if
>> "use TSC scaling" is 1 but TSC multiplier is 0.)
>>
>> To fix, in nested_vmx_setup_ctls_msrs(), sanitize the values read from MSRs
>> by filtering out fields that are not supported by eVMCS.
>>
>> This is a stable-friendly intermediate fix. A more comprehensive fix is
>> in progress [1] but is probably too complicated to safely apply to
>> stable.
>>
>> [1]: https://lore.kernel.org/kvm/20220627160440.31857-1-vkuznets@redhat.com/
>>
>> Fixes: d041b5ea93352 ("KVM: nVMX: Enable nested TSC scaling")
>> Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
>> ---
>>
>> Changes since v1:
>> - Sanitize all eVMCS unsupported fields instead of just TSC scaling.
>>
>> v1: https://lore.kernel.org/lkml/20220613161611.3567556-1-anrayabh@linux.microsoft.com/
>>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index f5cb18e00e78..f88d748c7cc6 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -6564,6 +6564,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>  		msrs->pinbased_ctls_high);
>>  	msrs->pinbased_ctls_low |=
>>  		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +	if (static_branch_unlikely(&enable_evmcs))
>> +		msrs->pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
>> +#endif
>>  	msrs->pinbased_ctls_high &=
>>  		PIN_BASED_EXT_INTR_MASK |
>>  		PIN_BASED_NMI_EXITING |
>> @@ -6580,6 +6584,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>  	msrs->exit_ctls_low =
>>  		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
>>  
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +	if (static_branch_unlikely(&enable_evmcs))
>> +		msrs->exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
>> +#endif
>>  	msrs->exit_ctls_high &=
>>  #ifdef CONFIG_X86_64
>>  		VM_EXIT_HOST_ADDR_SPACE_SIZE |
>> @@ -6600,6 +6608,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>  		msrs->entry_ctls_high);
>>  	msrs->entry_ctls_low =
>>  		VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +	if (static_branch_unlikely(&enable_evmcs))
>> +		msrs->entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
>> +#endif
>>  	msrs->entry_ctls_high &=
>>  #ifdef CONFIG_X86_64
>>  		VM_ENTRY_IA32E_MODE |
>> @@ -6657,6 +6669,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>  		      msrs->secondary_ctls_high);
>>  
>>  	msrs->secondary_ctls_low = 0;
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +	if (static_branch_unlikely(&enable_evmcs))
>> +		msrs->secondary_ctls_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
>> +#endif
>>  	msrs->secondary_ctls_high &=
>>  		SECONDARY_EXEC_DESC |
>>  		SECONDARY_EXEC_ENABLE_RDTSCP |
>
> (In theory, threre's also EVMCS1_UNSUPPORTED_VMFUNC filtering out
> VMX_VMFUNC_EPTP_SWITCHING (as eVMCS EPTP_LIST_ADDRESS) but it is not
> used by KVM)
>
> As I said in another thread, I think this is fine as a
> stable@/intermediate fix. Assuming the way to go for mainline is my
> "KVM: nVMX: Use vmcs_config for setting up nested VMX MSRs", this patch
> won't be needed and can be reverted.

(I've already said that in another thread, putting it here for
visibility)

I have to take this back. As-is, the patch is likely to break live
migration because of the reasons expressed by Jim:
https://lore.kernel.org/kvm/CALMp9eSBLcvuNDquvSfUnaF3S3f4ZkzqDRSsz-v93ZeX=xnssg@mail.gmail.com/

In case we filter out SECONDARY_EXEC_TSC_SCALING here in
nested_vmx_setup_ctls_msrs(), KVM_SET_MSRS on the destination will fail
because the data will have an unsupported bit.

It seems the easiest way to go for stable@ is to actually enable TSC
scaling, like the 4 patches I've suggested here:
https://lore.kernel.org/kvm/87bkujy4z9.fsf@redhat.com/

The full solution including vmcs_config usage for
nested_vmx_setup_ctls_msrs() is 28 patches now, it's likely a no-go for
stable :-(

-- 
Vitaly

