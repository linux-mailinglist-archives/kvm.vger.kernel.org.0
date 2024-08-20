Return-Path: <kvm+bounces-24588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0944D958390
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 397E21C21696
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6312518CBEC;
	Tue, 20 Aug 2024 10:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjkfdWsw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8443318E355;
	Tue, 20 Aug 2024 10:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148371; cv=none; b=ctyobD1F0+tt+P8lfVVOHvgqqHZ1+bc0+KjKEl1H7XFXBoH1ILtBptaEBxT+GUhaNKojC/jpMtslr58Kp3YbNleH0sexMyKb3bZDOF20oJ4ZqBXxWVmwSZ+B8ZT2skMnSvO4bTwc9JfISrciwpey6vjp+CppuDzorgmN24W4Oo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148371; c=relaxed/simple;
	bh=LOn8tbYqpTMo41juZ2qkyQCqnzv3ZHAiBo/Bqa9Q1yk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f/IT9BSCnrYtORoXyOf/U7LF6eTGlLnDUAg9w8LTRXCMnaCu0eVTNd4r68a6GbbyuItBAWwZq2lJRgu+KEgKuKr9JI8HlquJ50wAMvcMk5Jo/2vstUR+hwt2IiGqpaag1RCX5bUI1pEY1da7pJ2iSzJlPzRBZ99vlcfI9OW8wO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjkfdWsw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AD4C4AF09;
	Tue, 20 Aug 2024 10:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148371;
	bh=LOn8tbYqpTMo41juZ2qkyQCqnzv3ZHAiBo/Bqa9Q1yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjkfdWswvzeL9O4dMnfDrLLWRNbHRxqWc3pVtdW8xZ9mDPZ8YxJHdWJYPzcpPnkp7
	 mfKjcWALdwbOX4APYMwOhXOkAKtTVqslLaNrvJ1EIwso0HCXAj9V7bZN9jACGqrhNG
	 gE9fJgTGI7z8kraDBU66wpdP/03HWnVuxGoGqrELumL7gGfCJG7aV7+SounlcxVApI
	 jFquupe6gaK1ACOY6anTUP6sz6j1JPDVHkmaMZGiX2KVPGCC6PT3aM7U56v5ToxjOa
	 E9SExhCfezuvkRV1ilqqwC3ZohlJPcBViYR0U02JrpfVXKYrl0SSCi7FfTsrZ/PTsx
	 1hne43Wn2FgvQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLkf-005Dk2-12;
	Tue, 20 Aug 2024 11:06:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>,
	stable@vger.kernel.org
Subject: [PATCH 01/12] KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
Date: Tue, 20 Aug 2024 11:03:38 +0100
Message-Id: <20240820100349.3544850-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820100349.3544850-1-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On a system with a GICv3, if a guest hasn't been configured with
GICv3 and that the host is not capable of GICv2 emulation,
a write to any of the ICC_*SGI*_EL1 registers is trapped to EL2.

We therefore try to emulate the SGI access, only to hit a NULL
pointer as no private interrupt is allocated (no GIC, remember?).

The obvious fix is to give the guest what it deserves, in the
shape of a UNDEF exception.

Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/sys_regs.c  | 6 ++++++
 arch/arm64/kvm/vgic/vgic.h | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..31e49da867ff 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -33,6 +33,7 @@
 #include <trace/events/kvm.h>
 
 #include "sys_regs.h"
+#include "vgic/vgic.h"
 
 #include "trace.h"
 
@@ -435,6 +436,11 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 {
 	bool g1;
 
+	if (!kvm_has_gicv3(vcpu->kvm)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index ba8f790431bd..8532bfe3fed4 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -346,4 +346,11 @@ void vgic_v4_configure_vsgis(struct kvm *kvm);
 void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val);
 int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq);
 
+static inline bool kvm_has_gicv3(struct kvm *kvm)
+{
+	return (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
+		irqchip_in_kernel(kvm) &&
+		kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
+}
+
 #endif
-- 
2.39.2


