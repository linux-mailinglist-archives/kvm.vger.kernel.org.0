Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7EF25E6E
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 09:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfEVHB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 03:01:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:31984 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbfEVHB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 03:01:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 00:01:56 -0700
X-ExtLoop1: 1
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2019 00:01:54 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yu-cheng.yu@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH v5 1/8] KVM: VMX: Define CET VMCS fields and control bits
Date:   Wed, 22 May 2019 15:00:54 +0800
Message-Id: <20190522070101.7636-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190522070101.7636-1-weijiang.yang@intel.com>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET(Control-flow Enforcement Technology) is an upcoming Intel® processor
family feature that blocks return/jump-oriented programming (ROP) attacks.
It provides the following capabilities to defend
against ROP/JOP style control-flow subversion attacks:

- Shadow Stack (SHSTK):
  A second stack for the program that is used exclusively for
  control transfer operations.

- Indirect Branch Tracking (IBT):
  Free branch protection to defend against jump/call oriented
  programming.

Several new CET MSRs are defined in kernel to support CET:
MSR_IA32_{U,S}_CET - MSRs to control the CET settings for user
mode and suervisor mode respectively.

MSR_IA32_PL{0,1,2,3}_SSP - MSRs to store shadow stack pointers for
CPL-0,1,2,3 levels.

MSR_IA32_INT_SSP_TAB - MSR to store base address of shadow stack
pointer table.

Two XSAVES state components are introduced for CET:
IA32_XSS:[bit 11] - bit for save/restor user mode CET states
IA32_XSS:[bit 12] - bit for save/restor supervisor mode CET states.

6 VMCS fields are introduced for CET, {HOST,GUEST}_S_CET is to store
CET settings in supervisor mode. {HOST,GUEST}_SSP is to store shadow
stack pointers in supervisor mode. {HOST,GUEST}_INTR_SSP_TABLE is to
store base address of shadow stack pointer table.

If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host's CET MSRs are restored
from below VMCS fields at VM-Exit:
- HOST_S_CET
- HOST_SSP
- HOST_INTR_SSP_TABLE

If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest's CET MSRs are loaded
from below VMCS fields at VM-Entry:
- GUEST_S_CET
- GUEST_SSP
- GUEST_INTR_SSP_TABLE

Apart from VMCS auto-load fields, KVM calls kvm_load_guest_fpu() and
kvm_put_guest_fpu() to save/restore the guest CET MSR states at
VM exit/entry. XSAVES/XRSTORS are executed underneath these functions
if they are supported. The CET xsave area is consolidated with other
XSAVE components in thread_struct.fpu field.

When context switch happens during task switch/interrupt/exception etc.,
Kernel also relies on above functions to switch CET states properly.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
---
 arch/x86/include/asm/vmx.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4e4133e86484..d84804c7ddaa 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -103,6 +103,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_LOAD_HOST_CET_STATE             0x10000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -116,6 +117,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_GUEST_CET_STATE           0x00100000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
@@ -334,6 +336,9 @@ enum vmcs_field {
 	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
 	GUEST_SYSENTER_ESP              = 0x00006824,
 	GUEST_SYSENTER_EIP              = 0x00006826,
+	GUEST_S_CET                     = 0x00006828,
+	GUEST_SSP                       = 0x0000682a,
+	GUEST_INTR_SSP_TABLE            = 0x0000682c,
 	HOST_CR0                        = 0x00006c00,
 	HOST_CR3                        = 0x00006c02,
 	HOST_CR4                        = 0x00006c04,
@@ -346,6 +351,9 @@ enum vmcs_field {
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

