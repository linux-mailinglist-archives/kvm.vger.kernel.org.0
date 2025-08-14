Return-Path: <kvm+bounces-54646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D5CDFB25C27
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 08:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4616C1C868A8
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 06:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB55C25D208;
	Thu, 14 Aug 2025 06:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="WNPjJBY6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9124253931
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 06:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154088; cv=none; b=VtDFswhBHD+IumVDEIc1vddnjhlZ8FTnH1AW0jUVak/DjrFPADVpXteP+Nm+eqNESy4RqgIxvUDxyK2RSyL8McIlpflaVSMdXxSRkfedhZ/qs6JM5ls57kioeRRf0zXAGMl7TAzIXJUg090qUJxgnpvdsQz0uPwdTsXZy055AGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154088; c=relaxed/simple;
	bh=7Gfla4LpjOrT8Cgv9HiwO/rn3REpo0fOTkI3x0JXV6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEmW20LYEWE7Rr1F1w4iSfrtAG8xyNLOtYseBzT8CPFTVrrZvDSjM1GQyyNavX0CtsY4djl/EIwFB2ljLpQ2epinLnmvArIZtVvIf+maugydbcn+Ifwi1DqlTqNutIDZB/OnqF74cteCKRcvPq2FalnB3ligM+JaMuD/sBhm+bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=WNPjJBY6; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b47174edb2bso362778a12.3
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 23:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154085; x=1755758885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3Cfy9MkuTryrGPvIYV/gwml2MAD5wD8AXaGEu8eeiY=;
        b=WNPjJBY61+4kJC3pSTzx0IxgGOU6FdnUJh8SyNsdEwGCfuChga582T3fQr/XvUWpDy
         FzEow+yLQnmO9uWkczKMm2uryOLGX52zl4pRKgywFuSwzZqGYo37B6XQRIm7yq0D5IBl
         Gf4GcJdWn+3U+OhPPHcx4ajUSwwRBAbG5mI5w1cNpBVzKzgcl2zFNolPmwhQr1TeIDa1
         /8Md3mw04kRQK142BCQDIFcBz0V4hfpYAHTIDekI+ypWIizX45D5tGiqZkyoLjM25t1K
         gLhIHPZg/V8x9LGv30qxqps9XQPv3SfBM4Cgk/vNC1yw8AYNuE5oJi9aunITsxUU5maE
         Ucsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154085; x=1755758885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3Cfy9MkuTryrGPvIYV/gwml2MAD5wD8AXaGEu8eeiY=;
        b=FdnsJlGxeN5WmHa5oC0i7Uaev0TFwlcrCXyOifFRVtbUrdPGsMzjlgo+y1SJ2n58mX
         YLLEhMMzjMN8S5KHVFLTeuUGCFBg88Kxhjtw/Ms3SvFYkaIcv6TKVVF7YXJ1oZYMStgj
         DoE1KZvZQ62hW1LRQ4uJXfCWrrDHHQ/CUFzTOc7x9h2mQfV3HEV3Da8+yWl/FBkArl63
         WfEdnckFUTOlMyFTp3T0lc846aW2pTyQjlx9WT0YSaQAxAfAXtjn5TZlfiTnxXS6Ik1/
         x/e+NczKPgZ37IqJcTv8J5b30MMhZ5i7/Tny1tFdxXlCJVE1ex5j2m9r9G2Vf6HM4zpd
         FMmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHKQE2pt+otVGtTeMSH0+qPMwEOOb1JUvrpnXz6Q0doopUqeVrFpHil6miTAte2j9aQ9M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdjm+qjBciP0m/po8fpq5PykxQ2xDMI/sehoEo42bmhO7H+EnK
	SZHLh1ETaMjy3NFFURysbvJtP5UrTJhn3MNhS2ZMaIYkx0jyNZMHojM9psOmpCnel9owUX904kH
	r4nSR
X-Gm-Gg: ASbGncsiFLDQj2+AxzzveARmcmIdPq9OTFXlJeJmAKQafudKkBfnEdxMISvi94wGLLH
	ed7uAM6BQXYgDydjpMImSmG/TqabOiOt/+0JGEknwUAc/tMlYFLLvc/P3J0/0hyFVjPrqjZA7kK
	+9lvI5iJQ8Iq6VYY08xWGnrd5BuYvcEwe5aGQBYBaTnlm6UKkSafUwMmiqQ4Hr+wTlTs3AyTqRm
	I+emb6TLmkD4yPjsS9MQrKPWEWil3fqEngpTcQV0Ib/wHCU/VprKpmGlXZLs7e8vP5rHXsy+uFS
	vBu7mzFLmI0dSoRUAeftfagz4+8UnSeOqF59la0zDpgfJmaZFLAfw7wR63ktRDzJI+OSmZGydkN
	bmiMKxGzJEtMW5GNEq4+oGYtPD2aMu1touJaH5jv4Sr+V/a6nZg==
X-Google-Smtp-Source: AGHT+IH8PhH+kdbJo3TseIftuOS4YtVpdigzS/1u9iU7jJG3amFRXpK5xS1ruA8Xmy2+ygpXe+27pg==
X-Received: by 2002:a17:903:46cb:b0:243:11e3:a742 with SMTP id d9443c01a7336-244586eee45mr28699945ad.55.1755154084954;
        Wed, 13 Aug 2025 23:48:04 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.48.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:48:04 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com
Subject: [PATCH v5 4/5] vfio/type1: introduce a new member has_rsvd for struct vfio_dma
Date: Thu, 14 Aug 2025 14:47:13 +0800
Message-ID: <20250814064714.56485-5-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

Introduce a new member has_rsvd for struct vfio_dma. This member is
used to indicate whether there are any reserved or invalid pfns in
the region represented by this vfio_dma. If it is true, it indicates
that there is at least one pfn in this region that is either reserved
or invalid.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index dbacd852efae..30e1b54f6c25 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -93,6 +93,7 @@ struct vfio_dma {
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	bool			vaddr_invalid;
+	bool			has_rsvd;	/* has 1 or more rsvd pfns */
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
@@ -782,6 +783,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
+	dma->has_rsvd |= rsvd;
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-- 
2.20.1


