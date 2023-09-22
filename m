Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028C47AA737
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjIVDD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 23:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIVDD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 23:03:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14EB197
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 20:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695351756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EqcKAldc0rTAWjL+HzqUoeMVPCAyI6Kth5oYS2zXAKw=;
        b=It9w5Qj8tYQf10Qhx/6566+Z7uKnuBy4O9TnxRRog5Nj1jqMxwvzI3hXzeMQbHzAw57gha
        7I0wBNu4Oe1rZI0TX041BdYM6IDPCRnCA8eRBB9aEFqmSoV1rjQniEohd3ObGEI6rSCmCh
        VvEo9T9U/N+8BYEmZ8GinOHt3R1OhGQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-WHCfp0n9PDWvwWfmd-h02g-1; Thu, 21 Sep 2023 23:02:34 -0400
X-MC-Unique: WHCfp0n9PDWvwWfmd-h02g-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2bfe9ed93easo14220841fa.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 20:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695351753; x=1695956553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EqcKAldc0rTAWjL+HzqUoeMVPCAyI6Kth5oYS2zXAKw=;
        b=Y2w9VDai9I4iPNENFA0YQjHexUBI1zcNkzScLOmFMhy3u5mpEyXB48EcNH4vfy18jW
         M97DOlNaaLDUw7sv/8KR4Eq3WB1aZHapb72dlh8G2NlT2pgzTAopJkNFyJTpaH55TBaE
         ZCWMdglVNQn9ZvCle9qqy1ny2un3brY+5nDhInCuds9GnYy541ntfTj6gNJl8OaxVEZ5
         baUzzgjlfiJqtcTxoIxC6Ns74BZ1FROZy0lbenzTT+JdIrNJda0tMO2YjFxOPYMx+8v0
         jf98cJAJ8ReUdsqpoSXrneZdL/FLngnCRv1fAe5b7sqzVmC+oNtK/NkcMsBXtEP9H2BV
         u5zg==
X-Gm-Message-State: AOJu0YyRUY+rFZQzmsYljO5UM6O1vd7P9oolDM61RJvgR4KIRWplO1nH
        HnjPu+SMZ7Ic62lphAX7CvpsT+WIYYzx6QPsXerdE2KIBtCDBSAXagqdPG/Sm8ZjEQ3dGWay+bM
        N4wyaaSGwEMrb5kWjVnQf+u0RvWfg
X-Received: by 2002:a2e:a270:0:b0:2bf:fa16:3aa3 with SMTP id k16-20020a2ea270000000b002bffa163aa3mr414841ljm.25.1695351753197;
        Thu, 21 Sep 2023 20:02:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWPaR20LlK/x64yTtW4K1k8WLbyTe7kqQkHaO0WwMNdbdXwq8V+owBL4qNTHfquiQaV1xGp/OsP0CGi7v26wc=
X-Received: by 2002:a2e:a270:0:b0:2bf:fa16:3aa3 with SMTP id
 k16-20020a2ea270000000b002bffa163aa3mr414834ljm.25.1695351752920; Thu, 21 Sep
 2023 20:02:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com> <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com> <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com> <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com> <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com> <20230921155834-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230921155834-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 22 Sep 2023 11:02:21 +0800
Message-ID: <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 4:16=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Sep 21, 2023 at 04:53:45PM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 21, 2023 at 03:34:03PM -0400, Michael S. Tsirkin wrote:
> >
> > > that's easy/practical.  If instead VDPA gives the same speed with jus=
t
> > > shadow vq then keeping this hack in vfio seems like less of a problem=
.
> > > Finally if VDPA is faster then maybe you will reconsider using it ;)
> >
> > It is not all about the speed.
> >
> > VDPA presents another large and complex software stack in the
> > hypervisor that can be eliminated by simply using VFIO.
>
> If all you want is passing through your card to guest
> then yes this can be addressed "by simply using VFIO".

+1.

And what's more, using MMIO BAR0 then it can work for legacy.

I have a handy virtio hardware from one vendor that works like this,
and I see it is done by a lot of other vendors.

Thanks

