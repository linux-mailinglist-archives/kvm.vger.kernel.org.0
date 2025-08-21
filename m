Return-Path: <kvm+bounces-55229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F40FB2EBD2
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 05:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F5AA7BA8CA
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 03:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31652E2EED;
	Thu, 21 Aug 2025 03:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSGJq1DP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E40518C933;
	Thu, 21 Aug 2025 03:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755746270; cv=none; b=E+64WPCAdwY+l8t6oaFcx96UjxjjPErvjFD9pbuQ8xS3WV9GqL/Ci62ui381YLo7Egdea/augRzm07dZwSyDp/vZl1vhSbaat2cUeJoBJ/ZnK7ArzWQXfZIRLUFkW/zJKQ3z6vG07OHeQ4fdYnSoQamAVKr/Of9LdhIZKhCQI2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755746270; c=relaxed/simple;
	bh=h+RF8Zb0d9oJ8hZkMq/D3wvDV9FwApYP4YjX6BOlwV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jWN/pyXwmIlBgWge4CJHNXxG3Xlaif6OARpXiCwIKYNVI0UUwkjdwMNn1CrQokBh52S2fA+C+SZwlGBOrg+zd/LuDazxpK03Kb54BeD77UHV3iRYxyeM/c/Kee7z65ttvnxLGdHc2YkWB2SrKxddyyTbj1s6Wx6p2N2hr4Xerjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSGJq1DP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEC9C4CEF4;
	Thu, 21 Aug 2025 03:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755746269;
	bh=h+RF8Zb0d9oJ8hZkMq/D3wvDV9FwApYP4YjX6BOlwV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSGJq1DPysGgIf+Lr/1513mNXeTyr7qdgoGdnWxlqycHWI1Gn+d7cX/ZgRfWAONco
	 ZkVGg+aiH9OHwm5T9ph0bNE8BaRYfpN0U4a/E9YGtoZpda05aOtiEPM0Cb2ziq0do2
	 +lA9oPDwkbUCOhBbBb0lIA+v8Nf6Pd1rRJxS9s6Ur1KrzEZmT3ua+BTknKhaokBYoV
	 4FVfXrvAbmhDjpo0UfcsQzQOo+Q2r0zpRUwOANSzriB/1T5vE8XqtruRQ2uXWi+ybJ
	 2zkw2MV7OK0tkfGm6C3hqb7h2futgD97togXhjc13T9DT1sOlOtgkt3HmBezphki4n
	 8s8bZg3T+GkXQ==
From: guoren@kernel.org
To: guoren@kernel.org,
	troy.mitchell@linux.dev
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@linux.alibaba.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com
Subject: [PATCH V4 2/3] RISC-V: KVM: Remove unnecessary HGATP csr_read
Date: Wed, 20 Aug 2025 23:17:17 -0400
Message-Id: <20250821031719.2366017-3-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250821031719.2366017-1-guoren@kernel.org>
References: <CAJF2gTQFWJzHhRoQ-oASO9nn1kC0dv+NuK-DD=JgfeHE90RWqw@mail.gmail.com>
 <20250821031719.2366017-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>

The HGATP has been set to zero in gstage_mode_detect(), so there
is no need to save the old context. Unify the code convention
with gstage_mode_detect().

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
---
 arch/riscv/kvm/vmid.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 5f33625f4070..abb1c2bf2542 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -25,15 +25,12 @@ static DEFINE_SPINLOCK(vmid_lock);
 
 void __init kvm_riscv_gstage_vmid_detect(void)
 {
-	unsigned long old;
-
 	/* Figure-out number of VMID bits in HW */
-	old = csr_read(CSR_HGATP);
 	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
 	vmid_bits = csr_read(CSR_HGATP);
 	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
 	vmid_bits = fls_long(vmid_bits);
-	csr_write(CSR_HGATP, old);
+	csr_write(CSR_HGATP, 0);
 
 	/* We polluted local TLB so flush all guest TLB */
 	kvm_riscv_local_hfence_gvma_all();
-- 
2.40.1


