Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991337AAEB0
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 11:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjIVJs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 05:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIVJsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 05:48:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453E01AC
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 02:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695376051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6954+txMBpmYo04CypSUuQ2OMC1OEIajLVIpD63o/u0=;
        b=JVODK6Qfo8vRRtpri0NiDFVN9IXM3E/Nd4DxIP4WuWhAfhcn7dPCQnO0ITj/yow15KjjLJ
        GzxQxOG/OfpGxfrN+fXIeM/jNV9n5nwWwMMwq3HrE9DEnHpDbLcxdKqVY3k6Bi8f+T0gs3
        H4PsC6rgEAVP0AIuGmBE78V61igvO0Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-WuOXsdQiNgmVs7hwuj2EzA-1; Fri, 22 Sep 2023 05:47:29 -0400
X-MC-Unique: WuOXsdQiNgmVs7hwuj2EzA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-53114797d43so1359806a12.2
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 02:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695376048; x=1695980848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6954+txMBpmYo04CypSUuQ2OMC1OEIajLVIpD63o/u0=;
        b=xHambK3M09KyXJiPkXsrYp9fK2xnTiBAYtd3IFu6h8Z3QfgaNcROIlK1JNJsUSiXNJ
         a/gmnnfgozavsLcFt0jopHNVgFxl1W1nQRj7M+dBRQE9W1XTd/rjuHiJIB2erZ0DynL8
         s95Bly9AlQQqtdhDcPxH6r8QTWTMhg4WcVSjWbGBieT/PcaMvkdXUv3En81MnQfP7Txl
         qPYxAfZOSKn9sIXFCbHOhG/s+ici/s/pKNmxnD95ujBEyB6vhypbVOIW0eDmaKQs85QZ
         V3hHCN4Ho7KvtUX3W0yJ/Axdwi3IeQiX18FgRFYMKhR3q3NZdBE0XpypiRETsEJ2fj9E
         Xu5w==
X-Gm-Message-State: AOJu0YyROFmETX1w7Y1O22XfjT7etefWTCBmYZHLfSOW4Ji+nQZa7huV
        xc+kxRt7Lzz67ejgUicpIYkGA2D4vecRMjgy4xNl0lfTo2YqdBweHWKTxHWlV1iqJDySURm+EED
        FYjtE3YG1DQpu2HupJQly
X-Received: by 2002:a05:6402:114f:b0:522:2782:537 with SMTP id g15-20020a056402114f00b0052227820537mr6944668edw.15.1695376048474;
        Fri, 22 Sep 2023 02:47:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETZwiYeXyPDle3xoL9UArqKdbiEUti5oIzUYd4pU34ry486/q6oDn1zR3wW3ZaN159Z0kJKQ==
X-Received: by 2002:a05:6402:114f:b0:522:2782:537 with SMTP id g15-20020a056402114f00b0052227820537mr6944656edw.15.1695376048077;
        Fri, 22 Sep 2023 02:47:28 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id y6-20020aa7d506000000b0052a1a623267sm2029423edq.62.2023.09.22.02.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 02:47:27 -0700 (PDT)
Date:   Fri, 22 Sep 2023 05:47:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922011918-mutt-send-email-mst@kernel.org>
References: <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <20230921224836.GD13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921224836.GD13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 07:48:36PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 04:16:25PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 04:53:45PM -0300, Jason Gunthorpe wrote:
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
> > If all you want is passing through your card to guest
> > then yes this can be addressed "by simply using VFIO".
> 
> That is pretty much the goal, yes.
> 
> > And let me give you a simple example just from this patchset:
> > it assumes guest uses MSIX and just breaks if it doesn't.
> 
> It does? Really? Where did you see that?

This thing apparently:

+               opcode = (pos < VIRTIO_PCI_CONFIG_OFF(true)) ?
+                       VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ :
+                       VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ;

That "true" is supposed to be whether guest enabled MSI or not.


> > > VFIO is
> > > already required for other scenarios.
> > 
> > Required ... by some people? Most VMs I run don't use anything
> > outside of virtio.
> 
> Yes, some people. The sorts of people who run large data centers.
>
> > It seems to deal with emulating virtio which seems more like a vdpa
> > thing.
> 
> Alex described it right, it creates an SW trapped IO bar that relays
> the doorbell to an admin queue command.
> 
> > If you start adding virtio emulation to vfio then won't
> > you just end up with another vdpa? And if no why not?
> > And I don't buy the "we already invested in this vfio based solution",
> > sorry - that's not a reason upstream has to maintain it.
> 
> I think you would be well justified to object to actual mediation,
> like processing queues in VFIO or otherwise complex things.

This mediation is kind of smallish, I agree. Not completely devoid of
logic though.

> Fortunately there is no need to do that with DPU HW. The legacy IO BAR
> is a weird quirk that just cannot be done without a software trap, and
> the OASIS standardization effort was for exactly this kind of
> simplistic transformation.
> 
> I also don't buy the "upstream has to maintain it" line. The team that
> submitted it will maintain it just fine, thank you.

it will require maintainance effort when virtio changes are made.  For
example it pokes at the device state - I don't see specific races right
now but in the past we did e.g. reset the device to recover from errors
and we might start doing it again.

If more of the logic is under virtio directory where we'll remember
to keep it in loop, and will be able to reuse it from vdpa
down the road, I would be more sympathetic.

-- 
MST

