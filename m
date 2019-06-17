Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0A48AF4
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 19:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfFQR6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 13:58:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbfFQR6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 13:58:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HHrnVP147796;
        Mon, 17 Jun 2019 17:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=Q6dVMQo7+PTAndQ8uOguG2f51evVBWGjsKLAeynozxw=;
 b=oC7JTd6CLxDA7ypw5bglLbStGHdeWBUQkb8cOTevYCY7GrXcdzrwD1AnqaAtB3xdY4qn
 YnzveUr4wAHyNTch+7jcOjW9NoPYKLMjfWCRGYI6tN+ABUVk0IWxGOoJpZ1rGGsfpgb8
 7ozhwacwTrFRjm2xFAipSMSECRmp1/4IgaWns+5e3UEOsvFwDuqhHAg2ebCUSESEhE88
 NyaE0j5+BoYdTyrD1MB/lLsxQgvDwtMErAh/3U88OWJGE7jkIWLNqfnSMSyp/+GkXkZd
 +7WCGzRuKeNpeUFsTaWuiN6EHutqKWvxAExVRDtZGCysj2zfP/NqIbaoncyzF/pml6Aa pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t4saq7w47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 17:57:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HHvWaY130537;
        Mon, 17 Jun 2019 17:57:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t59gdc0j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 17:57:33 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5HHvWT5002623;
        Mon, 17 Jun 2019 17:57:32 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 10:57:32 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, kvm@vger.kernel.org, jmattson@google.com,
        maran.wilson@oracle.com, dgilbert@redhat.com,
        Liran Alon <liran.alon@oracle.com>
Subject: [QEMU PATCH v3 4/9] KVM: i386: Block migration for vCPUs exposed with nested virtualization
Date:   Mon, 17 Jun 2019 20:56:53 +0300
Message-Id: <20190617175658.135869-5-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190617175658.135869-1-liran.alon@oracle.com>
References: <20190617175658.135869-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170160
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
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 target/i386/cpu.c |  6 ------
 target/i386/cpu.h | 24 ++++++++++++++++++++++++
 target/i386/kvm.c | 12 ++++++------
 3 files changed, 30 insertions(+), 12 deletions(-)

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
index fce6660bac00..79d9495ceb0c 100644
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
 
@@ -1866,6 +1873,23 @@ static inline int32_t x86_get_a20_mask(CPUX86State *env)
     }
 }
 
+static inline bool cpu_has_vmx(CPUX86State *env)
+{
+    return (IS_INTEL_CPU(env) &&
+            (env->features[FEAT_1_ECX] & CPUID_EXT_VMX));
+}
+
+static inline bool cpu_has_svm(CPUX86State *env)
+{
+    return (IS_AMD_CPU(env) &&
+            (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM));
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
index c8fd53055d37..f43e2d69859e 100644
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
-- 
2.20.1

