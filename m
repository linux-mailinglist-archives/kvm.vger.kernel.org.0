Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919DD378DCB
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241866AbhEJMxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 08:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244390AbhEJL7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 07:59:01 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22CBC08C5F3
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 04:54:15 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id q136so14931981qka.7
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 04:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4+X4WteNsgQ19+v1jrZ7Ekzjl0pM0a2tSBb6kLiTT48=;
        b=PWyo1gl6oTeAtHGCeTBEPCa3Yr0PE4k7LvQFXAjuZ8kYFrMR4YWhiKpWpL9UTBvZ7m
         qk8KFyM10DuEJNIBnRKAozmeWOLsaRT5BF34OdpSj6Zv4Gqt85+FGlDU+TUek9WwkkfR
         jZ7v8VD7HnnFbwgxTvyBeOotqiXojc6x8i1KKOK4cVeQIekGTw1TCNcAMW/CMpvd+6RP
         tm9qSDCStEi3cagBGLSl7+rtLDZzX8+eMCzoO28n1Ii8zBPZJRPmgHsTk8uv3JTt6aUv
         wyhvmP1oQ5xcemAq48IGapmsXw3yUdDwPENB6AdF3PlELk7SIAKnvWNK5LHjesLGFh1U
         9+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4+X4WteNsgQ19+v1jrZ7Ekzjl0pM0a2tSBb6kLiTT48=;
        b=P7ECMV3426VZo69DZIwo/Y7R8Gz4KmDl9/V7mbACRjww62y9HT/RkbjdrmMDH0RtNl
         ZCUID9rXSbu2aR/RvVH0EvzNC0A7bdRtENFdUoag0Unn/3K1JxyEw65KIX43nbq9M802
         yjBzfKANcqkxMw+ZC+xaP7uWz5lqILJJBUWWsETt7B240gianvjpI4W26UsLtaL6l79J
         8tybz+Qvv2gsDoq3OuSbZedtIu4+LwmHuIYP/vn2XeLRa/YRClLLm53IlK9KVSqwUIbd
         R8mjnkepdg88veeJqbaRah12Itkr0/t2HCuElOO52i8u0T6M/bi5YUjudAVasTEZ+LHn
         xJ4A==
X-Gm-Message-State: AOAM531DW6rAA62dLkwQpEe0BkcI16UxE9PP0FPLJnRao13IiHY6UYnh
        KLR/cADbAJua9Zzyszx2Vbv11Q==
X-Google-Smtp-Source: ABdhPJzBhRA/mYegQ6Y3SCHv8vvyMaFup+8Bx9cPBeG9nbr9M1kzHbHa1+EnzLI/fQPr8l4kD42yUg==
X-Received: by 2002:a37:468c:: with SMTP id t134mr12536249qka.357.1620647654876;
        Mon, 10 May 2021 04:54:14 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id 189sm11286888qkd.51.2021.05.10.04.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 04:54:14 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lg4UH-004Bs3-DG; Mon, 10 May 2021 08:54:13 -0300
Date:   Mon, 10 May 2021 08:54:13 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: more iommu dead code removal
Message-ID: <20210510115413.GE2047089@ziepe.ca>
References: <20210510065405.2334771-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510065405.2334771-1-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 08:53:59AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this is another series to remove dead code from the IOMMU subsystem,
> this time mostly about the hacky code to pass an iommu device in
> struct mdev_device and huge piles of support code.  All of this was
> merged two years ago and (fortunately) never got used.

Yes, I looked at this too. Intel has been merging dead code for a
while now. Ostensibly to prepare to get PASID support in.. But the
whole PASID thing looks to be redesigned from what was originally
imagined.

At least from VFIO I think the PASID support should not use this hacky
stuff, /dev/ioasid should provide a clean solution

Jason
