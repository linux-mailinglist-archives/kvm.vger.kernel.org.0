Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872F7615733
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 03:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiKBCBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 22:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiKBCBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 22:01:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22D012ACA
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 19:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667354505; x=1698890505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PjMOc4GJkjR6HD0QRsUjdCVVQuo5/3q1FOwCwvl6D4U=;
  b=SA6+u1K0WlYu++W/q0PQuHrNetumz2NgKYMvUVBaGoz2yLjV9Vp6DwKg
   4DLkC6bAQFhTMiQ1dqaHPk9YOC9WExCYC468PCqtMx6CkTpTsf5lGatAQ
   ImvtnUfVv+cw6wbujD+Gpu0sKA/riDN+7k2CDBsa35dG1auk1B27CiVRa
   lk6gWFImvbJFrvrETsH50JTMRkbXj5PDykeEvK1dWwsjkj52MhmfYjQSf
   1xUpV1p/DLmmDU4MzxBVELkikSO5HMum+U/4N+6BdqAxW6GFGXfiorzd2
   Yek58STWjteqY8KAXjIGjGcCg8oF7bztdgWB16EXtQfGGInPVFNILYLls
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="289676978"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="289676978"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 19:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="667405999"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="667405999"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 01 Nov 2022 19:01:44 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, gshan@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC 1/1] KVM: selftests: rseq_test: use vdso_getcpu() instead of syscall()
Date:   Wed,  2 Nov 2022 10:01:28 +0800
Message-Id: <20221102020128.3030511-2-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221102020128.3030511-1-robert.hu@linux.intel.com>
References: <20221102020128.3030511-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vDSO getcpu() has been in Kernel since 2.6.19, which we can assume
generally available.
Use vDSO getcpu() to reduce the overhead, so that vcpu thread stalls less
therefore can have more odds to hit the race condition.

Fixes: 0fcc102923de ("KVM: selftests: Use getcpu() instead of sched_getcpu() in rseq_test")
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 32 ++++++++++++++++++-------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 6f88da7e60be..0b68a6b19b31 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -42,15 +42,29 @@ static void guest_code(void)
 }
 
 /*
- * We have to perform direct system call for getcpu() because it's
- * not available until glic 2.29.
+ * getcpu() was added in kernel 2.6.19. glibc support wasn't there
+ * until glibc 2.29.
+ * We can direct call it from vdso to ease gblic dependency.
+ *
+ * vdso manipulation code refers from selftests/x86/test_vsyscall.c
  */
-static void sys_getcpu(unsigned *cpu)
-{
-	int r;
+typedef long (*getcpu_t)(unsigned *, unsigned *, void *);
+static getcpu_t vdso_getcpu;
 
-	r = syscall(__NR_getcpu, cpu, NULL, NULL);
-	TEST_ASSERT(!r, "getcpu failed, errno = %d (%s)", errno, strerror(errno));
+static void init_vdso(void)
+{
+	void *vdso = dlopen("linux-vdso.so.1", RTLD_LAZY | RTLD_LOCAL |
+			    RTLD_NOLOAD);
+	if (!vdso)
+		vdso = dlopen("linux-gate.so.1", RTLD_LAZY | RTLD_LOCAL |
+			      RTLD_NOLOAD);
+	if (!vdso)
+		TEST_ASSERT(!vdso, "failed to find vDSO\n");
+
+	vdso_getcpu = (getcpu_t)dlsym(vdso, "__vdso_getcpu");
+	if (!vdso_getcpu)
+		TEST_ASSERT(!vdso_getcpu,
+			    "failed to find __vdso_getcpu in vDSO\n");
 }
 
 static int next_cpu(int cpu)
@@ -205,6 +219,8 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	u32 cpu, rseq_cpu;
 
+	init_vdso();
+
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
@@ -253,7 +269,7 @@ int main(int argc, char *argv[])
 			 * across the seq_cnt reads.
 			 */
 			smp_rmb();
-			sys_getcpu(&cpu);
+			vdso_getcpu(&cpu, NULL, NULL);
 			rseq_cpu = rseq_current_cpu_raw();
 			smp_rmb();
 		} while (snapshot != atomic_read(&seq_cnt));
-- 
2.31.1

