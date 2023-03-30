Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEC06D0C6E
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjC3ROC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjC3RN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:13:58 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2057.outbound.protection.outlook.com [40.92.52.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F18B26BA
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:13:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwWX6cJGrh4MsOwme28nPYP3ij282TC7Ub7VWxh+fR5BC6HNWXCMigclkHSm4aglW0ccS+xVQIOXEwI73uJulqACuKsxsTHIQ3zO1CBM3lbUvnqdrl7MSZHerJk5DbBtV8JL4huJFBF2+fCOr+KCYY0eNKenTteP06cY+u3EpKFcMaF+tVljUI9mnjQnLO4f86uAQCKwCsQ8TkUxjVL/oFWMTHQnLkd7KZ1K8UDdFKZVL6IR7v8keJcNbw+NCn/azmoivF8S+4O+MyVncz3WL1bkNJfhUvhUEr+my9vQaFzwe38HkWzJSk2M5ggQfbB+9B9kX7dIcfOOLArlTXCuAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MDHqcmQRPGkUdd5Ety8ynIkDpC4OBcxd3mYN7rx0y9U=;
 b=XwhsomZi3tuQg9Smi44wJSAbFetSODPmO+Mm30Ald84oxxTOR1HQMK5QIKWcxpvs+PnCKKinbpKThLixlrw0ECygmddEKsvr4A6YSPXO95N2jkc8MudXOWsFZHkstovIHjVXynnI5xo5tWJoYNdhar34XkbTMreiwiYeTp+Z44VlOtSMX7rA/4vaQfnWyIOsJzOrjt6aWn6xK5E//CppWqIMRa3MOk5bYLp1wGy8H+IBZMwecmPop6vg+PPw4YaYlZNEKxHLiOUc0eeKxjll/njSwUSLbkhuAuZ2nZPknsNk8UNhtjEeoAxeR7lxAc0T5kucWsI6SCr1h5goe28i0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from TYZPR06MB5418.apcprd06.prod.outlook.com (2603:1096:400:202::7)
 by TY0PR06MB5331.apcprd06.prod.outlook.com (2603:1096:400:214::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 17:13:53 +0000
Received: from TYZPR06MB5418.apcprd06.prod.outlook.com
 ([fe80::1c39:fb04:b3c2:5a26]) by TYZPR06MB5418.apcprd06.prod.outlook.com
 ([fe80::1c39:fb04:b3c2:5a26%2]) with mapi id 15.20.6222.034; Thu, 30 Mar 2023
 17:13:53 +0000
From:   Yohei Kojima <y-koj@outlook.jp>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Yohei Kojima <y-koj@outlook.jp>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH v3 3/4] accel: replace strerror() function to the thread safe qemu_strerror()
Date:   Fri, 31 Mar 2023 02:13:21 +0900
Message-ID: <TYZPR06MB54184091F777130BFE71A8E99D8E9@TYZPR06MB5418.apcprd06.prod.outlook.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <TYZPR06MB5418D71BB6F2BBFD80C01E559D8E9@TYZPR06MB5418.apcprd06.prod.outlook.com>
References: <TYZPR06MB5418D71BB6F2BBFD80C01E559D8E9@TYZPR06MB5418.apcprd06.prod.outlook.com>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-TMN:  [vH8xj3oNC7xQ1H5dSxnWevjpAJ1zD1NOwxm3XHHcetexZkovbrXZN4/c4I9uAZ9Y]
X-ClientProxiedBy: TYCP286CA0133.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::20) To TYZPR06MB5418.apcprd06.prod.outlook.com
 (2603:1096:400:202::7)
X-Microsoft-Original-Message-ID: <62bcf6eee9f60dfad0c6fd878e350ee941b4baea.1680195348.git.y-koj@outlook.jp>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB5418:EE_|TY0PR06MB5331:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db8d1f7-076f-43ec-7f01-08db3142230c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZVJInF9G7VtDIjsZZJkngPjrvHkSS8X686rn4jhlLv2iOOQ/cGPduB6ZE97fQAnHStNwm8jcWhqt6HRmhAxLrIEP0AAedvZUhWLMbJWe3MmagEBVC6Rzt8cyJGk1+1yIHAx3AaWEz8fiIOW2FduL1dt2XHwRJX35tv+ME9hO29f0soGZqxpU01/FFWsMVlIbyfCyuq8kIb4ckykO/a3QloFzVkq3mmXBATT5l+LUKAFghHet1PedSShOuL5SNVoXdiYZCjzY38X1GxD/iARrEQKKBLBeEreUeBeKLK9BObVy9Z9f9lzjgtQGJo+wXdY57/47cCvs6H3Usf5Eh4fxHWBk1TfeZi7YWZmmop4ycCbfjZ6n8SAgBMH/Ud+4qtKwlElpjiF6Tu5MIvknEX3dPLO16180nKLGHwETirJeNFUzi+awmw+nMRRJuz97kVbFj3UxnMAIP9AQX8gyXyBGP/AWYLti+p+sy+poEPgyK7z6b4an7ppAsW2rsZ7zLC3ULoSQerUX3M5iT0m3ArHvLiGFYJGAUlku6fIl1UYqwzaLOdVHKNkKCvqE8YgE3B8NvwHuOUeeUKgjqudnZH/vZHjPHHJoorfgs3pOuj789ms=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5G3ns7+z71PqnY00gAp4d3FH3vJwbXlEiYZnOTp5gyS+qkmNdWtXWc32pvye?=
 =?us-ascii?Q?UtdWBB88cYDmUDnRXO8fJanq5gyoQU2kWIH+Jy+tg1CihkEA/gSmZfEzwNwx?=
 =?us-ascii?Q?Wo4GXdtzfxM2yyZxbSFvqJJKDpHXx7jDibyHuSM71Fgxxae3P6jU8qoJ/0MN?=
 =?us-ascii?Q?h8UJNFam3cjZdmZ6Ngwlu7AbrPqieTsmbztJPXogOvLpE7gYMiVSJeQTDdpH?=
 =?us-ascii?Q?PQoWjFhvUg8ElOKwZRp7mItN9hjXjvK4WXvDKFkLFgrqCs7eXODmBBASfSL1?=
 =?us-ascii?Q?46NTjbSdfHJT9zv2/8oce+KGIGBGoNP3HjXV8O3mmL6cgniBYl0HuyFA64Vy?=
 =?us-ascii?Q?i8rkJkfWfDDh/hkPS0gOjF3ZNNg50AOIgM6J6Wgkl/Hbknr8HkcI+FBOqfqM?=
 =?us-ascii?Q?jFI4GgKoAuZOOKkzX9rgYcYgq5t4Z/v+Y/S1tqNctiEOthhMDzuCvvxKq7AO?=
 =?us-ascii?Q?4kcz3Jp/0E2xbNi8xMXNmcSc2/4JZvfIbSW/sqSoTARGjztrn+lTH8MbGstg?=
 =?us-ascii?Q?BKB5qfWJsMGqeqbcIvWMqYPRLi0s8lgE1+aJemz9crzz7kcc1e08GKPZflDN?=
 =?us-ascii?Q?mRGaQJn37Zeurw9K99iwB8+cHblUvbYTchWEdsXOx6KJ2yAgAMire1P3lkUf?=
 =?us-ascii?Q?Jne+ijmzGK82OzNS843KmnuusJwoA9m3zSBAxDDDCZYFiZBYwafwhoutm5Bm?=
 =?us-ascii?Q?2JCWP1O7lQQfkks59aWiNmCAS0RKNW4hwGEh7jIW+uGAMyyTgGDk3qUpPRJi?=
 =?us-ascii?Q?S4jrvY5RdhMrJQ45B3LSJjcz2dzkm1oSurUrlw46UAhNgIsKeNR4QAQZ3RTl?=
 =?us-ascii?Q?Njq+yrG453b2bBpjvecV39o4nKpatE/zUSSZNsNRRnvJdxTnCgDbdk6jAciY?=
 =?us-ascii?Q?R0bIJSOz751jOlNP83YfHWNNAESSxjvIjZWiaGAPYTBhF6TQXrWcDj9Ezk7K?=
 =?us-ascii?Q?owYQwvwXdp8FxjibBPfQOcx5MO54gkMVswWo2l2lPhy2hVkAxdEaDpLbcKGs?=
 =?us-ascii?Q?phyNfVehz/qN+lLIOb9EoQWcbR4Gh++M9CgkkuLjPqY/eUyuwbFqoIRleKZK?=
 =?us-ascii?Q?mYi/QlOtdNRZVOD90bqX3aDZs4ycrJ3gXYIDknkr3voeODVKKhfe4E0imSFM?=
 =?us-ascii?Q?cjflmRZqd9KafGwLncEHDIKdRla1FvZp9LPAYzndnreuZACM5P/lYK+HsEKd?=
 =?us-ascii?Q?TeD6xaz4ZEZlOMVko1zCTCdhEK2nLdA/Jub/7CJLopi1Nxry9LU0Y+Wqzwos?=
 =?us-ascii?Q?IQdYEs8AlTeaBWqHf7jInfSo9gs1+pyZz33lomvNWw=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-3208f.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db8d1f7-076f-43ec-7f01-08db3142230c
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB5418.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 17:13:52.9980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5331
X-Spam-Status: No, score=-0.0 required=5.0 tests=FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

strerror() is not guaranteed to be thread-safe as described in
(https://gitlab.com/qemu-project/qemu/-/issues/416).

This commit changes files under /accel that call strerror() to call
the safer qemu_strerror().

Signed-off-by: Yohei Kojima <y-koj@outlook.jp>
---
 accel/kvm/kvm-all.c | 32 ++++++++++++++++++--------------
 accel/tcg/cputlb.c  |  3 ++-
 accel/tcg/perf.c    |  7 ++++---
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f2a6ea6a68..b3dc7743db 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -22,6 +22,7 @@
 #include "qemu/atomic.h"
 #include "qemu/option.h"
 #include "qemu/config-file.h"
+#include "qemu/cutils.h"
 #include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "hw/pci/msi.h"
@@ -315,7 +316,7 @@ err:
         error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
                      " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
                      __func__, mem.slot, slot->start_addr,
-                     (uint64_t)mem.memory_size, strerror(errno));
+                     (uint64_t)mem.memory_size, qemu_strerror(errno));
     }
     return ret;
 }
@@ -1366,7 +1367,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
             err = kvm_set_user_memory_region(kml, mem, false);
             if (err) {
                 fprintf(stderr, "%s: error unregistering slot: %s\n",
-                        __func__, strerror(-err));
+                        __func__, qemu_strerror(-err));
                 abort();
             }
             start_addr += slot_size;
@@ -1389,7 +1390,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
         err = kvm_set_user_memory_region(kml, mem, true);
         if (err) {
             fprintf(stderr, "%s: error registering slot: %s\n", __func__,
-                    strerror(-err));
+                    qemu_strerror(-err));
             abort();
         }
         start_addr += slot_size;
@@ -1613,7 +1614,7 @@ static void kvm_mem_ioeventfd_add(MemoryListener *listener,
                                match_data);
     if (r < 0) {
         fprintf(stderr, "%s: error adding ioeventfd: %s (%d)\n",
-                __func__, strerror(-r), -r);
+                __func__, qemu_strerror(-r), -r);
         abort();
     }
 }
@@ -1649,7 +1650,7 @@ static void kvm_io_ioeventfd_add(MemoryListener *listener,
                               match_data);
     if (r < 0) {
         fprintf(stderr, "%s: error adding ioeventfd: %s (%d)\n",
-                __func__, strerror(-r), -r);
+                __func__, qemu_strerror(-r), -r);
         abort();
     }
 }
@@ -1668,7 +1669,7 @@ static void kvm_io_ioeventfd_del(MemoryListener *listener,
                               match_data);
     if (r < 0) {
         fprintf(stderr, "%s: error deleting ioeventfd: %s (%d)\n",
-                __func__, strerror(-r), -r);
+                __func__, qemu_strerror(-r), -r);
         abort();
     }
 }
@@ -2278,7 +2279,8 @@ static void kvm_irqchip_create(KVMState *s)
     } else if (kvm_check_extension(s, KVM_CAP_S390_IRQCHIP)) {
         ret = kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0);
         if (ret < 0) {
-            fprintf(stderr, "Enable kernel irqchip failed: %s\n", strerror(-ret));
+            fprintf(stderr, "Enable kernel irqchip failed: %s\n",
+                    qemu_strerror(-ret));
             exit(1);
         }
     } else {
@@ -2297,7 +2299,8 @@ static void kvm_irqchip_create(KVMState *s)
         }
     }
     if (ret < 0) {
-        fprintf(stderr, "Create kernel irqchip failed: %s\n", strerror(-ret));
+        fprintf(stderr, "Create kernel irqchip failed: %s\n",
+                qemu_strerror(-ret));
         exit(1);
     }
 
@@ -2446,7 +2449,7 @@ static int kvm_init(MachineState *ms)
 
     if (ret < 0) {
         fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
-                strerror(-ret));
+                qemu_strerror(-ret));
 
 #ifdef TARGET_S390X
         if (ret == -EINVAL) {
@@ -2532,7 +2535,8 @@ static int kvm_init(MachineState *ms)
             ret = kvm_vm_enable_cap(s, KVM_CAP_DIRTY_LOG_RING, 0, ring_bytes);
             if (ret) {
                 error_report("Enabling of KVM dirty ring failed: %s. "
-                             "Suggested minimum value is 1024.", strerror(-ret));
+                             "Suggested minimum value is 1024.",
+                             qemu_strerror(-ret));
                 goto err;
             }
 
@@ -2949,7 +2953,7 @@ int kvm_cpu_exec(CPUState *cpu)
                 break;
             }
             fprintf(stderr, "error: kvm run failed %s\n",
-                    strerror(-run_ret));
+                    qemu_strerror(-run_ret));
 #ifdef TARGET_PPC
             if (run_ret == -EBUSY) {
                 fprintf(stderr,
@@ -3455,7 +3459,7 @@ void kvm_init_cpu_signals(CPUState *cpu)
         r = kvm_set_signal_mask(cpu, &set);
     }
     if (r) {
-        fprintf(stderr, "kvm_set_signal_mask: %s\n", strerror(-r));
+        fprintf(stderr, "kvm_set_signal_mask: %s\n", qemu_strerror(-r));
         exit(1);
     }
 }
@@ -3538,7 +3542,7 @@ int kvm_set_one_reg(CPUState *cs, uint64_t id, void *source)
     reg.addr = (uintptr_t) source;
     r = kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
     if (r) {
-        trace_kvm_failed_reg_set(id, strerror(-r));
+        trace_kvm_failed_reg_set(id, qemu_strerror(-r));
     }
     return r;
 }
@@ -3552,7 +3556,7 @@ int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target)
     reg.addr = (uintptr_t) target;
     r = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
     if (r) {
-        trace_kvm_failed_reg_get(id, strerror(-r));
+        trace_kvm_failed_reg_get(id, qemu_strerror(-r));
     }
     return r;
 }
diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
index e984a98dc4..6cf888cdf1 100644
--- a/accel/tcg/cputlb.c
+++ b/accel/tcg/cputlb.c
@@ -40,6 +40,7 @@
 #include "qemu/plugin-memory.h"
 #endif
 #include "tcg/tcg-ldst.h"
+#include "qemu/cutils.h"
 
 /* DEBUG defines, enable DEBUG_TLB_LOG to log to the CPU_LOG_MMU target */
 /* #define DEBUG_TLB */
@@ -215,7 +216,7 @@ static void tlb_mmu_resize_locked(CPUTLBDesc *desc, CPUTLBDescFast *fast,
      */
     while (fast->table == NULL || desc->fulltlb == NULL) {
         if (new_size == (1 << CPU_TLB_DYN_MIN_BITS)) {
-            error_report("%s: %s", __func__, strerror(errno));
+            error_report("%s: %s", __func__, qemu_strerror(errno));
             abort();
         }
         new_size = MAX(new_size >> 1, 1 << CPU_TLB_DYN_MIN_BITS);
diff --git a/accel/tcg/perf.c b/accel/tcg/perf.c
index 65e35ea3b9..0c7a3a8822 100644
--- a/accel/tcg/perf.c
+++ b/accel/tcg/perf.c
@@ -13,6 +13,7 @@
 #include "exec/exec-all.h"
 #include "qemu/timer.h"
 #include "tcg/tcg.h"
+#include "qemu/cutils.h"
 
 #include "debuginfo.h"
 #include "perf.h"
@@ -54,7 +55,7 @@ void perf_enable_perfmap(void)
     perfmap = safe_fopen_w(map_file);
     if (perfmap == NULL) {
         warn_report("Could not open %s: %s, proceeding without perfmap",
-                    map_file, strerror(errno));
+                    map_file, qemu_strerror(errno));
     }
 }
 
@@ -201,7 +202,7 @@ void perf_enable_jitdump(void)
     jitdump = safe_fopen_w(jitdump_file);
     if (jitdump == NULL) {
         warn_report("Could not open %s: %s, proceeding without jitdump",
-                    jitdump_file, strerror(errno));
+                    jitdump_file, qemu_strerror(errno));
         return;
     }
 
@@ -214,7 +215,7 @@ void perf_enable_jitdump(void)
                        MAP_PRIVATE, fileno(jitdump), 0);
     if (perf_marker == MAP_FAILED) {
         warn_report("Could not map %s: %s, proceeding without jitdump",
-                    jitdump_file, strerror(errno));
+                    jitdump_file, qemu_strerror(errno));
         fclose(jitdump);
         jitdump = NULL;
         return;
-- 
2.39.2

