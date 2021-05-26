Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAF9390E61
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 04:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhEZCnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 22:43:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232303AbhEZCnX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 22:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621996912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bc/2MmUW+pgbFW2qFMtYQUjTQyUaBFo1vkB8ZkWRL6s=;
        b=Tk9XfSFrDKoUeNyGLEH6/pHkXySqidyDvK9SDOldMYqjtqNs4uQRkL0P78GH623yxptzb1
        eXiVKxDalEXIMRSlGma4NQn6MYfhc6cgkvX8cZ0fcl7+cdcq/8E49kX0uzPoJOYZHu5SdX
        cX10f0BOJbSUCnfd7uAmqr/OTmK6Jbc=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-b0R5RW27ODWJ5v2GOW6rwQ-1; Tue, 25 May 2021 22:41:50 -0400
X-MC-Unique: b0R5RW27ODWJ5v2GOW6rwQ-1
Received: by mail-pg1-f200.google.com with SMTP id m68-20020a6326470000b029020f37ad2901so22375237pgm.7
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 19:41:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bc/2MmUW+pgbFW2qFMtYQUjTQyUaBFo1vkB8ZkWRL6s=;
        b=ZTPOIufgdlmpm/nBHUhDFbX3WosPZ4j5MgF1ZWdyikzCbsH2GpPUbxQYTdYs/Vk5ZT
         zW+M8wFYB3DVo2T6CD0vo8Sj8PLN1cOOefVGBjRGfWr7FKAbo5fbu0x57iMG4VizNc0P
         6C+404AbmRBjPrGK3n1V4q5HcpxNyYu+0+Sw3WHHmD07O6zJhefatrSnkVvvlZcs8vzR
         /J1JXZbo2ixgDHYgtOMxj3Nxh8q1jz5PGe3ui/TYlpmcIZW6Ats8YRqk9gfgQd6EajSE
         2wb1HGplw5uqVdHUZ9eux5FgKFqPPJTmcU5JEOwHFXfmKgWWffFj5282v+wxjIotL2A0
         TFFw==
X-Gm-Message-State: AOAM530VwerdC27RsLFqjurLbCtUE/s0veIGvSY0L3hn4whcRCN7t2Qq
        5Fz/YKeO/e59cKPygEK9YE2OACBi+xR8qP3XEzyu3kFtU8V0sOZ5NTsKGrlfiUzG1xCiQj4gaGp
        OR2tDdNrKLms0
X-Received: by 2002:a62:ab10:0:b029:2e8:d5a8:d635 with SMTP id p16-20020a62ab100000b02902e8d5a8d635mr15164699pff.74.1621996909406;
        Tue, 25 May 2021 19:41:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdM51fqapZ+TAydQBf1YBCQBeMJGeM8QJFnRIR/jK472sF6Fh8jpb1mmntXjLVehm11MPEGA==
X-Received: by 2002:a62:ab10:0:b029:2e8:d5a8:d635 with SMTP id p16-20020a62ab100000b02902e8d5a8d635mr15164685pff.74.1621996909140;
        Tue, 25 May 2021 19:41:49 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a8sm14716088pfk.11.2021.05.25.19.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 19:41:48 -0700 (PDT)
Subject: Re: [PATCH v7 05/12] virtio_scsi: Add validation for residual bytes
 from response
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-6-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <94abb1de-921d-8bf2-4cfc-55c7fc86c5a0@redhat.com>
Date:   Wed, 26 May 2021 10:41:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210517095513.850-6-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/5/17 ÏÂÎç5:55, Xie Yongji Ð´µÀ:
> This ensures that the residual bytes in response (might come
> from an untrusted device) will not exceed the data buffer length.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/scsi/virtio_scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index efcaf0674c8d..ad7d8cecec32 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -97,7 +97,7 @@ static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
>   static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
>   {
>   	if (resid)
> -		scsi_set_resid(sc, resid);
> +		scsi_set_resid(sc, min(resid, scsi_bufflen(sc)));
>   }
>   
>   /*


Acked-by: Jason Wang <jasowang@redhat.com>


