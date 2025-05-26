Return-Path: <kvm+bounces-47676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD80AC3841
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 05:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CA9E7A9609
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 03:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BF71991B6;
	Mon, 26 May 2025 03:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="OSDNFJmK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD5E18B47E
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 03:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748230666; cv=none; b=ALPU5CPN+WZKgC+LugEHQQjsKulPxmGWSHtocOa5kd6qamgcXp3gNyNZUnSUH8GcAjV6vn6l7ou6VJHxOBTRlQ2F9lU08jorpS7saYCsWBxkCdChF3ANxQcgNXVX3ZYpKfdM23/iyY2pLJ9Zii0avdR5I+vxYo1cTs1ACPnN3hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748230666; c=relaxed/simple;
	bh=0z3DW3eLiT/2glKaCIDZdbh8rsKGTVe5AAcsr06pFM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGRVpaDcrD82kDB6c91mAf5CZHAYKH3rc2RmcOau1rumDxCreIzxJeK6VozrhxB12AOy3Q4XuQNqhfiKpt6zxhuYAbp5P3HTcTUgRg5IN+bdu6InqjIoL2tsum1VSlxSI4E1ii/wn5Ys5EJiI/OlUYXwR0PQ4+s+f2r7+V+5xDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=OSDNFJmK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2341e1fddb8so13389755ad.0
        for <kvm@vger.kernel.org>; Sun, 25 May 2025 20:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1748230663; x=1748835463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7vLgGkN6Vnumpz6d29VuOLpHKqUjZ78pRp6q7r9W+mI=;
        b=OSDNFJmKWS3bacMH9gBXbPhnb2dnFRUUhdmfOly8Vw4TABMt2E/n0vEKU5WsoNoP0W
         xp1U+zyN4Bn6CPRK/skiOm2/hvAr/VS3VCKhvQ7dStBXqRjR5FFIQ94KmGuRFiGTiqs5
         4CbMnTPWpYpO2vg+2ncehDW8KgyIPKmyDX2GWUYgezV8VYI/TPud/Xe9cIyFa5RSZ9jX
         oyjcOXfqZVydocThKMPJsG/LpeL0c8UJFA6r+K+xXI4FhTYroWSYKsECufWK6gsZ+SnH
         RzFfYuZmhR3LjpAgEmQsCVm5ZvYl5cfvEwa6JddiNDg7Y4QtdgeqiRyCbAThw/jUAs4E
         gK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748230663; x=1748835463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7vLgGkN6Vnumpz6d29VuOLpHKqUjZ78pRp6q7r9W+mI=;
        b=ojBp3efVq1BeXIZ06sWiDruX26T4zXonUwDx6JXltV3pO2O6WPmLosX5/+9l3rzj4n
         66JL0YT77AFNZLQ+0bKVXbTyjILSZFLK/Vkh5p5DsqEKx4Tqye1s8RE4QMXMdeQ53MSb
         iIp8yQGO8P+3zFVY2apL016uknidGra+UJuLFRXwfgKV72xG3VEAQwZ5+bQwdB+su9Gt
         cnOXoG3SkRlKxRPtXKTQSOZoNAHZdJjrg4rBgPrm/5tnVkuN1Bfpxb9TMx7kYaAlu6GA
         5sy81XgBhFm+TNWu4DMaFVw9sGbJY9rIIVCfvFPUoykMPwU9zBgbZDijOPTeMHiB8UiO
         JdLw==
X-Forwarded-Encrypted: i=1; AJvYcCUjqGpKHd+cH5oR3Jyjd0n7UXI1cFrEZOyCfTGuACZabtVf5g5lIf16ALybFvS6Sy9YLCk=@vger.kernel.org
X-Gm-Message-State: AOJu0YycylYTjltXEeSRg/zO76s9UowFr9cMfGMx4t0yCl2mvq0zf9fE
	yEBPyXvMZibMzRBz3H6QyJ0z5FYsO0myGOQoPN4xrDcybpnh7Bq9nWLeN0WlfKtvSlM=
X-Gm-Gg: ASbGncuNZv+m4qay69FKxdDybxHVh+koh3VKg6j/C2HgMUbl82fC+bYxE8E3G0jy1SZ
	xwCd0q2hGAX0EVsIEn2DJEaSGV6nhzIen0BcySjAp5YylLhj3Ne3b70gt+djj1tXDum6KqEwZIF
	K2sWFlhhiPqW/bEJg0noWsxOFf8p8/GWbNbSw4dxuzqs0GeorpRlrAfyRCnCKQrXmcwUdfLR3VY
	ZxsvP6w05wndu8p0xJzcVDBwfMaYdnRsWAccu49Xq7bdbepBSFov7m1cLmDCtWJmr0Zdo34qDMl
	SuyKDQpv/87li80/OPlv9YTsU5t3xyK0AgRTpRfBeoHcq5D5Y/T9Q9M0HTgwDTIdc6I1JkMdYja
	ffHE=
X-Google-Smtp-Source: AGHT+IGbfiSdJOKz3VR9Jajl4YpNiSwAfCQWBstzwpdi7q7BkwasjxqLVZbvgivWpF4goMfpxNNnZA==
X-Received: by 2002:a17:903:22c6:b0:22e:7c70:ed12 with SMTP id d9443c01a7336-23415000f42mr140216175ad.48.1748230663605;
        Sun, 25 May 2025 20:37:43 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2345d5b7952sm9760505ad.145.2025.05.25.20.37.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 25 May 2025 20:37:43 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	muchun.song@linux.dev,
	peterx@redhat.com
Subject: Re: [PATCH v4] vfio/type1: optimize vfio_pin_pages_remote() for large folio
Date: Mon, 26 May 2025 11:37:37 +0800
Message-ID: <20250526033737.7657-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250523085415.6f316c84.alex.williamson@redhat.com>
References: <20250523085415.6f316c84.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 23 May 2025 08:54:15 -0600, alex.williamson@redhat.com wrote: 

> > > +static long vpfn_pages(struct vfio_dma *dma,
> > > +		       dma_addr_t iova_start, long nr_pages)
> > > +{
> > > +	dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
> > > +	struct vfio_pfn *vpfn;
> > > +	long count = 0;
> > > +
> > > +	do {
> > > +		vpfn = vfio_find_vpfn_range(dma, iova_start, iova_end);
> > 
> > I am somehow confused here. Function vfio_find_vpfn_range()is designed
> > to find, through the rbtree, the node that is closest to the root node
> > and satisfies the condition within the range [iova_start, iova_end),
> > rather than the node closest to iova_start? Or perhaps I have
> > misunderstood something?
> 
> Sorry, that's an oversight on my part.  We might forego the _range
> version and just do an inline walk of the tree counting the number of
> already accounted pfns within the range.  Thanks,
> 
> Alex
> 
> > > +		if (likely(!vpfn))
> > > +			break;
> > > +
> > > +		count++;
> > > +		iova_start = vpfn->iova + PAGE_SIZE;
> > > +	} while (iova_start < iova_end);
> > > +
> > > +	return count;
> > > +}

The utilization of the function vpfn_pages() is undoubtedly a
good idea. It can swiftly determine the num of vpfn pages
within a specified range, which will evidently expedite the
process of vfio_pin_pages_remote(). Given that the function
vfio_find_vpfn_range() returns the "top" node in the rb tree
that satisfies the condition within the range
[iova_start, iova_end), might we consider implementing the
functionality of vpfn_pages() using the following approach?

+static long _vpfn_pages(struct vfio_pfn *vpfn,
+               dma_addr_t iova_start, dma_addr_t iova_end)
+{
+       struct vfio_pfn *left;
+       struct vfio_pfn *right;
+
+       if (!vpfn)
+               return 0;
+
+       left = vpfn->node.rb_left ?
+               rb_entry(vpfn->node.rb_left, struct vfio_pfn, node) : NULL;
+       right = vpfn->node.rb_right ?
+               rb_entry(vpfn->node.rb_right, struct vfio_pfn, node) : NULL;
+
+       if ((vpfn->iova >= iova_start) && (vpfn->iova < iova_end))
+               return 1 + _vpfn_pages(left, iova_start, iova_end) +
+                               _vpfn_pages(right, iova_start, iova_end);
+
+       if (vpfn->iova >= iova_end)
+               return _vpfn_pages(left, iova_start, iova_end);
+
+       return _vpfn_pages(right, iova_start, iova_end);
+}
+
+static long vpfn_pages(struct vfio_dma *dma,
+               dma_addr_t iova_start, long nr_pages)
+{
+       dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
+       struct vfio_pfn *top = vfio_find_vpfn_range(dma, iova_start, iova_end);
+
+       return _vpfn_pages(top, iova_start, iova_end);
+}

Thanks,
Zhe


