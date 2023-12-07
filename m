Return-Path: <kvm+bounces-3869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F07E0808B8A
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:12:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D2301C20BF0
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1CB46420;
	Thu,  7 Dec 2023 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uj115eZE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDE444C80;
	Thu,  7 Dec 2023 15:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33E7C433CA;
	Thu,  7 Dec 2023 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701961935;
	bh=9DwyeeOFDy6a1ZMT+28RG+1vcydLrWW/k+tdC7nSpJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj115eZEedKdopVE1F8DmyQlGIIaHBbl3Fq4UMZux6rlw02bKLeaaWPnf01lNc/Kr
	 h64K0o5ZbZIq/W+6nWTzsim2u11IICidrF1yEYZzHNcXHkH/bjCO1qY47sGLv4gPCm
	 ukRz8YqtEbSAC5KYhBi5xhEAaMpEYVe3sJBMpCLeF0BhmuR+lh/2oALRZyNdNEjUxn
	 4Map0mi2841QiJp16RoJRGymsCeXPxxGoyqYPhFDEuvmrfiBqM/X6hUrezqECD59vo
	 tTWaYFy7iH1iDHUO4991TBr8bqT1q9izAEB3c6ULJo9I0McScdcXBQQ75sPW6OtxXX
	 /nMXT5/HXPD2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rBG2v-002FcG-L7;
	Thu, 07 Dec 2023 15:12:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	vdonnefort@google.com,
	stable@vger.kernel.org
Subject: [PATCH 2/5] KVM: arm64: vgic: Add a non-locking primitive for kvm_vgic_vcpu_destroy()
Date: Thu,  7 Dec 2023 15:11:58 +0000
Message-Id: <20231207151201.3028710-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231207151201.3028710-1-maz@kernel.org>
References: <20231207151201.3028710-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, vdonnefort@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are going to need to call into kvm_vgic_vcpu_destroy() without
prior holding of the slots_lock, introduce __kvm_vgic_vcpu_destroy()
as a non-locking primitive of kvm_vgic_vcpu_destroy().

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index ad7e86879eb9..a86f300321a7 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -368,7 +368,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		vgic_v4_teardown(kvm);
 }
 
-void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
+static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
@@ -382,6 +382,15 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 }
 
+void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->slots_lock);
+	__kvm_vgic_vcpu_destroy(vcpu);
+	mutex_unlock(&kvm->slots_lock);
+}
+
 void kvm_vgic_destroy(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
@@ -392,7 +401,7 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	vgic_debug_destroy(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_vgic_vcpu_destroy(vcpu);
+		__kvm_vgic_vcpu_destroy(vcpu);
 
 	mutex_lock(&kvm->arch.config_lock);
 
-- 
2.39.2


