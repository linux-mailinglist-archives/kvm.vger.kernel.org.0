Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5227B145D
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 09:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjI1HOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 03:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjI1HOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 03:14:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E174C24
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 00:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695885004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xp82++crOZoaM6X/LxOAj7IKSMWgMbb+sdsAJug1YDc=;
        b=MomZBuIhyaTJjsEu+643LbxSD25vAfvZkYKlY+CrYACeX2O5LzmCz4MkLFGmZYtP4bhL+J
        Ei76eWV1WamUf7ugwhbw0u4OPcsMc9Ogma+8htX4tXLWAizgXx71ChTN6Z0zZjBl4LVj1T
        6IOFOaYMKPzWAf7UxlKeU1Y7K4dht+M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-MKvPhzZpOauK34TJJA-1PQ-1; Thu, 28 Sep 2023 01:26:39 -0400
X-MC-Unique: MKvPhzZpOauK34TJJA-1PQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-323306960e3so4870333f8f.1
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 22:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695878798; x=1696483598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xp82++crOZoaM6X/LxOAj7IKSMWgMbb+sdsAJug1YDc=;
        b=l9oflPpQMN0RnIbDCTF3mqistvqCbt4bB/DWxoindr3hjALS9JwuMEVrs768Itpsfs
         6TG1a/bYU3RS73tlU/5Mtdtyaaw11XXpD0/uDV0SuN1+XaOBvhdO5aitxXQImYxkbYQF
         MzVsptN8phDvkhw5wWJN5FbQ7gYS+FqZAnPO9RjAVKem+/xmMf/qgpBEEE9VMdNtHKQk
         OOLaryb0RadSBILWUrH1xXu37VwjCLss/mvEKRt9/ljn8yJqnus35MWIuguPkFlibpdf
         ApNEu0Dt/SEaO+rrDuS+3nykxuScYKMdOfAykVnzUM/emrxBPhAFPfzDuFvtckPDR7PI
         DRZA==
X-Gm-Message-State: AOJu0YzKSbcpfsoS3TuBo0USwFAnFcWsA8Wy7nGjAIwKYc4iHFmvuoZB
        7zAWLGbY/cZMSvaSOlAb9GlAsNCuUTAFq8tNNt75Tkkm9Hreq+POKR0kuUgcA2P3zw67qwpqKeL
        0AIjvKdp/e2ON
X-Received: by 2002:adf:ee48:0:b0:321:4790:bb5e with SMTP id w8-20020adfee48000000b003214790bb5emr219028wro.38.1695878798339;
        Wed, 27 Sep 2023 22:26:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPQurwO0AoypE2TWDU+Q7g/w7BZXGQF9+IGHSN11iCczls2yJnowTHsFwo18o3y5sbXPmLcA==
X-Received: by 2002:adf:ee48:0:b0:321:4790:bb5e with SMTP id w8-20020adfee48000000b003214790bb5emr219011wro.38.1695878797857;
        Wed, 27 Sep 2023 22:26:37 -0700 (PDT)
Received: from redhat.com ([2.52.19.249])
        by smtp.gmail.com with ESMTPSA id a13-20020adff7cd000000b0031ad5fb5a0fsm3599926wrq.58.2023.09.27.22.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 22:26:36 -0700 (PDT)
Date:   Thu, 28 Sep 2023 01:26:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, virtualization@lists.linux-foundation.org,
        jiri@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20230928010136-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <20230927131817.GA338226@nvidia.com>
 <20230927172806-mutt-send-email-mst@kernel.org>
 <20230927231600.GD339126@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927231600.GD339126@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 08:16:00PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 27, 2023 at 05:30:04PM -0400, Michael S. Tsirkin wrote:
> > On Wed, Sep 27, 2023 at 10:18:17AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Sep 26, 2023 at 07:41:44AM -0400, Michael S. Tsirkin wrote:
> > > 
> > > > > By the way, this follows what was done already between vfio/mlx5 to
> > > > > mlx5_core modules where mlx5_core exposes generic APIs to execute a command
> > > > > and to get the a PF from a given mlx5 VF.
> > > > 
> > > > This is up to mlx5 maintainers. In particular they only need to worry
> > > > that their patches work with specific hardware which they likely have.
> > > > virtio has to work with multiple vendors - hardware and software -
> > > > and exposing a low level API that I can't test on my laptop
> > > > is not at all my ideal.
> > > 
> > > mlx5 has a reasonable API from the lower level that allows the vfio
> > > driver to safely issue commands. The API provides all the safety and
> > > locking you have been questioning here.
> > > 
> > > Then the vfio driver can form the commands directly and in the way it
> > > needs. This avoids spewing code into the core modules that is only
> > > used by vfio - which has been a key design consideration for our
> > > driver layering.
> > > 
> > > I suggest following the same design here as it has been well proven.
> > > Provide a solid API to operate the admin queue and let VFIO use
> > > it. One of the main purposes of the admin queue is to deliver commands
> > > on behalf of the VF driver, so this is a logical and reasonable place
> > > to put an API.
> > 
> > Not the way virtio is designed now. I guess mlx5 is designed in
> > a way that makes it safe.
> 
> If you can't reliably issue commmands from the VF at all it doesn't
> really matter where you put the code. Once that is established up then
> an admin command execution interface is a nice cut point for
> modularity.
> 
> The locking in mlx5 to make this safe is not too complex, if Feng
> missed some items for virtio then he can work to fix it up.

Above two paragraphs don't make sense to me at all. VF issues
no commands and there's no locking.

> > > VFIO live migration is expected to come as well once OASIS completes
> > > its work.
> > 
> > Exactly. Is there doubt vdpa will want to support live migration?
> > Put this code in a library please.
> 
> I have a doubt, you both said vdpa already does live migration, so
> what will it even do with a live migration interface to a PCI
> function?

This is not the thread to explain how vdpa live migration works now and
why it needs new interfaces, sorry. Suffice is to say right now on virtio
tc Parav from nvidia is arguing for vdpa to use admin commands for
migration.

> It already has to use full mediation to operate a physical virtio
> function, so it seems like it shouldn't need the migration interface?
> 
> Regardless, it is better kernel development hygiene to put the code
> where it is used and wait for a second user to consolidate it than to
> guess.
> 
> Jason

Sorry no time right now to argue philosophy. I gave some hints on how to
make the virtio changes behave in a way that I'm ok with maintaining.
Hope they help.

-- 
MST

