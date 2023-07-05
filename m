Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FAB747FF0
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 10:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjGEImR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 04:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjGEImN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 04:42:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B959199E
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 01:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688546479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RMcHS+HYh08mQ8rBNMcHYRimEbsxb6yaJnh1Kb3mgQ0=;
        b=FYfxK6T1gDraYjxAZhyiNOOvgs2RLZEKGipfkdDAnExxOG+znph/NzBvWiWzmsg4TEH1Sa
        5jhKjWt5w6okMC1OSLjPxGgm8Xic84lsWKqbjkWrpZ7Wi/A2fxbRXrf/J9Uw0u/P3XOJCz
        GVywlv+iRXXtrTiZnIOmXKMUy20Wnxs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-84rEuwkyMeWn18wKjVN8Wg-1; Wed, 05 Jul 2023 04:41:18 -0400
X-MC-Unique: 84rEuwkyMeWn18wKjVN8Wg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-31432b25c2fso3140179f8f.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 01:41:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688546477; x=1691138477;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RMcHS+HYh08mQ8rBNMcHYRimEbsxb6yaJnh1Kb3mgQ0=;
        b=Os3eJp4N1mbz8QPtRxRH2yhzZyk739MvgZ3q7xudok5FEy8fRXcxYpHVMZ/L9fvMi+
         i95uG8hxAAtbYw1zXYOnwRjC2Eqle5BUe3tlFfomUl4Ej9VIyWC68G4DekwXPzKaL4Xm
         iLaFrWi+DQzaVgcgdxf/s0V4euw6t7uliClN/WE/mT9eGUyw5e83R09Fb8HNTllqBoXr
         A4UCldPRF5EAoZ4+yV9NaPhxhlqq2agYN4OACG2raGNbbcIjOPcJocXQu5ms/Jd/UF1s
         I6T/seMNB/lRDNeLhrhHqre1eytdN1AWpTFOMxjSlCbwbOW3dva1l/0WT46P/HCecqf1
         h4aw==
X-Gm-Message-State: ABy/qLYs00zbWwKqM3Ntg2X0q51nj3W3wwyCE24ImSB0fwkCRqspywCj
        nGEPjv3DjaRO6Cec+1zQoweRzB30gddh06UmVrEC++Gq8MJ1RXxcfszkE6jfCs5ObPjI1le6ATf
        MGts3sNUK44iE
X-Received: by 2002:adf:facd:0:b0:311:110d:5573 with SMTP id a13-20020adffacd000000b00311110d5573mr17013457wrs.64.1688546477134;
        Wed, 05 Jul 2023 01:41:17 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHYhxj8BmOxwM9GKxq6po7y4so3795albr5tzeL1hNw2jElCVSdO5UxrFnmlOXNJqsKErJ/XQ==
X-Received: by 2002:adf:facd:0:b0:311:110d:5573 with SMTP id a13-20020adffacd000000b00311110d5573mr17013442wrs.64.1688546476766;
        Wed, 05 Jul 2023 01:41:16 -0700 (PDT)
Received: from redhat.com ([2.52.13.33])
        by smtp.gmail.com with ESMTPSA id c13-20020adfe74d000000b0030ae499da59sm15301643wrn.111.2023.07.05.01.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 01:41:16 -0700 (PDT)
Date:   Wed, 5 Jul 2023 04:41:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eugenio Perez Martin <eperezma@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does
 not support it
Message-ID: <20230705043940-mutt-send-email-mst@kernel.org>
References: <20230703142218.362549-1-eperezma@redhat.com>
 <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org>
 <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org>
 <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023 at 03:49:58PM +0800, Jason Wang wrote:
> On Tue, Jul 4, 2023 at 11:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez Martin wrote:
> > > On Tue, Jul 4, 2023 at 12:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez Martin wrote:
> > > > > On Mon, Jul 3, 2023 at 4:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio Pérez wrote:
> > > > > > > With the current code it is accepted as long as userland send it.
> > > > > > >
> > > > > > > Although userland should not set a feature flag that has not been
> > > > > > > offered to it with VHOST_GET_BACKEND_FEATURES, the current code will not
> > > > > > > complain for it.
> > > > > > >
> > > > > > > Since there is no specific reason for any parent to reject that backend
> > > > > > > feature bit when it has been proposed, let's control it at vdpa frontend
> > > > > > > level. Future patches may move this control to the parent driver.
> > > > > > >
> > > > > > > Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature")
> > > > > > > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> > > > > >
> > > > > > Please do send v3. And again, I don't want to send "after driver ok" hack
> > > > > > upstream at all, I merged it in next just to give it some testing.
> > > > > > We want RING_ACCESS_AFTER_KICK or some such.
> > > > > >
> > > > >
> > > > > Current devices do not support that semantic.
> > > >
> > > > Which devices specifically access the ring after DRIVER_OK but before
> > > > a kick?
> > > >
> > >
> > > Previous versions of the QEMU LM series did a spurious kick to start
> > > traffic at the LM destination [1]. When it was proposed, that spurious
> > > kick was removed from the series because to check for descriptors
> > > after driver_ok, even without a kick, was considered work of the
> > > parent driver.
> > >
> > > I'm ok to go back to this spurious kick, but I'm not sure if the hw
> > > will read the ring before the kick actually. I can ask.
> > >
> > > Thanks!
> > >
> > > [1] https://lists.nongnu.org/archive/html/qemu-devel/2023-01/msg02775.html
> >
> > Let's find out. We need to check for ENABLE_AFTER_DRIVER_OK too, no?
> 
> My understanding is [1] assuming ACCESS_AFTER_KICK. This seems
> sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.
> 
> But this reminds me one thing, as the thread is going too long, I
> wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_RESET is
> supported?
> 
> Thanks

I don't see what does one have to do with another ...

I think with RING_RESET we had another solution, enable rings
mapping them to a zero page, then reset and re-enable later.

> >
> >
> >
> > > > > My plan was to convert
> > > > > it in vp_vdpa if needed, and reuse the current vdpa ops. Sorry if I
> > > > > was not explicit enough.
> > > > >
> > > > > The only solution I can see to that is to trap & emulate in the vdpa
> > > > > (parent?) driver, as talked in virtio-comment. But that complicates
> > > > > the architecture:
> > > > > * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
> > > > > * Store vq enable state separately, at
> > > > > vdpa->config->set_vq_ready(true), but not transmit that enable to hw
> > > > > * Store the doorbell state separately, but do not configure it to the
> > > > > device directly.
> > > > >
> > > > > But how to recover if the device cannot configure them at kick time,
> > > > > for example?
> > > > >
> > > > > Maybe we can just fail if the parent driver does not support enabling
> > > > > the vq after DRIVER_OK? That way no new feature flag is needed.
> > > > >
> > > > > Thanks!
> > > > >
> > > > > >
> > > > > > > ---
> > > > > > > Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/kernel/git/mst
> > > > > > > commit. Please let me know if I should send a v3 of [1] instead.
> > > > > > >
> > > > > > > [1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email-mst@kernel.org/T/
> > > > > > > ---
> > > > > > >  drivers/vhost/vdpa.c | 7 +++++--
> > > > > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > > > > index e1abf29fed5b..a7e554352351 100644
> > > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> > > > > > >  {
> > > > > > >       struct vhost_vdpa *v = filep->private_data;
> > > > > > >       struct vhost_dev *d = &v->vdev;
> > > > > > > +     const struct vdpa_config_ops *ops = v->vdpa->config;
> > > > > > >       void __user *argp = (void __user *)arg;
> > > > > > >       u64 __user *featurep = argp;
> > > > > > > -     u64 features;
> > > > > > > +     u64 features, parent_features = 0;
> > > > > > >       long r = 0;
> > > > > > >
> > > > > > >       if (cmd == VHOST_SET_BACKEND_FEATURES) {
> > > > > > >               if (copy_from_user(&features, featurep, sizeof(features)))
> > > > > > >                       return -EFAULT;
> > > > > > > +             if (ops->get_backend_features)
> > > > > > > +                     parent_features = ops->get_backend_features(v->vdpa);
> > > > > > >               if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
> > > > > > >                                BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
> > > > > > >                                BIT_ULL(VHOST_BACKEND_F_RESUME) |
> > > > > > > -                              BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
> > > > > > > +                              parent_features))
> > > > > > >                       return -EOPNOTSUPP;
> > > > > > >               if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
> > > > > > >                    !vhost_vdpa_can_suspend(v))
> > > > > > > --
> > > > > > > 2.39.3
> > > > > >
> > > >
> >

