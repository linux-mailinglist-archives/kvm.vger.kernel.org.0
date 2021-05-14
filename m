Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B06380A79
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 15:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhENNk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 09:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhENNkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 09:40:55 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7912C061574
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 06:39:42 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id h21so18431180qtu.5
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 06:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fw8jRpLJUUiDLFl+R/OeLe/+vcSlILAW8JDLv7Pnlgw=;
        b=ZA9iIphKPPHvcLSkBu2C/QMxUDhXyUp7Ql0A7zhq+gl8tX2VVw4d6MWbL3YGt3zMia
         eovdKfEgpKv/Kc6JgMp9UCw9S8MZR5nPFduJNr7x/z0XbVlGgNLXVftzfUVKBu0b6ABm
         RinPPw/eYvAo5xq2FjGO1ry+PBwldBVbyqtEvWJumFPyH6ThWymQ9gXFH0NAf+gQaVpn
         M9srCHz/FBZ/gl8Q7AQ70j9xSGfCbxZD9KMqMhWJ8ejqfvSLeS76TlpPfl+r5p2DMKcd
         O1K+SZm8GDVksZO0NYGjA4OCifqgsBaX7QsLUNiJf774sdooSmqhK4/lbsOJfcz7ocEi
         FQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fw8jRpLJUUiDLFl+R/OeLe/+vcSlILAW8JDLv7Pnlgw=;
        b=odPUPpNwAFiMHbsABenq8e90TNGMK/eEaskO9UzeeoFOZNYOHGZk9Auf7QAUNHlGuQ
         WNBS3QPskBwLiV2emSSBXcOgppQXx6SfEgschtr3fingmrk7YICsCLDuDRQVZmAdXhCX
         W+FeVonvQIYHP+O78hm5KE18QsMgHjXwck0A/3NZmTEk64en96dHGe6T/4lvGKRdvp8V
         lGt2VjJltxSozcG38XGNDFd2Y+CDzpMVALkqIAYYtQ8VKtjoWBcYWcrMh0cnewKTAQ8h
         kjcmI4Iy+bCFXg4Mq3L2sRJoRChy7WSgcMNwahMWBIXxiyD//8swG3FzlS8ahhEkv1lY
         cXBg==
X-Gm-Message-State: AOAM5325RFK5BVAXfi3UK+eXemM0jAHDe/1rNFyPu6br1ZXjF/SSdK7f
        msw4fvtj4qdzy4Ci1tr68jYbYw==
X-Google-Smtp-Source: ABdhPJyHkmiobTC20DDQbl/CkwGCuAAsPOfAEooNlfis4Grfk/a3JX140lwF9zGRuivL/kulThANeQ==
X-Received: by 2002:a05:622a:5c9:: with SMTP id d9mr14474203qtb.177.1620999582009;
        Fri, 14 May 2021 06:39:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id 11sm4839279qkk.31.2021.05.14.06.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 06:39:41 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lhY2V-007RfW-Pl; Fri, 14 May 2021 10:39:39 -0300
Date:   Fri, 14 May 2021 10:39:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Message-ID: <20210514133939.GL1096940@ziepe.ca>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de>
 <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB18863613CEBE3CDEEB86F4FC8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18863613CEBE3CDEEB86F4FC8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 01:17:23PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Thursday, May 13, 2021 8:01 PM
> > 
> > On Thu, May 13, 2021 at 03:28:52AM +0000, Tian, Kevin wrote:
> > 
> > > Are you specially concerned about this iommu_device hack which
> > > directly connects mdev_device to iommu layer or the entire removed
> > > logic including the aux domain concept? For the former we are now
> > > following up the referred thread to find a clean way. But for the latter
> > > we feel it's still necessary regardless of how iommu interface is redesigned
> > > to support device connection from the upper level driver. The reason is
> > > that with mdev or subdevice one physical device could be attached to
> > > multiple domains now. there could be a primary domain with DOMAIN_
> > > DMA type for DMA_API use by parent driver itself, and multiple auxiliary
> > > domains with DOMAIN_UNMANAGED types for subdevices assigned to
> > > different VMs.
> > 
> > Why do we need more domains than just the physical domain for the
> > parent? How does auxdomain appear in /dev/ioasid?
> > 
> 
> Another simple reason. Say you have 4 mdevs each from a different 
> parent are attached to an ioasid. If only using physical domain of the 
> parent + PASID it means there are 4 domains (thus 4 page tables) under 
> this IOASID thus every dma map operation must be replicated in all
> 4 domains which is really unnecessary. Having the domain created
> with ioasid and allow a device attaching to multiple domains is much
> cleaner for the upper-layer drivers to work with iommu interface.

Eh? That sounds messed up.

The IOASID is the page table. If you have one IOASID and you attach it
to 4 IOMMU routings (be it pasid, rid, whatever) then there should
only ever by one page table.

The iommu driver should just point the iommu HW at the shared page
table for each of the 4 routes and be done with it. At worst it has to
replicate invalidates, but that is very HW dependent.

Domain is just a half-completed-ioasid concept. It is today not
flexible enough to be a true IOASID, but it still does hold the io
page table.

Basically your data structure is an IOASID. It holds a single HW
specific page table. The IOASID has a list of RID and (RID,PASID) that
are authorized to use it. The IOMMU HW is programed to match the
RID/(RID,PASID) list and search the single page table. When the page
table is changed the IOMMU is told to dump caches, however that works.

When a device driver wants to use an IOASID it tells the iommu to
setup the route, either RID or (RID,PASID). Setting the route causes
the IOMMU driver to update the HW.

The struct device has enough context to provide the RID and the IOMMU
driver connection when operating on the IOASID.

Jason
