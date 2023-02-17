Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711BD69A56C
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 06:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBQF7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 00:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBQF7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 00:59:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A1C2CFF8
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 21:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676613515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4AP6C42/R8qAU0hxuIDM9Qu5qLKgmQO/4/XMSMYshv0=;
        b=S5/NiHk1z4OHIjq2ZxDvxuqEfTO2n3eVSPPZi3drWBNt5fYaTxfg8Vdkegy3/a8r3QHsKH
        SqHGYYcMZy/jaT46wTWAyrn2JbGSSinSgz6d9XMOKyFaM3hP+WUu51iEjgFPXk6u850ih9
        gjYXb/yG9FjYXxHTv3+FJiEF19xTxGY=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-612-EIZ61vkzPPSLRfH8eB_NHA-1; Fri, 17 Feb 2023 00:58:33 -0500
X-MC-Unique: EIZ61vkzPPSLRfH8eB_NHA-1
Received: by mail-oi1-f197.google.com with SMTP id g31-20020a0568080ddf00b0037f89b344ebso172328oic.0
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 21:58:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4AP6C42/R8qAU0hxuIDM9Qu5qLKgmQO/4/XMSMYshv0=;
        b=UPgNYv/2HVwAEG7kxK5ODq6jptt0MRMjHRTgnKycznIOX/7ElLpgmpUBJ/0/DN3ffg
         xqYQx1g6UflJu0w08O5pWxZOgOzDHGHqAVg+mo0V4dj4iaK49iuk5FFDBKHEmy6Ij6Y2
         ZwarUCnFMyD8AuPB6vuO0knRUQjm6+3tVD1AVsAFUixRMqFMmLsFGiPTcgtlHBbxv82A
         VyO6fR5GdB3ueljeiHaKDQCSXxeMEeRqjLNvN7OagBj3h69ohoSUkaONMwGOdBccDnSd
         QTTkdj25VXsr4v48xNKWJxtgqMuw1t8gNhiRoDSO96b0QY/lvM5dbqBWXWRy2hDwtNQx
         i0zQ==
X-Gm-Message-State: AO0yUKXuisGT27L/WamAE7iQ866Ty/48tYj/Shar5JaUknym6QMsfcNt
        /xdOf0E8zQmMsREewigC3sQupId5ZPlV7QM0xeAvEACM7AbTqwjzkBGFbjRC97R7eTuejNQ9w1e
        35gBkyKt3tQLJ+qOtEgcLqPyoJwOp
X-Received: by 2002:a05:6871:84ca:b0:16a:2c1a:e416 with SMTP id sw10-20020a05687184ca00b0016a2c1ae416mr306276oab.35.1676613512983;
        Thu, 16 Feb 2023 21:58:32 -0800 (PST)
X-Google-Smtp-Source: AK7set/DTnvWghD6LBzagHT2oVxIZ6Em4f+Zu8NAzl7w3xSe64tyl3U9v4dN2LtkQFyqeyCmiGccmvpI6xdxSkvo8c8=
X-Received: by 2002:a05:6871:84ca:b0:16a:2c1a:e416 with SMTP id
 sw10-20020a05687184ca00b0016a2c1ae416mr306274oab.35.1676613512767; Thu, 16
 Feb 2023 21:58:32 -0800 (PST)
MIME-Version: 1.0
References: <20230131145310.2069-1-longpeng2@huawei.com> <db99245c-606a-2f24-52fe-836a6972437f@redhat.com>
 <35b94992-0c6b-a190-1fce-5dda9c8dcf4b@huawei.com> <CACGkMEt0Rgkcmt9k4dWsp-qqtPvrM40mtgmSERc0A7Ve1wzKHw@mail.gmail.com>
 <ad0ab6b8-1e1e-f686-eb5c-78cc63869c54@huawei.com> <CACGkMEsOWmVGA1RYTNZybmzkz53g5cYEkJeMK_9uuQu-ezZcqg@mail.gmail.com>
 <af95c38d-fdca-aef0-55ae-bbb0baee6029@huawei.com>
In-Reply-To: <af95c38d-fdca-aef0-55ae-bbb0baee6029@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 17 Feb 2023 13:58:21 +0800
Message-ID: <CACGkMEt8TL=fc6tUfb7BTXTSsLZa=K39znJcFqpNhy7Oaw5s6A@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: cleanup memory maps when closing vdpa fds
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 1:16 PM Longpeng (Mike, Cloud Infrastructure
Service Product Dept.) <longpeng2@huawei.com> wrote:
>
>
>
> =E5=9C=A8 2023/2/15 10:56, Jason Wang =E5=86=99=E9=81=93:
> > On Wed, Feb 15, 2023 at 10:49 AM Longpeng (Mike, Cloud Infrastructure
> > Service Product Dept.) <longpeng2@huawei.com> wrote:
> >>
> >>
> >>
> >> =E5=9C=A8 2023/2/15 10:00, Jason Wang =E5=86=99=E9=81=93:
> >>> On Tue, Feb 14, 2023 at 2:28 PM Longpeng (Mike, Cloud Infrastructure
> >>> Service Product Dept.) <longpeng2@huawei.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> =E5=9C=A8 2023/2/14 14:16, Jason Wang =E5=86=99=E9=81=93:
> >>>>>
> >>>>> =E5=9C=A8 2023/1/31 22:53, Longpeng(Mike) =E5=86=99=E9=81=93:
> >>>>>> From: Longpeng <longpeng2@huawei.com>
> >>>>>>
> >>>>>> We must cleanup all memory maps when closing the vdpa fds, otherwi=
se
> >>>>>> some critical resources (e.g. memory, iommu map) will leaked if th=
e
> >>>>>> userspace exits unexpectedly (e.g. kill -9).
> >>>>>
> >>>>>
> >>>>> Sounds like a bug of the kernel, should we fix there?
> >>>>>
> >>>>
> >>>> For example, the iommu map is setup when QEMU calls VHOST_IOTLB_UPDA=
TE
> >>>> ioctl and it'll be freed if QEMU calls VHOST_IOTLB_INVALIDATE ioctl.
> >>>>
> >>>> So maybe we release these resources in vdpa framework in kernel is a
> >>>> suitable choice?
> >>>
> >>> I think I need understand what does "resources" mean here:
> >>>
> >>> For iommu mapping, it should be freed by vhost_vdpa_free_domain() in
> >>> vhost_vdpa_release()?
> >>>
> >>
> >> Please consider the following lifecycle of the vdpa device:
> >>
> >> 1. vhost_vdpa_open
> >>       vhost_vdpa_alloc_domain
> >>
> >> 2. vhost_vdpa_pa_map
> >>       pin_user_pages
> >>       vhost_vdpa_map
> >>         iommu_map
> >>
> >> 3. kill QEMU
> >>
> >> 4. vhost_vdpa_release
> >>       vhost_vdpa_free_domain
> >>
> >> In this case, we have no opportunity to invoke unpin_user_pages or
> >> iommu_unmap to free the memory.
> >
> > We do:
> >
> > vhost_vdpa_cleanup()
> >      vhost_vdpa_remove_as()
> >          vhost_vdpa_iotlb_unmap()
> >              vhost_vdpa_pa_unmap()
> >                  unpin_user_pages()
> >                  vhost_vdpa_general_unmap()
> >                      iommu_unmap()
> > ?
> >
> Oh, my codebase is linux-6.2-rc2 and the commit c070c1912a8 (vhost-vdpa:
> fix an iotlb memory leak) already fixed this bug in linux-6.2-rc3.
>
> > Btw, it looks like we should call vhost_vdpa_free_domain() *after*
> > vhost_vdpa_cleanup() otherwise it's a UAF?
> >
> I think so, the v->domain is set to NULL in vhost_vdpa_free_domain(), it
> seems would trigger null-pointer access in my case.

Patch are welcomed.

Thanks

>
> > Thanks
> >
> >>
> >>> static int vhost_vdpa_release(struct inode *inode, struct file *filep=
)
> >>> {
> >>>           struct vhost_vdpa *v =3D filep->private_data;
> >>>           struct vhost_dev *d =3D &v->vdev;
> >>>
> >>>           mutex_lock(&d->mutex);
> >>>           filep->private_data =3D NULL;
> >>>           vhost_vdpa_clean_irq(v);
> >>>           vhost_vdpa_reset(v);
> >>>           vhost_dev_stop(&v->vdev);
> >>>           vhost_vdpa_free_domain(v);
> >>>           vhost_vdpa_config_put(v);
> >>>           vhost_vdpa_cleanup(v);
> >>>           mutex_unlock(&d->mutex);
> >>>
> >>>           atomic_dec(&v->opened);
> >>>           complete(&v->completion);
> >>>
> >>>           return 0;
> >>> }
> >>>
> >>>>
> >>>> By the way, Jason, can you reproduce the problem in your machine?
> >>>>
> >>>
> >>> Haven't got time in doing this but it should be the responsibility of
> >>> the author to validate this anyhow.
> >>>
> >>> Thanks
> >>>
> >>>>> Thanks
> >>>>>
> >>>>>
> >>>>>>
> >>>>>> Signed-off-by: Longpeng <longpeng2@huawei.com>
> >>>>>> ---
> >>>>>>     drivers/vhost/vdpa.c | 13 +++++++++++++
> >>>>>>     1 file changed, 13 insertions(+)
> >>>>>>
> >>>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >>>>>> index a527eeeac637..37477cffa5aa 100644
> >>>>>> --- a/drivers/vhost/vdpa.c
> >>>>>> +++ b/drivers/vhost/vdpa.c
> >>>>>> @@ -823,6 +823,18 @@ static void vhost_vdpa_unmap(struct vhost_vdp=
a *v,
> >>>>>>             vhost_vdpa_remove_as(v, asid);
> >>>>>>     }
> >>>>>> +static void vhost_vdpa_clean_map(struct vhost_vdpa *v)
> >>>>>> +{
> >>>>>> +    struct vhost_vdpa_as *as;
> >>>>>> +    u32 asid;
> >>>>>> +
> >>>>>> +    for (asid =3D 0; asid < v->vdpa->nas; asid++) {
> >>>>>> +        as =3D asid_to_as(v, asid);
> >>>>>> +        if (as)
> >>>>>> +            vhost_vdpa_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
> >>>>>> +    }
> >>>>>> +}
> >>>>>> +
> >>>>>>     static int vhost_vdpa_va_map(struct vhost_vdpa *v,
> >>>>>>                      struct vhost_iotlb *iotlb,
> >>>>>>                      u64 iova, u64 size, u64 uaddr, u32 perm)
> >>>>>> @@ -1247,6 +1259,7 @@ static int vhost_vdpa_release(struct inode
> >>>>>> *inode, struct file *filep)
> >>>>>>         vhost_vdpa_clean_irq(v);
> >>>>>>         vhost_vdpa_reset(v);
> >>>>>>         vhost_dev_stop(&v->vdev);
> >>>>>> +    vhost_vdpa_clean_map(v);
> >>>>>>         vhost_vdpa_free_domain(v);
> >>>>>>         vhost_vdpa_config_put(v);
> >>>>>>         vhost_vdpa_cleanup(v);
> >>>>>
> >>>>> .
> >>>>
> >>>
> >>> .
> >>
> >
> > .
>

