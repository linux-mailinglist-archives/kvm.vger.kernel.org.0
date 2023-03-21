Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9684D6C35B5
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjCUPb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCUPby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:31:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D24C19F17
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679412662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q72wB1AnB+EZXK6jJvM3m9PVX7bBBgcDpGR6RAoFAUA=;
        b=Y3mxkH/9+YRr4t3t5n5ANXpZMYGPRVf4zBqv+mrM1Or+v2BnopdCIbaEz0IwWcTuO4tddY
        UcU7etY39NIpUDPLHNUrbjeBSEot0memLnPq6P+Vac+gF1Z4oBwdliNUXmubcICp0fp2aD
        9c/VbXf8+W7WAEQet3/L/D8x9a9APq0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-NtOcONy6NzGPM3RiV2GI8g-1; Tue, 21 Mar 2023 11:31:01 -0400
X-MC-Unique: NtOcONy6NzGPM3RiV2GI8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A34685531E;
        Tue, 21 Mar 2023 15:31:00 +0000 (UTC)
Received: from localhost (unknown [10.39.193.206])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 765751410F1C;
        Tue, 21 Mar 2023 15:30:58 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Viktor Prutyanov <viktor@daynix.com>
Cc:     mst@redhat.com, jasowang@redhat.com, pasic@linux.ibm.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Subject: Re: [PATCH v3] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
In-Reply-To: <CAPv0NP6Ep4-B7cMc285E3d3vYjgwO7O1pq5sG3OYYAoZd3EAYQ@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230321134410.2097163-1-viktor@daynix.com>
 <87h6uem9qc.fsf@redhat.com>
 <CAPv0NP6Ep4-B7cMc285E3d3vYjgwO7O1pq5sG3OYYAoZd3EAYQ@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 21 Mar 2023 16:30:57 +0100
Message-ID: <87bkkmm89a.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21 2023, Viktor Prutyanov <viktor@daynix.com> wrote:

> On Tue, Mar 21, 2023 at 5:59=E2=80=AFPM Cornelia Huck <cohuck@redhat.com>=
 wrote:
>>
>> On Tue, Mar 21 2023, Viktor Prutyanov <viktor@daynix.com> wrote:
>>
>> > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
>> > indicates that the driver passes extra data along with the queue
>> > notifications.
>> >
>> > In a split queue case, the extra data is 16-bit available index. In a
>> > packed queue case, the extra data is 1-bit wrap counter and 15-bit
>> > available index.
>> >
>> > Add support for this feature for MMIO, PCI and channel I/O transports.
>> >
>> > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
>> > ---
>> >  v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_sh=
adow,
>> >     remove byte swap, rename to vring_notification_data
>> >  v2: reject the feature in virtio_ccw, replace __le32 with u32
>> >
>> >  drivers/s390/virtio/virtio_ccw.c   |  4 +++-
>> >  drivers/virtio/virtio_mmio.c       | 14 +++++++++++++-
>> >  drivers/virtio/virtio_pci_common.c | 10 ++++++++++
>> >  drivers/virtio/virtio_pci_common.h |  4 ++++
>> >  drivers/virtio/virtio_pci_legacy.c |  2 +-
>> >  drivers/virtio/virtio_pci_modern.c |  2 +-
>> >  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
>> >  include/linux/virtio_ring.h        |  2 ++
>> >  include/uapi/linux/virtio_config.h |  6 ++++++
>> >  9 files changed, 57 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/vi=
rtio_ccw.c
>> > index 954fc31b4bc7..c33172c5b8d5 100644
>> > --- a/drivers/s390/virtio/virtio_ccw.c
>> > +++ b/drivers/s390/virtio/virtio_ccw.c
>> > @@ -396,13 +396,15 @@ static bool virtio_ccw_kvm_notify(struct virtque=
ue *vq)
>> >       struct virtio_ccw_vq_info *info =3D vq->priv;
>> >       struct virtio_ccw_device *vcdev;
>> >       struct subchannel_id schid;
>> > +     u32 data =3D __virtio_test_bit(vq->vdev, VIRTIO_F_NOTIFICATION_D=
ATA) ?
>> > +                     vring_notification_data(vq) : vq->index;
>> >
>> >       vcdev =3D to_vc_device(info->vq->vdev);
>> >       ccw_device_get_schid(vcdev->cdev, &schid);
>> >       BUILD_BUG_ON(sizeof(struct subchannel_id) !=3D sizeof(unsigned i=
nt));
>> >       info->cookie =3D kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
>> >                                     *((unsigned int *)&schid),
>> > -                                   vq->index, info->cookie);
>> > +                                   data, info->cookie);
>> >       if (info->cookie < 0)
>> >               return false;
>> >       return true;
>> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio=
.c
>> > index 3ff746e3f24a..7c16e622c33d 100644
>> > --- a/drivers/virtio/virtio_mmio.c
>> > +++ b/drivers/virtio/virtio_mmio.c
>> > @@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
>> >       return true;
>> >  }
>> >
>> > +static bool vm_notify_with_data(struct virtqueue *vq)
>> > +{
>> > +     struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vq->=
vdev);
>> > +     u32 data =3D vring_notification_data(vq);
>> > +
>> > +     writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
>>
>> Can't you simply use the same method as for ccw, i.e. use one callback
>> function that simply writes one value or the other?
>
> The idea is to eliminate the conditional branch induced by feature bit
> testing from the notification function. Probably, this can be done in
> the same way in ccw.

Hm, how noticable is that branch? IOW, is it worth making the code less
readable for this?

(In any case, all transports probably should use the same method.)

