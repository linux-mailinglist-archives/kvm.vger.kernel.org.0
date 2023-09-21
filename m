Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6475B7AA4D7
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 00:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbjIUWVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 18:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbjIUWVF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 18:21:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBED9D454
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695318952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MyqhpxeqARsdhRIANht3YMfMPFXcwzP0mgld7CNMDxo=;
        b=AcSiS0jjxmm1/AUwyiL3daAF/fLusOonzgLJFFreWb3SLPISagP0iTnMWkCUK2dSRsmdKk
        RtVjPPqmgOzmMSB+SahDP+nB+1qrWRdO4DfKwINK5pek7CHAGguUA0NnpLusb50ypeY1D1
        bdmlpS4mZ6c7JW10mongPtNwz8r9bJc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-jsspbXJAMMqGxrXC1QJqFQ-1; Thu, 21 Sep 2023 13:55:49 -0400
X-MC-Unique: jsspbXJAMMqGxrXC1QJqFQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-51d981149b5so860950a12.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695318948; x=1695923748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyqhpxeqARsdhRIANht3YMfMPFXcwzP0mgld7CNMDxo=;
        b=oo6G42TdLPdYJlnoIp2Vq25JfZ1RZcDHgKXj23c/voaAy0R/CLBCZcj/lvDlB/cG7J
         sFjMCq3xDllgjAE2IKhfiOtyd6w/hoXv+nI0YphEjOgT1peKln4xJwZOADoapVmgqhA7
         VAzc4mGJPwGE7HozsLDV2amfrF91cSAfnZZjz95X1VPVan4RggAHMGjWlClJJ/qGN35b
         x5TqbQKEZfilIBRCDUSWBSwNE1pd9zr0ZXO/4E3M6G9lNWws+W7uDXVOcChO2lueufQp
         XE62zThz3azWMwemUwOzJ6KEeWfcMvhSkTGIJy3aDbAj/8CP4t1WK1a8i0Pk76c6eiqA
         zQTA==
X-Gm-Message-State: AOJu0YxfM16SjEoTPBYzxipXP1ycXKxxCTliR+c40kZfBIc1Kc0eTKKs
        0cLKYj1248fadKMLNsLcKVgy9v32V0w5yuGpAqk/TvistkET6TliFT0UM4b2RNWudvNjn077QK7
        CulHZ6CZhueVs
X-Received: by 2002:aa7:ca46:0:b0:531:3e89:1bef with SMTP id j6-20020aa7ca46000000b005313e891befmr5135979edt.32.1695318948398;
        Thu, 21 Sep 2023 10:55:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/o7VnKnRlPFEfg+S7+ZS1Dsa+PHHOMSB6nxkr8+EDv0DGoCJGxXPKJmVvaB3A+xIAnEQumw==
X-Received: by 2002:aa7:ca46:0:b0:531:3e89:1bef with SMTP id j6-20020aa7ca46000000b005313e891befmr5135959edt.32.1695318948058;
        Thu, 21 Sep 2023 10:55:48 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id c21-20020aa7df15000000b00532c5e2d375sm1139679edy.1.2023.09.21.10.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 10:55:47 -0700 (PDT)
Date:   Thu, 21 Sep 2023 13:55:42 -0400
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
Message-ID: <20230921135426-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921174450.GT13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 02:44:50PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 01:21:26PM -0400, Michael S. Tsirkin wrote:
> > Yea it's very useful - it's also useful for vdpa whether this patchset
> > goes in or not.  At some level, if vdpa can't keep up then maybe going
> > the vfio route is justified. I'm not sure why didn't anyone fix iommufd
> > yet - looks like a small amount of work. I'll see if I can address it
> > quickly because we already have virtio accelerators under vdpa and it
> > seems confusing to people to use vdpa for some and vfio for others, with
> > overlapping but slightly incompatible functionality.  I'll get back next
> > week, in either case. I am however genuinely curious whether all the new
> > functionality is actually useful for these legacy guests.
> 
> It doesn't have much to do with the guests - this is new hypervisor
> functionality to make the hypervisor do more things. This stuff can
> still work with old VMs.
> 
> > > > Another question I'm interested in is whether there's actually a
> > > > performance benefit to using this as compared to just software
> > > > vhost. I note there's a VM exit on each IO access, so ... perhaps?
> > > > Would be nice to see some numbers.
> > > 
> > > At least a single trap compared with an entire per-packet SW flow
> > > undoubtably uses alot less CPU power in the hypervisor.
> >
> > Something like the shadow vq thing will be more or less equivalent
> > then?
> 
> Huh? It still has the entire netdev stack to go through on every
> packet before it reaches the real virtio device.

No - shadow vq just tweaks the descriptor and forwards it to
the modern vdpa hardware. No net stack involved.

> > That's upstream in qemu and needs no hardware support. Worth comparing
> > against.  Anyway, there's presumably actual hardware this was tested
> > with, so why guess? Just test and post numbers.
> 
> Our prior benchmarking put our VPDA/VFIO solutions at something like
> 2x-3x improvement over the qemu SW path it replaces.
> Parav said 10% is lost, so 10% of 3x is still 3x better :)
> 
> I thought we all agreed on this when vdpa was created in the first
> place, the all SW path was hopeless to get high performance out of?
> 
> Jason

That's not what I'm asking about though - not what shadow vq does,
shadow vq is a vdpa feature.

