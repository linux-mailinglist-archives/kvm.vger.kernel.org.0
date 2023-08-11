Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBF77790C4
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 15:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbjHKN3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 09:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbjHKN3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 09:29:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D2190
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 06:29:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-268bc714ce0so2256404a91.0
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 06:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691760560; x=1692365360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8LOpgoLGoY3DjpumPQsfCr46GfyFnwJ6iRRs1mZps+8=;
        b=P23nqss6FVvXml5SxPmyBOySoi8G56V8QNGw1aeNOAT1Kv2QSV9LHYmLlAxDbc2BTb
         X6o6yj1C+5iPCmclzAsBq8c01yvJd63vxN4x4DoJMg8Duwxnq4/CBUagn0SavWX0d8eG
         FJ6+frmZ0L/Z7WKdGHMkRKqKRmndj/aO/ZLYrUQk44b/3GpuP4AOux4smSG/g6cTP81L
         UQES66jdJvnUvW9fQ1TBxkUAa3lCRldj3aZOn0ttqJ3pbfrJP6ie8cgr/i6ptVkfPDIm
         bQYVuQiyXTMum16UfRPvpQLeEygFnDYFQx94Knx+zxFQuMzEy9Of8lEmoueGfMrwfH2P
         ArKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691760560; x=1692365360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8LOpgoLGoY3DjpumPQsfCr46GfyFnwJ6iRRs1mZps+8=;
        b=c171JeTahYO3Q3qGnWff/uzqDISplCa4/c0WlEu7sVvQsOtTz7OcW+M5JTO3WbF+ca
         J4T/+pvZOlYEWepPsuZobTlIhz752bUaRZ9vhE43ug96tsTDMI/FJzeo88nomJAqqzhh
         QmU/sC89Qo8ToNHqF0hmcQiOXIzExI4/6F/zjGDqmW3Yqs7DsIMx1u7QhUfkccqiumO6
         XAqlThM69Gnig+I85izLK6EBwOTbPLbAy0u+9VCoLAl32Usk5CuA/hg6zUeXm/pN4lr7
         C/bRNRmSSSsj6PWnDpbH5Xu2I22MWO2G/7aFCCyuQcffPT9w0cnrzSqIGQZKzDy2v8hC
         R2Qw==
X-Gm-Message-State: AOJu0YwKRK+B2vUSgz8xZZnRUnnyJqLkgZuV5A6tYCHZu3jdqBPdgVL5
        yMZAibzVh/Rujk6+4r969tjX/Q==
X-Google-Smtp-Source: AGHT+IEufSgy3WFklLzEfOQ7QcpVLaiWk87ysEXVFOcUtUGT0SPAsgLe2hy3p5Ir4TzY4QNGL5dM/Q==
X-Received: by 2002:a17:90a:648e:b0:268:220a:7080 with SMTP id h14-20020a17090a648e00b00268220a7080mr6628903pjj.2.1691760559815;
        Fri, 11 Aug 2023 06:29:19 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id ju9-20020a170903428900b001a6d4ea7301sm3890733plb.251.2023.08.11.06.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 06:29:19 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qUSCb-005RAj-Ge;
        Fri, 11 Aug 2023 10:29:17 -0300
Date:   Fri, 11 Aug 2023 10:29:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/12] iommu: Make iommu_queue_iopf() more generic
Message-ID: <ZNY3rYJbBFEMFi80@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-11-baolu.lu@linux.intel.com>
 <ZNU1Zev6j92IJRjn@ziepe.ca>
 <7fc396d5-e2bd-b126-b3a6-88f8033c14b4@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fc396d5-e2bd-b126-b3a6-88f8033c14b4@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023 at 10:21:20AM +0800, Baolu Lu wrote:

> > This also has lifetime problems on the mm.
> > 
> > The domain should flow into the iommu_sva_handle_iopf() instead of the
> > void *data.
> 
> Okay, but I still want to keep void *data as a private pointer of the
> iopf consumer. For SVA, it's probably NULL.

I'd rather give the iommu_domain some 'private' void * than pass
around weird pointers all over the place... That might be broadly
useful, eg iommufd could store the hwpt in there.

> > We need to document/figure out some how to ensure that the faults are
> > all done processing before a fault enabled domain can be freed.
> 
> This has been documented in drivers/iommu/io-pgfault.c:
> 
> [...]
>  * Any valid page fault will be eventually routed to an iommu domain and the
>  * page fault handler installed there will get called. The users of this
>  * handling framework should guarantee that the iommu domain could only be
>  * freed after the device has stopped generating page faults (or the iommu
>  * hardware has been set to block the page faults) and the pending page
> faults
>  * have been flushed.
>  *
>  * Return: 0 on success and <0 on error.
>  */
> int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
> [...]
> 
> > This patch would be better ordered before the prior patch.
> 
> Let me try this in the next version.

Okay.. but can we have some debugging to enforce this maybe? Also add
a comment when we obtain the domain on this path to see the above
about the lifetime

Jason
