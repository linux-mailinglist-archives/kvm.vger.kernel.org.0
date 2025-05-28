Return-Path: <kvm+bounces-47844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E02AC60C6
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 06:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50B7A3AA430
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 04:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40371EE017;
	Wed, 28 May 2025 04:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="cMaRMSv7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E4B1922F4
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 04:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748406093; cv=none; b=djPJ7yAppEnqo4gjg6AVdbvAAO8T2fkioRazxlIsFq77uAZOCBQsGD75YkYQvrzB0T1d6+ylPNxX1ORAeRIjITXviecgYXQ87PAS9OjecyJ6E1mQvYwqKKHsAfjNoIiSAbZRZk81cCPKNo4TGKSFpFuexlbsWrsWygMDtbaby6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748406093; c=relaxed/simple;
	bh=gYpAGN+5M5Rw7wA5/nO5pYmaDLAbaV/Yvvl8IIn+E24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWPkQDHpS8fdrwIpT36VSv9h+0vjOK6avLbbIzshmpaRgX8suS99L7KPwB8C6AZKHW90MTPMHAfun1ozD8HARX2cBH+66qMe6lZkqraAx/gGpNFJ5LqMcoXdnMPXX94/7+Ea7eu8iYWQ4lFFWwgJD+CbIWT/6vgOouwldgpHoPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=cMaRMSv7; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3110807523aso3859883a91.1
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 21:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1748406091; x=1749010891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WV/qvSPB6WEwErKAsMTVFQ4E7hjPgAfhVGUmnDRBrnE=;
        b=cMaRMSv7Pv/ROGY6fkrh8+RygvTG+PBrbMUdzrkz8Jd1tT330v7WgNmlTHmPKx+g44
         9zOtCZJeZoojIXs2CAJT+2WcWUw+GV9cUYL0XlGyeSq2OHHp/tOQR646tAwY7vZUht6j
         Dl+j580Zz7mEPq+Rvf+Bi4hHrfy3DeEnKXh1ym994GgFdk3aLrllakjoJyH2yV7swjS/
         bKi/tQ/u6oM4EyRzkAqyb2vaGAMpehrklZKggvmsWxQ9ZjBjDsS3dFsUtEs3bsfk6iLq
         9t00N2te20tNUoabKnvifMU6HYq7KO97B6jH3ojcpZJdnR9zenGHVmBx1kgjDEJ5DcTi
         ZWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748406091; x=1749010891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WV/qvSPB6WEwErKAsMTVFQ4E7hjPgAfhVGUmnDRBrnE=;
        b=utE20Ex97SW2IESKT/WnKR8IiQlNOPjdPsqKXrULzddU/rEagA4X7CVpCTvCpqdj7A
         lXXTMVC0WYkcAF3rbZgnyMj9tAqqOrn8JXKHF1bWqyBScU35gDIfDrQvJ5pGv+Xwvx8Y
         WV0CF32vYTnAZQIT8PfH9m0vBaPzdchfXcEvJ0u0hhCUMwQ5ueHypoqvGvjxfHKy4Nqt
         I8egth7R9+jYOdaPenbpWy/aRWy4ERnwPtD67c//EkPaXFobgjwjUdw8fF5oGHBLc4N4
         f/ww+BsnU1OxtN8ZrcFn0hNaYj++bCyp00hES5HXNrWu0zZHpXhg9JWIPD6oLdayqy/9
         7QFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1Qz9Q2ilq+k+cAfLw/txtl3Hzsguxuzu83kChuh8gGeDEPDvJPAlc/9cu10jEEKblQSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJHmy4t2C/uSTERsXk+cgzY0/YwLirBIhjT7lodvi/QspTsasE
	K+rhLL+10Rtkn06QnyA92bFVGU5t2mDZVPILSlxfREKovkOAiGWvvirqFGlHqCzEFok=
X-Gm-Gg: ASbGnctHOz3NVHEaE0LwjLlXp/ircekYgeIKG1sY0HS6s1W/5JLpS/YDzdYaExt5LHf
	3aanrMkvM77+N1yawAeKoCgJSF9I9sMczZ18WwWxDfVocS5YLw+enw6awzei9ezVDPb6VOze01E
	Tcz6UpMBKmLldlbGopqo0Nw/P8/le3ZyX32dFy+ZOExrtuceAXYEac/M4jrKZ5B/LCEOQ2lnp81
	M0jcjCxOcJEajyiRCtDuf0ARudiydX7hbQv2lLT6Tma95GtY2PGFraPAH2ZZ1xSHzZSLCyjUIqR
	8crXbldiz63au+Bb9bzQ24zTycLCJbwO0YRn32pZivssQjXxjNOTBwz+j9c9wq/ORJ3LIF2CBLA
	8Yg==
X-Google-Smtp-Source: AGHT+IHqceBKN3JoBv7Ps32UTkuJjeTI+o1YYmCxSCNbbdszAchYvVphd4HyUAYDLsrNEZRQGzutlA==
X-Received: by 2002:a17:90b:38c3:b0:311:df4b:4b91 with SMTP id 98e67ed59e1d1-311df4b4de7mr2403223a91.7.1748406091267;
        Tue, 27 May 2025 21:21:31 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-311e9b7f444sm285956a91.24.2025.05.27.21.21.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 May 2025 21:21:30 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	muchun.song@linux.dev,
	peterx@redhat.com
Subject: Re: [PATCH v4] vfio/type1: optimize vfio_pin_pages_remote() for large folio
Date: Wed, 28 May 2025 12:21:24 +0800
Message-ID: <20250528042124.69827-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250527131450.7e961373.alex.williamson@redhat.com>
References: <20250527131450.7e961373.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 27 May 2025 13:14:50 -0600, alex.williamson@redhat.com wrote: 

> > The utilization of the function vpfn_pages() is undoubtedly a
> > good idea. It can swiftly determine the num of vpfn pages
> > within a specified range, which will evidently expedite the
> > process of vfio_pin_pages_remote(). Given that the function
> > vfio_find_vpfn_range() returns the "top" node in the rb tree
> > that satisfies the condition within the range
> > [iova_start, iova_end), might we consider implementing the
> > functionality of vpfn_pages() using the following approach?
> > 
> > +static long _vpfn_pages(struct vfio_pfn *vpfn,
> > +               dma_addr_t iova_start, dma_addr_t iova_end)
> > +{
> > +       struct vfio_pfn *left;
> > +       struct vfio_pfn *right;
> > +
> > +       if (!vpfn)
> > +               return 0;
> > +
> > +       left = vpfn->node.rb_left ?
> > +               rb_entry(vpfn->node.rb_left, struct vfio_pfn, node) : NULL;
> > +       right = vpfn->node.rb_right ?
> > +               rb_entry(vpfn->node.rb_right, struct vfio_pfn, node) : NULL;
> > +
> > +       if ((vpfn->iova >= iova_start) && (vpfn->iova < iova_end))
> > +               return 1 + _vpfn_pages(left, iova_start, iova_end) +
> > +                               _vpfn_pages(right, iova_start, iova_end);
> > +
> > +       if (vpfn->iova >= iova_end)
> > +               return _vpfn_pages(left, iova_start, iova_end);
> > +
> > +       return _vpfn_pages(right, iova_start, iova_end);
> > +}
> 
> Recursion doesn't seem like a good fit here, the depth is practically
> unbounded.  Why not just use the new range function to find the highest
> point in the tree that intersects, then search each direction in
> separate loops (rb_next/rb_prev), counting additional entries within
> the range?  Thanks,
> 
> Alex

Oh, I see what you mean. So the implementation of vpfn_pages() might be
something like this.

+static long vpfn_pages(struct vfio_dma *dma,
+               dma_addr_t iova_start, long nr_pages)
+{
+       dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
+       struct vfio_pfn *top = vfio_find_vpfn_range(dma, iova_start, iova_end);
+       long ret = 1;
+       struct vfio_pfn *vpfn;
+       struct rb_node *prev;
+       struct rb_node *next;
+
+       if (likely(!top))
+               return 0;
+
+       prev = next = &top->node;
+
+       while ((prev = rb_prev(prev))) {
+               vpfn = rb_entry(prev, struct vfio_pfn, node);
+               if (vpfn->iova < iova_start)
+                       break;
+               ret++;
+       }
+
+       while ((next = rb_next(next))) {
+               vpfn = rb_entry(next, struct vfio_pfn, node);
+               if (vpfn->iova >= iova_end)
+                       break;
+               ret++;
+       }
+
+       return ret;
+}

Thanks,
Zhe


