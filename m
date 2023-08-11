Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E348F7790B7
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 15:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbjHKN1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 09:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjHKN1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 09:27:14 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2828A125
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 06:27:13 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bdb801c667so4596295ad.1
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 06:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691760432; x=1692365232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F7v0CVgY9abtWYoDC5bZkBPB2nRR3jrM6lzMQZBvyuU=;
        b=d1FmtARKaIJHCFVHZhIvjyWeh9YdGWhpXHg47bzfdOXmJHlxrslCa7zHg+/JD34q0e
         E9/3cip0qUiYQyaSEfw8LW1KYUNSfz7+aubYzAfkCKxHzXz1aD/zcjb2url7DUGw3QFK
         kXh/FNJld8j2cKTYqxjXigAi37lX18p01LLlG5uqSynfTOhbWhbZ0fNQFC7p238++VRQ
         Zs3Uxt3iiHDirlnfq3y2keMcgFiobHWlXmeW33RUglZ5pN91g1cbMZjZhs4rHwsn9r1M
         9rdF/SAB3CLwR+1IA27XUCeOTCmo4PB5RcAUhTvJUQJ7k0WobwUKOsY994haEl65WxVD
         I38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691760432; x=1692365232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F7v0CVgY9abtWYoDC5bZkBPB2nRR3jrM6lzMQZBvyuU=;
        b=eQhqBYPGHeFlRQ9VwShQU3VpmUTlBrJYY2ntirzQjCsyFuVC/nD6E9OZpdmoJHTFP4
         yx5adPoc3fOtlOBgqRdBzqtjD8ZKdLnHXra7ItsCOT1Agy7QI2sbKaitafkCEk+APJcs
         l1BIXr/nEP3ys/7ysLToCj5RCmAtK+3m6bCtYRYK11hC9GGkCEj6GJQJVVydYBDCsXp1
         HZArpG7jlZ2mgjf2mtteh3I5HHrrCRsHxYp+eEXGyKIvhq7GJLb4cK1pIx8J1usm1uEZ
         BhqKJDPoUlMPR8G+YnRgbsI2AHousQqbMlI/yHdYsu1SvgnbFaGzJx/X/erOVEjP2j/3
         wwbA==
X-Gm-Message-State: AOJu0YxcGnYedmANZHPdRv08HQFnrJYYj5LR64PyGnTVrcPhENtTmAUa
        IpBqpe9nohtLp4jYZpyg7ZzemQ==
X-Google-Smtp-Source: AGHT+IHjQ/YmFnNuEbJzT7wjHKlxU7TvjYa59TJH7k5fgJjND7DThiWpL/8pFybIFQzN1/kVVWlFlQ==
X-Received: by 2002:a17:902:f551:b0:1bb:97d0:c628 with SMTP id h17-20020a170902f55100b001bb97d0c628mr2378919plf.31.1691760432689;
        Fri, 11 Aug 2023 06:27:12 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id s13-20020a170902988d00b001bdc664ecd3sm19894plp.307.2023.08.11.06.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 06:27:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qUSAY-005R9K-MW;
        Fri, 11 Aug 2023 10:27:10 -0300
Date:   Fri, 11 Aug 2023 10:27:10 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Message-ID: <ZNY3LuW+FMAhK2xf@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
 <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNKMz04uhzL9T7ya@ziepe.ca>
 <BN9PR11MB527629949E7D44BED080400C8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <0771c28d-1b31-003e-7659-4f3f3cbf5546@linux.intel.com>
 <BN9PR11MB527686C925E33E0DCDF261CB8C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNUUjXMrLyU3g5KM@ziepe.ca>
 <f1dbfb6a-5a53-f440-5d3a-25772c67547f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1dbfb6a-5a53-f440-5d3a-25772c67547f@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023 at 09:53:41AM +0800, Baolu Lu wrote:
> On 2023/8/11 0:47, Jason Gunthorpe wrote:
> > On Thu, Aug 10, 2023 at 02:35:40AM +0000, Tian, Kevin wrote:
> > > > From: Baolu Lu<baolu.lu@linux.intel.com>
> > > > Sent: Wednesday, August 9, 2023 6:41 PM
> > > > 
> > > > On 2023/8/9 8:02, Tian, Kevin wrote:
> > > > > > From: Jason Gunthorpe<jgg@ziepe.ca>
> > > > > > Sent: Wednesday, August 9, 2023 2:43 AM
> > > > > > 
> > > > > > On Thu, Aug 03, 2023 at 08:16:47AM +0000, Tian, Kevin wrote:
> > > > > > 
> > > > > > > Is there plan to introduce further error in the future? otherwise this
> > > > should
> > > > > > > be void.
> > > > > > > 
> > > > > > > btw the work queue is only for sva. If there is no other caller this can be
> > > > > > > just kept in iommu-sva.c. No need to create a helper.
> > > > > > I think more than just SVA will need a work queue context to process
> > > > > > their faults.
> > > > > > 
> > > > > then this series needs more work. Currently the abstraction doesn't
> > > > > include workqueue in the common fault reporting layer.
> > > > Do you mind elaborate a bit here? workqueue is a basic infrastructure in
> > > > the fault handling framework, but it lets the consumers choose to use
> > > > it, or not to.
> > > > 
> > > My understanding of Jason's comment was to make the workqueue the
> > > default path instead of being opted by the consumer.. that is my 1st
> > > impression but might be wrong...
> > Yeah, that is one path. Do we have anyone that uses this that doesn't
> > want the WQ? (actually who even uses this besides SVA?)
> 
> I am still confused. When we forward iopf's to user space through the
> iommufd, we don't need to schedule a WQ, right? Or I misunderstood
> here?

Yes, that could be true, iommufd could just queue it from the
interrupt context and trigger a wakeup.

But other iommufd modes would want to invoke hmm_range_fault() which
would need the work queue.

Jason
