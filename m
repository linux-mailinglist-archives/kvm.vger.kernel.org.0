Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B58F6B6489
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjCLJ7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjCLJ6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F74B521F9
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615075; x=1710151075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mC1mA/SBz/XB3XNkxj9nYkmFwtjGiZmuZbvRWpRzVKc=;
  b=CTLmjKj3XgiJohV+JukmrLcFCUqOGsgvmzOsgfgBt4NcTtnRCPRiaDK9
   ss0fHBbm2HZ12jgcY5W75MYE5fA9Slb6QMSEhC2D8zod23KRFg5b5flWh
   KOf9T+Gwhzw6fAqQK0rusWJOi50ja3yZRhfE4r5TQIcLrtY0LUqYiqbnC
   EsqhF/NceHD8OXdYOzIp+F8ag1JXDeBVt49/AsWdQHwxegd3acurVx0Dp
   RwyXmE0wWpVQytppj2zAum0bd5ZxdpdKy5d3xGCxEAmIvW72Ngyba45Lk
   0tcL5SKO8UzMXRTpuHTIpyPR1/1jbYYBNjMsShtg/iDTGeMMsIkWeJoHR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998116"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998116"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677710"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677710"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:21 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 11/22] KVM: VMX: Add more vmcs and vmcs12 fields definition
Date:   Mon, 13 Mar 2023 02:02:52 +0800
Message-Id: <20230312180303.1778492-12-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add more fields definition for vmcs and vmcs12, which can be used to
extend vmcs shadow fields support for VMX emulation.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/vmx.h |  4 ++++
 arch/x86/kvm/vmx/vmcs12.c  |  6 ++++++
 arch/x86/kvm/vmx/vmcs12.h  | 16 ++++++++++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 498dc600bd5c..d9f119bab5b2 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -322,6 +322,10 @@ enum vmcs_field {
 	CR3_TARGET_VALUE2               = 0x0000600c,
 	CR3_TARGET_VALUE3               = 0x0000600e,
 	EXIT_QUALIFICATION              = 0x00006400,
+	EXIT_IO_RCX	                = 0x00006402,
+	EXIT_IO_RSI	                = 0x00006404,
+	EXIT_IO_RDI	                = 0x00006406,
+	EXIT_IO_RIP	                = 0x00006408,
 	GUEST_LINEAR_ADDRESS            = 0x0000640a,
 	GUEST_CR0                       = 0x00006800,
 	GUEST_CR3                       = 0x00006802,
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 2251b60920f8..6ab29b869914 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -112,6 +112,8 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(GUEST_SYSENTER_CS, guest_sysenter_cs),
 	FIELD(HOST_IA32_SYSENTER_CS, host_ia32_sysenter_cs),
 	FIELD(VMX_PREEMPTION_TIMER_VALUE, vmx_preemption_timer_value),
+	FIELD(PLE_GAP, ple_gap),
+	FIELD(PLE_WINDOW, ple_window),
 	FIELD(CR0_GUEST_HOST_MASK, cr0_guest_host_mask),
 	FIELD(CR4_GUEST_HOST_MASK, cr4_guest_host_mask),
 	FIELD(CR0_READ_SHADOW, cr0_read_shadow),
@@ -150,5 +152,9 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
+	FIELD(EXIT_IO_RCX, exit_io_rcx),
+	FIELD(EXIT_IO_RSI, exit_io_rsi),
+	FIELD(EXIT_IO_RDI, exit_io_rdi),
+	FIELD(EXIT_IO_RIP, exit_io_rip),
 };
 const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 01936013428b..92483940bb40 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -117,7 +117,11 @@ struct __packed vmcs12 {
 	natural_width host_ia32_sysenter_eip;
 	natural_width host_rsp;
 	natural_width host_rip;
-	natural_width paddingl[8]; /* room for future expansion */
+	natural_width exit_io_rcx;
+	natural_width exit_io_rsi;
+	natural_width exit_io_rdi;
+	natural_width exit_io_rip;
+	natural_width paddingl[4]; /* room for future expansion */
 	u32 pin_based_vm_exec_control;
 	u32 cpu_based_vm_exec_control;
 	u32 exception_bitmap;
@@ -165,7 +169,9 @@ struct __packed vmcs12 {
 	u32 guest_sysenter_cs;
 	u32 host_ia32_sysenter_cs;
 	u32 vmx_preemption_timer_value;
-	u32 padding32[7]; /* room for future expansion */
+	u32 ple_gap;
+	u32 ple_window;
+	u32 padding32[5]; /* room for future expansion */
 	u16 virtual_processor_id;
 	u16 posted_intr_nv;
 	u16 guest_es_selector;
@@ -292,6 +298,10 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
 	CHECK_OFFSET(host_rsp, 664);
 	CHECK_OFFSET(host_rip, 672);
+	CHECK_OFFSET(exit_io_rcx, 680);
+	CHECK_OFFSET(exit_io_rsi, 688);
+	CHECK_OFFSET(exit_io_rdi, 696);
+	CHECK_OFFSET(exit_io_rip, 704);
 	CHECK_OFFSET(pin_based_vm_exec_control, 744);
 	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
 	CHECK_OFFSET(exception_bitmap, 752);
@@ -339,6 +349,8 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(guest_sysenter_cs, 920);
 	CHECK_OFFSET(host_ia32_sysenter_cs, 924);
 	CHECK_OFFSET(vmx_preemption_timer_value, 928);
+	CHECK_OFFSET(ple_gap, 932);
+	CHECK_OFFSET(ple_window, 936);
 	CHECK_OFFSET(virtual_processor_id, 960);
 	CHECK_OFFSET(posted_intr_nv, 962);
 	CHECK_OFFSET(guest_es_selector, 964);
-- 
2.25.1

