Return-Path: <kvm+bounces-51062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA40AED583
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC38D16D156
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB6D221F0A;
	Mon, 30 Jun 2025 07:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="b1CkWVOj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF09221F12
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 07:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751268391; cv=none; b=H5Wx+62LiPl5rZia64G2R6QW9ih03RGrWcm/Lr/xhJ9Uo6pn63XuKD93iHW99JFyPUkZz6Sa5guH1Mj4AWiWJRTfz0vBiY7RNd40HYXL54X87/lrEAqQDdA4sUk/71WHIuDWiNpWPuqa+/deIdCeGw4GFzmqOuMHGkdP1w1bN7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751268391; c=relaxed/simple;
	bh=TLqFs73Rs07kvj6q6zHaiOwcjlhs5jMzOSpM5JzlbZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRCq3Oe+ZvI++ENkYFsPzhRUAZhuYEWHMOsk5jSW0+/Jk+mGJS/71rYNtCQAPMz1clnUJmaofI9+jC2Gj+d8iCksL6y2zYER7HWYczYHgoudUehPU1PlsXyMMYEepTuFJkRjtxQzHIF8vPccpoRjxYrzvq5rWI0eTuXpA40IeA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=b1CkWVOj; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23633a6ac50so50829275ad.2
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 00:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751268389; x=1751873189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gL8Na4RbOeb+mTd/Y2il+QsiGyvEE+fewWwpBjRUgYM=;
        b=b1CkWVOjwJstnDkRN7pIgbg08Ml4IVNzxRjj4IEWq+ylDq/v7pMzQK2bJniMPNmck5
         mq03sYLX43ZpRJOzY7GZBoYtoFZSx9ITZXAiwa/fVS/N1pVdMJZdzBdtJAc81BFAnyr0
         sde4llCtWC657DuFIQKmtrt3xCSCRbQpB+cz/87YHwcPgx459hIL06nb11DscmBHRrWW
         zygXmSFac/Wpl6Y1HfJwI4evAcftAc/0ealbo3RJIdCcV+17Z/TeeJ2o3b1JOKBVTa08
         xVTfT3iSF2R0T0rzsRX6orA3Oj6lXbAVhmXfr4cX7kFeYJ/hRmz0I5mmw1ez/CxBFUpt
         dn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751268389; x=1751873189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gL8Na4RbOeb+mTd/Y2il+QsiGyvEE+fewWwpBjRUgYM=;
        b=hv+JJsNvz0NUyQ9Z181FybZir9svH7AUR0MdyLrRTK387u/2UgpCp0wcjL1O6hhIw8
         XsnmVUPuNeFoGgcqN3Jqoy3GhzjDfPFjXULqGPvsTpl8FpFFtEpa+lqN8VBVSFdh86r+
         j8y63WnIINhXhJnjK17ZoRFwOvFCJpOjUaEImPVEJw7t3riewPk0InwYg3k2xXvVM+cW
         18yn/VJ+R0hQ3T9wYzI33BHirWJCjWY605ZWrcymtLtnA7hnzwovEfnl87Bcl8ffWZlX
         1iJx5mxNZQT0s4JJqEK+MMct57DmQiDTt2qD1LF/C5d8zgzxWBz7SGxi+C3hlC4BW9ja
         e8UQ==
X-Gm-Message-State: AOJu0YwiMO91uEZzGe6M1QmNxEm7W4EF+Rd1b5dGNWdRDotu2vfLh84v
	kWu5qjeYwibWPg0LGJ0ia3cS6yJOen/97ccn8pxKerG2A/io0i/qMczqstduPLScEoI=
X-Gm-Gg: ASbGnctTWWv/SdbLzDI13YS6LLXyPG+aGQNyHJY+bkVTYCHJLCIMNRQNhQSrV5l96gu
	+8yGmncfALbAhtOO74RVt4MEODkfRpUTre+q+vD4odcKK49pKJ+7SzKs9SVLsx4TaKFGTfDoZt4
	4euD6G4lq2HiATsoBRd/LOCalo+zPdFaQB0VMjQ1Dyouvq27rRZW/VVwbNm5+zi5Z6A92K1OsQz
	SxG4NaGSVaTzhx0/zZ1RZwvVB4d5q9YKz03HeEYnpknkYop/1EW9LvZ0HRrEm7tgvK0Ic8VsKcG
	Xx1ggCUzIPCQy4QXcK49VXrYMWqFMKzlr2z3dCcNbUTBRkcqpWTpMvyLK5lfFB2lYC8Qat0A2XN
	q6d1aXpBNUpT4Lg==
X-Google-Smtp-Source: AGHT+IFQElYkwq2G8k4uAgKb3u+FK4KZxl8VJVnmY3Eo87tiNYXeh7dgUSv1GRb4rJwPsH61XbRT/Q==
X-Received: by 2002:a17:903:41c8:b0:235:ed01:18cd with SMTP id d9443c01a7336-23ac4653ff7mr243268295ad.44.1751268389195;
        Mon, 30 Jun 2025 00:26:29 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.13])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f17f5sm77237555ad.62.2025.06.30.00.26.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 30 Jun 2025 00:26:28 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	david@redhat.com,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com
Subject: [PATCH 2/4] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Mon, 30 Jun 2025 15:25:16 +0800
Message-ID: <20250630072518.31846-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250630072518.31846-1-lizhe.67@bytedance.com>
References: <20250630072518.31846-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

The function vpfn_pages() can help us determine the number of vpfn
nodes on the vpfn rb tree within a specified range. This allows us
to avoid searching for each vpfn individually in the function
vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
calls in function vfio_unpin_pages_remote().

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a2d7abd4f2c2..330fff4fe96d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -804,16 +804,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    unsigned long pfn, unsigned long npage,
 				    bool do_accounting)
 {
-	long unlocked = 0, locked = 0;
+	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
 	long i;
 
-	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
-		if (put_pfn(pfn++, dma->prot)) {
+	for (i = 0; i < npage; i++)
+		if (put_pfn(pfn++, dma->prot))
 			unlocked++;
-			if (vfio_find_vpfn(dma, iova))
-				locked++;
-		}
-	}
 
 	if (do_accounting)
 		vfio_lock_acct(dma, locked - unlocked, true);
-- 
2.20.1


