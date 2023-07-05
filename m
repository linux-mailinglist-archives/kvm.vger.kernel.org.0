Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E76E747FF6
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 10:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjGEInQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 04:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjGEInA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 04:43:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD291719
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 01:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688546531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zOQW6ytwkNKpldl4Gwcyl0hiPfFRDq2NpyrhoTMoIf4=;
        b=FoY5G3W9kTObHvdMs3r5St+TC6PX/qiJM/jTWpHFaVQF8ps5GE8uOiFUej6Nm6j2S1YWXD
        +pm/AgW1wb/ELWSVntztwRgeq0hEAv/cBKQlTzW64etOyJAieMdkhKXPlRO9H7u63nZD/j
        fBqO0gFCdtKw/a62r6v3dzcDqDu3aQs=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-Gu0-P5ooPaeGXvaiUM1NEw-1; Wed, 05 Jul 2023 04:42:08 -0400
X-MC-Unique: Gu0-P5ooPaeGXvaiUM1NEw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4edc7406cbaso6438878e87.2
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 01:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688546527; x=1691138527;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zOQW6ytwkNKpldl4Gwcyl0hiPfFRDq2NpyrhoTMoIf4=;
        b=kMBUbpI+AjBGWcGMGCU3CiexejiLyFYnYrwbxm3vkxOoNEFUJdGRv+RiIR/VmVKHKR
         SIQXBrhpy4oRKjfLFeHX3OJnza9avtiUKExqr2Kfxae+WqjJPHaZuNJtZY1/vAze812B
         T6z0cgZ9ut5aVSoq+szv3WZ9hPzc84LzLEpUn78AocWbnZQfp4aMXUPcftSNxlxhdB7H
         PQmOBX+AsX2mDk68rtm2avq8agh6YhLKS9wZOiEJGDGq0QXVMYld/ZaFr1eQ5CdogK/t
         f0t/x4EdVqydRsTVSUMbdUX8BTuVlhkeopJ2i2M7q4kkqobrKtl+Ut6PkBIrUvHWamRC
         T+ZQ==
X-Gm-Message-State: ABy/qLYeB+OsEA/f17rRkfm4Q2pc6JGH0cdNjgai43/3/C5e5hwDaKJo
        h1LUwAGxCwM0EFZlR/hFfPT3FY97y9WO4zcRxDyAd64rRToQoywqS6HCbUILJuxObgAuBsZtEVR
        qrXOJ58Gt6Btm
X-Received: by 2002:a05:6512:3b9c:b0:4f8:5960:49a9 with SMTP id g28-20020a0565123b9c00b004f8596049a9mr14003101lfv.23.1688546527015;
        Wed, 05 Jul 2023 01:42:07 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG/H5pfmSsFn72wPJaF6gCY5W2vcZpPs+es/4FECw46OZpiDrini6ap0HCP3FDgbIRy+g5z/A==
X-Received: by 2002:a05:6512:3b9c:b0:4f8:5960:49a9 with SMTP id g28-20020a0565123b9c00b004f8596049a9mr14003085lfv.23.1688546526663;
        Wed, 05 Jul 2023 01:42:06 -0700 (PDT)
Received: from redhat.com ([2.52.13.33])
        by smtp.gmail.com with ESMTPSA id p23-20020a1c7417000000b003fbb5506e54sm1460129wmc.29.2023.07.05.01.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 01:42:06 -0700 (PDT)
Date:   Wed, 5 Jul 2023 04:42:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eugenio Perez Martin <eperezma@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does
 not support it
Message-ID: <20230705044151-mutt-send-email-mst@kernel.org>
References: <20230703142218.362549-1-eperezma@redhat.com>
 <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org>
 <CACGkMEvT4Y+-wfhyi324Y5hhAtn+ZF7cP9d=omdH-ZgdJ-4SOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEvT4Y+-wfhyi324Y5hhAtn+ZF7cP9d=omdH-ZgdJ-4SOQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023 at 03:55:23PM +0800, Jason Wang wrote:
> On Tue, Jul 4, 2023 at 6:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez Martin wrote:
> > > On Mon, Jul 3, 2023 at 4:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio Pérez wrote:
> > > > > With the current code it is accepted as long as userland send it.
> > > > >
> > > > > Although userland should not set a feature flag that has not been
> > > > > offered to it with VHOST_GET_BACKEND_FEATURES, the current code will not
> > > > > complain for it.
> > > > >
> > > > > Since there is no specific reason for any parent to reject that backend
> > > > > feature bit when it has been proposed, let's control it at vdpa frontend
> > > > > level. Future patches may move this control to the parent driver.
> > > > >
> > > > > Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature")
> > > > > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> > > >
> > > > Please do send v3. And again, I don't want to send "after driver ok" hack
> > > > upstream at all, I merged it in next just to give it some testing.
> > > > We want RING_ACCESS_AFTER_KICK or some such.
> > > >
> > >
> > > Current devices do not support that semantic.
> >
> > Which devices specifically access the ring after DRIVER_OK but before
> > a kick?
> 
> Vhost-net is one example at last. It polls a socket as well, so it
> starts to access the ring immediately after DRIVER_OK.
> 
> Thanks


For sure but that is not vdpa.

> >
> > > My plan was to convert
> > > it in vp_vdpa if needed, and reuse the current vdpa ops. Sorry if I
> > > was not explicit enough.
> > >
> > > The only solution I can see to that is to trap & emulate in the vdpa
> > > (parent?) driver, as talked in virtio-comment. But that complicates
> > > the architecture:
> > > * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
> > > * Store vq enable state separately, at
> > > vdpa->config->set_vq_ready(true), but not transmit that enable to hw
> > > * Store the doorbell state separately, but do not configure it to the
> > > device directly.
> > >
> > > But how to recover if the device cannot configure them at kick time,
> > > for example?
> > >
> > > Maybe we can just fail if the parent driver does not support enabling
> > > the vq after DRIVER_OK? That way no new feature flag is needed.
> > >
> > > Thanks!
> > >
> > > >
> > > > > ---
> > > > > Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/kernel/git/mst
> > > > > commit. Please let me know if I should send a v3 of [1] instead.
> > > > >
> > > > > [1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email-mst@kernel.org/T/
> > > > > ---
> > > > >  drivers/vhost/vdpa.c | 7 +++++--
> > > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > > index e1abf29fed5b..a7e554352351 100644
> > > > > --- a/drivers/vhost/vdpa.c
> > > > > +++ b/drivers/vhost/vdpa.c
> > > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> > > > >  {
> > > > >       struct vhost_vdpa *v = filep->private_data;
> > > > >       struct vhost_dev *d = &v->vdev;
> > > > > +     const struct vdpa_config_ops *ops = v->vdpa->config;
> > > > >       void __user *argp = (void __user *)arg;
> > > > >       u64 __user *featurep = argp;
> > > > > -     u64 features;
> > > > > +     u64 features, parent_features = 0;
> > > > >       long r = 0;
> > > > >
> > > > >       if (cmd == VHOST_SET_BACKEND_FEATURES) {
> > > > >               if (copy_from_user(&features, featurep, sizeof(features)))
> > > > >                       return -EFAULT;
> > > > > +             if (ops->get_backend_features)
> > > > > +                     parent_features = ops->get_backend_features(v->vdpa);
> > > > >               if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
> > > > >                                BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
> > > > >                                BIT_ULL(VHOST_BACKEND_F_RESUME) |
> > > > > -                              BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
> > > > > +                              parent_features))
> > > > >                       return -EOPNOTSUPP;
> > > > >               if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
> > > > >                    !vhost_vdpa_can_suspend(v))
> > > > > --
> > > > > 2.39.3
> > > >
> >

