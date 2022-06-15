Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2521854C784
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 13:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347875AbiFOLbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 07:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347683AbiFOLbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 07:31:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32D9052E42
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 04:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655292657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=deu1fZ+rJg4vtIyzufwUH9tCrx+7IF3P/lvcMVMcMto=;
        b=jOY+f9s5ny1+xF2LOeakdX57gA4kAOsuwKJlideOsv398UA6ruA9Va3a4K34d5B5XbanEo
        6WfmCAFx1vMNlBLI5f0F6SDM7bJV2E4z2uqfAXDqO86LMHPmAK8c+xqldJc7TqBctjeVPJ
        +5kOkWNAGb13DBbPLWPWyHYOSyx1rrI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-L80_tF_4PVSVjKX4__ZRFg-1; Wed, 15 Jun 2022 07:30:56 -0400
X-MC-Unique: L80_tF_4PVSVjKX4__ZRFg-1
Received: by mail-wm1-f69.google.com with SMTP id m22-20020a7bcb96000000b0039c4f6ade4dso4962961wmi.8
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 04:30:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=deu1fZ+rJg4vtIyzufwUH9tCrx+7IF3P/lvcMVMcMto=;
        b=u3JYp7Q4yOHgbINl542YYKITr/8QxSzKhtFlBTYVXmCqOQqnU2TeTtHKscFPumKEQH
         Wy/gCDcKp6yW3Pn1VwfEIFou4VH4bopF92lWSlHCPIoTP4dMO4CDTw5fmRk5PAVdXRV+
         QoC/Svyn0oBAiKE8L5DMlZwWn/jHWx86Jkn7buHI0z8PV7pGLV3hGS9dXEHzUjLbUdYl
         gpokac/bxQ00hh3/AetzrEIxxcQfz+rCcDId7L+sBRBPwqv7GgoWVB0T6UgZSwf/WivM
         HAb9Na8Scm75sq8VFDT2dXuRO3lL2kEHjCEvdKJ/I4h5fSm6B0Hegl5ZG+GoOFR1k+ea
         d3ZA==
X-Gm-Message-State: AJIora/tlc9T90bOjQCiNOyNCK3q0iZPpl34ugrxh/5L6+H1h6NNK/9t
        JpSBuhI6FgWcDb/mb+4dLd8X++XRXv01MOhPpmqiwMrA8c0bJtpdlC/8lI17qsxfpwqDHwBWorz
        63OerdnJi1cLq
X-Received: by 2002:a05:6000:1808:b0:21a:1322:cd9b with SMTP id m8-20020a056000180800b0021a1322cd9bmr9793144wrh.164.1655292655040;
        Wed, 15 Jun 2022 04:30:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v6ZjaAdpwX7tIwW3bDni1DiejlVqSRKsvOo3OuGN1wsYo5tjNHWI+jwvqWm6RPrB9yjf7DNQ==
X-Received: by 2002:a05:6000:1808:b0:21a:1322:cd9b with SMTP id m8-20020a056000180800b0021a1322cd9bmr9793119wrh.164.1655292654831;
        Wed, 15 Jun 2022 04:30:54 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q17-20020adffed1000000b00219f9829b71sm12682321wrs.56.2022.06.15.04.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 04:30:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     mail@anirudhrb.com, kumarpraveen@linux.microsoft.com,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        wei.liu@kernel.org, robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
In-Reply-To: <87pmjbi90m.fsf@redhat.com>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <87sfo7igis.fsf@redhat.com> <87pmjbi90m.fsf@redhat.com>
Date:   Wed, 15 Jun 2022 13:30:53 +0200
Message-ID: <87ilp2i2oi.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>
>> Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:
>>
>> ...
>>
>>>
>>> As per the comments in arch/x86/kvm/vmx/evmcs.h, TSC multiplier field is
>>> currently not supported in EVMCS.
>>
>> The latest version:
>> https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_vmx_enlightened_vmcs
>>
>> has it, actually. It was missing before (compare with e.g. 6.0b version
>> here:
>> https://github.com/MicrosoftDocs/Virtualization-Documentation/raw/live/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v6.0b.pdf)
>>
>> but AFAIR TSC scaling wasn't advertised by genuine Hyper-V either.
>> Interestingly enough, eVMCS version didn't change when these fields were
>> added, it is still '1'.
>>
>> I even have a patch in my stash (attached). I didn't send it out because
>> it wasn't properly tested with different Hyper-V versions.
>
> And of course I forgot a pre-requisite patch which updates 'struct
> hv_enlightened_vmcs' to the latest:
>

The good news is that TscMultiplies seems to work fine for me, at least
with an Azure Dv5 instance where I can see Tsc scaling exposed. The bad
news is that a few more patches are needed:

1) Fix 'struct hv_enlightened_vmcs' definition:
https://lore.kernel.org/kvm/20220613133922.2875594-20-vkuznets@redhat.com/

2) Define VMCS-to-EVMCS conversion for the new fields :

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 6a61b1ae7942..707a8de11802 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -28,6 +28,8 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
                     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
        EVMCS1_FIELD(HOST_IA32_EFER, host_ia32_efer,
                     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
+       EVMCS1_FIELD(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl,
+                    HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
        EVMCS1_FIELD(HOST_CR0, host_cr0,
                     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
        EVMCS1_FIELD(HOST_CR3, host_cr3,
@@ -78,6 +80,8 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
                     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
        EVMCS1_FIELD(GUEST_IA32_EFER, guest_ia32_efer,
                     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
+       EVMCS1_FIELD(GUEST_IA32_PERF_GLOBAL_CTRL, guest_ia32_perf_global_ctrl,
+                    HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
        EVMCS1_FIELD(GUEST_PDPTR0, guest_pdptr0,
                     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
        EVMCS1_FIELD(GUEST_PDPTR1, guest_pdptr1,
@@ -126,24 +130,47 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
                     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
        EVMCS1_FIELD(XSS_EXIT_BITMAP, xss_exit_bitmap,
                     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
+       EVMCS1_FIELD(ENCLS_EXITING_BITMAP, encls_exiting_bitmap,
+                    HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
+       EVMCS1_FIELD(TSC_MULTIPLIER, tsc_multiplier,
+                    HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),

...

so it is becoming more and more complicated to assemble for testing. Let
me finish my testing and I'll put a series together and send it out to
simplify the process. Stay tuned!

-- 
Vitaly

