Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2416D396F83
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhFAIvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:51:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:45208 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233819AbhFAIur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:50:47 -0400
IronPort-SDR: qWiThMF1Ui27T+8VRVn/9wxtMElVWdL9ZaFWJ8HGEPCp38gesvVtnpdxjlusbYp6P9dPsEC5XH
 Vq/RG9OIpnbQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381467"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381467"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:33 -0700
IronPort-SDR: pcY6ZVRYCG3AIXdG+E7mH60EuWfF95mcW3CLBxPGNBbu0wDKDpKok1w38XReVN4oTNQKHzw7Zv
 sz2c0c8l9FOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967839"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:30 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 12/15] kvm/vmx/vmcs12: Add Tertiary VM-Exec control field in vmcs12
Date:   Tue,  1 Jun 2021 16:47:51 +0800
Message-Id: <1622537274-146420-13-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmcs12.c | 1 +
 arch/x86/kvm/vmx/vmcs12.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 034adb6..717e63a 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -51,6 +51,7 @@
 	FIELD64(VMWRITE_BITMAP, vmwrite_bitmap),
 	FIELD64(XSS_EXIT_BITMAP, xss_exit_bitmap),
 	FIELD64(ENCLS_EXITING_BITMAP, encls_exiting_bitmap),
+	FIELD64(TERTIARY_VM_EXEC_CONTROL, tertiary_vm_exec_control),
 	FIELD64(GUEST_PHYSICAL_ADDRESS, guest_physical_address),
 	FIELD64(VMCS_LINK_POINTER, vmcs_link_pointer),
 	FIELD64(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 1349495..ec901b6 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -70,7 +70,8 @@ struct __packed vmcs12 {
 	u64 eptp_list_address;
 	u64 pml_address;
 	u64 encls_exiting_bitmap;
-	u64 padding64[2]; /* room for future expansion */
+	u64 tertiary_vm_exec_control;
+	u64 padding64[1]; /* room for future expansion */
 	/*
 	 * To allow migration of L1 (complete with its L2 guests) between
 	 * machines of different natural widths (32 or 64 bit), we cannot have
@@ -258,6 +259,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(eptp_list_address, 304);
 	CHECK_OFFSET(pml_address, 312);
 	CHECK_OFFSET(encls_exiting_bitmap, 320);
+	CHECK_OFFSET(tertiary_vm_exec_control, 328);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
-- 
1.8.3.1

