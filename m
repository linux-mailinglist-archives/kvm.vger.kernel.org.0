Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E5A557907
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 13:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiFWLtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 07:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiFWLtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 07:49:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4930A4CD7C
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 04:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655984975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DGO+ly9oOlaEL89zUxGJxm8XA2hf9aVta/AFY8h752o=;
        b=ak12K0I70wcViTVcYvpj0BEJ6tPTfFnHGePnunhEnEhqoV3+LohGJmKhcL1GuI5Y/jzd7Q
        EyoPHLIQ+fl/IL7iw85G67LimB17yUBetWjpefD2s3v4jQOyqWIoRywfUQNlMQKYzCqwp9
        PW6N2+jh89uqCRdOehAkWIN7c97ARsk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-GxaX_l_pNj6AnAOXIbp6Rw-1; Thu, 23 Jun 2022 07:49:33 -0400
X-MC-Unique: GxaX_l_pNj6AnAOXIbp6Rw-1
Received: by mail-wm1-f70.google.com with SMTP id be12-20020a05600c1e8c00b0039c506b52a4so1602320wmb.1
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 04:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DGO+ly9oOlaEL89zUxGJxm8XA2hf9aVta/AFY8h752o=;
        b=YsoxQRr29WS+h9A03bDiIc4uLrw3OINlbBAGyk74y+0Jkapd1l4nCb2PFUtledi/ek
         2vdcx57S5wRAa6WpxRPggYV2K/G5DX8jMG7RZVlZqGDeKkspLWJ0V+LWyWJrFfTK00/i
         dQYxW0whaC9Mbf0RNXY+lOWvJDPSAGImFC7sJVn3JMosOXqHZYenfBrStbP3p5CYUlvd
         DdMHJy0Oj5RzZNem0H/9OaTMo0Hn79yj8bwyHn7+nXIvh1WJKpVJ6k8q0AXfr8jEYSJS
         kOdnZ5HDUCs1OLeI0oOxFP8qcwrCZtnZCazQK/Mu9uGVMlJ4H3/0Svkby0CiovusBzsG
         pp+A==
X-Gm-Message-State: AJIora8OnlhC1mTj6cOlOu291MpbiFo4S+eWEEuKkGbWSAKfA72vSM77
        nNF0FRPCAmJMDs9Wbs6I5HMr83Jbc/RJz3TNN4L4KfqMXy7lK0IpzrACjJYDXO6zKnRudVQ9NX9
        +lQqttogqtGq6
X-Received: by 2002:a5d:59ac:0:b0:218:5b7e:1c1c with SMTP id p12-20020a5d59ac000000b002185b7e1c1cmr7862518wrr.621.1655984972240;
        Thu, 23 Jun 2022 04:49:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vTPcKA/Gtunm62EMKOjhQsL1m61Yus+wpfp3jVs8q/AUz9YpZd9lg6T2PmBGdsLONZlOPI3Q==
X-Received: by 2002:a5d:59ac:0:b0:218:5b7e:1c1c with SMTP id p12-20020a5d59ac000000b002185b7e1c1cmr7862485wrr.621.1655984971915;
        Thu, 23 Jun 2022 04:49:31 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u16-20020adfed50000000b0021b89f8662esm14508407wro.13.2022.06.23.04.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 04:49:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
In-Reply-To: <YrQ9rt61a8tPWWGO@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqdsjW4/zsYaJahf@google.com> <YqipLpHI24NdhgJO@anrayabh-desk>
 <YqiwoOP4HX2LniI4@google.com> <87zgi5xh42.fsf@redhat.com>
 <YrMenI1mTbqA9MaR@anrayabh-desk> <87r13gyde8.fsf@redhat.com>
 <YrNBHFLzAgcsw19O@anrayabh-desk> <87k098y77x.fsf@redhat.com>
 <YrQ9rt61a8tPWWGO@anrayabh-desk>
Date:   Thu, 23 Jun 2022 13:49:30 +0200
Message-ID: <87bkujy4z9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:

> On Wed, Jun 22, 2022 at 06:48:50PM +0200, Vitaly Kuznetsov wrote:
>> Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:
>> 
>> > On Wed, Jun 22, 2022 at 04:35:27PM +0200, Vitaly Kuznetsov wrote:
>> 
>> ...
>> 
>> >> 
>> >> I've tried to pick it up but it's actually much harder than I think. The
>> >> patch has some minor issues ('&vmcs_config.nested' needs to be switched
>> >> to '&vmcs_conf->nested' in nested_vmx_setup_ctls_msrs()), but the main
>> >> problem is that the set of controls nested_vmx_setup_ctls_msrs() needs
>> >> is NOT a subset of vmcs_config (setup_vmcs_config()). I was able to
>> >> identify at least:
>> 
>> ...
>> 
>> I've jsut sent "[PATCH RFC v1 00/10] KVM: nVMX: Use vmcs_config for
>> setting up nested VMX MSRs" which implements Sean's suggestion. Hope
>> this is the way to go for mainline.
>> 
>> >
>> > How about we do something simple like the patch below to start with?
>> > This will easily apply to stable and we can continue improving upon
>> > it with follow up patches on mainline.
>> >
>> 
>> Personally, I'm not against this for @stable. Alternatively, in case the
>
> I think it's a good intermediate fix for mainline too. It is easier to land
> it in stable if it already exists in mainline. It can stay in mainline
> until your series lands and replaces it with the vmcs_config approach.
>
> What do you think?
>

Paolo's call but personally I think both series can make 5.20 so there's
no need for an intermediate solution.

>> only observed issue is with TSC scaling, we can add support for it for
>> KVM-on-Hyper-V but not for Hyper-V-on-KVM (a small subset of "[PATCH
>> 00/11] KVM: VMX: Support TscScaling and EnclsExitingBitmap whith
>> eVMCS"). I can prepare patches if needed.
>
> Will it fit in stable's 100 line rule?
>

Yes, please take a look at the attached patches (5.18.y based). First 3
are identical to what I've sent for mainline, the last one is reduced to
only support TSC scaling for KVM on Hyper-V (but not Hyper-V on
KVM). Compile tested only, proceed with caution)

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-x86-hyperv-Fix-struct-hv_enlightened_vmcs-definition.patch

From 3057bc241d70152df5f82cfc1fa03d11c91fb48a Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Mon, 13 Jun 2022 15:39:02 +0200
Subject: [PATCH 1/4] x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
Content-Type: text/plain

Section 1.9 of TLFS v6.0b says:

"All structures are padded in such a way that fields are aligned
naturally (that is, an 8-byte field is aligned to an offset of 8 bytes
and so on)".

'struct enlightened_vmcs' has a glitch:

...
        struct {
                u32                nested_flush_hypercall:1; /*   836: 0  4 */
                u32                msr_bitmap:1;         /*   836: 1  4 */
                u32                reserved:30;          /*   836: 2  4 */
        } hv_enlightenments_control;                     /*   836     4 */
        u32                        hv_vp_id;             /*   840     4 */
        u64                        hv_vm_id;             /*   844     8 */
        u64                        partition_assist_page; /*   852     8 */
...

And the observed values in 'partition_assist_page' make no sense at
all. Fix the layout by padding the structure properly.

Fixes: 68d1eb72ee99 ("x86/hyper-v: define struct hv_enlightened_vmcs and clean field bits")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 0a9407dc0859..6f0acc45e67a 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -546,7 +546,7 @@ struct hv_enlightened_vmcs {
 	u64 guest_rip;
 
 	u32 hv_clean_fields;
-	u32 hv_padding_32;
+	u32 padding32_1;
 	u32 hv_synthetic_controls;
 	struct {
 		u32 nested_flush_hypercall:1;
@@ -554,7 +554,7 @@ struct hv_enlightened_vmcs {
 		u32 reserved:30;
 	}  __packed hv_enlightenments_control;
 	u32 hv_vp_id;
-
+	u32 padding32_2;
 	u64 hv_vm_id;
 	u64 partition_assist_page;
 	u64 padding64_4[4];
-- 
2.35.3


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0002-x86-hyperv-Update-struct-hv_enlightened_vmcs-definit.patch

From 377ec70ef19dc770bf0764e711408b89d53b36c6 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Wed, 20 Apr 2022 14:42:50 +0200
Subject: [PATCH 2/4] x86/hyperv: Update 'struct hv_enlightened_vmcs'
 definition
Content-Type: text/plain

Updated Hyper-V Enlightened VMCS specification lists several new
fields for the following features:

- PerfGlobalCtrl
- EnclsExitingBitmap
- Tsc Scaling
- GuestLbrCtl
- CET
- SSP

Update the definition.

Note: The latest TLFS is available at
https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/tlfs

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 6f0acc45e67a..fd334e8defb7 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -559,9 +559,20 @@ struct hv_enlightened_vmcs {
 	u64 partition_assist_page;
 	u64 padding64_4[4];
 	u64 guest_bndcfgs;
-	u64 padding64_5[7];
+	u64 guest_ia32_perf_global_ctrl;
+	u64 guest_ia32_s_cet;
+	u64 guest_ssp;
+	u64 guest_ia32_int_ssp_table_addr;
+	u64 guest_ia32_lbr_ctl;
+	u64 padding64_5[2];
 	u64 xss_exit_bitmap;
-	u64 padding64_6[7];
+	u64 host_ia32_perf_global_ctrl;
+	u64 encls_exiting_bitmap;
+	u64 tsc_multiplier;
+	u64 host_ia32_s_cet;
+	u64 host_ssp;
+	u64 host_ia32_int_ssp_table_addr;
+	u64 padding64_6;
 } __packed;
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE			0
-- 
2.35.3


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0003-KVM-VMX-Define-VMCS-to-EVMCS-conversion-for-the-new-.patch

From 1c1be861161cb95f2b78727a6b7edda277ba036e Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Wed, 20 Apr 2022 15:41:01 +0200
Subject: [PATCH 3/4] KVM: VMX: Define VMCS-to-EVMCS conversion for the new
 fields
Content-Type: text/plain

Enlightened VMCS v1 definition was updated with new fields, support
them in KVM by defining VMCS-to-EVMCS conversion.

Note: SSP, CET and Guest LBR features are not supported by KVM yet and
the corresponding fields are not defined in 'enum vmcs_field', leave
them commented out for now.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 87e3dc10edf4..61a702a804f8 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -28,6 +28,8 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
 	EVMCS1_FIELD(HOST_IA32_EFER, host_ia32_efer,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
+	EVMCS1_FIELD(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl,
+		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
 	EVMCS1_FIELD(HOST_CR0, host_cr0,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
 	EVMCS1_FIELD(HOST_CR3, host_cr3,
@@ -78,6 +80,8 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
 	EVMCS1_FIELD(GUEST_IA32_EFER, guest_ia32_efer,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
+	EVMCS1_FIELD(GUEST_IA32_PERF_GLOBAL_CTRL, guest_ia32_perf_global_ctrl,
+		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
 	EVMCS1_FIELD(GUEST_PDPTR0, guest_pdptr0,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
 	EVMCS1_FIELD(GUEST_PDPTR1, guest_pdptr1,
@@ -126,6 +130,28 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
 	EVMCS1_FIELD(XSS_EXIT_BITMAP, xss_exit_bitmap,
 		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
+	EVMCS1_FIELD(ENCLS_EXITING_BITMAP, encls_exiting_bitmap,
+		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
+	EVMCS1_FIELD(TSC_MULTIPLIER, tsc_multiplier,
+		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
+	/*
+	 * Not used by KVM:
+	 *
+	 * EVMCS1_FIELD(0x00006828, guest_ia32_s_cet,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
+	 * EVMCS1_FIELD(0x0000682A, guest_ssp,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
+	 * EVMCS1_FIELD(0x0000682C, guest_ia32_int_ssp_table_addr,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
+	 * EVMCS1_FIELD(0x00002816, guest_ia32_lbr_ctl,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
+	 * EVMCS1_FIELD(0x00006C18, host_ia32_s_cet,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
+	 * EVMCS1_FIELD(0x00006C1A, host_ssp,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
+	 * EVMCS1_FIELD(0x00006C1C, host_ia32_int_ssp_table_addr,
+	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
+	 */
 
 	/* 64 bit read only */
 	EVMCS1_FIELD(GUEST_PHYSICAL_ADDRESS, guest_physical_address,
-- 
2.35.3


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0004-KVM-VMX-Support-TSC-scaling-with-enlightened-VMCS.patch

From 5870058d2be9b8d2e34604e7f67eb7522f554dd9 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Wed, 15 Jun 2022 14:03:01 +0200
Subject: [PATCH 4/4] KVM: VMX: Support TSC scaling with enlightened VMCS
Content-Type: text/plain

Enlightened VMCS v1 now includes the required field for TSC scaling
feature so SECONDARY_EXEC_TSC_SCALING doesn't need to be filtered out
for KVM on Hyper-V case. Hyper-V on KVM is, however, trickier: to not
break live migration to older KVMs which may not support the feature
it needs to stay filtered out. Eventually, a new KVM capability indicating
support for the new fields will need to be introduced.

While on it, update the comment why VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL/
VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL are kept filtered out and add
missing spaces in trace_kvm_nested_vmenter_failed() strings making the
output ugly.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c |  8 +++++++-
 arch/x86/kvm/vmx/evmcs.h | 11 ++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 61a702a804f8..6ed4bb2e676e 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -385,7 +385,13 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+		/*
+		 * Initially, SECONDARY_EXEC_TSC_SCALING was filtered out as there was no
+		 * TscMultiplier field defined in eVMCS. Keep the status quo to not break
+		 * live migration.
+		 */
+		ctl_high &= ~(EVMCS1_UNSUPPORTED_2NDEXEC |
+			      SECONDARY_EXEC_TSC_SCALING);
 		break;
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 8d70f9aea94b..5fd9292be6bb 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -37,16 +37,14 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
  *	EPTP_LIST_ADDRESS               = 0x00002024,
  *	VMREAD_BITMAP                   = 0x00002026,
  *	VMWRITE_BITMAP                  = 0x00002028,
- *
- *	TSC_MULTIPLIER                  = 0x00002032,
  *	PLE_GAP                         = 0x00004020,
  *	PLE_WINDOW                      = 0x00004022,
  *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
- *      GUEST_IA32_PERF_GLOBAL_CTRL     = 0x00002808,
- *      HOST_IA32_PERF_GLOBAL_CTRL      = 0x00002c04,
  *
- * Currently unsupported in KVM:
- *	GUEST_IA32_RTIT_CTL		= 0x00002814,
+ *	While GUEST_IA32_PERF_GLOBAL_CTRL and HOST_IA32_PERF_GLOBAL_CTRL
+ *	are present in eVMCSv1, Windows 11 still has issues booting when
+ *	VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL/VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL
+ *	are exposed to it, keep them filtered out.
  */
 #define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
 				    PIN_BASED_VMX_PREEMPTION_TIMER)
@@ -57,7 +55,6 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_ENABLE_PML |					\
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
-	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
 #define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
 	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
-- 
2.35.3


--=-=-=--

