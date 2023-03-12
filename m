Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6A86B648F
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjCLJ71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCLJ7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2C618A85
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615088; x=1710151088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IjKVgrMEdx17LcOGt0GrvahqLKCh6n+MHrfFP/lxgG4=;
  b=YHXpCXw3L/68BFYpSiEaOe8bAzikgcoBGeE9jgdtQVb3uetpjbXcWWLS
   gFbvw1fOigCOZX+/QLTv4QsrL+Bve7Ns6gksPSbqlORv1SnSo2aq85YtP
   Dco7R4XtaF4s+7NnxB1gXBBuD+lFzBANVPUeHqeYt+isacHp/YNR6pojM
   5NWXeaK/fC8wiE2QuB/3Cz7uuT5D4IfthdXgPW+B1TPIPEChm4aFr1dHe
   p9fyi/oCPH00/mDKVFnjFYieW2wQ1LkJfosqwySyKemh45OzC2n+mBMnj
   lZAVavxB7zjB5pHQIcklT6xv7XOtZ12+GyCM9PVhgm2LRzMXKzyFcpsfl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344681"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344681"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627296"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627296"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:51 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-6 01/13] pkvm: x86: Pre-define the maximum number of supported VMs
Date:   Mon, 13 Mar 2023 02:03:33 +0800
Message-Id: <20230312180345.1778588-2-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180345.1778588-1-jason.cj.chen@intel.com>
References: <20230312180345.1778588-1-jason.cj.chen@intel.com>
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

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

Define the maximum number of the VMs pKVM can support. pKVM needs
reserve related memory based on the VM number it support (e.g., shadow
EPT page table pages). The reserved memory size for pKVM is calculated
then exposed to pkvm_init through pkvm_constants definition
PKVM_MAX_VM_NUM.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c       | 2 +-
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h   | 3 +++
 arch/x86/kvm/vmx/pkvm/pkvm_constants.c | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
index 9efedba2b3c9..25904252d2dd 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
@@ -10,7 +10,7 @@
 
 struct pkvm_hyp *pkvm_hyp;
 
-#define MAX_SHADOW_VMS	255
+#define MAX_SHADOW_VMS	(PKVM_MAX_NORMAL_VM_NUM + PKVM_MAX_PROTECTED_VM_NUM)
 #define HANDLE_OFFSET 1
 
 #define to_shadow_vm_handle(vcpu_handle)	((s64)(vcpu_handle) >> SHADOW_VM_HANDLE_SHIFT)
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
index 82a59b5d7fd5..b7c3f8c478b4 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -7,6 +7,9 @@
 
 #include <asm/pkvm_spinlock.h>
 
+#define PKVM_MAX_NORMAL_VM_NUM		8
+#define PKVM_MAX_PROTECTED_VM_NUM	2
+
 /*
  * A container for the vcpu state that hyp needs to maintain for protected VMs.
  */
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_constants.c b/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
index c6dc35b52664..6222a8fff6af 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
@@ -15,5 +15,6 @@ int main(void)
 	DEFINE(PKVM_VMEMMAP_ENTRY_SIZE, sizeof(struct hyp_page));
 	DEFINE(PKVM_SHADOW_VM_SIZE, sizeof(struct pkvm_shadow_vm) + pkvm_shadow_vcpu_array_size());
 	DEFINE(PKVM_SHADOW_VCPU_STATE_SIZE, sizeof(struct shadow_vcpu_state));
+	DEFINE(PKVM_MAX_VM_NUM, PKVM_MAX_NORMAL_VM_NUM + PKVM_MAX_PROTECTED_VM_NUM);
 	return 0;
 }
-- 
2.25.1

