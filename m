Return-Path: <kvm+bounces-3865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B0B808B86
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:12:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5FBE1C20B83
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5521645BF9;
	Thu,  7 Dec 2023 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAphyFtZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DCA125C5;
	Thu,  7 Dec 2023 15:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0A1C433C8;
	Thu,  7 Dec 2023 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701961935;
	bh=bjw4PEa9SjpvxQmxru54wXvwdGXfNeLhwFsEcpsXAT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAphyFtZfO1h8SVG0nkPBfxunKZZHNRrYx9jUY5GVgEZCC/PWS4frBkwVvhKTaZW6
	 u761SZ3lpAqh/aDUKLKe1444yi2HdqD1WgzQqBjhpPwEOOj/m87Y3061vY0cTIq+cQ
	 IzhOr09EvZm2pGlGlg2S9q8q+KccZsOuFAx86WuRXeTCPVSWdcRrgQlLHLbXUAPGwb
	 ZZA78tzNLtFK1v2Uz0mUds4c7EYi3Q1vdMaZF9jYvd15wz8noaM00LHxe69PcjsZST
	 XDzVtD5K7QjJQciJ5VOiyzRFyWbeOqeZTbxpVyhGmglGvaOsJ2v2fAlsrPNkFZvEkA
	 BVscdhDS0AFMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rBG2v-002FcG-Ev;
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
Subject: [PATCH 1/5] KVM: arm64: vgic: Simplify kvm_vgic_destroy()
Date: Thu,  7 Dec 2023 15:11:57 +0000
Message-Id: <20231207151201.3028710-2-maz@kernel.org>
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

When destroying a vgic, we have rather cumbersome rules about
when slots_lock and config_lock are held, resulting in fun
buglets.

The first port of call is to simplify kvm_vgic_map_resources()
so that there is only one call to kvm_vgic_destroy() instead of
two, with the second only holding half of the locks.

For that, we kill the non-locking primitive and move the call
outside of the locking altogether. This doesn't change anything
(we re-acquire the locks and teardown the whole vgic), and
simplifies the code significantly.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index c8c3cb812783..ad7e86879eb9 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -382,26 +382,24 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 }
 
-static void __kvm_vgic_destroy(struct kvm *kvm)
+void kvm_vgic_destroy(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
-	lockdep_assert_held(&kvm->arch.config_lock);
+	mutex_lock(&kvm->slots_lock);
 
 	vgic_debug_destroy(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_destroy(vcpu);
 
+	mutex_lock(&kvm->arch.config_lock);
+
 	kvm_vgic_dist_destroy(kvm);
-}
 
-void kvm_vgic_destroy(struct kvm *kvm)
-{
-	mutex_lock(&kvm->arch.config_lock);
-	__kvm_vgic_destroy(kvm);
 	mutex_unlock(&kvm->arch.config_lock);
+	mutex_unlock(&kvm->slots_lock);
 }
 
 /**
@@ -469,25 +467,26 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 		type = VGIC_V3;
 	}
 
-	if (ret) {
-		__kvm_vgic_destroy(kvm);
+	if (ret)
 		goto out;
-	}
+
 	dist->ready = true;
 	dist_base = dist->vgic_dist_base;
 	mutex_unlock(&kvm->arch.config_lock);
 
 	ret = vgic_register_dist_iodev(kvm, dist_base, type);
-	if (ret) {
+	if (ret)
 		kvm_err("Unable to register VGIC dist MMIO regions\n");
-		kvm_vgic_destroy(kvm);
-	}
-	mutex_unlock(&kvm->slots_lock);
-	return ret;
 
+	goto out_slots;
 out:
 	mutex_unlock(&kvm->arch.config_lock);
+out_slots:
 	mutex_unlock(&kvm->slots_lock);
+
+	if (ret)
+		kvm_vgic_destroy(kvm);
+
 	return ret;
 }
 
-- 
2.39.2


