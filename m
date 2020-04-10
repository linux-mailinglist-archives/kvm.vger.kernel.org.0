Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58FDA1A4C91
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgDJXRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:20811 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbgDJXRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:10 -0400
IronPort-SDR: IUrfL5n6FXBtaDOgVCNZRDYchVhfxiYlg4+kkvjwIyxZNlbJJ1SYJBMKQk+R2PwJxIiLBZyDQs
 k4V3qHI9HXrg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:10 -0700
IronPort-SDR: BwcLt5QGh5kMNt1wqqaSRoYMpzNagewl3mo7adf+zrWY7rB2o2KfIlmUNIBBy3CBQ5QzkAMmDW
 FmN6Oc9n38+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542229"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH 04/10] KVM: selftests: Add GUEST_ASSERT variants to pass values to host
Date:   Fri, 10 Apr 2020 16:17:01 -0700
Message-Id: <20200410231707.7128-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add variants of GUEST_ASSERT to pass values back to the host, e.g. to
help debug/understand a failure when the the cause of the assert isn't
necessarily binary.

It'd probably be possible to auto-calculate the number of arguments and
just have a single GUEST_ASSERT, but there are a limited number of
variants and silently eating arguments could lead to subtle code bugs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 25 +++++++++++++++----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index d4c3e4d9cd92..e38d91bd8ec1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -313,11 +313,26 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
-#define GUEST_ASSERT(_condition) do {			\
-	if (!(_condition))				\
-		ucall(UCALL_ABORT, 2,			\
-			"Failed guest assert: "		\
-			#_condition, __LINE__);		\
+#define __GUEST_ASSERT(_condition, _nargs, _args...) do {	\
+	if (!(_condition))					\
+		ucall(UCALL_ABORT, 2 + _nargs,			\
+			"Failed guest assert: "			\
+			#_condition, __LINE__, _args);		\
 } while (0)
 
+#define GUEST_ASSERT(_condition) \
+	__GUEST_ASSERT((_condition), 0, 0)
+
+#define GUEST_ASSERT_1(_condition, arg1) \
+	__GUEST_ASSERT((_condition), 1, (arg1))
+
+#define GUEST_ASSERT_2(_condition, arg1, arg2) \
+	__GUEST_ASSERT((_condition), 2, (arg1), (arg2))
+
+#define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
+	__GUEST_ASSERT((_condition), 3, (arg1), (arg2), (arg3))
+
+#define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
+	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
+
 #endif /* SELFTEST_KVM_UTIL_H */
-- 
2.26.0

