Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E074DDC6B
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 16:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiCRPIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 11:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237917AbiCRPIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 11:08:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 316D746170
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 08:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647616001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+yTgNP9oxuvI/AXZfZgs40R3qimySg0T7LRBYMUg5Ls=;
        b=Q5d62EFGntslzB2ajZSP8VeCAb3LNo/4q+RwL2aK9NoWCoV615tCRebgof+4YQrNToQ4qe
        bJRwgO5qCd0atYG+2npBr+xAaNFW+kwQ7H5jSuNmlbYbtFLo5GXJyZgFhCp4lpzlmVZf8B
        oNTnqiD9F/B4zJF5EUSTsycmbVzqS48=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-_hJErcuYMYyi1fGF6d1DfA-1; Fri, 18 Mar 2022 11:06:39 -0400
X-MC-Unique: _hJErcuYMYyi1fGF6d1DfA-1
Received: by mail-io1-f71.google.com with SMTP id z16-20020a05660217d000b006461c7cbee3so5234299iox.21
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 08:06:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+yTgNP9oxuvI/AXZfZgs40R3qimySg0T7LRBYMUg5Ls=;
        b=u0qxZp+2xp/rkduaLX/xOqPbLvHAM/yJ/IHCQe3gWKsUnuijBxRcHqAnqYttU86Fao
         w2WAeNoVlP+miR4mi12mSZfm3Yc5hu6/9YYp0AQDtVOsN9NoBJW6TZ+entYAyZIJLlCe
         EztwAeAPXUA7LZfNJIDNjart9VgkY+bPdGqgG5LxJi075KoAwNnLrUeDS9D4zIUwCbZJ
         EpMk4aJuffz1iR4R8yGKNS29pptK53Dlbq8op7KKD5JUQFi3UU9KgufrhjYrZhcZi2Qt
         kDB7WLA6AxNrR4hNFfPCLHD44faTpgJ/iieWO+Gbs6POvpDGAeuJzuUYOWBWm0XmRcl8
         beOQ==
X-Gm-Message-State: AOAM5310sbzAO1tz439Fc1UPnusyjCMSv/LM2rTweoZP4wIEtfIvxFGh
        t92Cfw20MtssZvnMzfXLSv6L8NorW9N7XauEL23R78upH7deFj1r18QZKAwoJpj6JJRdWtKkzsU
        j3cMeAHnD+VA3
X-Received: by 2002:a05:6638:218f:b0:320:a695:f0f2 with SMTP id s15-20020a056638218f00b00320a695f0f2mr173928jaj.49.1647615998972;
        Fri, 18 Mar 2022 08:06:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymayIsjkmANn+DTGl8tpCUAdgZcTDVNqMKfMTxfw6TG27DM9/Ia6QTdXNzkbGOrbUAVMcxxw==
X-Received: by 2002:a05:6638:218f:b0:320:a695:f0f2 with SMTP id s15-20020a056638218f00b00320a695f0f2mr173911jaj.49.1647615998747;
        Fri, 18 Mar 2022 08:06:38 -0700 (PDT)
Received: from redhat.com ([98.55.18.59])
        by smtp.gmail.com with ESMTPSA id k1-20020a056e021a8100b002c64cf94399sm5232905ilv.44.2022.03.18.08.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 08:06:38 -0700 (PDT)
Date:   Fri, 18 Mar 2022 09:06:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        John Levon <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: iommufd dirty page logging overview
Message-ID: <20220318090636.6ea05cfd.alex.williamson@redhat.com>
In-Reply-To: <20220318124108.GF11336@nvidia.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
        <20220316235044.GA388745@nvidia.com>
        <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220318124108.GF11336@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Mar 2022 09:41:08 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Mar 18, 2022 at 09:23:49AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, March 17, 2022 7:51 AM
> > >   
> > > > there a rough idea of how the new dirty page logging will look like?
> > > > Is this already explained in the email threads an I missed it?  
> > > 
> > > I'm hoping to get something to show in the next few weeks, but what
> > > I've talked about previously is to have two things:
> > > 
> > > 1) Control and reporting of dirty tracking via the system IOMMU
> > >    through the iommu_domain interface exposed by iommufd
> > > 
> > > 2) Control and reporting of dirty tracking via a VFIO migration
> > >    capable device's internal tracking through a VFIO_DEVICE_FEATURE
> > >    interface similar to the v2 migration interface
> > > 
> > > The two APIs would be semantically very similar but target different
> > > HW blocks. Userspace would be in charge to decide which dirty tracker
> > > to use and how to configure it.
> > >   
> > 
> > for the 2nd option I suppose userspace is expected to retrieve
> > dirty bits via VFIO_DEVICE_FEATURE before every iommufd 
> > unmap operation in precopy phase, just like why we need return
> > the dirty bitmap to userspace in iommufd unmap interface in
> > the 1st option. Correct?  
> 
> It would have to be after unmap, not before
> 
> > Is there any value of having iommufd pull dirty bitmap from
> > vfio driver then the userspace can just stick to a unified
> > iommufd interface for dirty pages no matter they are tracked
> > by system IOMMU or device IP? Sorry if this has been discussed
> > in previous threads which I haven't fully checked.  
> 
> It is something to discuss, this is sort of what the current vfio
> interface imagines

Yes.

> But to do it we need to build a whole bunch of infrastructure to
> register and control these things and add new ioctls to vfio to
> support this. I'm not sure we get a sufficient benifit to be
> worthwhile, infact it is probably a net loss as we loose the ability
> for userspace to pull the dirty bits from multiple device trackers in
> parallel with threading.

It seems like the new ioctls and such would be to configure the 2nd
option, the current assumption is the iommu collects all dirty bits.

There are advantages to each, the 2nd option gives the user more
visibility, more options to thread, but it also possibly duplicates
significant data.

The unmap scenario above is also not quite as cohesive if the user
needs to poll devices for dirty pages in the unmapped range after
performing the unmap.  It might make sense if the iommufd could
generate the merged bitmap on unmap as the threading optimization
probably has less value in that case.  Thanks,

Alex

