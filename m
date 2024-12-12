Return-Path: <kvm+bounces-33586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCAE39EED1A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 16:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD309164FEC
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 15:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973892185B1;
	Thu, 12 Dec 2024 15:39:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33F86F2FE
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 15:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017957; cv=none; b=oDBgrw7X4x6ppb1DM5XuU1CI7itfVGSqBtHx9pdXBrKc32wea2ekxaNWCqxX/BTzLlr7V2wSTeW78H6xbGsTxKtZ3R1kIklruyKB1smoI2J/+TE3XvW/q6G3LIqHDXtvxVyH1HpfgBdeOWBYox362va4RA0f0B2vA43aXJr8EzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017957; c=relaxed/simple;
	bh=YOOEBPTJZDrSeED6ji+So3Mj4MJWAInvl0Qni0IrTn0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f1wXlyAatGhEUbaLJ2usyCKy/w1dt+lOwRhSyCFs9AXyGYbkAS+ODa0Jl3h81er9w2SMGRtogI9yqH/gpLzaAE1+YVE2n3jwuxtWCp0xJtFXOJkVyqXzYElYxLAZ+km1Uj+0mAcIlBxoh9grEczns+fBHv7IUxbvm8r0ApBc9c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1tLkXB-00000003f6l-1DsD;
	Thu, 12 Dec 2024 15:51:21 +0100
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH] target/i386: Reset TSCs of parked vCPUs too on VM reset
Date: Thu, 12 Dec 2024 15:51:15 +0100
Message-ID: <5a605a88e9a231386dc803c60f5fed9b48108139.1734014926.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: mhej@vps-ovh.mhejs.net

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Since commit 5286c3662294 ("target/i386: properly reset TSC on reset")
QEMU writes the special value of "1" to each online vCPU TSC on VM reset
to reset it.

However parked vCPUs don't get that handling and due to that their TSCs
get desynchronized when the VM gets reset.
This in turn causes KVM to turn off PVCLOCK_TSC_STABLE_BIT in its exported
PV clock.
Note that KVM has no understanding of vCPU being currently parked.

Without PVCLOCK_TSC_STABLE_BIT the sched clock is marked unstable in
the guest's kvm_sched_clock_init().
This causes a performance regressions to show in some tests.

Fix this issue by writing the special value of "1" also to TSCs of parked
vCPUs on VM reset.


Reproducing the issue:
1) Boot a VM with "-smp 2,maxcpus=3" or similar

2) device_add host-x86_64-cpu,id=vcpu,node-id=0,socket-id=0,core-id=2,thread-id=0

3) Wait a few seconds

4) device_del vcpu

5) Inside the VM run:
# echo "t" >/proc/sysrq-trigger; dmesg | grep sched_clock_stable
Observe the sched_clock_stable() value is 1.

6) Reboot the VM

7) Once the VM boots once again run inside it:
# echo "t" >/proc/sysrq-trigger; dmesg | grep sched_clock_stable
Observe the sched_clock_stable() value is now 0.


Fixes: 5286c3662294 ("target/i386: properly reset TSC on reset")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 accel/kvm/kvm-all.c                | 11 +++++++++++
 configs/targets/i386-softmmu.mak   |  1 +
 configs/targets/x86_64-softmmu.mak |  1 +
 include/sysemu/kvm.h               |  8 ++++++++
 target/i386/kvm/kvm.c              | 15 +++++++++++++++
 5 files changed, 36 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 801cff16a5a2..dec1d1c16a0d 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -437,6 +437,16 @@ int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
     return kvm_fd;
 }
 
+static void kvm_reset_parked_vcpus(void *param)
+{
+    KVMState *s = param;
+    struct KVMParkedVcpu *cpu;
+
+    QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
+        kvm_arch_reset_parked_vcpu(cpu->vcpu_id, cpu->kvm_fd);
+    }
+}
+
 int kvm_create_vcpu(CPUState *cpu)
 {
     unsigned long vcpu_id = kvm_arch_vcpu_id(cpu);
@@ -2728,6 +2738,7 @@ static int kvm_init(MachineState *ms)
     }
 
     qemu_register_reset(kvm_unpoison_all, NULL);
+    qemu_register_reset(kvm_reset_parked_vcpus, s);
 
     if (s->kernel_irqchip_allowed) {
         kvm_irqchip_create(s);
diff --git a/configs/targets/i386-softmmu.mak b/configs/targets/i386-softmmu.mak
index 2ac69d5ba370..2eb0e8625005 100644
--- a/configs/targets/i386-softmmu.mak
+++ b/configs/targets/i386-softmmu.mak
@@ -1,4 +1,5 @@
 TARGET_ARCH=i386
 TARGET_SUPPORTS_MTTCG=y
 TARGET_KVM_HAVE_GUEST_DEBUG=y
+TARGET_KVM_HAVE_RESET_PARKED_VCPU=y
 TARGET_XML_FILES= gdb-xml/i386-32bit.xml
diff --git a/configs/targets/x86_64-softmmu.mak b/configs/targets/x86_64-softmmu.mak
index e12ac3dc59bf..920e9a42006f 100644
--- a/configs/targets/x86_64-softmmu.mak
+++ b/configs/targets/x86_64-softmmu.mak
@@ -2,4 +2,5 @@ TARGET_ARCH=x86_64
 TARGET_BASE_ARCH=i386
 TARGET_SUPPORTS_MTTCG=y
 TARGET_KVM_HAVE_GUEST_DEBUG=y
+TARGET_KVM_HAVE_RESET_PARKED_VCPU=y
 TARGET_XML_FILES= gdb-xml/i386-64bit.xml
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index c3a60b28909a..ab17c09a551f 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -377,6 +377,14 @@ int kvm_arch_init(MachineState *ms, KVMState *s);
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
 
+#ifdef TARGET_KVM_HAVE_RESET_PARKED_VCPU
+void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd);
+#else
+static inline void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd)
+{
+}
+#endif
+
 bool kvm_vcpu_id_is_valid(int vcpu_id);
 
 /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8e17942c3ba1..2ff618fbf138 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2415,6 +2415,21 @@ void kvm_arch_after_reset_vcpu(X86CPU *cpu)
     }
 }
 
+void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd)
+{
+    g_autofree struct kvm_msrs *msrs = NULL;
+
+    msrs = g_malloc0(sizeof(*msrs) + sizeof(msrs->entries[0]));
+    msrs->entries[0].index = MSR_IA32_TSC;
+    msrs->entries[0].data = 1; /* match the value in x86_cpu_reset() */
+    msrs->nmsrs++;
+
+    if (ioctl(kvm_fd, KVM_SET_MSRS, msrs) != 1) {
+        warn_report("parked vCPU %lu TSC reset failed: %d",
+                    vcpu_id, errno);
+    }
+}
+
 void kvm_arch_do_init_vcpu(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;

