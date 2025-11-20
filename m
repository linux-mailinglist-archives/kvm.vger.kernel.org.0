Return-Path: <kvm+bounces-63923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC67C75ABB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:29:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 66DC62C946
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0436E371A0A;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXJuAi0N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06458368E19;
	Thu, 20 Nov 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659558; cv=none; b=OgUVydzBTME9bAr/rAbqMRzW54YEiondkkZINkvURNtDn06TM4XbT03x9TtT3Yq4KXJGMXhqSOI2X8TOQgRdfPTxpTeCQcVPcU949sA5/1TSCz9ZZo4fV5gOp8jihCWblJHcOJpXNyp3BLv1MgEJZLC03SLUypPiRtPIbVKOuI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659558; c=relaxed/simple;
	bh=9zmvyJnqM1pmsDAZmL9HBzTQeKZt544wzk09PL440M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMjKdyEafgTKrn6c8k3IINzS2HPXgjcEsrot1C6CBsmpf/jBeYLUeVR4ngso87882cvkmYWeL0ZhW6Q1xPVA7eAweNAdaKA0t+pO08h3CV44DQHAVbeuYcp/vVQA5X5rnPtZqTNhVRWbhmoxW65eMLGkAuXGZ0+SGMvjSEhZK2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXJuAi0N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0D0C16AAE;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659557;
	bh=9zmvyJnqM1pmsDAZmL9HBzTQeKZt544wzk09PL440M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXJuAi0Ng0UM8uATPILI+p1EcvRTKkW1WwAgtUgGL4NwGDqabcAKNx09h51Y2NlyH
	 GjeD8M65DlydSXu+VtKf0vyt7pq6D6zTJapiFu3W5tTn2HcpWqXgniqigM3KgT9fVB
	 wF/Qh4leL6IBz5FBgF6Kw0IgCPZEreyyORGMWCV4LaK+iZ914nQEQyPbXnOB0RtEtO
	 kDh7WwGQhJokx69c4WwDTvoyAyAYX7kvX2XodZhH7L0JZLT1dKSdwwPIZl7f86DyjZ
	 bnvX5qP9yTcH/nYILAst1jZohzk084rjo92Z08ywLHwvMBPMESlAorjFh5UBTjd3zG
	 Z3nvPPSlywE/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pr-00000006y6g-47kU;
	Thu, 20 Nov 2025 17:25:56 +0000
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
Subject: [PATCH v4 09/49] KVM: arm64: Add LR overflow handling documentation
Date: Thu, 20 Nov 2025 17:24:59 +0000
Message-ID: <20251120172540.2267180-10-maz@kernel.org>
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

Add a bit of documentation describing how we are dealing with LR
overflow. This is mostly a braindump of how things are expected
to work. For now anyway.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 81 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 6dd5a10081e27..7ee253a9fb77e 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -825,7 +825,86 @@ static int compute_ap_list_depth(struct kvm_vcpu *vcpu,
 	return count;
 }
 
-/* Requires the VCPU's ap_list_lock to be held. */
+/*
+ * Dealing with LR overflow is close to black magic -- dress accordingly.
+ *
+ * We have to present an almost infinite number of interrupts through a very
+ * limited number of registers. Therefore crucial decisions must be made to
+ * ensure we feed the most relevant interrupts into the LRs, and yet have
+ * some facilities to let the guest interact with those that are not there.
+ *
+ * All considerations below are in the context of interrupts targeting a
+ * single vcpu with non-idle state (either pending, active, or both),
+ * colloquially called the ap_list:
+ *
+ * - Pending interrupts must have priority over active interrupts. This also
+ *   excludes pending+active interrupts. This ensures that a guest can
+ *   perform priority drops on any number of interrupts, and yet be
+ *   presented the next pending one.
+ *
+ * - Deactivation of interrupts outside of the LRs must be tracked by using
+ *   either the EOIcount-driven maintenance interrupt, and sometimes by
+ *   trapping the DIR register.
+ *
+ * - For EOImode=0, a non-zero EOIcount means walking the ap_list past the
+ *   point that made it into the LRs, and deactivate interrupts that would
+ *   have made it onto the LRs if we had the space.
+ *
+ * - The MI-generation bits must be used to try and force an exit when the
+ *   guest has done enough changes to the LRs that we want to reevaluate the
+ *   situation:
+ *
+ *	- if the total number of pending interrupts exceeds the number of
+ *	  LR, NPIE must be set in order to exit once no pending interrupts
+ *	  are present in the LRs, allowing us to populate the next batch.
+ *
+ *	- if there are active interrupts outside of the LRs, then LRENPIE
+ *	  must be set so that we exit on deactivation of one of these, and
+ *	  work out which one is to be deactivated.  Note that this is not
+ *	  enough to deal with EOImode=1, see below.
+ *
+ *	- if the overall number of interrupts exceeds the number of LRs,
+ *	  then UIE must be set to allow refilling of the LRs once the
+ *	  majority of them has been processed.
+ *
+ *	- as usual, MI triggers are only an optimisation, since we cannot
+ *        rely on the MI being delivered in timely manner...
+ *
+ * - EOImode=1 creates some additional problems:
+ *
+ *      - deactivation can happen in any order, and we cannot rely on
+ *	  EOImode=0's coupling of priority-drop and deactivation which
+ *	  imposes strict reverse Ack order. This means that DIR must
+ *	  trap if we have active interrupts outside of the LRs.
+ *
+ *      - deactivation of SPIs can occur on any CPU, while the SPI is only
+ *	  present in the ap_list of the CPU that actually ack-ed it. In that
+ *	  case, EOIcount doesn't provide enough information, and we must
+ *	  resort to trapping DIR even if we don't overflow the LRs. Bonus
+ *	  point for not trapping DIR when no SPIs are pending or active in
+ *	  the whole VM.
+ *
+ *	- LPIs do not suffer the same problem as SPIs on deactivation, as we
+ *	  have to essentially discard the active state, see below.
+ *
+ * - Virtual LPIs have an active state (surprise!), which gets removed on
+ *   priority drop (EOI). However, EOIcount doesn't get bumped when the LPI
+ *   is not present in the LR (surprise again!). Special care must therefore
+ *   be taken to remove the active state from any activated LPI when exiting
+ *   from the guest. This is in a way no different from what happens on the
+ *   physical side. We still rely on the running priority to have been
+ *   removed from the APRs, irrespective of the LPI being present in the LRs
+ *   or not.
+ *
+ * - Virtual SGIs directly injected via GICv4.1 must not affect EOIcount, as
+ *   they are not managed in SW and don't have a true active state. So only
+ *   set vSGIEOICount when no SGIs are in the ap_list.
+ *
+ * - GICv2 SGIs with multiple sources are injected one source at a time, as
+ *   if they were made pending sequentially. This may mean that we don't
+ *   always present the HPPI if other interrupts with lower priority are
+ *   pending in the LRs. Big deal.
+ */
 static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-- 
2.47.3


