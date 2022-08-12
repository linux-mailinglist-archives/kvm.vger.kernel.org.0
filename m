Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D77F590FF0
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 13:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbiHLLRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 07:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHLLRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 07:17:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C98CAA3C6
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 04:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660303040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i2uStZHcnGK1w3yJ0+mPheUPjNUdo4CHm8EdAzcVLaM=;
        b=JGGbumq/Ti1Jtf2TWrNqu0UcIbi6SHfOW/BVbBiLv4Q7dyt57+mj64HJASmauGsheKk4yX
        hXUOXDSY/c72WOyFwDepm5YcHNkMt92LPy9X37x/zVc/CB0AWMAC0ujiN8lFocgZX+FCTP
        Xz23TXYeKpYFu9YITQoAcUeW5LLCRnU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-176-ucHQPizaMk-wSJ81Mseg0A-1; Fri, 12 Aug 2022 07:17:19 -0400
X-MC-Unique: ucHQPizaMk-wSJ81Mseg0A-1
Received: by mail-wm1-f71.google.com with SMTP id i132-20020a1c3b8a000000b003a537064611so444873wma.4
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 04:17:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=i2uStZHcnGK1w3yJ0+mPheUPjNUdo4CHm8EdAzcVLaM=;
        b=Kii80cpx/jKYNu+tCW8l53C36HWtsqzE8sR3+U5Q7267k7fjp4pQZbUa7Ff9LTtzrf
         s+ZjpdFMlt21kCrjnP0+RrJxdfEmsD6ZgBMOPuyjlwbwt/1ieyyVz9AF2d9+nl4c0eEp
         T9STwgGJJ75hkYYEc8e3+jWLQVILGCzXR2p2ePWuNuFUqJtQXg4HUQr+Wf15F5wQ78Fm
         XsTsB/tRHIV7aQHhkwepJpteYNahZwruBZhB0uEAxtDV+OyGuzjZPwn/CQrHC92b3+aR
         eVL/IUWLoE1ImbGakM8ifxlbrCKxaH+aoV486wtXYcFSvFVxVVU5sSd8LXiUABOohULv
         glTQ==
X-Gm-Message-State: ACgBeo0KM4zwc4UQmGb39RoDzXDPt85QIv2tce5MwX5uVnQAw3OBhz+R
        x33HA7mKFCpZAMvAi6znHoxrkLPKpEvyGVOWz63mx5wBUj5jqeKATjBQMyOPhZKbee++pTW4/EQ
        NzqP3gXSyTGKS
X-Received: by 2002:a1c:5408:0:b0:3a5:5380:1f0c with SMTP id i8-20020a1c5408000000b003a553801f0cmr8621429wmb.22.1660303038404;
        Fri, 12 Aug 2022 04:17:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5kRgnRLONY++5noljgBkEKfRWlSfoMEmDvayaO4LHF6zu6hzy09dOq/6tBQNTQSV1JUg1XCQ==
X-Received: by 2002:a1c:5408:0:b0:3a5:5380:1f0c with SMTP id i8-20020a1c5408000000b003a553801f0cmr8621412wmb.22.1660303038110;
        Fri, 12 Aug 2022 04:17:18 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7416:9d00:bb54:f6b1:32e:b9fc])
        by smtp.gmail.com with ESMTPSA id g18-20020a5d5552000000b0021e43b4edf0sm1732604wrw.20.2022.08.12.04.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 04:17:17 -0700 (PDT)
Date:   Fri, 12 Aug 2022 07:17:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, parav@nvidia.com,
        xieyongji@bytedance.com, gautam.dawar@amd.com
Subject: Re: [PATCH V5 0/6] ifcvf/vDPA: support query device config space
 through netlink
Message-ID: <20220812071638-mutt-send-email-mst@kernel.org>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812071251-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812071251-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 07:14:39AM -0400, Michael S. Tsirkin wrote:
> On Fri, Aug 12, 2022 at 06:44:54PM +0800, Zhu Lingshan wrote:
> > This series allows userspace to query device config space of vDPA
> > devices and the management devices through netlink,
> > to get multi-queue, feature bits and etc.
> > 
> > This series has introduced a new netlink attr
> > VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, this should be used to query
> > features of vDPA  devices than the management device.
> > 
> > Please help review.
> 
> I can't merge this for this merge window.
> Am I right when I say that the new thing here is patch 5/6 + new
> comments?
> If yes I can queue it out of the window, on top.

So at this point, can you please send patches on top of the vhost
tree? I think these are just patches 3 and 5 but please confirm.


> > Thanks!
> > Zhu Lingshan
> > 
> > Changes rom V4:
> > (1) Read MAC, MTU, MQ conditionally (Michael)
> > (2) If VIRTIO_NET_F_MAC not set, don't report MAC to userspace
> > (3) If VIRTIO_NET_F_MTU not set, report 1500 to userspace
> > (4) Add comments to the new attr
> > VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES(Michael)
> > (5) Add comments for reporting the device status as LE(Michael)
> > 
> > Changes from V3:
> > (1)drop the fixes tags(Parva)
> > (2)better commit log for patch 1/6(Michael)
> > (3)assign num_queues to max_supported_vqs than max_vq_pairs(Jason)
> > (4)initialize virtio pci capabilities in the probe() function.
> > 
> > Changes from V2:
> > Add fixes tags(Parva)
> > 
> > Changes from V1:
> > (1) Use __virito16_to_cpu(true, xxx) for the le16 casting(Jason)
> > (2) Add a comment in ifcvf_get_config_size(), to explain
> > why we should return the minimum value of
> > sizeof(struct virtio_net_config) and the onboard
> > cap size(Jason)
> > (3) Introduced a new attr VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES
> > (4) Show the changes of iproute2 output before and after 5/6 patch(Jason)
> > (5) Fix cast warning in vdpa_fill_stats_rec() 
> > 
> > Zhu Lingshan (6):
> >   vDPA/ifcvf: get_config_size should return a value no greater than dev
> >     implementation
> >   vDPA/ifcvf: support userspace to query features and MQ of a management
> >     device
> >   vDPA: allow userspace to query features of a vDPA device
> >   vDPA: !FEATURES_OK should not block querying device config space
> >   vDPA: Conditionally read fields in virtio-net dev config space
> >   fix 'cast to restricted le16' warnings in vdpa.c
> > 
> >  drivers/vdpa/ifcvf/ifcvf_base.c |  13 ++-
> >  drivers/vdpa/ifcvf/ifcvf_base.h |   2 +
> >  drivers/vdpa/ifcvf/ifcvf_main.c | 142 +++++++++++++++++---------------
> >  drivers/vdpa/vdpa.c             |  82 ++++++++++++------
> >  include/uapi/linux/vdpa.h       |   3 +
> >  5 files changed, 149 insertions(+), 93 deletions(-)
> > 
> > -- 
> > 2.31.1

