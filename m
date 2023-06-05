Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144237226BB
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjFENBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjFENBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:01:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23E0CD
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 06:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685970033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bbubscZftjyRYYL2p4m/teVFWDkt0vBAkgkuXdu/w1E=;
        b=PaDyhoi5M2Wybz2aXAWRKa6Qow24lnGuV4raeaysBnOTf3r9uIHRze36Qw4RNK5QjOe64i
        FuhYZqZVXzL/QkIQySHwdHiTYzlBI8oPRyvovHUs/GMiAQb16luScqGGHI0E5eB/Kz8dNl
        FjalMmXDHQeU9usi0YDviduEOZ0+6oA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-NPY-MVjYMa6aGkqn5aJMfw-1; Mon, 05 Jun 2023 09:00:31 -0400
X-MC-Unique: NPY-MVjYMa6aGkqn5aJMfw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-30ae4ed92eeso2098295f8f.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 06:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685970030; x=1688562030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bbubscZftjyRYYL2p4m/teVFWDkt0vBAkgkuXdu/w1E=;
        b=jCNqDfd9NqTlsH9hWr+YxmcoPRz/W7UqhsehYFwd4IGXUxyaraI/RU9YlpjE17D8lq
         Qp3tMNRGWmdctFRUOzMlrYftVzGRe8wbm1SmLUJNZDH+cU2/TtFm0h9HdqSMWVsjTdLM
         V/MgC9rXbXjSxssJ8fmfPHu2QoMqi0BOrowX44jFOh/z/pfxpP9o217KATkPvEApRSFX
         NUQn6HjsQyzJhNrGUmLxqf5Dz0kU3sBtl6pz94F0f9zSGv+cuEMkLDTCXzWufm6Vbu9l
         7veiFtfO182g7MSoODtMERmaxkmE8oelzPamMcJZyPC22zNyFZt6LneGewEIrhjB7Ng7
         ye1g==
X-Gm-Message-State: AC+VfDyCVnwuCNVELt7YHdMu1GZ8s6fqISSsWyXjfvV3CiTjBxgjpiGo
        CTHBowhJfN30LLAPmMWMyMX9yR+++kKEXlUQGeBrkSHG/izXGF6fhVe3TZ+PFHXfv6SH9jlPa5B
        LVHWByAw1ISyC
X-Received: by 2002:a5d:4d4a:0:b0:30a:f1dd:dc55 with SMTP id a10-20020a5d4d4a000000b0030af1dddc55mr3686140wru.53.1685970029830;
        Mon, 05 Jun 2023 06:00:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6DD3cwjpmZBvtInHDuWJuM4v9sDwnhYfReDafcIwBsT4j0UbFV+PmO399VIFuafC8KUQM2Tg==
X-Received: by 2002:a5d:4d4a:0:b0:30a:f1dd:dc55 with SMTP id a10-20020a5d4d4a000000b0030af1dddc55mr3686125wru.53.1685970029458;
        Mon, 05 Jun 2023 06:00:29 -0700 (PDT)
Received: from redhat.com ([2.55.4.169])
        by smtp.gmail.com with ESMTPSA id p6-20020a056000018600b0030aefd11892sm9708331wrx.41.2023.06.05.06.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 06:00:28 -0700 (PDT)
Date:   Mon, 5 Jun 2023 09:00:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230605085840-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > don't support packed virtqueue well yet, so let's filter the
> > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > 
> > > This way, even if the device supports it, we don't risk it being
> > > negotiated, then the VMM is unable to set the vring state properly.
> > > 
> > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > > 
> > > Notes:
> > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > >     better PACKED support" series [1] and backported in stable branches.
> > > 
> > >     We can revert it when we are sure that everything is working with
> > >     packed virtqueues.
> > > 
> > >     Thanks,
> > >     Stefano
> > > 
> > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > 
> > I'm a bit lost here. So why am I merging "better PACKED support" then?
> 
> To really support packed virtqueue with vhost-vdpa, at that point we would
> also have to revert this patch.
> 
> I wasn't sure if you wanted to queue the series for this merge window.
> In that case do you think it is better to send this patch only for stable
> branches?
> > Does this patch make them a NOP?
> 
> Yep, after applying the "better PACKED support" series and being sure that
> the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> patch.
> 
> Let me know if you prefer a different approach.
> 
> I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> interprets them the right way, when it does not.
> 
> Thanks,
> Stefano
> 

If this fixes a bug can you add Fixes tags to each of them? Then it's ok
to merge in this window. Probably easier than the elaborate
mask/unmask dance.

> > 
> > >  drivers/vhost/vdpa.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index 8c1aefc865f0..ac2152135b23 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -397,6 +397,12 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
> > > 
> > >  	features = ops->get_device_features(vdpa);
> > > 
> > > +	/*
> > > +	 * IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE) don't support
> > > +	 * packed virtqueue well yet, so let's filter the feature for now.
> > > +	 */
> > > +	features &= ~BIT_ULL(VIRTIO_F_RING_PACKED);
> > > +
> > >  	if (copy_to_user(featurep, &features, sizeof(features)))
> > >  		return -EFAULT;
> > > 
> > > 
> > > base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
> > > --
> > > 2.40.1
> > 

