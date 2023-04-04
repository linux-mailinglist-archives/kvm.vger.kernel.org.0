Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC74B6D6B5C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbjDDSRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbjDDSRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:17:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079DD46BF
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680632194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IteB3h1IFF9JrrwNNhJrcSxfFKVKvFn7WIKCluRji64=;
        b=T+aNbcTj0PM/4p7mCXMgq544SU8syIAaVzklZpnQiUMQnYz7EG8Aux7Um+kYCegnj/TKCo
        OqxjrWt4KnE457XBa44g+ZUUDdrzqcJtSRbb9ME3/+yvXjC6qnM1WP6SDb/hwhnTkNyzQ8
        DAcKd5FOIpGuO84sGZocwJUYmIQyF1w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-ReFcDzh8OiymMW5y-0mEZw-1; Tue, 04 Apr 2023 14:16:32 -0400
X-MC-Unique: ReFcDzh8OiymMW5y-0mEZw-1
Received: by mail-ed1-f69.google.com with SMTP id n6-20020a5099c6000000b00502c2f26133so2130655edb.12
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 11:16:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IteB3h1IFF9JrrwNNhJrcSxfFKVKvFn7WIKCluRji64=;
        b=hBd4ROnrF0fEQIXdHnWd+5Aogf6zP9nTwMwlsGwo/QTH9kX5YW7fkHoDKzHpENSiqU
         cr8Xy9XqIXScKKOyZTH2/c+XmjnpmplVSmthovIOQt/FXmJvSW4rYMLC/8NikM/yO9Gb
         0Yd3YxgQdo34hZpo1sjZ+y5UyaVryreewvyicFdf7VsRgUo5NA9/EKf8ri2j/5Vvwaed
         oGPNjL5yxRYFcDMOsdKq/KPZh6ZgUtRa2I8MwrzK6fnNJmaLU2/Zy1fSbDhj3VU4ep48
         klwEcoFPfSbnVKOFkVwXz8Ta1f0l5HTKCkvlAAHCI3Dt79NKp9VsfLAQC5j7NGCUhuKh
         vSgw==
X-Gm-Message-State: AAQBX9d3y4M+r8JnfGfIgCHGgZpy7eJe5+OIfheLikC8iGHkH3zZ1e7I
        dOhE85B+/tajy0q+WhATcU/DBfKVus2MVrVk3rFpT5Q9crU0VOjgDvW2xfBE5ynpFcYsh1JjooJ
        yQJy69XBQJiZC
X-Received: by 2002:a17:906:4714:b0:84d:4e4f:1f85 with SMTP id y20-20020a170906471400b0084d4e4f1f85mr344217ejq.59.1680632191696;
        Tue, 04 Apr 2023 11:16:31 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZCgo8S1M18VZAugvOWFRDnPyPjTek7bcWsZJ7qMIVGPNRWD16Sn2oW1a2cmFO9+19n6ACQMQ==
X-Received: by 2002:a17:906:4714:b0:84d:4e4f:1f85 with SMTP id y20-20020a170906471400b0084d4e4f1f85mr344205ejq.59.1680632191371;
        Tue, 04 Apr 2023 11:16:31 -0700 (PDT)
Received: from redhat.com ([2.52.139.22])
        by smtp.gmail.com with ESMTPSA id g1-20020a170906394100b00933356c681esm6266002eje.150.2023.04.04.11.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:16:30 -0700 (PDT)
Date:   Tue, 4 Apr 2023 14:16:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Viktor Prutyanov <viktor@daynix.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yan@daynix.com" <yan@daynix.com>
Subject: Re: [PATCH v6] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Message-ID: <20230404141501-mutt-send-email-mst@kernel.org>
References: <20230324195029.2410503-1-viktor@daynix.com>
 <AM0PR04MB4723A8D079076FA56AB45845D48C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723A8D079076FA56AB45845D48C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 02, 2023 at 08:17:49AM +0000, Alvaro Karsz wrote:
> Hi Viktor,
> 
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 4c3bb0ddeb9b..f9c6604352b4 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2752,6 +2752,23 @@ void vring_del_virtqueue(struct virtqueue *_vq)
> >  }
> >  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
> > 
> > +u32 vring_notification_data(struct virtqueue *_vq)
> > +{
> > +       struct vring_virtqueue *vq = to_vvq(_vq);
> > +       u16 next;
> > +
> > +       if (vq->packed_ring)
> > +               next = (vq->packed.next_avail_idx &
> > +                               ~(-(1 << VRING_PACKED_EVENT_F_WRAP_CTR))) |
> > +                       vq->packed.avail_wrap_counter <<
> > +                               VRING_PACKED_EVENT_F_WRAP_CTR;
> > +       else
> > +               next = vq->split.avail_idx_shadow;
> > +
> > +       return next << 16 | _vq->index;
> > +}
> > +EXPORT_SYMBOL_GPL(vring_notification_data);
> > +
> >  /* Manipulates transport-specific feature bits. */
> >  void vring_transport_features(struct virtio_device *vdev)
> >  {
> > @@ -2771,6 +2788,8 @@ void vring_transport_features(struct virtio_device *vdev)
> >                         break;
> >                 case VIRTIO_F_ORDER_PLATFORM:
> >                         break;
> > +               case VIRTIO_F_NOTIFICATION_DATA:
> > +                       break;
> 
> This function is used by virtio_vdpa as well (drivers/virtio/virtio_vdpa.c:virtio_vdpa_finalize_features).
> A vDPA device can offer this feature and it will be accepted, even though VIRTIO_F_NOTIFICATION_DATA is not a thing for the vDPA transport at the moment.
> 
> I don't know if this is bad, since offering VIRTIO_F_NOTIFICATION_DATA is meaningless for a vDPA device at the moment.
> 
> I submitted a patch adding support for vDPA transport.
> https://lore.kernel.org/virtualization/20230402081034.1021886-1-alvaro.karsz@solid-run.com/T/#u

Hmm.  So it seems we need to first apply yours then this patch,
is that right? Or the other way around? What is the right way to make it not break bisect?
Do you mind including this patch with yours in a patchset
in the correct order?




> >                 default:
> >                         /* We don't understand this bit. */
> >                         __virtio_clear_bit(vdev, i);
> 

