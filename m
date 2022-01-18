Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F7D491C2E
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 04:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbiARDOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 22:14:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:50866 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345345AbiARDDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 22:03:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642475028; x=1674011028;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cNbQxVyCs4XEuxaNikdfZkGDSRScRmZ3aVi6FBmdIH8=;
  b=WreKUbXpnjChNq0EswFuuoMDTkAB1+nuP1JZpTMLGMO4pE2kZUWMatb+
   yGsMhV7oYcNIzpPUe1QgZQqOoI0XxcjMj8NPIU5KyHZxYxailf8L+OhxD
   zG6k/Ls96+SvlzAuR8JZpE5Vt5H15po+aqpgxY86xbeqroZi6mzFwsw0w
   4LVl7keoVQPcGbfKiO6lBNvUJcQGOGEw3V5EwG308TljAXpFOjxFx1vMk
   HbLgA/FVMtjjyNojOYrHaARVlhu6C4gVS81whMNP18i0XUyMhy4QCCgWx
   QnCIBqF57asVKgs1UE8sofUvRbslxrRuaJI/cP1/X2IwkkXlZYf3nTEeN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="232085919"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="232085919"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 19:03:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="693245257"
Received: from devel-wwang.sh.intel.com ([10.239.48.106])
  by orsmga005.jf.intel.com with ESMTP; 17 Jan 2022 19:03:43 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     scgl@linux.ibm.com, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, guang.zeng@intel.com,
        jing2.liu@intel.com, yang.zhong@intel.com, tglx@linutronix.de,
        kevin.tian@intel.com, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH] kvm: selftests: conditionally build vm_xsave_req_perm()
Date:   Mon, 17 Jan 2022 20:48:17 -0500
Message-Id: <20220118014817.30910-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vm_xsave_req_perm() is currently defined and used by x86_64 only.
Make it compiled into vm_create_with_vcpus() only when on x86_64
machines. Otherwise, it would cause linkage errors, e.g. on s390x.

Fixes: 415a3c33e8 ("kvm: selftests: Add support for KVM_CAP_XSAVE2")
Reported-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4a645dc77f34..c22a17aac6b0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -393,10 +393,12 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 	struct kvm_vm *vm;
 	int i;
 
+#ifdef __x86_64__
 	/*
 	 * Permission needs to be requested before KVM_SET_CPUID2.
 	 */
 	vm_xsave_req_perm();
+#endif
 
 	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
 	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)
-- 
2.25.1

