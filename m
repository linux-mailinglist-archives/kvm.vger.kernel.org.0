Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACEB641185
	for <lists+kvm@lfdr.de>; Sat,  3 Dec 2022 00:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiLBXcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 18:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbiLBXco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 18:32:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A3BDC852
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 15:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670023903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qjSR1M97GsLkCw1f1F0aNrEffSGd/N75Xh2LF2EhiHs=;
        b=M/QIjhpFWSmw1x+gj25Tq+YrFgC4Te4GyN8Nv+2hXA8m/lSkqdRYmA9y7oHBdgHlPzMQSC
        eXTQsHD0rsAxVNQLRLyr5AI1IwQD8bhkxG7wIF8Vmj+wAhbGBnbO+Bx2cGiOeMgtKqmIQ1
        ocH+48tE5SzK0l25O0ZMLq4ODiN7heY=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-GwsdYlmrOg6cPB8Da_UwkA-1; Fri, 02 Dec 2022 18:31:42 -0500
X-MC-Unique: GwsdYlmrOg6cPB8Da_UwkA-1
Received: by mail-il1-f198.google.com with SMTP id y12-20020a056e021bec00b00302a7d5bc83so6832351ilv.16
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 15:31:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjSR1M97GsLkCw1f1F0aNrEffSGd/N75Xh2LF2EhiHs=;
        b=STWrOpFR8Y/4aK42f7CNYBuUXieNW25KRyP0fur1bKQHD7sAAeCvkFa+Dde4TaNMvW
         FpRhzhryYgQRGY9dn40VKs834xYfDHlHXWbHF48oRmoM9VxWbIViwI7P6U3UvdXJSOWM
         vPW/GMqnLCAI7TYQ55k3LmoBIMYGfQlyyTkNzL5sllR286Qlwfllr5Ha4NeXqtjh8HaD
         DuTPRkGhXne6kyxWwfVQlRWarlfoG15F4jAoY3JkuZzR4EMxJmr074Yt/BV1YRbiKf3c
         cE90V51eBjMo7A/pjglRLAJK6+UOprNOpyN2eDMPeA9PnT0nG2hGy9i1A3zqF2OTYztY
         m5UQ==
X-Gm-Message-State: ANoB5pkLrQosq4cAluk2GIjPLD4PX1XIoAvYRVYyfZs+Cum6tloXY31Y
        xf36Qmo678QbNwF2Po1YxhS+Et2BAcQmy5ppSK1M5l0bTg5H2urAwA8HG9aOhs4gm4sljHZxZSt
        y99/WR+5YOaNv
X-Received: by 2002:a02:6a26:0:b0:389:d02c:7e4c with SMTP id l38-20020a026a26000000b00389d02c7e4cmr15760327jac.218.1670023901936;
        Fri, 02 Dec 2022 15:31:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4UJutKQHtqhdI5bG+awzAArYAFUxFWfPU6PK+0gtysZdCjZw9rAh4eau7h+OH3TB7BubYgQA==
X-Received: by 2002:a02:6a26:0:b0:389:d02c:7e4c with SMTP id l38-20020a026a26000000b00389d02c7e4cmr15760324jac.218.1670023901721;
        Fri, 02 Dec 2022 15:31:41 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n32-20020a027120000000b003733e2ce4e8sm3088052jac.59.2022.12.02.15.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 15:31:41 -0800 (PST)
Date:   Fri, 2 Dec 2022 16:31:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2] vfio/iova_bitmap: refactor iova_bitmap_set() to
 better handle page boundaries
Message-ID: <20221202163139.3dcf7884.alex.williamson@redhat.com>
In-Reply-To: <20221129131235.38880-1-joao.m.martins@oracle.com>
References: <20221129131235.38880-1-joao.m.martins@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Nov 2022 13:12:35 +0000
Joao Martins <joao.m.martins@oracle.com> wrote:

> Commit f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
> had fixed the unaligned bitmaps by capping the remaining iterable set at
> the start of the bitmap. Although, that mistakenly worked around
> iova_bitmap_set() incorrectly setting bits across page boundary.
> 
> Fix this by reworking the loop inside iova_bitmap_set() to iterate over a
> range of bits to set (cur_bit .. last_bit) which may span different pinned
> pages, thus updating @page_idx and @offset as it sets the bits. The
> previous cap to the first page is now adjusted to be always accounted
> rather than when there's only a non-zero pgoff.
> 
> While at it, make @page_idx , @offset and @nbits to be unsigned int given
> that it won't be more than 512 and 4096 respectively (even a bigger
> PAGE_SIZE or a smaller struct page size won't make this bigger than the
> above 32-bit max). Also, delete the stale kdoc on Return type.
> 
> Cc: Avihai Horon <avihaih@nvidia.com>
> Fixes: f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
> Changes since v1:
>  * Add Reviewed-by by Jason Gunthorpe
>  * Add Fixes tag (Alex Williamson)
> 
> It passes my tests but to be extra sure: Avihai could you take this
> patch a spin in your rig/tests as well? Thanks!
> ---
>  drivers/vfio/iova_bitmap.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)

Applied to vfio next branch for v6.2 with Avihai's tested-by.  Thanks,

Alex

