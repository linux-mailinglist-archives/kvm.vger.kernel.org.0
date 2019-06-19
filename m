Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56924BDF8
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 18:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbfFSQXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 12:23:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729670AbfFSQXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 12:23:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JGDiCv030793;
        Wed, 19 Jun 2019 16:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=5+VDtEHpYCvXTvJzElp/9F5GUAkU9Kk5VcCDhZwomMI=;
 b=FxzokixQ03Pj1zbmRAjnhM3BdKOVjkDlE8xNcYqSg5v4PlJ5VbqGsToZCDJPtuBgSuOn
 OfFdZ4aqQk2RK7WgWGibmb7kP/bllezYP0IuiTc2p5EshwG014HxPJ8mb/VWnSE2d7cR
 /xvYPyvgFYc19aEuiqEzgZVnyO66K7BqZQXhEuqrT4EkIGy+VBthkrl1YxJasHT+Fq2B
 Zseyby1AOk8WjKwokOWmXUJju7LXr6A0sTAAHMEpezWsnjveiTF/P5Lw45NImSKVnNlE
 +m9a4PX7u2zEi2VQucZ37woPdx4eeqMNV+F2ONp/CULOVvUz7uOsE0LZTtccllNyCNsB HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t7809cem3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 16:22:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JGLEHp187176;
        Wed, 19 Jun 2019 16:22:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2t77yn6nxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 16:22:15 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5JGMEMO024652;
        Wed, 19 Jun 2019 16:22:14 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 09:22:14 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, kvm@vger.kernel.org, jmattson@google.com,
        maran.wilson@oracle.com, dgilbert@redhat.com,
        Liran Alon <liran.alon@oracle.com>
Subject: [QEMU PATCH v4 05/10] target/i386: kvm: Block migration for vCPUs exposed with nested virtualization
Date:   Wed, 19 Jun 2019 19:21:35 +0300
Message-Id: <20190619162140.133674-6-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619162140.133674-1-liran.alon@oracle.com>
References: <20190619162140.133674-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit d98f26073beb ("target/i386: kvm: add VMX migration blocker")
added a migration blocker for vCPU exposed with Intel VMX.
However, migration should also be blocked for vCPU exposed with
AMD SVM.

Both cases should be blocked because QEMU should extract additional
vCPU state from KVM that should be migrated as part of vCPU VMState.
E.g. Whether vCPU is running in guest-mode or host-mode.

Fixes: d98f26073beb ("target/i386: kvm: add VMX migration blocker")
Reviewed-by: Maran Wilson <maran.wilson@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 target/i386/cpu.c |  6 ------
 target/i386/cpu.h | 22 ++++++++++++++++++++++
 target/i386/kvm.c | 14 +++++++-------
 3 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 536d7d152044..197201087e65 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5170,12 +5170,6 @@ static int x86_cpu_filter_features(X86CPU *cpu)
     return rv;
 }
 
-#define IS_INTEL_CPU(env) ((env)->cpuid_vendor1 == CPUID_VENDOR_INTEL_1 && \
-                           (env)->cpuid_vendor2 == CPUID_VENDOR_INTEL_2 && \
-                           (env)->cpuid_vendor3 == CPUID_VENDOR_INTEL_3)
-#define IS_AMD_CPU(env) ((env)->cpuid_vendor1 == CPUID_VENDOR_AMD_1 && \
-                         (env)->cpuid_vendor2 == CPUID_VENDOR_AMD_2 && \
-                         (env)->cpuid_vendor3 == CPUID_VENDOR_AMD_3)
 static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index fce6660bac00..64bb7fdcb231 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -728,6 +728,13 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
 
 #define CPUID_VENDOR_HYGON    "HygonGenuine"
 
+#define IS_INTEL_CPU(env) ((env)->cpuid_vendor1 == CPUID_VENDOR_INTEL_1 && \
+                           (env)->cpuid_vendor2 == CPUID_VENDOR_INTEL_2 && \
+                           (env)->cpuid_vendor3 == CPUID_VENDOR_INTEL_3)
+#define IS_AMD_CPU(env) ((env)->cpuid_vendor1 == CPUID_VENDOR_AMD_1 && \
+                         (env)->cpuid_vendor2 == CPUID_VENDOR_AMD_2 && \
+                         (env)->cpuid_vendor3 == CPUID_VENDOR_AMD_3)
+
 #define CPUID_MWAIT_IBE     (1U << 1) /* Interrupts can exit capability */
 #define CPUID_MWAIT_EMX     (1U << 0) /* enumeration supported */
 
@@ -1866,6 +1873,21 @@ static inline int32_t x86_get_a20_mask(CPUX86State *env)
     }
 }
 
+static inline bool cpu_has_vmx(CPUX86State *env)
+{
+    return (env->features[FEAT_1_ECX] & CPUID_EXT_VMX);
+}
+
+static inline bool cpu_has_svm(CPUX86State *env)
+{
+    return (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM);
+}
+
+static inline bool cpu_has_nested_virt(CPUX86State *env)
+{
+    return (cpu_has_vmx(env) || cpu_has_svm(env));
+}
+
 /* fpu_helper.c */
 void update_fp_status(CPUX86State *env);
 void update_mxcsr_status(CPUX86State *env);
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index fa01f18b28f0..b2041ce5ec3c 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -906,7 +906,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
 }
 
 static Error *invtsc_mig_blocker;
-static Error *vmx_mig_blocker;
+static Error *nested_virt_mig_blocker;
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
@@ -1270,13 +1270,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
                                   !!(c->ecx & CPUID_EXT_SMX);
     }
 
-    if ((env->features[FEAT_1_ECX] & CPUID_EXT_VMX) && !vmx_mig_blocker) {
-        error_setg(&vmx_mig_blocker,
-                   "Nested VMX virtualization does not support live migration yet");
-        r = migrate_add_blocker(vmx_mig_blocker, &local_err);
+    if (cpu_has_nested_virt(env) && !nested_virt_mig_blocker) {
+        error_setg(&nested_virt_mig_blocker,
+                   "Nested virtualization does not support live migration yet");
+        r = migrate_add_blocker(nested_virt_mig_blocker, &local_err);
         if (local_err) {
             error_report_err(local_err);
-            error_free(vmx_mig_blocker);
+            error_free(nested_virt_mig_blocker);
             return r;
         }
     }
@@ -1347,7 +1347,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
  fail:
     migrate_del_blocker(invtsc_mig_blocker);
  fail2:
-    migrate_del_blocker(vmx_mig_blocker);
+    migrate_del_blocker(nested_virt_mig_blocker);
 
     return r;
 }
-- 
2.20.1

