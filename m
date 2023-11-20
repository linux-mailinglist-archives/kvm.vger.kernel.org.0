Return-Path: <kvm+bounces-2104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3F6F7F1417
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1FAFB21932
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C6E20B1F;
	Mon, 20 Nov 2023 13:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGkv2qWY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB01F959;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB01C07615;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485859;
	bh=Gb78xrJCbwzaA9er9NmF+iIBn24HN2v9V7S1q86rtS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGkv2qWYPDpfr0XrlPjc+XIBn3zPV6v+NtK+KguN7pb/VeJgYzfaoKA0F3smPWJap
	 jjRnoVbA6whv/eXZ82DpAxlcLGyH1o4wNw8e+oiAvtbagzbqT63q50A+SREkyNIPTH
	 QbHgC2HiHDCZ59QTT2/AakKeCvz7TpmIT2rinjuQEgJjOEJkxFWwYyXrEP4MtIPHmC
	 caurG/SMrOqvZJ7LvFVCrCXetcZvRlOYnCzPmRu/FlXdhCF+wD3dYhkbz2TwtG3a3/
	 8moFpQBZlce9BJmDg/kEhQ3YFOrfqg2xh4DxKrqStKRXdi8F7iPG+1aR0PeZhvmKg4
	 wXDhF6tFqlKpA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543F-00EjnU-R1;
	Mon, 20 Nov 2023 13:10:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 34/43] KVM: arm64: nv: Deal with broken VGIC on maintenance interrupt delivery
Date: Mon, 20 Nov 2023 13:10:18 +0000
Message-Id: <20231120131027.854038-35-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Normal, non-nesting KVM deals with maintenance interrupt in a very
simple way: we don't even try to handle it and just turn it off
as soon as we exit, long before the kernel can handle it.

However, with NV, we rely on the actual handling of the interrupt
to leave it active and pass it down to the L1 guest hypervisor
(we effectively treat it as an assigned interrupt, just like the
timer).

This doesn't work with something like the Apple M2, which doesn't
have an active state that allows the interrupt to be masked.

Instead, just disable the vgic after having taken the interrupt and
injected a virtual interrupt. This is enough for the guest to make
forward progress, but will limit its ability to handle further
interrupts until it next exits (IAR will always report "spurious").

Oh well.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index b8f4dd39676c..ea76b1f7285c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -264,4 +264,7 @@ void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 		kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 				    vcpu->kvm->arch.vgic.maint_irq, state, vcpu);
 	}
+
+	if (unlikely(kvm_vgic_global_state.no_hw_deactivation))
+		sysreg_clear_set_s(SYS_ICH_HCR_EL2, ICH_HCR_EN, 0);
 }
-- 
2.39.2


