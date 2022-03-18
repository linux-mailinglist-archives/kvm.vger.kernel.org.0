Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29E94DD60F
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 09:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiCRIZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 04:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiCRIZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 04:25:12 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C531E88780
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 01:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647591834; x=1679127834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=2B0jRUQkDPhNOC+pX7zn7Y+wP0pcFv2VGOcVYjoAfPg=;
  b=jR6sIVa9FAkqxjVQC6jEL0GO4EiTyHBFPI+o333Yqb1LucwS3Qqef0X0
   2ai1b9nUBX3i+M7uoH1QENjbkAe3kwESlYo8W0HBfsFKKlJZjKv9DdQkT
   iNcyJt7vt4Mfwo/gxZ9JgUSVrx9X4xi04LLT5NWYEd0Zts1JRLB9cYEJE
   UjQQKn3iuoQD5pc2NchK8CRoYSOrJpqqyhlfHxTcu8cPsmIehQrbFR/fi
   HIQtX7umfrhl7vibySy7UtHz5cDcmtfoNQ2NXHR/3ryK3mGtQ7+77O39b
   jraTKc53ijl27cRaHDmkIm4rYMD7dpiVsMKdJc4jhJHM9qby+rtzuyeR1
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="343528108"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="343528108"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 01:23:54 -0700
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="558320573"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 01:23:52 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 2/3] i386: kvm: Save&restore triple fault event
Date:   Fri, 18 Mar 2022 16:29:33 +0800
Message-Id: <20220318082934.25030-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220318082934.25030-1-chenyi.qiang@intel.com>
References: <20220318082934.25030-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the direct triple faults, i.e. hardware detected and KVM morphed
to VM-Exit, KVM will never lose them. But for triple faults sythesized
by KVM, e.g. the RSM path, if KVM exits to userspace before the request
is serviced, userspace coud migrate the VM and lose the triple fault.

A new flag KVM_VCPUEVENT_TRIPLE_FAULT is defined to signal that there's
triple fault event waiting to be serviced. Track it and save/restore
during get/set_vcpu_events().

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 target/i386/cpu.c     |  1 +
 target/i386/cpu.h     |  1 +
 target/i386/kvm/kvm.c | 10 ++++++++++
 3 files changed, 12 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6c7ef1099b..dbfecf46a0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5918,6 +5918,7 @@ static void x86_cpu_reset(DeviceState *dev)
     env->exception_has_payload = false;
     env->exception_payload = 0;
     env->nmi_injected = false;
+    env->has_triple_fault = false;
 #if !defined(CONFIG_USER_ONLY)
     /* We hard-wire the BSP to the first CPU. */
     apic_designate_bsp(cpu->apic_state, s->cpu_index == 0);
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e11734ba86..5a2a005ae8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1659,6 +1659,7 @@ typedef struct CPUArchState {
     uint8_t has_error_code;
     uint8_t exception_has_payload;
     uint64_t exception_payload;
+    bool has_triple_fault;
     uint32_t ins_len;
     uint32_t sipi_vector;
     bool tsc_valid;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 83d0988302..3159c9cefe 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4041,6 +4041,10 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
         }
     }
 
+    if (env->has_triple_fault) {
+        events.flags |= KVM_VCPUEVENT_TRIPLE_FAULT;
+    }
+
     return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_VCPU_EVENTS, &events);
 }
 
@@ -4110,6 +4114,12 @@ static int kvm_get_vcpu_events(X86CPU *cpu)
         }
     }
 
+    if (events.flags & KVM_VCPUEVENT_TRIPLE_FAULT) {
+        env->has_triple_fault = true;
+    } else {
+        env->has_triple_fault = false;
+    }
+
     env->sipi_vector = events.sipi_vector;
 
     return 0;
-- 
2.17.1

