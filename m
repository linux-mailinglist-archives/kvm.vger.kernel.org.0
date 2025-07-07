Return-Path: <kvm+bounces-51656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E85AAFAC23
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 08:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42EDD7AA511
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 06:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DBE3286897;
	Mon,  7 Jul 2025 06:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ZyRrB7mX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AC427AC4B
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 06:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871031; cv=none; b=F5NLn4RpBcyNv2UCxjTVBwOlUbHGbSG8VCf9vfmFC1BHJNYO6MertEllsqtldu+vRLhd2kY5KmwsC6mkOdm2mH+3DM4cMz/iMR6XjuqBzJqltILwKSdkz0k0hMK9TKB2/oWlhvtQrUCg8l+nxaOsWR4XsKjlRIJfPZ78lWP7TIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871031; c=relaxed/simple;
	bh=/B2Cmebs2wx0RR0cS/Zre9jsbWIH/bpLwhd4AwWN4Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjYEzXmEtuhsE6o/NZi1jaQ2SoANlEcpCztZOkZgyzx2oRd72MHgfMjqqEnGjq23nZkNwPu//tBGEIsgUJX2/i+eGAnl5OfRVnUlNxl27f3/KobhAkTRc56dAH/u7uNscqIy7v0+8dW2oLYoAx/Ktf5kPBx1off3lPFF71flU30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ZyRrB7mX; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-235d6de331fso34962695ad.3
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 23:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751871029; x=1752475829; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90En1W3zs0tALEbbRQaodK/vejigNx50ns8gS3LDvBw=;
        b=ZyRrB7mXt4+uVJYdLr7VzAMd8qE6RFZp1yalP7Zp5KCelemeFiUsUzcea0CHlZyA2z
         y/np/lMT6W8Xywhht8pfKxEz0n4EBT3pG6IKynHHjy/wRdEhOwAwU8o1awIRg6rIOjNA
         eOOFlKR8pqhaVO/ntznKeNXNDEB4+pcX6albrPxw0U9xYCdqDJ/5AuYkeSgAPKCaFtzm
         1u4KqnKgypID2+ER0d2PeR5T2R2zSzy8p0mXT18GQ+q0TcEW9og4Dqs96syz3swbJSE+
         PgHjrk2vzSmWNIzbiKKBheJ9ZBJe/j96kAd7uq0WJ+jjIw7qJFOTsRt9cMeVgpeKr91M
         Lchw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751871029; x=1752475829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=90En1W3zs0tALEbbRQaodK/vejigNx50ns8gS3LDvBw=;
        b=UURlTGpyajw3YOML4paSj+NTsam19UBfOyYbJmFH5kvQTVoBAn5S8uwwVqTj/tAeqI
         s1XjA5IQtq384JW7L46QIhtOHM3eBuZNt02UA6IKMRQvHRza8dKNAvspveF5jBh9pJm6
         8KnJjXwiJj1zXRetH6w/5ZidJBLWyr6nxlKQMcSKQ3H6s/uUngU2ehTixiM4Wyave2/F
         1oRlG38ywQ7gpQqZOdl/i/xEND5LyV6Kxd2WpMp3EYXDMxQWdnsV8x/jJLcFp1GwTCjQ
         /M63zXZKHEQ8k3CoZUEl7SFXoZ7kagz22xkEG9zDIVT023YEtO3CTOFAJ1QBlv0FMlU3
         sodA==
X-Gm-Message-State: AOJu0YyZlisP9ZGjOPP+lktj0YD4fLjZ0HZY4wQWklxnSZylN4uovpd/
	Q4Nfv73uqHa20QM9OGu/vDFngSY79Na7AiB8ObMQjpDW0dO6ZdOUIfRMpY3VCY1Aq00=
X-Gm-Gg: ASbGncs6ZUxRO/zmRPViESyycNaUu3fSzGECR2x5WIRFvJ2AYjfOs67vtIdDFfeAZRt
	Qra73kllwUUfbcgy4ICYMf0S5Eq19nIiZCY2voBUSNi7Ce+UUOh4HRwMl8K/U9yt0KpoYF0CUuw
	ZrftSAkz9Chdgk73A7Ac6mDgojh+HsN0cTH5HQVK8vzBzsEVVX4lMZeoFcnk2cIzpk7zj/Lyz8Q
	ogeSPHi8tLdFVWw5xnM0d+PRKqdt00edRrhQQ6JPw7qCiQb2pdoOmX/RneerG0WB9yx5hiuDhkn
	PN6DaE+SIKNu0AaVXGVLlt1IPL0xVXjRcPNMRLG89o8R6wjKScquJ+O/mJAS18Rg9wLRD0NfGX6
	yrWuFSzRV+pNP
X-Google-Smtp-Source: AGHT+IGk089Voe8sYujhmiUPCIl62YdQ2hxYB5OqRb9ETbkQLoZK53+o1hrm29Rn78YQ81hdAXergg==
X-Received: by 2002:a17:903:1446:b0:235:e942:cb9c with SMTP id d9443c01a7336-23c85d9f014mr192498945ad.5.1751871029513;
        Sun, 06 Jul 2025 23:50:29 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8431a1aasm77377635ad.15.2025.07.06.23.50.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Jul 2025 23:50:29 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v3 4/5] vfio/type1: introduce a new member has_rsvd for struct vfio_dma
Date: Mon,  7 Jul 2025 14:49:49 +0800
Message-ID: <20250707064950.72048-5-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250707064950.72048-1-lizhe.67@bytedance.com>
References: <20250707064950.72048-1-lizhe.67@bytedance.com>
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

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b770eb1c4e07..13c5667d431c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -92,6 +92,7 @@ struct vfio_dma {
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	bool			vaddr_invalid;
+	bool			has_rsvd;	/* has 1 or more rsvd pfns */
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
@@ -774,6 +775,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
+	dma->has_rsvd |= rsvd;
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-- 
2.20.1


