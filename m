Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05C6EAF9F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjDUQvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjDUQuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:50:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F335715466;
        Fri, 21 Apr 2023 09:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095850; x=1713631850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HFNN6byA2AP42mJgNw2pZfCWk5/F/jjT/+R4++ncQJA=;
  b=Q4xR7Ww4d0BsbzyIfcQQ6/1KonM0hsXVgm9G8iDpoLo7FtMRHbjx2MgG
   e8DcIBGB34HBewwSkFKE4nUegVzCYqrLQo8dLaVe83/HsPHh4k8TNJOXX
   V2Lwbv79Yq5Rtvt4QpHFXSKOZp54m5VUNHXGBhfsY07xG1W2eD1JATy8S
   jWN8lDW96WxHIrYZCVb8rldC0G+at+dXhfz+qDsJqj+icHtSe+BVtnJZg
   0BOsmbPphv0T5mOEdZF+X6j9XEMJCWPOqcVvL/+ZodTpy96hgw+NRP/+B
   MPrHRmEGIx5GKIln5DoXwrgEjDiDb3IWL6lkoACkHfBjb8y9KXzMXIKRQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344787020"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344787020"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817396"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817396"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v2 11/21] KVM:VMX: Introduce CET VMCS fields and control bits
Date:   Fri, 21 Apr 2023 09:46:05 -0400
Message-Id: <20230421134615.62539-12-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET (Control-flow Enforcement Technology) is a CPU feature used to prevent
Return/Jump-Oriented Programming (ROP/JOP) attacks. CET introduces a new
exception type, Control Protection (#CP), and two sub-features(SHSTK,IBT)
to defend against ROP/JOP style control-flow subversion attacks.

Shadow Stack (SHSTK):
  A shadow stack is a second stack used exclusively for control transfer
  operations. The shadow stack is separate from the data/normal stack and
  can be enabled individually in user and kernel mode.  When shadow stacks
  are enabled, CALL pushes the return address on both the data and shadow
  stack. RET pops the return address from both stacks and compares them.
  If the return addresses from the two stacks do not match, the processor
  signals a #CP.

Indirect Branch Tracking (IBT):
  IBT adds a new instrution, ENDBRANCH, that is used to mark valid target
  addresses of indirect branches (CALL, JMP, ENCLU[EEXIT], etc...). If an
  indirect branch is executed and the next instruction is _not_ an
  ENDBRANCH, the processor signals a #CP.

Several new CET MSRs are defined to support CET:
  MSR_IA32_{U,S}_CET: Controls the CET settings for user mode and kernel
                      mode respectively.

  MSR_IA32_PL{0,1,2,3}_SSP: Stores shadow stack pointers for CPL-0,1,2,3
                            protection respectively.

  MSR_IA32_INT_SSP_TAB: Stores base address of shadow stack pointer table.

Two XSAVES state bits are introduced for CET:
  IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
  IA32_XSS:[bit 12]: Control saving/restoring kernel mode CET states.

Six VMCS fields are introduced for CET:
  {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
  {HOST,GUEST}_SSP: Stores shadow stack pointer of current active task/thread.
  {HOST,GUEST}_INTR_SSP_TABLE: Stores base address of shadow stack pointer table.

If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host CET states are restored from
the following VMCS fields at VM-Exit:
  HOST_S_CET
  HOST_SSP
  HOST_INTR_SSP_TABLE

If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest CET states are loaded from
the following VMCS fields at VM-Entry:
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
index 498dc600bd5c..fe2aff27df8c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -102,6 +102,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_LOAD_CET_STATE                  0x10000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -115,6 +116,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_CET_STATE                 0x00100000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
@@ -343,6 +345,9 @@ enum vmcs_field {
 	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
 	GUEST_SYSENTER_ESP              = 0x00006824,
 	GUEST_SYSENTER_EIP              = 0x00006826,
+	GUEST_S_CET                     = 0x00006828,
+	GUEST_SSP                       = 0x0000682a,
+	GUEST_INTR_SSP_TABLE            = 0x0000682c,
 	HOST_CR0                        = 0x00006c00,
 	HOST_CR3                        = 0x00006c02,
 	HOST_CR4                        = 0x00006c04,
@@ -355,6 +360,9 @@ enum vmcs_field {
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

