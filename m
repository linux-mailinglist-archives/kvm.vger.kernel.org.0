Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7C4778150
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 21:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjHJTTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 15:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjHJTS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 15:18:57 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BCD2D43
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 12:18:56 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-63d30554eefso7928746d6.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 12:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691695135; x=1692299935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6nK40dlXSEtV9j+1clrTX2RCnnQWiTsk3pHmbVPkUwY=;
        b=VmBkafl1u25d2ecLyUc29ulrsvOSkhhEKJzuIU93CMtsoCspLy4ihE6XAu6q0FKV7H
         7LnJGstvlp0byYFZseM2BaVUeXnNZLL+R2jOlaxU4o1Ud/nwJDZ3AlwHHAWddr1hdDAg
         8Alv1t72xMjHMEMMtHU9bWogP2hPkCqxEH22qnX5LDAMnjcCIdacsNJpfbyNjw80iyd3
         0Xa721kMEsJQYgnTNhLDNMaDAoCHiSoBnKuy0rN8Z+NmXMYhiCdRQJSBHOdZ5K2x7LBG
         538LpY5D5oj+OGHc81pQ5kls8HpXumbdw5zvGYkIXTJUyb1xkQ++ypNWCPge9FRsMSvh
         zm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691695135; x=1692299935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nK40dlXSEtV9j+1clrTX2RCnnQWiTsk3pHmbVPkUwY=;
        b=AcUCJkHr76CnV5st3XXgCaEawC1jdhLCImcGlQYfee1QQb9XkRxAhu0XROSJaK6FH/
         dMtcp91RfK/MYV8tED9fDDIQCyAEbluzEsT52MbhjCM5vYM+eSGiWqm5fuO39DVo5gK8
         CSosslMUuzDRmk5RwUKUyMm+k/9otvakml5KNXbWFRTYdSeMll0t//K6aO/9VS+I3fjr
         Rf3odXty4CA/RBrFf0cETeYMlitri6ESyX6YE3zvjDMxYY5mbYkDxar++mD59ojnT6Vx
         IWsLwiIxrnAflG5T1bILFz6a8KOPLTVzEl4tfQHPoUvZtEXJl0CsyL0qv6zYQ0uIyOoX
         6iCw==
X-Gm-Message-State: AOJu0YxzQc1PBf6hOL5uqVaNGoNpoZ9orxARkraCQJEhcYwo4CuHr7Ba
        yKYtMdOyZLsPVhNf3t7KDb0wcA==
X-Google-Smtp-Source: AGHT+IHH4IrROTfTjO5eB3vOPq41MQjpTBHKBaN/zPPR2N44/sTFeqgtLodbzZoyZt1KMjgv18nz0g==
X-Received: by 2002:a05:6214:15c3:b0:635:e528:5213 with SMTP id p3-20020a05621415c300b00635e5285213mr3435331qvz.23.1691695135500;
        Thu, 10 Aug 2023 12:18:55 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id i9-20020a0cab49000000b0063d316af55csm694456qvb.3.2023.08.10.12.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 12:18:54 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qUBBO-005Ips-5n;
        Thu, 10 Aug 2023 16:18:54 -0300
Date:   Thu, 10 Aug 2023 16:18:54 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/12] iommu: Add helper to set iopf handler for domain
Message-ID: <ZNU4Hio8oAHH8RLn@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-13-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727054837.147050-13-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 01:48:37PM +0800, Lu Baolu wrote:
> To avoid open code everywhere.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h | 11 ++++++++++-
>  drivers/iommu/iommu.c | 20 ++++++++++++++++++--
>  2 files changed, 28 insertions(+), 3 deletions(-)

Seems like overkill at this point..

Also, I think this is probably upside down.

We want to create the domains as fault enabled in the first place.

A fault enabled domain should never be attached to something that
cannot support faults. It should also not support changing the fault
handler while it exists.

Thus at the creation point would be the time to supply the fault handler
as part of requesting faulting.

Taking an existing domain and making it faulting enabled is going to
be really messy in all the corner cases.

My advice (and Robin will probably hate me), is to define a new op:

struct domain_alloc_paging_args {
       struct fault_handler *fault_handler;
       void *fault_data
};

struct iommu_domain *domain_alloc_paging2(struct device *dev, struct
       domain_alloc_paging_args *args)

The point would be to leave the majority of drivers using the
simplified, core assisted, domain_alloc_paging() interface and they
just don't have to touch any of this stuff at all.

Obviously if handler is given then the domain will be initialized as
faulting.

Jason
