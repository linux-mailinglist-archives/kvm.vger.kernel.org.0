Return-Path: <kvm+bounces-49655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB01ADC02B
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E45D13A50D2
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358DF23B610;
	Tue, 17 Jun 2025 04:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dqKbIBxf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634FD2BF001
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 04:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750133932; cv=none; b=inwgfQ9VYBYdewzOzWW2g3xiKgL499cuL04s+arFrGJXIU1fl8xhyUXNbX+XvaEfhesw6lYnStvI/5y9o6WjCpECr5NJ9obNTjRdArEVBOxdZi+XqJbhwF6RxVsfhPP5KNKaBCmu/fbtrDq3wJsH/00croY5a+VmfE6vt0gnqhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750133932; c=relaxed/simple;
	bh=uV3cHhXrkTvBqdB8VYyLYO8kapwhTK0/BJjfokGJUfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tn5fKtX3beShn3O8zpkPI1pcJFekVlQXxQF3Kojsi2g4u6XZ1Bqh7DW7eFan8TmGXbcKosbzdxmdgg4efJqIfZutpuf4cTuTC0AjUr+w8BkVEvfR7LIFVsFtjBt5G/hIn5rGg04nAm+7QYS2mMVoyjbevBQbXi8Ssc/O5IxpP08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dqKbIBxf; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3121aed2435so6229615a91.2
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 21:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750133929; x=1750738729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSlkXQNydyRdWXir99epy9/y/pcz1kH+JURzeIlDKkA=;
        b=dqKbIBxfKMzQZhBfJkHeUywNq4ozYqp838k/e0dFu5ePWUs0KGP18Bn6oSDP+ef4Ey
         kjzDxKebCQDxcPHqAfX5ky9Isy7sfgIFvZggDen06s1ukKyBVtz+42eTLdkvuZW7gmjk
         JycRyF2FgcHHTcriJBjqhjCq2hMXSbRFBJbTGaEnAD54aAtxvyoHKnR03epDz8VRvNHS
         KbYjtmssu0rWugkUXhzXs0RrQRFZDnioHpxc1PHywbmCgDBcftP7TJmJ0ismI2TgndZ4
         Ms5CrqTjoAqN6h9epJgESlBUXlB1ZP4sXSwvcPMsFSzvSNogGaWsMdkpfQsiuj7ByXdM
         DE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750133929; x=1750738729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSlkXQNydyRdWXir99epy9/y/pcz1kH+JURzeIlDKkA=;
        b=CFAGWK5QTS1ePpA+aDK0Wia6flVFZpU5kRLPNi9cwyyYZXV4HfYLldLXN8AHBxBTMW
         e/JFdYw4Zgo5uasQNfc1M9L+5rirEbl1s0dgxs/rL5ZTg9+ndTQ11WMCPvmcrpcvMp7d
         OrQSQ4rZ+lyaQ5NccK4hK68LJYVnOmoZeUZn29KrnpNIXGj19DKfZmsfHAGQegLz9J8j
         6bR1OS0GYtKcu+AVFonLnMsMaFX92Fw9thYcykBty6lGfyEUP4msWxqJxAu1iZzjLW3T
         ui0VBvXCAeBgKaK3lUzrzwTEfS/EwgG6bUkTfHngVY/5SwYo+WJZjxfRLk0W7RzFU9c8
         FZXw==
X-Gm-Message-State: AOJu0YwzsL6hMNCEw587jb9Jb5FTs2zpwmuCfQXg8ebgaCVhW+yDBWLh
	MmtwB0CNDEq21yYXZDmED8nfUgrNW/H2dIWkvRFbFur0fnVMzYrA3xcrPfzTdl05p/8=
X-Gm-Gg: ASbGnctCVDGK2TX04Fsm7h3btIgSLGGTJDY4oG9vQavExjAYBTFUqhUlv7xujA/7BGk
	E2LlmAMBqKapxe4E/mrXDFkTHmXtOADfxAkzcDaIk/977ohEZykguOzrHFFwfGHAc/cb41vstZg
	1N3ApigoKDk0AXMlWw9qJmt9VGccoEakgYZSOwJPkb9QTuMgKNvZAy4u0dMc+/7h40j2uRw97uA
	hfprNpXxU7vjSSCuVTsuhCHd855WvVeDeQWmDPZmm5wToZcRuKa/+mLAJQsr9KNVkzQ3WX3glTH
	goYg5aISm6Q/y5a0fH6CXimNwsfhlApDCwO5HLfPEH6l5dRz7FXScrQhuolJorlID+LQS9Od05e
	apC6BNpZSk6U7tw==
X-Google-Smtp-Source: AGHT+IFFsYmbyBpsr4DfeSQEWnhRvRv7gZnPzQ50rJUqNYeidLKzQA3kEEhkN2HqBPK8GrrOI3dAow==
X-Received: by 2002:a17:90b:50c7:b0:312:1c83:58ec with SMTP id 98e67ed59e1d1-313f1c0bcb0mr22561839a91.12.1750133929457;
        Mon, 16 Jun 2025 21:18:49 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88c029sm69798345ad.26.2025.06.16.21.18.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Jun 2025 21:18:49 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v4 1/3] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Tue, 17 Jun 2025 12:18:19 +0800
Message-ID: <20250617041821.85555-2-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250617041821.85555-1-lizhe.67@bytedance.com>
References: <20250617041821.85555-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

This patch is based on patch 'vfio/type1: optimize
vfio_pin_pages_remote() for large folios'[1].

The function vpfn_pages() can help us determine the number of vpfn
nodes on the vpfn rb tree within a specified range. This allows us
to avoid searching for each vpfn individually in the function
vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
calls in function vfio_unpin_pages_remote().

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 28ee4b8d39ae..e952bf8bdfab 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -805,16 +805,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
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


