Return-Path: <kvm+bounces-37502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C989FA2AD02
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBFA7188ACCD
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB691F4171;
	Thu,  6 Feb 2025 15:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOOnxG3n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFA224635A;
	Thu,  6 Feb 2025 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738856984; cv=none; b=aclnNKOqovWjtgpCm8B09t3En5B/Yx63+4/RQLXGsYhTA3DdmQcWPHFVpYsTPK04k87Pt1gldq9DywT1oGwFDf88WnYmvbEMfa3hVQFjV6GFCzAQoVJDWSFAi2KyBWlNDTy8Vsg/42eizQG3+CmqEHZtc1NivfEh/l49nT6lMkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738856984; c=relaxed/simple;
	bh=Za1PNQ3sjrTQ/q3busy2dbutshSkyGMY6U7X8BZk2rs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cOyk5tlYeOqFSqyByFjF6M0Lta80quwDvdqIGwgRctksT4jd/vnuNlEVJhmxLoYUUJStoye6FA/96lzrpnbfdHJPE+Y5yEE8MYKdu0y8aEtVE6wtqivuhWLl/7lg8zWOLq9SkVE+BHiipQhHAxpmEZnd5vVDsjCgPRybMRYyBso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOOnxG3n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA10C4CEEA;
	Thu,  6 Feb 2025 15:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738856984;
	bh=Za1PNQ3sjrTQ/q3busy2dbutshSkyGMY6U7X8BZk2rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOOnxG3nup72Q6gGZjimtqvdVUyJzHKD8AgyHMeJrUh3yZbowxgc7X5G2CL2iyky5
	 58JrGNwAv73EcBJd6tltXH03nXoG20Yz8VAHUh00tEoP4MjdS4Fa7m5+GJnVzL2xuL
	 Vz/IyhDfISOtDEDwlFtnayN2DqPuZK5FcB8nAPVkT0rlUN6n1zbe6+sqSNEBR5TmKE
	 gHOJxZld2txz8Miry8RoehoTvT+QWZkcZ1Q1fS/tZZHYDu3S0oeTBagMxcn5OnQ398
	 BdE1GKNbUcysLZfIznedOrWxQdM6cYSU7UE+NU+A0a4XN7oIgJsnQTcn810vX/P8ZR
	 zovZXYkJBba/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg48M-001BOX-92;
	Thu, 06 Feb 2025 15:49:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 13/16] KVM: arm64: nv: Propagate used_lrs between L1 and L0 contexts
Date: Thu,  6 Feb 2025 15:49:22 +0000
Message-Id: <20250206154925.1109065-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206154925.1109065-1-maz@kernel.org>
References: <20250206154925.1109065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We have so far made sure that L1 and L0 vgic contexts were
totally independent. There is however one spot of bother with
this approach, and that's in the GICv3 emulation code required by
our fruity friends.

The issue is that the emulation code needs to know how many LRs
are in flight. And while it is easy to reach the L0 version through
the vcpu pointer, doing so for the L1 is much more complicated,
as these structures are private to the nested code.

We could simply expose that structure and pick one or the other
depending on the context, but this seems extra complexity for not
much benefit.

Instead, just propagate the number of used LRs from the nested code
into the L0 context, and be done with it. Should this become a burden,
it can be easily rectified.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index e72be14d99d55..643bd8a8e0669 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -323,6 +323,12 @@ void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 	__vgic_v3_activate_traps(cpu_if);
 
 	__vgic_v3_restore_state(cpu_if);
+
+	/*
+	 * Propagate the number of used LRs for the benefit of the HYP
+	 * GICv3 emulation code. Yes, this is a pretty sorry hack.
+	 */
+	vcpu->arch.vgic_cpu.vgic_v3.used_lrs = cpu_if->used_lrs;
 }
 
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
@@ -358,6 +364,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	}
 
 	shadow_if->lr_map = 0;
+	vcpu->arch.vgic_cpu.vgic_v3.used_lrs = 0;
 }
 
 /*
-- 
2.39.2


