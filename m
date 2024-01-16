Return-Path: <kvm+bounces-6329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2363F82EC9D
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 11:11:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6003B22478
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 10:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4020413AC2;
	Tue, 16 Jan 2024 10:11:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69188134BE;
	Tue, 16 Jan 2024 10:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a22905cd170d4ee9805d32e1eec18322-20240116
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:16592e3b-7f91-4805-b226-df76d2b3ec8f,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.35,REQID:16592e3b-7f91-4805-b226-df76d2b3ec8f,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:5d391d7,CLOUDID:17af677f-4f93-4875-95e7-8c66ea833d57,B
	ulkID:240116180031ZL8M7VE6,BulkQuantity:0,Recheck:0,SF:19|38|24|100|101|74
	|66|17|42|102,TC:nil,Content:0,EDM:5,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_SNR
X-UUID: a22905cd170d4ee9805d32e1eec18322-20240116
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1885945740; Tue, 16 Jan 2024 18:00:29 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 5C6A3E000EB9;
	Tue, 16 Jan 2024 18:00:29 +0800 (CST)
X-ns-mid: postfix-65A653BD-152262411
Received: from kernel.. (unknown [172.20.15.234])
	by mail.kylinos.cn (NSMail) with ESMTPA id 43C6EE000EB9;
	Tue, 16 Jan 2024 18:00:27 +0800 (CST)
From: Kunwu Chan <chentao@kylinos.cn>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH] KVM: x86/mmu: Use KMEM_CACHE instead of kmem_cache_create()
Date: Tue, 16 Jan 2024 18:00:25 +0800
Message-Id: <20240116100025.95702-1-chentao@kylinos.cn>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 arch/x86/kvm/mmu/mmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d59e3ba5d646..5f0d8148cf6e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6997,9 +6997,7 @@ int kvm_mmu_vendor_module_init(void)
=20
 	kvm_mmu_reset_all_pte_masks();
=20
-	pte_list_desc_cache =3D kmem_cache_create("pte_list_desc",
-					    sizeof(struct pte_list_desc),
-					    0, SLAB_ACCOUNT, NULL);
+	pte_list_desc_cache =3D KMEM_CACHE(pte_list_desc, SLAB_ACCOUNT);
 	if (!pte_list_desc_cache)
 		goto out;
=20
--=20
2.39.2


