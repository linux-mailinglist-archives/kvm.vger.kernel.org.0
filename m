Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DC7774A02
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbjHHUKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjHHUJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:09:59 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833D844811
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:39:40 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-40849e69eb5so39614911cf.1
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 11:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691519979; x=1692124779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=64QCZ+lCjqLCLgWqPm6Im36kRBI6O73TOOo0qu3TAc4=;
        b=ngl7ca+dDeOo1NbtsDWD3hb35GubXAE9bW4YU+Q9ZeNQiYlwws2AP21vm1W9mce/Yx
         6ip0BJ/dz8OEdvpusCgK0uEuMiptwij0mmqFChb/mPzoZnydcBzqCj/wld2p+OPVf6aA
         94cg94q9bQBcUj9Shjbi2ywkjakp+/Iuhhg8yF14oxRyg67JuNY8DDoIdat+Bb7WNm31
         W6hOXXt1M8Bj4UHq743YLSzvXXeU4X/bf5rjjn1XoYfXfkxTdDqEX+zEwcLdcBisuwd8
         Y3ls3blTbOZaIN0WkgM2lPu6FUW3roESHOhBLzCk9y44Sc2qYJBZ3qim4dVFt2ny3ReI
         /GQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691519979; x=1692124779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=64QCZ+lCjqLCLgWqPm6Im36kRBI6O73TOOo0qu3TAc4=;
        b=Q7qr7sypZNZ8zuFSr+oMgZ2w3Y4qOMsGV/sme/W5Cm64+yvnNHihKlItUQtnmXH0Uo
         sKg2h8fVr7l5wrt5NpNke9AByevbk/toFAps5WhDjT3OquQuJJYNNytJxCohy+VbcPef
         Icj2Gr//f3lGilZOVpBKTTPWvchFtBjU22avNj2Hu/5gRMPOM9YKAYxjkp/GD/lTE78E
         +LUv5HMhoKdmfhL5I3UvizbEN3oCqCzcfzWVRDv2vKfO1fMla5xBt9BnysZETyZ7gMYp
         uIW2221IaLqJOmja44y/RKgMm0QTHtWixzNBcSyqMYUBm9rBuP4bl2Edssg0KbG2GsL4
         /MVw==
X-Gm-Message-State: AOJu0YwmSrFO7JpICrzQFwrAqkPqAPHCIQF+KMrv7zdedlCrZpuongf5
        m1/G1Ybu8bwzcQWTZIDpPOZVQw==
X-Google-Smtp-Source: AGHT+IHpUQvjin0dfbxMHZFXvfs1yLMSRD2Rp9ldZKVLrYQ9K6NRMfi8+h/vzLGKDPZotUVGEmHXeg==
X-Received: by 2002:a05:622a:1a9e:b0:405:45e2:39f9 with SMTP id s30-20020a05622a1a9e00b0040545e239f9mr682152qtc.15.1691519979699;
        Tue, 08 Aug 2023 11:39:39 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id 16-20020a05620a071000b00765ab6d3e81sm3457218qkc.122.2023.08.08.11.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 11:39:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qTRcI-004vXr-3a;
        Tue, 08 Aug 2023 15:39:38 -0300
Date:   Tue, 8 Aug 2023 15:39:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Message-ID: <ZNKL6hGRZT9qfV1K@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-4-baolu.lu@linux.intel.com>
 <BN9PR11MB52767976314CC61A0F8BEFD08C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <faad1948-5096-c9d3-616a-cd0f0a4b5876@linux.intel.com>
 <BN9PR11MB527614E61BC257FE113EFE358C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527614E61BC257FE113EFE358C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 03:51:30AM +0000, Tian, Kevin wrote:
> > From: Baolu Lu <baolu.lu@linux.intel.com>
> > Sent: Friday, August 4, 2023 10:59 AM
> > 
> > On 2023/8/3 15:54, Tian, Kevin wrote:
> > >> From: Lu Baolu<baolu.lu@linux.intel.com>
> > >> Sent: Thursday, July 27, 2023 1:48 PM
> > >>
> > >>   struct iommu_fault {
> > >>   	__u32	type;
> > >> -	__u32	padding;
> > > this padding should be kept.
> > >
> > 
> > To keep above 64-bit aligned, right?
> > 
> 
> yes

If it is not uapi we should not explicitly document padding (and __u32
should be u32). The compiler will add it if it is necessary.

If the compiler isn't right for some reason then something else has
gone wrong.

Jason
