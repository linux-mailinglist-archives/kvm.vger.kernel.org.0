Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3973B221AAE
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgGPDRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:17:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:8148 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgGPDRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:17:00 -0400
IronPort-SDR: WZdZG2LjeAexcXXOUVciHy2vTPfUvi0KyXmviCcXP+jgBem06kSh69i29uLYIvWswaSqYKtv6k
 VCoQPRHnqhug==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210844839"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210844839"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:16:59 -0700
IronPort-SDR: a7aNfgQLxQCdNKvyXw9yDgMY2ItXXqXasHSRR7WvgO7UhFkl1qMV8tS970+FmOE9Ym0WORcgeK
 XvrenmOUg8Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="360910423"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2020 20:16:57 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RESEND v13 02/11] KVM: VMX: Introduce CET VMCS fields and flags
Date:   Thu, 16 Jul 2020 11:16:18 +0800
Message-Id: <20200716031627.11492-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200716031627.11492-1-weijiang.yang@intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET(Control-flow Enforcement Technology) is a CPU feature used to prevent
Return/Jump-Oriented Programming(ROP/JOP) attacks. It provides the following
sub-features to defend against ROP/JOP style control-flow subversion attacks:

Shadow Stack (SHSTK):
  A second stack for program which is used exclusively for control transfer
  operations.

Indirect Branch Tracking (IBT):
  Code branching protection to defend against jump/call oriented programming.

Several new CET MSRs are defined in kernel to support CET:
  MSR_IA32_{U,S}_CET: Controls the CET settings for user mode and kernel mode
  respectively.

  MSR_IA32_PL{0,1,2,3}_SSP: Stores shadow stack pointers for CPL-0,1,2,3
  protection respectively.

  MSR_IA32_INT_SSP_TAB: Stores base address of shadow stack pointer table.

Two XSAVES state bits are introduced for CET:
  IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
  IA32_XSS:[bit 12]: Control saving/restoring kernel mode CET states.

Six VMCS fields are introduced for CET:
  {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
  {HOST,GUEST}_SSP: Stores shadow stack pointer of current task/thread.
  {HOST,GUEST}_INTR_SSP_TABLE: Stores base address of shadow stack pointer
  table.

If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host CET states are restored from below
VMCS fields at VM-Exit:
  HOST_S_CET
  HOST_SSP
  HOST_INTR_SSP_TABLE

If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest CET states are loaded from below
VMCS fields at VM-Entry:
  GUEST_S_CET
  GUEST_SSP
  GUEST_INTR_SSP_TABLE

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/vmx.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cd7de4b401fe..879c57ff2dc5 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -94,6 +94,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_LOAD_CET_STATE                  0x10000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -107,6 +108,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_CET_STATE                 0x00100000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
@@ -328,6 +330,9 @@ enum vmcs_field {
 	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
 	GUEST_SYSENTER_ESP              = 0x00006824,
 	GUEST_SYSENTER_EIP              = 0x00006826,
+	GUEST_S_CET                     = 0x00006828,
+	GUEST_SSP                       = 0x0000682a,
+	GUEST_INTR_SSP_TABLE            = 0x0000682c,
 	HOST_CR0                        = 0x00006c00,
 	HOST_CR3                        = 0x00006c02,
 	HOST_CR4                        = 0x00006c04,
@@ -340,6 +345,9 @@ enum vmcs_field {
 	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
 	HOST_RSP                        = 0x00006c14,
 	HOST_RIP                        = 0x00006c16,
+	HOST_S_CET                      = 0x00006c18,
+	HOST_SSP                        = 0x00006c1a,
+	HOST_INTR_SSP_TABLE             = 0x00006c1c
 };
 
 /*
-- 
2.17.2

