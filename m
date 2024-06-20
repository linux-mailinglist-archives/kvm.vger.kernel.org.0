Return-Path: <kvm+bounces-20132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 901E1910D87
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:49:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8734B25B09
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63721B4C31;
	Thu, 20 Jun 2024 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="skqt5qEU"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17621B4C2C
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902049; cv=none; b=kIf01BticrgkxRKLQUYR6ATGcEvCyECoXYiVcM+3bdSRgLtY3aahChAvsRNoHATJjKmkLJZBLgHWfLvvmXajf9x82yRXnHdWx3qX+jmXWlJdLu+8wZx2XqMhmy6Nndhq1J89T+rz23EOpuqUI9n5bMf9+MynuaKCH/ICaomqtfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902049; c=relaxed/simple;
	bh=AB7fFKaZ4IzZn209XJyuszZvhI37LCYwB3JZOQnIwPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF+kvf/QIYwy+ExIwwIbELeMhypluA5uhTJM2GpcEqDokeEt3t26QYBSpn01D+/meb1jIxWOb8mVdyBuh5TYKTB7e/xf6a4GuNhauXnG44SdtFptfJoZMYdUXjcTUDQdcGcmZjrT+Jwzij9a6PPqbiY+C0YWoM36dCvm1TA2OpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=skqt5qEU; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NAN7p6f7rgTiinz1pWiC7BoeIE5/rA20oN+kCgrXMGk=;
	b=skqt5qEUKdD4gmmJdjkRja67McNVpEwCIsA8Mpx3yq8Pvz5TOzW8sjT049KFybDEC+tzgp
	W+dLXD1o9oaF5HLSgQf12XJUZB1ioNTovPQE6+5KIXBBgj/5jiQk9VF9/IDTF/pltYQLBe
	8wMOhgqCzn8P2hoGsEb8iZP4jNHiaCU=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 12/15] KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
Date: Thu, 20 Jun 2024 16:46:49 +0000
Message-ID: <20240620164653.1130714-13-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

We are missing the propagation of CPTR_EL2.{TCPAC,TTA} into
the CPACR format. Make sure we preserve these bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_nested.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5e0ab0596246..a11ed921d4e0 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -32,7 +32,7 @@ static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
 
 static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
 {
-	u64 cpacr_el1 = 0;
+	u64 cpacr_el1 = CPACR_ELx_RES1;
 
 	if (cptr_el2 & CPTR_EL2_TTA)
 		cpacr_el1 |= CPACR_ELx_TTA;
@@ -41,6 +41,8 @@ static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
 	if (!(cptr_el2 & CPTR_EL2_TZ))
 		cpacr_el1 |= CPACR_ELx_ZEN;
 
+	cpacr_el1 |= cptr_el2 & (CPTR_EL2_TCPAC | CPTR_EL2_TAM);
+
 	return cpacr_el1;
 }
 
-- 
2.45.2.741.gdbec12cfda-goog


