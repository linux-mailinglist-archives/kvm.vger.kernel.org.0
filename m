Return-Path: <kvm+bounces-51722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26C40AFC11A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 05:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1928172854
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 03:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75F6B22CBE6;
	Tue,  8 Jul 2025 03:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UsudPzGE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20942557A
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 03:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751943628; cv=none; b=h28uLAbW4EvylSXDcOswKaRjyBh1o200zivQfO2QBSzt3iJJEoX2YkFGLwtalRiQ63CMg2nbNN895fV50H8TIBK9N0Z9rWv0/fqxwWs++2XIkFvYC8QPHc8w3sNB09OGAunJNUKiW9vSll3hSRuQPaHG1ZV3XWF1cQNQwZ+8p4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751943628; c=relaxed/simple;
	bh=WMhgcSeohrqilWlbvY9PZXYZsd0ZvU6eqOQQdw7z46Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhq8b/SMovDiAhF5m56qxxVqnVT4505sLldLQoAumT8oHpXiiKDxHS2HdPWoNVnbjQVllbipjMbcUNVMViGd3latnJhPljtk76mv+RueBrOuVdwioBYmxYud0cG7GKiowX+86fBPhKcj6peVS/Lu4j3pTbnIRh9ozxCOIjoHXXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=UsudPzGE; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7fd581c2bf4so3320953a12.3
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 20:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751943625; x=1752548425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMrKKC1vkb61pVbzzmeJOBgVccrTmC1tTEZe+RTgQIY=;
        b=UsudPzGEV9JgH/FxBaWxFPXHu0RDglfD79L+wa7zEUiXF4H9zF8Y2lhcEDkML6Ykx+
         TX/8DkT+/ikqLG28YNNMqgDZEbPEUo/3/fV718IiWLxnAdmGrAjaKpzNFwuzMgKoQso0
         HFXtIA6SHuj5kWSd2/f4/WGFctmCQGoVPDbAkWd4xALch0BmE8u7NaPvmXw2IsKnxCRf
         Elkh0So8GdrKjfX+Cid+INx/1nNhGzbIYDr7YxBLBDYQRcJalyzdCc7qLuguf/OXQwxR
         FZvS/UHqce2j/k8yAfFEZnkVqhTmLtTBzNoR76HGceAwrtMWMlfGfveNXqKmP8mqx/4Y
         lchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751943625; x=1752548425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bMrKKC1vkb61pVbzzmeJOBgVccrTmC1tTEZe+RTgQIY=;
        b=Y5cPQqu4Xyn/E6CjF0MpoMaZWVQWC7orhGl+Iu71RYZRaDjtY5QxXhAuK7OkADurb0
         /BMI6/b47twqwqHP9jkZ6oCQl7KtOOZ7FpXXca79HSohNimfI2NBbHBJOadhImjtZb/e
         Th2ILffY9gPpAh9cY0qlpMKrzDVteywNggg4XNLlwggRcFA3xB/pJhQqhJLL4oLd9NFW
         T7rW+g2M66BYmSJc37IT54cprdpp8RjFtC4F7AYjjsvWn1rhTkkaz+QSClXEvwtUY5fQ
         cs/Equ4wQR+SsAift8SaUhZjiNFQnDwXRFXukL6hvG6sDr5A6cYC0VAAfb1DChf8IyZM
         sPVA==
X-Forwarded-Encrypted: i=1; AJvYcCUM/Au44zuPzJFExFOf7x4kOs42+5qRZ9XBsBsB2gD3c3I/cXa7Rk2VhqEHr9tD+vrRjwc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWmaQxQPcVroOZ/+7RgwUORF+LrgZEQbxlY6RmgupBF03dXny/
	ujm6F4B9DHl84fdRHNHKsVgllo38L/cHL+i6VwfQItFAYvrGpcPpj+1+UAj3RsAsci0=
X-Gm-Gg: ASbGncto2e80+oLmDa38VVj77BBdari8u+RByLCPiqW4c+27RdNU8szdmyUEEyeh8rm
	Hk8I/awG65hntmCsmFiN3lfwG9+JcTM/jNNfAD1G5xzajIXKo+lBic4Rdi0gIDBMF4pP0cSgVhR
	JEVHMDwos0lUR+EhUjcvAUXf3IRBq3sQ63XvqCXzyeSt1vpMPi7AbhwBopvuAGFsSmwCXB54Eyi
	Z7befHmqb+VkTln7/Oums/6aYWucgZ3ZUx46H73REHza2iwBWZaeFTNoHIjPfrQnPdQvmjQa3lM
	gUfMcYOiGJKPkWvs8JK3HQFGwHrDjlbOXHfVpOxEvnUrZjHoJnqAu9/QDkXGMyaSA/acjzFv1i1
	4UijMw5io3t6eQw==
X-Google-Smtp-Source: AGHT+IGONuKHAlHSkdF9dYjKJobYsaQXINAC8otRUB02iJ7r7RxJpmX1c4M/LkCrqml5u544gUG41g==
X-Received: by 2002:a17:90b:2ed0:b0:311:f30b:c21 with SMTP id 98e67ed59e1d1-31aadd9fd46mr17327109a91.26.1751943624853;
        Mon, 07 Jul 2025 20:00:24 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee450fcbsm10029952a12.12.2025.07.07.20.00.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Jul 2025 20:00:24 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v3 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Date: Tue,  8 Jul 2025 11:00:17 +0800
Message-ID: <20250708030017.46848-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <9d74e93d-5a5f-4ffa-91fa-eb2061080f94@redhat.com>
References: <9d74e93d-5a5f-4ffa-91fa-eb2061080f94@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 7 Jul 2025 09:29:30 +0200, david@redhat.com wrote:
 
> > @@ -680,32 +724,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >   		 * and rsvd here, and therefore continues to use the batch.
> >   		 */
> >   		while (true) {
> > +			long nr_pages, acct_pages = 0;
> > +
> >   			if (pfn != *pfn_base + pinned ||
> >   			    rsvd != is_invalid_reserved_pfn(pfn))
> >   				goto out;
> >   
> > +			/*
> > +			 * Using GUP with the FOLL_LONGTERM in
> > +			 * vaddr_get_pfns() will not return invalid
> > +			 * or reserved pages.
> > +			 */
> > +			nr_pages = num_pages_contiguous(
> > +					&batch->pages[batch->offset],
> > +					batch->size);
> > +			if (!rsvd) {
> > +				acct_pages = nr_pages;
> > +				acct_pages -= vpfn_pages(dma, iova, nr_pages);
> > +			}
> > +
> >   			/*
> >   			 * Reserved pages aren't counted against the user,
> >   			 * externally pinned pages are already counted against
> >   			 * the user.
> >   			 */
> > -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> > +			if (acct_pages) {
> >   				if (!dma->lock_cap &&
> > -				    mm->locked_vm + lock_acct + 1 > limit) {
> > +						mm->locked_vm + lock_acct + acct_pages > limit) {
> 
> Weird indentation change.
> 
> It should be
> 
> if (!dma->lock_cap &&
>      mm->locked_vm + lock_acct + acct_pages > limit) {
> 
>      ^ aligned here

Thank you! We need the following fixup code.

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 03fce54e1372..6909275e46c2 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -750,7 +750,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			 */
 			if (acct_pages) {
 				if (!dma->lock_cap &&
-						mm->locked_vm + lock_acct + acct_pages > limit) {
+				     mm->locked_vm + lock_acct + acct_pages > limit) {
 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 						__func__, limit << PAGE_SHIFT);
 					ret = -ENOMEM;


> Please don't drop acks/rbs already given in previous submissions.

Sorry for the inconvenience it may have caused.

> Acked-by: David Hildenbrand <david@redhat.com>

Thank you once again for your review.

Thanks,
Zhe

