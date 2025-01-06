Return-Path: <kvm+bounces-34638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A65A03111
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D364D3A3BD9
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3231DF981;
	Mon,  6 Jan 2025 20:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mFrayqa7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E5F1DF24B
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193831; cv=none; b=ox8kD0cT1dNMlDzZtz1QnitiM3L+3HbLHWTdqBz4r6MtiDaJfm/h35dVVjCYf2clzgG7OVL7PYIY9DcrBH39oGcQgDcO1k6F5G9awwjp+d8xp8fX9yK/FoAW+EyBBImmXat7Spk3TFDhsjNYOJRUCxlJA/XbQmpVZSrLgIGWO7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193831; c=relaxed/simple;
	bh=qzuBmNQH3znmhd3VNLozKF0kfAq08JeYKtjdXh2hp1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f8de76k3GPoL5wq6Kph6+54aT9VZVkVjenXK8DZ4MbEQM6iRuhE/P3TJYgEyK2ySkxPahqp9nb4crFeZBlSgp4RWva6L4zun0nLysA27TkHZHtqIH402PbMZtvFYvwrB36YK031b4e8UzybOQl1V/9MghyXrrOQr1PNbVf9vhWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mFrayqa7; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4361f796586so152703775e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736193827; x=1736798627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQTkKmwN0la/zq4/AmggU7ruV8aWhlAE2m8oe1Or7Yc=;
        b=mFrayqa7eRWKsfi68pRUDs5njnYt2eQrYQlNWFG8zpKxBj+ffg7dDqM2XbMQzP+AKp
         MidlZlNhmlK2tNLh6/T338oAPuhI30s10euqTjjZQ5HFl+/qMhGHdPPPGUbrqplUc6AU
         XbJUFyPrvPeRz/tqod2R0A+hVpZPAr7tcdxNLtM41Fp3CmIQT33khMsLU9sq0apIVNWn
         2FFlZd4NFlhB2FhVU0ggOy+mnZ68UrjifPTjddwVsFiEuDj4htQv1+5fOlIsY4E/vFBt
         M2Wbj7HJHeBPd5vMWUppLJtdi6UXADiMPEf5szChbAOkJVvaUCd6xc3YUF/tVfRBRllj
         j/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736193828; x=1736798628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQTkKmwN0la/zq4/AmggU7ruV8aWhlAE2m8oe1Or7Yc=;
        b=oOPCXvKaZ+Bbw+7H2XcADR8e6GfjbtcyZlBsIEY1jj8mz9PqkEo5pzmFLtPzgGvWXh
         DvE3CSCZssZajnWNQ4i4c38kXTb2KZdFJFq9RFZYHkgTipPL/UlExaKYO4Jrl0Ufd7H1
         5PLbFNI/tRr+BLbRE5ndL4qv3OfI5sJlVniUiRyrI/wtxUuRxO6AT8CwyFoEZRgiSn+Y
         +Bd3edTipPDywS3zHyTE3YBSq+AmDh1QKk6SipG06N2Ev/L7Zqst+kuh2QDBbR0TJiK7
         Mxt2Tq6qrUKyovwRIlDFyoZ4eN4Ygnnos993HEaikQl4o/SR9pKRvi/KoOuSVn4btDus
         RMHg==
X-Forwarded-Encrypted: i=1; AJvYcCUDw1iGChSvf2WpTqZHKrqMjIIsDxGsd4r1Lg8KO7cRjpSrwtN/VTC/wOULd8CI4c6inw8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwFV8iZQkPTyS3DvcL28cSZJgDaChMrcMUA2j8P2A02qVbI/ag
	I1NdEtGuRljqkw5rIPd8V8QMjaVHwt9lPAyEM6Rx2IZRR6hIeOblL7qFJtetApA=
X-Gm-Gg: ASbGncsPA1HS1elbdEzJv51BZ7nk7hGhi3mZcZPsUs+N6wGqIvO3y5ZiCL5bL84LtFY
	zehHjx3k2Ihj/rmoj32Nb18Fgh7pt/a3ouxfuysC3izQqKmb60CH3+9HAA9+yXYXbalqT+J+t9Y
	r3mMU5+2DLA0+uCzyul8KI6F/zdtpQN+M5QlGFuNm6LLbEqu78i2abKCi2o8txLfn4RogMIwH6r
	Jm8jyjNSUVV8eqA4y0qvaJ4Grn4sIMFAxC4DXASycm1PXDTApkS+eziboXWKV8IYocVhQcxJAHQ
	5AX8DemM11Fjq1FGf8jIYDzoW6QbpZQ=
X-Google-Smtp-Source: AGHT+IHDE/cbM5Uz3mC6dPWI+SKnpmJxnVL7+eC7vPChMfg/0MfF0CSgk918tvS7UmQNdLQuffdZDw==
X-Received: by 2002:a5d:6c64:0:b0:385:f6f4:f8e with SMTP id ffacd0b85a97d-38a223ff1cemr40988273f8f.50.1736193825978;
        Mon, 06 Jan 2025 12:03:45 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436723cb159sm525092965e9.16.2025.01.06.12.03.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 12:03:44 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Alexander Graf <agraf@csgraf.de>,
	Paul Durrant <paul@xen.org>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-s390x@nongnu.org,
	Riku Voipio <riku.voipio@iki.fi>,
	Anthony PERARD <anthony@xenproject.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Edgar E . Iglesias" <edgar.iglesias@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	David Woodhouse <dwmw2@infradead.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Anton Johansson <anjo@rev.ng>
Subject: [RFC PATCH 7/7] accel/kvm: Use CPU_FOREACH_KVM()
Date: Mon,  6 Jan 2025 21:02:58 +0100
Message-ID: <20250106200258.37008-8-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106200258.37008-1-philmd@linaro.org>
References: <20250106200258.37008-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Only iterate over KVM vCPUs when running KVM specific code.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/kvm_int.h         |  3 +++
 accel/kvm/kvm-all.c              | 14 +++++++-------
 hw/i386/kvm/clock.c              |  3 ++-
 hw/intc/spapr_xive_kvm.c         |  5 +++--
 hw/intc/xics_kvm.c               |  5 +++--
 target/i386/kvm/kvm.c            |  4 ++--
 target/i386/kvm/xen-emu.c        |  2 +-
 target/s390x/kvm/kvm.c           |  2 +-
 target/s390x/kvm/stsi-topology.c |  3 ++-
 9 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
index 4de6106869b..0ef4c336b18 100644
--- a/include/system/kvm_int.h
+++ b/include/system/kvm_int.h
@@ -13,6 +13,7 @@
 #include "qapi/qapi-types-common.h"
 #include "qemu/accel.h"
 #include "qemu/queue.h"
+#include "system/hw_accel.h"
 #include "system/kvm.h"
 #include "hw/boards.h"
 #include "hw/i386/topology.h"
@@ -168,6 +169,8 @@ struct KVMState
     char *device;
 };
 
+#define CPU_FOREACH_KVM(cpu) CPU_FOREACH_HWACCEL(cpu)
+
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
                                   AddressSpace *as, int as_id, const char *name);
 
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c65b790433c..9b26b286865 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -872,7 +872,7 @@ static uint64_t kvm_dirty_ring_reap_locked(KVMState *s, CPUState* cpu)
     if (cpu) {
         total = kvm_dirty_ring_reap_one(s, cpu);
     } else {
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_KVM(cpu) {
             total += kvm_dirty_ring_reap_one(s, cpu);
         }
     }
@@ -935,7 +935,7 @@ static void kvm_cpu_synchronize_kick_all(void)
 {
     CPUState *cpu;
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_KVM(cpu) {
         run_on_cpu(cpu, do_kvm_cpu_synchronize_kick, RUN_ON_CPU_NULL);
     }
 }
@@ -3535,7 +3535,7 @@ int kvm_insert_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len)
         }
     }
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_KVM(cpu) {
         err = kvm_update_guest_debug(cpu, 0);
         if (err) {
             return err;
@@ -3574,7 +3574,7 @@ int kvm_remove_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len)
         }
     }
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_KVM(cpu) {
         err = kvm_update_guest_debug(cpu, 0);
         if (err) {
             return err;
@@ -3592,7 +3592,7 @@ void kvm_remove_all_breakpoints(CPUState *cpu)
     QTAILQ_FOREACH_SAFE(bp, &s->kvm_sw_breakpoints, entry, next) {
         if (kvm_arch_remove_sw_breakpoint(cpu, bp) != 0) {
             /* Try harder to find a CPU that currently sees the breakpoint. */
-            CPU_FOREACH(tmpcpu) {
+            CPU_FOREACH_KVM(tmpcpu) {
                 if (kvm_arch_remove_sw_breakpoint(tmpcpu, bp) == 0) {
                     break;
                 }
@@ -3603,7 +3603,7 @@ void kvm_remove_all_breakpoints(CPUState *cpu)
     }
     kvm_arch_remove_all_hw_breakpoints();
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_KVM(cpu) {
         kvm_update_guest_debug(cpu, 0);
     }
 }
@@ -4384,7 +4384,7 @@ static void query_stats_cb(StatsResultList **result, StatsTarget target,
         stats_args.result.stats = result;
         stats_args.names = names;
         stats_args.errp = errp;
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_KVM(cpu) {
             if (!apply_str_list_filter(cpu->parent_obj.canonical_path, targets)) {
                 continue;
             }
diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
index 63be5088420..f2638cf2c22 100644
--- a/hw/i386/kvm/clock.c
+++ b/hw/i386/kvm/clock.c
@@ -17,6 +17,7 @@
 #include "qemu/host-utils.h"
 #include "qemu/module.h"
 #include "system/kvm.h"
+#include "system/kvm_int.h"
 #include "system/runstate.h"
 #include "system/hw_accel.h"
 #include "kvm/kvm_i386.h"
@@ -196,7 +197,7 @@ static void kvmclock_vm_state_change(void *opaque, bool running,
         if (!cap_clock_ctrl) {
             return;
         }
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_KVM(cpu) {
             run_on_cpu(cpu, do_kvmclock_ctrl, RUN_ON_CPU_NULL);
         }
     } else {
diff --git a/hw/intc/spapr_xive_kvm.c b/hw/intc/spapr_xive_kvm.c
index 26d30b41c15..08354f08512 100644
--- a/hw/intc/spapr_xive_kvm.c
+++ b/hw/intc/spapr_xive_kvm.c
@@ -14,6 +14,7 @@
 #include "target/ppc/cpu.h"
 #include "system/cpus.h"
 #include "system/kvm.h"
+#include "system/kvm_int.h"
 #include "system/runstate.h"
 #include "hw/ppc/spapr.h"
 #include "hw/ppc/spapr_cpu_core.h"
@@ -678,7 +679,7 @@ int kvmppc_xive_post_load(SpaprXive *xive, int version_id)
      * 'post_load' handler of XiveTCTX because the machine is not
      * necessarily connected to the KVM device at that time.
      */
-    CPU_FOREACH(cs) {
+    CPU_FOREACH_KVM(cs) {
         PowerPCCPU *cpu = POWERPC_CPU(cs);
 
         ret = kvmppc_xive_cpu_set_state(spapr_cpu_state(cpu)->tctx, &local_err);
@@ -795,7 +796,7 @@ int kvmppc_xive_connect(SpaprInterruptController *intc, uint32_t nr_servers,
         kvmppc_xive_change_state_handler, xive);
 
     /* Connect the presenters to the initial VCPUs of the machine */
-    CPU_FOREACH(cs) {
+    CPU_FOREACH_KVM(cs) {
         PowerPCCPU *cpu = POWERPC_CPU(cs);
 
         ret = kvmppc_xive_cpu_connect(spapr_cpu_state(cpu)->tctx, errp);
diff --git a/hw/intc/xics_kvm.c b/hw/intc/xics_kvm.c
index ee72969f5f1..aed2ad44363 100644
--- a/hw/intc/xics_kvm.c
+++ b/hw/intc/xics_kvm.c
@@ -29,6 +29,7 @@
 #include "qapi/error.h"
 #include "trace.h"
 #include "system/kvm.h"
+#include "system/kvm_int.h"
 #include "hw/ppc/spapr.h"
 #include "hw/ppc/spapr_cpu_core.h"
 #include "hw/ppc/xics.h"
@@ -418,7 +419,7 @@ int xics_kvm_connect(SpaprInterruptController *intc, uint32_t nr_servers,
     kvm_gsi_direct_mapping = true;
 
     /* Create the presenters */
-    CPU_FOREACH(cs) {
+    CPU_FOREACH_KVM(cs) {
         PowerPCCPU *cpu = POWERPC_CPU(cs);
 
         icp_kvm_realize(DEVICE(spapr_cpu_state(cpu)->icp), &local_err);
@@ -434,7 +435,7 @@ int xics_kvm_connect(SpaprInterruptController *intc, uint32_t nr_servers,
     }
 
     /* Connect the presenters to the initial VCPUs of the machine */
-    CPU_FOREACH(cs) {
+    CPU_FOREACH_KVM(cs) {
         PowerPCCPU *cpu = POWERPC_CPU(cs);
         icp_set_kvm_state(spapr_cpu_state(cpu)->icp, &local_err);
         if (local_err) {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2f66e63b880..437911d6c6a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -329,7 +329,7 @@ void kvm_synchronize_all_tsc(void)
     CPUState *cpu;
 
     if (kvm_enabled()) {
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_KVM(cpu) {
             run_on_cpu(cpu, do_kvm_synchronize_tsc, RUN_ON_CPU_NULL);
         }
     }
@@ -2847,7 +2847,7 @@ static void *kvm_msr_energy_thread(void *data)
          * Identify the vcpu threads
          * Calculate the number of vcpu per package
          */
-        CPU_FOREACH(cpu) {
+        CPU_FOREACH_KVM(cpu) {
             for (int i = 0; i < num_threads; i++) {
                 if (cpu->thread_id == thd_stat[i].thread_id) {
                     thd_stat[i].is_vcpu = true;
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index e81a2458812..36ae9c11252 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -1422,7 +1422,7 @@ int kvm_xen_soft_reset(void)
         return err;
     }
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_KVM(cpu) {
         async_run_on_cpu(cpu, do_vcpu_soft_reset, RUN_ON_CPU_NULL);
     }
 
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index db645a48133..a02e78ce807 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -1559,7 +1559,7 @@ static void handle_diag_318(S390CPU *cpu, struct kvm_run *run)
         return;
     }
 
-    CPU_FOREACH(t) {
+    CPU_FOREACH_KVM(t) {
         run_on_cpu(t, s390_do_cpu_set_diag318,
                    RUN_ON_CPU_HOST_ULONG(diag318_info));
     }
diff --git a/target/s390x/kvm/stsi-topology.c b/target/s390x/kvm/stsi-topology.c
index c8d6389cd87..cf1a9b5d218 100644
--- a/target/s390x/kvm/stsi-topology.c
+++ b/target/s390x/kvm/stsi-topology.c
@@ -10,6 +10,7 @@
 #include "cpu.h"
 #include "hw/s390x/sclp.h"
 #include "hw/s390x/cpu-topology.h"
+#include "system/kvm_int.h"
 
 QEMU_BUILD_BUG_ON(S390_CPU_ENTITLEMENT_LOW != 1);
 QEMU_BUILD_BUG_ON(S390_CPU_ENTITLEMENT_MEDIUM != 2);
@@ -256,7 +257,7 @@ static void s390_topology_fill_list_sorted(S390TopologyList *topology_list)
 
     QTAILQ_INSERT_HEAD(topology_list, &sentinel, next);
 
-    CPU_FOREACH(cs) {
+    CPU_FOREACH_KVM(cs) {
         S390TopologyId id = s390_topology_from_cpu(S390_CPU(cs));
         S390TopologyEntry *entry = NULL, *tmp;
 
-- 
2.47.1


