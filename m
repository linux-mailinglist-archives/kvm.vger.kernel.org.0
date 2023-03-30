Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E066D0C6F
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjC3ROD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjC3ROA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:14:00 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2057.outbound.protection.outlook.com [40.92.52.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83452526F
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xup6gnUagzRneR4yaqeu1d2gEWWnEQCbz//6o3WnZZM0rWBgJHcF3q3Bk9dG3D/832QcuVy79+j4Rwg9ItaD5m3pyQXbJn0WulYBnzJM7FnzHVsKYGHFI4Jd3gHL69bbflrTqg4qrRzCYwASDfWJJLgKlQmvwFY5hubbCpIQ7fZRX78nV3A29HyrjfKMDVN5j8/59EY5WBeycPL6/Wjj8h6n0mgIKchyPGdWbTDi90Unvrmqkoc5//QN3B69p0NX7qGkCT0X3yWZuIplB/1nia7G+ABRKnqVuQ9fdSulEuJ59Uh8BpY/Q9picvfdWp2ATiTCxv7ro3+zxhGZNn194w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fG5SDjiuVVhnlTF1nIrshKxcRESD8BJ2GE+gdl4vSUg=;
 b=eWarKXNyAXNXwn15o9yYb6edjZXe5RnMKAej2Rm9ASMZj6HkFtEHefOuAgczqpjhcQera3HMGCWsc2CvU0hrK6sxF1ECLKDwCpnQ7GYGjD6XsarRei7zuflyoiwJKxnwJJDgpu9sAv3/FCQ8fk90feM+LFtb+k/J+qNM1zlqdCNflc0sfLeT4O7bz73GHMKD+wLW0+KZeqSA0A7pL+OK2eP67b+gUkKSyKwQsC8RlHcSoCj8dW3c8LoYnKgqJvBdiOhZ422UHnGRTnTccsDqoUSCC7wOm5nDpbPGXF+wh6dE+CGrBq6ZCibq82ZioFI/eBIKZN2JGmnqO7nbrsefpQ==
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
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        kvm@vger.kernel.org (open list:X86 KVM CPUs)
Subject: [PATCH v3 4/4] target/i386: replace strerror() function to the thread safe qemu_strerror()
Date:   Fri, 31 Mar 2023 02:13:22 +0900
Message-ID: <TYZPR06MB5418EC16ECFE6A7C228786A89D8E9@TYZPR06MB5418.apcprd06.prod.outlook.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <TYZPR06MB5418D71BB6F2BBFD80C01E559D8E9@TYZPR06MB5418.apcprd06.prod.outlook.com>
References: <TYZPR06MB5418D71BB6F2BBFD80C01E559D8E9@TYZPR06MB5418.apcprd06.prod.outlook.com>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-TMN:  [UzUmQXPXUXzI9Crkq/QWU5gbtawtcj26GTvpBxxNX9+QaGbt7HV1TiV9FfOwAJSG]
X-ClientProxiedBy: TYCP286CA0133.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::20) To TYZPR06MB5418.apcprd06.prod.outlook.com
 (2603:1096:400:202::7)
X-Microsoft-Original-Message-ID: <4594055207c9fd24c2429059cd8b300b3675b93d.1680195348.git.y-koj@outlook.jp>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB5418:EE_|TY0PR06MB5331:EE_
X-MS-Office365-Filtering-Correlation-Id: 9081d0cd-54d5-4ddd-a555-08db3142234a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkJ0i8v9Kp7AMJp/JtNMzZpm4I8Z9+8uvl44+Xi5387v4AdlL5wANexy0azBV3wM1muGNu7UMc4FePNE2CGvQbOt/pCTqN36ifzuDkfvqOOVJQMM4DY+U3LZWq5GSKU7qZ35itE7Uvu49liFSr+IBSDhjmeW3t8nwzmoLqQm4WPUIE5TQ07aV4mRHi4wY5bZ9xWVfXaf3HoqNmU0+lzdtfsMSRruTCxT7leJcx8EVmPP1dbe9hQnPhQDtTBjaRfElIPM7caj1ly9g9SfySqlw0z1RGsDKMziXCjOsNBmlLB8amg3DeQ4sSIsg9zrClJjuMbdGPnzwcDpbfxjL6mpNxP39yo1o0zMVWaMXnF9+fff9m5Ho9tHrifgrOl3kPvkDvZPs1IZzokFET3zC/uWsED3+TSoI9xr7kAqCsjKb1gvubEN/Owy2yCUq0Unefxp5qBF4gpJDw8gnvYfnJpXyyvjw/GbUQ0uUKWM6RLK/H7c9aFHAeL8hhmUvxcsCZWHOz3ibuHLHo7EvkAwInsK+oXgsElfgrnDweqnIpNuJlWb206rRhJRuYE+ClgOz5JUXzQdsz3Wo5RvCMI1cwBsZEAiTWF5EutYxSv1DF4jG/8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bbuyvUCq37LdVMbBgefO3xx5JoRBFFDzUASGWhLom69e/nY/J0x33KTt8ycI?=
 =?us-ascii?Q?QygD7xl26Ag2JKnVA95i6ojfEF/5KvnU6WI1jHFLJnn2xNqmGpOmbi1Z9R3H?=
 =?us-ascii?Q?7tORjJqevjuvl17INHVr1HgOxM2DMnZCWDdspJP7GWrmQHOtYs3niOlOuKM5?=
 =?us-ascii?Q?4NEyi3GhEgrC8sd11f6go50CTXqwT/qhkiMSXNUP5m9iEYNW+Yh/dwpcoyQi?=
 =?us-ascii?Q?nCP/TQ2K0HHtiuH+pQlRoIsrSRHhP7JLOr3t2rTpB5M7FHT9zwYM91taZD8x?=
 =?us-ascii?Q?gZtMlX0RRD0CISk56pSLNgusVxlG+0l+ohRobd3+udN5t3H2+IybczglQP3J?=
 =?us-ascii?Q?rgsH2RtrQsOS3KrfsMCvodl8kccvzGMZVS+I8hS5+Y3hrl9gTgWTlzJhmHC3?=
 =?us-ascii?Q?9kfNhhe+LNQCgIuHONGoptP/jShs/8ExL2ztjWyqXC7BXitVjsSlu3+qfHev?=
 =?us-ascii?Q?M9D/S/iN+5q5IXSnf5LGpCk9PFwJmdh+tS+sSPGOreKqIZiv4BRJ7G2XOWWC?=
 =?us-ascii?Q?2A3hI+/s9KWkm4N7yadwDW4rB5HLjVzpC4yMVqRORCsx1oS7+CHlZBX7HDOm?=
 =?us-ascii?Q?3/+eC57f6piQEvJOE+6W6KEf76gdTtMHZoE0xKuoz9wJ+NzftLDU7PeANv6r?=
 =?us-ascii?Q?tpeH17A6ycICTJFm7RcQPkWpWexrihCjgdTSK73PMFLHXKhc6elcZhpZHrc/?=
 =?us-ascii?Q?SNTB1JOrTk46Ol8XF8BL6cUR1KrlcJG5ZI9Y8Ci3KT178t+gxw8ncMNROkPH?=
 =?us-ascii?Q?XpSALAgxTkJ4NN4c9tmafcmpa1qaeoBkHkQqIsuRnUn5EzS6H26vEyE/qQxE?=
 =?us-ascii?Q?yYTNRnJA7Ig8OjqYLS3QdRSl/apCxIP7JdAQAYDCsN+Kos5FRmNA9w+fPhEY?=
 =?us-ascii?Q?eTjfrCm56WWFpXNnZKzFSJ+YXYG9TzqhBdkZMOV1aUQYGBnVsyTnivl551sa?=
 =?us-ascii?Q?HxcqGNpMO3PElhmoWz6Ors6c6noVO1qx2XDlXQ9eZJ+vFmXkPOfZhBo/NRSo?=
 =?us-ascii?Q?yt9nvCyvd9WDPV+gbrr9b27fo9WupydN8W8U0Vp2x28iQdwbQwIjtuySdygw?=
 =?us-ascii?Q?8CEzA+7ZAIE5mSLZjiBCb43MyenpFVroGbaHspwWfXw6z2RIp43+8QyXYe0a?=
 =?us-ascii?Q?9rWS7UxzyUIP1hx78N1MlU/gJRSI7Um06uCqkyYWlM5qftO6GWGvW0aabmTq?=
 =?us-ascii?Q?AcS+nqJUBa8eY7E7AmPYb4bbIf6YcLCQ0t5XzqRdWpfmdNx+yK3elQJBygf2?=
 =?us-ascii?Q?O9XuZc0ytkqXA6rgrCUGPBPk45S5ZVJyy1+nEMuDDg=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-3208f.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 9081d0cd-54d5-4ddd-a555-08db3142234a
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB5418.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 17:13:53.3973
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

This commit changes files under /target/i386 that call strerror() to
call the safer qemu_strerror().

Signed-off-by: Yohei Kojima <y-koj@outlook.jp>
---
 target/i386/kvm/kvm.c             | 49 ++++++++++++++++---------------
 target/i386/kvm/xen-emu.c         |  7 +++--
 target/i386/nvmm/nvmm-accel-ops.c |  2 +-
 target/i386/sev.c                 |  5 ++--
 target/i386/whpx/whpx-accel-ops.c |  2 +-
 5 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index de531842f6..b31810f108 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -41,6 +41,7 @@
 #include "qemu/main-loop.h"
 #include "qemu/ratelimit.h"
 #include "qemu/config-file.h"
+#include "qemu/cutils.h"
 #include "qemu/error-report.h"
 #include "qemu/memalign.h"
 #include "hw/i386/x86.h"
@@ -275,7 +276,7 @@ static struct kvm_cpuid2 *try_get_cpuid(KVMState *s, int max)
             return NULL;
         } else {
             fprintf(stderr, "KVM_GET_SUPPORTED_CPUID failed: %s\n",
-                    strerror(-r));
+                    qemu_strerror(-r));
             exit(1);
         }
     }
@@ -519,7 +520,7 @@ uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index)
     ret = kvm_ioctl(s, KVM_GET_MSRS, &msr_data);
     if (ret != 1) {
         error_report("KVM get MSR (index=0x%x) feature failed, %s",
-            index, strerror(-ret));
+            index, qemu_strerror(-ret));
         exit(1);
     }
 
@@ -1055,7 +1056,7 @@ static struct kvm_cpuid2 *try_get_hv_cpuid(CPUState *cs, int max,
             return NULL;
         } else {
             fprintf(stderr, "KVM_GET_SUPPORTED_HV_CPUID failed: %s\n",
-                    strerror(-r));
+                    qemu_strerror(-r));
             exit(1);
         }
     }
@@ -1642,7 +1643,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
         ret = kvm_vcpu_enable_cap(cs, synic_cap, 0);
         if (ret < 0) {
             error_report("failed to turn on HyperV SynIC in KVM: %s",
-                         strerror(-ret));
+                         qemu_strerror(-ret));
             return ret;
         }
 
@@ -1650,7 +1651,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
             ret = hyperv_x86_synic_add(cpu);
             if (ret < 0) {
                 error_report("failed to create HyperV SynIC: %s",
-                             strerror(-ret));
+                             qemu_strerror(-ret));
                 return ret;
             }
         }
@@ -1689,7 +1690,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
         ret = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_ENFORCE_CPUID, 0, 1);
         if (ret < 0) {
             error_report("failed to enable KVM_CAP_HYPERV_ENFORCE_CPUID: %s",
-                         strerror(-ret));
+                         qemu_strerror(-ret));
             return ret;
         }
     }
@@ -1918,7 +1919,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         if (r < 0) {
             fprintf(stderr,
                     "failed to enable KVM_CAP_ENFORCE_PV_FEATURE_CPUID: %s",
-                    strerror(-r));
+                    qemu_strerror(-r));
             abort();
         }
     }
@@ -2156,7 +2157,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
         ret = kvm_get_mce_cap_supported(cs->kvm_state, &mcg_cap, &banks);
         if (ret < 0) {
-            fprintf(stderr, "kvm_get_mce_cap_supported: %s", strerror(-ret));
+            fprintf(stderr, "kvm_get_mce_cap_supported: %s",
+                    qemu_strerror(-ret));
             return ret;
         }
 
@@ -2179,7 +2181,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         env->mcg_cap &= mcg_cap | MCG_CAP_BANKS_MASK;
         ret = kvm_vcpu_ioctl(cs, KVM_X86_SETUP_MCE, &env->mcg_cap);
         if (ret < 0) {
-            fprintf(stderr, "KVM_X86_SETUP_MCE: %s", strerror(-ret));
+            fprintf(stderr, "KVM_X86_SETUP_MCE: %s", qemu_strerror(-ret));
             return ret;
         }
     }
@@ -2354,7 +2356,7 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
     ret = kvm_ioctl(s, KVM_GET_MSR_FEATURE_INDEX_LIST, &msr_list);
     if (ret < 0 && ret != -E2BIG) {
         error_report("Fetch KVM feature MSR list failed: %s",
-            strerror(-ret));
+            qemu_strerror(-ret));
         return ret;
     }
 
@@ -2367,7 +2369,7 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
 
     if (ret < 0) {
         error_report("Fetch KVM feature MSR list failed: %s",
-            strerror(-ret));
+            qemu_strerror(-ret));
         g_free(kvm_feature_msrs);
         kvm_feature_msrs = NULL;
         return ret;
@@ -2595,7 +2597,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         ret = kvm_vm_enable_cap(s, KVM_CAP_EXCEPTION_PAYLOAD, 0, true);
         if (ret < 0) {
             error_report("kvm: Failed to enable exception payload cap: %s",
-                         strerror(-ret));
+                         qemu_strerror(-ret));
             return ret;
         }
     }
@@ -2605,7 +2607,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         ret = kvm_vm_enable_cap(s, KVM_CAP_X86_TRIPLE_FAULT_EVENT, 0, true);
         if (ret < 0) {
             error_report("kvm: Failed to enable triple fault event cap: %s",
-                         strerror(-ret));
+                         qemu_strerror(-ret));
             return ret;
         }
     }
@@ -2707,7 +2709,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                                 disable_exits);
         if (ret < 0) {
             error_report("kvm: guest stopping CPU not supported: %s",
-                         strerror(-ret));
+                         qemu_strerror(-ret));
         }
     }
 
@@ -2724,7 +2726,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                                     KVM_BUS_LOCK_DETECTION_EXIT);
             if (ret < 0) {
                 error_report("kvm: Failed to enable bus lock detection cap: %s",
-                             strerror(-ret));
+                             qemu_strerror(-ret));
                 return ret;
             }
             ratelimit_init(&bus_lock_ratelimit_ctrl);
@@ -2743,7 +2745,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                                     notify_window_flags);
             if (ret < 0) {
                 error_report("kvm: Failed to enable notify vmexit cap: %s",
-                             strerror(-ret));
+                             qemu_strerror(-ret));
                 return ret;
             }
     }
@@ -2754,7 +2756,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                                 KVM_MSR_EXIT_REASON_FILTER);
         if (ret) {
             error_report("Could not enable user space MSRs: %s",
-                         strerror(-ret));
+                         qemu_strerror(-ret));
             exit(1);
         }
 
@@ -2762,7 +2764,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                            kvm_rdmsr_core_thread_count, NULL);
         if (!r) {
             error_report("Could not install MSR_CORE_THREAD_COUNT handler: %s",
-                         strerror(-ret));
+                         qemu_strerror(-ret));
             exit(1);
         }
     }
@@ -4889,7 +4891,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
             ret = kvm_vcpu_ioctl(cpu, KVM_NMI);
             if (ret < 0) {
                 fprintf(stderr, "KVM: injection failed, NMI lost (%s)\n",
-                        strerror(-ret));
+                        qemu_strerror(-ret));
             }
         }
         if (cpu->interrupt_request & CPU_INTERRUPT_SMI) {
@@ -4900,7 +4902,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
             ret = kvm_vcpu_ioctl(cpu, KVM_SMI);
             if (ret < 0) {
                 fprintf(stderr, "KVM: injection failed, SMI lost (%s)\n",
-                        strerror(-ret));
+                        qemu_strerror(-ret));
             }
         }
     }
@@ -4941,7 +4943,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
                 if (ret < 0) {
                     fprintf(stderr,
                             "KVM: injection failed, interrupt lost (%s)\n",
-                            strerror(-ret));
+                            qemu_strerror(-ret));
                 }
             }
         }
@@ -5414,7 +5416,8 @@ static bool __kvm_enable_sgx_provisioning(KVMState *s)
 
     ret = kvm_vm_enable_cap(s, KVM_CAP_SGX_ATTRIBUTE, 0, fd);
     if (ret) {
-        error_report("Could not enable SGX PROVISIONKEY: %s", strerror(-ret));
+        error_report("Could not enable SGX PROVISIONKEY: %s",
+                     qemu_strerror(-ret));
         exit(1);
     }
     close(fd);
@@ -5580,7 +5583,7 @@ int kvm_arch_irqchip_create(KVMState *s)
         ret = kvm_vm_enable_cap(s, KVM_CAP_SPLIT_IRQCHIP, 0, 24);
         if (ret) {
             error_report("Could not enable split irqchip mode: %s",
-                         strerror(-ret));
+                         qemu_strerror(-ret));
             exit(1);
         } else {
             DPRINTF("Enabled KVM_CAP_SPLIT_IRQCHIP\n");
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index d7c7eb8d9c..f7837ff95a 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -12,6 +12,7 @@
 #include "qemu/osdep.h"
 #include "qemu/log.h"
 #include "qemu/main-loop.h"
+#include "qemu/cutils.h"
 #include "qemu/error-report.h"
 #include "hw/xen/xen.h"
 #include "sysemu/kvm_int.h"
@@ -135,7 +136,7 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
     ret = kvm_vm_ioctl(s, KVM_XEN_HVM_CONFIG, &cfg);
     if (ret < 0) {
         error_report("kvm: Failed to enable Xen HVM support: %s",
-                     strerror(-ret));
+                     qemu_strerror(-ret));
         return ret;
     }
 
@@ -209,7 +210,7 @@ int kvm_xen_init_vcpu(CPUState *cs)
         err = kvm_vcpu_ioctl(cs, KVM_XEN_VCPU_SET_ATTR, &va);
         if (err) {
             error_report("kvm: Failed to set Xen vCPU ID attribute: %s",
-                         strerror(-err));
+                         qemu_strerror(-err));
             return err;
         }
     }
@@ -964,7 +965,7 @@ static uint64_t kvm_get_current_ns(void)
 
     ret = kvm_vm_ioctl(kvm_state, KVM_GET_CLOCK, &data);
     if (ret < 0) {
-        fprintf(stderr, "KVM_GET_CLOCK failed: %s\n", strerror(ret));
+        fprintf(stderr, "KVM_GET_CLOCK failed: %s\n", qemu_strerror(ret));
                 abort();
     }
 
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index 6c46101ac1..97d9daacea 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -32,7 +32,7 @@ static void *qemu_nvmm_cpu_thread_fn(void *arg)
 
     r = nvmm_init_vcpu(cpu);
     if (r < 0) {
-        fprintf(stderr, "nvmm_init_vcpu failed: %s\n", strerror(-r));
+        fprintf(stderr, "nvmm_init_vcpu failed: %s\n", qemu_strerror(-r));
         exit(1);
     }
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 859e06f6ad..9f19fc5469 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -38,6 +38,7 @@
 #include "exec/confidential-guest-support.h"
 #include "hw/i386/pc.h"
 #include "exec/address-spaces.h"
+#include "qemu/cutils.h"
 
 #define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
@@ -247,7 +248,7 @@ sev_ram_block_added(RAMBlockNotifier *n, void *host, size_t size,
     r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
     if (r) {
         error_report("%s: failed to register region (%p+%#zx) error '%s'",
-                     __func__, host, max_size, strerror(errno));
+                     __func__, host, max_size, qemu_strerror(errno));
         exit(1);
     }
 }
@@ -948,7 +949,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     sev->sev_fd = open(devname, O_RDWR);
     if (sev->sev_fd < 0) {
         error_setg(errp, "%s: Failed to open %s '%s'", __func__,
-                   devname, strerror(errno));
+                   devname, qemu_strerror(errno));
         g_free(devname);
         goto err;
     }
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index e8dc4b3a47..bf16c8e643 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -32,7 +32,7 @@ static void *whpx_cpu_thread_fn(void *arg)
 
     r = whpx_init_vcpu(cpu);
     if (r < 0) {
-        fprintf(stderr, "whpx_init_vcpu failed: %s\n", strerror(-r));
+        fprintf(stderr, "whpx_init_vcpu failed: %s\n", qemu_strerror(-r));
         exit(1);
     }
 
-- 
2.39.2

