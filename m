Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A6963B4F2
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiK1Wt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbiK1WtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:49:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FFB24978
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 14:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669675698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7TlrGEL2bnBz6a3SuEwpVSmuKbTVP4SKXwIvKUVULuY=;
        b=VAb1vH3ksf90zGmM8MNd3dh1IeGEs664nnjtYFtUy8nMd9OLTWIKc92u6l9XxPoHGaXljf
        qVh0A7MjnUkdAqnaH/VJHPAErzcgDR53GWmkH9XZWZRy5wdYVnnxHp2O5cs2PPkU1tOx+y
        eOgj6x4dwB+E/WnnpOf9W+wSLbU/Xds=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-435-huSzRoEBN8KKtYJTGHLudQ-1; Mon, 28 Nov 2022 17:48:16 -0500
X-MC-Unique: huSzRoEBN8KKtYJTGHLudQ-1
Received: by mail-io1-f72.google.com with SMTP id q197-20020a6b8ece000000b006de79f67604so7014652iod.13
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 14:48:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7TlrGEL2bnBz6a3SuEwpVSmuKbTVP4SKXwIvKUVULuY=;
        b=x+5A3tqpVtU15pTR6d6C7Nf/FBjg40PGSwLtID53ehRmBWn1DQ4iah2hztbPOS79LM
         idkT/tZSPXrQqpLTrrDchSLlnm9rcy+5SdyYtMceXbu6UJcl4VlCHGt21VjFkk3Z/Twm
         OkLvEi3UINwnyh/M8XGh/09faY21hBvXzt+QKmt4MjXyEcgRtWp3FSX5T4OmQSEqcCeJ
         mPeuo04RIGPD4arwORgC0IQoeirYqGAv6/byKgHx2uc/sXJbo5WED4mCcrv7kJfz0zXc
         uAC1c+hSZYUJu312HxVM0LOUI0lAOv+UP5YSd4JEhVkOppleeyTJKHsYkJZZzq2UTYdi
         AZWg==
X-Gm-Message-State: ANoB5pn3Vkt2dz8mTNbDRVHDOap4WI4g5oONX+Fu2hNz2niqxg8bNfpU
        Hwc0aniEVm4GMpm64gpuooY9PQO3PY7DY+bQHn77jBGNs7sVDZ2iF2NT4uKkBbKZVZXVCJKri5f
        ImpPtNV+RY0RJ
X-Received: by 2002:a92:c84d:0:b0:302:eed9:c605 with SMTP id b13-20020a92c84d000000b00302eed9c605mr10808187ilq.49.1669675695909;
        Mon, 28 Nov 2022 14:48:15 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5o+B1HG1b+ZlJErcdZNB5WdZKPwqnV+jw+ayBI/sKI+clFW481Djt3dh1QaWcUijc9fFuxww==
X-Received: by 2002:a92:c84d:0:b0:302:eed9:c605 with SMTP id b13-20020a92c84d000000b00302eed9c605mr10808178ilq.49.1669675695695;
        Mon, 28 Nov 2022 14:48:15 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f22-20020a056638169600b00389dbc74fc5sm1893560jat.78.2022.11.28.14.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 14:48:14 -0800 (PST)
Date:   Mon, 28 Nov 2022 15:48:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH] vfio/iova_bitmap: refactor iova_bitmap_set() to better
 handle page boundaries
Message-ID: <20221128154812.48061660.alex.williamson@redhat.com>
In-Reply-To: <77c2ba5a-2b5c-9a47-32ae-13e5a6960d05@oracle.com>
References: <20221125172956.19975-1-joao.m.martins@oracle.com>
        <20221128121240.333d679d.alex.williamson@redhat.com>
        <77c2ba5a-2b5c-9a47-32ae-13e5a6960d05@oracle.com>
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

On Mon, 28 Nov 2022 19:22:10 +0000
Joao Martins <joao.m.martins@oracle.com> wrote:

> On 28/11/2022 19:12, Alex Williamson wrote:
> > On Fri, 25 Nov 2022 17:29:56 +0000
> > Joao Martins <joao.m.martins@oracle.com> wrote:
> >   
> >> Commit f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
> >> had fixed the unaligned bitmaps by capping the remaining iterable set at
> >> the start of the bitmap. Although, that mistakenly worked around
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >> iova_bitmap_set() incorrectly setting bits across page boundary.
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>
> >> Fix this by reworking the loop inside iova_bitmap_set() to iterate over a
     ^^^^^^^^^^^...
> >> range of bits to set (cur_bit .. last_bit) which may span different pinned
> >> pages, thus updating @page_idx and @offset as it sets the bits. The
> >> previous cap to the first page is now adjusted to be always accounted
> >> rather than when there's only a non-zero pgoff.
> >>
> >> While at it, make @page_idx , @offset and @nbits to be unsigned int given
> >> that it won't be more than 512 and 4096 respectively (even a bigger
> >> PAGE_SIZE or a smaller struct page size won't make this bigger than the
> >> above 32-bit max). Also, delete the stale kdoc on Return type.
> >>
> >> Cc: Avihai Horon <avihaih@nvidia.com>
> >> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> >> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>  
> > 
> > Should this have:
> > 
> > Fixes: f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
> > 
> > ?  
> 
> I was at two minds with the Fixes tag.
> 
> The commit you referenced above is still a fix (or workaround), this patch is a
> better fix that superseeds as opposed to fixing a bug that commit f38044e5ef58
> introduced. So perhaps the right one ought to be:
> 
> Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")

The above highlighted text certainly suggests that there's a fix to
f38044e5ef58 here.  We might still be iterating on a problem that was
originally introduced in 58ccf0190d19, but this more directly addresses
the version of that problem that exists after f38044e5ef58.  I think
it's more helpful for backporters to see this progression rather than
two patches claiming to fix the same commit with one depending on
another.  If you'd rather that stable have a different backport that
short circuits the interim fix in f38044e5ef58, that could be posted
separately, but imo it's better to follow the mainline progression.
Thanks,

Alex

