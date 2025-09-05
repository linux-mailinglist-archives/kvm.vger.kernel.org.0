Return-Path: <kvm+bounces-56860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9F01B44FCA
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 09:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C559B627D5
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 07:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCCAA2EA477;
	Fri,  5 Sep 2025 07:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGuR7LOd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055A82E92D2;
	Fri,  5 Sep 2025 07:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757057345; cv=none; b=SSToHu8brjNXwS9BAXLFohJpVARN6cxfzC9kWJ97APXDmkl2jPqO8GVHOdM5IMAY7szsdd6z0bGQTSmnLT4XHO+RDTwraSYR4Y1DxsXYev0pspkpuqIZZL5PrR+7JW4nis5cA/DhR7gYJwIQBsyoODJfb/yCqWx+I1bL4PLfIBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757057345; c=relaxed/simple;
	bh=yVy1f3yKmPmzFcw9VKqDyY9YboyVtGIYlwJrQrV2qog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mT6B9P3/VW3lGSqaVbiVU1hBFdiituZ9OTYx6gMXShIHKjVXVIHIkQxsmzpJoIu8iXWdKuw455W9XDtSHFFshoNu7d3Cu3BJC3B6in4o56xnzLlEH79e1pWDyeh7Vi0wXd0WIdJbRlyXwYY8p7ksQ7mKaA29B2iK0Mm7mma4Jcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGuR7LOd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D324C4CEF1;
	Fri,  5 Sep 2025 07:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757057344;
	bh=yVy1f3yKmPmzFcw9VKqDyY9YboyVtGIYlwJrQrV2qog=;
	h=From:To:Cc:Subject:Date:From;
	b=oGuR7LOdCqpTVIeg+Y1AtdcT434yJI73d6FnTZh8Ibgz6vjBV+WB2H1zg7zyA8Q3X
	 4uZ61Bvtmm9/OU65Kg4MeJAzI9AoeM4UJnAW9Yl2zfvURlKc54UDDFl3BmXsepJIFf
	 P8Q9juSPgRsENh5jbPAzr2C0LdpcHd63f++ybzmoTlZjMhuCwmuyMiPaw1t3Lzg2RK
	 iDf1mBgpf2+rM79po6E0bMX8KRCPq5Kc0VPAYDf/tPTA361hbOao+jIyGeaymAT9JQ
	 3dPB/R3UgXUd4Lr6YRaW8KVDpqEmuFoHJvEvy8+2+GOv96t7TPxgPTAMyJx4v2P4OO
	 9T3NUhB0jcahA==
Received: from [131.175.126.3] (helo=lobster-girl.dot1x.polimi.it)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uuQsY-00000003Y39-0yts;
	Fri, 05 Sep 2025 07:29:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Mark freed S2 MMUs as invalid
Date: Fri,  5 Sep 2025 08:28:59 +0100
Message-ID: <20250905072859.211369-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 131.175.126.3
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When freeing an S2 MMU, we free the associated pgd, but omit to
mark the structure as invalid. Subsequently, a call to
kvm_nested_s2_unmap() would pick these invalid S2 MMUs and
pass them down the teardown path.

This ends up with a nasty warning as we try to unmap an unallocated
set of page tables.

Fix this by making the S2 MMU invalid on freeing the pgd by calling
kvm_init_nested_s2_mmu().

Fixes: 4f128f8e1aaa ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9a45daf817bf..315aaadfda30 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1074,6 +1074,10 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 		mmu->pgt = NULL;
 		free_percpu(mmu->last_vcpu_ran);
 	}
+
+	if (kvm_is_nested_s2_mmu(kvm, mmu))
+		kvm_init_nested_s2_mmu(mmu);
+		
 	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
-- 
2.47.2


