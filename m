Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CBB6BC8C8
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 09:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCPITR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 04:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCPITO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 04:19:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2AF2BF1A
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 01:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678954653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7tgpDQ21wRopkfuNLBenzw1X+XTk1gkyJI+wV3gp8bc=;
        b=S1qn/6v7Ja79Na/SrxZ9nWggckWAZxPlTrRtqyY0O0PbpZcVrqsgw0hGLbvDILwMid0iyw
        P/B3nV3PmafHs0KjOT0UED2vSJEkMcd0q8a4snRf0oM7vxjwSjlv+BsRz7C0O07DMUvvkj
        Dqrq25Tn+D9mziEhHWTUVCQOV/J3QXU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-CVSXV7NlPzqMMdKuDB34qA-1; Thu, 16 Mar 2023 04:17:31 -0400
X-MC-Unique: CVSXV7NlPzqMMdKuDB34qA-1
Received: by mail-wm1-f69.google.com with SMTP id t1-20020a7bc3c1000000b003dfe223de49so2261100wmj.5
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 01:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678954650;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7tgpDQ21wRopkfuNLBenzw1X+XTk1gkyJI+wV3gp8bc=;
        b=VT1axXvx2+tzAvf//sue3QudNgYE3FHsNyoteFpgW2J87hM+6gl9PFpAuUBDmx42FU
         3DxiB/ti9BXEMJdmY3VZgP2sGTwSW+6LjvLlhpocNKXt/tKR2gjngKhP2YcWr9vIz2cM
         T7b59TF5uhYL3aIga3JiwMXkf7VD4iHhugQRkm68PYcodDMpYuFzbtkBmqXsF9uUZj8G
         t6EDQSlnPPUflS2/C7Y7/XcNd/dLfLEiP775Y4rp9i9oJPJXNkyrARZ2ocPppEgXlxa9
         jaZ/Z9o30aVe6BQfh1ZmsuOSOS8sAcbwfhdQIwTUYmKgOSd1lYFuGc8+xacNt352yycJ
         HDig==
X-Gm-Message-State: AO0yUKW3ZvfXalUQ1Awbw+mtjNDBstDCE1zXTVDV4Eo+vk5eiqDn2fY9
        8+n1heVN57dOn/PUgh1YahLeod2iWo6ot1MPvK3+/Oytsk+G3M9/ywoL+GFiinaT+ElDX0MDAGa
        b+sLt33jS5U0R
X-Received: by 2002:a05:600c:3c8f:b0:3ea:bc08:b63e with SMTP id bg15-20020a05600c3c8f00b003eabc08b63emr21673834wmb.2.1678954650291;
        Thu, 16 Mar 2023 01:17:30 -0700 (PDT)
X-Google-Smtp-Source: AK7set8yAXCmTlyMF4pVppmWMDqyhk0GT12h+rEm72RHUQ1OCYbXiPEGJgmkVgwCqUMwdNOtrDJ3tw==
X-Received: by 2002:a05:600c:3c8f:b0:3ea:bc08:b63e with SMTP id bg15-20020a05600c3c8f00b003eabc08b63emr21673814wmb.2.1678954650016;
        Thu, 16 Mar 2023 01:17:30 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id l26-20020a05600c2cda00b003dd1bd0b915sm4353875wmc.22.2023.03.16.01.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 01:17:29 -0700 (PDT)
Date:   Thu, 16 Mar 2023 09:17:25 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/8] vdpa: add bind_mm/unbind_mm callbacks
Message-ID: <20230316081725.2gwfgptm3lkoptwt@sgarzare-redhat>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-2-sgarzare@redhat.com>
 <CACGkMEv24Zw-OUbBBSne21pF7=4XCZ6JGj7Y_cC7cMFYTjbF1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEv24Zw-OUbBBSne21pF7=4XCZ6JGj7Y_cC7cMFYTjbF1Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023 at 11:39:42AM +0800, Jason Wang wrote:
>On Thu, Mar 2, 2023 at 7:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> These new optional callbacks is used to bind/unbind the device to
>> a specific address space so the vDPA framework can use VA when
>> these callbacks are implemented.
>>
>> Suggested-by: Jason Wang <jasowang@redhat.com>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>
>One thing that came into my mind is that after this commit:
>
>commit 5ce995f313ce56c0c62425c3ddc37c5c50fc33db
>Author: Jason Wang <jasowang@redhat.com>
>Date:   Fri May 29 16:02:59 2020 +0800
>
>    vhost: use mmgrab() instead of mmget() for non worker device
>
>    For the device that doesn't use vhost worker and use_mm(), mmget() is
>    too heavy weight and it may brings troubles for implementing mmap()
>    support for vDPA device.
>
>We don't hold the address space after this commit, so the userspace
>mapping could be invalid if the owner exits?

Thanks for mentioning it, I'll take a look at it!

In case maybe I should do a mmget (or get_task_mm) in vhost-vdpa before
calling the callback, or in the parent driver inside the callback, but
it seems duplicating code.

Thanks,
Stefano

>
>Thanks
>
>>
>> Notes:
>>     v2:
>>     - removed `struct task_struct *owner` param (unused for now, maybe
>>       useful to support cgroups) [Jason]
>>     - add unbind_mm callback [Jason]
>>
>>  include/linux/vdpa.h | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>> index 43f59ef10cc9..369c21394284 100644
>> --- a/include/linux/vdpa.h
>> +++ b/include/linux/vdpa.h
>> @@ -290,6 +290,14 @@ struct vdpa_map_file {
>>   *                             @vdev: vdpa device
>>   *                             @idx: virtqueue index
>>   *                             Returns pointer to structure device or error (NULL)
>> + * @bind_mm:                   Bind the device to a specific address space
>> + *                             so the vDPA framework can use VA when this
>> + *                             callback is implemented. (optional)
>> + *                             @vdev: vdpa device
>> + *                             @mm: address space to bind
>> + * @unbind_mm:                 Unbind the device from the address space
>> + *                             bound using the bind_mm callback. (optional)
>> + *                             @vdev: vdpa device
>>   * @free:                      Free resources that belongs to vDPA (optional)
>>   *                             @vdev: vdpa device
>>   */
>> @@ -351,6 +359,8 @@ struct vdpa_config_ops {
>>         int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
>>                               unsigned int asid);
>>         struct device *(*get_vq_dma_dev)(struct vdpa_device *vdev, u16 idx);
>> +       int (*bind_mm)(struct vdpa_device *vdev, struct mm_struct *mm);
>> +       void (*unbind_mm)(struct vdpa_device *vdev);
>>
>>         /* Free device resources */
>>         void (*free)(struct vdpa_device *vdev);
>> --
>> 2.39.2
>>
>

