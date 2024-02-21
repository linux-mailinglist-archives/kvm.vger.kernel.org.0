Return-Path: <kvm+bounces-9261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B6885CFF7
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 06:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5211528602F
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 05:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5D73BB51;
	Wed, 21 Feb 2024 05:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MGYDRQmp"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F76C3B788
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 05:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708494209; cv=none; b=APLOgQx2LCvp0f5cAfagmkFa0iuPlFBuEPWDHFG0x5vOglnptck6TBKGgc3XeARzUm6ZXGrPIxTuWIJuaG/BFW3NPh96qooU7Z9AxR99CWr2xjplK6IWzgkPag0jpDvRNTZZ0ETFe4FOvUavZwSzAcTxDk2u3XtexZOVGpxhSFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708494209; c=relaxed/simple;
	bh=egvxRC64pImQWpYJ5H/66l//0W0vYIRaEzxh49R2ggA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDXUzHkJbLySEteSPqxuw1cm8XrLhGPDirgTvZrUpUaeWGoZgtaoAAngyUFttoKvE/lcuo9AEK7x8q7l6QIwpc2bfOTun7NJsuJx+KXzkBJvmnv/huXgxt061/Pf6t4Oq5d8ncwhcu2niZ5Js+uZOpgbs50CNFmRhAlQ5khQJpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MGYDRQmp; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708494206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hwGBWvx+wwsJa7xNRdwDH7MJ0Q05E6x3UjwcqNXt4/0=;
	b=MGYDRQmpErICmMJRKOaSwPhNZwcGWG9i3eBvE7S9eAoTsD13nFyL/UaN2lmj6158Yql47k
	AE2cr3rXzXv4faz9wb7vFc2SwzJUyIy/dLvzFP+PJ69TdIyorSkUwcQq8Iej9FIRHfuPhI
	PvHsPUfiiZp1eoJHZjh3RHF+HbDCms4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 04/10] KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
Date: Wed, 21 Feb 2024 05:42:47 +0000
Message-ID: <20240221054253.3848076-5-oliver.upton@linux.dev>
In-Reply-To: <20240221054253.3848076-1-oliver.upton@linux.dev>
References: <20240221054253.3848076-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Start iterating the LPI xarray in anticipation of removing the LPI
linked-list.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index fb2d3c356984..b9874dc04608 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -327,6 +327,8 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	return 0;
 }
 
+#define GIC_LPI_MAX_INTID	((1 << INTERRUPT_ID_BITS_ITS) - 1)
+
 /*
  * Create a snapshot of the current LPIs targeting @vcpu, so that we can
  * enumerate those LPIs without holding any lock.
@@ -335,6 +337,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	XA_STATE(xas, &dist->lpi_xa, GIC_LPI_OFFSET);
 	struct vgic_irq *irq;
 	unsigned long flags;
 	u32 *intids;
@@ -353,7 +356,9 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 		return -ENOMEM;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+	rcu_read_lock();
+
+	xas_for_each(&xas, irq, GIC_LPI_MAX_INTID) {
 		if (i == irq_count)
 			break;
 		/* We don't need to "get" the IRQ, as we hold the list lock. */
@@ -361,6 +366,8 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 			continue;
 		intids[i++] = irq->intid;
 	}
+
+	rcu_read_unlock();
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	*intid_ptr = intids;
-- 
2.44.0.rc0.258.g7320e95886-goog


