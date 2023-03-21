Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63EE6C325A
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 14:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCUNLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 09:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjCUNLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 09:11:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CE62D75
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 06:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679404228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LHioC2Bz+LhXLt/kWCD/RKd45AYTVWaKEiEQ85K6IJk=;
        b=hg3F0gFqQL1PcWZPBBqrA0iHsDKVvjoMZifHK9qS/sUF5fRltR2NiaNGW7Umm45ntr3UN+
        DKDGOivJa4UssP2F+3wdAiqPnhviPYIM4HV7uQdY1pzDTRXDZWCklky1idg5oxznXWZKpi
        nWMwLcR3UM4VtdIKNEAcMwwhd0NaphE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-gQg3QGrOOUS7pjercg99cw-1; Tue, 21 Mar 2023 09:10:26 -0400
X-MC-Unique: gQg3QGrOOUS7pjercg99cw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC75A96DC85;
        Tue, 21 Mar 2023 13:10:25 +0000 (UTC)
Received: from localhost (unknown [10.39.193.206])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 56696140E95F;
        Tue, 21 Mar 2023 13:10:25 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Viktor Prutyanov <viktor@daynix.com>
Cc:     Jason Wang <jasowang@redhat.com>, pasic@linux.ibm.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Subject: Re: [PATCH v2] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
In-Reply-To: <20230321050719-mutt-send-email-mst@kernel.org>
Organization: Red Hat GmbH
References: <20230320232115.1940587-1-viktor@daynix.com>
 <CACGkMEu5qa2KUHti3w59DcXNxBdh8_ogZ9oW9bo1_PHwbNiCBg@mail.gmail.com>
 <CAPv0NP5wTMG=3kT_FX4xi9kGbX0Dah4qTQfFQPutWYsWvK1i-g@mail.gmail.com>
 <20230321050719-mutt-send-email-mst@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 21 Mar 2023 14:10:23 +0100
Message-ID: <87jzzamerk.fsf@redhat.com>
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

On Tue, Mar 21 2023, "Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Tue, Mar 21, 2023 at 12:00:42PM +0300, Viktor Prutyanov wrote:
>> On Tue, Mar 21, 2023 at 5:29=E2=80=AFAM Jason Wang <jasowang@redhat.com>=
 wrote:
>> >
>> > On Tue, Mar 21, 2023 at 7:21=E2=80=AFAM Viktor Prutyanov <viktor@dayni=
x.com> wrote:
>> > >
>> > > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
>> > > indicates that the driver passes extra data along with the queue
>> > > notifications.
>> > >
>> > > In a split queue case, the extra data is 16-bit available index. In a
>> > > packed queue case, the extra data is 1-bit wrap counter and 15-bit
>> > > available index.
>> > >
>> > > Add support for this feature for MMIO and PCI transports. Channel I/O
>> > > transport will not accept this feature.
>> > >
>> > > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
>> > > ---
>> > >
>> > >  v2: reject the feature in virtio_ccw, replace __le32 with u32
>> > >
>> > >  drivers/s390/virtio/virtio_ccw.c   |  4 +---
>> > >  drivers/virtio/virtio_mmio.c       | 15 ++++++++++++++-
>> > >  drivers/virtio/virtio_pci_common.c | 10 ++++++++++
>> > >  drivers/virtio/virtio_pci_common.h |  4 ++++
>> > >  drivers/virtio/virtio_pci_legacy.c |  2 +-
>> > >  drivers/virtio/virtio_pci_modern.c |  2 +-
>> > >  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
>> > >  include/linux/virtio_ring.h        |  2 ++
>> > >  include/uapi/linux/virtio_config.h |  6 ++++++
>> > >  9 files changed, 56 insertions(+), 6 deletions(-)
>> > >
>> > > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/=
virtio_ccw.c
>> > > index a10dbe632ef9..d72a59415527 100644
>> > > --- a/drivers/s390/virtio/virtio_ccw.c
>> > > +++ b/drivers/s390/virtio/virtio_ccw.c
>> > > @@ -789,9 +789,7 @@ static u64 virtio_ccw_get_features(struct virtio=
_device *vdev)
>> > >
>> > >  static void ccw_transport_features(struct virtio_device *vdev)
>> > >  {
>> > > -       /*
>> > > -        * Currently nothing to do here.
>> > > -        */
>> > > +       __virtio_clear_bit(vdev, VIRTIO_F_NOTIFICATION_DATA);
>> >
>> > Is there any restriction that prevents us from implementing
>> > VIRTIO_F_NOTIFICATION_DATA? (Spec seems doesn't limit us from this)
>>=20
>> Most likely, nothing.
>
> So pls code it up. It's the same format.

FWIW, the notification data needs to go via the third parameter of
kvm_hypercall3() in virtio_ccw_kvm_notify().

