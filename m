Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414764CDE60
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiCDUHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiCDUGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:06:39 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D749A76D2;
        Fri,  4 Mar 2022 12:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424083; x=1677960083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8ferppz4eR2spSd3kgPq7FJIv1ClxuWQHKELTGTPvqk=;
  b=RiaPsT8eR5i2nhD4tPSBJzFBKYtnkhqw84vQFRubWuIzprurEDGIajJa
   ghqcBsXbhOhRZin99LZBu9uJcLbleLKqh1ljyUHNBkr1Pv1JIg0jmpWOk
   svEOyq7OfOhYY2ruCAtEVqzmufKIRSI57D2hPe/t6gt78rtzS8s8az6MF
   HfgqzzIbZBCtK1OUSyVhsfdUqWfx4AE7qdc/fTR3d7WExE0goLARRljNs
   Tdqhs2PGXpTpiPfI4gk/U2WQwR+WVH3RPRZBuOczUNfdU3EKycA8mpepV
   4XOLFhwTJM72ZVg00/DOsQBg/NBwna4H6ZBOnoRqjO8T7fio06lOYuKiI
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983348"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983348"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:10 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344158"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:10 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 015/104] KVM: TDX: add a helper function for KVM to issue SEAMCALL
Date:   Fri,  4 Mar 2022 11:48:31 -0800
Message-Id: <5cf00a5f5d108443a081ef95db9c7695be99c7d4.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TODO: Consolidate seamcall helper function with TDX host/guest patch series.
For now, this is kept to make this patch series compile/work.

A VMM interacts with the TDX module using a new instruction (SEAMCALL).  A
TDX VMM uses SEAMCALLs where a VMX VMM would have directly interacted with
VMX instructions.  For instance, a TDX VMM does not have full access to the
VM control structure corresponding to VMX VMCS.  Instead, a VMM induces the
TDX module to act on behalf via SEAMCALLs.

Add a helper function for KVM C code to execute SEAMCALL instruction to
hide its SEAMCALL ABI details.  Although the x86 TDX host patch series
defines a similar wrapper, the KVM TDX patch series defines its own because
KVM TDX case is performance-critical, unlike the x86 TDX one that does
one-time initialization.  The difference is that the KVM TDX one is defined
as a static inline function without an error check that is known to not
happen so that compiler can optimize it better.  The wrapper fiction in the
x86 TDX host patch is defined as a function written in assembly code with
error check so that it can detect errors that can occur only during the
initialization.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/seamcall.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/seamcall.h

diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
new file mode 100644
index 000000000000..604792e9a59f
--- /dev/null
+++ b/arch/x86/kvm/vmx/seamcall.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_VMX_SEAMCALL_H
+#define __KVM_VMX_SEAMCALL_H
+
+#ifdef CONFIG_INTEL_TDX_HOST
+
+#ifdef __ASSEMBLY__
+
+.macro seamcall
+	.byte 0x66, 0x0f, 0x01, 0xcf
+.endm
+
+#else
+
+struct tdx_module_output;
+u64 kvm_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
+		struct tdx_module_output *out);
+
+#endif /* !__ASSEMBLY__ */
+
+#endif	/* CONFIG_INTEL_TDX_HOST */
+
+#endif /* __KVM_VMX_SEAMCALL_H */
-- 
2.25.1

