Return-Path: <kvm+bounces-33963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B0F9F4F23
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 272EF1883A2C
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF371F8925;
	Tue, 17 Dec 2024 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnebEbNC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725C01F76A4;
	Tue, 17 Dec 2024 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734448445; cv=none; b=PXG/XoOnLbBZa9aItYTldrbzJK2HfqKA4lF/3F29aP73AgxhNUF8NmiSD2xQveCpJz7Aq4qUNtikkgd1HPmqi4e9Rd9SPJlCuicLAWbGcjefgKbH/x5tDsGFfx9r68SB3rJEjHD6Q4FNzadAViJ5zsOnGb5T53HRokD3ztLVvYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734448445; c=relaxed/simple;
	bh=lTuulWIes+xx4TZWCTOPHr4hDzPMZjCFsU2Ygx8xIPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=osgBtlhMgYkbiRDdRBlqw4dO5TvaRDFg0YgJn/csqEDjywMWzTrMF5OFKRJXYp76whWV1XOzBJZpxovJSrN/5rFQYl5DYW1G43yKr4aftWmEYRhw32gzKkDwWjvEmIsmKd2gE8Zlrb6s0cTm6F87KlBSGBTxrexDH19jvGnosNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnebEbNC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5098AC4CED3;
	Tue, 17 Dec 2024 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734448445;
	bh=lTuulWIes+xx4TZWCTOPHr4hDzPMZjCFsU2Ygx8xIPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnebEbNC6YXLkwUfTins6EI89sWdYTPAsPMVc/37gm97qb7WLHr+AXNzTfQnZ7yyG
	 aqjwPkP24u4UwVMZKXT34RHUEJiB/pi+bg+bebmV9xAl7/11B3hU/1qpOWTFgE+/ML
	 JlvDrK6KDk+xcKoxQm4NvnXfOGtrCZIQcCLMI/QMZCr89YTIfkpykXzHn//0FFsrOn
	 iJXJ614tCYTmdcBx9zZsIBDHwmxy0h4RnbQE1N/malklCcLhWLTUunc6B703ksw13M
	 An+M6Ge02iXXKNsdIxle38B5OARO1FdZZQU3ZhWE/sLi/c/B+KDP1eWMd7IjgfgKIm
	 p/yYtEJV5+C2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNZGt-004bWV-FT;
	Tue, 17 Dec 2024 15:14:03 +0000
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
Subject: [PATCH 05/16] KVM: arm64: nv: Load timer before the GIC
Date: Tue, 17 Dec 2024 15:13:20 +0000
Message-Id: <20241217151331.934077-6-maz@kernel.org>
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


