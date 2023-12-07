Return-Path: <kvm+bounces-3867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2FC2808B88
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5737FB20CEF
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6132A45C00;
	Thu,  7 Dec 2023 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nVLtvTQs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C5F44C78;
	Thu,  7 Dec 2023 15:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5335C433CC;
	Thu,  7 Dec 2023 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701961935;
	bh=xB410b3BErVoxCS51k+tCMypT8OeoqnuZ/RFcZFPmjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVLtvTQsQ7LJLfl3aYxAEm5pFvQM5EF/uicU8XkpvCdWS7vVN9RwAkLgJdSl37bF8
	 3K1jVWQDEHTe7InOpOX/JYZXsR5F8OCoIDPkogGaM48X059ffc3YVshp3QXqfkjQ2z
	 WXHOek7NzBiP5OR6C3mceKhlBbspHKpj0O411U4lAIxgJ4xmg+p3aD6Gst2S07TpZB
	 5b7P3yqDHIQgYRzuFlB5rSk3D4hO75OXQBQyymSNq6XSBwJ4iF9lQxPqJT4ARDhH/D
	 dQS0txJUn2/oVqxPHi3y8ipU65y5EPubQ6pMaeM8wrNoH958q6F/xaPH8YSKG3jjW1
	 KVe8usuzgiEnQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rBG2w-002FcG-0r;
	Thu, 07 Dec 2023 15:12:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	vdonnefort@google.com
Subject: [PATCH 4/5] KVM: arm64: vgic: Ensure that slots_lock is held in vgic_register_all_redist_iodevs()
Date: Thu,  7 Dec 2023 15:12:00 +0000
Message-Id: <20231207151201.3028710-5-maz@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, vdonnefort@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although we implicitly depend on slots_lock being held when registering
IO devices with the IO bus infrastructure, we don't enforce this
requirement. Make it explicit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 0f039d46d4fc..a764b0ab8bf9 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -833,6 +833,8 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 	unsigned long c;
 	int ret = 0;
 
+	lockdep_assert_held(&kvm->slots_lock);
+
 	kvm_for_each_vcpu(c, vcpu, kvm) {
 		ret = vgic_register_redist_iodev(vcpu);
 		if (ret)
-- 
2.39.2


