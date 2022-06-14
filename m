Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A8A54B071
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 14:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbiFNMTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 08:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiFNMTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 08:19:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0ABBC43EE5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655209184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/0MEntxUovDItabxyHgNH3zdYnTQeXrI0UtQH5CAKdw=;
        b=SfoCEDAc/MG9XmwEsrMxtdHT9VApGG6qa5C5UMq7jf+Qxh7GtPxT7AAZZJl9OPMXBGlhgr
        0D+hG3luzWAT7N4/48XwVDxoSMr6nSGCJj1rm/HBHGKvicVmoDWraaytwWp1rkg6+vOg2H
        sPBvzlmoSCI6xFD/qbRV5lPbJcZmXs4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-O66JhXt-P3K4BQiRZ7PGaw-1; Tue, 14 Jun 2022 08:19:42 -0400
X-MC-Unique: O66JhXt-P3K4BQiRZ7PGaw-1
Received: by mail-ed1-f70.google.com with SMTP id m6-20020aa7c2c6000000b0042dc237d9e7so6068396edp.15
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:19:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/0MEntxUovDItabxyHgNH3zdYnTQeXrI0UtQH5CAKdw=;
        b=WW58lb842JEoQjRHsy+ae+7brZdMt7mdMypgX4OOYkno6gDVzEG9JzW4tDHZsLm0rp
         Cmn9PGr6HFSmbCcmCrtPic1oFCC09S94+FsMJG8YJAcTRMUTG/wXcQwsFJKKTvOc8ebh
         qc56eA48lhkh+d16idAI7EnulmcMg8VtFvLoLIFfsiY++sOvqg0TUxxtlEN5PArEy+Vu
         xiJP9jyUSxU37bAi3I1XeruH5ecmxf8xDllnqN8KrlIPcKsFPiSmZZYVNoAAeuKbTwnQ
         MOPAcmcXgoAHAy0RNxfWSSoPqjPxPlcpnux59h9C4Fnj4xx2mOgLNEVN5tN+aebec5RN
         UsUA==
X-Gm-Message-State: AOAM531L9Jpj//Pr1i+DcBv5mYCj4f2vtK15ulF4p+FHzIFDTz+7lxBJ
        8xto24SJ4DIk5Adx6cetkxcM95fTh9tD1bF9hhTymHnrmNS9zr+ZXGDQJWqEW5KJNCDo0p6miHW
        ijjByLHlkKVc9
X-Received: by 2002:a17:906:d1cc:b0:709:567f:3506 with SMTP id bs12-20020a170906d1cc00b00709567f3506mr4002523ejb.363.1655209181692;
        Tue, 14 Jun 2022 05:19:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx42IQqlmtovWoVmOE8npAYyCPPyPz8pF5loAAbHWO1Ljfj8+6v+pKyQ4/JLNByqV5MYBl3oQ==
X-Received: by 2002:a17:906:d1cc:b0:709:567f:3506 with SMTP id bs12-20020a170906d1cc00b00709567f3506mr4002492ejb.363.1655209181482;
        Tue, 14 Jun 2022 05:19:41 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x24-20020aa7dad8000000b0042dd482d0c4sm6966110eds.80.2022.06.14.05.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:19:40 -0700 (PDT)
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
In-Reply-To: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
Date:   Tue, 14 Jun 2022 14:19:39 +0200
Message-ID: <87sfo7igis.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:

...

>
> As per the comments in arch/x86/kvm/vmx/evmcs.h, TSC multiplier field is
> currently not supported in EVMCS.

The latest version:
https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_vmx_enlightened_vmcs

has it, actually. It was missing before (compare with e.g. 6.0b version
here:
https://github.com/MicrosoftDocs/Virtualization-Documentation/raw/live/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v6.0b.pdf)

but AFAIR TSC scaling wasn't advertised by genuine Hyper-V either.
Interestingly enough, eVMCS version didn't change when these fields were
added, it is still '1'.

I even have a patch in my stash (attached). I didn't send it out because
it wasn't properly tested with different Hyper-V versions.

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-KVM-x86-Allow-some-previously-forbidden-controls-whe.patch

From cb7c34d0c98691cf02a3198ee05cc913300e909b Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Wed, 20 Apr 2022 15:43:37 +0200
Subject: [PATCH RFC] KVM: x86: Allow some previously forbidden controls when
 eVMCS is in use
Content-Type: text/plain

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.h  | 11 ++++-------
 arch/x86/kvm/vmx/nested.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index ddbdb557cc53..5963c6374db2 100644
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
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3e2ef5edad4a..4a596973e505 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1628,6 +1628,10 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->guest_rflags = evmcs->guest_rflags;
 		vmcs12->guest_interruptibility_info =
 			evmcs->guest_interruptibility_info;
+		/*
+		 * Not present in struct vmcs12:
+		 * vmcs12->guest_ssp = evmcs->guest_ssp;
+		 */
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1674,6 +1678,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->host_fs_selector = evmcs->host_fs_selector;
 		vmcs12->host_gs_selector = evmcs->host_gs_selector;
 		vmcs12->host_tr_selector = evmcs->host_tr_selector;
+		vmcs12->host_ia32_perf_global_ctrl = evmcs->host_ia32_perf_global_ctrl;
+		/*
+		 * Not present in struct vmcs12:
+		 * vmcs12->host_ia32_s_cet = evmcs->host_ia32_s_cet;
+		 * vmcs12->host_ssp = evmcs->host_ssp;
+		 * vmcs12->host_ia32_int_ssp_table_addr = evmcs->host_ia32_int_ssp_table_addr;
+		 */
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1741,6 +1752,8 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->tsc_offset = evmcs->tsc_offset;
 		vmcs12->virtual_apic_page_addr = evmcs->virtual_apic_page_addr;
 		vmcs12->xss_exit_bitmap = evmcs->xss_exit_bitmap;
+		vmcs12->encls_exiting_bitmap = evmcs->encls_exiting_bitmap;
+		vmcs12->tsc_multiplier = evmcs->tsc_multiplier;
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1788,6 +1801,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->guest_bndcfgs = evmcs->guest_bndcfgs;
 		vmcs12->guest_activity_state = evmcs->guest_activity_state;
 		vmcs12->guest_sysenter_cs = evmcs->guest_sysenter_cs;
+		vmcs12->guest_ia32_perf_global_ctrl = evmcs->guest_ia32_perf_global_ctrl;
+		/*
+		 * Not present in struct vmcs12:
+		 * vmcs12->guest_ia32_s_cet = evmcs->guest_ia32_s_cet;
+		 * vmcs12->guest_ia32_lbr_ctl = evmcs->guest_ia32_lbr_ctl;
+		 * vmcs12->guest_ia32_int_ssp_table_addr = evmcs->guest_ia32_int_ssp_table_addr;
+		 */
 	}
 
 	/*
@@ -1890,12 +1910,23 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 	 * evmcs->vm_exit_msr_store_count = vmcs12->vm_exit_msr_store_count;
 	 * evmcs->vm_exit_msr_load_count = vmcs12->vm_exit_msr_load_count;
 	 * evmcs->vm_entry_msr_load_count = vmcs12->vm_entry_msr_load_count;
+	 * evmcs->guest_ia32_perf_global_ctrl = vmcs12->guest_ia32_perf_global_ctrl;
+	 * evmcs->host_ia32_perf_global_ctrl = vmcs12->host_ia32_perf_global_ctrl;
+	 * evmcs->encls_exiting_bitmap = vmcs12->encls_exiting_bitmap;
+	 * evmcs->tsc_multiplier = vmcs12->tsc_multiplier;
 	 *
 	 * Not present in struct vmcs12:
 	 * evmcs->exit_io_instruction_ecx = vmcs12->exit_io_instruction_ecx;
 	 * evmcs->exit_io_instruction_esi = vmcs12->exit_io_instruction_esi;
 	 * evmcs->exit_io_instruction_edi = vmcs12->exit_io_instruction_edi;
 	 * evmcs->exit_io_instruction_eip = vmcs12->exit_io_instruction_eip;
+	 * evmcs->host_ia32_s_cet = vmcs12->host_ia32_s_cet;
+	 * evmcs->host_ssp = vmcs12->host_ssp;
+	 * evmcs->host_ia32_int_ssp_table_addr = vmcs12->host_ia32_int_ssp_table_addr;
+	 * evmcs->guest_ia32_s_cet = vmcs12->guest_ia32_s_cet;
+	 * evmcs->guest_ia32_lbr_ctl = vmcs12->guest_ia32_lbr_ctl;
+	 * evmcs->guest_ia32_int_ssp_table_addr = vmcs12->guest_ia32_int_ssp_table_addr;
+	 * evmcs->guest_ssp = vmcs12->guest_ssp;
 	 */
 
 	evmcs->guest_es_selector = vmcs12->guest_es_selector;
-- 
2.35.3


--=-=-=--

