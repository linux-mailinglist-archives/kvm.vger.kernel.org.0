Return-Path: <kvm+bounces-51316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D741FAF5E25
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0EC652271C
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F3E2E7BCF;
	Wed,  2 Jul 2025 16:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ezpBL3ub"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D4F2D46BE
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 16:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751472720; cv=none; b=of18ZkhZvMvXDikySXTP9CVr7/a0tQah2ZP8XVqp46dasbDsfE1TgGALIlb8uOLtZA9zqRlCmQXVRR+qucnmPau0SI1zrRUmX4bcdFRyPkH7/CrQHzTWCOd2MkurfNOWSOaxSHZHDhLE+MayZLsOpMg75CGIltV8am2MUsVXVJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751472720; c=relaxed/simple;
	bh=ku/1O1AIFsAJJ6qmmvnq+B5DRjf3j0x7VN0LkoGzkUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvkReZj9f64354BRmLeddQi9iPhL7zio+hYgthu6nWiRNcdWtehgnVcPEXJnXv8B/x0nMrux90G8ucYbWyJZPufbGKexITKBzNGV0boEYnx1gIuozd8wXpeqfVvYn5uiq+zKWKsVCW339/BAoKMWnKCDU83/2/jkyZfbzt6ZiHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ezpBL3ub; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-60d5c665fceso2086122eaf.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 09:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751472717; x=1752077517; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xLl0djX76uDh2KqOF+EzMvL6PoM9gvUJ0/VwerVvcuU=;
        b=ezpBL3ub40irIXQqvS2QZITGipRrqRa53fQq61zGxdt5X6TEtgcyGdC9y0eregS1oU
         QqFhUcDugTZ3uJmI8AfVVgYm1CzddOw1/7XTZBT7jjEUC039+8hKTk54ZWeCRlHJrmLs
         Kz24P0v2oDhjr5LcRBbnfgg+BKeHFTvS9qN4F7TKeMJWtXO48V2dgXGWQpb84fWuYXVU
         qK4PQocAmmNFn6q5gVTN+obC+/BbGPawqg+X7S6fJo2mMmZtNsXIT8iyAh2YcpNHyj7f
         VjTI4JjiWl5xDd44CP4sRV4jOfKq//TCG+cjZkYieoco8LA0DPYKg+84zLmAr3E0H3ah
         HTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751472717; x=1752077517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xLl0djX76uDh2KqOF+EzMvL6PoM9gvUJ0/VwerVvcuU=;
        b=pgOfrt6wlg7hw33P2c76tBHMMPK/yV0JWx/9r/ePZo9QK3PVws3Pr1yhAu01deF1y1
         In17XkW3vcz/VnHPhRFVo9MBJlhf+ArbA9NOpuns+DMysFByFo7FwINLlPsZi8ZHGFp9
         Y9T1MKof5ucfVgmHDpwH7RG+9aWJr1Ent8fOlmGtWkgkVzhHUAhzjezxDK0jLa68f1xp
         JkRwSnSuslhLfMwYcRbEx80s8LqiUZ3vNjSopsn/AsTzC42ujl2lzurN/Dwi9Ix3e/DO
         HtHo4I0+PFqyXSnwP05O5kQ79TkAEdbYPcHaynWBRMFn1M3eZKuZTg7iNdpBP38ud/Bh
         eXMg==
X-Forwarded-Encrypted: i=1; AJvYcCXqjByhKZqG80SlShiULw+cooexJAJiJZN3N97EhRk8Ni1CUwNp4xwheTO8NGLgJZdo2GE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6OblOQPem9dv1lkG/hUjAfTzNBOCyg0JPzgwfYbiDkriBT2PO
	M9PUrmu/5Xr7JiJoMrF66RgcwjL8QS8g9NgA5wwOwgUlhiIlYUqqm64+jegrsR1hvkSA2CdbCqB
	p8cmkT4Y=
X-Gm-Gg: ASbGnctJpRQl/aqeh+phz+JfFN/TkFyOMuYPqwvCWY8s7kXshYlwbo6LTt1J6yHRnCa
	2kSmdt3PF80lOK8GsQ0HvjwpUzDUVjYhlnUinj73B9055jOnQdNOq9Sc1fh2iPNX/NTu6ZiZNc+
	DRZf87dVsRjaWQRGY39RBFFHhLmTX67V7699h58t+2RdkWA1Uv5b9QSfRIa+uM2OB9CepdMomG1
	b1Xr1yzSpWiiGBqrYzRLV+iEuC7xvqb22OnuLxCWInJsHuENGCVJ4qNz3k2T4Gc9rEECE+aFjzI
	QNKQpErF1VvWvz8UFPIPlSWAUT7jgxklAsUQcO5UAOU9cGmJpN//ga3DSQFmAWFhxmqMBA==
X-Google-Smtp-Source: AGHT+IEUcyyYplg3dAlsN64/ClYT7sGu4SJixmVO5+dP9Ynt+31d1VKg5vFlMLwsobsP4aHj0c1LwQ==
X-Received: by 2002:a05:6870:e8c9:b0:2ea:8f12:5762 with SMTP id 586e51a60fabf-2f5a8d27ce5mr2546491fac.7.1751472717371;
        Wed, 02 Jul 2025 09:11:57 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:7056:ddb5:3445:864f])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2efd4ef7024sm3926135fac.13.2025.07.02.09.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 09:11:56 -0700 (PDT)
Date: Wed, 2 Jul 2025 19:11:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: lizhe.67@bytedance.com
Cc: alex.williamson@redhat.com, david@redhat.com, jgg@ziepe.ca,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev, oe-kbuild@lists.linux.dev,
	peterx@redhat.com
Subject: Re: [PATCH 3/4] vfio/type1: introduce a new member has_rsvd for
 struct vfio_dma
Message-ID: <24446bf8-3255-4622-a53c-33690c07fb17@suswa.mountain>
References: <c209cfd6-05b1-4491-91ce-c672414d718c@suswa.mountain>
 <20250702034720.53574-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250702034720.53574-1-lizhe.67@bytedance.com>

On Wed, Jul 02, 2025 at 11:47:20AM +0800, lizhe.67@bytedance.com wrote:
> On Tue, 1 Jul 2025 18:13:48 +0300, dan.carpenter@linaro.org wrote:
> 
> > New smatch warnings:
> > drivers/vfio/vfio_iommu_type1.c:788 vfio_pin_pages_remote() error: uninitialized symbol 'rsvd'.
> > 
> > Old smatch warnings:
> > drivers/vfio/vfio_iommu_type1.c:2376 vfio_iommu_type1_attach_group() warn: '&group->next' not removed from list
> > 
> > vim +/rsvd +788 drivers/vfio/vfio_iommu_type1.c
> > 
> > 8f0d5bb95f763c Kirti Wankhede  2016-11-17  684  static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> > 0635559233434a Alex Williamson 2025-02-18  685  				  unsigned long npage, unsigned long *pfn_base,
> > 4b6c33b3229678 Daniel Jordan   2021-02-19  686  				  unsigned long limit, struct vfio_batch *batch)
> > 73fa0d10d077d9 Alex Williamson 2012-07-31  687  {
> > 4d83de6da265cd Daniel Jordan   2021-02-19  688  	unsigned long pfn;
> > 4d83de6da265cd Daniel Jordan   2021-02-19  689  	struct mm_struct *mm = current->mm;
> > 6c38c055cc4c0a Alex Williamson 2016-12-30  690  	long ret, pinned = 0, lock_acct = 0;
> > 89c29def6b0101 Alex Williamson 2018-06-02  691  	bool rsvd;
> > a54eb55045ae9b Kirti Wankhede  2016-11-17  692  	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
> > 166fd7d94afdac Alex Williamson 2013-06-21  693  
> > 6c38c055cc4c0a Alex Williamson 2016-12-30  694  	/* This code path is only user initiated */
> > 4d83de6da265cd Daniel Jordan   2021-02-19  695  	if (!mm)
> > 166fd7d94afdac Alex Williamson 2013-06-21  696  		return -ENODEV;
> > 73fa0d10d077d9 Alex Williamson 2012-07-31  697  
> > 4d83de6da265cd Daniel Jordan   2021-02-19  698  	if (batch->size) {
> > 4d83de6da265cd Daniel Jordan   2021-02-19  699  		/* Leftover pages in batch from an earlier call. */
> > 4d83de6da265cd Daniel Jordan   2021-02-19  700  		*pfn_base = page_to_pfn(batch->pages[batch->offset]);
> > 4d83de6da265cd Daniel Jordan   2021-02-19  701  		pfn = *pfn_base;
> > 89c29def6b0101 Alex Williamson 2018-06-02  702  		rsvd = is_invalid_reserved_pfn(*pfn_base);
> 
> When batch->size is not zero, we initialize rsvd here.
> 
> > 4d83de6da265cd Daniel Jordan   2021-02-19  703  	} else {
> > 4d83de6da265cd Daniel Jordan   2021-02-19  704  		*pfn_base = 0;
> 
> When the value of batch->size is zero, we set the value of *pfn_base
> to zero and do not initialize rsvd for the time being.
> 
> > 5c6c2b21ecc9ad Alex Williamson 2013-06-21  705  	}
> > 5c6c2b21ecc9ad Alex Williamson 2013-06-21  706  
> > eb996eec783c1e Alex Williamson 2025-02-18  707  	if (unlikely(disable_hugepages))
> > eb996eec783c1e Alex Williamson 2025-02-18  708  		npage = 1;
> > eb996eec783c1e Alex Williamson 2025-02-18  709  
> > 4d83de6da265cd Daniel Jordan   2021-02-19  710  	while (npage) {
> > 4d83de6da265cd Daniel Jordan   2021-02-19  711  		if (!batch->size) {
> > 4d83de6da265cd Daniel Jordan   2021-02-19  712  			/* Empty batch, so refill it. */
> > eb996eec783c1e Alex Williamson 2025-02-18  713  			ret = vaddr_get_pfns(mm, vaddr, npage, dma->prot,
> > eb996eec783c1e Alex Williamson 2025-02-18  714  					     &pfn, batch);
> > be16c1fd99f41a Daniel Jordan   2021-02-19  715  			if (ret < 0)
> > 4d83de6da265cd Daniel Jordan   2021-02-19  716  				goto unpin_out;
> > 166fd7d94afdac Alex Williamson 2013-06-21  717  
> > 4d83de6da265cd Daniel Jordan   2021-02-19  718  			if (!*pfn_base) {
> > 4d83de6da265cd Daniel Jordan   2021-02-19  719  				*pfn_base = pfn;
> > 4d83de6da265cd Daniel Jordan   2021-02-19  720  				rsvd = is_invalid_reserved_pfn(*pfn_base);
> 
> Therefore, for the first loop, when batch->size is zero, *pfn_base must
> be zero, which will then lead to the initialization of rsvd.
> 

Yeah.  :/

I don't know why this warning was printed honestly.  Smatch is supposed
to figure that kind of thing out correctly.  It isn't printed on my
system.  I've tried deleting the cross function DB (which shouldn't
matter) and I'm using the published version of Smatch but I can't get it
to print.  Ah well.  My bad.  Thanks for taking a look.

regards,
dan carpenter


