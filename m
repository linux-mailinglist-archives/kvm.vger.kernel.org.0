Return-Path: <kvm+bounces-35238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7436DA0AB21
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 18:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33D0B7A3481
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6C41C3054;
	Sun, 12 Jan 2025 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgTOElQg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD211BF7E8;
	Sun, 12 Jan 2025 17:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736701731; cv=none; b=cS2jTKBxu15/aHLYMj3Vbfq5E8KA0qivxpQGWy4aNysTBTEprePz8wSd9G1pM9VaJ8LidtOOi0nXwN5qyid59vaiRsZgJbIlydqM5FwUAVayWWvGbnWSDezQcMqko2EtZpj7ap6wQdtEFqglptPMHQh5+UTHmdeGRY+XgtGAB4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736701731; c=relaxed/simple;
	bh=lTuulWIes+xx4TZWCTOPHr4hDzPMZjCFsU2Ygx8xIPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WCbtn9GfapY/4HSJYljiaN/j035PezXWFj0MMB+gAH3rB1PAJBI45XuSWnMicZXuG4mv/sESP0eKuw0v3oJ/iDUii5Cys67YjFMEXvxAcQbZ2LdwqecWg/jIiFNPTYWKs3CulTrgRzCSfOW4VKZj43gkGzR2eDy1wJCwl8CG9Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgTOElQg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E17C4CEE6;
	Sun, 12 Jan 2025 17:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736701731;
	bh=lTuulWIes+xx4TZWCTOPHr4hDzPMZjCFsU2Ygx8xIPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgTOElQg/YT8lWi3H4TgcDJ9iGBy3PyQATdTQjzM53LqEgKB0UNz34OVzTZu7Iv+I
	 wFY7pLMqaayFnPpoAoozFoyeyFrol2DIGs0A5NsbtVRmYLSa+03e33j/yk/XTYqLqb
	 58BQVS9KLbsbMjAu3V4cbz9hBKqA34luoDM7WYRv5RQIQwzYbeqcyHT+8JVwp1T3Kk
	 bCIT4xT+SYkYvgbyRvwo+0ei0PQLPKl42NawT2IYbceM456FvcBl0Vy7aotftJNKhF
	 ReONyoiFtOxgvqQMlgHcEofF91zsbzbzeqDb/E9GzI0DLqBCRKy2pXdIaarq3V/vn+
	 rS0FTLMYq0oLA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1SD-00BNxR-MJ;
	Sun, 12 Jan 2025 17:08:49 +0000
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
Subject: [PATCH v2 05/17] KVM: arm64: nv: Load timer before the GIC
Date: Sun, 12 Jan 2025 17:08:33 +0000
Message-Id: <20250112170845.1181891-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250112170845.1181891-1-maz@kernel.org>
References: <20250112170845.1181891-1-maz@kernel.org>
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

In order for vgic_v3_load_nested to be able to observe which timer
interrupts have the HW bit set for the current context, the timers
must have been loaded in the new mode and the right timer mapped
to their corresponding HW IRQs.

At the moment, we load the GIC first, meaning that timer interrupts
injected to an L2 guest will never have the HW bit set (we see the
old configuration).

Swapping the two loads solves this particular problem.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc4..3115c44ed4042 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -596,8 +596,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vcpu->cpu = cpu;
 
-	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
+	kvm_vgic_load(vcpu);
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
-- 
2.39.2


