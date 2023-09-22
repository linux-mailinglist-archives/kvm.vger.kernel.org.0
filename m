Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D8A7AB4EA
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjIVPkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjIVPkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:40:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2549C139
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695397167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z1juo4wQ/7QEejr5BWLkPOZgP2Az8qd1gn01up27KMk=;
        b=ipQfZzw3orSOcXhcyqu98d/b3Y1TSLZ2g4weJ65qudvU1PkWC5SfnM0J6Yz1VybFB3qJWx
        90kTlyDbbpK+Z6BtIHujr3eBllUXSNRs/4lzu83Xp62CH6/RhPQ6AqE0SNxo++AmYZx2Dp
        9Af0yqjVmuCx38mHt/QuHglqNIb0eKw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-g2RVpSgaMWudn8Ynpe4cuA-1; Fri, 22 Sep 2023 11:39:25 -0400
X-MC-Unique: g2RVpSgaMWudn8Ynpe4cuA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94a35b0d4ceso177026166b.3
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695397165; x=1696001965;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1juo4wQ/7QEejr5BWLkPOZgP2Az8qd1gn01up27KMk=;
        b=kC0XxrndmRWyy/OCnS1liUXrjsmq0tSyozHZH8hfYn5ltrt59MbBmQr7kxrK39wxdo
         WuKill9lbMhbN+KjjwofsnsS6VyYJQIcNMet9PaHuqChKlkgd/PCJ4UgnOXfpJLbKC/G
         wcw1Tcdd16ixKY52uGSLOzoQb2dN6BCWqSv7KnawHcD9Xv/9+/UXN1m5kflSN2AiePjQ
         WqpmxnlAhmcYdBCneesFKREKgmz/Gdz97mWwnXIT5dZ+I/HzF8IMn9tC+YK87FOa3Qq8
         +sJargGDCLNbVIPjAncQPCee3zsyJBpOwMy8cWnPx5Mm9ZTuS82n2dOS7nWZpWywUUuD
         DoRw==
X-Gm-Message-State: AOJu0YyJkNB1DduVIFR5DOZAtlp3AeKFTKS5gSJhh2egodgtbcX9Z6Ik
        UtaFC6gtkLHqkGFrd3L6ejsw84iHpoVnVOWO3Ai75W0SS3ojxWawljagHcm6eWoNNFu87MykmfK
        lDRfetJyHSvfc
X-Received: by 2002:a17:907:2cd4:b0:9ae:50de:1aa5 with SMTP id hg20-20020a1709072cd400b009ae50de1aa5mr6475871ejc.19.1695397164857;
        Fri, 22 Sep 2023 08:39:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFeGSdDPaRM6KjwV981O05NHicuJfuebKz9xcHmZZSEqMjJ8lDESI+n36o33v28MriHdfF1uw==
X-Received: by 2002:a17:907:2cd4:b0:9ae:50de:1aa5 with SMTP id hg20-20020a1709072cd400b009ae50de1aa5mr6475843ejc.19.1695397164463;
        Fri, 22 Sep 2023 08:39:24 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id w27-20020a17090633db00b009a2235ed496sm2923362eja.141.2023.09.22.08.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 08:39:23 -0700 (PDT)
Date:   Fri, 22 Sep 2023 11:39:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922111342-mutt-send-email-mst@kernel.org>
References: <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <CACGkMEt=dxhJP4mUUWh+x-TSxA5JQcvmhJbkLJMWdN8oXV6ojg@mail.gmail.com>
 <20230922122501.GP13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230922122501.GP13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 09:25:01AM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 22, 2023 at 11:02:50AM +0800, Jason Wang wrote:
> > On Fri, Sep 22, 2023 at 3:53 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Thu, Sep 21, 2023 at 03:34:03PM -0400, Michael S. Tsirkin wrote:
> > >
> > > > that's easy/practical.  If instead VDPA gives the same speed with just
> > > > shadow vq then keeping this hack in vfio seems like less of a problem.
> > > > Finally if VDPA is faster then maybe you will reconsider using it ;)
> > >
> > > It is not all about the speed.
> > >
> > > VDPA presents another large and complex software stack in the
> > > hypervisor that can be eliminated by simply using VFIO.
> > 
> > vDPA supports standard virtio devices so how did you define
> > complexity?
> 
> As I said, VFIO is already required for other devices in these VMs. So
> anything incremental over base-line vfio-pci is complexity to
> minimize.
> 
> Everything vdpa does is either redundant or unnecessary compared to
> VFIO in these environments.
> 
> Jason

Yes but you know. There are all kind of environments.  I guess you
consider yours the most mainstream and important, and are sure it will
always stay like this.  But if there's a driver that does what you need
then you use that. You really should be explaining what vdpa
*does not* do that you need.

But anyway, if Alex wants to maintain this it's not too bad,
but I would like to see more code move into a library
living under the virtio directory. As it is structured now
it will make virtio core development harder.

-- 
MST

