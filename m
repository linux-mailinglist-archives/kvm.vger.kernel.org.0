Return-Path: <kvm+bounces-15557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6218AD57F
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B11B21C20F52
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B8415622F;
	Mon, 22 Apr 2024 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PnUSdiuw"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D611153BCC
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816139; cv=none; b=i6POgPIyMshbzdUywaxm/sg2PDkwPw3g0Jh1DrgZ9rnfwnNAIDgGOxHIJ2yHXE1ZDOlmW5ePD32S60EprZregkxWMzPjczlfGNCCdrPsY2xcbfIF9UVxWsjBZdyzLz2FxKWr7GZGPPYl84dwqvXgIkBgvVNsEIOVzOYQFlKNqOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816139; c=relaxed/simple;
	bh=aPJ8EsOmW+ShuVGwFxFojefQqgXUi3BYddMzeavuhgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+sWZwxgwFteqvjOmCJsRIvV9rAkQnWU19jCi+oi4gyZYXSJ430Dw2+baYerpkFD4YMTmfEjNWpYkgnyorORDv9QM4H7+3JSyP05QxkHv8E+CyL1yKe1DiaJSoWgUMAeZ64TrC6V1rbG4ZYZqGMBHngkl3Gjg8+e+JWIDsPXhqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PnUSdiuw; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FggNVBv5Qk/uiQWX9kyA7K+xN3CA6hkYXhcHr0dYksM=;
	b=PnUSdiuwdTVzFCC2QS56E444YhhEnrFylOdsZdxUYj2IFPOThUZ87bz+25EV49hQPnfLJ3
	G76DgfYviVVkxxTq3Ex2XBrbRD0pqAIVGMRkUQvFap0mybZNFzyJGqZ3iHoNqqpK7YzBPi
	dbI4CuhczCa0ToUg9Lp9gghoRnPaolU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 03/19] KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_invall()
Date: Mon, 22 Apr 2024 20:01:42 +0000
Message-ID: <20240422200158.2606761-4-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The new LPI xarray makes it possible to walk the VM's LPIs without
holding a lock, meaning that vgic_copy_lpi_list() is no longer
necessary. Prepare for the deletion by walking the LPI xarray directly
in vgic_its_invall().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index bdb7718b923a..07706c5e996b 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1365,23 +1365,19 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
 int vgic_its_invall(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	int irq_count, i = 0;
-	u32 *intids;
-
-	irq_count = vgic_copy_lpi_list(kvm, vcpu, &intids);
-	if (irq_count < 0)
-		return irq_count;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	unsigned long intid;
 
-	for (i = 0; i < irq_count; i++) {
-		struct vgic_irq *irq = vgic_get_irq(kvm, NULL, intids[i]);
+	xa_for_each(&dist->lpi_xa, intid, irq) {
+		irq = vgic_get_irq(kvm, NULL, intid);
 		if (!irq)
 			continue;
+
 		update_lpi_config(kvm, irq, vcpu, false);
 		vgic_put_irq(kvm, irq);
 	}
 
-	kfree(intids);
-
 	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.its_vm)
 		its_invall_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe);
 
-- 
2.44.0.769.g3c40516874-goog


