Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30FD263405
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbgIIRNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730285AbgIIPcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 11:32:23 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBEBC0619C1
        for <kvm@vger.kernel.org>; Wed,  9 Sep 2020 08:09:42 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id cy2so1692680qvb.0
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 08:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ckIFVGgJHCBY1cA5MmiDi5JHd3+uJkL9F5APYSbHoys=;
        b=T9wd52lIzwRMDofgJUuo+3ltiFsBzzqHT/6wDAtY+6fafz/u4H1lv3ixD52RgL+iOj
         wyH+C6VA1vtepU3Oy+Sbj0BaCUERjwT4ZX1AT/GfMWxny8Us3VtNSfvMpIxmLva4fOtJ
         E30s70diwiBDOYMLWHWotNO5rafTduvCHkA6Xc28TtVrnitKOVjDGEX2dFXLZGLazsRR
         EzGzWLb/GXWD6DKD8VJAapAU6qQB83epGB2sAf3pr548O8SpcBgVoaRBzfRaUMr2RXSQ
         TaJJGGi7Gnz/5Zi1cQquUYBl7ZuBcQ1tO9BOfN6fJFHYajPqQqiKnbZ36ygsyTDWvdLq
         3A1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ckIFVGgJHCBY1cA5MmiDi5JHd3+uJkL9F5APYSbHoys=;
        b=XwQUgK42AoXUXN+iydwGnonyuOU4OSB4ATvGID78n1wICxrbYDVzGyBZ+GjXN3yU8/
         5oYRSat2kn6Z4fxTl/YUr8wDaSC2NrQOKpAHv9+9DcDgSyBJjvk8qwwiyBASzlN+o4Cx
         IiwwDzvBEfWycFuhIv5iYvTTnkPhpY0kMrfpOIjMhDYHJNJiHQBBOvxtjNuuaf5j6p7t
         bM1ZWa8/JT/sx+bF2OqzLgo4k11BXvLfPB2+D4uiyOEXlPaocwv+3ZdVA77ZLRB8SU7f
         OKyXdNFS6psQhnzWLrWIbEZ/Fv4UhNktY1TxLjDwnlSQqSaahJxSeJZt4eIEJlcJKj4W
         bs9Q==
X-Gm-Message-State: AOAM533CBt1LuWVasaBbb2/kSH/ftOS0BK7mSgOjMvUw6xfeYKmCglCW
        QetBpic3aco6v5KuypZsLUqe4Q==
X-Google-Smtp-Source: ABdhPJy90a1Sij3B0JFqI0M18Ne3sL4AB2hocicAm5yltS1FCpUYMt5qGJjgohzozkPrsosLEtpZIg==
X-Received: by 2002:a05:6214:180d:: with SMTP id o13mr4616379qvw.87.1599664181962;
        Wed, 09 Sep 2020 08:09:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id r34sm3428714qtr.18.2020.09.09.08.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 08:09:41 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kG1jA-003MI2-Ec; Wed, 09 Sep 2020 12:09:40 -0300
Date:   Wed, 9 Sep 2020 12:09:40 -0300
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
Message-ID: <20200909150940.GG87483@ziepe.ca>
References: <20200908133204.1338-1-maoming.maoming@huawei.com>
 <20200908133204.1338-2-maoming.maoming@huawei.com>
 <20200909080114.GA8321@infradead.org>
 <20200909130518.GE87483@ziepe.ca>
 <20200909142941.GA23553@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909142941.GA23553@infradead.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 09, 2020 at 03:29:41PM +0100, Christoph Hellwig wrote:
> On Wed, Sep 09, 2020 at 10:05:18AM -0300, Jason Gunthorpe wrote:
> > How to use? The VMAs can have mixed page sizes so the caller would
> > have to somehow switch and call twice? Not sure this is faster.
> 
> We can find out the page size based on the page.  Right now it is
> rather cumbersome, but one of willys pending series has a nicer helper
> for that.

So, returns a packed array of pinned head page pointers where each
element's length is determined by page_size()? 

Some maths from VA figure out the initial page offset and final page
length?

Could this representation work effectively for general DMA mapping
somehow?

Put the array in chained pages like SGL so it can efficiently cover
very large amounts of VA?

Jason
