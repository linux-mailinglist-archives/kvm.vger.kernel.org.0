Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818DF7AE520
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 07:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbjIZFfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 01:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjIZFfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 01:35:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A233D7
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 22:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695706492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wlZAa2UjvOsuyM8pmm/wDliagPEyeZHIRgEbMXeCfoo=;
        b=Ql5QHHRAc/eUSIJlgUF6ip4liA1622JO/amwjE85ckub6htXzQfSxc0SVAbWeCJ6frh3LT
        gKpOG/z6Y1nWVlnALK090iVL+a//VshHIHp33rjS7ZKY7MW1L2tbE5K3TR5vEY26eEAOyF
        wWefHCHXwRnTZmKtzYC5eMcD8aA8xWM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-DmyRp6siNl-yUEqCqeptEg-1; Tue, 26 Sep 2023 01:34:50 -0400
X-MC-Unique: DmyRp6siNl-yUEqCqeptEg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-99bca0b9234so616487566b.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 22:34:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695706490; x=1696311290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wlZAa2UjvOsuyM8pmm/wDliagPEyeZHIRgEbMXeCfoo=;
        b=sQUf96oMxQ57vdIohiM/e24nd3MR5MhX0jp89diJIVqol+i7IuAU4x+56Ve9tZo1Bu
         Ix6h5BfAztP1wgLoghtB3/+C7IfKSaAxTkyiHlnOQ+c82n1hW49iH0Bf1XL+a9hYPHhp
         p4g3KMNK+WIOnRznEDZGW7kdbaCX5Xw5NktQIwcIMrG1lPuf7sOlN/CEyw9sluqvac6Y
         RiY2jej7DcISk9WrXRatFnLMGutrYBwLRN3ajuFEWxQMVlbQxjmtcCWSgelWzogRY3na
         k7EOaz4XGe9FNHs2DAcoVNC35/i8CS7Bi+5/nEEynU5ax1xGSukV+HvyiCOPk+7sVnz1
         J8Yw==
X-Gm-Message-State: AOJu0Yxm+BfF8EnPcX/MWb9nLF6yRoDYIAnv7he6Gn4mRf73N/KwVOqm
        5DJX5FePEBjkl0Tth8MRahjRtCtGjTevkjZ/oCSAsX9hynMVf08UJVN3kOkJRKfrfUumifBflo+
        lloo4+QrOnmjg
X-Received: by 2002:a17:907:da6:b0:9ae:65a5:b6f4 with SMTP id go38-20020a1709070da600b009ae65a5b6f4mr8974761ejc.20.1695706489787;
        Mon, 25 Sep 2023 22:34:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzkXlaim5/oWjEAmJmUxy8o9CN6yWWgjaiSAxwdGQ4Ks7jnhTVPgRLo4AR3/PP1nrSlJUkEA==
X-Received: by 2002:a17:907:da6:b0:9ae:65a5:b6f4 with SMTP id go38-20020a1709070da600b009ae65a5b6f4mr8974747ejc.20.1695706489472;
        Mon, 25 Sep 2023 22:34:49 -0700 (PDT)
Received: from redhat.com ([2.52.31.177])
        by smtp.gmail.com with ESMTPSA id lg15-20020a170906f88f00b0099d0a8ccb5fsm7160863ejb.152.2023.09.25.22.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 22:34:48 -0700 (PDT)
Date:   Tue, 26 Sep 2023 01:34:45 -0400
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
Message-ID: <20230926012236-mutt-send-email-mst@kernel.org>
References: <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
 <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
 <20230925122607.GW13733@nvidia.com>
 <20230925143708-mutt-send-email-mst@kernel.org>
 <20230926004059.GM13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926004059.GM13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 09:40:59PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 25, 2023 at 03:44:11PM -0400, Michael S. Tsirkin wrote:
> > > VDPA is very different from this. You might call them both mediation,
> > > sure, but then you need another word to describe the additional
> > > changes VPDA is doing.
> > 
> > Sorry about hijacking the thread a little bit, but could you
> > call out some of the changes that are the most problematic
> > for you?
> 
> I don't really know these details. The operators have an existing
> virtio world that is ABI toward the VM for them, and they do not want
> *anything* to change. The VM should be unware if the virtio device is
> created by old hypervisor software or new DPU software. It presents
> exactly the same ABI.
> 
> So the challenge really is to convince that VDPA delivers that, and
> frankly, I don't think it does. ABI toward the VM is very important
> here.

And to complete the picture, it is the DPU software/firmware that
is resposible for maintaining this ABI in your ideal world?


> > > In this model the DPU is an extension of the hypervisor/qemu
> > > environment and we shift code from x86 side to arm side to increase
> > > security, save power and increase total system performance.
> > 
> > I think I begin to understand. On the DPU you have some virtio
> > devices but also some non-virtio devices.  So you have to
> > use VFIO to talk to the DPU. Reusing VFIO to talk to virtio
> > devices too, simplifies things for you. 
> 
> Yes
> 
> > If guests will see vendor-specific devices from the DPU anyway, it
> > will be impossible to migrate such guests away from the DPU so the
> > cross-vendor migration capability is less important in this
> > use-case.  Is this a good summary?
> 
> Well, sort of. As I said before, the vendor here is the cloud
> operator, not the DPU supplier. The guest will see an AWS virtio-net
> function, for example.
> 
> The operator will ensure that all their different implementations of
> this function will interwork for migration.
> 
> So within the closed world of a single operator live migration will
> work just fine.
> 
> Since the hypervisor's controlled by the operator only migrate within
> the operators own environment anyhow, it is an already solved problem.
> 
> Jason


Okay the picture emerges I think. Thanks! I'll try to summarize later
for everyone's benefit.


-- 
MST

