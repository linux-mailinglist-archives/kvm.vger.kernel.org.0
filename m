Return-Path: <kvm+bounces-2102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84D817F1413
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:14:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 067D51F24578
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99FAE2033E;
	Mon, 20 Nov 2023 13:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDcWY2Xs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1461EA72;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F9EC433C7;
	Mon, 20 Nov 2023 13:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485858;
	bh=uQStS8OhF9bOiuYGBQwafNDcKEhaFD7FkZJn4m6F/3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDcWY2XsT+wrP772GvzQKQviIKjoSo0yNiyntXdUgo2pEk7+4vMYduNWP3kFXraRt
	 DTK+1X8zKXN9lk1P4NNl6oQ9u2qdjd0wmd8xizNKi+NDJ9Tzrc0efMih15QOcnsu7t
	 N4OTDF4S4pwa6KX9ooL/I4C0RD4jnNMP6ymscOaeZS0jMT7UXD3TCJfMd1XHTVjFSA
	 IOhSixITUNd1IdrYhilLCYTodpQJfDY/teL8zlNz6xJ0AvDyHA27QTWKihjUd+FENp
	 fnMVIYmaCww/ZadPVXYGi0rhhXAgg03CWQx4K9T2vlOR9E14eiFSRRU2E4c8RJ8iBy
	 Pn8O1OFZcfqzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543F-00EjnU-2c;
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
Subject: [PATCH v11 31/43] KVM: arm64: nv: Don't block in WFI from nested state
Date: Mon, 20 Nov 2023 13:10:15 +0000
Message-Id: <20231120131027.854038-32-maz@kernel.org>
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

If trapping WFI from a L2 guest, and that L1 hasn't asked for
such trap, it is very hard to decide when to unblock the vcpu,
as we only have a very partial view on the guest's nested
interrupt state (the L1 hypervisor knows about it, but L0 doesn't).

In such a case, we're better off just returning to the L2 guest
immediately. It isn't wrong from an architecture perspective.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 95760ed448bf..d684a2af3406 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -781,6 +781,15 @@ static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * If we're in nested state and the guest hypervisor does not trap
+	 * WFI, we're in a bit of trouble, as we don't have a good handle
+	 * on the interrupts that are pending for the guest yet. Revisit
+	 * this at some point.
+	 */
+	if (vgic_state_is_nested(vcpu))
+		return;
+
 	/*
 	 * Sync back the state of the GIC CPU interface so that we have
 	 * the latest PMR and group enables. This ensures that
-- 
2.39.2


