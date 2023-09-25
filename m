Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB89D7ADE72
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 20:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjIYSRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 14:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjIYSRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 14:17:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730208E
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695665801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NFY8KO7exZJuGoSNda4VqGBb8Equ+XlWtrdZ2h/i9EE=;
        b=S29OvmRBJCjtA6wWvHsAJ8aECx7oTqE8EF+TBn4g2qlmLuQN+HIaLKdK7LOnSc592WxqoO
        mbLc493KrzeRwPtcR+8DlYcLeY+Aj0gRHnZ52WbZc1fBtSW531yISF9auJl0BsMmceEzzM
        NLJkKS1yVHNPj83JOrimUXZH21o5XL0=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-pmWyiFMUNhy_ZkbuE1RWHQ-1; Mon, 25 Sep 2023 14:16:39 -0400
X-MC-Unique: pmWyiFMUNhy_ZkbuE1RWHQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1dcf9fda747so9652301fac.1
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695665798; x=1696270598;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NFY8KO7exZJuGoSNda4VqGBb8Equ+XlWtrdZ2h/i9EE=;
        b=Vn06n4DrCQaYfvsdyiweSazWnKout9lhpTDp8KCGWwQjQ8EgKpkizraHEPQp40qSCB
         orDqvQHfBvP/eQhJDZA3eugYcah0uBxqMS+nxAMSDGTZyVVKHQIBOPz5g7DYctfP8wWp
         EUii7H2fiJIllTUr2PNhxvpGCJxx56nSW3nCFzigCqnJ9h5cJk4Xnpxo1uvIe4v9e/Hq
         A269EkSMPM7g+Ak9aCMYs7EeewJO4KqLVBDOfNts7T3j06PZc8svh+WXNyoPnnxLO06H
         2zPC8xYgUU10JgNDfOYyXHVfm6MDFdU0gMOapFPsolgItLSd17yLpFjK0lP8ThV8KdJL
         jSmA==
X-Gm-Message-State: AOJu0YzNIcaFdgdwFD5CCzkKDiXu0mQ+ZURv0qdX7CKbfOHOBviq/+UY
        nwVp2Ql9ahmDRgwEb+xqZnzUQ9rmpqfr1oJgxMigh/MVVRjK+69TV7HVlHegLeHUxBfQg/wXIds
        hzo8XFeXnAIdV
X-Received: by 2002:a05:6870:41c7:b0:1c0:2e8f:17fd with SMTP id z7-20020a05687041c700b001c02e8f17fdmr10557340oac.40.1695665798584;
        Mon, 25 Sep 2023 11:16:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwXE1LPmfUYbPthMNSP0cmJcMi8DExG+rfbujPW1+QPh8DQXLcBnujK+Md9C5G0HWt8tsanw==
X-Received: by 2002:a05:6870:41c7:b0:1c0:2e8f:17fd with SMTP id z7-20020a05687041c700b001c02e8f17fdmr10557305oac.40.1695665798203;
        Mon, 25 Sep 2023 11:16:38 -0700 (PDT)
Received: from redhat.com ([185.184.228.174])
        by smtp.gmail.com with ESMTPSA id cx4-20020a05620a51c400b007743382121esm941451qkb.84.2023.09.25.11.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 11:16:37 -0700 (PDT)
Date:   Mon, 25 Sep 2023 14:16:30 -0400
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
Message-ID: <20230925133637-mutt-send-email-mst@kernel.org>
References: <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <CACGkMEt=dxhJP4mUUWh+x-TSxA5JQcvmhJbkLJMWdN8oXV6ojg@mail.gmail.com>
 <20230922122501.GP13733@nvidia.com>
 <20230922111342-mutt-send-email-mst@kernel.org>
 <20230922161928.GS13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230922161928.GS13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 01:19:28PM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 22, 2023 at 11:39:19AM -0400, Michael S. Tsirkin wrote:
> > On Fri, Sep 22, 2023 at 09:25:01AM -0300, Jason Gunthorpe wrote:
> > > On Fri, Sep 22, 2023 at 11:02:50AM +0800, Jason Wang wrote:
> > > > On Fri, Sep 22, 2023 at 3:53 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > > >
> > > > > On Thu, Sep 21, 2023 at 03:34:03PM -0400, Michael S. Tsirkin wrote:
> > > > >
> > > > > > that's easy/practical.  If instead VDPA gives the same speed with just
> > > > > > shadow vq then keeping this hack in vfio seems like less of a problem.
> > > > > > Finally if VDPA is faster then maybe you will reconsider using it ;)
> > > > >
> > > > > It is not all about the speed.
> > > > >
> > > > > VDPA presents another large and complex software stack in the
> > > > > hypervisor that can be eliminated by simply using VFIO.
> > > > 
> > > > vDPA supports standard virtio devices so how did you define
> > > > complexity?
> > > 
> > > As I said, VFIO is already required for other devices in these VMs. So
> > > anything incremental over base-line vfio-pci is complexity to
> > > minimize.
> > > 
> > > Everything vdpa does is either redundant or unnecessary compared to
> > > VFIO in these environments.
> > > 
> > > Jason
> > 
> > Yes but you know. There are all kind of environments.  I guess you
> > consider yours the most mainstream and important, and are sure it will
> > always stay like this.  But if there's a driver that does what you need
> > then you use that.
> 
> Come on, you are the one saying we cannot do things in the best way
> possible because you want your way of doing things to be the only way
> allowed. Which of us thinks "yours the most mainstream and important" ??
> 
> I'm not telling you to throw away VPDA, I'm saying there are
> legimitate real world use cases where VFIO is the appropriate
> interface, not VDPA.
> 
> I want choice, not dogmatic exclusion that there is Only One True Way.

I don't particularly think there's only one way, vfio is already there.
I am specifically thinking about this patch, for example it
muddies the waters a bit: normally I think vfio exposed device
with the same ID, suddenly it changes the ID as visible to the guest.
But again, whether doing this kind of thing is OK is more up to Alex than me.

I do want to understand if there's a use-case that vdpa does not address
simply because it might be worth while to extend it to do so, and a
bunch of people working on it are at Red Hat and I might have some input
into how that labor is allocated. But if the use-case is simply "has to
be vfio and not vdpa" then I guess not.




> > You really should be explaining what vdpa *does not* do that you
> > need.
> 
> I think I've done that enough, but if you have been following my
> explanation you should see that the entire point of this design is to
> allow a virtio device to be created inside a DPU to a specific
> detailed specification (eg an AWS virtio-net device, for instance)
> 
> The implementation is in the DPU, and only the DPU.
> 
> At the end of the day VDPA uses mediation and creates some
> RedHat/VDPA/Qemu virtio-net device in the guest. It is emphatically
> NOT a perfect recreation of the "AWS virtio-net" we started out with.
> 
> It entirely fails to achieve the most important thing it needs to do!

It could be that we are using mediation differently - in my world it's
when there's some host software on the path between guest and hardware,
and this qualifies.  The difference between what this patch does and
what vdpa does seems quantitative, not qualitative. Which might be
enough to motivate this work, I don't mind. But you seem to feel
it is qualitative and I am genuinely curious about it, because
if yes then it might lead e.g. the virtio standard in new directions.

I can *imagine* all kind of reasons to want to use vfio as compared to vdpa;
here are some examples I came up with, quickly:
- maybe you have drivers that poke at registers not in virtio spec:
  vfio allows that, vdpa by design does not
- maybe you are using vfio with a lot of devices already and don't want
  to special-case handling for virtio devices on the host
do any of the above motivations ring the bell? Some of the things you
said seem to hint at that. If yes maybe include this in the cover
letter.

There is also a question of capability. Specifically iommufd support
is lacking in vdpa (though there are finally some RFC patches to
address that). All this is fine, could be enough to motivate
a work like this one. But I am very curious to know if there
is any other capability lacking in vdpa. I asked already and you
didn't answer so I guess not?




> Yishai will rework the series with your remarks, we can look again on
> v2, thanks for all the input!
> 
> Jason

