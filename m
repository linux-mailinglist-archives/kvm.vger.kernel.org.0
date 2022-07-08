Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6177F56BCB1
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiGHOmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238390AbiGHOms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:42:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC23B57276
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657291363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zaxbY1rOITz+shpil2uKHRFDtCLUgY9k2BOgoea4vxs=;
        b=aU2BMiWQUESOm5xJbD3ZyvvERI4VV+WYQKUBdaqN3l2EyFRSHtIOFSxnnU9vJSzLE6Dfjk
        tAT44sGJssG5DLSslFTCOibYkIQL5pFubXsBFR43J2lPKnuw3bBZlMJiBgsVv9Yyk+7CBm
        EAQM1rwKeHuzZx5qMXoE5bXtpdddlWo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-l-P0Dvv0Pvu_jnLAV3s2Bg-1; Fri, 08 Jul 2022 10:42:40 -0400
X-MC-Unique: l-P0Dvv0Pvu_jnLAV3s2Bg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7985C3801160;
        Fri,  8 Jul 2022 14:42:39 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EF5140315C;
        Fri,  8 Jul 2022 14:42:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/25] KVM: nVMX: Support several new fields in eVMCSv1
Date:   Fri,  8 Jul 2022 16:42:03 +0200
Message-Id: <20220708144223.610080-6-vkuznets@redhat.com>
In-Reply-To: <20220708144223.610080-1-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened VMCS v1 definition was updated with new fields, add
support for them for Hyper-V on KVM.

Note: SSP, CET and Guest LBR features are not supported by KVM yet
and 'struct vmcs12' has no corresponding fields.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 778f82015f03..4fc84f0f5875 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1603,6 +1603,10 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->guest_rflags = evmcs->guest_rflags;
 		vmcs12->guest_interruptibility_info =
 			evmcs->guest_interruptibility_info;
+		/*
+		 * Not present in struct vmcs12:
+		 * vmcs12->guest_ssp = evmcs->guest_ssp;
+		 */
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1649,6 +1653,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
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
@@ -1716,6 +1727,8 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->tsc_offset = evmcs->tsc_offset;
 		vmcs12->virtual_apic_page_addr = evmcs->virtual_apic_page_addr;
 		vmcs12->xss_exit_bitmap = evmcs->xss_exit_bitmap;
+		vmcs12->encls_exiting_bitmap = evmcs->encls_exiting_bitmap;
+		vmcs12->tsc_multiplier = evmcs->tsc_multiplier;
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -1763,6 +1776,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
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
@@ -1865,12 +1885,23 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
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

