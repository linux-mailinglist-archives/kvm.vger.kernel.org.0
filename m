Return-Path: <kvm+bounces-38805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 753F7A3E849
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CE91167EC2
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 23:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED1B267384;
	Thu, 20 Feb 2025 23:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DaDqapGV"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493161D5CDD
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 23:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740093707; cv=none; b=KLQ9WcVIxJoalOKuBbwtPDgdzZ9kkjBsFmAnqpV83QtVC4GZiTVi+vnu2UAgbrnisI+QRSAL9OnjdxDwMQeFZLVkl0e3z4+rQbn6GJSL5iFKaT1ACALi+7C3l2Z2rd56QmTJQ8Xqz8+5aVxltJ0xdpaVk5nEK7fS+qtq7So7YUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740093707; c=relaxed/simple;
	bh=g6ve7xNlVgVdQFgPLeNGusPRvCr3J4hbfDhtJ9gFxqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Isiv/Y0aGpPY8qo0Z0itm7g6VdvB2P2huIIDLYXgT3Ovp0yxzzmk72OkQyauCHaa+LrxSZpSaEGe4lTvELVgjGjVHll2fA5h6rPKLtUuJiMVGle4IZiwWtUEt/rHhmKwty0wrsVYYqSFzToObtEGRxVHa9FOWrgJBmxkZELW6pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DaDqapGV; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740093693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Zm+fIkprFMzXqFqejHYGRIWeMskyoEAHZq3W3dz6AW8=;
	b=DaDqapGVqZFoote3oBKSCfSKz8yS3GCvcGZZqbYcYUwKdoqKz0rQJKvHfDRiZCcemyw4t+
	NZhSovbH+/jvLHTC1QmuLClo52pUGEZ9FmtOEQxjvaiCFVc4gViczGxcNs07W4Ni8k+5Pm
	+Ns0G4E0mXgF15jk5D4WaRNg2Oc3hTc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: powerpc: Enable commented out BUILD_BUG_ON() assertion
Date: Fri, 21 Feb 2025 00:20:19 +0100
Message-ID: <20250220232019.196380-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The BUILD_BUG_ON() assertion was commented out in commit 38634e676992
("powerpc/kvm: Remove problematic BUILD_BUG_ON statement") and fixed in
commit c0a187e12d48 ("KVM: powerpc: Fix BUILD_BUG_ON condition"), but
not enabled. Enable it now that this no longer breaks and remove the
comment.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/powerpc/kvm/timing.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
index 45817ab82bb4..14b0e23f601f 100644
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@ -38,11 +38,7 @@ static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type) {}
 static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int type)
 {
 	/* type has to be known at build time for optimization */
-
-	/* The BUILD_BUG_ON below breaks in funny ways, commented out
-	 * for now ... -BenH
 	BUILD_BUG_ON(!__builtin_constant_p(type));
-	*/
 	switch (type) {
 	case EXT_INTR_EXITS:
 		vcpu->stat.ext_intr_exits++;
-- 
2.48.1


