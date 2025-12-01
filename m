Return-Path: <kvm+bounces-64982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E4180C95882
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 02:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5515A34249D
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 01:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C771547E7;
	Mon,  1 Dec 2025 01:46:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA7172610;
	Mon,  1 Dec 2025 01:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764553582; cv=none; b=qDjwPb/Ee9R6hNve7sJ6hm1Vrzn278aYOLnGnmByZqC9a2ESrwKVaTgRrwQur5iOeQcqu9jnMlU6qJhoTSsb0uQEVWdj69kpyvOCuiJtBn7kml4JDgKvjP3Is71nE25wS0CeqEfgWpyjPZx0hG+88LF5LJKQE+HZzE06plDh3Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764553582; c=relaxed/simple;
	bh=1NlUxVJXI80LACLgsudtnMDqE9VprO3S4doM6Ujl7gc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CGcVzZo3E2yS6AqwcEB9LRpLYRXsNnGko1H7HGVyDvBcR6W8c64s6U3lnMxe9RVG9vpvRAG+NNd6p+iE9azAqkUdPWoxEtUiLc5BNCrDmg/lMjmZ/pnCGN2VqWwFBRm/k4STvAtEcHiOwZuB53Du6D2peUWM6Yz/uOSmc5wr2Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.244.238])
	by APP-01 (Coremail) with SMTP id qwCowADnf89j8yxpK9+vAg--.18813S2;
	Mon, 01 Dec 2025 09:46:12 +0800 (CST)
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
Subject: [PATCH 2/4] RISC-V: KVM: Add support for software check exception
Date: Mon,  1 Dec 2025 09:28:35 +0800
Message-Id: <0f23f96ee5abc5c445f1f482130e8efa33e7b97c.1764509485.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1764509485.git.zhouquan@iscas.ac.cn>
References: <cover.1764509485.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADnf89j8yxpK9+vAg--.18813S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cryxtw1kJFyxJw4xCrWkXrb_yoW8tr47pF
	s8CF1v9rWrKr9akr1IyFnF9r4xGan8Kw1agryUtF45KrW7t3yUZ3s5K347JF98XF4kXF4I
	9F18WFZ5uFn0qr7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
	4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67AK6w
	4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWU
	JVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7V
	AKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42
	IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUeKZXDUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiCREDBmks7Hsa4gAAs3

From: Quan Zhou <zhouquan@iscas.ac.cn>

zicfiss / zicfilp introduces a new exception to priv isa `software check
exception` with cause code = 18. Delegate this exception to VS mode because
cfi violations in VU/VS will be reported via this exception.

RISC-V KVM should ensure that even if the SBI implementation ignores
hedeleg settings and routes VS-mode software check exceptions to HS mode,
KVM still correctly forwards them to the guest. Otherwise, these exceptions
would exit to userspace and terminate the guest.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/include/asm/csr.h      | 1 +
 arch/riscv/include/asm/kvm_host.h | 3 ++-
 arch/riscv/kvm/vcpu_exit.c        | 3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 4a37a98398ad..9f10ef69de30 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -108,6 +108,7 @@
 #define EXC_INST_PAGE_FAULT	12
 #define EXC_LOAD_PAGE_FAULT	13
 #define EXC_STORE_PAGE_FAULT	15
+#define EXC_SOFTWARE_CHECK		18
 #define EXC_INST_GUEST_PAGE_FAULT	20
 #define EXC_LOAD_GUEST_PAGE_FAULT	21
 #define EXC_VIRTUAL_INST_FAULT		22
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 4d794573e3db..0bb4da1c73df 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -53,7 +53,8 @@
 					 BIT(EXC_SYSCALL)         | \
 					 BIT(EXC_INST_PAGE_FAULT) | \
 					 BIT(EXC_LOAD_PAGE_FAULT) | \
-					 BIT(EXC_STORE_PAGE_FAULT))
+					 BIT(EXC_STORE_PAGE_FAULT)) | \
+					 BIT(EXC_SOFTWARE_CHECK)
 
 #define KVM_HIDELEG_DEFAULT		(BIT(IRQ_VS_SOFT)  | \
 					 BIT(IRQ_VS_TIMER) | \
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 0bb0c51e3c89..5ab8e87ed248 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -243,6 +243,9 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		run->exit_reason = KVM_EXIT_DEBUG;
 		ret = 0;
 		break;
+	case EXC_SOFTWARE_CHECK:
+		ret = vcpu_redirect(vcpu, trap);
+		break;
 	default:
 		break;
 	}
-- 
2.34.1


