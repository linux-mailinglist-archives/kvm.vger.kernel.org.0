Return-Path: <kvm+bounces-29608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86DDD9AE0ED
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A69691C25F5D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D351C07FE;
	Thu, 24 Oct 2024 09:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wM9sxCdb"
X-Original-To: kvm@vger.kernel.org
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1FE1C07C1;
	Thu, 24 Oct 2024 09:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729762495; cv=none; b=pHgnEkQLrzmP0iZJEj1BoRViphl77c1Oo8o3zi6bDgXTI9sfsPUPsCstX9YFxUoC3yOl+FxWkrI/ptP/1HNjuVKdwc7N9IvsFoj1R71mPjVXeNRMXGRDqjBHFfxEU2hLok5gK4jSQkdlXiKhq7rvHf6NGZtfEBnxiQWHq7ZIpXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729762495; c=relaxed/simple;
	bh=+yesL1/Tjzt5TF8Vnp9EeBw/ptoHOo1EBeTHV+wYTQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB4YSHaEt5rSmeFgN6HZHk+Gw1VR379CaQ/bHHBZYqd23cAopOv8logz2E760tnCr9xaTkXTrR/uA0fQDOwVbxcb0zeRwQlQRpk9IlauChdoP7Sl8Wdcbdn81tppPwKG0fgmvkmGeSGTFrVZD7hH00c9axH0TpGQO7/xLk9uSQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wM9sxCdb; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1729762490; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=wMMJARvMklmy7JTnx9koiikH8rF5s7OtNVXr+o/den4=;
	b=wM9sxCdbJ1sWc7pqU89ZSgKshGkpDU2+qND7ekkjUckOJXZ7lT0c667IdrvhJ4bdN8Ajjs/rINJEWYtxUw1T7PnSHHnwDfTYB8Emj4OFp78OlfBXm7ze6kDbbmilOuZZHvfbwUXFZQPfRp1dbUa7wWHPGW01YXvsqnaaaOCHhRs=
Received: from localhost.localdomain(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0WHoiyxC_1729762488 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Oct 2024 17:34:49 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Xunlei Pang <xlpang@linux.alibaba.com>
Subject: [PATCH v1: vfio: avoid unnecessary pin memory when dma map io address space 1/2]  mm: introduce vma flag VM_PGOFF_IS_PFN
Date: Thu, 24 Oct 2024 17:34:43 +0800
Message-ID: <da92b66f3ab0f51292d82ff9267ea1a15ec7e81c.1729760996.git.qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1729760996.git.qinyuntan@linux.alibaba.com>
References: <cover.1729760996.git.qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new vma flag 'VM_PGOFF_IS_PFN', which means
vma->vm_pgoff == pfn. This allows us to directly obtain pfn
through vma->vm_pgoff. No Functional Change.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Reviewed-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Reviewed-by: Xunlei Pang <xlpang@linux.alibaba.com>
---
 include/linux/mm.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ecf63d2b05825..80849b1b9aa92 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -322,6 +322,12 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
 #define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
 
+#ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS	/* vma->vm_pgoff == pfn */
+    #define VM_PGOFF_IS_PFN   BIT(62)
+#else
+    #define VM_PGOFF_IS_PFN   VM_NONE
+#endif
+
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_1	33	/* bit only usable on 64-bit architectures */
-- 
2.43.5


