Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF25587FBF
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbiHBQIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbiHBQI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:08:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A38E26122
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ocJxblDza2Sr7gKj41bQyysSP+PFqiVFlPEMK6X0mos=;
        b=Q/DM+LSF4szkQtZ2VhKRm5J6NvON6fmwq2IommO6KDRtaUvMvr1yLzwNNXRAnBj04hnKda
        y/EhT2lLa7fO9V67jrVqeqDuqpj6afS2TAx+g0NMRemMNqphIpQ3MCmbXm/Q4QtOQEoJIm
        8V9G0zkpNrrHtieurZZiOovIVwo+fYU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-g5CGDIhNPnueOqE72w4ozA-1; Tue, 02 Aug 2022 12:08:15 -0400
X-MC-Unique: g5CGDIhNPnueOqE72w4ozA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86B603804507;
        Tue,  2 Aug 2022 16:08:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B4812166B26;
        Tue,  2 Aug 2022 16:08:11 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/26] KVM: nVMX: Support several new fields in eVMCSv1
Date:   Tue,  2 Aug 2022 18:07:35 +0200
Message-Id: <20220802160756.339464-6-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened VMCS v1 definition was updated with new fields, add
support for them for Hyper-V on KVM.

Note: SSP, CET and Guest LBR features are not supported by KVM yet
and 'struct vmcs12' has no corresponding fields.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..270a1d8e4a6e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1607,6 +1607,10 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->guest_rflags = evmcs->guest_rflags;
 		vmcs12->guest_interruptibility_info =
 			evmcs->guest_interruptibility_info;
+		/*
+		 * Not present in struct vmcs12:
+		 * vmcs12->guest_ssp = evmcs->guest_ssp;
+		 */
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1653,6 +1657,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
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
@@ -1720,6 +1731,8 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->tsc_offset = evmcs->tsc_offset;
 		vmcs12->virtual_apic_page_addr = evmcs->virtual_apic_page_addr;
 		vmcs12->xss_exit_bitmap = evmcs->xss_exit_bitmap;
+		vmcs12->encls_exiting_bitmap = evmcs->encls_exiting_bitmap;
+		vmcs12->tsc_multiplier = evmcs->tsc_multiplier;
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1767,6 +1780,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
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
@@ -1869,12 +1889,23 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
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

