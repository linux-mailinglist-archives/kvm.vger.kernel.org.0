Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AD22237D7
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 11:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgGQJJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 05:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgGQJJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 05:09:14 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4CDC061755
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 02:09:14 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id by13so7086833edb.11
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 02:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5hAp7/Ut6hK4YsA1k2zD1LY3Swf7sq8YHylKSXCzPJI=;
        b=LaZvUjdgoZgnkJNplfexj1+VySl/Bvb12VUGBJbdN9LkSfjRY0gSDagxsUKxtavwl5
         DSzVMGBRyg4xpS8GFJvxFhosd8bddV2YPKMkeXSIF8/E2ZAxdxxljL09VIJVYcRdKRgP
         gLHKv6Xq+V9ce7jucMxM8s30rLw8GUIGtJ3iNoDqb0HJ+0CsRkT4xp5/jBDYtGIweWBg
         Bwwqqhp11dQD2I4shX9GDTkA11VNRAjodljLnTCdSR7VYivTZbDljPpQ0sitVuAYUknO
         EnOYnw4D3KtJhh6Aw2JdVCN6eY7QaezKNk7xNcg5ioL2BvjOc6azurQ6eFwDhwv95ZrC
         0QCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5hAp7/Ut6hK4YsA1k2zD1LY3Swf7sq8YHylKSXCzPJI=;
        b=B10oTwRNpipMYPxI3Mq/nyWN3zjTNBZOf4PkD2BLLGLv6LzVxtSqBWgT5ifFzCQBYh
         WVdZRqKQGVp3CxVtqVcHiD7omMX9+oqBIWc2Xo+ztPbMg8WzKqSKg+wdzoyGntGTs9QF
         E2nXnJm0f8Uod+wb9gYx8qBnsl2VhkWXUef1cqN8f3ODuT9Knf5XChclq3lnJbbBbl5v
         g2ZmbEbHzoMGZC3LtFV//C4GZ0I13e9tObaNtFlm3zxqKtHH6AWEog99RqGy0eWL9H8R
         b9Tp4pPQ2JLu8coe0BF4o6St9Vp0oQ7onj2/CXR+kBaBxEhYTAnTSc4YrBgx7anwujl9
         q5cA==
X-Gm-Message-State: AOAM530dDhKyzp7KnL8gYucZX4fNSauQM6wqfJvxeWv4bby3sn8Xo++T
        fHzdYOOZKjq48ElCyWJxqHq2lQ==
X-Google-Smtp-Source: ABdhPJxujtV7hysPeFOIoqKwGlmSd8lfEd8PTxDutsJIVtdPPbK+E0Gu8GwztgA2bbvp1ZvOpUskzQ==
X-Received: by 2002:a50:e8c8:: with SMTP id l8mr8512571edn.386.1594976953280;
        Fri, 17 Jul 2020 02:09:13 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id b14sm7271529ejg.18.2020.07.17.02.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 02:09:12 -0700 (PDT)
Date:   Fri, 17 Jul 2020 11:09:00 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>, Will Deacon <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Message-ID: <20200717090900.GC4850@myrica>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
 <20200713131454.GA2739@willie-the-truck>
 <CY4PR11MB1432226D0A52D099249E95A0C3610@CY4PR11MB1432.namprd11.prod.outlook.com>
 <20200716153959.GA447208@myrica>
 <f3779a69-0295-d668-5f2f-746b6ff2bdce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3779a69-0295-d668-5f2f-746b6ff2bdce@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 10:38:17PM +0200, Auger Eric wrote:
> Hi Jean,
> 
> On 7/16/20 5:39 PM, Jean-Philippe Brucker wrote:
> > On Tue, Jul 14, 2020 at 10:12:49AM +0000, Liu, Yi L wrote:
> >>> Have you verified that this doesn't break the existing usage of
> >>> DOMAIN_ATTR_NESTING in drivers/vfio/vfio_iommu_type1.c?
> >>
> >> I didn't have ARM machine on my hand. But I contacted with Jean
> >> Philippe, he confirmed no compiling issue. I didn't see any code
> >> getting DOMAIN_ATTR_NESTING attr in current drivers/vfio/vfio_iommu_type1.c.
> >> What I'm adding is to call iommu_domai_get_attr(, DOMAIN_ATTR_NESTIN)
> >> and won't fail if the iommu_domai_get_attr() returns 0. This patch
> >> returns an empty nesting info for DOMAIN_ATTR_NESTIN and return
> >> value is 0 if no error. So I guess it won't fail nesting for ARM.
> > 
> > I confirm that this series doesn't break the current support for
> > VFIO_IOMMU_TYPE1_NESTING with an SMMUv3. That said...
> > 
> > If the SMMU does not support stage-2 then there is a change in behavior
> > (untested): after the domain is silently switched to stage-1 by the SMMU
> > driver, VFIO will now query nesting info and obtain -ENODEV. Instead of
> > succeding as before, the VFIO ioctl will now fail. I believe that's a fix
> > rather than a regression, it should have been like this since the
> > beginning. No known userspace has been using VFIO_IOMMU_TYPE1_NESTING so
> > far, so I don't think it should be a concern.
> But as Yi mentioned ealier, in the current vfio code there is no
> DOMAIN_ATTR_NESTING query yet.

That's why something that would have succeeded before will now fail:
Before this series, if user asked for a VFIO_IOMMU_TYPE1_NESTING, it would
have succeeded even if the SMMU didn't support stage-2, as the driver
would have silently fallen back on stage-1 mappings (which work exactly
the same as stage-2-only since there was no nesting supported). After the
series, we do check for DOMAIN_ATTR_NESTING so if user asks for
VFIO_IOMMU_TYPE1_NESTING and the SMMU doesn't support stage-2, the ioctl
fails.

I believe it's a good fix and completely harmless, but wanted to make sure
no one objects because it's an ABI change.

Thanks,
Jean

> In my SMMUV3 nested stage series, I added
> such a query in vfio-pci.c to detect if I need to expose a fault region
> but I already test both the returned value and the output arg. So to me
> there is no issue with that change.
> > 
> > And if userspace queries the nesting properties using the new ABI
> > introduced in this patchset, it will obtain an empty struct. I think
> > that's acceptable, but it may be better to avoid adding the nesting cap if
> > @format is 0?
> agreed
> 
> Thanks
> 
> Eric
> > 
> > Thanks,
> > Jean
> > 
> >>
> >> @Eric, how about your opinion? your dual-stage vSMMU support may
> >> also share the vfio_iommu_type1.c code.
> >>
> >> Regards,
> >> Yi Liu
> >>
> >>> Will
> > 
> 
