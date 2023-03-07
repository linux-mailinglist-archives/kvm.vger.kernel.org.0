Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A3A6AE163
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 14:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjCGNxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 08:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjCGNxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 08:53:09 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A770B83888;
        Tue,  7 Mar 2023 05:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678197158; x=1709733158;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sQ7LWgB/6JVGYkKwEe+WCyTFEuM/QI03P1Yc2gqbCAg=;
  b=DsEKCHkffa/VMJPmZfwtfWKapbE3Q+Ep0Jmie9MnOokls+JwHn5aOne7
   hpVyrfMXaJwKbGFFfeNoC3NLr6xbsUHnJoF61LJ1aUKIwuihTmbo7Cc/o
   KSI2VOf1hjidNPZiUAG1LcWc0udParN6p7Co/H8fvo31WoL3Qp2XnxEDi
   KFoOWfPsbHSKM2md0GtkWD4HfeiANrdu+PfWYGxiasjA/DCxaOPPoKCuT
   KKwRR6FP5Fu1FqWqN2QYx6VMYLY7jimkdcxS5h9DUiaEaYUHVaKFJMUwX
   WU2xOR09tpPYCnBQuBE4LDoAM3SadLLfqi9/rSe475H9goybJP4MyGL8m
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="400675435"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="400675435"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 05:52:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="626551621"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="626551621"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orsmga003.jf.intel.com with ESMTP; 07 Mar 2023 05:52:35 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, dmatlack@google.com, mizhang@google.com,
        isaku.yamahata@gmail.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Date:   Tue,  7 Mar 2023 21:52:33 +0800
Message-Id: <20230307135233.54684-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current KVM_BUG and KVM_BUG_ON assume that 'cond' passed from callers is
32-bit as it casts 'cond' to the type of int. This will be wrong if 'cond'
provided by a caller is 64-bit, e.g. an error code of 0xc0000d0300000000
will be converted to 0, which is not expected.

Improves the implementation by using bool in KVM_BUG and KVM_BUG_ON.
'bool' is preferred to 'int' as __ret is essentially used as a boolean
and coding-stytle.rst documents that use of bool is encouraged to improve
readability and is often a better option than 'int' for storing boolean
values.

Fixes: 0b8f11737cff ("KVM: Add infrastructure and macro to mark VM as bugged")
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 include/linux/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f06635b24bd0..0221a48b3e3d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -881,7 +881,7 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
 
 #define KVM_BUG(cond, kvm, fmt...)				\
 ({								\
-	int __ret = (cond);					\
+	bool __ret = !!(cond);					\
 								\
 	if (WARN_ONCE(__ret && !(kvm)->vm_bugged, fmt))		\
 		kvm_vm_bugged(kvm);				\
@@ -890,7 +890,7 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
 
 #define KVM_BUG_ON(cond, kvm)					\
 ({								\
-	int __ret = (cond);					\
+	bool __ret = !!(cond);					\
 								\
 	if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))		\
 		kvm_vm_bugged(kvm);				\
-- 
2.27.0

