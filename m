Return-Path: <kvm+bounces-2417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C22DD7F6D83
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7963A2820A6
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E189D1A591;
	Fri, 24 Nov 2023 07:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kBQSqUbk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805891728;
	Thu, 23 Nov 2023 23:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812727; x=1732348727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7pXFvzIlPBv7YsxlB7MipwWfzAjim4sbbyjzoKX1zCo=;
  b=kBQSqUbkTsUvH4YyWu1ntAsVTcBNXlEnq4vj712ywpqQAmfESayO+mho
   t1G4x+3bLFimSt1gQGXEfuYT+/rJTyI5wMDnAkco7bmISpOf9KVp76Hox
   EjXtfN7INVDIdXkP/Qc5bv+syOIv4n+IXwy4mMc9ROxKKepFL9m+KFq0n
   Sy0Qh6+r5eUcn2WiSxh01N6cfqR+xFR4dmdxe19xLV1zuCttfh3fsObz7
   tnXuMsCPMhWUb/+pHvANMuhcj+ZZbMXeIoMubl75wJtP6gOaTcJsCDSsD
   pQRhGKe30bUHYf16Pv8PUlrmH70XYmJ6/IpTrC2SqVZEsyB1VyMz/2p2a
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872370"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872370"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629846"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629846"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:41 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v7 18/26] KVM: VMX: Introduce CET VMCS fields and control bits
Date: Fri, 24 Nov 2023 00:53:22 -0500
Message-Id: <20231124055330.138870-19-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Control-flow Enforcement Technology (CET) is a kind of CPU feature used
to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
style control-flow subversion attacks.

Shadow Stack (SHSTK):
  A shadow stack is a second stack used exclusively for control transfer
  operations. The shadow stack is separate from the data/normal stack and
  can be enabled individually in user and kernel mode. When shadow stack
  is enabled, CALL pushes the return address on both the data and shadow
  stack. RET pops the return address from both stacks and compares them.
  If the return addresses from the two stacks do not match, the processor
  generates a #CP.

Indirect Branch Tracking (IBT):
  IBT introduces instruction(ENDBRANCH)to mark valid target addresses of
  indirect branches (CALL, JMP etc...). If an indirect branch is executed
  and the next instruction is _not_ an ENDBRANCH, the processor generates
  a #CP. These instruction behaves as a NOP on platforms that have no CET.

Several new CET MSRs are defined to support CET:
  MSR_IA32_{U,S}_CET: CET settings for {user,supervisor} CET respectively.

  MSR_IA32_PL{0,1,2,3}_SSP: SHSTK pointer linear address for CPL{0,1,2,3}.

  MSR_IA32_INT_SSP_TAB: Linear address of SHSTK pointer table, whose entry
			is indexed by IST of interrupt gate desc.

Two XSAVES state bits are introduced for CET:
  IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
  IA32_XSS:[bit 12]: Control saving/restoring supervisor mode CET states.

Six VMCS fields are introduced for CET:
  {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
  {HOST,GUEST}_SSP: Stores current active SSP.
  {HOST,GUEST}_INTR_SSP_TABLE: Stores current active MSR_IA32_INT_SSP_TAB.

On Intel platforms, two additional bits are defined in VM_EXIT and VM_ENTRY
control fields:
If VM_EXIT_LOAD_CET_STATE = 1, host CET states are loaded from following
VMCS fields at VM-Exit:
  HOST_S_CET
  HOST_SSP
  HOST_INTR_SSP_TABLE

If VM_ENTRY_LOAD_CET_STATE = 1, guest CET states are loaded from following
VMCS fields at VM-Entry:
  GUEST_S_CET
  GUEST_SSP
  GUEST_INTR_SSP_TABLE

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/vmx.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0e73616b82f3..451fd4f4fedc 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -104,6 +104,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_LOAD_CET_STATE                  0x10000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -117,6 +118,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_CET_STATE                 0x00100000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
@@ -345,6 +347,9 @@ enum vmcs_field {
 	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
 	GUEST_SYSENTER_ESP              = 0x00006824,
 	GUEST_SYSENTER_EIP              = 0x00006826,
+	GUEST_S_CET                     = 0x00006828,
+	GUEST_SSP                       = 0x0000682a,
+	GUEST_INTR_SSP_TABLE            = 0x0000682c,
 	HOST_CR0                        = 0x00006c00,
 	HOST_CR3                        = 0x00006c02,
 	HOST_CR4                        = 0x00006c04,
@@ -357,6 +362,9 @@ enum vmcs_field {
 	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
 	HOST_RSP                        = 0x00006c14,
 	HOST_RIP                        = 0x00006c16,
+	HOST_S_CET                      = 0x00006c18,
+	HOST_SSP                        = 0x00006c1a,
+	HOST_INTR_SSP_TABLE             = 0x00006c1c
 };
 
 /*
-- 
2.27.0


