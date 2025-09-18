Return-Path: <kvm+bounces-57989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D59B835FB
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 09:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AC731C80B3B
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4179E2ECD28;
	Thu, 18 Sep 2025 07:40:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010C92EAD0A;
	Thu, 18 Sep 2025 07:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758181205; cv=none; b=fBBkb1bmDoEKq57x0niQ0eVUKRSwMViThtaldnj6IMjqg2XK/4/t+dbW3TEqyH5JGChM45+O30JTZX3bJHd//dx3IpKZtIEZJqEgRz4EAkX0BqqUI40teWbm6r1s/JICCO0Gn+okTAvyU35x4lTganxoUiARdBjO9DGbTS4TK8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758181205; c=relaxed/simple;
	bh=czA3Q5d93APggFE6yfrJXoPL0H7UP+NlCjnVDYPdXcM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DI4Q+Ioeld4264gQ1qeVkKYPi08F3S5ICis/QbVeE3uvchX1H7SRlx3sqh4waS8E3DN2nKLRWft9hYlbzANhhsGbtZ/s7uU1RRAegt/56hThBg4BLagZu9Xbat7gDwXIBio++1Jcjo68s8IJT8swjHWIobg95fgX192Z921T5hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from qiao.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowADHaBI+t8toBKqGAw--.13402S2;
	Thu, 18 Sep 2025 15:39:43 +0800 (CST)
From: Zhe Qiao <qiaozhe@iscas.ac.cn>
To: anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	qiaozhe@iscas.ac.cn
Cc: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] RISCV: KVM: Add support for userspace to suspend a vCPU
Date: Thu, 18 Sep 2025 15:39:27 +0800
Message-ID: <20250918073927.403410-1-qiaozhe@iscas.ac.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADHaBI+t8toBKqGAw--.13402S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4rCr1fKw1rJFyfJw1fWFg_yoW5ZFy7pF
	sFkrs09w4rGryxCw13J3yDur15WrsYgrnxury29rW5Gr45KrWrAr4v9rW5JF1UJFW8XF1I
	yFn8K3WUC3W5twUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUeJ5rDUUUU
X-CM-SenderInfo: ptld061kh6x2xfdvhtffof0/

Add RISC-V architecture support for the KVM_MP_STATE_SUSPENDED vCPU
state, indicating that a vCPU is in suspended mode. While suspended,
the vCPU will block execution until a wakeup event is detected.

Introduce a new system event type, KVM_SYSTEM_EVENT_WAKEUP, to notify
userspace when KVM has recognized such a wakeup event. It is then
userspace’s responsibility to either make the vCPU runnable again or
keep it suspended until the next wakeup event occurs.

Signed-off-by: Zhe Qiao <qiaozhe@iscas.ac.cn>
---
 arch/riscv/include/asm/kvm_host.h |  2 ++
 arch/riscv/kvm/vcpu.c             | 37 +++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index d71d3299a335..dbc6391407ae 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -43,6 +43,8 @@
 #define KVM_REQ_HFENCE			\
 	KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(6)
+#define KVM_REQ_SUSPEND		\
+	KVM_ARCH_REQ_FLAGS(7, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3ebcfffaa978..0881c78476b1 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -496,6 +496,18 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static void kvm_riscv_vcpu_suspend(struct kvm_vcpu *vcpu)
+{
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_SUSPENDED);
+	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
+static bool kvm_riscv_vcpu_suspended(struct kvm_vcpu *vcpu)
+{
+	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_SUSPENDED;
+}
+
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
@@ -516,6 +528,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		else
 			ret = -EINVAL;
 		break;
+	case KVM_MP_STATE_SUSPENDED:
+		kvm_riscv_vcpu_suspend(vcpu);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -682,6 +697,25 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	}
 }
 
+static int kvm_riscv_handle_suspend(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_riscv_vcpu_suspended(vcpu))
+		return 1;
+
+	kvm_riscv_vcpu_wfi(vcpu);
+
+	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
+
+	if (kvm_arch_vcpu_runnable(vcpu)) {
+		memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_WAKEUP;
+		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		return 0;
+	}
+
+	return 1;
+}
+
 /**
  * kvm_riscv_check_vcpu_requests - check and handle pending vCPU requests
  * @vcpu:	the VCPU pointer
@@ -731,6 +765,9 @@ static int kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			kvm_riscv_vcpu_record_steal_time(vcpu);
 
+		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
+			kvm_riscv_handle_suspend(vcpu);
+
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
 	}
-- 
2.43.0


