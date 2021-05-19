Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258BA3899C5
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 01:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhESX0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 19:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhESX0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 19:26:23 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6778C061574
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 16:25:01 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id v8so14540428qkv.1
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 16:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jofypBmuNK78helxp/ax3lvvaD1SSYgX9AHCXeb2JyI=;
        b=N+FIikMxArUHq1byG1kV6q6NKiH1yzdaJ73QnFvU7gnei0NcXatMYjDQ/ysJWeBJUz
         HU+0NNBklt3GiG1WqihmEZDLgrsaMez/pjd1gK+nq1yfEAl4wKARzYJcQ9YvICi1PbfJ
         YmKCfYOaNFRsx04nfwkEcco4XkSA5EJzUpFfr7AW5h4ojV2pmxtrP0yLMHPB89Npr6MC
         cYvKGOLX7tUJB9fr5WHNwIUnrPHLmMT3XH1oZkYwxMdMuAS8LI+qL0xR0NfXu2XozXzX
         mnVR8EYQcltbwycZy/8FNlwePUV7aMDd/SY0pRucP8XY2ZQWC41lv4cyNLN79dAK3X8D
         3g1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jofypBmuNK78helxp/ax3lvvaD1SSYgX9AHCXeb2JyI=;
        b=ugy+5shZ2ZgaLDOAk7r/hhPhoz2G7kocooO77Wlo26vT5Ax8zvULEiQV4ax4oL0GpJ
         HCvb1HHqwfEXo2cj3GPPwuOOx5wdIhGJjEd5L5AAjnh8P7KjsMbQiEYxEgcYFVOHJxmH
         74UoVIb2tubcsTvXt1wwIsbx7gkW7GcW1fp5hYLU9OJsddgLyaAAqIuggjDgAn0VdcBP
         ljlRBxwhuw91KXlIhVr6MffAHIf9iQ5+v/dkNs41cCBrpYIAm6xpzQ2eRx4VfdATKQ5X
         yZh/VBPhXeyUMum63rNI+2/5g8ZdCw+jkzozHBbTpFfFNL2kItVBuRDGKbPoZcFQIdwD
         SidA==
X-Gm-Message-State: AOAM5311G2WN8KT07JkjbnT4VGT/X436oeraWPtJ4V34YNgMZSmOGQG+
        m1t+/CEm5UhWIPc0WNFrtvC1Ug==
X-Google-Smtp-Source: ABdhPJwacQNrdgaaDkGD5jqXNtEa9dtPcTdGRZpUC1+HOzqirLQtKg5p7syqrmkzIKN+BpViLEFW6Q==
X-Received: by 2002:a05:620a:21c5:: with SMTP id h5mr1932597qka.395.1621466700858;
        Wed, 19 May 2021 16:25:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id u186sm918257qkd.30.2021.05.19.16.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 16:25:00 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1ljVYh-00AxO2-BM; Wed, 19 May 2021 20:24:59 -0300
Date:   Wed, 19 May 2021 20:24:59 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <20210519232459.GV1096940@ziepe.ca>
References: <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca>
 <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca>
 <YKJnPGonR+d8rbu/@8bytes.org>
 <20210517133500.GP1096940@ziepe.ca>
 <YKKNLrdQ4QjhLrKX@8bytes.org>
 <131327e3-5066-7a88-5b3c-07013585eb01@arm.com>
 <20210519180635.GT1096940@ziepe.ca>
 <MWHPR11MB1886C64EAEB752DE9E1633358C2B9@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886C64EAEB752DE9E1633358C2B9@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 11:12:46PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Thursday, May 20, 2021 2:07 AM
> > 
> > On Wed, May 19, 2021 at 04:23:21PM +0100, Robin Murphy wrote:
> > > On 2021-05-17 16:35, Joerg Roedel wrote:
> > > > On Mon, May 17, 2021 at 10:35:00AM -0300, Jason Gunthorpe wrote:
> > > > > Well, I'm sorry, but there is a huge other thread talking about the
> > > > > IOASID design in great detail and why this is all needed. Jumping into
> > > > > this thread without context and basically rejecting all the
> > > > > conclusions that were reached over the last several weeks is really
> > > > > not helpful - especially since your objection is not technical.
> > > > >
> > > > > I think you should wait for Intel to put together the /dev/ioasid uAPI
> > > > > proposal and the example use cases it should address then you can give
> > > > > feedback there, with proper context.
> > > >
> > > > Yes, I think the next step is that someone who read the whole thread
> > > > writes up the conclusions and a rough /dev/ioasid API proposal, also
> > > > mentioning the use-cases it addresses. Based on that we can discuss the
> > > > implications this needs to have for IOMMU-API and code.
> > > >
> > > >  From the use-cases I know the mdev concept is just fine. But if there is
> > > > a more generic one we can talk about it.
> > >
> > > Just to add another voice here, I have some colleagues working on drivers
> > > where they want to use SMMU Substream IDs for a single hardware block
> > to
> > > operate on multiple iommu_domains managed entirely within the
> > > kernel.
> > 
> > If it is entirely within the kernel I'm confused how mdev gets
> > involved? mdev is only for vfio which is userspace.
> > 
> 
> Just add some background. aux domain is used to support mdev but they
> are not tied together. Literally aux domain just implies that there could be 
> multiple domains attached to a device then when one of them becomes
> the primary all the remaining are deemed as auxiliary. From this angle it
> doesn't matter whether the requirement of multiple domains come from
> user or kernel.

You can't entirely use aux domain from inside the kernel because you
can't compose it with the DMA API unless you also attach it to some
struct device, and where will the struct device come from?

We already talked about this on the "how to use PASID from the kernel"
thread.

If Robin just wants to use a stream ID from a kernel driver then that
API to make a PASID == RID seems like a better answer for kernel DMA
than aux domains is.

Jason
