Return-Path: <kvm+bounces-57185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 12000B5124A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43FE37A5761
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58736313287;
	Wed, 10 Sep 2025 09:17:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cmccmta1.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561DD3112D8;
	Wed, 10 Sep 2025 09:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757495877; cv=none; b=G0h9SH4qJmz/OuFGH3NBnVnWTTWV/fRqIczOyI8C5f/Z37U+Ve07e2BLmGqMrMJH9NMuydlu0oOc0KYWyeKtcGonxJV85q86E95rjrj40suRI5nfh5kcrf5kjtgtDExczmhTNpqf1hu4znVo3k44cLgT2tfAcZiDIHlB5qDNEiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757495877; c=relaxed/simple;
	bh=RLLm9pnVH37H7xjf5OXNxYNi/k874wPLIP1MoO6qGR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q1eUGOD80lwFgwhxaAz/XOMVvaW1Armc9p5Rzg4C3YOApV8YF1xDzQ/G1gO6/hB8k0vcPa7c6fyOTW0piQWtwVRpBLy9lbaMEXue+twKJV0tesSBdK4JbTTZBbpg3aGivH2n8DwqQLw+IFOqauz0sBo5AjPuvME+EV75efu5xaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee468c14237dd6-58e69;
	Wed, 10 Sep 2025 17:17:47 +0800 (CST)
X-RM-TRANSID:2ee468c14237dd6-58e69
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from Z04181454368174 (unknown[10.55.1.71])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee468c14238228-95f8e;
	Wed, 10 Sep 2025 17:17:47 +0800 (CST)
X-RM-TRANSID:2ee468c14238228-95f8e
From: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
To: mst@redhat.com
Cc: jasowang@redhat.com,
	eperezma@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: [PATCH] vhost: vringh: Modify the return value check
Date: Wed, 10 Sep 2025 17:17:38 +0800
Message-ID: <20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

The return value of copy_from_iter and copy_to_iter can't be negative,
check whether the copied lengths are equal.

Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
---
 drivers/vhost/vringh.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 9f27c3f6091b..0c8a17cbb22e 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1115,6 +1115,7 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
+		size_t size;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
 				      len - total_translated, &translated,
@@ -1132,9 +1133,9 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 				      translated);
 		}
 
-		ret = copy_from_iter(dst, translated, &iter);
-		if (ret < 0)
-			return ret;
+		size = copy_from_iter(dst, translated, &iter);
+		if (size != translated)
+			return -EFAULT;
 
 		src += translated;
 		dst += translated;
-- 
2.33.0




