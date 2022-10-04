Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F445F4C63
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 01:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiJDXFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 19:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJDXFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 19:05:48 -0400
X-Greylist: delayed 536 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 16:05:43 PDT
Received: from zulu616.server4you.de (mail.csgraf.de [85.25.223.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E256255B2
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 16:05:42 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-117-005-115.95.117.pool.telefonica.de [95.117.5.115])
        by csgraf.de (Postfix) with ESMTPSA id A5A3260806F2;
        Wed,  5 Oct 2022 00:56:46 +0200 (CEST)
From:   Alexander Graf <agraf@csgraf.de>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladislav Yaroshchuk <yaroshchuk2000@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 2/3] i386: kvm: Add support for MSR filtering
Date:   Wed,  5 Oct 2022 00:56:42 +0200
Message-Id: <20221004225643.65036-3-agraf@csgraf.de>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
In-Reply-To: <20221004225643.65036-1-agraf@csgraf.de>
References: <20221004225643.65036-1-agraf@csgraf.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM has grown support to deflect arbitrary MSRs to user space since
Linux 5.10. For now we don't expect to make a lot of use of this
feature, so let's expose it the easiest way possible: With up to 16
individually maskable MSRs.

This patch adds a kvm_filter_msr() function that other code can call
to install a hook on KVM MSR reads or writes.

Signed-off-by: Alexander Graf <agraf@csgraf.de>
---
 target/i386/kvm/kvm.c      | 124 +++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |  11 ++++
 2 files changed, 135 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a1fd1f5379..ea53092dd0 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -139,6 +139,8 @@ static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
 static struct kvm_msr_list *kvm_feature_msrs;
 
+static KVMMSRHandlers msr_handlers[KVM_MSR_FILTER_MAX_RANGES];
+
 #define BUS_LOCK_SLICE_TIME 1000000000ULL /* ns */
 static RateLimit bus_lock_ratelimit_ctrl;
 static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
@@ -2588,6 +2590,16 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
+                                KVM_MSR_EXIT_REASON_FILTER);
+        if (ret) {
+            error_report("Could not enable user space MSRs: %s",
+                         strerror(-ret));
+            exit(1);
+        }
+    }
+
     return 0;
 }
 
@@ -5077,6 +5089,108 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg)
     }
 }
 
+static bool kvm_install_msr_filters(KVMState *s)
+{
+    uint64_t zero = 0;
+    struct kvm_msr_filter filter = {
+        .flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
+    };
+    int r, i, j = 0;
+
+    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
+        KVMMSRHandlers *handler = &msr_handlers[i];
+        if (handler->msr) {
+            struct kvm_msr_filter_range *range = &filter.ranges[j++];
+
+            *range = (struct kvm_msr_filter_range) {
+                .flags = 0,
+                .nmsrs = 1,
+                .base = handler->msr,
+                .bitmap = (__u8 *)&zero,
+            };
+
+            if (handler->rdmsr) {
+                range->flags |= KVM_MSR_FILTER_READ;
+            }
+
+            if (handler->wrmsr) {
+                range->flags |= KVM_MSR_FILTER_WRITE;
+            }
+        }
+    }
+
+    r = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
+    if (r) {
+        return false;
+    }
+
+    return true;
+}
+
+bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+                    QEMUWRMSRHandler *wrmsr)
+{
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
+        if (!msr_handlers[i].msr) {
+            msr_handlers[i] = (KVMMSRHandlers) {
+                .msr = msr,
+                .rdmsr = rdmsr,
+                .wrmsr = wrmsr,
+            };
+
+            if (!kvm_install_msr_filters(s)) {
+                msr_handlers[i] = (KVMMSRHandlers) { };
+                return false;
+            }
+
+            return true;
+        }
+    }
+
+    return false;
+}
+
+static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
+{
+    int i;
+    bool r;
+
+    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
+        KVMMSRHandlers *handler = &msr_handlers[i];
+        if (run->msr.index == handler->msr) {
+            if (handler->rdmsr) {
+                r = handler->rdmsr(cpu, handler->msr,
+                                   (uint64_t *)&run->msr.data);
+                run->msr.error = r ? 0 : 1;
+                return 0;
+            }
+        }
+    }
+
+    assert(false);
+}
+
+static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
+{
+    int i;
+    bool r;
+
+    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
+        KVMMSRHandlers *handler = &msr_handlers[i];
+        if (run->msr.index == handler->msr) {
+            if (handler->wrmsr) {
+                r = handler->wrmsr(cpu, handler->msr, run->msr.data);
+                run->msr.error = r ? 0 : 1;
+                return 0;
+            }
+        }
+    }
+
+    assert(false);
+}
+
 static bool has_sgx_provisioning;
 
 static bool __kvm_enable_sgx_provisioning(KVMState *s)
@@ -5176,6 +5290,16 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         /* already handled in kvm_arch_post_run */
         ret = 0;
         break;
+    case KVM_EXIT_X86_RDMSR:
+        /* We only enable MSR filtering, any other exit is bogus */
+        assert(run->msr.reason == KVM_MSR_EXIT_REASON_FILTER);
+        ret = kvm_handle_rdmsr(cpu, run);
+        break;
+    case KVM_EXIT_X86_WRMSR:
+        /* We only enable MSR filtering, any other exit is bogus */
+        assert(run->msr.reason == KVM_MSR_EXIT_REASON_FILTER);
+        ret = kvm_handle_wrmsr(cpu, run);
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 4124912c20..2ed586c11b 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -54,4 +54,15 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
 bool kvm_enable_sgx_provisioning(KVMState *s);
 void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask);
 
+typedef bool QEMURDMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t *val);
+typedef bool QEMUWRMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t val);
+typedef struct kvm_msr_handlers {
+    uint32_t msr;
+    QEMURDMSRHandler *rdmsr;
+    QEMUWRMSRHandler *wrmsr;
+} KVMMSRHandlers;
+
+bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+                    QEMUWRMSRHandler *wrmsr);
+
 #endif
-- 
2.37.0 (Apple Git-136)

