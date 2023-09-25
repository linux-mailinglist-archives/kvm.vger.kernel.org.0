Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A837AE01E
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 21:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjIYTxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 15:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYTxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 15:53:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFC7109
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695671535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vij2tAFDCy7t+kNBMMGWQ+6bzq78Otf5CwiIdMQN6h4=;
        b=QxXxQOaUUgrxXfFPSuzMTWiieLBMsyMEPOJqiGaidNnU1w5WNKSmInOKdksTVk+rv92YNb
        FEqC7Cr78Zl4ckSGnUGix6Bb5fXOXFyoLoPJ1oMOlldFTwC311kSrz66hgDDs4Bc8jw6Hl
        C/731xGOEoVw9yMB9AgHqpLH/dyDgKA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-SeFeBvxSPUS8cNnOgpoykA-1; Mon, 25 Sep 2023 15:52:14 -0400
X-MC-Unique: SeFeBvxSPUS8cNnOgpoykA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-65b13294747so34703546d6.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695671533; x=1696276333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vij2tAFDCy7t+kNBMMGWQ+6bzq78Otf5CwiIdMQN6h4=;
        b=wPizfQ5+9CrpRLkZJCdTMvlEvvzoQ3cHZUa2Hm9ZSFvFPQh+g/WalWoDzr9jJXA2HO
         ngpoXI0GfIPtcOBs6EftG06SnRMGC2NmA32vFsdhnsEIn0c5plIjH1/9GHM0eGHzJ00Y
         kC0hY8XF7W3uy0HTxPzXp81l95+jVBixTPOpnFNeDGrGSMdmrwFp0VsOHw0GkJkJZmIM
         vIB4iMbZ3tP9mm6S6vKJwhNRQSds0XUaCea6tcgWI8KXrCScOQU1PiYsUY8tlQunkx6D
         UyEzBrGqnFkNK9YGRl4O4khcrM46ngMirpO+iFzGo9O1kTCQWlq8BgElyF/jsuNsZK+5
         YQmg==
X-Gm-Message-State: AOJu0YzVb7T+FHwNwbrLBEp5DdsSNGhgpZP4qOQGvMSkLg7SR9yuz9rr
        t8ITqPNCYuBZ/oBsi/sxxvldN1HOa5O8OqXIKLQnnr8paYKEdN+RPlDJH0pJUuuEWxTZQE0u2kN
        Fcq5FLKirOvTG
X-Received: by 2002:a0c:f105:0:b0:658:41ee:faf2 with SMTP id i5-20020a0cf105000000b0065841eefaf2mr6908714qvl.23.1695671533515;
        Mon, 25 Sep 2023 12:52:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGv618qn7iMismssguJZY82mZhr3Q9ZZZ2hUqLv0J/ZFLY+49u4eqAMtzhN4277ayVB0TfUtw==
X-Received: by 2002:a0c:f105:0:b0:658:41ee:faf2 with SMTP id i5-20020a0cf105000000b0065841eefaf2mr6908694qvl.23.1695671533177;
        Mon, 25 Sep 2023 12:52:13 -0700 (PDT)
Received: from redhat.com ([185.184.228.174])
        by smtp.gmail.com with ESMTPSA id a13-20020a05620a16cd00b0076cbcf8ad3bsm1976635qkn.55.2023.09.25.12.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 12:52:12 -0700 (PDT)
Date:   Mon, 25 Sep 2023 15:52:05 -0400
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
Message-ID: <20230925154622-mutt-send-email-mst@kernel.org>
References: <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <CACGkMEt=dxhJP4mUUWh+x-TSxA5JQcvmhJbkLJMWdN8oXV6ojg@mail.gmail.com>
 <20230922122501.GP13733@nvidia.com>
 <20230922111342-mutt-send-email-mst@kernel.org>
 <20230922161928.GS13733@nvidia.com>
 <20230925133637-mutt-send-email-mst@kernel.org>
 <20230925185318.GK13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925185318.GK13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 03:53:18PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 25, 2023 at 02:16:30PM -0400, Michael S. Tsirkin wrote:
> 
> > I do want to understand if there's a use-case that vdpa does not address
> > simply because it might be worth while to extend it to do so, and a
> > bunch of people working on it are at Red Hat and I might have some input
> > into how that labor is allocated. But if the use-case is simply "has to
> > be vfio and not vdpa" then I guess not.
> 
> If you strip away all the philisophical arguing VDPA has no way to
> isolate the control and data virtqs to different IOMMU configurations
> with this single PCI function.

Aha, so address space/PASID support then?

> The existing HW VDPA drivers provided device specific ways to handle
> this.
> 
> Without DMA isolation you can't assign the high speed data virtq's to
> the VM without mediating them as well.
> 
> > It could be that we are using mediation differently - in my world it's
> > when there's some host software on the path between guest and hardware,
> > and this qualifies.  
> 
> That is pretty general. As I said to Jason, if you want to use it that
> way then you need to make up a new word to describe what VDPA does as
> there is a clear difference in scope between this VFIO patch (relay IO
> commands to the device) and VDPA (intercept all the control plane,
> control virtq and bring it to a RedHat/qemu standard common behavior)

IIUC VDPA itself does not really bring it to either RedHat or qemu
standard, it just allows userspace to control behaviour - if userspace
is qemu then it's qemu deciding how it behaves. Which I guess this
doesn't. Right?  RedHat's not in the picture at all I think.

> > There is also a question of capability. Specifically iommufd support
> > is lacking in vdpa (though there are finally some RFC patches to
> > address that). All this is fine, could be enough to motivate
> > a work like this one.
> 
> I've answered many times, you just don't semm to like the answers or
> dismiss them as not relevant to you.
> 
> Jason


Not really I think I lack some of the picture so I don't fully
understand. Or maybe I missed something else.

-- 
MST

