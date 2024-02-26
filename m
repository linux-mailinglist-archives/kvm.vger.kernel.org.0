Return-Path: <kvm+bounces-9943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A16F4867C1C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D956B2ADCF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1497812C81B;
	Mon, 26 Feb 2024 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vQ5v3SWJ"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555C612C55D;
	Mon, 26 Feb 2024 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708963284; cv=none; b=h1p4GFz8PrnnR9KwleQ2DuV50aSqZpPpHTDqyEqI+CUPSm0hnD8IGFD22Xwq1OKu2mhkpxbirKqqE03Vhf6eraM0kYbnnKKIPl6S2TJCfBoQ8IlpMsjTYJFXyA6eje6ZZ6YLuGwxBKR6aww+yPpOkC0Y9SWcf+H0GTpsC3cmKkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708963284; c=relaxed/simple;
	bh=dMr2bgmwiVOt4TcUYH1qJC2vLb4zsG+TYAOHrr5w6YA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Hb6CDIDlmGzmFCZGzMSzFf3xPvtccx40u4wxQ1kTd2sKlJBr2ALObaSIrP8Bw6ZFqp9ix8VxrtA48+VRSP1zQcAMdZDYuURrhrqUdVqmbd1E8NZZQoWl9UCJDXZx91UjOh5Mxdznz9HSoI+E2e35+gAkCBDklCVnINNATXlGAAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vQ5v3SWJ; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708963277; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=uO744AgFJT3omawn12Dq7uRsOiSEoPU3Y3gdcHNc6O4=;
	b=vQ5v3SWJWiveFSM6sRgM1wiJ7b+QcsZOklVJwqrHFyw7Sueu4h7VQ1KksBE28OS6aPT98tgX5ARgSQ0W1KpLhlQ68q5EO5RXAxrBj1lkLrWpahzDscjYo5xJjMwmHvxdXJ/CDuSjL8zJoVyaKeyj8ZGzjHhKipxmrxFzP4MS2ZU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=ethan.xys@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W1K5SSG_1708963266;
Received: from localhost(mailfrom:ethan.xys@linux.alibaba.com fp:SMTPD_---0W1K5SSG_1708963266)
          by smtp.aliyun-inc.com;
          Tue, 27 Feb 2024 00:01:17 +0800
From: Yisheng Xie <ethan.xys@linux.alibaba.com>
To: alex.williamson@redhat.com
Cc: akpm@linux-foundation.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ethan.xys@linux.alibaba.com
Subject: [PATCH] vfio/type1: unpin PageReserved page
Date: Tue, 27 Feb 2024 00:01:06 +0800
Message-Id: <20240226160106.24222-1-ethan.xys@linux.alibaba.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We meet a warning as following:
 WARNING: CPU: 99 PID: 1766859 at mm/gup.c:209 try_grab_page.part.0+0xe8/0x1b0
 CPU: 99 PID: 1766859 Comm: qemu-kvm Kdump: loaded Tainted: GOE  5.10.134-008.2.x86_64 #1
 Hardware name: Foxconn AliServer-Thor-04-12U-v2/Thunder2, BIOS 1.0.PL.FC.P.031.00 05/18/2022
 RIP: 0010:try_grab_page.part.0+0xe8/0x1b0
 Code: b9 00 04 00 00 83 e6 01 74 ca 48 8b 32 b9 00 04 00 00 f7 c6 00 00 01 00 74 ba eb 91 8b 57 34 48 89 f8 85 d2 0f 8f 48 ff ff ff <0f> 0b 31 c0 c3 48 89 fa 48 8b 0a f7 c1 00 00 01 00 0f 85 5c ff ff
 RSP: 0018:ffffc900b1a63b98 EFLAGS: 00010282
 RAX: ffffea00000e4580 RBX: 0000000000052202 RCX: ffffea00000e4580
 RDX: 0000000080000001 RSI: 0000000000052202 RDI: ffffea00000e4580
 RBP: ffff88efa5d3d860 R08: 0000000000000000 R09: 0000000000000002
 R10: 0000000000000008 R11: ffff89403fff7000 R12: ffff88f589165818
 R13: 00007f1320600000 R14: ffffea0181296ca8 R15: ffffea00000e4580
 FS:  00007f1324f93e00(0000) GS:ffff893ebfb80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f1321694070 CR3: 0000006046014004 CR4: 00000000007726e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  follow_page_pte+0x64b/0x800
  __get_user_pages+0x228/0x560
  __gup_longterm_locked+0xa0/0x2f0
  vaddr_get_pfns+0x67/0x100 [vfio_iommu_type1]
  vfio_pin_pages_remote+0x30b/0x460 [vfio_iommu_type1]
  vfio_pin_map_dma+0xd4/0x2e0 [vfio_iommu_type1]
  vfio_dma_do_map+0x21e/0x340 [vfio_iommu_type1]
  vfio_iommu_type1_ioctl+0xdd/0x170 [vfio_iommu_type1]
  ? __fget_files+0x79/0xb0
  ksys_ioctl+0x7b/0xb0
  ? ksys_write+0xc4/0xe0
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x2d/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

After add dumppage, it shows that it is a PageReserved page(e.g. zero page),
whoes refcount is just overflow:
 page:00000000b0504535 refcount:-2147483647 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3916
 flags: 0xffffc000001002(referenced|reserved)
 raw: 00ffffc000001002 ffffea00000e4588 ffffea00000e4588 0000000000000000
 raw: 0000000000000000 0000000000000000 80000001ffffffff 0000000000000000

gup will _pin_ a page which is PageReserved, however, put_pfn in vfio will
skip unpin page which is PageReserved. So use pfn_valid in put_pfn
instead of !is_invalid_reserved_pfn to unpin PageReserved page.

Signed-off-by: Yisheng Xie <ethan.xys@linux.alibaba.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b2854d7939ce..12775bab27ee 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -461,7 +461,7 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
 
 static int put_pfn(unsigned long pfn, int prot)
 {
-	if (!is_invalid_reserved_pfn(pfn)) {
+	if (pfn_valid(pfn)) {
 		struct page *page = pfn_to_page(pfn);
 
 		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
-- 
2.39.1


