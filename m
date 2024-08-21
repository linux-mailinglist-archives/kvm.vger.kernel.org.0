Return-Path: <kvm+bounces-24711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A76959A94
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7319428185F
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D921B5EC8;
	Wed, 21 Aug 2024 11:27:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8577614C5BD;
	Wed, 21 Aug 2024 11:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724239664; cv=none; b=AP36e24IVHa6ZoxxzpX+BZpm9McGrxiFsuSCtTP7iIzm7RprgEVGBgfyXk3PAcybs1Htq7FFATAnYUVuppCBEFhIk6haVgACXYGrr7aiMXj938hXxoQIX1SfMxPxme6tY7ByvS/Cq9nN7coY6X8sOn3fr+b4oNWY78gzQOLG2IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724239664; c=relaxed/simple;
	bh=k+wI27GqsGnBaCjuAIHqFhYnhQ6n7mgQgpX76GKua1I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hjFxKeM9vT0ubsI50V65nPOMTTD7LraHCy9koU8Y26zUVNucbJsU0FdpOCbXbVQQrflVa0xNTIiyzSuib5uWTa7c3Q1E3Bnwnxl8Gu8m4Aqiq/raciVMcHPxEgJnYCCj+A2aECTPIHDxKhfQJ0MQrdHkSNjkmolnhFBeZFSpQRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WpkTX6VHpz20lPs;
	Wed, 21 Aug 2024 19:22:56 +0800 (CST)
Received: from dggpeml500005.china.huawei.com (unknown [7.185.36.59])
	by mail.maildlp.com (Postfix) with ESMTPS id 976381401F3;
	Wed, 21 Aug 2024 19:27:38 +0800 (CST)
Received: from huawei.com (10.175.112.125) by dggpeml500005.china.huawei.com
 (7.185.36.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 21 Aug
 2024 19:27:37 +0800
From: Yongqiang Liu <liuyongqiang13@huawei.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
	<hpa@zytor.com>, <x86@kernel.org>, <dave.hansen@linux.intel.com>,
	<bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <liuyongqiang13@huawei.com>
Subject: [PATCH -next] KVM: SVM: Remove unnecessary GFP_KERNEL_ACCOUNT in svm_set_nested_state()
Date: Wed, 21 Aug 2024 19:27:37 +0800
Message-ID: <20240821112737.3649937-1-liuyongqiang13@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500005.china.huawei.com (7.185.36.59)

The fixed size temporary variables vmcb_control_area and vmcb_save_area
allocated in svm_set_nested_state() are released when the function exits.
Meanwhile, svm_set_nested_state() also have vcpu mutex held to avoid
massive concurrency allocation, so we don't need to set GFP_KERNEL_ACCOUNT.

Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6f704c1037e5..d5314cb7dff4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1693,8 +1693,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	ret  = -ENOMEM;
-	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL_ACCOUNT);
-	save = kzalloc(sizeof(*save), GFP_KERNEL_ACCOUNT);
+	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL);
+	save = kzalloc(sizeof(*save), GFP_KERNEL);
 	if (!ctl || !save)
 		goto out_free;
 
-- 
2.25.1


