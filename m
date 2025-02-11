Return-Path: <kvm+bounces-37777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F01E1A30195
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:40:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92708167BB6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDEBA1CEEB2;
	Tue, 11 Feb 2025 02:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="EAAe0Ss3"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.8])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4D026BD92;
	Tue, 11 Feb 2025 02:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739241601; cv=none; b=fokJnVjIY2xUSSXovJsRc2z7+dggdR/QJoBKjJ67pIAdMPLUwpIrCUv9qZk7y3LBcNbJomfv/S4wn6h9F0dnuqIjA07L94ZIMAqJF9+C6Y8CF5hUYO4wXhywJWkiiPNct535yBC9X8bE4bsvCPpBE08L8h1Tkvkw5u6p2Rd3KBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739241601; c=relaxed/simple;
	bh=y+ztxwhEcdpLaeJJ6Prmki4HGBmqn+jbQWGvXTY0ARA=;
	h=From:To:Cc:Subject:Date:Message-Id; b=p0cf0wLEud+WKhaxddERnGIOtgGgNVnc936GsV8JVeCR1xqb+Z1LsTBM0RpE3n3OFNzGzl5dqqJDsTVMKOgdc9pggjj0/Dqhywm3ATDXsxXDOlB51TMEeezLQgWGSGNkO56i0YxSnOvIARXOSi7wk+YyHGUOAdGMil71aHSjwyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=EAAe0Ss3; arc=none smtp.client-ip=220.197.31.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-Id; bh=0iKDFXKmakrxlwTvyT
	XBK7m38OSdvEOg0wa8XmraGSo=; b=EAAe0Ss3Y/wFBXuLqiGmhnzPM8PhjKBNiB
	Tj88sHLJXFydVLhshTomuq3ZrZliUO9hKjp2LFlgxODmbr9Z7Ao1wb4S6PRze2/7
	feZK1eGyZM8Ma4mZmX8CyBzhEVeGzdehK3D45YgQAoUaKG508gMyCMUphnHKp0QN
	U00/Kr20U=
Received: from hg-OptiPlex-7040.hygon.cn (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDn77rRt6pnZ85rAw--.31934S2;
	Tue, 11 Feb 2025 10:37:05 +0800 (CST)
From: yangge1116@126.com
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	seanjc@google.com,
	21cnbao@gmail.com,
	david@redhat.com,
	baolin.wang@linux.alibaba.com,
	thomas.lendacky@amd.com,
	liuzixing@hygon.cn,
	Ge Yang <yangge1116@126.com>
Subject: [PATCH V4] KVM: SEV: fix wrong pinning of pages
Date: Tue, 11 Feb 2025 10:37:03 +0800
Message-Id: <1739241423-14326-1-git-send-email-yangge1116@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID:_____wDn77rRt6pnZ85rAw--.31934S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxur4UCrWrJFWUAw4xZr1UZFb_yoWrGF15pF
	4rGws0yr13KrZFvryIqrWkursrZ3y8Kw4jkryIywn5uFnxtry0vr4Iqr17try5A3y8WF98
	tF4DGw4rZw4DZa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRoGQDUUUUU=
X-CM-SenderInfo: 51dqwwjhrrila6rslhhfrp/1tbifh3wG2eqsNCEaAAAsJ
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Ge Yang <yangge1116@126.com>

In the sev_mem_enc_register_region() function, we need to call
sev_pin_memory() to pin memory for the long term. However, when
calling sev_pin_memory(), the FOLL_LONGTERM flag is not passed, causing
the allocated pages not to be migrated out of MIGRATE_CMA/ZONE_MOVABLE,
violating these mechanisms to avoid fragmentation with unmovable pages,
for example making CMA allocations fail.

To address the aforementioned problem, we should add the FOLL_LONGTERM
flag when calling sev_pin_memory() within the sev_mem_enc_register_region()
function.

Signed-off-by: Ge Yang <yangge1116@126.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---

V4:
- adjust the code format suggested by Tom

V3:
- the fix only needed for sev_mem_enc_register_region()

V2:
- update code and commit message suggested by David

 arch/x86/kvm/svm/sev.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a2a794c..90ad846 100644
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
 
@@ -1250,7 +1250,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		if (IS_ERR(src_p))
 			return PTR_ERR(src_p);
 
-		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
+		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, FOLL_WRITE);
 		if (IS_ERR(dst_p)) {
 			sev_unpin_memory(kvm, src_p, n);
 			return PTR_ERR(dst_p);
@@ -1316,7 +1316,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
+	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, FOLL_WRITE);
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
@@ -1798,7 +1798,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 1);
+				    PAGE_SIZE, &n, FOLL_WRITE);
 	if (IS_ERR(guest_page)) {
 		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
@@ -2696,7 +2696,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 		return -ENOMEM;
 
 	mutex_lock(&kvm->lock);
-	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
+	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
+				       FOLL_WRITE | FOLL_LONGTERM);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
 		mutex_unlock(&kvm->lock);
-- 
2.7.4


