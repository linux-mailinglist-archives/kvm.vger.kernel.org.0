Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB25637EDE
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 19:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiKXSUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 13:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKXSUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 13:20:49 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C756E81FB8
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 10:20:48 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id x18so1406182qki.4
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 10:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ltI6eSB4eU2L5MqLzp2IrrjYqUYQimzYEMyIzSVZsI=;
        b=jfY2Ml6YgQz8PxocVPd5lY6nd2dxAJeg1YSJEK7fLI7Fy2SRk6KGwpK3dna5XcHrMU
         ckCJhOhE2Imk9xtzjMcFG6OLCdNL7KDOdzGys86j1JthUrWHuRrKI3IyBxbyIre4ihNJ
         SaJVgKWrXv2yPeB4vczhaSDlwBXo3BjPLmEyXWMEP9hkmJo9Xvqnl4pcwjm5RFUG9Dlp
         uAr9tBz0Q+gDVG60oDIgDeBk9I6KXHLESs1HMSwHFWIxLkLkS19F6RbRsEvhrWcp/DZf
         OPb9rdvgNTq09MovYZ1mRR7z1yblsf6UBoaTkDC/wXShyFMP4t30X6hbqlQF5N6aIkbQ
         p67g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ltI6eSB4eU2L5MqLzp2IrrjYqUYQimzYEMyIzSVZsI=;
        b=7u2CZGWLAQAVhShEHOlcRKajDso+Fh/PahcN0qr0wvzq4dOlE0dyvjpXVjLq9t1K/f
         ruh4WNpNB0MlJPWkCK4DnnuPv0vB2pQ1rRKjhhdjE5qVhUDwocDL67RW6vha07RyZ3z/
         9AJFuxmXFLM1eGLxchbuI2EGbbhJKPQh9PDt/y29FeIFctr2W/nOfDvNomdL/oL15cDo
         OSj3GIyPsH+d4LTsb/5k6qbhOYPLAYx7lxymrkJlpLc5d22fy9VcCN1G2XHEsQZMaFmm
         Jy/mzprutEN8eNaTUKOZR/mCzljXTZL9wMWxCSePbOi8z26Ll93Uv2IqFeImVIlTguYJ
         ITTA==
X-Gm-Message-State: ANoB5plIFBw2TEBFDMIcNyMzEKpWBcKegMUVfWcSUzH4JDOLs0r0jFdU
        fmL6Bgi4eCu8b+yj2EuQzs0tqg==
X-Google-Smtp-Source: AA0mqf7FgsirRb5a172c1yFJxT/gKUylP8+k3zCi2cjgCs+qpVuV6q7jjB1+4VlERPd7/rf0924Tuw==
X-Received: by 2002:a05:620a:468b:b0:6fb:c039:c1aa with SMTP id bq11-20020a05620a468b00b006fbc039c1aamr27665683qkb.624.1669314047895;
        Thu, 24 Nov 2022 10:20:47 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id bs13-20020a05620a470d00b006bbc3724affsm1275458qkb.45.2022.11.24.10.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 10:20:46 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oyGq5-00CLPi-R6;
        Thu, 24 Nov 2022 14:20:45 -0400
Date:   Thu, 24 Nov 2022 14:20:45 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v1 2/2] vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
Message-ID: <Y3+1/a25zcxNT3He@ziepe.ca>
References: <20221025193114.58695-1-joao.m.martins@oracle.com>
 <20221025193114.58695-3-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025193114.58695-3-joao.m.martins@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 25, 2022 at 08:31:14PM +0100, Joao Martins wrote:
> iova_bitmap_set() doesn't consider the end of the page boundary when the
> first bitmap page offset isn't zero, and wrongly changes the consecutive
> page right after. Consequently this leads to missing dirty pages from
> reported by the device as seen from the VMM.
> 
> The current logic iterates over a given number of base pages and clamps it
> to the remaining indexes to iterate in the last page.  Instead of having to
> consider extra pages to pin (e.g. first and extra pages), just handle the
> first page as its own range and let the rest of the bitmap be handled as if
> it was base page aligned.
> 
> This is done by changing iova_bitmap_mapped_remaining() to return PAGE_SIZE
> - pgoff (on the first bitmap page), and leads to pgoff being set to 0 on
> following iterations.
> 
> Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
> Reported-by: Avihai Horon <avihaih@nvidia.com>
> Tested-by: Avihai Horon <avihaih@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
> I have a small test suite that I have been using for functional and some
> performance tests; I try to cover all the edge cases. Though I happened to
> miss having a test case (which is also fixed) ... leading to this bug.
> I wonder if this test suite is something of interest to have in
> tree?

Yes, when we move this to iommufd the test suite should be included,
either as integrated using the mock domain and the selftests or
otherwise.

This is really a problem in iova_bitmap_set(), it isn't doing the math
right.


> +	/* Cap to one page in the first iteration, if PAGE_SIZE unaligned. */

Why isn't it just 

 bitmap->mapped.npages * PAGE_SIZE - bitmap->mapped.pgoff

And fix the bug in iova_bitmap_set:

void iova_bitmap_set(struct iova_bitmap *bitmap,
		     unsigned long iova, size_t length)
{
	struct iova_bitmap_map *mapped = &bitmap->mapped;
	unsigned cur_bit =
		((iova - mapped->iova) >> mapped->pgshift) + mapped->pgoff * 8;
	unsigned long last_bit =
		(((iova + length - 1) - mapped->iova) >> mapped->pgshift) +
		mapped->pgoff * 8;

	do {
		unsigned int page_idx = cur_bit / BITS_PER_PAGE;
		unsigned int nbits =
			min(BITS_PER_PAGE - cur_bit, last_bit - cur_bit + 1);
		void *kaddr;

		kaddr = kmap_local_page(mapped->pages[page_idx]);
		bitmap_set(kaddr, cur_bit % BITS_PER_PAGE, nbits);
		kunmap_local(kaddr);
		cur_bit += nbits;
	} while (cur_bit <= last_bit);
}
EXPORT_SYMBOL_GPL(iova_bitmap_set);

Jason
