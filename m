Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D98262EED
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 15:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgIINHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 09:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIINF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 09:05:26 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FAEC061573
        for <kvm@vger.kernel.org>; Wed,  9 Sep 2020 06:05:21 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id cr8so1410270qvb.10
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 06:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SQiYBb9hIxC2l4xPBV67YXsRJO9uNM2atVYfM8q4ou8=;
        b=pP83bq75IxsdMCDo379I0Q+Yw0WLU7W25iHcm/NAdOU4dk/3KQeaVC5V+pfGTpmjXW
         Gpn5tif/F15CgHcQb4U7ql9Dz6Wmu3MthNL9mE6Cumt4rZu5TWxsRoclfaUIXgUocGbM
         pmL17BtjKqtlTBtdvZn7TcyXLDF6awGA3i0KZA5PSqV7XqaApbdVtQPFJ7lli/EiNHqR
         9lx2zwT0jmis/pdIIn09cKsFEDH3+7X+NuQCodI5jqv2DcqEE+0DjriVNzLnm+xmdWOz
         PKMGEJCMwy2wkxLknBRVoL81kq6jouZ+wlEKsokwmO/lkusgjrBgLts5EXtZ2UQZWWFO
         Cc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SQiYBb9hIxC2l4xPBV67YXsRJO9uNM2atVYfM8q4ou8=;
        b=ZcajUf/RMnNeg/YfSn6dP7MDLijBaAQrmjYfN6AojDdZ37zXc9rrd8/EJYQh0sqCPg
         yg875thYUY/tdFtf4ckYeIi2MWwf09xQdkAnRsxhHj/ddZu2mSE9mWayh5F4meGKDPeq
         jidIx+VXH81ktsurDgv/Tv94sFZN/5xsHquFXzlycBad+S4FL/427lOr0OYMu0KF9J5M
         oit4bRQvmvGSMceHEbrmfqZiXZAg048m0ibkezkq/61u/uEREu3fXHtqmVoXPDDH0Q+U
         ydBmy50dLc1OOwfkALcAiJVov+AZ1aynq8c2v+1iRqeJ45amjaMR7hF5IATxWeEW+FSb
         c67g==
X-Gm-Message-State: AOAM5304V3e5un3MB0rXot0x6GrN5/t38+t4YxVITxOMmjmIxD50DX2R
        D2nnlfuzlSr3/fO97dNJL+0yWg==
X-Google-Smtp-Source: ABdhPJyyKUUZm4KYEm/R6Wux6480vc2XFPJDGKd9JoI86/628ERRBVCDKOZ5LZxRrcQzjhnpSrv3Ug==
X-Received: by 2002:a05:6214:1045:: with SMTP id l5mr3984047qvr.110.1599656720625;
        Wed, 09 Sep 2020 06:05:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id 192sm2534880qkm.110.2020.09.09.06.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 06:05:19 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kFzmo-003JUV-UL; Wed, 09 Sep 2020 10:05:18 -0300
Date:   Wed, 9 Sep 2020 10:05:18 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ming Mao <maoming.maoming@huawei.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, alex.williamson@redhat.com,
        akpm@linux-foundation.org, cohuck@redhat.com,
        jianjay.zhou@huawei.com, weidong.huang@huawei.com,
        peterx@redhat.com, aarcange@redhat.com, wangyunjian@huawei.com,
        willy@infradead.org, jhubbard@nvidia.com
Subject: Re: [PATCH V4 1/2] vfio dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200909130518.GE87483@ziepe.ca>
References: <20200908133204.1338-1-maoming.maoming@huawei.com>
 <20200908133204.1338-2-maoming.maoming@huawei.com>
 <20200909080114.GA8321@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909080114.GA8321@infradead.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 09, 2020 at 09:01:14AM +0100, Christoph Hellwig wrote:
> I really don't think this approach is any good.  You workaround
> a deficiency in the pin_user_pages API in one particular caller for
> one particular use case.

RDMA has the same basic issues, this should should not be solved with
workarounds in VFIO - a common API would be good

> I think you'd rather want either:
> 
>  (1) a FOLL_HUGEPAGE flag for the pin_user_pages API family that returns
>      a single struct page for any kind of huge page, which would also
>      benefit all kinds of other users rather than adding these kinds of
>      hacks to vfio.

How to use? The VMAs can have mixed page sizes so the caller would
have to somehow switch and call twice? Not sure this is faster.

>  (2) add a bvec version of the API that returns a variable size
>      "extent"

This is the best one, I think.. The IOMMU setup can have multiple page
sizes, so having largest contiguous blocks pre-computed should speed
that up.

vfio should be a win to use a sgl rather than a page list?

Especially if we can also reduce the number of pages pinned by only
pinning head pages..

> I had started on (2) a while ago, and here is branch with my code (which
> is broken and fails test, but might be a start):
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/gup-bvec
> 
> But for now I wonder if (1) is the better start, which could still be
> reused to (2) later.

What about some 'pin_user_page_sgl' as a stepping stone?

Switching from that point to bvec seems like a smaller step?

Jason
