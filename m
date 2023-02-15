Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0325669749A
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 03:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjBOC5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 21:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjBOC5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 21:57:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55D42CFD0
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 18:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676429820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mXtgX5Vk2h3WIcUJAdVP4BZOumGxRu9HOZsfurPg6EA=;
        b=XDEWIhYzkC7VF7mywTTuuDRUEhmDv/7Z+TW5ASR0vLOMgAeHswwp0IxxzuEY3sYgCyjh/0
        qSV8W/CKo5Y3tkjn3XNuML2rjzHy5l3Je9bidR/iPmc3tsUwGoEvpfYDh2dCW4MrqQmcG6
        monQe2Ur17Va02RvfLnAV9Y9CQELD40=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-628-pyUBwTFcNLKgNn-_sJdSVQ-1; Tue, 14 Feb 2023 21:56:58 -0500
X-MC-Unique: pyUBwTFcNLKgNn-_sJdSVQ-1
Received: by mail-oi1-f197.google.com with SMTP id du3-20020a056808628300b00364c7610c6aso3442379oib.6
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 18:56:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mXtgX5Vk2h3WIcUJAdVP4BZOumGxRu9HOZsfurPg6EA=;
        b=sszU404gaee4NEdsSIedomq5DCI6hVFgFuit7UX7KEYHnxIG85IAxCmyW7gf8u8igB
         YKCXFTlX0VePtrfkMb+8Le+6Lt1rGRWMJExwJDIfTSMl6cAdUIyYmVEfU1qXmFWMRqCf
         ubUWvAe84aP+/g3j5gmiOr969OgAJzkC14OqkkNY4N/e7YCMTj1/ePVnUqYIESzqV3Sv
         uEteUGvNArJBRarGgsUuQKzrgR62FG2mSbmwUCXKM3zsIGdT6DPZpywABOAvp3yC0MqU
         A8yqmk6FEESIhsQne+xRC7dwW96QWhKGdG+UoRy+f2UcNBR2aNQ1eT3WAl1py2DEP0yh
         VDQQ==
X-Gm-Message-State: AO0yUKVWpqIDmSDQ2ge7YXoS5rRt36ultS+w7ibr7gxoZ8a/l5yhbgGM
        IAJ01TUj6TlYmWrIE3BCF/geh1/cULuqBjdMOEQWQwmBJRKSwEDOZm//h6WODVkAWmCtuXM1q4T
        rwtQjtlprSDvlwlbXzACnlJOC0kbV
X-Received: by 2002:a9d:62e:0:b0:68b:cbcf:c24b with SMTP id 43-20020a9d062e000000b0068bcbcfc24bmr38211otn.4.1676429818127;
        Tue, 14 Feb 2023 18:56:58 -0800 (PST)
X-Google-Smtp-Source: AK7set+DrpHnZ9E7DqN5CM1RUFJnBP54MzJQLr0RZB9+OZFABcaKeLjC/2nGjj6vR1Zfy1ETJ3ecoA4Ek43x1WjGjeA=
X-Received: by 2002:a9d:62e:0:b0:68b:cbcf:c24b with SMTP id
 43-20020a9d062e000000b0068bcbcfc24bmr38208otn.4.1676429817882; Tue, 14 Feb
 2023 18:56:57 -0800 (PST)
MIME-Version: 1.0
References: <20230131145310.2069-1-longpeng2@huawei.com> <db99245c-606a-2f24-52fe-836a6972437f@redhat.com>
 <35b94992-0c6b-a190-1fce-5dda9c8dcf4b@huawei.com> <CACGkMEt0Rgkcmt9k4dWsp-qqtPvrM40mtgmSERc0A7Ve1wzKHw@mail.gmail.com>
 <ad0ab6b8-1e1e-f686-eb5c-78cc63869c54@huawei.com>
In-Reply-To: <ad0ab6b8-1e1e-f686-eb5c-78cc63869c54@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 15 Feb 2023 10:56:46 +0800
Message-ID: <CACGkMEsOWmVGA1RYTNZybmzkz53g5cYEkJeMK_9uuQu-ezZcqg@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 10:49 AM Longpeng (Mike, Cloud Infrastructure
Service Product Dept.) <longpeng2@huawei.com> wrote:
>
>
>
> =E5=9C=A8 2023/2/15 10:00, Jason Wang =E5=86=99=E9=81=93:
> > On Tue, Feb 14, 2023 at 2:28 PM Longpeng (Mike, Cloud Infrastructure
> > Service Product Dept.) <longpeng2@huawei.com> wrote:
> >>
> >>
> >>
> >> =E5=9C=A8 2023/2/14 14:16, Jason Wang =E5=86=99=E9=81=93:
> >>>
> >>> =E5=9C=A8 2023/1/31 22:53, Longpeng(Mike) =E5=86=99=E9=81=93:
> >>>> From: Longpeng <longpeng2@huawei.com>
> >>>>
> >>>> We must cleanup all memory maps when closing the vdpa fds, otherwise
> >>>> some critical resources (e.g. memory, iommu map) will leaked if the
> >>>> userspace exits unexpectedly (e.g. kill -9).
> >>>
> >>>
> >>> Sounds like a bug of the kernel, should we fix there?
> >>>
> >>
> >> For example, the iommu map is setup when QEMU calls VHOST_IOTLB_UPDATE
> >> ioctl and it'll be freed if QEMU calls VHOST_IOTLB_INVALIDATE ioctl.
> >>
> >> So maybe we release these resources in vdpa framework in kernel is a
> >> suitable choice?
> >
> > I think I need understand what does "resources" mean here:
> >
> > For iommu mapping, it should be freed by vhost_vdpa_free_domain() in
> > vhost_vdpa_release()?
> >
>
> Please consider the following lifecycle of the vdpa device:
>
> 1. vhost_vdpa_open
>      vhost_vdpa_alloc_domain
>
> 2. vhost_vdpa_pa_map
>      pin_user_pages
>      vhost_vdpa_map
>        iommu_map
>
> 3. kill QEMU
>
> 4. vhost_vdpa_release
>      vhost_vdpa_free_domain
>
> In this case, we have no opportunity to invoke unpin_user_pages or
> iommu_unmap to free the memory.

We do:

vhost_vdpa_cleanup()
    vhost_vdpa_remove_as()
        vhost_vdpa_iotlb_unmap()
            vhost_vdpa_pa_unmap()
                unpin_user_pages()
                vhost_vdpa_general_unmap()
                    iommu_unmap()
?

Btw, it looks like we should call vhost_vdpa_free_domain() *after*
vhost_vdpa_cleanup() otherwise it's a UAF?

Thanks

>
> > static int vhost_vdpa_release(struct inode *inode, struct file *filep)
> > {
> >          struct vhost_vdpa *v =3D filep->private_data;
> >          struct vhost_dev *d =3D &v->vdev;
> >
> >          mutex_lock(&d->mutex);
> >          filep->private_data =3D NULL;
> >          vhost_vdpa_clean_irq(v);
> >          vhost_vdpa_reset(v);
> >          vhost_dev_stop(&v->vdev);
> >          vhost_vdpa_free_domain(v);
> >          vhost_vdpa_config_put(v);
> >          vhost_vdpa_cleanup(v);
> >          mutex_unlock(&d->mutex);
> >
> >          atomic_dec(&v->opened);
> >          complete(&v->completion);
> >
> >          return 0;
> > }
> >
> >>
> >> By the way, Jason, can you reproduce the problem in your machine?
> >>
> >
> > Haven't got time in doing this but it should be the responsibility of
> > the author to validate this anyhow.
> >
> > Thanks
> >
> >>> Thanks
> >>>
> >>>
> >>>>
> >>>> Signed-off-by: Longpeng <longpeng2@huawei.com>
> >>>> ---
> >>>>    drivers/vhost/vdpa.c | 13 +++++++++++++
> >>>>    1 file changed, 13 insertions(+)
> >>>>
> >>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >>>> index a527eeeac637..37477cffa5aa 100644
> >>>> --- a/drivers/vhost/vdpa.c
> >>>> +++ b/drivers/vhost/vdpa.c
> >>>> @@ -823,6 +823,18 @@ static void vhost_vdpa_unmap(struct vhost_vdpa =
*v,
> >>>>            vhost_vdpa_remove_as(v, asid);
> >>>>    }
> >>>> +static void vhost_vdpa_clean_map(struct vhost_vdpa *v)
> >>>> +{
> >>>> +    struct vhost_vdpa_as *as;
> >>>> +    u32 asid;
> >>>> +
> >>>> +    for (asid =3D 0; asid < v->vdpa->nas; asid++) {
> >>>> +        as =3D asid_to_as(v, asid);
> >>>> +        if (as)
> >>>> +            vhost_vdpa_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
> >>>> +    }
> >>>> +}
> >>>> +
> >>>>    static int vhost_vdpa_va_map(struct vhost_vdpa *v,
> >>>>                     struct vhost_iotlb *iotlb,
> >>>>                     u64 iova, u64 size, u64 uaddr, u32 perm)
> >>>> @@ -1247,6 +1259,7 @@ static int vhost_vdpa_release(struct inode
> >>>> *inode, struct file *filep)
> >>>>        vhost_vdpa_clean_irq(v);
> >>>>        vhost_vdpa_reset(v);
> >>>>        vhost_dev_stop(&v->vdev);
> >>>> +    vhost_vdpa_clean_map(v);
> >>>>        vhost_vdpa_free_domain(v);
> >>>>        vhost_vdpa_config_put(v);
> >>>>        vhost_vdpa_cleanup(v);
> >>>
> >>> .
> >>
> >
> > .
>

