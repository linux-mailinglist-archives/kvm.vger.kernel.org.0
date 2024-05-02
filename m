Return-Path: <kvm+bounces-16454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2518BA40F
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFBAF1C22050
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F724A99C;
	Thu,  2 May 2024 23:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wWWjTHkm"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1254D20322
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 23:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692948; cv=none; b=p3mdhefPU5oEi+AKV8c++Y6zwspnkulXfNQJyCMJvP4EzTAxYMZA6XmATpfyV29OernDFCsCoIrgqso6t+4chL+ZSTjoRpG33LDgBJ0ihZWjd0+iSOViIErhAqJ9RzmFwLtDOK8B7GKcaQ5A7G5idKShf0Y+lpmpxUMtO9j6APA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692948; c=relaxed/simple;
	bh=RVLlP9UAJjT9rjtC4yBjgEoC1k0lV6g61gpobEnfixU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnw9dOvA/MrJCrj1/LzdFEEmL0O9S/z8K1O8e5ELF3SFrKmT8mSeBjwu/85oTLi6K1gPFbCkzjH804v206qQ2/ahZx5zEgGtM1V/9C1TIqucapil0aVIwSkUdHAQY23MSJkFaYTpgEkFIkE1Vfb39s7JBUUSuRHzJblE8U9Qs6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wWWjTHkm; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714692945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vF3+YH+65XdKRfWLhifnu1CKp8rh29togi7QQaOdEYU=;
	b=wWWjTHkmXwrZl29Q6K7Vc/6Gstu8uglD6ym8FlLg7jW0LTrt3xxRyPtuyTMpUAkK2JB/Vp
	jqWFf2UYTC+QkfmJ89uUqW1USEJ9F4cgonWyrPMHxuya2/DYnKkzC9Fs4gzeJ4xOOk6MaS
	gTe/ML+TpC6ZCJ8jQx2G/08hlW4/UdM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 4/7] KVM: selftests: Rename helper in set_id_regs to imply VM scope
Date: Thu,  2 May 2024 23:35:26 +0000
Message-ID: <20240502233529.1958459-5-oliver.upton@linux.dev>
In-Reply-To: <20240502233529.1958459-1-oliver.upton@linux.dev>
References: <20240502233529.1958459-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Prepare for a later change that'll cram in per-vCPU feature ID test
cases by renaming the current test case.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/aarch64/set_id_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index 16e2338686c1..3d0ce49f9b78 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -374,7 +374,7 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
 	TEST_ASSERT_EQ(val, old_val);
 }
 
-static void test_user_set_reg(struct kvm_vcpu *vcpu, bool aarch64_only)
+static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 {
 	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
 	struct reg_mask_range range = {
@@ -476,7 +476,7 @@ int main(void)
 
 	ksft_set_plan(ftr_cnt);
 
-	test_user_set_reg(vcpu, aarch64_only);
+	test_vm_ftr_id_regs(vcpu, aarch64_only);
 	test_guest_reg_read(vcpu);
 
 	kvm_vm_free(vm);
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


