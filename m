Return-Path: <kvm+bounces-50350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D82AE4382
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D8C9189E521
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACAA254B19;
	Mon, 23 Jun 2025 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ecprC0Be"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5F724E019;
	Mon, 23 Jun 2025 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685251; cv=none; b=dUMVCIWWphIDxw7JqniyWVQJw90VIzyEFi1IHm0ECnIUS7UkoWDpshjbYyCPAAOG2zPzNhs5/YL03fhL2LqbnL+eEbMmysaNwyAyoyRpIa23MeUt6e8XHMsYMMsw7tuiQiShZwFj6ar9WQ5ucZANqdCRWlacLWEvX/w3BPW8gUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685251; c=relaxed/simple;
	bh=OAFTThjQbfy9nAc9ifWeL04/k1E7jUOp5koyzmWAnrs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXxyONYUPmYTkw4OPU7uich1SEJdzgwPYzJ29q6fDF4uK8eXI96rnyNpWiDxj6ShoWGiaURB3W/MN9mapiYDmpym5yhNGnwJwkxAGpWns90SG7n5I0A5vtQu2yDVHyAgORZcNbczDo0FelvwKuqsBwlGBThKbjzNIegfT/fBFvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ecprC0Be; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=tLS0jqGrb3MS8d9+Zqocfz6+iEasSrP5hi+kiaqEmQE=; b=ecprC0BeB4NxOfTFqXpdgg1LEM
	5eXgD9f0C3XYq+pHcYoq7Ztl/bJbw5L9Ch82IPn1W2+iVqy2FpMiHLpJjsRJn3bdhg1fDd9N3wJkh
	mJTSuhvs45tGnJfLS5od6lE4qCOKvDGKgmLoT9QPOivFufL4Qto8OSTjbV99CmbqR1AvmpewxgC3T
	psnj+n7fKFLeFmMh1AxIr+lMPltlUZG2lQkWFny+SguVW32kM/5bqVwBLDlE3DBfRl20ZrrcIH5ER
	3kUZe24CFUFJlR4w1QiNfiX34Lbnumd3K2za9rylJ5nk5SDruYpFlogA1Moq4wsFnomxa51OEmwg7
	5CFdaX2Q==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uThCe-00000005Du5-1SQN;
	Mon, 23 Jun 2025 13:27:16 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uThCc-000000043AO-2kz9;
	Mon, 23 Jun 2025 14:27:14 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [RFC PATCH 2/2] KVM: arm64: vgic-its: Unmap all vPEs on shutdown
Date: Mon, 23 Jun 2025 14:27:14 +0100
Message-ID: <20250623132714.965474-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623132714.965474-1-dwmw2@infradead.org>
References: <20250623132714.965474-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

We observed systems going dark on kexec, due to corruption of the new
kernel's text (and sometimes the initrd). This was eventually determined
to be caused by the vLPI pending tables used by the GIC in the previous
kernel, which were not being quiesced properly.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/arm64/kvm/arm.c          |  5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c | 14 ++++++++++++++
 include/kvm/arm_vgic.h        |  2 ++
 3 files changed, 21 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 38a91bb5d4c7..2b76f506bc2d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2164,6 +2164,11 @@ void kvm_arch_disable_virtualization_cpu(void)
 		cpu_hyp_uninit(NULL);
 }
 
+void kvm_arch_shutdown(void)
+{
+	kvm_vgic_v3_shutdown();
+}
+
 #ifdef CONFIG_CPU_PM
 static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
 				    unsigned long cmd,
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b0..6591e8d84855 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -382,6 +382,20 @@ static void map_all_vpes(struct kvm *kvm)
 						dist->its_vm.vpes[i]->irq));
 }
 
+void kvm_vgic_v3_shutdown(void)
+{
+	struct kvm *kvm;
+
+	if (!kvm_vgic_global_state.has_gicv4_1)
+		return;
+
+	mutex_lock(&kvm_lock);
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		unmap_all_vpes(kvm);
+	}
+	mutex_unlock(&kvm_lock);
+}
+
 /*
  * vgic_v3_save_pending_tables - Save the pending tables into guest RAM
  * kvm lock and all vcpu lock must be held
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4a34f7f0a864..e850ee860238 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -442,6 +442,8 @@ int vgic_v4_put(struct kvm_vcpu *vcpu);
 
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
 
+void kvm_vgic_v3_shutdown(void);
+
 /* CPU HP callbacks */
 void kvm_vgic_cpu_up(void);
 void kvm_vgic_cpu_down(void);
-- 
2.49.0


