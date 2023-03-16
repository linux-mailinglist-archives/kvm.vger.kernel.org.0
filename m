Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408656BCA76
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 10:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCPJMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 05:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCPJMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 05:12:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B06526B
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 02:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678957908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3eMeY9yQN+W3p1vHqt8vyruDxKEouKBf8XoW+xN+7GI=;
        b=WTapVjnBtsf4iDkaOoK6qqtuhXhhxpgvaZXnVs/FKHfqq6gsge4yBK44zDUyr/rh7rOoOX
        TH5oOCQCZlG+cGJf6Rr1n+xiACwcsZuxfNiNq2FQVzyuLBWdGwQXqYNnIlGq9rT5ualJbQ
        EJ9Qs1ChdDUUJuNXZNUF+hFgwxbxeq8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-dBymGGe1PQCsLgX40-bFOQ-1; Thu, 16 Mar 2023 05:11:47 -0400
X-MC-Unique: dBymGGe1PQCsLgX40-bFOQ-1
Received: by mail-wm1-f69.google.com with SMTP id t1-20020a7bc3c1000000b003dfe223de49so2321765wmj.5
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 02:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678957906;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3eMeY9yQN+W3p1vHqt8vyruDxKEouKBf8XoW+xN+7GI=;
        b=6B7pJwXjm8mX9yIMS96K82GCjR5SYQhmUnoVJopZKYeWsQN/2xHEMReagjP2Eda5cH
         lxRmcnFfzyAuTBfsyerPZn25cQA6c7I1cwNLwPwy31It3m090qyakOfvdhOEM42v2CL2
         RVhyqs0Jssb8eqaL2b173kJDieBCVxIZcTOo0Sw2jvP7VHeNqiyfPY1OceR0QUk/87eZ
         STapGlcw3s9qUA0TqpXYVmoAwuNnOmeDZ2IwkVAkH1nzbK3c5iBUCamVmYBgFcW1HwZ1
         IX/5Caj4Dcb2qRPB8tdrG96pRtX9NobQVwxFq06yMp/AGLmSsum1k8OvCgDVqqMB62Sx
         NCvA==
X-Gm-Message-State: AO0yUKUZY07rRUb8LzjuzUZhEh5cHzcpFNn9RKmDtKde5WvJ6XHGeMp6
        j3clscfMoInt7NuwnVtKYtIiQf/XP/Dwy127DtNv8N4k7S/biRelWh+6I957h/iopcTY5SBZar6
        2Mjpm0VJfAzO/
X-Received: by 2002:adf:ffc4:0:b0:2ce:fd37:9392 with SMTP id x4-20020adfffc4000000b002cefd379392mr4100476wrs.45.1678957905879;
        Thu, 16 Mar 2023 02:11:45 -0700 (PDT)
X-Google-Smtp-Source: AK7set+X9DfQli3Fz2uLdFc+Z4TbWmOca2fwWfEubcClbX5Pl3I1a8rJk+NQbGboz0DJZWf/m4UJLQ==
X-Received: by 2002:adf:ffc4:0:b0:2ce:fd37:9392 with SMTP id x4-20020adfffc4000000b002cefd379392mr4100461wrs.45.1678957905562;
        Thu, 16 Mar 2023 02:11:45 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id c10-20020adfed8a000000b002cf8220cc75sm6685830wro.24.2023.03.16.02.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 02:11:45 -0700 (PDT)
Date:   Thu, 16 Mar 2023 10:11:42 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 8/8] vdpa_sim: add support for user VA
Message-ID: <20230316091142.p2ogqf3q2fsyha3l@sgarzare-redhat>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-9-sgarzare@redhat.com>
 <CACGkMEt1hBcRdh0oQYCs4meRs0mvDu9X9o-zK4aS87hrN+QPxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEt1hBcRdh0oQYCs4meRs0mvDu9X9o-zK4aS87hrN+QPxA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023 at 01:36:13PM +0800, Jason Wang wrote:
>On Thu, Mar 2, 2023 at 7:35 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> The new "use_va" module parameter (default: false) is used in
>> vdpa_alloc_device() to inform the vDPA framework that the device
>> supports VA.
>>
>> vringh is initialized to use VA only when "use_va" is true and the
>> user's mm has been bound. So, only when the bus supports user VA
>> (e.g. vhost-vdpa).
>>
>> vdpasim_mm_work_fn work is used to attach the kthread to the user
>> address space when the .bind_mm callback is invoked, and to detach
>> it when the .unbind_mm callback is invoked.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>
>> Notes:
>>     v2:
>>     - `use_va` set to true by default [Eugenio]
>>     - supported the new unbind_mm callback [Jason]
>>     - removed the unbind_mm call in vdpasim_do_reset() [Jason]
>>     - avoided to release the lock while call kthread_flush_work() since we
>>       are now using a mutex to protect the device state
>>
>>  drivers/vdpa/vdpa_sim/vdpa_sim.h |  1 +
>>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 98 +++++++++++++++++++++++++++++++-
>>  2 files changed, 97 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>> index 4774292fba8c..3a42887d05d9 100644
>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>> @@ -59,6 +59,7 @@ struct vdpasim {
>>         struct vdpasim_virtqueue *vqs;
>>         struct kthread_worker *worker;
>>         struct kthread_work work;
>> +       struct mm_struct *mm_bound;
>>         struct vdpasim_dev_attr dev_attr;
>>         /* mutex to synchronize virtqueue state */
>>         struct mutex mutex;
>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> index a28103a67ae7..eda26bc33df5 100644
>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> @@ -35,10 +35,77 @@ module_param(max_iotlb_entries, int, 0444);
>>  MODULE_PARM_DESC(max_iotlb_entries,
>>                  "Maximum number of iotlb entries for each address space. 0 means unlimited. (default: 2048)");
>>
>> +static bool use_va = true;
>> +module_param(use_va, bool, 0444);
>> +MODULE_PARM_DESC(use_va, "Enable/disable the device's ability to use VA");
>> +
>>  #define VDPASIM_QUEUE_ALIGN PAGE_SIZE
>>  #define VDPASIM_QUEUE_MAX 256
>>  #define VDPASIM_VENDOR_ID 0
>>
>> +struct vdpasim_mm_work {
>> +       struct kthread_work work;
>> +       struct mm_struct *mm;
>> +       bool bind;
>> +       int ret;
>> +};
>> +
>> +static void vdpasim_mm_work_fn(struct kthread_work *work)
>> +{
>> +       struct vdpasim_mm_work *mm_work =
>> +               container_of(work, struct vdpasim_mm_work, work);
>> +
>> +       mm_work->ret = 0;
>> +
>> +       if (mm_work->bind) {
>> +               kthread_use_mm(mm_work->mm);
>> +               //TODO: should we attach the cgroup of the mm owner?
>> +       } else {
>> +               kthread_unuse_mm(mm_work->mm);
>> +       }
>> +}
>> +
>> +static void vdpasim_worker_queue_mm(struct vdpasim *vdpasim,
>> +                                   struct vdpasim_mm_work *mm_work)
>> +{
>
>Nit: we need to tweak the name as it does flush besides queuing the work.

Yep, or split in 2 functions.

>
>> +       struct kthread_work *work = &mm_work->work;
>> +
>> +       kthread_init_work(work, vdpasim_mm_work_fn);
>> +       kthread_queue_work(vdpasim->worker, work);
>> +
>> +       kthread_flush_work(work);
>> +}
>> +
>> +static int vdpasim_worker_bind_mm(struct vdpasim *vdpasim,
>> +                                 struct mm_struct *new_mm)
>> +{
>> +       struct vdpasim_mm_work mm_work;
>> +
>> +       mm_work.mm = new_mm;
>> +       mm_work.bind = true;
>> +
>> +       vdpasim_worker_queue_mm(vdpasim, &mm_work);
>> +
>> +       if (!mm_work.ret)
>> +               vdpasim->mm_bound = new_mm;
>> +
>> +       return mm_work.ret;
>> +}
>> +
>> +static void vdpasim_worker_unbind_mm(struct vdpasim *vdpasim)
>> +{
>> +       struct vdpasim_mm_work mm_work;
>> +
>> +       if (!vdpasim->mm_bound)
>> +               return;
>> +
>> +       mm_work.mm = vdpasim->mm_bound;
>> +       mm_work.bind = false;
>
>Can we simply use mm_work.mm = NULL for unbinding?
>
>> +
>> +       vdpasim_worker_queue_mm(vdpasim, &mm_work);
>> +
>> +       vdpasim->mm_bound = NULL;
>
>And change the mm_bound in the worker?

Yep, I need to put `vdpasim` in struct vdpasim_mm_work.

I'll do in the next version.

Thanks,
Stefano

