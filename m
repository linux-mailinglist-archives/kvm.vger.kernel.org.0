Return-Path: <kvm+bounces-4420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE662812579
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56295282F59
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C99D24C85;
	Thu, 14 Dec 2023 02:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="eQccfhVk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD40114
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:41 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-425e58bd4c8so13491471cf.3
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702522060; x=1703126860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ntiXZyzgAfw7DEiUwC2cla+1/r+Z91Px9imV7BJfm4E=;
        b=eQccfhVk7nDYWuJiaMHSFst/2lfRIsQ5LcVGGPwzOro5E4IPE1jJq+4zmfiTV9fW1/
         JGLtODe28w1wrfnlDnMMAx73YW5V20GAbAKmbOsqSH4llz/cO0+ogVRiKpPYI4RKn5yw
         ZPJHR51ztl6mJQ+an3niXS8WJ9Au7nx8IKJ4Z7hAiae2xd7Flwme1gN9ZC18Jvv8hH/c
         pQlyqj+lvOVz8ZCFRV2lXN+WWu1QQE6sw88b+COl0DZL0SLEOn6wPpvy4xJGXE0/gccq
         4cmLLsGp5h89B3YKsmHKHPKcrMHQ/eMYQAbYVRtP9iDyseLKoe8sB4rv9KIBZz0Pkp+/
         6hyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702522060; x=1703126860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ntiXZyzgAfw7DEiUwC2cla+1/r+Z91Px9imV7BJfm4E=;
        b=Fw91cE3QroN8e/CUOmjwXoxj3VB5v4XKX84KnI+jVadixo6t7QX7UQNq/siKajd3sX
         xa+Dq0VVFK/TJFqIdQLMf1yaeS8Kf1QeRj+jvcSO7yyMAzQSkfx6IrlZGoMQB2ZVHu0/
         GnpQUZvlNSUC2GEnW5fRoTBhyzrPrjqeY6T3+axS5whFkFwuFGQsvXLMM/73sG15O7n1
         lw4nBiVIT2Tfhd4NF7X1Y6QeOuw6KDT9OXgBDM355H3Tlg79N+MAnrPNL5o8TqbvX42g
         TaTpqPsEVtSJV0KiR+AmLgPtqXotCpjG49HKjVU9X7D9TOBt0QWnEHauQ9Ir92CYDi8Y
         W5Hg==
X-Gm-Message-State: AOJu0YyZVbz2XLPxbX7d786bco7fL21ZOSbNuY7cmflfMFqDFMRgfqaP
	u+PCBk/dbSMswUsjvkAbfod4JA==
X-Google-Smtp-Source: AGHT+IFp1ZD52g4ymlbxazKG1B37Keyo6/4q8bj6M6rVdCJFfpmlC4GJ0ji/8pgJ8q6GEwLUiO0XHA==
X-Received: by 2002:ac8:4e52:0:b0:425:9ab0:467a with SMTP id e18-20020ac84e52000000b004259ab0467amr10005951qtw.19.1702522060183;
        Wed, 13 Dec 2023 18:47:40 -0800 (PST)
Received: from vinp3lin.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id fh3-20020a05622a588300b00425b356b919sm4240208qtb.55.2023.12.13.18.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 18:47:39 -0800 (PST)
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
Subject: [RFC PATCH 5/8] kvm: x86: upper bound for preemption based boost duration
Date: Wed, 13 Dec 2023 21:47:22 -0500
Message-ID: <20231214024727.3503870-6-vineeth@bitbyteword.org>
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

Guest requests boost on preempt disable but doesn't request unboost on
preempt enable. This may cause the guest vcpu to be boosted for longer
than what it deserves. Also, there are lots of preemption disabled paths
in kernel and some could be quite long.

This patch sets a bound on the maximum time a vcpu is boosted due to
preemption disabled in guest. Default is 3000us, and could be changed
via kvm module parameter.

Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 49 ++++++++++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 474fe2d6d3e0..6a8326baa6a0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -994,6 +994,8 @@ struct kvm_vcpu_arch {
 	 */
 	struct {
 		enum kvm_vcpu_boost_state boost_status;
+		bool preempt_disabled;
+		ktime_t preempt_disabled_ts;
 		int boost_policy;
 		int boost_prio;
 		u64 msr_val;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2577e1083f91..8c15c6ff352e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -199,6 +199,15 @@ module_param(eager_page_split, bool, 0644);
 static bool __read_mostly mitigate_smt_rsb;
 module_param(mitigate_smt_rsb, bool, 0444);
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+/*
+ * Maximum time in micro seconds a guest vcpu can stay boosted due
+ * to preemption disabled.
+ */
+unsigned int pvsched_max_preempt_disabled_us = 3000;
+module_param(pvsched_max_preempt_disabled_us, uint, 0644);
+#endif
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -2149,17 +2158,47 @@ static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_PARAVIRT_SCHED_KVM
+static inline void kvm_vcpu_update_preempt_disabled(struct kvm_vcpu_arch *arch,
+		bool preempt_disabled)
+{
+	if (arch->pv_sched.preempt_disabled != preempt_disabled) {
+		arch->pv_sched.preempt_disabled = preempt_disabled;
+		if (preempt_disabled)
+			arch->pv_sched.preempt_disabled_ts = ktime_get();
+		else
+			arch->pv_sched.preempt_disabled_ts = 0;
+	}
+}
+
+static inline bool kvm_vcpu_exceeds_preempt_disabled_duration(struct kvm_vcpu_arch *arch)
+{
+	s64 max_delta = pvsched_max_preempt_disabled_us * NSEC_PER_USEC;
+
+	if (max_delta && arch->pv_sched.preempt_disabled) {
+		s64 delta;
+
+		WARN_ON_ONCE(arch->pv_sched.preempt_disabled_ts == 0);
+		delta = ktime_to_ns(ktime_sub(ktime_get(),
+					arch->pv_sched.preempt_disabled_ts));
+
+		if (delta >= max_delta)
+			return true;
+	}
+
+	return false;
+}
+
 static inline bool __vcpu_needs_boost(struct kvm_vcpu *vcpu, union guest_schedinfo schedinfo)
 {
 	bool pending_event = kvm_cpu_has_pending_timer(vcpu) || kvm_cpu_has_interrupt(vcpu);
 
 	/*
 	 * vcpu needs a boost if
-	 * - A lazy boost request active, or
-	 * - Pending latency sensitive event, or
-	 * - Preemption disabled in this vcpu.
+	 * - A lazy boost request active or a pending latency sensitive event, and
+	 * - Preemption disabled duration on this vcpu has not crossed the threshold.
 	 */
-	return (schedinfo.boost_req == VCPU_REQ_BOOST || pending_event || schedinfo.preempt_disabled);
+	return ((schedinfo.boost_req == VCPU_REQ_BOOST || pending_event) &&
+			!kvm_vcpu_exceeds_preempt_disabled_duration(&vcpu->arch));
 }
 
 static inline void kvm_vcpu_do_pv_sched(struct kvm_vcpu *vcpu)
@@ -2173,6 +2212,8 @@ static inline void kvm_vcpu_do_pv_sched(struct kvm_vcpu *vcpu)
 		&schedinfo, offsetof(struct pv_sched_data, schedinfo), sizeof(schedinfo)))
 		return;
 
+	kvm_vcpu_update_preempt_disabled(&vcpu->arch, schedinfo.preempt_disabled);
+
 	kvm_vcpu_set_sched(vcpu, __vcpu_needs_boost(vcpu, schedinfo));
 }
 #else
-- 
2.43.0


