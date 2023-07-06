Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6F97495CE
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 08:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjGFGku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 02:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbjGFGkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 02:40:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C70019B
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 23:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688625602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rg4IfexhYec6xUknQtLkQiZWYyOTZiXy0lHs1tnCoTU=;
        b=VkIhNcPWOebKBCAHNJqXClFA/5A78EgY5K+x74TMqUBsFcTMgQMnQiU0sCjGtydGeQrMOO
        VdIP9YDtD9IXtJAa+YuPAJ9A/ntWOH+316OMYusUOOqMZndRmc2ihJi1C02Lpg2mFHwOWT
        xvlwN+HfddEzSPNaHK0qFhChwsZi3sA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-_D7wBcunN3WXSFBehsso0Q-1; Thu, 06 Jul 2023 02:40:01 -0400
X-MC-Unique: _D7wBcunN3WXSFBehsso0Q-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4fb1a5788f0so295749e87.2
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 23:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688625600; x=1691217600;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rg4IfexhYec6xUknQtLkQiZWYyOTZiXy0lHs1tnCoTU=;
        b=S2TFaSoDxlzSnvH+b4OWUm8nje50G7pyj0NPC6oMqKfVw5rBIBhSdNXZC7XseI/xF2
         FnLit/wQaj8dvNAJOSlZx9vYBs3bQm5azngAiZ6ArbjHTKzKWrIUVvfQDexClKBIOtAQ
         WJOTxB/B0oPleJxHbJqFy45Lb01bNN7ywSdJ2a8Qr5Pvl8poADDs7kCb16dOe8nJSFgA
         cGWWHWMrLTpuimToEBQqa/CKx2jg7t+zqUhZ9zK9bHKBFFkiOPmKdMyH87GVF1pDvxxF
         2IpFVMcwcaQmff1bnw+HovgHSain3MJnGVS/Xl3GTbgCgziS1jb8e4CfUzPkDXXtXpak
         jeZw==
X-Gm-Message-State: ABy/qLZ2FGWGo7v0IZSkgpH/YhGiKmOXZ3jrxblo6euG4SFbyMGjkFWG
        kEP4aim4Qr47wkNA+tApJIW+86S15qRclGZzlVJ1CBuus5JQ4493K6F4tKoLwm3NTfMypoaVF/a
        NqrAWp4H5VZa4
X-Received: by 2002:a19:434a:0:b0:4f8:7614:48a5 with SMTP id m10-20020a19434a000000b004f8761448a5mr680256lfj.66.1688625600339;
        Wed, 05 Jul 2023 23:40:00 -0700 (PDT)
X-Google-Smtp-Source: APBJJlE386jplh0iitvZKDpxQtD+TN3LjC9KlQhdbORFe0IQ5iV+4M8s56CNKTah82KPV4FYkCEBIA==
X-Received: by 2002:a19:434a:0:b0:4f8:7614:48a5 with SMTP id m10-20020a19434a000000b004f8761448a5mr680241lfj.66.1688625599972;
        Wed, 05 Jul 2023 23:39:59 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e5:9a00:6cb0:ad0c:4846:6126])
        by smtp.gmail.com with ESMTPSA id l16-20020a5d4bd0000000b0031438e42599sm941035wrt.82.2023.07.05.23.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 23:39:59 -0700 (PDT)
Date:   Thu, 6 Jul 2023 02:39:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does
 not support it
Message-ID: <20230706023949-mutt-send-email-mst@kernel.org>
References: <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org>
 <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org>
 <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
 <CAJaqyWd0QC6x9WHBT0x9beZyC8ZrF2y=d9HvmT0+05RtGc8_og@mail.gmail.com>
 <eff34828-545b-956b-f400-89b585706fe4@amd.com>
 <20230706020603-mutt-send-email-mst@kernel.org>
 <CAJaqyWeCv6HhWni=c7xySTCyj9WAFfM3JhWL2e_mDKjHp3wPzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWeCv6HhWni=c7xySTCyj9WAFfM3JhWL2e_mDKjHp3wPzQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 08:35:30AM +0200, Eugenio Perez Martin wrote:
> On Thu, Jul 6, 2023 at 8:07 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jul 05, 2023 at 05:07:11PM -0700, Shannon Nelson wrote:
> > > On 7/5/23 11:27 AM, Eugenio Perez Martin wrote:
> > > >
> > > > On Wed, Jul 5, 2023 at 9:50 AM Jason Wang <jasowang@redhat.com> wrote:
> > > > >
> > > > > On Tue, Jul 4, 2023 at 11:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez Martin wrote:
> > > > > > > On Tue, Jul 4, 2023 at 12:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez Martin wrote:
> > > > > > > > > On Mon, Jul 3, 2023 at 4:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio Pérez wrote:
> > > > > > > > > > > With the current code it is accepted as long as userland send it.
> > > > > > > > > > >
> > > > > > > > > > > Although userland should not set a feature flag that has not been
> > > > > > > > > > > offered to it with VHOST_GET_BACKEND_FEATURES, the current code will not
> > > > > > > > > > > complain for it.
> > > > > > > > > > >
> > > > > > > > > > > Since there is no specific reason for any parent to reject that backend
> > > > > > > > > > > feature bit when it has been proposed, let's control it at vdpa frontend
> > > > > > > > > > > level. Future patches may move this control to the parent driver.
> > > > > > > > > > >
> > > > > > > > > > > Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature")
> > > > > > > > > > > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> > > > > > > > > >
> > > > > > > > > > Please do send v3. And again, I don't want to send "after driver ok" hack
> > > > > > > > > > upstream at all, I merged it in next just to give it some testing.
> > > > > > > > > > We want RING_ACCESS_AFTER_KICK or some such.
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Current devices do not support that semantic.
> > > > > > > >
> > > > > > > > Which devices specifically access the ring after DRIVER_OK but before
> > > > > > > > a kick?
> > >
> > > The PDS vdpa device can deal with a call to .set_vq_ready after DRIVER_OK is
> > > set.  And I'm told that our VQ activity should start without a kick.
> > >
> > > Our vdpa device FW doesn't currently have support for VIRTIO_F_RING_RESET,
> > > but I believe it could be added without too much trouble.
> > >
> > > sln
> > >
> >
> > OK it seems clear at least in the current version pds needs
> > VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK.
> > However can we also code up the RING_RESET path as the default?
> > Then down the road vendors can choose what to do.
> >
> 
> Yes, the RING_RESET path can be coded & tested for vp_vdpa, for
> example. I'm ok with making it the default, and let
> _F_ENABLE_AFTER_DRIVER_OK as a fallback.

Sounds good.

> >
> >
> >
> >
> > > > > > > >
> > > > > > >
> > > > > > > Previous versions of the QEMU LM series did a spurious kick to start
> > > > > > > traffic at the LM destination [1]. When it was proposed, that spurious
> > > > > > > kick was removed from the series because to check for descriptors
> > > > > > > after driver_ok, even without a kick, was considered work of the
> > > > > > > parent driver.
> > > > > > >
> > > > > > > I'm ok to go back to this spurious kick, but I'm not sure if the hw
> > > > > > > will read the ring before the kick actually. I can ask.
> > > > > > >
> > > > > > > Thanks!
> > > > > > >
> > > > > > > [1] https://lists.nongnu.org/archive/html/qemu-devel/2023-01/msg02775.html
> > > > > >
> > > > > > Let's find out. We need to check for ENABLE_AFTER_DRIVER_OK too, no?
> > > > >
> > > > > My understanding is [1] assuming ACCESS_AFTER_KICK. This seems
> > > > > sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.
> > > > >
> > > > > But this reminds me one thing, as the thread is going too long, I
> > > > > wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_RESET is
> > > > > supported?
> > > > >
> > > >
> > > > The problem with that is that the device needs to support all
> > > > RING_RESET, like to be able to change vq address etc after DRIVER_OK.
> > > > Not all HW support it.
> > > >
> > > > We just need the subset of having the dataplane freezed until all CVQ
> > > > commands have been consumed. I'm sure current vDPA code already
> > > > supports it in some devices, like MLX and PSD.
> > > >
> > > > Thanks!
> > > >
> > > > > Thanks
> > > > >
> > > > > >
> > > > > >
> > > > > >
> > > > > > > > > My plan was to convert
> > > > > > > > > it in vp_vdpa if needed, and reuse the current vdpa ops. Sorry if I
> > > > > > > > > was not explicit enough.
> > > > > > > > >
> > > > > > > > > The only solution I can see to that is to trap & emulate in the vdpa
> > > > > > > > > (parent?) driver, as talked in virtio-comment. But that complicates
> > > > > > > > > the architecture:
> > > > > > > > > * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
> > > > > > > > > * Store vq enable state separately, at
> > > > > > > > > vdpa->config->set_vq_ready(true), but not transmit that enable to hw
> > > > > > > > > * Store the doorbell state separately, but do not configure it to the
> > > > > > > > > device directly.
> > > > > > > > >
> > > > > > > > > But how to recover if the device cannot configure them at kick time,
> > > > > > > > > for example?
> > > > > > > > >
> > > > > > > > > Maybe we can just fail if the parent driver does not support enabling
> > > > > > > > > the vq after DRIVER_OK? That way no new feature flag is needed.
> > > > > > > > >
> > > > > > > > > Thanks!
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > ---
> > > > > > > > > > > Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/kernel/git/mst
> > > > > > > > > > > commit. Please let me know if I should send a v3 of [1] instead.
> > > > > > > > > > >
> > > > > > > > > > > [1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email-mst@kernel.org/T/
> > > > > > > > > > > ---
> > > > > > > > > > >   drivers/vhost/vdpa.c | 7 +++++--
> > > > > > > > > > >   1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > > > > > > >
> > > > > > > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > > > > > > > > index e1abf29fed5b..a7e554352351 100644
> > > > > > > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > > > > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> > > > > > > > > > >   {
> > > > > > > > > > >        struct vhost_vdpa *v = filep->private_data;
> > > > > > > > > > >        struct vhost_dev *d = &v->vdev;
> > > > > > > > > > > +     const struct vdpa_config_ops *ops = v->vdpa->config;
> > > > > > > > > > >        void __user *argp = (void __user *)arg;
> > > > > > > > > > >        u64 __user *featurep = argp;
> > > > > > > > > > > -     u64 features;
> > > > > > > > > > > +     u64 features, parent_features = 0;
> > > > > > > > > > >        long r = 0;
> > > > > > > > > > >
> > > > > > > > > > >        if (cmd == VHOST_SET_BACKEND_FEATURES) {
> > > > > > > > > > >                if (copy_from_user(&features, featurep, sizeof(features)))
> > > > > > > > > > >                        return -EFAULT;
> > > > > > > > > > > +             if (ops->get_backend_features)
> > > > > > > > > > > +                     parent_features = ops->get_backend_features(v->vdpa);
> > > > > > > > > > >                if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
> > > > > > > > > > >                                 BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
> > > > > > > > > > >                                 BIT_ULL(VHOST_BACKEND_F_RESUME) |
> > > > > > > > > > > -                              BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
> > > > > > > > > > > +                              parent_features))
> > > > > > > > > > >                        return -EOPNOTSUPP;
> > > > > > > > > > >                if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
> > > > > > > > > > >                     !vhost_vdpa_can_suspend(v))
> > > > > > > > > > > --
> > > > > > > > > > > 2.39.3
> > > > > > > > > >
> > > > > > > >
> > > > > >
> > > > >
> > > >
> >

