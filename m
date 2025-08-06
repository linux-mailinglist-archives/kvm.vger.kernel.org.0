Return-Path: <kvm+bounces-54127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C78B1CA27
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 18:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 869E84E2C09
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 16:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2312C29CB4A;
	Wed,  6 Aug 2025 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPt+sa2H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439D029B8D8;
	Wed,  6 Aug 2025 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499391; cv=none; b=S9x57j/YzTIFvpf/aly5+qCPlWhW2Okj7LdUkPcGX7hmVUPN2nzivMGewlzwUu4pVqWV9Xkhv+0l26iJ93YJcNlrTrIWqOwdqPakrBBKBh6/MEoCH2Vof3Q16hPP3KgQ+K4ACdryou5JQc4urWmhIeiDjc7rLTWErAyJny01rSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499391; c=relaxed/simple;
	bh=JaFSWJU85Fpq1EgbXnM5BHKfbOjbYmhuKh/TLmUtnBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ka7zY+BnOacNDITTgjg5V6HUuyOEZD/UvkjF3MIppYhbT27tRSQKb5uqkoWovhRGIU7HFZgYcPtWYJT+4Idip8kWc2mdXtQ/JxDwloK/LM3+7t/H3pBcPzOCT0C8A33JCqXU2h6JZ0EGmgkA0ZY2PnB+QIugOiAQ2wZnBNxO6io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPt+sa2H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C291EC4CEFA;
	Wed,  6 Aug 2025 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754499390;
	bh=JaFSWJU85Fpq1EgbXnM5BHKfbOjbYmhuKh/TLmUtnBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPt+sa2HevfnRmwWNIN0+KH5gVnOEjbirwxNxZ+emt54Z0n7ezlnI93RQW6rFzeq4
	 cBpveHLAVbvrHkgqsvTFqOu/MrCe5QBWmaO7Ll8het7GUjjAf8p0THgSw7zJPwIxsi
	 oprDAq884JCL+VmRS66CXMS82KVZg+D9YUpVqs4wVJgJZlz7LFkAFp3l12ifbhD86G
	 q4ArwTgFLQ9LRKJ+SqVtlxdB1A1AYW8GXA8VkZg5kcrefK22WY3gbiOta12uqLDHdP
	 dlHwCv2rUfWoZWa5ueN+li18DosrGaFHrz3Cyul+jxOLeOQdc5Dl/fly9wY+x3pJaP
	 5VG1hJ6Ft6Q5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ujhRE-004ZQV-P7;
	Wed, 06 Aug 2025 17:56:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 5/5] KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
Date: Wed,  6 Aug 2025 17:56:15 +0100
Message-Id: <20250806165615.1513164-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250806165615.1513164-1-maz@kernel.org>
References: <20250806165615.1513164-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make ID_AA64PFR0_EL1.RAS writable so that we can restore a VM from
a system without RAS to a RAS-equipped machine (or disable RAS
in the guest).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 66e5a733e9628..3a50ade091491 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2951,7 +2951,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    ~(ID_AA64PFR0_EL1_AMU |
 		      ID_AA64PFR0_EL1_MPAM |
 		      ID_AA64PFR0_EL1_SVE |
-		      ID_AA64PFR0_EL1_RAS |
 		      ID_AA64PFR0_EL1_AdvSIMD |
 		      ID_AA64PFR0_EL1_FP)),
 	ID_FILTERED(ID_AA64PFR1_EL1, id_aa64pfr1_el1,
-- 
2.39.2


