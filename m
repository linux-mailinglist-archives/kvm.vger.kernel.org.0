Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761BD5E74D4
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 09:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiIWH0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 03:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiIWH0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 03:26:41 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7698212A4BB
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 00:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663918000; x=1695454000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=0del9VXeyTnxvbQjFzOC/wKBQkuUfZxt/1ML/Cb1adw=;
  b=cou2n5IKMCkKWfVmzUpQdSFwyJtaHDhX6tKyanKt39tzX9YRjXHF8u+d
   6jw0tcQ8IZNQaRLREngUl5/d1exP2jTc+iujT148QkSScykcD1a5SkFIj
   ssgKS5Tmp197GPQJFRx5yFWQGu2d02MfqVnf1Nb5WFlDBp2GJMH8QYE90
   2LQyLnwLtukdyPP9BE0G6zxInJ55DkzYMUxw1JJgggeHV+GxNVym0juHn
   +FughWjKN+KKJx4XTQFv1uZicRwPk5nUbOeS3ngBHdd2/jjykgxcZ8sJG
   1B5IzHbnmr/P0al5bcHcApcdxLIaPlPYUFSNVVb+sWE8PeRzjiu7TNIJ/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="287646917"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="287646917"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 00:26:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="620121672"
Received: from chenyi-pc.sh.intel.com ([10.239.159.53])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 00:26:37 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v7 1/2] i386: kvm: extend kvm_{get, put}_vcpu_events to support pending triple fault
Date:   Fri, 23 Sep 2022 15:33:32 +0800
Message-Id: <20220923073333.23381-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220923073333.23381-1-chenyi.qiang@intel.com>
References: <20220923073333.23381-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the direct triple faults, i.e. hardware detected and KVM morphed
to VM-Exit, KVM will never lose them. But for triple faults sythesized
by KVM, e.g. the RSM path, if KVM exits to userspace before the request
is serviced, userspace could migrate the VM and lose the triple fault.

A new flag KVM_VCPUEVENT_VALID_TRIPLE_FAULT is defined to signal that
the event.triple_fault_pending field contains a valid state if the
KVM_CAP_X86_TRIPLE_FAULT_EVENT capability is enabled.

Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 target/i386/cpu.c     |  1 +
 target/i386/cpu.h     |  1 +
 target/i386/kvm/kvm.c | 20 ++++++++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1db1278a59..6e107466b3 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6017,6 +6017,7 @@ static void x86_cpu_reset(DeviceState *dev)
     env->exception_has_payload = false;
     env->exception_payload = 0;
     env->nmi_injected = false;
+    env->triple_fault_pending = false;
 #if !defined(CONFIG_USER_ONLY)
     /* We hard-wire the BSP to the first CPU. */
     apic_designate_bsp(cpu->apic_state, s->cpu_index == 0);
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 82004b65b9..b97d182e28 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1739,6 +1739,7 @@ typedef struct CPUArchState {
     uint8_t has_error_code;
     uint8_t exception_has_payload;
     uint64_t exception_payload;
+    bool triple_fault_pending;
     uint32_t ins_len;
     uint32_t sipi_vector;
     bool tsc_valid;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a1fd1f5379..3838827134 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -132,6 +132,7 @@ static int has_xcrs;
 static int has_pit_state2;
 static int has_sregs2;
 static int has_exception_payload;
+static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
 
@@ -2483,6 +2484,16 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    has_triple_fault_event = kvm_check_extension(s, KVM_CAP_X86_TRIPLE_FAULT_EVENT);
+    if (has_triple_fault_event) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_TRIPLE_FAULT_EVENT, 0, true);
+        if (ret < 0) {
+            error_report("kvm: Failed to enable triple fault event cap: %s",
+                         strerror(-ret));
+            return ret;
+        }
+    }
+
     ret = kvm_get_supported_msrs(s);
     if (ret < 0) {
         return ret;
@@ -4299,6 +4310,11 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
         }
     }
 
+    if (has_triple_fault_event) {
+        events.flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
+        events.triple_fault.pending = env->triple_fault_pending;
+    }
+
     return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_VCPU_EVENTS, &events);
 }
 
@@ -4368,6 +4384,10 @@ static int kvm_get_vcpu_events(X86CPU *cpu)
         }
     }
 
+    if (events.flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT) {
+        env->triple_fault_pending = events.triple_fault.pending;
+    }
+
     env->sipi_vector = events.sipi_vector;
 
     return 0;
-- 
2.17.1

