Return-Path: <kvm+bounces-55325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD9EB2FE8F
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 17:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF2C5642787
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E9E296BDB;
	Thu, 21 Aug 2025 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONYFbl0e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC80296BAE
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755789803; cv=none; b=M4jNk/qyJV3X7qNRj1IkD6kvLynjPK7kzzkxfOnhTWY03ZFPchey92EZCoM9ztT5X+l6rmWz2peRp9jG9Eo2NIIMDKaMLck85Zz2zWZf5K9FTDHYIHQFxYLdV0sMnAe2+XpIdiEUfLayAbF0ruymQJN6C4AuBI1sdrYeNKfQkYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755789803; c=relaxed/simple;
	bh=phOEOrcbb6XWP/f68JJcZtVW5Y1qLoFhmz5f49cY/fc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lX3EY8RwNdPU0Xf5xW1Z2ACnpGcpA89mQj4G3Y64Dlxi7To5qCNpHXmaYI42l1E/fAnELW3ly2yE80DUviequYvOX0i14ZWRmYCJ/gCYPG4PbNEFUGhmwDwtHZqxSSpADjQ73fAU2zne4DGeFLA7aOce60KjKjjBhrLhhmyJ0+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ONYFbl0e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755789800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Pp2QMqSmglzTl9N5ktKXe1fiz3QOWjTH6/o2x2dsayc=;
	b=ONYFbl0eIr03dPdTdjI00XhGu+tUVwBv4jNUVh5fMqW2mRKU5vtqwUSJRqyPxlVjVhSzeZ
	Kxk5sh23XggI3IN77ctGB5Zc1URjVydJXLEjvOWNt4kYk3ObMYdnlEhHKeAKfHdeXjR0IP
	t1FpYRlqTBwOmj5Jx8A4cuO+WZEx3xA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-miNiIWGfMPeJx_avnRzFLA-1; Thu,
 21 Aug 2025 11:23:17 -0400
X-MC-Unique: miNiIWGfMPeJx_avnRzFLA-1
X-Mimecast-MFC-AGG-ID: miNiIWGfMPeJx_avnRzFLA_1755789795
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7240019560A5;
	Thu, 21 Aug 2025 15:23:15 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.226.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD86919560B0;
	Thu, 21 Aug 2025 15:23:10 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	kvm@vger.kernel.org
Cc: Peter Xu <peterx@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: Fix access to unavailable adapter indicator pages during postcopy
Date: Thu, 21 Aug 2025 17:23:09 +0200
Message-ID: <20250821152309.847187-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

When you run a KVM guest with vhost-net and migrate that guest to
another host, and you immediately enable postcopy after starting the
migration, there is a big chance that the network connection of the
guest won't work anymore on the destination side after the migration.

With a debug kernel v6.16.0, there is also a call trace that looks
like this:

 FAULT_FLAG_ALLOW_RETRY missing 881
 CPU: 6 UID: 0 PID: 549 Comm: kworker/6:2 Kdump: loaded Not tainted 6.16.0 #56 NONE
 Hardware name: IBM 3931 LA1 400 (LPAR)
 Workqueue: events irqfd_inject [kvm]
 Call Trace:
  [<00003173cbecc634>] dump_stack_lvl+0x104/0x168
  [<00003173cca69588>] handle_userfault+0xde8/0x1310
  [<00003173cc756f0c>] handle_pte_fault+0x4fc/0x760
  [<00003173cc759212>] __handle_mm_fault+0x452/0xa00
  [<00003173cc7599ba>] handle_mm_fault+0x1fa/0x6a0
  [<00003173cc73409a>] __get_user_pages+0x4aa/0xba0
  [<00003173cc7349e8>] get_user_pages_remote+0x258/0x770
  [<000031734be6f052>] get_map_page+0xe2/0x190 [kvm]
  [<000031734be6f910>] adapter_indicators_set+0x50/0x4a0 [kvm]
  [<000031734be7f674>] set_adapter_int+0xc4/0x170 [kvm]
  [<000031734be2f268>] kvm_set_irq+0x228/0x3f0 [kvm]
  [<000031734be27000>] irqfd_inject+0xd0/0x150 [kvm]
  [<00003173cc00c9ec>] process_one_work+0x87c/0x1490
  [<00003173cc00dda6>] worker_thread+0x7a6/0x1010
  [<00003173cc02dc36>] kthread+0x3b6/0x710
  [<00003173cbed2f0c>] __ret_from_fork+0xdc/0x7f0
  [<00003173cdd737ca>] ret_from_fork+0xa/0x30
 3 locks held by kworker/6:2/549:
  #0: 00000000800bc958 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x7ee/0x1490
  #1: 000030f3d527fbd0 ((work_completion)(&irqfd->inject)){+.+.}-{0:0}, at: process_one_work+0x81c/0x1490
  #2: 00000000f99862b0 (&mm->mmap_lock){++++}-{3:3}, at: get_map_page+0xa8/0x190 [kvm]

The "FAULT_FLAG_ALLOW_RETRY missing" indicates that handle_userfaultfd()
saw a page fault request without ALLOW_RETRY flag set, hence userfaultfd
cannot remotely resolve it (because the caller was asking for an immediate
resolution, aka, FAULT_FLAG_NOWAIT, while remote faults can take time).
With that, get_map_page() failed and the irq was lost.

We should not be strictly in an atomic environment here and the worker
should be sleepable (the call is done during an ioctl from userspace),
so we can allow adapter_indicators_set() to just sleep waiting for the
remote fault instead.

Link: https://issues.redhat.com/browse/RHEL-42486
Signed-off-by: Peter Xu <peterx@redhat.com>
[thuth: Assembled patch description and fixed some cosmetical issues]
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Note: Instructions for reproducing the bug can be found in the ticket here:
 https://issues.redhat.com/browse/RHEL-42486?focusedId=26661116#comment-26661116

 arch/s390/kvm/interrupt.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 60c360c18690f..dcce826ae9875 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2777,12 +2777,19 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
 
 static struct page *get_map_page(struct kvm *kvm, u64 uaddr)
 {
+	struct mm_struct *mm = kvm->mm;
 	struct page *page = NULL;
+	int locked = 1;
+
+	if (mmget_not_zero(mm)) {
+		mmap_read_lock(mm);
+		get_user_pages_remote(mm, uaddr, 1, FOLL_WRITE,
+				      &page, &locked);
+		if (locked)
+			mmap_read_unlock(mm);
+		mmput(mm);
+	}
 
-	mmap_read_lock(kvm->mm);
-	get_user_pages_remote(kvm->mm, uaddr, 1, FOLL_WRITE,
-			      &page, NULL);
-	mmap_read_unlock(kvm->mm);
 	return page;
 }
 
-- 
2.50.1


