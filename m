Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5505F4C60
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 01:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJDXFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 19:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJDXFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 19:05:48 -0400
Received: from zulu616.server4you.de (mail.csgraf.de [85.25.223.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA98A25C40
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 16:05:42 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-117-005-115.95.117.pool.telefonica.de [95.117.5.115])
        by csgraf.de (Postfix) with ESMTPSA id 8AB776080FDE;
        Wed,  5 Oct 2022 00:56:47 +0200 (CEST)
From:   Alexander Graf <agraf@csgraf.de>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladislav Yaroshchuk <yaroshchuk2000@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 3/3] KVM: x86: Implement MSR_CORE_THREAD_COUNT MSR
Date:   Wed,  5 Oct 2022 00:56:43 +0200
Message-Id: <20221004225643.65036-4-agraf@csgraf.de>
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

The MSR_CORE_THREAD_COUNT MSR describes CPU package topology, such as number
of threads and cores for a given package. This is information that QEMU has
readily available and can provide through the new user space MSR deflection
interface.

This patch propagates the existing hvf logic from patch 027ac0cb516
("target/i386/hvf: add rdmsr 35H MSR_CORE_THREAD_COUNT") to KVM.

Signed-off-by: Alexander Graf <agraf@csgraf.de>
---
 target/i386/kvm/kvm.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ea53092dd0..791e995389 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2403,6 +2403,17 @@ static int kvm_get_supported_msrs(KVMState *s)
     return ret;
 }
 
+static bool kvm_rdmsr_core_thread_count(X86CPU *cpu, uint32_t msr,
+                                        uint64_t *val)
+{
+    CPUState *cs = CPU(cpu);
+
+    *val = cs->nr_threads * cs->nr_cores; /* thread count, bits 15..0 */
+    *val |= ((uint32_t)cs->nr_cores << 16); /* core count, bits 31..16 */
+
+    return true;
+}
+
 static Notifier smram_machine_done;
 static KVMMemoryListener smram_listener;
 static AddressSpace smram_address_space;
@@ -2591,6 +2602,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     if (kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
+        bool r;
+
         ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
                                 KVM_MSR_EXIT_REASON_FILTER);
         if (ret) {
@@ -2598,6 +2611,14 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                          strerror(-ret));
             exit(1);
         }
+
+        r = kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
+                           kvm_rdmsr_core_thread_count, NULL);
+        if (!r) {
+            error_report("Could not install MSR_CORE_THREAD_COUNT handler: %s",
+                         strerror(-ret));
+            exit(1);
+        }
     }
 
     return 0;
-- 
2.37.0 (Apple Git-136)

