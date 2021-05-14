Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D826D380C1D
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 16:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhENOp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 10:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbhENOp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 10:45:57 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21828C061574
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 07:44:45 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id j11so22316467qtn.12
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 07:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5eRvTdeEB4OFHRkGyw/FepnZIZ1CoxvAuK8I7ThmVnY=;
        b=nRkdu7k2xQ+YoBCvbAK24g2UZnBtDHdW77UuZWq1TzE1ce/i2vSxDI3PdfKI5Jsm9d
         JRRwdxdT0Bs39ZNeLlzVgpmazAiVXgM+zzr8ziiO7KgyEikyw7RpioDCezi1XKjxoGNP
         POVVlFsCMQ9vTbPgGl7v6QzGYQWWYI9OJewyjQmQ3WwsxgYI24sQ6TMMkjKiiYwVXW5x
         8+ipkG/ael3qLVrlHufx0H2LgX6Tqpg0Z8QC+AqA4v8RN6S8q3zVrRqgoth1O4jzTlAj
         jwIHjEFqIPmdguSTbvmMbkB3B5avjXAM3F3JkUPS+VqLm2pQ4PjA0Yf2BtzRnkcYpGtT
         aUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5eRvTdeEB4OFHRkGyw/FepnZIZ1CoxvAuK8I7ThmVnY=;
        b=WuOJVwG4+RNu4+upMfHn6/vhuUrtNLeyNEQQPIhUY0IoORRC20La3ylePVQt8wjtBn
         V04LKm4UDzTAiKbHYsDkuolQDbuvfBFgdoqw6Pa7Kq8Az6CIC5dSLfZWrpRhbF0r4jP7
         Xf/sqhNEipHvxU7NJewb1IxbLNrq+xHHFO+5zlShk+abnX8+EXBh85nmL9f9O5xStUq8
         6CVE9f1Ez1QhtCInYd0ZP32FE4YkvLQMwuW60871pgFLQDtC5FCv6w1dtqBFBGppmPwv
         tKQCUZyDLH9twwe1tB5E19nKu+u9mnf410xCBjwMiPLKPERhM824IQLocqSQPof20tdy
         vpoA==
X-Gm-Message-State: AOAM533l+azo3mTX2+cDq6Z93VmvTZBONSQZpgVKXq9ZFWJ4EBSxZ+aA
        YjoDsxzJjR8KW+uLsF30I7oWIA==
X-Google-Smtp-Source: ABdhPJxXWxgtyCMpLAybGYmVkwL/O8mVvUjGMWW8nfKwX9BgEHmZSiHUjb0Crr7tgdUgMOvc0inVcg==
X-Received: by 2002:a05:622a:1493:: with SMTP id t19mr43119374qtx.147.1621003484390;
        Fri, 14 May 2021 07:44:44 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id q7sm4886079qki.17.2021.05.14.07.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 07:44:43 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lhZ3T-007Shk-Ai; Fri, 14 May 2021 11:44:43 -0300
Date:   Fri, 14 May 2021 11:44:43 -0300
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
Message-ID: <20210514144443.GN1096940@ziepe.ca>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de>
 <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB18863613CEBE3CDEEB86F4FC8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133939.GL1096940@ziepe.ca>
 <MWHPR11MB1886AE36746C8F82553471088C509@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886AE36746C8F82553471088C509@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 02:28:44PM +0000, Tian, Kevin wrote:
> Well, I see what you meant now. Basically you want to make IOASID 
> as the first-class object in the entire iommu stack, replacing what 
> iommu domain fulfill todays. 

Alternatively you transform domain into being a full fledged IOASID.
I don't know which path works out to be a better patch series.

> Our original proposal was still based on domain-centric philosophy
> thus containing IOASID and its routing info only in the uAPI layer
> of /dev/ioasid and then connecting to domains.

Where do the domains come from though? You still have to hack hack all
the drivers to create dummy domains to support this plan, and in the
process PASID is pretty hobbled as an actual API if every PASID
instance requires a wonky dummy struct device and domain.

> btw are you OK with our ongoing uAPI proposal still based on domain
> flavor for now? the uAPI semantics should be generic regardless of 
> how underlying iommu interfaces are designed. At least separate
> uAPI discussion from iommu ops re-design.

The most important thing is the uAPI, you don't get to change that later.

The next most is the driver facing API.

You can figure out the IOMMU layer internals in stages.

Clearly IOASID == domain today as domain is kind of half a
IOASID. When you extend to PASID and other stuff I think you have
little choice but to make a full IOASID more first class.

Dummy domains are a very poor substitute.

In my experiance these kinds of transformations can usually be managed
as "just alot of typing". Usually the old driver code structure can be
kept enough to not break it while reorganizing.

Jason
