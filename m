Return-Path: <kvm+bounces-50017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56ADFAE11BC
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 05:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E56D45A13F9
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 03:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 322171E0B9C;
	Fri, 20 Jun 2025 03:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Ej4mijS4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001D91DEFF5
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 03:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389852; cv=none; b=cLAA/rq3Ud6pP/qx76SccjGu5yGbx+gZfRnSy4BI9yfye9LvoWIRV8NYJwfcOusOUvX+qIWp0defeSFqsDvGBYQV2ilDzypwubyOjuvpzbo/0WOqaUe1gwssQs52U4pq4KLbzONGrGG/jBNL0cpZJ954nibXqSTjlwATEec8wDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389852; c=relaxed/simple;
	bh=uV3cHhXrkTvBqdB8VYyLYO8kapwhTK0/BJjfokGJUfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILTio4xvHX3tGsBtwolMQUY7fLIeQh27HZpfXKb4p3HnLddZ+CFj5RViY6298RsOE1WEGxkJPPlN6WMo0GkTuJtA+jQ5IX6JidEye2WLrCxWthUF4YBPQc/+lKvZiTKwNZhCpxyU6YubynmVwKi4nh3ZxwM7BpH+97jTcSTqszk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Ej4mijS4; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-73c17c770a7so1559119b3a.2
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 20:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750389850; x=1750994650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSlkXQNydyRdWXir99epy9/y/pcz1kH+JURzeIlDKkA=;
        b=Ej4mijS4RguUTdUbbaLOvuxEsljl/l/1iHRMlpTICXszE6evvhFc5rsBHh5A0GDPIy
         rm30X/nF6cpOgmAVbZOfUy2xoCWIiiggtWnXEeh8PdTPABjM76pYy43n1M04Xw8Cc3NV
         VwfYxOyODA2MN58ml6vts3HfRjJUN14dyO23MrdXi0KaLtCArihoIbu89ZtqphCUPa5l
         Ujto4oLw3XUKrgO9qS68Ml8VCkpO/JyJSAb+D/PREvvZXWMvcfRBWyc4L4Gb/x4lmx+7
         oYFNBV/zWQ8dRYVIQ7AxXh7im/dMQw8rgt4e1ghPrOzZFFwZ2LT5U5yGLA6pHzuze2y7
         6MbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750389850; x=1750994650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSlkXQNydyRdWXir99epy9/y/pcz1kH+JURzeIlDKkA=;
        b=dEVA+QcaKYHz13DvOa855QCSc88vq3J/1PFjNEJ7Id7VJX9yvuB0QBY4pCs6NpqHrJ
         W0sa0Kqx8f4vw63/i5EFzNSV88X2RJdfk+d1dAZe11pt4ERMPFc1NXi5IBWwWUHEoWFH
         zgk7Altp1JWC7C7piXXn16lq16930cGd4ngBJuvnw8EF0u/vJS/fJcWDSV4Pv8rMGOrN
         bb/U551YH3wdDyE3B5jPreDpmYuYBCCPDM3etElEcDSyh8ZZ0M0UKZFwUAOqNA3ChW/E
         usV41vPzLo/yISL68ptZKc7KmS6fBZ0YwnSxKqGnSC7wl6CcWjPS8253ZjAwQV3s5IpL
         rW4A==
X-Forwarded-Encrypted: i=1; AJvYcCWPznnpdQYtF60Gao9MyntgXkLEefJE9ecnel0gC7//NSuAhuN7Sq9CWjano9+K3pva2Uo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6JIi0x2sv7qarYusWeWnKb8gALKSh4nMBMwUmA2fyY7FXGEi2
	SMz2yeznZrRtbaqzXfQZsOMFTT2FNoYipHd40DFLccxpryh2hs54AEpF6lfxPQyKTqQ=
X-Gm-Gg: ASbGncuWmyF6v0bXGYgaapITfCAUmso1OJThzJ5RtStziJ+LYfUbrmst3PZp0ODtYur
	H5Kb2MEkY0Uvwxn5ZFME+W+mIZA/fespqH53nsGZ7ia2C01p6OKhU+YpqeERpUJ6hZq4qMnT9kR
	cINyFZCt97krcXtyU3tigi/anfhuxnU5qezb2qmGeEQhb5HxfMDTzunCYG1saNhtr7C9+qepBqu
	pA9kdS4zNhizGzXEl14HKXwm4q/lTps2gUXQvefCYxmSuw58WiPCNb07LlhIr90SkiWvsUdkgOk
	g5qTO36SgLI02tRv/dgUBcO30cUuxuohTpHHs/WduZJoiBLcbFbb4czduYiFj1nfnrTvNWvoU0G
	BAwTlHW0lEWIfR4EUD09t8XQ=
X-Google-Smtp-Source: AGHT+IEsXcfjbayevRNoihfpHC+h/sIDZOjdQav72EKNFmITtaUo3YN4YHLpYj329boEKbDYcfD4jg==
X-Received: by 2002:a05:6a20:a10c:b0:204:4573:d854 with SMTP id adf61e73a8af0-22026d58631mr2053781637.9.1750389850193;
        Thu, 19 Jun 2025 20:24:10 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f12423e3sm490565a12.47.2025.06.19.20.24.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Jun 2025 20:24:09 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	david@redhat.com
Cc: peterx@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com
Subject: [PATCH v5 1/3] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Fri, 20 Jun 2025 11:23:42 +0800
Message-ID: <20250620032344.13382-2-lizhe.67@bytedance.com>
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


