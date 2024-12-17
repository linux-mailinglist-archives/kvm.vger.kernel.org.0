Return-Path: <kvm+bounces-33970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B691A9F4F1B
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77ABE161EA1
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFE11F8AEA;
	Tue, 17 Dec 2024 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVWolua/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210CF1F8901;
	Tue, 17 Dec 2024 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734448447; cv=none; b=TfYbv5jslACtgv6MO3AePUrdriNotdaqIqMSFd6+wxJ6A7U8y8SWij2RDZQ8ixyUDq3TvxyvHXyOeYuX7Thrz6kGuLwXkbIo9dX9j7gVKfA/P/BNnq5VNfxAZuBc8zovDbKfXu5RBRVf9QM6mGuO3e3duo5rQvCZ35ztyjocSh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734448447; c=relaxed/simple;
	bh=Qpdg/3uNo56RDMPdNnLA2ilJVAUDi/+rZ7z3fY9T0KQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l7lewFrELoO4J5DsZ7L8cdfSjON/6SnOXPGvqCrbLu7tb+TL9fd+e2zLY+K+fqMaarzUz9MyrHJU5vJbdIL3EIIySyYwVwPh3aMtWW9rxB47Gr5+vAYtQfwY5j8Rgk7gxpx8azVqUjY9lXDIu2BR6drr6hfaikaJY4CH7IyAhuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVWolua/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04290C4CED3;
	Tue, 17 Dec 2024 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734448447;
	bh=Qpdg/3uNo56RDMPdNnLA2ilJVAUDi/+rZ7z3fY9T0KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVWolua/pSI8gyo6SMN9UC0Vh2Z2MG7SKiP6r696TfG11xLzf53P9FMlWRYlVJBeY
	 AWk0e0Q6XPM9nEjtBBNDHiagSGHTmnBVTumFJ/h7mpYnuK6OSDClIjWKG7VdP3Ah0Y
	 zuuiKXk7q1KLVcwF4hVFEEo9e7/bFoXSgR6FpGX6Y6FEZHWdrqjWkxO8pyWF2h013m
	 R+lIgo7XT1RHYcCVFtZDSXE+Fu5ASaj+xJ/EWI79v19X00mBsxE7rzR/oSqqUmcWij
	 n+/w5+anQLWzXC179NIEHd7s57sa/zHHnzplO2l70mxjGPBpKpaSnhMqV4f1V+igxR
	 eLrPuHhv/Q/4A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNZGv-004bWV-AR;
	Tue, 17 Dec 2024 15:14:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eauger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH 14/16] KVM: arm64: nv: Propagate used_lrs between L1 and L0 contexts
Date: Tue, 17 Dec 2024 15:13:29 +0000
Message-Id: <20241217151331.934077-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217151331.934077-1-maz@kernel.org>
References: <20241217151331.934077-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eauger@redhat.com, gankulkarni@os.amperecomputing.com
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
index fba499a20aec8..b81bfa85ebb19 100644
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


