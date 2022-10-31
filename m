Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB53613638
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 13:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiJaM0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 08:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJaM0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 08:26:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07793106
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 05:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667219103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfkK1KtSCue63LLMxZ4FtECuWKGnXXVP4gbD3G4cjL0=;
        b=OFx4cqAw1WszYJHlmmLCJFPOXdJRo/xVbu9y99AH8+Poi0r9/e1eiyLb5DXSZKaqJ6gor6
        QsO1Q15Ch+Xmg1aSef1upI7yOeWymOUWGRjDF2e0i44POTd7WUMzjRx0cYapxkajV52iBq
        YBOorJY2g/Jl16w0nPVudGzb/bcDnHE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-471-f_6eIIAdMRKeJS1Nta6omQ-1; Mon, 31 Oct 2022 08:25:01 -0400
X-MC-Unique: f_6eIIAdMRKeJS1Nta6omQ-1
Received: by mail-wm1-f71.google.com with SMTP id e8-20020a05600c218800b003cf634f5280so925215wme.8
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 05:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zfkK1KtSCue63LLMxZ4FtECuWKGnXXVP4gbD3G4cjL0=;
        b=b9zlDTQ+LjMUDrqZvPbEA//7wykU/JUzPknMtZrYL3fW8RZSyNTW7SFpvYOuIFCS8V
         BYu/BleISe1gFeRnMkGM7bx7430M7Wvf+82h1dBt3H4KuJgjRezJtcWlAXt5eQcqjkVM
         bYiaQ9JbcZuPJHxpI2SZSho42ljzXQO+D0XHypuNZz0YJfo1ZtlZWi9CtOWuQ3pOvLDy
         bWuHkbPPDCn+8eHpHDgDFnJDU0es5iI2kZgw8EpLg6OlMU4DDNSpjiyf0kxwZTpkzv11
         qP7e8ok7ldXvL6eEgtuS3oUTdjRSZyPsHRrdJfX593USiUv2LE+MetuCHwiKdHqz43a5
         NrMw==
X-Gm-Message-State: ACrzQf204Ydpp3+2dG8b7Wa7fDvlkT7Ubp3ngdjPK4tpIQq44OFG7scu
        B1tJbiZkDC5IqZ3GAEwH89UQO6Cgl2TjCCA2yLsI9yT57BThlGbPLo1lophgYyRe0FD0VtUbI+p
        4sbQnHZB37k3E
X-Received: by 2002:a7b:c4cf:0:b0:3cf:497c:ae3a with SMTP id g15-20020a7bc4cf000000b003cf497cae3amr17788957wmk.177.1667219100536;
        Mon, 31 Oct 2022 05:25:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM69D8xIsVZcaWiRZms64488Fpw3/JfDO/S2qIuys1bMppxYZyg7F7QbMgvcGKp4qqtV88spaA==
X-Received: by 2002:a7b:c4cf:0:b0:3cf:497c:ae3a with SMTP id g15-20020a7bc4cf000000b003cf497cae3amr17788937wmk.177.1667219100283;
        Mon, 31 Oct 2022 05:25:00 -0700 (PDT)
Received: from redhat.com ([2.52.15.189])
        by smtp.gmail.com with ESMTPSA id l13-20020a05600c2ccd00b003a2f2bb72d5sm8067013wmc.45.2022.10.31.05.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:24:59 -0700 (PDT)
Date:   Mon, 31 Oct 2022 08:24:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Gautam Dawar <gdawar@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Harpreet Singh Anand <hanand@xilinx.com>
Subject: Re: [PATCH v5 2/6] vdpa: Allocate SVQ unconditionally
Message-ID: <20221031082106-mutt-send-email-mst@kernel.org>
References: <20221011104154.1209338-1-eperezma@redhat.com>
 <20221011104154.1209338-3-eperezma@redhat.com>
 <20221031041821-mutt-send-email-mst@kernel.org>
 <CAJaqyWcaZ32agF0CKPUU89NHj0Di9Q5kFJDsWcUwCG2q0u_kEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWcaZ32agF0CKPUU89NHj0Di9Q5kFJDsWcUwCG2q0u_kEQ@mail.gmail.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 12:56:06PM +0100, Eugenio Perez Martin wrote:
> On Mon, Oct 31, 2022 at 9:21 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Oct 11, 2022 at 12:41:50PM +0200, Eugenio Pérez wrote:
> > > SVQ may run or not in a device depending on runtime conditions (for
> > > example, if the device can move CVQ to its own group or not).
> > >
> > > Allocate the resources unconditionally, and decide later if to use them
> > > or not.
> > >
> > > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> >
> > I applied this for now but I really dislike it that we are wasting
> > resources like this.
> >
> > Can I just drop this patch from the series? It looks like things
> > will just work anyway ...
> >
> 
> It will not work simply dropping this patch, because new code expects
> SVQ vrings to be already allocated. But that is doable with more work.
> 
> > I know, when one works on a feature it seems like everyone should
> > enable it - but the reality is qemu already works quite well for
> > most users and it is our resposibility to first do no harm.
> >
> 
> I agree, but then it is better to drop this series entirely for this
> merge window. I think it is justified to add it at the beginning of
> the next merge window, and to give more time for testing and adding
> more features actually.

Not sure what "then" means. You tell me - should I drop it?

> However, I think shadow CVQ should start by default as long as the
> device has the right set of both virtio and vdpa features. Otherwise,
> we need another cmdline parameter, something like x-cvq-svq, and the
> update of other layers like libvirt.
> 
> Thanks!

OK maybe that is not too bad.


> >
> > > ---
> > >  hw/virtio/vhost-vdpa.c | 33 +++++++++++++++------------------
> > >  1 file changed, 15 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > > index 7f0ff4df5b..d966966131 100644
> > > --- a/hw/virtio/vhost-vdpa.c
> > > +++ b/hw/virtio/vhost-vdpa.c
> > > @@ -410,6 +410,21 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
> > >      int r;
> > >      bool ok;
> > >
> > > +    shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
> > > +    for (unsigned n = 0; n < hdev->nvqs; ++n) {
> > > +        g_autoptr(VhostShadowVirtqueue) svq;
> > > +
> > > +        svq = vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
> > > +                            v->shadow_vq_ops_opaque);
> > > +        if (unlikely(!svq)) {
> > > +            error_setg(errp, "Cannot create svq %u", n);
> > > +            return -1;
> > > +        }
> > > +        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
> > > +    }
> > > +
> > > +    v->shadow_vqs = g_steal_pointer(&shadow_vqs);
> > > +
> > >      if (!v->shadow_vqs_enabled) {
> > >          return 0;
> > >      }
> > > @@ -426,20 +441,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
> > >          return -1;
> > >      }
> > >
> > > -    shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
> > > -    for (unsigned n = 0; n < hdev->nvqs; ++n) {
> > > -        g_autoptr(VhostShadowVirtqueue) svq;
> > > -
> > > -        svq = vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
> > > -                            v->shadow_vq_ops_opaque);
> > > -        if (unlikely(!svq)) {
> > > -            error_setg(errp, "Cannot create svq %u", n);
> > > -            return -1;
> > > -        }
> > > -        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
> > > -    }
> > > -
> > > -    v->shadow_vqs = g_steal_pointer(&shadow_vqs);
> > >      return 0;
> > >  }
> > >
> > > @@ -580,10 +581,6 @@ static void vhost_vdpa_svq_cleanup(struct vhost_dev *dev)
> > >      struct vhost_vdpa *v = dev->opaque;
> > >      size_t idx;
> > >
> > > -    if (!v->shadow_vqs) {
> > > -        return;
> > > -    }
> > > -
> > >      for (idx = 0; idx < v->shadow_vqs->len; ++idx) {
> > >          vhost_svq_stop(g_ptr_array_index(v->shadow_vqs, idx));
> > >      }
> > > --
> > > 2.31.1
> >

