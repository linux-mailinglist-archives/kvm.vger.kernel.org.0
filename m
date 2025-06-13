Return-Path: <kvm+bounces-49408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAEB1AD8AA6
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 13:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6FC03AA36F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 11:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BB62E0B63;
	Fri, 13 Jun 2025 11:38:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6F018BC0C;
	Fri, 13 Jun 2025 11:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749814738; cv=none; b=nQb5Yu+J0nfMVD3Od4OOl2Pr9nAFuwt0ZXkVKjJ93/Q9e5ddY2RHtNIZB3SI4QXFtcutfcOub/Xo0yEBYTufF9RMRi2q/ewx06/TiVVgoZR4PkPOxKY0Wmf9Vlnfrjk4aW+1RgAotbLPMY298IIQ8ielPaQyXm9f0BfW13T9lpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749814738; c=relaxed/simple;
	bh=yAdyrKd0ReAWwONsmqSc1eeuu0Pc879P2+xEWkYdAUc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IM1OkSljlVi+6NihI7UD20c+DM5YnlY47liGPfUzkBuYvKppYHClEOjLFZiA6Rtv1Cajh25taEVIYJQ4Dm62lrWe8bqn4Pq+bu2ipxKJu6fVB1yehkoRfBn45XugudPdNUfasePja+Mk7XiUDAr9CjzOAoDLUcFpGJTqyFx8GV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.smartont.net (unknown [180.110.114.155])
	by APP-03 (Coremail) with SMTP id rQCowADXJ1DFDUxoRw05Bg--.50527S2;
	Fri, 13 Jun 2025 19:38:45 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH 1/2] RISC-V: KVM: Enable ring-based dirty memory tracking
Date: Fri, 13 Jun 2025 19:29:57 +0800
Message-Id: <20e116efb1f7aff211dd8e3cf8990c5521ed5f34.1749810735.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1749810735.git.zhouquan@iscas.ac.cn>
References: <cover.1749810735.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADXJ1DFDUxoRw05Bg--.50527S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1fGryUurWUWw4UXFy8uFg_yoW5tw4rpF
	s3CrZava1rGF4fG34SyrWkur4UWrZ3Kr43XrWUZFyrGr1YyFWkArsYg348JryUJFy8Xa4I
	kF1FgFyY9Fs0qwUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUl-erU
	UUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBgsMBmhL72JrwwAAsB

From: Quan Zhou <zhouquan@iscas.ac.cn>

Enable ring-based dirty memory tracking on riscv:

- Enable CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL as riscv is weakly
  ordered.
- Set KVM_DIRTY_LOG_PAGE_OFFSET for the ring buffer's physical page
  offset.
- Add a check to kvm_vcpu_kvm_riscv_check_vcpu_requests for checking
  whether the dirty ring is soft full.

To handle vCPU requests that cause exits to userspace, modified the
`kvm_riscv_check_vcpu_requests` to return a value (currently only
returns 0 or 1).

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 Documentation/virt/kvm/api.rst    |  2 +-
 arch/riscv/include/uapi/asm/kvm.h |  1 +
 arch/riscv/kvm/Kconfig            |  1 +
 arch/riscv/kvm/vcpu.c             | 18 ++++++++++++++++--
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1bd2d42e6424..5de0fbfe2fc0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8316,7 +8316,7 @@ core crystal clock frequency, if a non-zero CPUID 0x15 is exposed to the guest.
 7.36 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
 ----------------------------------------------------------
 
-:Architectures: x86, arm64
+:Architectures: x86, arm64, riscv
 :Type: vm
 :Parameters: args[0] - size of the dirty log ring
 
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 5f59fd226cc5..ef27d4289da1 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -18,6 +18,7 @@
 #define __KVM_HAVE_IRQ_LINE
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define KVM_INTERRUPT_SET	-1U
 #define KVM_INTERRUPT_UNSET	-2U
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 704c2899197e..5a62091b0809 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -25,6 +25,7 @@ config KVM
 	select HAVE_KVM_MSI
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_READONLY_MEM
+	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e0a01af426ff..0502125efb30 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -690,7 +690,14 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
+/**
+ * check_vcpu_requests - check and handle pending vCPU requests
+ * @vcpu:	the VCPU pointer
+ *
+ * Return: 1 if we should enter the guest
+ *	    0 if we should exit to userspace
+ */
+static int kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
@@ -735,7 +742,12 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			kvm_riscv_vcpu_record_steal_time(vcpu);
+
+		if (kvm_dirty_ring_check_request(vcpu))
+			return 0;
 	}
+
+	return 1;
 }
 
 static void kvm_riscv_update_hvip(struct kvm_vcpu *vcpu)
@@ -917,7 +929,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_riscv_gstage_vmid_update(vcpu);
 
-		kvm_riscv_check_vcpu_requests(vcpu);
+		ret = kvm_riscv_check_vcpu_requests(vcpu);
+		if (ret <= 0)
+			continue;
 
 		preempt_disable();
 
-- 
2.34.1


