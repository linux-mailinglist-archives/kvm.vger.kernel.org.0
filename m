Return-Path: <kvm+bounces-43964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB05A9912F
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75750165C4C
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043E229B227;
	Wed, 23 Apr 2025 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBNs+0c2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5B729AB0E;
	Wed, 23 Apr 2025 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421319; cv=none; b=mrl6HV7CDrEsCRjUum6ZIsBeDr20i1ll2Q4Oc/3mHsFm3SlbHqm+TO74Ka15t3QHM4YlgyoaUeC6kZqDHUzOJ3cE9jy/PAGwUDqqLzoJvWZPIaLQF/z+srZkT1ae9Sv1sBXQ2+DE1/mPuwaWrA7XiFsr6W3BnBAIZepuOT3LuPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421319; c=relaxed/simple;
	bh=6xnfxO24XeMhZUOFnH7AZVi9lO940gonY1iIvv10IoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BvArQpBhl08YwSilixn7TWRrkST7qLFROXX9IbDcV8xDRDyL1hjAXbtdxSZL8/CLEg430Sou9Zyq4a7v3ACkX9bViwSgKyw5TMH8hE5oKk7/VYzPB7YDrfEzLOSsx6+S+R+2A+Jx2K0NaGPmGDFfteP+URYV+XFGx+CBAgUv6+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBNs+0c2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004DAC4CEE2;
	Wed, 23 Apr 2025 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421319;
	bh=6xnfxO24XeMhZUOFnH7AZVi9lO940gonY1iIvv10IoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBNs+0c2ewB3FewtEFlhCkz0tR8fiJd5k6bnXBXqAQrzvE0gM7q238QH0WnZASAII
	 TwsfRIE6H1llzVNUBBWLc32ymeYfVr8ayZz3Hd420mt6dtR1R4APtzpbdzRMfvMuuJ
	 ExlR8N6JuZvxEmbdL9NRp8njZQUVMxsXs6Z6B735ceTchGmCtAEsgMGI2GGTVvkhtx
	 mgvvSoYshyceuQJr+bBzFddFYJVIjA/Q0CSHhNCXLKhLx9NaPU6sCXfEbf9yvactZJ
	 x+ILvaTvqu1Q7TS9BwqnzCwhXiaYZr+23YVL4b/8MEJV5znOxcjDbDfkcL20Fhpi84
	 D7ZwWHO4XpSvg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7boj-0082xr-1U;
	Wed, 23 Apr 2025 16:15:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 15/17] KVM: arm64: nv: Remove dead code from ERET handling
Date: Wed, 23 Apr 2025 16:15:06 +0100
Message-Id: <20250423151508.2961768-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250423151508.2961768-1-maz@kernel.org>
References: <20250423151508.2961768-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Cleanly, this code cannot trigger, since we filter this from the
caller. Drop it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 0fcfcc0478f94..5e9fec251684d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2471,13 +2471,6 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
 	u64 spsr, elr, esr;
 
-	/*
-	 * Forward this trap to the virtual EL2 if the virtual
-	 * HCR_EL2.NV bit is set and this is coming from !EL2.
-	 */
-	if (forward_hcr_traps(vcpu, HCR_NV))
-		return;
-
 	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
 	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
 
-- 
2.39.2


