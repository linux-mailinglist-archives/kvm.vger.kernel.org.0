Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837C0509944
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 09:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385876AbiDUHin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 03:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385818AbiDUHia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 03:38:30 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D28B13D7C
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 00:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650526541; x=1682062541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=iiCAR1Rfqc66iGGWY17iyr5Co4ZAZLinh3HQEEGKipA=;
  b=QJzj/EEvprYWlP6pVcfz68GwfMxSE13M8uLD0LHen07j7OMgIK7Viu4G
   Ab4jPIT3LyZ9KeeitseYbpTlEmdhMDxApaEWR94ktbXNdW017De4FSXeZ
   LEpavcTHD3lrsdbJPKMe3hs/P6LV05QNLEkuFGGyAGDZNtQc6StOEF0GN
   UPF5appGFl5W9TrePaI6lxdQqYxu4Ek9znSMm1VhgGNm2MzpQU8iiRBYa
   h3HqlfttjyIAqhkA7cLD6UX1b33SdCCct3itNXAWWSJwOm4WrI9/Tf/gb
   9cmYSvmR0TL6o4422SBVqFE2kXH4RKzC+cBt/c+1lhxURKw6boe/XYhff
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="264440513"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="264440513"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:35:20 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="530155163"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:35:17 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 2/3] i386: kvm: Save&restore triple fault event
Date:   Thu, 21 Apr 2022 15:40:27 +0800
Message-Id: <20220421074028.18196-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421074028.18196-1-chenyi.qiang@intel.com>
References: <20220421074028.18196-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
the event.triple_fault_pending field contains a valid state.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 target/i386/cpu.c     | 1 +
 target/i386/cpu.h     | 1 +
 target/i386/kvm/kvm.c | 8 +++++++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index cb6b5467d0..276058d52e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5998,6 +5998,7 @@ static void x86_cpu_reset(DeviceState *dev)
     env->exception_has_payload = false;
     env->exception_payload = 0;
     env->nmi_injected = false;
+    env->triple_fault_pending = false;
 #if !defined(CONFIG_USER_ONLY)
     /* We hard-wire the BSP to the first CPU. */
     apic_designate_bsp(cpu->apic_state, s->cpu_index == 0);
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 982c532353..a2a9423747 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1701,6 +1701,7 @@ typedef struct CPUArchState {
     uint8_t has_error_code;
     uint8_t exception_has_payload;
     uint64_t exception_payload;
+    bool triple_fault_pending;
     uint32_t ins_len;
     uint32_t sipi_vector;
     bool tsc_valid;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9cf8e03669..bd44a02f51 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4099,7 +4099,9 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
     }
 
     if (level >= KVM_PUT_RESET_STATE) {
-        events.flags |= KVM_VCPUEVENT_VALID_NMI_PENDING;
+        events.flags |= KVM_VCPUEVENT_VALID_NMI_PENDING |
+                        KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
+        events.triple_fault_pending = env->triple_fault_pending;
         if (env->mp_state == KVM_MP_STATE_SIPI_RECEIVED) {
             events.flags |= KVM_VCPUEVENT_VALID_SIPI_VECTOR;
         }
@@ -4174,6 +4176,10 @@ static int kvm_get_vcpu_events(X86CPU *cpu)
         }
     }
 
+    if (events.flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT) {
+        env->triple_fault_pending = events.triple_fault_pending;
+    }
+
     env->sipi_vector = events.sipi_vector;
 
     return 0;
-- 
2.17.1

