Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183657ADFC3
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 21:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjIYTpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 15:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjIYTpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 15:45:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA002103
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695671061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mMU7NywJrh4BHVnQGkVt0mklZf13jbuE4bUSz+J1lQE=;
        b=NLnkxabKmhjOSfjk2RV71bqRVP9aZVhne1EzaqQHEsg84OsbBx4flCAnB735aesZbxtqi/
        H6ssGqiwiXizK4xkoJfp/+O2sQyS4FSm6M3k7+rbTITisNnYTZx/7aQYzs+1EGwrnU1eYO
        QqM3wJzaVVs1N6DyHiqEGNn2Z94zptY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-8guSjw3XMY2pKuEaDpNrAQ-1; Mon, 25 Sep 2023 15:44:20 -0400
X-MC-Unique: 8guSjw3XMY2pKuEaDpNrAQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-65b23c40cefso1559876d6.1
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695671060; x=1696275860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mMU7NywJrh4BHVnQGkVt0mklZf13jbuE4bUSz+J1lQE=;
        b=r/EWbV85VqOggQpIDow5Lm9MQDFotGMprqzIhphanBQT/eMwhs5aeP9+yZz/tFnElG
         I/Ula90U5BqwJRASN+sbWZ/VmODXvKC+oiOOudzVUeFsiIfNhCliYxqZ83csPBqPVH5+
         9IjQiEHBiV1zVfGVIZUP4UF+43SpU5sl0v6hpvS38InrSjZpgeBMZyo0k20JhljeMQg2
         +iolCAotRXrzq3A9hHV0PIp/ascdU/r7vQP2iMvkKdt+4wT93FTDdZGQHL/nLO/r+xxy
         qmlkzI7mIXLXEopHnuHQCiqpesoZ0YOIsbQf+scsLAwSm70wJsFDpS7E249uJhJ+FFBJ
         6yyg==
X-Gm-Message-State: AOJu0Yz8oT0GLv+Y4s8303gdHQ59x36T/i7mCjYHwCsFcFBubvAGISwG
        7aWrBduW0Q+mf2NZiLdaP7q5OW9dc3uQSE2JYAxQ/Lworn8EzBxaSKCyuhAEvydBZwdHbB9X09I
        gkd3XrSI8wUMOBjWv05of
X-Received: by 2002:a05:6214:a6a:b0:64f:8bdd:873 with SMTP id ef10-20020a0562140a6a00b0064f8bdd0873mr5673205qvb.3.1695671059707;
        Mon, 25 Sep 2023 12:44:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYX8cA2PPH5EQkqPiWRhZGZHOiNwBRCVFzgp1zyu4+jxBhcQLtJrqiGkExxjeSX5H+a8qrtA==
X-Received: by 2002:a05:6214:a6a:b0:64f:8bdd:873 with SMTP id ef10-20020a0562140a6a00b0064f8bdd0873mr5673190qvb.3.1695671059308;
        Mon, 25 Sep 2023 12:44:19 -0700 (PDT)
Received: from redhat.com ([185.184.228.174])
        by smtp.gmail.com with ESMTPSA id q8-20020a0cf5c8000000b006589375b888sm4363894qvm.67.2023.09.25.12.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 12:44:18 -0700 (PDT)
Date:   Mon, 25 Sep 2023 15:44:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230925143708-mutt-send-email-mst@kernel.org>
References: <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
 <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
 <20230925122607.GW13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925122607.GW13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 09:26:07AM -0300, Jason Gunthorpe wrote:
> > > So, as I keep saying, in this scenario the goal is no mediation in the
> > > hypervisor.
> > 
> > That's pretty fine, but I don't think trapping + relying is not
> > mediation. Does it really matter what happens after trapping?
> 
> It is not mediation in the sense that the kernel driver does not in
> any way make decisions on the behavior of the device. It simply
> transforms an IO operation into a device command and relays it to the
> device. The device still fully controls its own behavior.
> 
> VDPA is very different from this. You might call them both mediation,
> sure, but then you need another word to describe the additional
> changes VPDA is doing.

Sorry about hijacking the thread a little bit, but could you
call out some of the changes that are the most problematic
for you?

> > > It is pointless, everything you think you need to do there
> > > is actually already being done in the DPU.
> > 
> > Well, migration or even Qemu could be offloaded to DPU as well. If
> > that's the direction that's pretty fine.
> 
> That's silly, of course qemu/kvm can't run in the DPU.
> 
> However, we can empty qemu and the hypervisor out so all it does is
> run kvm and run vfio. In this model the DPU does all the OVS, storage,
> "VPDA", etc. qemu is just a passive relay of the DPU PCI functions
> into VM's vPCI functions.
> 
> So, everything VDPA was doing in the environment is migrated into the
> DPU.
> 
> In this model the DPU is an extension of the hypervisor/qemu
> environment and we shift code from x86 side to arm side to increase
> security, save power and increase total system performance.
> 
> Jason

I think I begin to understand. On the DPU you have some virtio
devices but also some non-virtio devices.  So you have to
use VFIO to talk to the DPU. Reusing VFIO to talk to virtio
devices too, simplifies things for you. If guests will see
vendor-specific devices from the DPU anyway, it will be impossible
to migrate such guests away from the DPU so the cross-vendor
migration capability is less important in this use-case.
Is this a good summary?


-- 
MST

