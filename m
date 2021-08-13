Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE093EB9F3
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 18:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhHMQWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 12:22:23 -0400
Received: from smtp179.sjtu.edu.cn ([202.120.2.179]:37590 "EHLO
        smtp179.sjtu.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhHMQWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 12:22:22 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2021 12:22:21 EDT
Received: from proxy01.sjtu.edu.cn (smtp185.sjtu.edu.cn [202.120.2.185])
        by smtp179.sjtu.edu.cn (Postfix) with ESMTPS id 26ACC100888E1;
        Sat, 14 Aug 2021 00:14:33 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by proxy01.sjtu.edu.cn (Postfix) with ESMTP id E10DF205420A1;
        Sat, 14 Aug 2021 00:14:32 +0800 (CST)
X-Virus-Scanned: amavisd-new at proxy01.sjtu.edu.cn
Received: from proxy01.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy01.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pLSTk6HgRYaz; Sat, 14 Aug 2021 00:14:32 +0800 (CST)
Received: from sky.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
        (Authenticated sender: skyele@sjtu.edu.cn)
        by proxy01.sjtu.edu.cn (Postfix) with ESMTPSA id DBCC92044AFEB;
        Sat, 14 Aug 2021 00:14:18 +0800 (CST)
From:   Tianqiang Xu <skyele@sjtu.edu.cn>
To:     x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        kvm@vger.kernel.org, hpa@zytor.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Tianqiang Xu <skyele@sjtu.edu.cn>
Subject: [PATCH] KVM: x86: add a new field 'is_idle' to kvm_steal_time
Date:   Sat, 14 Aug 2021 00:14:13 +0800
Message-Id: <20210813161413.17255-1-skyele@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch aims to fix performance issue caused by current
para-virtualized scheduling design.

The current para-virtualized scheduling design uses 'preempted' field of
kvm_steal_time to avoid scheduling task on the preempted vCPU.
However, when the pCPU where the preempted vCPU most recently run is idle,
it will result in low cpu utilization, and consequently poor performance.

The new field: 'is_idle' of kvm_steal_time can precisely reveal the status of
pCPU where preempted vCPU most recently run, and then improve cpu utilization.

Host OS sets this field to 1 if cpu_rq(this_cpu)->nr_running is 1 before
a vCPU being scheduled out. On this condition, there is no other task on
this pCPU to run. Thus, is_idle == 1 means the pCPU where the preempted
vCPU most recently run is idle.

Guest OS uses this field to know if a pCPU is idle and decides whether
to schedule a task to a preempted vCPU or not. If the pCPU is idle,
scheduling a task to this pCPU will improve cpu utilization. If not,
avoiding scheduling a task to this preempted vCPU can avoid host/guest
switch, hence improving performance.

Experiments on a VM with 16 vCPUs show that the patch can reduce around
50% to 80% execution time for most PARSEC benchmarks. 
This also holds true for a VM with 112 vCPUs.

Experiments on 2 VMs with 112 vCPUs show that the patch can reduce around
20% to 80% execution time for most PARSEC benchmarks. 

Test environment:
-- PowerEdge R740
-- 56C-112T CPU Intel(R) Xeon(R) Gold 6238R CPU
-- Host 190G DRAM
-- QEMU 5.0.0
-- PARSEC 3.0 Native Inputs
-- Host is idle during the test
-- Host and Guest kernel are both kernel-5.14.0

Results:
1. 1 VM, 16 VCPU, 16 THREAD.
   Host Topology: sockets=2 cores=28 threads=2
   VM Topology:   sockets=1 cores=16 threads=1
   Command: <path to parsec>/bin/parsecmgmt -a run -p <benchmark> -i native -n 16
   Statistics below are the real time of running each benchmark.(lower is better)

                    before patch    after patch     improvements
bodytrack           52.866s         22.619s         57.21%
fluidanimate        84.009s         38.148s         54.59%
streamcluster       270.17s         42.726s         84.19%
splash2x.ocean_cp   31.932s         9.539s          70.13%
splash2x.ocean_ncp  36.063s         14.189s         60.65%
splash2x.volrend    134.587s        21.79s          83.81%

2. 1VM, 112 VCPU. Some benchmarks require the number of threads to be the power of 2,
so we run them with 64 threads and 128 threads.
   Host Topology: sockets=2 cores=28 threads=2
   VM Topology:   sockets=1 cores=112 threads=1
   Command: <path to parsec>/bin/parsecmgmt -a run -p <benchmark> -i native -n <64,112,128>
   Statistics below are the real time of running each benchmark.(lower is better)

   

                                before patch    after patch     improvements
fluidanimate(64 thread)         124.235s        27.924s         77.52%
fluidanimate(128 thread)        169.127s        64.541s         61.84%
streamcluster(112 thread)       861.879s        496.66s         42.37%
splash2x.ocean_cp(64 thread)    46.415s         18.527s         60.08%
splash2x.ocean_cp(128 thread)   53.647s         28.929s         46.08%
splash2x.ocean_ncp(64 thread)   47.613s         19.576s         58.89%
splash2x.ocean_ncp(128 thread)  54.94s          29.199s         46.85%
splash2x.volrend(112 thread)    801.384s        144.824s        81.93%

3. 2VM, each VM: 112 VCPU. Some benchmarks require the number of threads to
be the power of 2, so we run them with 64 threads and 128 threads.
   Host Topology: sockets=2 cores=28 threads=2
   VM Topology:   sockets=1 cores=112 threads=1
   Command: <path to parsec>/bin/parsecmgmt -a run -p <benchmark> -i native -n <64,112,128>
   Statistics below are the average real time of running each benchmark in 2 VMs.(lower is better)
                                before patch    after patch     improvements
fluidanimate(64 thread)         135.2125s       49.827s         63.15%
fluidanimate(128 thread)        178.309s        86.964s         51.23%
splash2x.ocean_cp(64 thread)    47.4505s        20.314s         57.19%
splash2x.ocean_cp(128 thread)   55.5645s        30.6515s        44.84%
splash2x.ocean_ncp(64 thread)   49.9775s        23.489s         53.00%
splash2x.ocean_ncp(128 thread)  56.847s         28.545s         49.79%
splash2x.volrend(112 thread)    838.939s        239.632s        71.44%

For space limit, we list representative statistics here.

--
Authors: Tianqiang Xu, Dingji Li, Zeyu Mi
         Shanghai Jiao Tong University

Signed-off-by: Tianqiang Xu <skyele@sjtu.edu.cn>
---
 arch/x86/hyperv/hv_spinlock.c         |  7 +++
 arch/x86/include/asm/cpufeatures.h    |  1 +
 arch/x86/include/asm/kvm_host.h       |  1 +
 arch/x86/include/asm/paravirt.h       |  8 +++
 arch/x86/include/asm/paravirt_types.h |  1 +
 arch/x86/include/asm/qspinlock.h      |  6 ++
 arch/x86/include/uapi/asm/kvm_para.h  |  4 +-
 arch/x86/kernel/asm-offsets_64.c      |  1 +
 arch/x86/kernel/kvm.c                 | 23 +++++++
 arch/x86/kernel/paravirt-spinlocks.c  | 15 +++++
 arch/x86/kernel/paravirt.c            |  2 +
 arch/x86/kvm/x86.c                    | 90 ++++++++++++++++++++++++++-
 include/linux/sched.h                 |  1 +
 kernel/sched/core.c                   | 17 +++++
 kernel/sched/sched.h                  |  1 +
 15 files changed, 176 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/hv_spinlock.c b/arch/x86/hyperv/hv_spinlock.c
index 91cfe698bde0..b8c32b719cab 100644
--- a/arch/x86/hyperv/hv_spinlock.c
+++ b/arch/x86/hyperv/hv_spinlock.c
@@ -66,6 +66,12 @@ __visible bool hv_vcpu_is_preempted(int vcpu)
 }
 PV_CALLEE_SAVE_REGS_THUNK(hv_vcpu_is_preempted);
 
+__visible bool hv_pcpu_is_idle(int vcpu)
+{
+	return false;
+}
+PV_CALLEE_SAVE_REGS_THUNK(hv_pcpu_is_idle);
+
 void __init hv_init_spinlocks(void)
 {
 	if (!hv_pvspin || !apic ||
@@ -82,6 +88,7 @@ void __init hv_init_spinlocks(void)
 	pv_ops.lock.wait = hv_qlock_wait;
 	pv_ops.lock.kick = hv_qlock_kick;
 	pv_ops.lock.vcpu_is_preempted = PV_CALLEE_SAVE(hv_vcpu_is_preempted);
+	pv_ops.lock.pcpu_is_idle = PV_CALLEE_SAVE(hv_pcpu_is_idle);
 }
 
 static __init int hv_parse_nopvspin(char *arg)
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d0ce5cfd3ac1..8a078619c9de 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -238,6 +238,7 @@
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
 #define X86_FEATURE_PVUNLOCK		( 8*32+20) /* "" PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* "" PV vcpu_is_preempted function */
+#define X86_FEATURE_PCPUISIDLE		( 8*32+22) /* "" PV pcpu_is_idle function */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..bed0ab7233be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -742,6 +742,7 @@ struct kvm_vcpu_arch {
 
 	struct {
 		u8 preempted;
+		u8 is_idle;
 		u64 msr_val;
 		u64 last_steal;
 		struct gfn_to_pfn_cache cache;
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index da3a1ac82be5..f34dec6eb515 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -609,8 +609,16 @@ static __always_inline bool pv_vcpu_is_preempted(long cpu)
 				ALT_NOT(X86_FEATURE_VCPUPREEMPT));
 }
 
+static __always_inline bool pv_pcpu_is_idle(long cpu)
+{
+	return PVOP_ALT_CALLEE1(bool, lock.pcpu_is_idle, cpu,
+				"xor %%" _ASM_AX ", %%" _ASM_AX ";",
+				ALT_NOT(X86_FEATURE_PCPUISIDLE));
+}
+
 void __raw_callee_save___native_queued_spin_unlock(struct qspinlock *lock);
 bool __raw_callee_save___native_vcpu_is_preempted(long cpu);
+bool __raw_callee_save___native_pcpu_is_idle(long cpu);
 
 #endif /* SMP && PARAVIRT_SPINLOCKS */
 
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index d9d6b0203ec4..7d9b5906580c 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -257,6 +257,7 @@ struct pv_lock_ops {
 	void (*kick)(int cpu);
 
 	struct paravirt_callee_save vcpu_is_preempted;
+	struct paravirt_callee_save pcpu_is_idle;
 } __no_randomize_layout;
 
 /* This contains all the paravirt structures: we get a convenient
diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index d86ab942219c..1832dd8308ca 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -61,6 +61,12 @@ static inline bool vcpu_is_preempted(long cpu)
 {
 	return pv_vcpu_is_preempted(cpu);
 }
+
+#define pcpu_is_idle pcpu_is_idle
+static inline bool pcpu_is_idle(long cpu)
+{
+	return pv_pcpu_is_idle(cpu);
+}
 #endif
 
 #ifdef CONFIG_PARAVIRT
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 5146bbab84d4..2af305ba030a 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -63,12 +63,14 @@ struct kvm_steal_time {
 	__u32 version;
 	__u32 flags;
 	__u8  preempted;
-	__u8  u8_pad[3];
+	__u8  is_idle;
+	__u8  u8_pad[2];
 	__u32 pad[11];
 };
 
 #define KVM_VCPU_PREEMPTED          (1 << 0)
 #define KVM_VCPU_FLUSH_TLB          (1 << 1)
+#define KVM_PCPU_IS_IDLE          (1 << 0)
 
 #define KVM_CLOCK_PAIRING_WALLCLOCK 0
 struct kvm_clock_pairing {
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index b14533af7676..b587bbe44470 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -22,6 +22,7 @@ int main(void)
 
 #if defined(CONFIG_KVM_GUEST) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 	OFFSET(KVM_STEAL_TIME_preempted, kvm_steal_time, preempted);
+	OFFSET(KVM_STEAL_TIME_is_idle, kvm_steal_time, is_idle);
 	BLANK();
 #endif
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a26643dc6bd6..274d205b744c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -900,11 +900,20 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
 }
 PV_CALLEE_SAVE_REGS_THUNK(__kvm_vcpu_is_preempted);
 
+__visible bool __kvm_pcpu_is_idle(long cpu)
+{
+	struct kvm_steal_time *src = &per_cpu(steal_time, cpu);
+
+	return !!(src->is_idle & KVM_PCPU_IS_IDLE);
+}
+PV_CALLEE_SAVE_REGS_THUNK(__kvm_pcpu_is_idle);
+
 #else
 
 #include <asm/asm-offsets.h>
 
 extern bool __raw_callee_save___kvm_vcpu_is_preempted(long);
+extern bool __raw_callee_save___kvm_pcpu_is_idle(long);
 
 /*
  * Hand-optimize version for x86-64 to avoid 8 64-bit register saving and
@@ -922,6 +931,18 @@ asm(
 ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
 ".popsection");
 
+asm(
+".pushsection .text;"
+".global __raw_callee_save___kvm_pcpu_is_idle;"
+".type __raw_callee_save___kvm_pcpu_is_idle, @function;"
+"__raw_callee_save___kvm_pcpu_is_idle:"
+"movq	__per_cpu_offset(,%rdi,8), %rax;"
+"cmpb	$0, " __stringify(KVM_STEAL_TIME_is_idle) "+steal_time(%rax);"
+"setne	%al;"
+"ret;"
+".size __raw_callee_save___kvm_pcpu_is_idle, .-__raw_callee_save___kvm_pcpu_is_idle;"
+".popsection");
+
 #endif
 
 /*
@@ -970,6 +991,8 @@ void __init kvm_spinlock_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
 		pv_ops.lock.vcpu_is_preempted =
 			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
+		pv_ops.lock.pcpu_is_idle =
+			PV_CALLEE_SAVE(__kvm_pcpu_is_idle);
 	}
 	/*
 	 * When PV spinlock is enabled which is preferred over
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 9e1ea99ad9df..d7f6a461d0a5 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -27,12 +27,24 @@ __visible bool __native_vcpu_is_preempted(long cpu)
 }
 PV_CALLEE_SAVE_REGS_THUNK(__native_vcpu_is_preempted);
 
+__visible bool __native_pcpu_is_idle(long cpu)
+{
+	return false;
+}
+PV_CALLEE_SAVE_REGS_THUNK(__native_pcpu_is_idle);
+
 bool pv_is_native_vcpu_is_preempted(void)
 {
 	return pv_ops.lock.vcpu_is_preempted.func ==
 		__raw_callee_save___native_vcpu_is_preempted;
 }
 
+bool pv_is_native_pcpu_is_idle(void)
+{
+	return pv_ops.lock.pcpu_is_idle.func ==
+		__raw_callee_save___native_pcpu_is_idle;
+}
+
 void __init paravirt_set_cap(void)
 {
 	if (!pv_is_native_spin_unlock())
@@ -40,4 +52,7 @@ void __init paravirt_set_cap(void)
 
 	if (!pv_is_native_vcpu_is_preempted())
 		setup_force_cpu_cap(X86_FEATURE_VCPUPREEMPT);
+
+	if (!pv_is_native_pcpu_is_idle())
+		setup_force_cpu_cap(X86_FEATURE_PCPUISIDLE);
 }
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 04cafc057bed..4489ca6d28c3 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -366,6 +366,8 @@ struct paravirt_patch_template pv_ops = {
 	.lock.kick			= paravirt_nop,
 	.lock.vcpu_is_preempted		=
 				PV_CALLEE_SAVE(__native_vcpu_is_preempted),
+	.lock.pcpu_is_idle              =
+				PV_CALLEE_SAVE(__native_pcpu_is_idle),
 #endif /* SMP */
 #endif
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..61bd01f82cdb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3181,6 +3181,72 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 
+static void kvm_steal_time_set_is_idle(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_map map;
+	struct kvm_steal_time *st;
+
+	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
+		return;
+
+	if (vcpu->arch.st.is_idle)
+		return;
+
+	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
+			&vcpu->arch.st.cache, true))
+		return;
+
+	st = map.hva +
+		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+
+	st->is_idle = vcpu->arch.st.is_idle = KVM_PCPU_IS_IDLE;
+
+	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
+}
+
+static void kvm_steal_time_clear_is_idle(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_map map;
+	struct kvm_steal_time *st;
+
+	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
+		return;
+
+	if (!vcpu->arch.st.is_idle)
+		return;
+
+	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
+			&vcpu->arch.st.cache, false))
+		return;
+
+	st = map.hva +
+		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+
+	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH))
+		xchg(&st->is_idle, 0);
+	else
+		st->is_idle = 0;
+
+	vcpu->arch.st.is_idle = 0;
+
+	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
+}
+
+
+static DEFINE_PER_CPU(struct kvm_vcpu *, this_cpu_pre_run_vcpu);
+
+static void vcpu_load_update_pre_vcpu_callback(struct kvm_vcpu *new_vcpu, struct kvm_steal_time *st)
+{
+	struct kvm_vcpu *old_vcpu = __this_cpu_read(this_cpu_pre_run_vcpu);
+
+	if (!old_vcpu)
+		return;
+	if (old_vcpu != new_vcpu)
+		kvm_steal_time_clear_is_idle(old_vcpu);
+	else
+		st->is_idle = new_vcpu->arch.st.is_idle = KVM_PCPU_IS_IDLE;
+}
+
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm_host_map map;
@@ -3219,6 +3285,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.st.preempted = 0;
 
+	vcpu_load_update_pre_vcpu_callback(vcpu, st);
+
 	if (st->version & 1)
 		st->version += 1;  /* first time write, random junk */
 
@@ -4290,6 +4358,8 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
 }
 
+extern int get_cpu_nr_running(int cpu);
+
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
@@ -4304,8 +4374,15 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (kvm_xen_msr_enabled(vcpu->kvm))
 		kvm_xen_runstate_set_preempted(vcpu);
-	else
+	else {
 		kvm_steal_time_set_preempted(vcpu);
+
+		if (get_cpu_nr_running(smp_processor_id()) <= 1)
+			kvm_steal_time_set_is_idle(vcpu);
+		else
+			kvm_steal_time_clear_is_idle(vcpu);
+	}
+
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
@@ -9693,6 +9770,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 	preempt_enable();
 
+	__this_cpu_write(this_cpu_pre_run_vcpu, vcpu);
+
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	/*
@@ -11253,6 +11332,15 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	int cpu;
+	struct kvm_vcpu *vcpu;
+
+	for_each_possible_cpu(cpu) {
+		vcpu = per_cpu(this_cpu_pre_run_vcpu, cpu);
+		if (vcpu && vcpu->kvm == kvm)
+			per_cpu(this_cpu_pre_run_vcpu, cpu) = NULL;
+	}
+
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ec8d07d88641..dd4c41d2d8d3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1736,6 +1736,7 @@ extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
 extern int available_idle_cpu(int cpu);
+extern int available_idle_cpu_sched(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int, const struct sched_param *);
 extern void sched_set_fifo(struct task_struct *p);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 20ffcc044134..1bcc023ce581 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6664,6 +6664,17 @@ int available_idle_cpu(int cpu)
 	return 1;
 }
 
+int available_idle_cpu_sched(int cpu)
+{
+	if (!idle_cpu(cpu))
+		return 0;
+
+	if (!pcpu_is_idle(cpu))
+		return 0;
+
+	return 1;
+}
+
 /**
  * idle_task - return the idle task for a given CPU.
  * @cpu: the processor in question.
@@ -10413,3 +10424,9 @@ void call_trace_sched_update_nr_running(struct rq *rq, int count)
 {
         trace_sched_update_nr_running_tp(rq, count);
 }
+
+int get_cpu_nr_running(int cpu)
+{
+	return cpu_rq(cpu)->nr_running;
+}
+EXPORT_SYMBOL_GPL(get_cpu_nr_running);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 14a41a243f7b..49daefa91470 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -101,6 +101,7 @@ extern void calc_global_load_tick(struct rq *this_rq);
 extern long calc_load_fold_active(struct rq *this_rq, long adjust);
 
 extern void call_trace_sched_update_nr_running(struct rq *rq, int count);
+
 /*
  * Helpers for converting nanosecond timing to jiffy resolution
  */
-- 
2.26.3

