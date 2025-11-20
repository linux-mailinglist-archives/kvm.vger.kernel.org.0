Return-Path: <kvm+bounces-63938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 53934C75BB4
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 2697A3034C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFC837413A;
	Thu, 20 Nov 2025 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Om6yr0CK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683BE393DD0;
	Thu, 20 Nov 2025 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659561; cv=none; b=Yuits89vfLYO6ASIcurI+Pji0nDq+Qx+WHWUW9BjGobm7+nRUFGavFsdL0Soy5Job9b+Zp/PyRWQF3XJCJna9ymiAqH9d0BvPn2uOGfTODAcacrIoA8q+47sDrHP0OLZG7HU8zKu/7I9uOhm2IB63jUlIdhUmIIemICuSkxnn4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659561; c=relaxed/simple;
	bh=+YGd9JHhb0OIMMWRqXwm8AJ8566l/XuBzTV96laMsUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7xR83wucCfcqU7z+phcyid6isvcGh/4gV8A9KFlNgcYef9x8X0hqZuNIzOHMYaAg9QmKLOr9THRmxuqtqhm5dGpeqKmPa5Rv38Pih21gyONfUMKOtYt03y2PtS92bSl0GXwFJN34OBNFV18S3/UGerxbYD40ouqZZHMoDy0wpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Om6yr0CK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E16C4CEF1;
	Thu, 20 Nov 2025 17:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659561;
	bh=+YGd9JHhb0OIMMWRqXwm8AJ8566l/XuBzTV96laMsUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Om6yr0CK2VSJUyJDuQ3Zr9rBnq5Zp+usGfby18QVxeaD967pmSKQJaOlOjsjnc402
	 FqlZu1Kgr4wy8EUbATlE7qfHfydpqEMbdNfUjcS4Rkz05uUhuup9lEJ2t3DoOTvgMs
	 u+CCRt6+2aLNwOd1omL/lRO9UgaW5lTyV6jZaYgSPy5QfA7CHB3HfCHVVmRWEh5wnD
	 j138BH1bgBPxq48rZxs7CeTccp2AaLjoU6NB06dBJeGzIncAFEpudlgIrRt6Shidqx
	 dIg/Pn9nCciaIxRNRcjlRQme8IjesTgaHVNqLJNhSipZP/7wgefFxnR65DFxKtJ/Gm
	 nQ2imdS4Y7cpA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pv-00000006y6g-1vfY;
	Thu, 20 Nov 2025 17:25:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 23/49] KVM: arm64: Make vgic_target_oracle() globally available
Date: Thu, 20 Nov 2025 17:25:13 +0000
Message-ID: <20251120172540.2267180-24-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make the internal crystal ball global, so that implementation-specific
code can use it.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 2 +-
 arch/arm64/kvm/vgic/vgic.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 7e6f02d48fff1..004010104659a 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -237,7 +237,7 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
  *
  * Requires the IRQ lock to be held.
  */
-static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
+struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 {
 	lockdep_assert_held(&irq->irq_lock);
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index e48294521541e..037efb6200823 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -261,6 +261,7 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid);
 struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
+struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
 void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
-- 
2.47.3


