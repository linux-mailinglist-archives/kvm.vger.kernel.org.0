Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C1A389502
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 20:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhESSH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 14:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhESSH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 14:07:59 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C46C06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 11:06:39 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id e8so3999947qvp.7
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 11:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tImv3Ted6BARmz7M+tuEIdrP9JRn+bjF1ToIbRbbDJ8=;
        b=Bbfl7flyMPWNyDLufCNwLW0WE4SyDnLCleDYtN7/u2gC0bb9iO/Hkj1b1N8LaK9jVj
         fFv21pHhR5afJPiTABu+Ns9UNr+b/IYRlZTXuZKrDtFJJ4kpcYylkACvXknYC/tu6iwZ
         aHZcmydArLtG5/HbT3w8d1hPAEd3OXLH52ztw2rDziHqk6aPSr7SCDOHthEKfk90OyfU
         AwNjxGHXHO6Kcj6FHUcEI5ANW2fXnbX8TXUtHFrHnkiCemekTOsHtUHxJHpMPhlG6HEU
         k175NImjnc4rhOfcgzYSFll8wC69/QQbK3OpIkUQKd4DZhvtTDNmCmYiosX/qIG+M9ig
         aA7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tImv3Ted6BARmz7M+tuEIdrP9JRn+bjF1ToIbRbbDJ8=;
        b=MVsXn02rZ2F2mvRdxo83/+qg0/eW8qjRuGA+2rDn5vHKkW6tIAwMJGN8/q3aFMXHfQ
         pKXDsjoTy3gJ2sMDhoEGxsSwrDKRBmUNBKXReiWoDh9sMlYhs8jIoOcZUnyhkeOVe/c7
         Kslgx1jXEidiBdm+RzHcWwozKvD8tbHETCF81hT+W/4Zu9TCuw9OWYP5g0tbPicPXjLc
         AecjyLVtlc8OXw6fTTdaXQYc2N86GQ1/2JvG8RcKSpz9aQ3YcoeJI5OeV8hXfKnaeRmz
         YYyy3dnZ+dVOGv4hSG33pE8FB/ykPItdCIAy0TAgGlljssEjVJtms+mL9fH4C0nDhWsd
         foYw==
X-Gm-Message-State: AOAM5307PQmzpQ09qFDpxUnaYYpXmzoP1lYU3RYEGqFQ2q9MCtCO/iJX
        rHy6SS5dPPt9XA2X3ru8syZ96g==
X-Google-Smtp-Source: ABdhPJxfdVisFtDoBA6vNWNzXoLMLU8eFLwTJh2Zrfswd3jA5ooaEQhDs9SHMkNr9LB1GfQ5Oi4EbQ==
X-Received: by 2002:a0c:ee62:: with SMTP id n2mr906256qvs.20.1621447597322;
        Wed, 19 May 2021 11:06:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id w5sm321655qkf.14.2021.05.19.11.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 11:06:36 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1ljQaZ-00AnII-Nw; Wed, 19 May 2021 15:06:35 -0300
Date:   Wed, 19 May 2021 15:06:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Message-ID: <20210519180635.GT1096940@ziepe.ca>
References: <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca>
 <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca>
 <YKJnPGonR+d8rbu/@8bytes.org>
 <20210517133500.GP1096940@ziepe.ca>
 <YKKNLrdQ4QjhLrKX@8bytes.org>
 <131327e3-5066-7a88-5b3c-07013585eb01@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <131327e3-5066-7a88-5b3c-07013585eb01@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 04:23:21PM +0100, Robin Murphy wrote:
> On 2021-05-17 16:35, Joerg Roedel wrote:
> > On Mon, May 17, 2021 at 10:35:00AM -0300, Jason Gunthorpe wrote:
> > > Well, I'm sorry, but there is a huge other thread talking about the
> > > IOASID design in great detail and why this is all needed. Jumping into
> > > this thread without context and basically rejecting all the
> > > conclusions that were reached over the last several weeks is really
> > > not helpful - especially since your objection is not technical.
> > > 
> > > I think you should wait for Intel to put together the /dev/ioasid uAPI
> > > proposal and the example use cases it should address then you can give
> > > feedback there, with proper context.
> > 
> > Yes, I think the next step is that someone who read the whole thread
> > writes up the conclusions and a rough /dev/ioasid API proposal, also
> > mentioning the use-cases it addresses. Based on that we can discuss the
> > implications this needs to have for IOMMU-API and code.
> > 
> >  From the use-cases I know the mdev concept is just fine. But if there is
> > a more generic one we can talk about it.
> 
> Just to add another voice here, I have some colleagues working on drivers
> where they want to use SMMU Substream IDs for a single hardware block to
> operate on multiple iommu_domains managed entirely within the
> kernel.

If it is entirely within the kernel I'm confused how mdev gets
involved? mdev is only for vfio which is userspace.

In any event, if you are kernel only it is not quite as big a deal to
create what you need. A 'substream domain' disconnected from the
struct device is not unreasonable.

> an mdev-like approach with aux domains is pretty much the ideal fit for this
> use-case, while all the IOASID discussion appears centred on SVA and
> userspace interfaces, and as such barely relevant if at all.

/dev/ioasid is centered on userspace, but usually the way this works
is a user API like that will be close to a mirror kernel
implementation if someone needs such a thing.

Jason
