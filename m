Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB39A5323B0
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 09:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiEXHJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 03:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbiEXHJZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 03:09:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 428099347F
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 00:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653376161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Jg/VQp3/7T8NXHS/IRW4J+wxsI4fOnWx/NzDoP4bWw=;
        b=caRwOIKAozokqXOur8+e21knN1plVGHYyEMeYRdnZ1lhWdqvwxTxMYjsxsKzuvzB0FJ5PZ
        Gn6evX4xG+IYvV93c+eqIW+ffvMFqKVbzK0MOSSeGbtRbM3kVIQAsusFfq7Mkze+Jjb0KY
        dYPlEgaZjK3a08mCaAulE1uiFGGKXng=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-0zbLyCKSPBeVGCN7azrMCg-1; Tue, 24 May 2022 03:09:12 -0400
X-MC-Unique: 0zbLyCKSPBeVGCN7azrMCg-1
Received: by mail-qk1-f198.google.com with SMTP id p13-20020a05620a132d00b006a362041049so6451685qkj.0
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 00:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4Jg/VQp3/7T8NXHS/IRW4J+wxsI4fOnWx/NzDoP4bWw=;
        b=gXarFl8Fhh3Bh+dkcYot37BHW90A+4FcY2+8NKCfKpFtqLBmNT9aOyHRX6SAmVM5ea
         8n7WAd8UsHG1w/xwSd8leJo8Emayk17G/6d4pCcRxB8bxrK/4XMTi5XYBd1XEaymPECq
         Iwo3/T661RuOHi7xGzSERBuCCOZAF3srkXpYac+jQsd3PHI76gCj37DQfJh2J/ovtTAH
         ySBOKlGMfd0H1xgd3i9LXZXxDAop/4KAlkDX7/BZdW+oFDFW6mjxmbFMb5rQNCi4Rwy/
         IlPI+jTzotPPWXc2gF1ugofg5TgXX1zYi0HE7Y0eCZTg5Qo+n9cWauPxw+B6D/0qrpqK
         8uXg==
X-Gm-Message-State: AOAM530lVxRXqos4eAkt2z438HINJyWRfPqWwFRxqWs34NlCIyTXoqg7
        KSODnV3AK5OOtohVnoqcT1LzeiAKqqrOGID8yeqzrOKdkqq6SLiNrjR4TORYZa12NOKhm0K52ZO
        ZHL/4zBRGLB0e
X-Received: by 2002:a05:6214:194e:b0:45a:d8e3:2d3f with SMTP id q14-20020a056214194e00b0045ad8e32d3fmr19980108qvk.59.1653376151731;
        Tue, 24 May 2022 00:09:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7GaMbEtJARwuaEZHhi6Q4+UwgAVZKJMVkhQCWvjA6aMpUiA710enlZjHGU7oXX2vN4IPk8A==
X-Received: by 2002:a05:6214:194e:b0:45a:d8e3:2d3f with SMTP id q14-20020a056214194e00b0045ad8e32d3fmr19980097qvk.59.1653376151522;
        Tue, 24 May 2022 00:09:11 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id bs40-20020a05620a472800b006a34918ea64sm6589755qkb.98.2022.05.24.00.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 00:09:10 -0700 (PDT)
Date:   Tue, 24 May 2022 09:09:00 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, dinang@xilinx.com,
        Eli Cohen <elic@nvidia.com>,
        Laurent Vivier <lvivier@redhat.com>, pabloc@xilinx.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, Cindy Lu <lulu@redhat.com>,
        ecree.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH 1/4] vdpa: Add stop operation
Message-ID: <20220524070900.ak7a5frwtezjhhrq@sgarzare-redhat>
References: <20220520172325.980884-1-eperezma@redhat.com>
 <20220520172325.980884-2-eperezma@redhat.com>
 <79089dc4-07c4-369b-826c-1c6e12edcaff@oracle.com>
 <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 09:20:14PM +0200, Eugenio Perez Martin wrote:
>On Sat, May 21, 2022 at 12:13 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>>
>> On 5/20/2022 10:23 AM, Eugenio Pérez wrote:
>> > This operation is optional: It it's not implemented, backend feature bit
>> > will not be exposed.
>> >
>> > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>> > ---
>> >   include/linux/vdpa.h | 6 ++++++
>> >   1 file changed, 6 insertions(+)
>> >
>> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>> > index 15af802d41c4..ddfebc4e1e01 100644
>> > --- a/include/linux/vdpa.h
>> > +++ b/include/linux/vdpa.h
>> > @@ -215,6 +215,11 @@ struct vdpa_map_file {
>> >    * @reset:                  Reset device
>> >    *                          @vdev: vdpa device
>> >    *                          Returns integer: success (0) or error (< 0)
>> > + * @stop:                    Stop or resume the device (optional, but it must
>> > + *                           be implemented if require device stop)
>> > + *                           @vdev: vdpa device
>> > + *                           @stop: stop (true), not stop (false)
>> > + *                           Returns integer: success (0) or error (< 0)
>> Is this uAPI meant to address all use cases described in the full blown
>> _F_STOP virtio spec proposal, such as:
>>
>> --------------%<--------------
>>
>> ...... the device MUST finish any in flight
>> operations after the driver writes STOP.  Depending on the device, it
>> can do it
>> in many ways as long as the driver can recover its normal operation 
>> if it
>> resumes the device without the need of resetting it:
>>
>> - Drain and wait for the completion of all pending requests until a
>>    convenient avail descriptor. Ignore any other posterior descriptor.
>> - Return a device-specific failure for these descriptors, so the driver
>>    can choose to retry or to cancel them.
>> - Mark them as done even if they are not, if the kind of device can
>>    assume to lose them.
>> --------------%<--------------
>>
>
>Right, this is totally underspecified in this series.
>
>I'll expand on it in the next version, but that text proposed to
>virtio-comment was complicated and misleading. I find better to get
>the previous version description. Would the next description work?
>
>```
>After the return of ioctl, the device MUST finish any pending operations like
>in flight requests. It must also preserve all the necessary state (the
>virtqueue vring base plus the possible device specific states) that is required
>for restoring in the future.

For block devices wait for all in-flight requests could take several 
time.

Could this be a problem if the caller gets stuck on this ioctl?

If it could be a problem, maybe we should use an eventfd to signal that 
the device is successfully stopped.

Thanks,
Stefano

