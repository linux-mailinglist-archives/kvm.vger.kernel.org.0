Return-Path: <kvm+bounces-29499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDA29AC9FF
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDD0C1C215B8
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 12:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715381ADFE3;
	Wed, 23 Oct 2024 12:23:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25F21AAE3A;
	Wed, 23 Oct 2024 12:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729686179; cv=none; b=uVGJUH/UH5ZyVojEiXPrKyAf309rTHpZTfHqEdHP6OYAf154qam0wFOz4ZeBYRpxS8PShC1vSaVqpUQQszULwIB6bMEzrq1SAl7ecDaQfdlXXwbR4zMQPmfDtfUm/rt0jpb8l30Acc9bB/gMuRiPqSJOqQ8z8EWgMAg1BaSGsvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729686179; c=relaxed/simple;
	bh=oPIp4tLcrU3CwKqjNaPLoWZgZ9z4YQZFIP1mC0dNDqU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y5bmXYpF1wYfuFh4tAQGeX/gj0zssegYbS3LTHWqUPyiEl8izFXMdjfPdEtwBKORrNLjx/s0rEYhlfLobrUT56LuLz1JHHzkWSjao8TOl+vMhw34VKfXK2WxIZYFfAiPsxUi0mAn1FCLElI9lPed+aWPEwOQNlbe3oE4k2bDEpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee76718e9e1eab-69ec0;
	Wed, 23 Oct 2024 20:19:45 +0800 (CST)
X-RM-TRANSID:2ee76718e9e1eab-69ec0
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from leadsec.example.com.localdomain (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66718e9dd58e-cd953;
	Wed, 23 Oct 2024 20:19:45 +0800 (CST)
X-RM-TRANSID:2ee66718e9dd58e-cd953
From: Liu Jing <liujing@cmss.chinamobile.com>
To: mpe@ellerman.id.au
Cc: npiggin@gmail.com,
	christophe.leroy@csgroup.eu,
	naveen@kernel.org,
	maddy@linux.ibm.com,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liu Jing <liujing@cmss.chinamobile.com>
Subject: [PATCH] KVM: Array access out of bounds
Date: Wed, 23 Oct 2024 20:01:11 +0800
Message-Id: <20241023120111.3973-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the kvmppc_mmu_book3s_64_xlate function,
r = be64_to_cpu(pteg[i+1]); i used is 16 after the last loop and adding 1 will cross the line.

Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>

diff --git a/arch/powerpc/kvm/book3s_64_mmu.c b/arch/powerpc/kvm/book3s_64_mmu.c
index 61290282fd9e..75d2b284c4b4 100644
--- a/arch/powerpc/kvm/book3s_64_mmu.c
+++ b/arch/powerpc/kvm/book3s_64_mmu.c
@@ -284,11 +284,16 @@ static int kvmppc_mmu_book3s_64_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 		second = true;
 		goto do_second;
 	}
+	if (i < 14) {
+		r = be64_to_cpu(pteg[i+1]);
+		pp = (r & HPTE_R_PP) | key;
+		if (r & HPTE_R_PP0)
+			pp |= 8;
+	} else {
+		dprintk("KVM: Index out of bounds!\n");
+		goto no_page_found;
+	}
 
-	r = be64_to_cpu(pteg[i+1]);
-	pp = (r & HPTE_R_PP) | key;
-	if (r & HPTE_R_PP0)
-		pp |= 8;
 
 	gpte->eaddr = eaddr;
 	gpte->vpage = kvmppc_mmu_book3s_64_ea_to_vp(vcpu, eaddr, data);
-- 
2.27.0




