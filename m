Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE296814B1
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 16:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbjA3PTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 10:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238090AbjA3PTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 10:19:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFADA3B667
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 07:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675091890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=URESPY8B3rO6+zudqQ9a2I8Kc4P4ekxUO74igKr3Ygk=;
        b=iz3IYkjWKiTvImyQYrPyAr6VPGVAOeV90N2lz0Z32JAuox9Sj1tAlwQ8ldjOiZcE/6/O4P
        7+QOk/MoqPEXl2ZypcMyovRCa2ls8Sc3j6YHAAZK7kX0cuNSQyVLlymVUehk0XVLMtnZKg
        uM9Fr1WqIy5TRqlmqPNuoG8M4d4kOd8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-54-Yx1AF_y5MiaxJdkTGUbhFg-1; Mon, 30 Jan 2023 10:18:07 -0500
X-MC-Unique: Yx1AF_y5MiaxJdkTGUbhFg-1
Received: by mail-wm1-f72.google.com with SMTP id k9-20020a05600c1c8900b003dc5dec2ac6so1040593wms.4
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 07:18:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=URESPY8B3rO6+zudqQ9a2I8Kc4P4ekxUO74igKr3Ygk=;
        b=b+5mTJBIWJj1q2h/8GOMWnJPV1IrFnF/JjvNeDrotns5PCr2LCmaptjHJxPaPdPl43
         pLBgc3Z7RVx/KD5LcJ2ojCitzWoWeIfwxqARCl5U3gNTgFKbPx1W++CcCEZ78Zcoje/7
         P/kRaWdayRwk4QaF220hhOCvYdct1Bi+z/yRpadEf9PkIiAhmxJXqLsxwQrh+6vFIGTh
         INdrtkUWqX1SVgT4Es/OYoq0NCteQXBGXdTIECKsohoOU4QEyrLz9VXscqZAnGdJ2knS
         FkNhf8wphAyGa/L2dfBJHKInT6ELNELkqj3OEDCGk5FoIHbJFlsCCJc7t78LHRGZkmde
         dheQ==
X-Gm-Message-State: AO0yUKUq7Xd66QhjecJsxbVs5iqeQLgt1Ee3eLSlwMDT19RaHkSecH79
        CkigG85WF2wimqEceceBWie7Ukt0+9P28ABu+OrNMDZw6e1qXr8ICw4z/eX4AITE1UHdlp3p7Ex
        h6juIg7G6mASH
X-Received: by 2002:a05:6000:1105:b0:2bf:b77c:df72 with SMTP id z5-20020a056000110500b002bfb77cdf72mr16512192wrw.25.1675091885643;
        Mon, 30 Jan 2023 07:18:05 -0800 (PST)
X-Google-Smtp-Source: AK7set9hHGYe0bnBQdwa2LZ/rAVCRbopEtGk+crtv3OHnMIQTfwimU+PtBLrc1/FzlqOKTq9Gtug2w==
X-Received: by 2002:a05:6000:1105:b0:2bf:b77c:df72 with SMTP id z5-20020a056000110500b002bfb77cdf72mr16512171wrw.25.1675091885371;
        Mon, 30 Jan 2023 07:18:05 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id p6-20020a5d48c6000000b002bfc0558ecdsm11985935wrs.113.2023.01.30.07.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 07:18:04 -0800 (PST)
Date:   Mon, 30 Jan 2023 10:17:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 09/23] virtio_blk: use bvec_set_virt to initialize
 special_vec
Message-ID: <20230130101747-mutt-send-email-mst@kernel.org>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130092157.1759539-10-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023 at 10:21:43AM +0100, Christoph Hellwig wrote:
> Use the bvec_set_virt helper to initialize the special_vec.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
>  drivers/block/virtio_blk.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 6a77fa91742880..dc6e9b989910b0 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -170,9 +170,7 @@ static int virtblk_setup_discard_write_zeroes_erase(struct request *req, bool un
>  
>  	WARN_ON_ONCE(n != segments);
>  
> -	req->special_vec.bv_page = virt_to_page(range);
> -	req->special_vec.bv_offset = offset_in_page(range);
> -	req->special_vec.bv_len = sizeof(*range) * segments;
> +	bvec_set_virt(&req->special_vec, range, sizeof(*range) * segments);
>  	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
>  
>  	return 0;
> -- 
> 2.39.0

