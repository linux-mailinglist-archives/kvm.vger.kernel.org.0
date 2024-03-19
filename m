Return-Path: <kvm+bounces-12165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2270388029D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB61E284F00
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF06013AF2;
	Tue, 19 Mar 2024 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aev290IT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8120A11723
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710866658; cv=none; b=Mncy30Uxi+SErIEqQ4XC65+AVnxLCazhMh0pk2MhS5vzI4ZIxtFv8N4vuJPYqAm/ToKzg3V2xc2hI8JOU+XXUlRbEt6GmHtweKHpXu4laSWQSjcZVWH3d5b6tRPszBwDl4C3wX1iNmgSd32NsXwOUzb2rfDIdHaVu5DvQilrjwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710866658; c=relaxed/simple;
	bh=+n/b8fA9MMXRAFLGykf1jkNKxKU7ByBWxVaJX4iqWpY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jbsvBpHDdR/PnS0YlFosOXrupyqsTI4MJrcprz7yh9Hw8vb/W8Lq5E00R+N9vvEfpHmiZK6I7oTcIIlovByv0nuEt4vg7f85V7jo9d/UmCs0wShexSBaLBrFXEN4sibmtcfUp+/cQrZ1IDJtpf3PRWmw++BppL4+EnSWDpbGOJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aev290IT; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-7cbfd9f04e3so3755639f.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 09:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710866655; x=1711471455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=55tADTKr/fKtx+P9Mx3gQHhaNaSTbLjPsk1QuvUf7uI=;
        b=aev290IT6mqhafhMQ3v+yjsIIJ3f8VQFG0x1rQDANfp2Yc4WuRQxdU7VV6UA/e3ELN
         CYn1BkWx25xosqrjb6uGm0UX/6PAqA9zraIY6Gl5hNqconPRokGpI2beZgttQaXrsxLI
         x8dZGcmBJ7NXPkSqPzQ0yI447UwkOoSrw2AFbb6bQVuElFb4Owpdn1yB43x/P6Arl+vv
         gYfTN0tNEAikzR7s8o1NNwBHdXnq1FzSksEeMe06N6bVm4eAiNdDio/FiUDBK+xGs9An
         rcYkUvUP5baBJV2EZ7YTi4PTDMdyR8v7vot/CPt4JELLj3T3jgsEG72wYxkWQHgfzCHM
         csOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710866655; x=1711471455;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=55tADTKr/fKtx+P9Mx3gQHhaNaSTbLjPsk1QuvUf7uI=;
        b=ns0LWgtSEgmDhdzOlGX3TyvbI2PHK+rkq6TXUyKkryY9x8Innbicj1qbRrfjah7M20
         hSUUgaLxjuRTgLe2u3iV8Ye5t7GlXdoKcEms7S1stz9k1aG2gfVfth4qzs1kUU8FtWHu
         ZtfyDvZLAvTnOMmzjLZ8C0qmEc20CATzM+QNIVdOgFtH1OYAsXtnWN0832E576XfafFv
         dAC136SgQtB1PpsFnlxtYhvJmIkmWUSp+/oByQUEZiKxQ+kSVu83qWpCiq0r4PggcOwZ
         U+r2rOlBHMixc4FwWY2w2sBk7XYvXjlHQuec73ycNfi0uBLScAZbeeUmdd2SDVX4Azm1
         YP8g==
X-Gm-Message-State: AOJu0YwswgMTqKvVcNcfpGxdBgKtwZtHQzK/h1/BOc1c/9ebvw85kiz1
	5ZB/QY7gti5JhqCUlr8BMFCv1yWWmXADNg7/kq4hNmRerOoUfhERgYif00a4y9EO8493lWWC8QO
	bnV9bsftx1+bcYKAvIRxie5Q4At5xFF1sojBP2jCIxlY6THBA6cAnF+pCQriuizvOfER/IMQBi4
	9FCkLY25HWHBZOHsUBPcQEp6lnoIG6BnagBtIA++vO2HZ2gEU28jDkAe8=
X-Google-Smtp-Source: AGHT+IFRbk7J0ciLHbLLk9I3qhSS1omT3Bl07k9k3e57ZQB+uGmYZ+eVWm/uRTh6ZDfo3t25XVq4gku22P4yF8IxNA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:1491:b0:7c8:264d:5e98 with
 SMTP id a17-20020a056602149100b007c8264d5e98mr145907iow.0.1710866655492; Tue,
 19 Mar 2024 09:44:15 -0700 (PDT)
Date: Tue, 19 Mar 2024 16:43:41 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240319164341.1674863-1-coltonlewis@google.com>
Subject: [PATCH v2] KVM: arm64: Add KVM_CAP to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a KVM_CAP to control WFx (WFI or WFE) trapping based on scheduler
runqueue depth. This is so they can be passed through if the runqueue
is shallow or the CPU has support for direct interrupt injection. They
may be always trapped by setting this value to 0. Technically this
means traps will be cleared when the runqueue depth is 0, but that
implies nothing is running anyway so there is no reason to care. The
default value is 1 to preserve previous behavior before adding this
option.

Think about his option as a threshold. The instruction will be trapped
if the runqueue depth is higher than the threshold.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

v2:
The last version was exclusively a flag to enable unconditional wfx
passthrough but there was feedback to make passthrough/trapping depend
on runqueue depth. I asked the last thread if there were any
preferences for the interface to accomplish this but I figured it's
easier to show code than wait for people telling me what to do.

v1:
https://lore.kernel.org/kvmarm/20240129213918.3124494-1-coltonlewis@google.com/

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  7 ++++++-
 include/linux/sched/stat.h        |  1 +
 include/uapi/linux/kvm.h          |  2 +-
 kernel/sched/core.c               | 15 +++++++++++++--
 5 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..79f461efaa6c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -317,6 +317,7 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+	u64 wfx_trap_runqueue_depth;
 };

 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..419eed6e1814 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -116,6 +116,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_ARM_WFX_TRAP_RUNQUEUE_DEPTH:
+		kvm->arch.wfx_trap_runqueue_depth = cap->args[0];
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -176,6 +179,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)

 	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);

+	kvm->arch.wfx_trap_runqueue_depth = 1;
 	return 0;

 err_free_cpumask:
@@ -240,6 +244,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_ARM_WFX_TRAP_RUNQUEUE_DEPTH:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -456,7 +461,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);

-	if (single_task_running())
+	if (nr_running_this_cpu() <= vcpu->kvm->arch.wfx_trap_runqueue_depth)
 		vcpu_clear_wfx_traps(vcpu);
 	else
 		vcpu_set_wfx_traps(vcpu);
diff --git a/include/linux/sched/stat.h b/include/linux/sched/stat.h
index 0108a38bb64d..dc1541fcec56 100644
--- a/include/linux/sched/stat.h
+++ b/include/linux/sched/stat.h
@@ -18,6 +18,7 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned int nr_running(void);
+extern unsigned int nr_running_this_cpu(void);
 extern bool single_task_running(void);
 extern unsigned int nr_iowait(void);
 extern unsigned int nr_iowait_cpu(int cpu);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c3308536482b..4c0ebf514c03 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1155,6 +1155,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_ARM_WFX_TRAP_RUNQUEUE_DEPTH 236

 #ifdef KVM_CAP_IRQ_ROUTING

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9116bcc90346..b18f29964648 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5420,7 +5420,7 @@ unsigned int nr_running(void)
 }

 /*
- * Check if only the current task is running on the CPU.
+ * Return number of tasks running on this CPU.
  *
  * Caution: this function does not check that the caller has disabled
  * preemption, thus the result might have a time-of-check-to-time-of-use
@@ -5432,9 +5432,20 @@ unsigned int nr_running(void)
  *
  * - in a loop with very short iterations (e.g. a polling loop)
  */
+unsigned int nr_running_this_cpu(void)
+{
+	return raw_rq()->nr_running;
+}
+EXPORT_SYMBOL(nr_running_this_cpu);
+
+/*
+ * Check if only the current task is running on the CPU.
+ *
+ * Caution: see warning for nr_running_this_cpu
+ */
 bool single_task_running(void)
 {
-	return raw_rq()->nr_running == 1;
+	return nr_running_this_cpu() == 1;
 }
 EXPORT_SYMBOL(single_task_running);

--
2.44.0.291.gc1ea87d7ee-goog

