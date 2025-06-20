Return-Path: <kvm+bounces-50018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2491AE11BE
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 05:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 791324A3682
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 03:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA5B1E5207;
	Fri, 20 Jun 2025 03:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="S1tXgx1p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CF31DC997
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 03:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389857; cv=none; b=QXlc7hDyRCehqpzcO9xfIG9zy6jcf/466e2iQBU2ti8gfMZV4SradIjQYngBudbPiLaTXeHLtXWyZQPSdN541JZN1+Yom+mC0wbS/cWFMbdiEo/OqbIRqoueL7Hf3Lxxk8q34J4sTMw+PPxRRLvy7D2Rh+DWatf92dl2+Qnu09g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389857; c=relaxed/simple;
	bh=aVi+q7O/crMw2zBHRVPGvYU26xciOHQulJaxqwWbTeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsJFGDO4MwduOY9LbaUvMGk5WuxotiOzcrUZmWA7/HY+T1IpxtDkx46T0pCZsRNlXkiSR72saVENsSdpQxPOcbAjAKsv2IR0+pFaLuXTuVOlslLX2O0U+oovg3F9GBk+fGUoa+C+o4lyMsB/SSajmHeYBN6R40QgEnEMNb3NBxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=S1tXgx1p; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-74801bc6dc5so1030410b3a.1
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 20:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750389854; x=1750994654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nA8lu1ILmrG85n9fJ0bjb2wIucT5x1eh7C3/xgb3MvM=;
        b=S1tXgx1p+/xZ85gm5TFxRpupd6GZrbhLepznNavCPtAwxn1G/6HVqJl8tQqWs41miw
         DYhP7CTarYFyG34D55YrnHqGNzb63SLTZUx7G6eXRFJm7uFhLJTuEDRbK1hclMzdwT5F
         vHCNiA+rAzBIiaCMmgQi57dF9ncH8dYI4dmZzhG8OKoUas8J+FMk3ESg32EJ4sUXaEgb
         9nZI/JOuY571fvepOAMkUDuBmEOrZtRV4SLrD8ixgsiYW9tEifHSIlYau8MI1SMlLA+J
         UV6QzslGO1RpWzWBOH8+jESd8T1ViYLDE/uu+1GnYC4uh5zXGDXpstqeuTGGlC4XF2Wd
         uCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750389855; x=1750994655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nA8lu1ILmrG85n9fJ0bjb2wIucT5x1eh7C3/xgb3MvM=;
        b=oscZs+MiXVTedy+MMBDDipfRraTrBy75s2ihC7vDH4/nvynZ142pSvwI6xMv3fY2Pc
         wEpOr4h6uXUqtG+Kcbsa4mYVcVj9NrPM+FiVu2s2H3YXeQsI7H2OaRyoNJGKWdGZy0YM
         ABeX5YbEDkTgBChxCuZKmhdzzI/e53V4wib/QrTnrvKHqheBnELgM34mgVK7QBAoWnmH
         6/hojqkYhd5Al1x+Z0uPrSS9KLRm9AzVrQP0Ze6IWcVr2wzKGQzK8eIZLHKabzpJZWVL
         PuyuYoQVfofiVjcLtBOKor2rlTkkk79IzfBEIyQE+al/6ZYo2E7Iahv7YH+t3/LZ/hDt
         mdZg==
X-Forwarded-Encrypted: i=1; AJvYcCWnvxX6C4fNX3Z5Qj22CceAeJ/Z1JwtwLhf5IqLQ6Z4eGLKoaIUsdQ96+NC/qDDHviszLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqAHsoyq+xNuzYXrP1gAAbq6r4gh5HmW3ieJkMI4GYCX3cRoiG
	cJdqRaQJ3PUK1mshNBU0UctJCTnkCjxDcz/R00QJndN00j6PhTdX41g4o+NjbB9wdJQ=
X-Gm-Gg: ASbGncuHO/GpdbH6MH88WzU/c+X5bBH6ZE7T9sJkw2IULGD9AigS3G2EZZ0CH6QfKlU
	3qI15n1RDDnSoIyElqrHV6uWw4aod1uIGnLBqvCV6h2qRUELyQ19h+PRd3l3xiOH8lg2oGDj/E+
	X7bpdPW3eve/e55l8KfG9Lp5yzt/1V4whT2BOJHxpNJs/NtwjlD5kTHHKdt44Ybj3hKDEFweehw
	FXAb1N+HmF1AfYIHZT8jGe1n0cBIjloaTw/LuvJj+36N2cpggCxxQMMjssoVs488PDYUAMSvBRj
	8XwhlGuGHM3Kzl07S/AUpzZzOys8D1h6jmzLPHUOA6hIJNK7UH7I00NSXNRggUs0PWBbAsOkME5
	Ze+Q3Bknom4WX/ImrnkP7MII=
X-Google-Smtp-Source: AGHT+IErDrjxvnczjGX7Ziw3nenkBC6Zy/yUAkwXq28ayHDSFAw6u+ds5wFBRcu3M1Dusg9exASQ7g==
X-Received: by 2002:a05:6a00:9496:b0:746:195b:bf1c with SMTP id d2e1a72fcca58-7490f5a435emr1097281b3a.10.1750389854555;
        Thu, 19 Jun 2025 20:24:14 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f12423e3sm490565a12.47.2025.06.19.20.24.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Jun 2025 20:24:14 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	david@redhat.com
Cc: peterx@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com
Subject: [PATCH v5 2/3] vfio/type1: introduce a new member has_rsvd for struct vfio_dma
Date: Fri, 20 Jun 2025 11:23:43 +0800
Message-ID: <20250620032344.13382-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250620032344.13382-1-lizhe.67@bytedance.com>
References: <20250620032344.13382-1-lizhe.67@bytedance.com>
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
---
 drivers/vfio/vfio_iommu_type1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index e952bf8bdfab..8827e315e3d8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -93,6 +93,10 @@ struct vfio_dma {
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	bool			vaddr_invalid;
+	/*
+	 * Any reserved or invalid pfns within this range?
+	 */
+	bool			has_rsvd;
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
@@ -785,6 +789,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
+	dma->has_rsvd |= rsvd;
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-- 
2.20.1


