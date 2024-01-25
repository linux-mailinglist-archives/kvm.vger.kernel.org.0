Return-Path: <kvm+bounces-6989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 721C283BC10
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2873B231D3
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 08:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDA81B944;
	Thu, 25 Jan 2024 08:34:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E14E54C;
	Thu, 25 Jan 2024 08:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706171644; cv=none; b=EnxVKoAtlDqG7QHko+DpZTlnMzxR/cGqfM6zJHHR13jOB44dOAFV8zDhQOiBaUOaPyGoGZeEDXgqlrWk7HSGPacW9eLPqxX8/IZTY+To/43crdJ7cWCoz5iEojeK+/ih87a57jyY89Vstb93Is4deKdCBjHu+DpbF2iVHhHQpjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706171644; c=relaxed/simple;
	bh=nu2X+w6CoHZuxTQ+GtRpCRPDCFCdqjvwG2j7jgKiTpU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bCeHpwyMeXErr1JF0VXi5dZD+qaKeYWmI5ZzHYlWvDpQJmWb2SSeZLtnwATOkUCkTRB9A7KkKO6gZ6mTPGu6yNGnKmsGGlKa7lbXzc9xjDiagBHOrZhyHiuH40xoR31hmhvznu3etj3Xjj60jASWEi9MHOctOw1ons+a/9LmAi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8121b05ff4ae4a279be3bc3a10dff9e7-20240125
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:61e0fa9d-4ed9-49a3-a7a2-54b5d96d874b,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.35,REQID:61e0fa9d-4ed9-49a3-a7a2-54b5d96d874b,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:5d391d7,CLOUDID:312e3e83-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:2401251633590W14PIM2,BulkQuantity:0,Recheck:0,SF:66|38|24|17|19|44|1
	02,TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 8121b05ff4ae4a279be3bc3a10dff9e7-20240125
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1342124197; Thu, 25 Jan 2024 16:33:57 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 92147E000EB9;
	Thu, 25 Jan 2024 16:33:57 +0800 (CST)
X-ns-mid: postfix-65B21CF5-371084490
Received: from kernel.. (unknown [172.20.15.234])
	by mail.kylinos.cn (NSMail) with ESMTPA id E9161E000EB9;
	Thu, 25 Jan 2024 16:33:49 +0800 (CST)
From: Kunwu Chan <chentao@kylinos.cn>
To: mpe@ellerman.id.au,
	npiggin@gmail.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH v2] KVM: PPC: code cleanup for kvmppc_book3s_irqprio_deliver
Date: Thu, 25 Jan 2024 16:33:48 +0800
Message-Id: <20240125083348.533883-1-chentao@kylinos.cn>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

This part was commented from commit 2f4cf5e42d13 ("Add book3s.c")
in about 14 years before.
If there are no plans to enable this part code in the future,
we can remove this dead code.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
Change in v2:
    - Remove redundant blank line
---
 arch/powerpc/kvm/book3s.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 8acec144120e..be9fbfbf62f7 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -360,10 +360,6 @@ static int kvmppc_book3s_irqprio_deliver(struct kvm_=
vcpu *vcpu,
 		break;
 	}
=20
-#if 0
-	printk(KERN_INFO "Deliver interrupt 0x%x? %x\n", vec, deliver);
-#endif
-
 	if (deliver)
 		kvmppc_inject_interrupt(vcpu, vec, 0);
=20
--=20
2.39.2


