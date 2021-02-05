Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865323106E2
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhBEIfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:35:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:19405 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhBEIep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 03:34:45 -0500
IronPort-SDR: CjaSfGbhS8w0VW48Y9Mxhz653lme17vXY8wVkeBi0+EStjYl0BYNQEPZjmVMeVs7RKRpP337LV
 sZ0Dr9inckfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="181550686"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="181550686"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:34:02 -0800
IronPort-SDR: D9bxMPuBg2nzCyVfrjWF55OoXB/SmRbMtsYcsuLmRw5/oepXFzJwCU24xmmVgFSfC5sFywQhJV
 LsOj6kE5xGsQ==
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="393761893"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:34:00 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/5] KVM: VMX: Introduce PKS VMCS fields
Date:   Fri,  5 Feb 2021 16:37:02 +0800
Message-Id: <20210205083706.14146-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205083706.14146-1-chenyi.qiang@intel.com>
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKS(Protection Keys for Supervisor Pages) is a feature that extends the
Protection Key architecture to support thread-specific permission
restrictions on supervisor pages.

A new PKS MSR(PKRS) is defined in kernel to support PKS, which holds a
set of permissions associated with each protection domian.

Two VMCS fields {HOST,GUEST}_IA32_PKRS are introduced in
{host,guest}-state area to store the value of PKRS.

Every VM exit saves PKRS into guest-state area.
If VM_EXIT_LOAD_IA32_PKRS = 1, VM exit loads PKRS from the host-state
area.
If VM_ENTRY_LOAD_IA32_PKRS = 1, VM entry loads PKRS from the guest-state
area.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/vmx.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f8ba5289ecb0..5472859e21b0 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -94,6 +94,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_LOAD_IA32_PKRS			0x20000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -107,6 +108,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_IA32_PKRS			0x00400000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
@@ -243,12 +245,16 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_IA32_PKRS			= 0x00002818,
+	GUEST_IA32_PKRS_HIGH		= 0x00002819,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
 	HOST_IA32_EFER_HIGH		= 0x00002c03,
 	HOST_IA32_PERF_GLOBAL_CTRL	= 0x00002c04,
 	HOST_IA32_PERF_GLOBAL_CTRL_HIGH	= 0x00002c05,
+	HOST_IA32_PKRS			= 0x00002c06,
+	HOST_IA32_PKRS_HIGH		= 0x00002c07,
 	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
 	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
 	EXCEPTION_BITMAP                = 0x00004004,
-- 
2.17.1

