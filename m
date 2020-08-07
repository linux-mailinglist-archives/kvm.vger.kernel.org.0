Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04ED823E979
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgHGIqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:46:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:65145 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgHGIqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:46:47 -0400
IronPort-SDR: 9lUVoQ61V38JDQuZP/R0iCzRx94K6gKM0LbYE3q/Tzc0JnJAjY5tx/EDUw5PNnivqRTYb22y8C
 1+kdfYdB0TpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="214565718"
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="214565718"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 01:46:46 -0700
IronPort-SDR: 95lBwmMTRHBuGxcPLquYgJLSzAWQtRulQ1T7PQhLt3uMioPI148jKqrntGjoyKziS0e8AFeB2V
 Fljic4D8ECSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="307317144"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga002.jf.intel.com with ESMTP; 07 Aug 2020 01:46:44 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 1/7] KVM: VMX: Introduce PKS VMCS fields
Date:   Fri,  7 Aug 2020 16:48:35 +0800
Message-Id: <20200807084841.7112-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807084841.7112-1-chenyi.qiang@intel.com>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
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
---
 arch/x86/include/asm/vmx.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cd7de4b401fe..425cf81dd722 100644
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

