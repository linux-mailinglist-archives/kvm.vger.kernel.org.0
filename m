Return-Path: <kvm+bounces-35214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 127F8A0A136
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 07:16:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F50C16B14A
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 06:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E677165EFC;
	Sat, 11 Jan 2025 06:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="neoDfF7D"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A29129A78;
	Sat, 11 Jan 2025 06:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736576196; cv=none; b=taR7z8o9PGGvShJj9Sjkl9gSaX35qHkPPfISYyYGzAuKhZkCTZJ1DOFj9AfIimVEw0Sh/6g/pWGO+b2iL8mma2sKgalqLDTgZD8sTi+gKeAq/jLn9bBZYL55YKoN/x3XPwXr8NUDeEoBD8fQuEjVR5sCZ8L63Zn3JVn6vmIRBOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736576196; c=relaxed/simple;
	bh=oukHhCJXgCfigZTwcqagCTWG5Ht5Fy2imAVp+txHc5A=;
	h=From:To:Cc:Subject:Date:Message-Id; b=PTPsts9+IaRN3IE61rSx/m7t65p/U9MiryFvo1auNSdicffks+GUbAjMv5Stp8BlLCwWyliPcVmr0oR5IaqYZlymSDSF1YSbWWo2LHBr9lcZXIp3DqTeJelJpR2yQpkmOzeUYHU3moBr9f1Ybm+jibjkhul1TAM2UG6qk7WzPA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=neoDfF7D; arc=none smtp.client-ip=117.135.210.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-Id; bh=CFDdJY+ndV3xpovE6P
	Z/Y7Xc2rqn9DrT7VisN6kFqEs=; b=neoDfF7DIGLAd+qhGACYfjAvboXR+TYWAT
	XZZqQrrcfzHzpQo/T+Y8jvHvd5ASL4G3ZuimD/ZkSk5M46qiaVgNKAjVqilYl6qt
	A2P1RcuyHl5vcSSAi/Ap1CImT/eB3FxYYQ435fHkizNXMHNrj9fjjvxyNf4ffwf0
	Q4iQBOI7U=
Received: from hg-OptiPlex-7040.hygon.cn (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3j+57DIJnMOx3Aw--.32455S2;
	Sat, 11 Jan 2025 14:15:23 +0800 (CST)
From: yangge1116@126.com
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	seanjc@google.com,
	21cnbao@gmail.com,
	david@redhat.com,
	baolin.wang@linux.alibaba.com,
	liuzixing@hygon.cn,
	yangge <yangge1116@126.com>
Subject: [PATCH V3] KVM: SEV: fix wrong pinning of pages
Date: Sat, 11 Jan 2025 14:15:22 +0800
Message-Id: <1736576122-9818-1-git-send-email-yangge1116@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID:_____wD3j+57DIJnMOx3Aw--.32455S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxur4UCry5Kw4fJw15KFykZrb_yoWrJF4kpF
	4rWws0yr13KrZFvryxtrWkursrZ3yrKr4jkFyIywn5uFnrtryIvr4Iqr17try5A3y8WF98
	tF4DGw4rZw4DZa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRY-erUUUUU=
X-CM-SenderInfo: 51dqwwjhrrila6rslhhfrp/1tbiih3RG2eCCVUhfwAAs6
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: yangge <yangge1116@126.com>

In the sev_mem_enc_register_region() function, we need to call
sev_pin_memory() to pin memory for the long term. However, when
calling sev_pin_memory(), the FOLL_LONGTERM flag is not passed, causing
the allocated pages not to be migrated out of MIGRATE_CMA/ZONE_MOVABLE,
violating these mechanisms to avoid fragmentation with unmovable pages,
for example making CMA allocations fail.

To address the aforementioned problem, we should add the FOLL_LONGTERM
flag when calling sev_pin_memory() within the sev_mem_enc_register_region()
function.

Signed-off-by: yangge <yangge1116@126.com>
---

V3:
- the fix only needed for sev_mem_enc_register_region()

V2:
- update code and commit message suggested by David

 arch/x86/kvm/svm/sev.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd07..04a125c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -622,7 +622,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 				    unsigned long ulen, unsigned long *n,
-				    int write)
+				    int flags)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	unsigned long npages, size;
@@ -663,7 +663,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 		return ERR_PTR(-ENOMEM);
 
 	/* Pin the user virtual address. */
-	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
+	npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		ret = -ENOMEM;
@@ -751,7 +751,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
-	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
+	inpages = sev_pin_memory(kvm, vaddr, size, &npages, FOLL_WRITE);
 	if (IS_ERR(inpages))
 		return PTR_ERR(inpages);
 
@@ -1250,7 +1250,8 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		if (IS_ERR(src_p))
 			return PTR_ERR(src_p);
 
-		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
+		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n,
+					FOLL_WRITE);
 		if (IS_ERR(dst_p)) {
 			sev_unpin_memory(kvm, src_p, n);
 			return PTR_ERR(dst_p);
@@ -1316,7 +1317,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
+	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, FOLL_WRITE);
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
@@ -1798,7 +1799,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 1);
+				    PAGE_SIZE, &n, FOLL_WRITE);
 	if (IS_ERR(guest_page)) {
 		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
@@ -2696,7 +2697,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 		return -ENOMEM;
 
 	mutex_lock(&kvm->lock);
-	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
+	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
+				FOLL_WRITE | FOLL_LONGTERM);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
 		mutex_unlock(&kvm->lock);
-- 
2.7.4


