Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9AF667B45
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbjALQk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbjALQhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:32 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A0510B74;
        Thu, 12 Jan 2023 08:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541231; x=1705077231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=09ex/GWFgm/e3kqVrQ9ERgn2H38TVnuMLzJQ3ZuE9Tg=;
  b=Y4tKjw/5fZewHILovAduSm8xNf627gkvM8BGF373DeKYYPmSG5K5PcE/
   2skEJFAdWmAw30u9X/+ZKm8cViBbjjxvovH8VG541D99m0f54Vh/DAxMt
   z1ldUmEHkMt2qZXpGHwfcW6YF/ECBFERej7FIzqHLkTII1XiCCxSxyQk+
   RND+DQNr7/HxyylmRCGkgRKzJRAToaKHiJ2SHQC3DwXHv27IKHCXgACQ8
   /2KCq/Uxuna0yOEmlZcfLD2WN0/DsDEi8l1GXUJydSpuBJp5TDHoBof1v
   XYxaHP/kV3980xzYCilJIdkv1ynVl/ZTi6NNqBiq7sV/YYbpUy+liaQ9+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811682"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811682"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151651"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151651"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:20 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v11 009/113] KVM: TDX: Add TDX "architectural" error codes
Date:   Thu, 12 Jan 2023 08:31:17 -0800
Message-Id: <6872c5d6f10dca4c98582a2083fce791b5726271.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add error codes for the TDX SEAMCALLs both for TDX VMM side for TDH
SEAMCALL and TDX guest side for TDG.VP.VMCALL.  KVM issues the TDX
SEAMCALLs and checks its error code.  KVM handles hypercall from the TDX
guest and may return an error.  So error code for the TDX guest is also
needed.

TDX SEAMCALL uses bits 31:0 to return more information, so these error
codes will only exactly match RAX[63:32].  Error codes for TDG.VP.VMCALL is
defined by TDX Guest-Host-Communication interface spec.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx_errno.h | 38 ++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h

diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
new file mode 100644
index 000000000000..389b1b53da25
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* architectural status code for SEAMCALL */
+
+#ifndef __KVM_X86_TDX_ERRNO_H
+#define __KVM_X86_TDX_ERRNO_H
+
+#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
+
+/*
+ * TDX SEAMCALL Status Codes (returned in RAX)
+ */
+#define TDX_SUCCESS				0x0000000000000000ULL
+#define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
+#define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
+#define TDX_OPERAND_BUSY			0x8000020000000000ULL
+#define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
+#define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
+#define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
+#define TDX_KEY_CONFIGURED			0x0000081500000000ULL
+#define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000ULL
+#define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
+
+/*
+ * TDG.VP.VMCALL Status Codes (returned in R10)
+ */
+#define TDG_VP_VMCALL_SUCCESS			0x0000000000000000ULL
+#define TDG_VP_VMCALL_RETRY			0x0000000000000001ULL
+#define TDG_VP_VMCALL_INVALID_OPERAND		0x8000000000000000ULL
+#define TDG_VP_VMCALL_TDREPORT_FAILED		0x8000000000000001ULL
+
+/*
+ * TDX module operand ID, appears in 31:0 part of error code as
+ * detail information
+ */
+#define TDX_OPERAND_ID_RCX			0x01
+#define TDX_OPERAND_ID_SEPT			0x92
+
+#endif /* __KVM_X86_TDX_ERRNO_H */
-- 
2.25.1

