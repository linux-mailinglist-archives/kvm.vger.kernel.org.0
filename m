Return-Path: <kvm+bounces-43821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4068CA96938
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 14:25:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4F80189DAAF
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 12:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE0027CCE7;
	Tue, 22 Apr 2025 12:24:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4E127CB15
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 12:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745324699; cv=none; b=Y66HzoJkx9tUj0FkFsJN7GNqO47yvQeIx8jEUfAT6Hr8l6tTfPqWFA8JokHocjBggEOc7WvrJm3o8G+r1CFICcXiUyLrHZYu738e5gtJmdzY/bR1h09NUP+ZvDco7olkLRTTvIzhr3pSZ2SED3KbQCTkGDo5nybUFqIucH77cT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745324699; c=relaxed/simple;
	bh=riUUzcMOMN18qp3iJLjuh4YhZn4+N/FfbftfL+9MOHs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bim+CdAeTaiv1mDjUE0QF00mYSjL8JqgxJdHAD6axUpDmvhEY0/qV6hqiZJZ4cGi02nE63s/icHFun6/1Wtcv61Mjq/MKRBq51PAQNXLCkBjk1tfeY7APA9XoN3ZCYq1JRuNuDuzdMSPtIY54e8/p4WuWvf/95AEVMy4vZLtnq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>, xuwenjie <xuwenjie04@baidu.com>
Subject: [PATCH] KVM: SVM: move kfree() out of critical zone protected by spin_lock_irqsave
Date: Tue, 22 Apr 2025 20:08:11 +0800
Message-ID: <20250422120811.3477-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: BJHW-Mail-Ex10.internal.baidu.com (10.127.64.33) To
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2025-04-22 20:08:18:889
X-FEAS-Client-IP: 10.127.64.38
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

Although kfree is a non-sleep function, it is possible to enter a long
chain of calls probabilistically, so it looks better to move kfree out
of the critical zone.

Signed-off-by: xuwenjie <xuwenjie04@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/svm/avic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 65fd245..2520247 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -783,8 +783,9 @@ static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 		if (cur->data != pi->ir_data)
 			continue;
 		list_del(&cur->node);
+		spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 		kfree(cur);
-		break;
+		return;
 	}
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
-- 
2.9.4


