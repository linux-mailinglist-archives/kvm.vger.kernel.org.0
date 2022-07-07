Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA50956A030
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 12:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiGGKlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 06:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiGGKle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 06:41:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABB664F673
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 03:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657190490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pwcg7T0JuistTDUMjOvWrknPf1gKH9MIp+DFOaxmRLk=;
        b=fuEJw9ZUNg++bNFtkFC9byvxVKJ6yTXhgMsCSuFedlwBv1V6aeUQR/QnZ5PuvCdl5abyeH
        7iQ0iSIojp6Rxc0amaXsctVpDqGpiUFHxTvrJf0yzWyht9hCI+o9kOfbc5d16KpCFDOYzh
        gHQRL7w73huf8Fw7s36uOTJNTBFjMCM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-6cdB2VQBObSXu7SkjX9V9Q-1; Thu, 07 Jul 2022 06:41:29 -0400
X-MC-Unique: 6cdB2VQBObSXu7SkjX9V9Q-1
Received: by mail-wm1-f69.google.com with SMTP id z11-20020a05600c0a0b00b003a043991610so9378008wmp.8
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 03:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Pwcg7T0JuistTDUMjOvWrknPf1gKH9MIp+DFOaxmRLk=;
        b=NJxmSPJd1rlduRDOclOMCY0dH3x48A2xATHzv05SptCVBEMSAzGes0+Al3YDid7iYY
         tzUF/oUhSMOliEhteIv19ZAsp00Pix5KE/jjezT6uv7IWEsUsUmS4KwoNbfkIlZtmrgP
         uf+RPVfbBUKummk+oVm/hjOo9aCvGk4z57MQhfUUis4hi2tJdGxKrLzDCKAKPK04rFsw
         OYsfVfg6/mFFP+N4GSTG9pTbzBG2Fa2IO8pNHzikxvh8asVtPTsrBNknPsIwqMTRCIIH
         Z4sWLH0Ll6mS4dX5cFeIQnx83RC5wISCu7QvshNVTu5VxSMS68kv/NuO8ejqlVQ4dfJf
         IxaA==
X-Gm-Message-State: AJIora+9IAwQMWydSapu9/hy7aonnGybMxAtowkcX9UXHgc02Lz8f2gd
        QDwG4qy2nCSJZ91CtU4nIxm7TOMBtOE/+43A/Evj9TeY5FtjHfRIyt5brrAzwrQ/RXGq5Wfjqkf
        3QKOxaYmZd+ku
X-Received: by 2002:a05:6000:1449:b0:21b:b171:5eb8 with SMTP id v9-20020a056000144900b0021bb1715eb8mr42593889wrx.634.1657190488442;
        Thu, 07 Jul 2022 03:41:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1umfdWDsVBEWSxSBLaDDZ9YXVnNYpWt9Xos/OmPvPmnoyKP3JJo7OU6aWB2hLTWYc0keDEnWg==
X-Received: by 2002:a05:6000:1449:b0:21b:b171:5eb8 with SMTP id v9-20020a056000144900b0021bb1715eb8mr42593876wrx.634.1657190488245;
        Thu, 07 Jul 2022 03:41:28 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n35-20020a05600c3ba300b003a039054567sm28432130wms.18.2022.07.07.03.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 03:41:27 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 20/28] KVM: VMX: Add missing VMENTRY controls to
 vmcs_config
In-Reply-To: <CALMp9eTVAOCvWQ-3A6VmwhJk6skES9phMPC3O-za7Rk05SfVTg@mail.gmail.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-21-vkuznets@redhat.com>
 <CALMp9eTVAOCvWQ-3A6VmwhJk6skES9phMPC3O-za7Rk05SfVTg@mail.gmail.com>
Date:   Thu, 07 Jul 2022 12:41:26 +0200
Message-ID: <87fsjdqk6h.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> As a preparation to reusing the result of setup_vmcs_config() in
>> nested VMX MSR setup, add the VMENTRY controls which KVM doesn't
>> use but supports for nVMX to KVM_OPT_VMX_VM_ENTRY_CONTROLS and
>> filter them out in vmx_vmentry_ctrl().
>>
>> No functional change intended.
>>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 3 +++
>>  arch/x86/kvm/vmx/vmx.h | 4 +++-
>>  2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index e5ab77ed37e4..b774b6391e0e 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4179,6 +4179,9 @@ static u32 vmx_vmentry_ctrl(void)
>>  {
>>         u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
>>
>> +       /* Not used by KVM but supported for nesting. */
>> +       vmentry_ctrl &= ~(VM_ENTRY_SMM | VM_ENTRY_DEACT_DUAL_MONITOR);
>> +
>
> LOL! KVM does not emulate the dual-monitor treatment of SMIs and SMM.
> Do we actually claim to support these VM-entry controls today?!?
>

No, just a brainfart on my side, nested_vmx_setup_ctls_msrs() filters
them out too. I'll drop the patch.

>>         if (vmx_pt_mode_is_system())
>>                 vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
>>                                   VM_ENTRY_LOAD_IA32_RTIT_CTL);
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index d4503a38735b..7ada8410a037 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -479,7 +479,9 @@ static inline u8 vmx_get_rvi(void)
>>                 __KVM_REQ_VMX_VM_ENTRY_CONTROLS
>>  #endif
>>  #define KVM_OPT_VMX_VM_ENTRY_CONTROLS                          \
>> -       (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |                  \
>> +       (VM_ENTRY_SMM |                                         \
>> +       VM_ENTRY_DEACT_DUAL_MONITOR |                           \
>> +       VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |                   \
>>         VM_ENTRY_LOAD_IA32_PAT |                                \
>>         VM_ENTRY_LOAD_IA32_EFER |                               \
>>         VM_ENTRY_LOAD_BNDCFGS |                                 \
>> --
>> 2.35.3
>>
>

-- 
Vitaly

