Return-Path: <kvm+bounces-29832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98F219B2D96
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 11:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D51628162E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 10:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD721DE2B7;
	Mon, 28 Oct 2024 10:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjeXHdmZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E241DD9A8;
	Mon, 28 Oct 2024 10:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112702; cv=none; b=Ujjd0Ngq/UssSbJaE3YvZvtPjO7N7u3DXKvkOTv6pil6HzjsM0PwYCViJRvPX6wr+EmYHeabIi+fELfJ7+BcCzIcwZnNXZXaQYKdx4of82zqz1caQ7y0uPYcqnVMiMX2673/dv0Usw+9UA78GniX+3z+S6g4VM72XLrTaWkAUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112702; c=relaxed/simple;
	bh=3q8OmelhAQAHtJG0+WA+DXqVRpr3cx7P46HkfwupuDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeCeANLBsKxS7FMTWQlArOnwIiiYn/d60ozH23YB7Pr19/AXDVdhpTDpbJlC6VyKvenIzpOCqkcKGqOaofwk33Y2jczmvR4AJWuDnOlq6Wy+mZlVyP2pMWod0d4kSgk3SdvOyFh5VWhvwhB8ju4ty3KZmGLLZVb6DCCNhIiEaZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JjeXHdmZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83936C4CEE8;
	Mon, 28 Oct 2024 10:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112702;
	bh=3q8OmelhAQAHtJG0+WA+DXqVRpr3cx7P46HkfwupuDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjeXHdmZfO1kM+2WfmAFE1FeuLDlA1lgyzfSm6gh8yC7cz/gBTy6p+ffVYLw5gggB
	 PNQlE38TAHKljbklsV3FJYHwAxz3Z/6EPUS6UBNHin4vlt6uB7U1pc00hZD44XsxuE
	 qbUUcEFphwIS+LtL7/AWczSmlYgPFxQcvwQt3NEZHzNzW4+LoHxBWpGjWlnhY5Xmch
	 9mComtwHBnrbdCSttFSCyzFWl4DHfst0loNyxVWOPRJa0voEJRtaShcsHnJq/Fg4/F
	 l7L32ROEETxZ/BQP+DVM7e60fyy1Qu1c9VGLghGd1RliDUg6XQcYEXy5Zl8NRbIdrr
	 34pqoe3/YO57A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Cyan Yang <cyan.yang@sifive.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.11 19/32] RISCV: KVM: use raw_spinlock for critical section in imsic
Date: Mon, 28 Oct 2024 06:50:01 -0400
Message-ID: <20241028105050.3559169-19-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028105050.3559169-1-sashal@kernel.org>
References: <20241028105050.3559169-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.5
Content-Transfer-Encoding: 8bit

From: Cyan Yang <cyan.yang@sifive.com>

[ Upstream commit 3ec4350d4efb5ccb6bd0e11d9cf7f2be4f47297d ]

For the external interrupt updating procedure in imsic, there was a
spinlock to protect it already. But since it should not be preempted in
any cases, we should turn to use raw_spinlock to prevent any preemption
in case PREEMPT_RT was enabled.

Signed-off-by: Cyan Yang <cyan.yang@sifive.com>
Reviewed-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Message-ID: <20240919160126.44487-1-cyan.yang@sifive.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/aia_imsic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 0a1e859323b45..a8085cd8215e3 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -55,7 +55,7 @@ struct imsic {
 	/* IMSIC SW-file */
 	struct imsic_mrif *swfile;
 	phys_addr_t swfile_pa;
-	spinlock_t swfile_extirq_lock;
+	raw_spinlock_t swfile_extirq_lock;
 };
 
 #define imsic_vs_csr_read(__c)			\
@@ -622,7 +622,7 @@ static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
 	 * interruptions between reading topei and updating pending status.
 	 */
 
-	spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
+	raw_spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
 
 	if (imsic_mrif_atomic_read(mrif, &mrif->eidelivery) &&
 	    imsic_mrif_topei(mrif, imsic->nr_eix, imsic->nr_msis))
@@ -630,7 +630,7 @@ static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
 	else
 		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
 
-	spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
+	raw_spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
 }
 
 static void imsic_swfile_read(struct kvm_vcpu *vcpu, bool clear,
@@ -1051,7 +1051,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
 	}
 	imsic->swfile = page_to_virt(swfile_page);
 	imsic->swfile_pa = page_to_phys(swfile_page);
-	spin_lock_init(&imsic->swfile_extirq_lock);
+	raw_spin_lock_init(&imsic->swfile_extirq_lock);
 
 	/* Setup IO device */
 	kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
-- 
2.43.0


