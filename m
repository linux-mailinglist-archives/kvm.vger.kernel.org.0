Return-Path: <kvm+bounces-35040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D04F2A08FA6
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABB321889917
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDCAB20ADFF;
	Fri, 10 Jan 2025 11:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="Pbs3yoEc"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E911ACEDF;
	Fri, 10 Jan 2025 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736509551; cv=none; b=UxmUwuSvz83BQzL4HRjxlK23A8HvvbAjW9HhNwEeJVsc9mfQR5LVPWVhaaWuwGDITXKC+6neVIgKZPxd/vNuBEPb14hBHCM92eMuF8tjgn/kmfTRNxsFmIaVdfEA4dMum957rDWYdY2goWGUNjVNwbkUsnZBwbntUdvJTwFznno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736509551; c=relaxed/simple;
	bh=sbZtKrFrM0hCQvwTHy47LPoXiatxsRy9BCY0hXjZHqc=;
	h=From:To:Cc:Subject:Date:Message-Id; b=D2U1of8geLXCjjueGRhU7TuAVkVsQlArUmnu3pxpL5ZRz9oRXzG90ZVr/KXlgdMJFv+7R0/LUWApXrKCibu7f7gW3oQFuGYQypBVZz25t45CRUVVMKLCJPNl4SLm1O+2k3dRj6XEddOJrwSIk31xvhvoukB8feZsKi9p2p5qSGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=Pbs3yoEc; arc=none smtp.client-ip=220.197.31.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-Id; bh=kbqVq+CCpwES02oY8e
	jm+oyD8X8RDnfon9nrvS5wzUQ=; b=Pbs3yoEc3wsyp+RcTC27qwvKLj4Ws+pG6S
	ah6juIO0RfGgVOEAO9idd8U4g2pRB9hLx9MXkxLBB7+xVLWe9kXWSDXmCPo3hJlu
	S1deAPADU2/GMvEntSa+HmzGHfh4QH9lWhCF5f1QrTkSt45wp28tF2fXKf0mcG7v
	kLKLkXwrg=
Received: from hg-OptiPlex-7040.hygon.cn (unknown [112.64.138.194])
	by gzsmtp3 (Coremail) with SMTP id pykvCgD372TCB4Fns5RyDg--.39341S2;
	Fri, 10 Jan 2025 19:42:59 +0800 (CST)
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
Subject: [PATCH V2] KVM: SEV: fix wrong pinning of pages
Date: Fri, 10 Jan 2025 19:42:56 +0800
Message-Id: <1736509376-30746-1-git-send-email-yangge1116@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID:pykvCgD372TCB4Fns5RyDg--.39341S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar47KrWUWr47KF15JF43KFg_yoW8XFyUpa
	1kGwsayFW3X3sFyF97taykur17ua4kWr47AFn3Z3s8uwn8KFySqr4Ivw1Utw4kZryruFnY
	vr4rGrn8ZF4DZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR0dgtUUUUU=
X-CM-SenderInfo: 51dqwwjhrrila6rslhhfrp/1tbiOhLQG2eA9JTIIQAAsN
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: yangge <yangge1116@126.com>

When pin_user_pages_fast() pins SEV guest memory without the
FOLL_LONGTERM flag, the pages will not get migrated out of MIGRATE_CMA/
ZONE_MOVABLE, violating these mechanisms to avoid fragmentation with
unmovable pages, for example making CMA allocations fail.

To address the aforementioned problem, we propose adding the
FOLL_LONGTERM flag to the pin_user_pages_fast() function.

Signed-off-by: yangge <yangge1116@126.com>
---

V2:
- update code and commit message suggested by David

 arch/x86/kvm/svm/sev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd07..96f3b8e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -630,6 +630,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	unsigned long locked, lock_limit;
 	struct page **pages;
 	unsigned long first, last;
+	unsigned int flags = FOLL_LONGTERM;
 	int ret;
 
 	lockdep_assert_held(&kvm->lock);
@@ -662,8 +663,10 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
+	flags |= write ? FOLL_WRITE : 0;
+
 	/* Pin the user virtual address. */
-	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
+	npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		ret = -ENOMEM;
-- 
2.7.4


