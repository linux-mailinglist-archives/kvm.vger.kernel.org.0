Return-Path: <kvm+bounces-20316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AAD39913097
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 00:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D1411F22D83
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 22:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B4D16B3B9;
	Fri, 21 Jun 2024 22:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kHjtPmSC"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394BB16D4D8
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 22:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719010258; cv=none; b=kbj3gAfeUKEhECYve75dJFumqLseEOvY9n5/nQOjNzs/UL2pFeIC8F7tST66dnC6a+6xdOyDHjrZOGopi7IUpu5CLjI/vY9bQAARQLvZpWrWRkeyorxToRoWNooFB1kOiGWQEISAntzUBuNqWTAp524hFQLHDjpmX6TDi/MKuUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719010258; c=relaxed/simple;
	bh=WssRw6bC7c07l+/R+5V1RUQ2OSX4YBQrO5UhnBe2Q0A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dsEQQd1Q0sna+PB72WVHDqGtGCjU82U10Bc1XXn2r+tsFtiT2dqRpKZaaeQJnNs2sCd7rZyVc8Gwg59fRajuOjmLMLFxfz7Met5jCniMsRjO3/isAlEy9MLcSdAuHV3tGbkMPmNfTf/0qwwk6Zqc+SsHo0sWecHanUaYfsOW/0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kHjtPmSC; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719010253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cq5jbSXcKuwxHk9WCWHT1kVsa3LmunE883tOEVCVOW4=;
	b=kHjtPmSCDvYLEXVfxpWeNNj7FllsWcQV+KWv5d1eHQuEegjJCkzKpZv6yUvWazLG1dQj5q
	XJKzDvTkIMKhfTCLkVEuWo+vUl593peesl8fsC7ec3bzzq5d3rCX8gyfdjVonPJxf8bApw
	84EXaQh2csplk9jDNynY9ULozkGa+zs=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: selftests: Assert that MPIDR_EL1 is unchanged across vCPU reset
Date: Fri, 21 Jun 2024 22:50:45 +0000
Message-ID: <20240621225045.2472090-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

commit 606af8293cd8 ("KVM: selftests: arm64: Test vCPU-scoped feature ID
registers") intended to test that MPIDR_EL1 is unchanged across vCPU
reset but failed at actually doing so.

Add the missing assertion.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/aarch64/set_id_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index 9583c04f1228..d20981663831 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -539,6 +539,7 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	for (int i = 0; i < ARRAY_SIZE(test_regs); i++)
 		test_assert_id_reg_unchanged(vcpu, test_regs[i].reg);
 
+	test_assert_id_reg_unchanged(vcpu, SYS_MPIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_CTR_EL0);
 

base-commit: a9e3d7734719d5b58f260edc15dce3ea4dc3d313
-- 
2.45.2.741.gdbec12cfda-goog


