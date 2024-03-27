Return-Path: <kvm+bounces-12766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73CE588D851
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A16B61C25439
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 08:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C621339A1;
	Wed, 27 Mar 2024 07:59:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmtu5ljy1ljeznc42.icoremail.net (zg8tmtu5ljy1ljeznc42.icoremail.net [159.65.134.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F682C859
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 07:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.65.134.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711526384; cv=none; b=FSFfFEIMDEFtDF9qo1dVHpituTLS8h8rW6O7HWMLWlVt7pm57zSpLjQkwV8xvnM/D6ydHovWeqmuSrzMCus2wem33px9xUYPhPcDgnt1GMqO9GF0N571G11dIJbXwwz30wqeS1VlowglLEf3xviyJURriMo2kbJGeo/RfKpKyHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711526384; c=relaxed/simple;
	bh=6KMKJpvnLeuBhGIz5BKjsqZww25xAF5Kzg4ckvnw15o=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References; b=Lo9i7hvkZD34xjKVxGMggZ/mPuJlk9EPxG92BE1SL+I0V3t3KqYNVI7mYMExSQQjSXbkilWkUx6KnPWVY0J9+kKxWJDNrhkSMk4uCSQHccyopk5kR3lIXpmtTxDTslGw4z7DloJNlUIfVBhTkQClx6vK+U7VRt7JqKvYVHjcvEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=159.65.134.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgBn++KS0QNmzA4DAA--.6945S6;
	Wed, 27 Mar 2024 15:58:18 +0800 (CST)
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
	haibo1.xu@intel.com,
	duchao713@qq.com
Subject: [PATCH v3 2/3] RISC-V: KVM: Handle breakpoint exits for VCPU
Date: Wed, 27 Mar 2024 07:55:25 +0000
Message-Id: <20240327075526.31855-3-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240327075526.31855-1-duchao@eswincomputing.com>
References: <20240327075526.31855-1-duchao@eswincomputing.com>
X-CM-TRANSID:TAJkCgBn++KS0QNmzA4DAA--.6945S6
X-Coremail-Antispam: 1UD129KBjvdXoWruFWxCF4rAF1UZrWUtrWxXrb_yoW3Grg_G3
	4xJw1fGFZ8Xw1xtFnrGw4fJrn5Jws5Ja45XryF9r98WF1qvr4xKrZ5X3WUZr18ZrW5ZFsr
	Jrs5AF43A34jyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbq8YjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
	IE14v26r15M28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CE
	w4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6x
	kF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE
	c7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I
	8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCF
	s4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY02
	Avz4vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7iFx
	UUUUU
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Exit to userspace for breakpoint traps. Set the exit_reason as
KVM_EXIT_DEBUG before exit.

Signed-off-by: Chao Du <duchao@eswincomputing.com>
---
 arch/riscv/kvm/vcpu_exit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 2415722c01b8..5761f95abb60 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -204,6 +204,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
 			ret = kvm_riscv_vcpu_sbi_ecall(vcpu, run);
 		break;
+	case EXC_BREAKPOINT:
+		run->exit_reason = KVM_EXIT_DEBUG;
+		ret = 0;
+		break;
 	default:
 		break;
 	}
-- 
2.17.1


