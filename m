Return-Path: <kvm+bounces-51063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E45B1AED586
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:27:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35BAA16E5B5
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E823223707;
	Mon, 30 Jun 2025 07:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NRpG5mHQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047B721E0AD
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 07:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751268396; cv=none; b=kwac51MXp3CDMMtLd3Oj6hGv2zB6TAsGTL1WoXGyM3oHCDqHsqUkgXiJ9VSvBI/yEsJVuJHdAKosZlGw1hobxfksYmfePOu2MfWhzFfSDQWfDQ6ggeI2NWpV8OHsSnBZSJcW5nHhUAHLhQKoxgru5JN8hrGYs6lLgM0t2iIhINw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751268396; c=relaxed/simple;
	bh=OXOAdqxVIp9HtLsu1MvyrpEwHF6RN9H7pCkvmJZLspY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e27vLwLSh7dngrxeHg9DSRObU59pEjCCJyJNxINw3jKo6MuqHzkaxa0czil9hRCtCfZdMD8LEPRbcnhLjz2LW/3FieK0/1n59VdmC7qtf8yHYNPChGBNzYhXPiX4P6AGlAuwUUbbwtTg4oE8suuoawuJOUoyyfMm2Bh2yYyN3Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NRpG5mHQ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-236377f00a1so38305345ad.3
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 00:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751268394; x=1751873194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/hNQa9KjFyMpC2ihH2SV+iZEz4QS98Qql4RbXjx0BM=;
        b=NRpG5mHQEzq/dAot1ADX0cryiQcBGIOi4f/9WXSuazrMYPIHb6bcBkKwafmDaIHza2
         3SL6prn28028s0RgCbiQF6v+2MqriZ2v4oYfoFxjyqVirWfuvPLY4QPb26X34nMezqu8
         dnOF/YSvYIvbevEt+2S/kMn6D7MVxGdWnjzL4+Y3KuZ7yJKX74iZVHmRC8FH8qgk2WM+
         iI0A5MNsBFE1aLBtRc7n+FDjN4J6U07NtXLj3wd7qt/F/KWfZaSqqdPWhua2oYgfAWHe
         diHZ7zn11XHgIzyKF/wTA3McVmbMAAfhnRQvwR0vRKyMDZi5ajBoFqTFjbguAuJBj1jO
         eOqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751268394; x=1751873194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/hNQa9KjFyMpC2ihH2SV+iZEz4QS98Qql4RbXjx0BM=;
        b=pklUQcj5PxMf/lKL/EVEylIIOowrDfAZehtvYD/IIJSwoeNkd8LzcrlzT96JtUcoH2
         rPQewHEhvCccf0TTnuvSh/m/2FxWkkGaZoDJ6P1nbG2+VLWIqsdJado/verl4s6NB32v
         wQxPhsqpfBu2J4KyosDI9hNJDgse7jRgTtQvjBgHVUhkqbJmDKXrTYv8C1mtTXItYUbx
         iV2BORI0j2DQs01UjOJ6iIMuZAY6FbZGjbYu6U8tTNjdxopH66QqCY1cpiYpStZs9UW3
         25Y5kHmFkn95RG805eWQ2O67jDGcg+lzf7AFkvQ20r7NyJxlg2xnMOy56PLqxwXE4meV
         Aptw==
X-Gm-Message-State: AOJu0YyCnxJEQoMs6sNlkaqTm1eU8kdLNPZrq9B0oUNy5I0P4QifL6OQ
	rVsl2Qyf34Uh6H1n5HkZs1/5YNVxQl2C7/1P6HhzMqly3AqVusvrq9VSkn00cXtUbl0=
X-Gm-Gg: ASbGncsZGMF8c2qliCOlmh/vofYEcK0SCkAfMRwCMm+lsm8iYWBnP7SeTgYN0Wg0ZWI
	jhBida5JmVuMfg5cbztlPVRM0VBBhqdllBXdjGukki/r5lUxywVMY86LMPdyGHSmR70tBnhPsN0
	i2Kwc0ND/SIlPGAfK1ZVNhZL5hiFzzxk2ocKxWr0bdzVjODc2lcc2IdPAz8MxusYDssWjWlUNXO
	Zzx0fSNa/asMfzC9aNggI/ldLgGciMIU/McCszd+KIHEXUJfPh8UqOv4SbnG4St5K7W3D9BhMKI
	B719/adfIG7eOyNWxFwMKWwBGODkLhUTVjlac6/oMWtt9k9pN9Ly1aKV2q/gJBeFvgkHu3kSdK2
	BHoWo8aRHTo32tA==
X-Google-Smtp-Source: AGHT+IGAD20yxGlVCMQbeNZIjI7hSWnCpaZJZIRII2/DKq9LAZjm63OyWH2Q4nV6p6WIReEmgJrW+g==
X-Received: by 2002:a17:902:f745:b0:220:ea90:191e with SMTP id d9443c01a7336-23ac3cf5451mr169718755ad.4.1751268394203;
        Mon, 30 Jun 2025 00:26:34 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.13])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f17f5sm77237555ad.62.2025.06.30.00.26.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 30 Jun 2025 00:26:33 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	david@redhat.com,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com
Subject: [PATCH 3/4] vfio/type1: introduce a new member has_rsvd for struct vfio_dma
Date: Mon, 30 Jun 2025 15:25:17 +0800
Message-ID: <20250630072518.31846-4-lizhe.67@bytedance.com>
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

Introduce a new member has_rsvd for struct vfio_dma. This member is
used to indicate whether there are any reserved or invalid pfns in
the region represented by this vfio_dma. If it is true, it indicates
that there is at least one pfn in this region that is either reserved
or invalid.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 330fff4fe96d..a02bc340c112 100644
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
@@ -784,6 +785,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
+	dma->has_rsvd |= rsvd;
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-- 
2.20.1


