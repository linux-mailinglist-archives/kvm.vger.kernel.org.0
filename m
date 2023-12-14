Return-Path: <kvm+bounces-4419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 001B0812577
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8503F282E3C
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2388F46AD;
	Thu, 14 Dec 2023 02:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="p3sofx11"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18501D0
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:38 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-4258e0a0dc1so45300791cf.2
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702522057; x=1703126857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ekpxaaikq3I9HLHBaO2l2iBuB2axaTEVCYm2OaBnRno=;
        b=p3sofx11abKQooywzYyPteiIcvfZ7riV6Aa6EAwPAQh2fYduZiYUIQTcgzo9jkag4Q
         c2PcTJhu+0ladh5/S1DKTG4fR+EXb9NsMKAW+sMknOUoJm3M9/22lPZMazM4ZbjFV1ky
         pybaJtrYmnk5DCOlE9NxxYTlO57dI/4C4P9FD1MnGpW8eD6KuDJw0vUjpiuooUZwvam1
         a4Xmh1aiEF9L+VCosq/3jvK9HkzTNSnzvuYKylw/cqyNyO/CbURge1csoT7K1+9EU2w1
         iv6ChdYfUMBMsdKc/hLTMZqT/83uN8jZ51RFy6jBspW/tioOo8cWjdjIe6xGIgzR4jUB
         hJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702522057; x=1703126857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ekpxaaikq3I9HLHBaO2l2iBuB2axaTEVCYm2OaBnRno=;
        b=eru7V7oqWIcgMCTJR74kDAggOSbpJBBdUXygbuNOFQj2jSRY9SDTtmRuaYQ+U74l20
         JJbN548Lka3ejui49mLL9HAAD2KhYzIKWJK4MdcUmpyJsm5jzl3LRCOqZPdwirLU+yl/
         Wlk/ZmZMMJY5Iv8w3VxDtR+ldkHnu1ThVTfwOAxSaUhszqRuovKUkHf145Z93DfdGId5
         Z2mrTleFq1Iui7UxlqaEofsJzKOOjUpmSwrjpWCQWWIatxUccwLUMmycEbOI5aFkIEC1
         bkKA31QmjOz3jsWKsoGKZFPVCtfw5T10FFccOlLXs10r1ZSB+Q1v5ioPEOAvfo3xLH2z
         bJbQ==
X-Gm-Message-State: AOJu0YxtlmTEKueugu2o0jfEk3isUV7IQbmPS+eGLvKcpPglYEhKRq+E
	eGfSlKfiQiOhGH14bNB2M7+esA==
X-Google-Smtp-Source: AGHT+IFvU0N0QxWo4eV6lx4Bbxuz57j3TWF3PwmsDngRIU5vBkxPxZDnBO+vqLYngLOzGAuFoeRARQ==
X-Received: by 2002:a05:622a:10a:b0:423:b290:e7e6 with SMTP id u10-20020a05622a010a00b00423b290e7e6mr12537997qtw.37.1702522057118;
        Wed, 13 Dec 2023 18:47:37 -0800 (PST)
Received: from vinp3lin.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id fh3-20020a05622a588300b00425b356b919sm4240208qtb.55.2023.12.13.18.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 18:47:36 -0800 (PST)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [RFC PATCH 3/8] kvm: x86: vcpu boosting/unboosting framework
Date: Wed, 13 Dec 2023 21:47:20 -0500
Message-ID: <20231214024727.3503870-4-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214024727.3503870-1-vineeth@bitbyteword.org>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the guest kernel is about to run a critical or latency sensitive
workload, it can request the hypervisor to boost the priority of the
vcpu thread. Similarly, guest kernel can request to unboost when the
vcpu switches to a normal workload.

When a guest determines that it needs a boost, it need not immediately
request a synchronous boost as it is already running at that moment.
Synchronous request is detrimental because it incurs a VMEXIT. Rather,
let the guest note down its request on a shared memory and the host can
check this request on next VMEXIT and boost if needed.

Preemption disabled state in a vcpu is also considered latency sensitive
and requires boosting. Guest passes its preemption state to host and
host boosts the vcpu thread as needed.

Unboost requests needs to be synchronous because guest running boosted
while really not required might hurt host workload. Implement a
synchronous mechanism to unboost using MSR_KVM_PV_SCHED. Host checks
the shared memory for boost/unboost request on every VMEXIT. So, the
VMEXIT due to wrmsr(ULLONG_MAX) also goes through a fastexit path which
takes care of the boost/unboost.

Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 arch/x86/include/asm/kvm_host.h      | 42 ++++++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h | 19 +++++++
 arch/x86/kvm/x86.c                   | 48 ++++++++++++++++++
 include/linux/kvm_host.h             | 11 +++++
 virt/kvm/kvm_main.c                  | 74 ++++++++++++++++++++++++++++
 5 files changed, 194 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f89ba1f07d88..474fe2d6d3e0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -994,6 +994,8 @@ struct kvm_vcpu_arch {
 	 */
 	struct {
 		enum kvm_vcpu_boost_state boost_status;
+		int boost_policy;
+		int boost_prio;
 		u64 msr_val;
 		struct gfn_to_hva_cache data;
 	} pv_sched;
@@ -2230,6 +2232,13 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
 #ifdef CONFIG_PARAVIRT_SCHED_KVM
+/*
+ * Default policy and priority used for boosting
+ * VCPU threads.
+ */
+#define VCPU_BOOST_DEFAULT_PRIO	8
+#define VCPU_BOOST_DEFAULT_POLICY	SCHED_RR
+
 static inline bool kvm_arch_vcpu_pv_sched_enabled(struct kvm_vcpu_arch *arch)
 {
 	return arch->pv_sched.msr_val;
@@ -2240,6 +2249,39 @@ static inline void kvm_arch_vcpu_set_boost_status(struct kvm_vcpu_arch *arch,
 {
 	arch->pv_sched.boost_status = boost_status;
 }
+
+static inline bool kvm_arch_vcpu_boosted(struct kvm_vcpu_arch *arch)
+{
+	return arch->pv_sched.boost_status == VCPU_BOOST_BOOSTED;
+}
+
+static inline int kvm_arch_vcpu_boost_policy(struct kvm_vcpu_arch *arch)
+{
+	return arch->pv_sched.boost_policy;
+}
+
+static inline int kvm_arch_vcpu_boost_prio(struct kvm_vcpu_arch *arch)
+{
+	return arch->pv_sched.boost_prio;
+}
+
+static inline int kvm_arch_vcpu_set_boost_prio(struct kvm_vcpu_arch *arch, u64 prio)
+{
+	if (prio >= MAX_RT_PRIO)
+		return -EINVAL;
+
+	arch->pv_sched.boost_prio = prio;
+	return 0;
+}
+
+static inline int kvm_arch_vcpu_set_boost_policy(struct kvm_vcpu_arch *arch, u64 policy)
+{
+	if (policy != SCHED_FIFO && policy != SCHED_RR)
+		return -EINVAL;
+
+	arch->pv_sched.boost_policy = policy;
+	return 0;
+}
 #endif
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6b1dea07a563..e53c3f3a88d7 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -167,11 +167,30 @@ enum kvm_vcpu_boost_state {
 	VCPU_BOOST_BOOSTED
 };
 
+/*
+ * Boost Request from guest to host for lazy boosting.
+ */
+enum kvm_vcpu_boost_request {
+	VCPU_REQ_NONE = 0,
+	VCPU_REQ_UNBOOST,
+	VCPU_REQ_BOOST,
+};
+
+
+union guest_schedinfo {
+	struct {
+		__u8 boost_req;
+		__u8 preempt_disabled;
+	};
+	__u64 pad;
+};
+
 /*
  * Structure passed in via MSR_KVM_PV_SCHED
  */
 struct pv_sched_data {
 	__u64 boost_status;
+	union guest_schedinfo schedinfo;
 };
 
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0f475b50ac83..2577e1083f91 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2148,6 +2148,37 @@ static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 		xfer_to_guest_mode_work_pending();
 }
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+static inline bool __vcpu_needs_boost(struct kvm_vcpu *vcpu, union guest_schedinfo schedinfo)
+{
+	bool pending_event = kvm_cpu_has_pending_timer(vcpu) || kvm_cpu_has_interrupt(vcpu);
+
+	/*
+	 * vcpu needs a boost if
+	 * - A lazy boost request active, or
+	 * - Pending latency sensitive event, or
+	 * - Preemption disabled in this vcpu.
+	 */
+	return (schedinfo.boost_req == VCPU_REQ_BOOST || pending_event || schedinfo.preempt_disabled);
+}
+
+static inline void kvm_vcpu_do_pv_sched(struct kvm_vcpu *vcpu)
+{
+	union guest_schedinfo schedinfo;
+
+	if (!kvm_vcpu_sched_enabled(vcpu))
+		return;
+
+	if (kvm_read_guest_offset_cached(vcpu->kvm, &vcpu->arch.pv_sched.data,
+		&schedinfo, offsetof(struct pv_sched_data, schedinfo), sizeof(schedinfo)))
+		return;
+
+	kvm_vcpu_set_sched(vcpu, __vcpu_needs_boost(vcpu, schedinfo));
+}
+#else
+static inline void kvm_vcpu_do_pv_sched(struct kvm_vcpu *vcpu) { }
+#endif
+
 /*
  * The fast path for frequent and performance sensitive wrmsr emulation,
  * i.e. the sending of IPI, sending IPI early in the VM-Exit flow reduces
@@ -2201,6 +2232,15 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 			ret = EXIT_FASTPATH_REENTER_GUEST;
 		}
 		break;
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	case MSR_KVM_PV_SCHED:
+		data = kvm_read_edx_eax(vcpu);
+		if (data == ULLONG_MAX) {
+			kvm_skip_emulated_instruction(vcpu);
+			ret = EXIT_FASTPATH_EXIT_HANDLED;
+		}
+		break;
+#endif
 	default:
 		break;
 	}
@@ -10919,6 +10959,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	guest_timing_exit_irqoff();
 
 	local_irq_enable();
+
+	kvm_vcpu_do_pv_sched(vcpu);
+
 	preempt_enable();
 
 	kvm_vcpu_srcu_read_lock(vcpu);
@@ -11990,6 +12033,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (r)
 		goto free_guest_fpu;
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	kvm_arch_vcpu_set_boost_prio(&vcpu->arch, VCPU_BOOST_DEFAULT_PRIO);
+	kvm_arch_vcpu_set_boost_policy(&vcpu->arch, VCPU_BOOST_DEFAULT_POLICY);
+#endif
+
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_xen_init_vcpu(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a74aeea55347..c6647f6312c9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2290,6 +2290,17 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 
 #ifdef CONFIG_PARAVIRT_SCHED_KVM
 void kvm_set_vcpu_boosted(struct kvm_vcpu *vcpu, bool boosted);
+int kvm_vcpu_set_sched(struct kvm_vcpu *vcpu, bool boost);
+
+static inline bool kvm_vcpu_sched_enabled(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_pv_sched_enabled(&vcpu->arch);
+}
+#else
+static inline int kvm_vcpu_set_sched(struct kvm_vcpu *vcpu, bool boost)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5bbb5612b207..37748e2512e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -57,6 +57,9 @@
 #include <asm/ioctl.h>
 #include <linux/uaccess.h>
 
+#include <linux/sched.h>
+#include <uapi/linux/sched/types.h>
+
 #include "coalesced_mmio.h"
 #include "async_pf.h"
 #include "kvm_mm.h"
@@ -3602,6 +3605,77 @@ bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+/*
+ * Check if we need to act on the boost/unboost request.
+ * Returns true if:
+ *  - caller is requesting boost and vcpu is boosted, or
+ *  - caller is requesting unboost and vcpu is not boosted.
+ */
+static inline bool __can_ignore_set_sched(struct kvm_vcpu *vcpu, bool boost)
+{
+	return ((boost && kvm_arch_vcpu_boosted(&vcpu->arch)) ||
+		(!boost && !kvm_arch_vcpu_boosted(&vcpu->arch)));
+}
+
+int kvm_vcpu_set_sched(struct kvm_vcpu *vcpu, bool boost)
+{
+	int policy;
+	int ret = 0;
+	struct pid *pid;
+	struct sched_param param = { 0 };
+	struct task_struct *vcpu_task = NULL;
+
+	/*
+	 * We can ignore the request if a boost request comes
+	 * when we are already boosted or an unboost request
+	 * when we are already unboosted.
+	 */
+	if (__can_ignore_set_sched(vcpu, boost))
+		goto set_boost_status;
+
+	if (boost) {
+		policy = kvm_arch_vcpu_boost_policy(&vcpu->arch);
+		param.sched_priority = kvm_arch_vcpu_boost_prio(&vcpu->arch);
+	} else {
+		/*
+		 * TODO: here we just unboost to SCHED_NORMAL. Ideally we
+		 * should either
+		 * - revert to the initial priority before boost, or
+		 * - introduce tunables for unboost priority.
+		 */
+		policy = SCHED_NORMAL;
+		param.sched_priority = 0;
+	}
+
+	rcu_read_lock();
+	pid = rcu_dereference(vcpu->pid);
+	if (pid)
+		vcpu_task = get_pid_task(pid, PIDTYPE_PID);
+	rcu_read_unlock();
+	if (vcpu_task == NULL)
+		return -KVM_EINVAL;
+
+	/*
+	 * This might be called from interrupt context.
+	 * Since we do not use rt-mutexes, we can safely call
+	 * sched_setscheduler_pi_nocheck with pi = false.
+	 * NOTE: If in future, we use rt-mutexes, this should
+	 * be modified to use a tasklet to do boost/unboost.
+	 */
+	WARN_ON_ONCE(vcpu_task->pi_top_task);
+	ret = sched_setscheduler_pi_nocheck(vcpu_task, policy,
+			&param, false);
+	put_task_struct(vcpu_task);
+set_boost_status:
+	if (!ret)
+		kvm_set_vcpu_boosted(vcpu, boost);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_set_sched);
+#endif
+
 #ifndef CONFIG_S390
 /*
  * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
-- 
2.43.0


