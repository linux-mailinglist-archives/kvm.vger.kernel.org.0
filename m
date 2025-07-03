Return-Path: <kvm+bounces-51364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9C7AF6915
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:18:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB8E81BC81A0
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 04:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24A828DF46;
	Thu,  3 Jul 2025 04:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Lq6AR6aJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0642628DB69
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 04:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751516312; cv=none; b=monwBZl2ok0kCGrdlVaVtMVEfjdYHbUTdvcczC9JbCUBkqmS4JmLcUkW+K8HX6CnRgL5ZV/BFMRCS3VM+SpeGace1fa78+VWl6KE6JY0tAlD2xKvyuh/DsZZvk3HF0cIUhTCZD8D/ZtokZXzyAY01NriVMLCvXgtk6keEp/pvw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751516312; c=relaxed/simple;
	bh=n853TwlO290HC3DFOSZa3fC5HPi/a6KwpQlo+fZZXWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5yGEzvchn3vk5rPCC8AmsuUDv5B/Qmyuv00DDhb+HUHDKYEKfKRIawLpnyrK/gN8JzK6906Ew6lKBUg2BZIueFOQeVE3n86beNAhTMmizFE59hwaghkN8bY5QoId8Nlq3zJQnsxLMsobu8bvgWP4GUEpJRkYetpvGUXEgxWkc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Lq6AR6aJ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7426c44e014so7568217b3a.3
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 21:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751516309; x=1752121109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6A9qM1W1kTMfxV7iEFaeSovxnFad4ELH4SHsOsiAsk=;
        b=Lq6AR6aJxebvK+4lRzboUjWWGULi4QAaGggRuZ+cI1TiGsLUY/Rqi3+bi5eEkJrCpG
         vqvwcPmTuYIpbFfWNIDDXFfGfra8Ge6oaiEG0RJ19rUIOXQhQbPY+Z9+OPthdAYUMUFW
         YUZXPIg12aA99/qnGKuWWMJqYXhozdq9oJRzDFm0i/MOeNJ6gJt0R8+av3sOnEQtOH+2
         iEWERFn/HazKjmjA7LoZNENHihHKKBlyzKFlCjTV0LqYFybjoJTNp0qDepLzGg36I1gX
         XCOSZlFB7q5/FiVyd8mragICFF/t1WQ9GirtOYpLayxDLXuHsHinY/Hjq+dtKGpTBcCu
         mhiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751516309; x=1752121109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P6A9qM1W1kTMfxV7iEFaeSovxnFad4ELH4SHsOsiAsk=;
        b=LQFb6OcU6qg3hKJxgrbZ2wJiAfikXgF28drUiVBLKN8AU98awsRUXmduu0UVB75Wkz
         iNdl4UIMCCqmloLINUjpi8RmrPiqQxATm3A7SAqpEVsef41q/eiSJWRkNZG2w07FOnxq
         UBnFXj85X+kWmQUfSjvarR3Af+YlacoCVi9VhFf2QHkQd/cW+m4InFYaBDJSoFqa6kCv
         hKdwfCp+h3vyaTetBr2D4ZmvjOMPFwq+QA//OM2mjTbp8TOrzSujrMWCFSMi8vqNR1YF
         kem/JEQPM9ZVA7draB7aZsS/mStzMdGDn3cAYaVscArR0MWad7Ng8glrAoFodROip67e
         g0jQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuVVz64sG+vu3+NLQwL/fk2ttaj+cjlhlAEGuCpKTrqR+YHw4pFyISAn15ri736gbgcns=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy21XfcXF6m+RKEfeu8EOz8jWYq9go2l9hssluX6St5/jDOmZzM
	7PZXm8iVILK7CJJ0Ve7rn9pNmEyzNQsS+NS789rFM1r1m/Po/X4H6ZZqei1stdGEfFg=
X-Gm-Gg: ASbGncuIC0sSamFiWf5eDdbqlcbGrJk3UybbFY9Y39gyyVTK9IUk+2jCFBDZuXhto5v
	eJ/+IXid2OMSZI+fleuSZKubaW4k/9l80LBucCpFMrsodD13sdl23sP9iAFwfEKmqz3bZVW6whH
	JX/SiJf3HirMIjDb0KY24n4ssd2bhnUiJOE25WwqTurNb/bcJ/KUYmjoYIeAQ1doB/tQn+hNXJm
	8p2PQNnTVLCGB6j9wPVjtfBmMBRySn598eV6VgzNk+Y4+V4zwRFGF5n83QZhvWCVUHaFOVzVT60
	rEgpcJSBanhVzREQD6mvVyy47Bx5r+MUzbHqmBvjz1Tur2gWM95zYKvrpa6bXBrLVJzPnzs4fhR
	EmiHRZNeDogzv
X-Google-Smtp-Source: AGHT+IGODDTqgpEaoXWqjlMlT787ig8FJP/T1SAPH4oWUJ6Gg94JEZiVKBCBdsPXOE7/4ni32QnqvA==
X-Received: by 2002:a05:6a20:7fa9:b0:21f:a6c9:34d with SMTP id adf61e73a8af0-2243cae4263mr2443342637.1.1751516309240;
        Wed, 02 Jul 2025 21:18:29 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5573e71sm16905004b3a.98.2025.07.02.21.18.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 21:18:28 -0700 (PDT)
From: lizhe.67@bytedance.com
To: jgg@ziepe.ca
Cc: alex.williamson@redhat.com,
	david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com,
	jgg@nvidia.com
Subject: Re: [PATCH 2/4] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Thu,  3 Jul 2025 12:18:22 +0800
Message-ID: <20250703041822.37063-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250702182759.GD904431@ziepe.ca>
References: <20250702182759.GD904431@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2 Jul 2025 15:27:59 -0300, jgg@ziepe.ca wrote:

> On Mon, Jun 30, 2025 at 03:25:16PM +0800, lizhe.67@bytedance.com wrote:
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > The function vpfn_pages() can help us determine the number of vpfn
> > nodes on the vpfn rb tree within a specified range. This allows us
> > to avoid searching for each vpfn individually in the function
> > vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
> > calls in function vfio_unpin_pages_remote().
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 10 +++-------
> >  1 file changed, 3 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index a2d7abd4f2c2..330fff4fe96d 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -804,16 +804,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> >  				    unsigned long pfn, unsigned long npage,
> >  				    bool do_accounting)
> >  {
> > -	long unlocked = 0, locked = 0;
> > +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> >  	long i;
> 
> The logic in vpfn_pages?() doesn't seem quite right? Don't we want  to
> count the number of pages within the range that fall within the rb
> tree?
> 
> vpfn_pages() looks like it is only counting the number of RB tree
> nodes within the range?

As I understand it, a vfio_pfn corresponds to a single page, am I right?

Thanks,
Zhe

