Return-Path: <kvm+bounces-2098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 093277F140F
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7DC51F2453E
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8043200B9;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgurBvk+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423971DFF1;
	Mon, 20 Nov 2023 13:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16470C433CC;
	Mon, 20 Nov 2023 13:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485858;
	bh=5DBiFNgj+CREZmY9jeeRQhQKYcgewSdvLDerRT8EBow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgurBvk+NHNAqalG1NLzymPZ3yNuahqZ8KWV/fKJ1CQfeQ4LEynSrTE0dsjRy8Hqw
	 DyfJB9P7VNkX2kf3KpiBpQnEe0jhQRjgjdSBhGqexZXiUCTT1ndyxhGTXQ97LmZFNh
	 USvoSR7v2OqzIZPsQgD2DbtK7Jo30HmZQZEOymDk/3Ws09fnP3174i30lhI3c2GP4x
	 n2P9lUZLuTs3N7lFoUB49aKl4BswKi63WqSvX0JN00lEPI6an4mnnHZ6kKQIZGSp0q
	 jt6BwuNeQWIsHD0nWAOC1EjFu+x63srsdf/PaqomnsbaoW+yJKV4OvgNZUGYzN1I5N
	 aHPy2he7kaTJw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543E-00EjnU-97;
	Mon, 20 Nov 2023 13:10:56 +0000
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
Subject: [PATCH v11 28/43] KVM: arm64: nv: Publish emulated timer interrupt state in the in-memory state
Date: Mon, 20 Nov 2023 13:10:12 +0000
Message-Id: <20231120131027.854038-29-maz@kernel.org>
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

With FEAT_NV2, the EL0 timer state is entirely stored in memory,
meaning that the hypervisor can only provide a very poor emulation.

The only thing we can really do is to publish the interrupt state
in the guest view of CNT{P,V}_CTL_EL0, and defer everything else
to the next exit.

Only FEAT_ECV will allow us to fix it, at the cost of extra trapping.

Suggested-by: Chase Conklin <chase.conklin@arm.com>
Suggested-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index e3f6feef2c83..dba92bbe4617 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -447,6 +447,25 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 {
 	int ret;
 
+	/*
+	 * Paper over NV2 brokenness by publishing the interrupt status
+	 * bit. This still results in a poor quality of emulation (guest
+	 * writes will have no effect until the next exit).
+	 *
+	 * But hey, it's fast, right?
+	 */
+	if (is_hyp_ctxt(vcpu) &&
+	    (timer_ctx == vcpu_vtimer(vcpu) || timer_ctx == vcpu_ptimer(vcpu))) {
+		u32 ctl = timer_get_ctl(timer_ctx);
+
+		if (new_level)
+			ctl |= ARCH_TIMER_CTRL_IT_STAT;
+		else
+			ctl &= ~ARCH_TIMER_CTRL_IT_STAT;
+
+		timer_set_ctl(timer_ctx, ctl);
+	}
+
 	timer_ctx->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_irq(timer_ctx),
 				   timer_ctx->irq.level);
-- 
2.39.2


