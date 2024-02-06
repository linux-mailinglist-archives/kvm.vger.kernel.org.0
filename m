Return-Path: <kvm+bounces-8083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFC584AF65
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F21661F25F19
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 07:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F5B12D777;
	Tue,  6 Feb 2024 07:52:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D9B12AAE8
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 07:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707205953; cv=none; b=gtucvdE84zi1A+Z6gNNXWFfGiRRYdwTXB/RvCZVO7EKOyZyBbO1TRAYKMQg3RrZqxg+icGICeYAAYboRrRkf/zetbjw3YT1oBgfPpmgZSOmyR1u6zaZB/iFfylVS/T26s0fRgybXdsAnmocvNrGSZAFRYByolJVXdq9v0AuAWiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707205953; c=relaxed/simple;
	bh=LKCesvnQ8hKwu2pW4oYdaxSBuPICXR1AXOoWtwWSePw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References; b=paa6Ezvv1Nk30amzmP25sWGUoaZDwVLvVg7gfXKEGhKj7Yh9WjPuyydBUAKn/QHXDRQStgGAeRbKNQ0HwBNM+NMljk7OEaSH5gAgmEszr2TdSBKuGMH2pyo+TR/N5ukVL3nv9DTb3JXZoziJ00TtBmgFqC0IytHBTQYDS/xoo6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgD3gv2B5MFlygcKAA--.4463S5;
	Tue, 06 Feb 2024 15:49:24 +0800 (CST)
From: Chao Du <duchao@eswincomputing.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	shuah@kernel.org,
	dbarboza@ventanamicro.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	duchao713@qq.com
Subject: [PATCH v1 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
Date: Tue,  6 Feb 2024 07:49:29 +0000
Message-Id: <20240206074931.22930-2-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240206074931.22930-1-duchao@eswincomputing.com>
References: <20240206074931.22930-1-duchao@eswincomputing.com>
X-CM-TRANSID:TAJkCgD3gv2B5MFlygcKAA--.4463S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr47Gw4fCryDKw1fCF1rJFb_yoW8tr4xpF
	4DCr98Aw4rGr93C34Iya95ur4S939agrnak347uFy3AFWjyrWFyrs5KrZxJry5JrWrWFyx
	CF1rKF1ru3Z8trUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP2b7Iv0xC_tr1lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2
	xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU05D
	G5UUUUU==
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST_DEBUG is
being checked.

kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug flags
from userspace accordingly. Route the breakpoint exceptions to HS mode
if the VM is being debugged by userspace, by clearing the corresponding
bit in hedeleg CSR.

Signed-off-by: Chao Du <duchao@eswincomputing.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  1 +
 arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
 arch/riscv/kvm/vm.c               |  1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index d6b7a5b95874..8890977836f0 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -17,6 +17,7 @@

 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_GUEST_DEBUG

 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b5ca9f2e98ac..6cee974592ac 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -475,8 +475,19 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
-	/* TODO; To be implemented later. */
-	return -EINVAL;
+	if (dbg->control & KVM_GUESTDBG_ENABLE) {
+		if (vcpu->guest_debug != dbg->control) {
+			vcpu->guest_debug = dbg->control;
+			csr_clear(CSR_HEDELEG, BIT(EXC_BREAKPOINT));
+		}
+	} else {
+		if (vcpu->guest_debug != 0) {
+			vcpu->guest_debug = 0;
+			csr_set(CSR_HEDELEG, BIT(EXC_BREAKPOINT));
+		}
+	}
+
+	return 0;
 }

 static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index ce58bc48e5b8..7396b8654f45 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -186,6 +186,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
--
2.17.1


