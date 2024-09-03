Return-Path: <kvm+bounces-25790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90AB696A8C2
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 22:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C33F21C23CF3
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 20:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33BF820010D;
	Tue,  3 Sep 2024 20:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oW2Q3oRV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5746B1D2782;
	Tue,  3 Sep 2024 20:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725396159; cv=none; b=itN2xZIl6xjJAgG4c1+fbm+qoKQk1mi7lyXgxSvoUgMlSnxnnp9MRj2mEFFym5rKJzaZEm8QIq2hmQizZl86mcddv91AOaApqm7kGyaqWTxu8MuxUdJhA9oU56zWE4QCO/7bbFofOezdvVCOYG1YJ7jhiNxOmIbnTahq7yGCzd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725396159; c=relaxed/simple;
	bh=U3bZxkJ5+6Ey3tGRFEroT38h1LCOxrBV+g3AfVlkMcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0yfFQADsZC/q02S/5KaBTi4JV01iyE0mjKJo2RLrg81GqnJuYjMn9gGiMaHWS3216EW8OP1Tz/louXiwdh+wEQu/OoGCEBrv/cki1T9TKZId8HxDNYWc3OclEkFVYkrSrT9G8PKc7B3pyR7xYWMIIk1iev2+WEvYQuvkTjIylc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oW2Q3oRV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4F1C4CEC5;
	Tue,  3 Sep 2024 20:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725396158;
	bh=U3bZxkJ5+6Ey3tGRFEroT38h1LCOxrBV+g3AfVlkMcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oW2Q3oRVOXvtJfm+3WqTu7iifgK5odHvJM075WNpa7uYo71j7/ddY4z4cQCJxoIOw
	 qyY7g1ccrcPZ7L/3z1jQwIaf0nhMXYNChrB4hxotqdxpiRKL1ShBV5VyBZHwk7u53u
	 t2RpIDJpz/tgdkyv7mCkutbNK9gEAULXWCip1rGjz/knUYr4N0ACpcrnTWI0h3sMEc
	 eKnFAWykBTCnREx+2TV6g12lav/X05HyppuqSO77rplYzlFghZT8+pAAcx4ve8/rmS
	 P+OjOAe425EHi64eYCcIw1SYgQVM/uRzQ/GpAKwulDs0AjN07PybDuOJS2cvD4iSYV
	 x1OE4TCWl83pQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>,
	zhaotianrui@loongson.cn,
	chenhuacai@kernel.org,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: [PATCH AUTOSEL 6.10 15/22] LoongArch: KVM: Invalidate guest steal time address on vCPU reset
Date: Tue,  3 Sep 2024 15:22:02 -0400
Message-ID: <20240903192243.1107016-15-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240903192243.1107016-1-sashal@kernel.org>
References: <20240903192243.1107016-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.7
Content-Transfer-Encoding: 8bit

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 4956e07f05e239b274d042618a250c9fa3e92629 ]

If ParaVirt steal time feature is enabled, there is a percpu gpa address
passed from guest vCPU and host modifies guest memory space with this gpa
address. When vCPU is reset normally, it will notify host and invalidate
gpa address.

However if VM is crashed and VMM reboots VM forcely, the vCPU reboot
notification callback will not be called in VM. Host needs invalidate
the gpa address, else host will modify guest memory during VM reboots.
Here it is invalidated from the vCPU KVM_REG_LOONGARCH_VCPU_RESET ioctl
interface.

Also funciton kvm_reset_timer() is removed at vCPU reset stage, since SW
emulated timer is only used in vCPU block state. When a vCPU is removed
from the block waiting queue, kvm_restore_timer() is called and SW timer
is cancelled. And the timer register is also cleared at VMM when a vCPU
is reset.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/kvm_vcpu.h | 1 -
 arch/loongarch/kvm/timer.c            | 7 -------
 arch/loongarch/kvm/vcpu.c             | 2 +-
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index 590a92cb54165..d741c3e9933a5 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -76,7 +76,6 @@ static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
 #endif
 
 void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
-void kvm_reset_timer(struct kvm_vcpu *vcpu);
 void kvm_save_timer(struct kvm_vcpu *vcpu);
 void kvm_restore_timer(struct kvm_vcpu *vcpu);
 
diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index bcc6b6d063d91..74a4b5c272d60 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -188,10 +188,3 @@ void kvm_save_timer(struct kvm_vcpu *vcpu)
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ESTAT);
 	preempt_enable();
 }
-
-void kvm_reset_timer(struct kvm_vcpu *vcpu)
-{
-	write_gcsr_timercfg(0);
-	kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TCFG, 0);
-	hrtimer_cancel(&vcpu->arch.swtimer);
-}
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 9e8030d451290..0b53f4d9fddf9 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -572,7 +572,7 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
 				vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
 			break;
 		case KVM_REG_LOONGARCH_VCPU_RESET:
-			kvm_reset_timer(vcpu);
+			vcpu->arch.st.guest_addr = 0;
 			memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
 			memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
 			break;
-- 
2.43.0


