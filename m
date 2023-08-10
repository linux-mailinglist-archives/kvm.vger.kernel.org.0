Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55298777E91
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 18:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbjHJQrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 12:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbjHJQrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 12:47:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B219F10C7
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 09:47:11 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-26813cd7a8aso757267a91.2
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 09:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691686031; x=1692290831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1YxxQSx9jryP/gaiSlpxrcgwKgQeQJEh/0X+pazM0o=;
        b=ce/9DcrCCwo6KPfVtyNMNZolyHGIshD4DR/Wwxcjvjqlu2XZC2ifdrhTlTMfIbIpeQ
         9b90fyURIEL5MZ9OfK9porDeciE520+G8QtnkKssJ+XxcxmmKkEaLPYgHq4/SWdDOjy8
         LlUjLXgVmYkOjGqOVyfTuMXSsLpV2rW7vChHQJrQWZmlTTBgJZJmxuZGZCMimvei99rP
         ghT4UMiwO3FVTv8qcE912BIbrT9fazw4xMd4nFj5YEFvMO+dnOCEyHVFG65Bia2hYzwq
         FxjZlGsyOIbe7GeyLd73rYRo4u1SYKYuPYchLPh0qDZ11YpBFSFTWWKehNUhm+P8FcbT
         uitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691686031; x=1692290831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1YxxQSx9jryP/gaiSlpxrcgwKgQeQJEh/0X+pazM0o=;
        b=KdrXTUNA4wbGZbI8UwCybkw8AILmd/B9/6oF4MDx6Att3T7TCjNd1AM3CuHV4v3jHw
         Zkm/UkD9gUnZRT6rG/szcsuOxGtngbdckzJBw+UrGTd96Xs3vonQyzMlZJ67le6g5Db8
         ENNv49uEytOQxE4ShUI9LJFLlCCuKqZZprXI4Rxa02ZtRK7DQJenskxScT7QIVbTSKlv
         N0p25sxa/sUiAHPKKcMfcsPnXpZJs3Zf9jqAWtLH7HmL0zYmQU8OPVxctHLjeTTD0Dut
         j3q+fOZ7PKKd/UKOh7dy4eXTbx8u7uXW6iAKUVswuUrP4MKK9bkO+n5glYCuIg0kcA2p
         W93A==
X-Gm-Message-State: AOJu0Yw+haYMf3yEaS9s1kHLbBDP9VRZRZw9Q5ZshTQS6qZP5d6YYUhX
        cTk5H8fBzvTQDr6mprjQnOpxYA==
X-Google-Smtp-Source: AGHT+IEW7khYL0o4UiJXTotcmkvmJTY67L4z884ZB/Rx1B6m1oAZwsmTvmxd1WH9hKUE9QQ1nrFRXQ==
X-Received: by 2002:a17:90a:ba92:b0:268:300b:ee82 with SMTP id t18-20020a17090aba9200b00268300bee82mr2781613pjr.19.1691686031121;
        Thu, 10 Aug 2023 09:47:11 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id 19-20020a17090a1a5300b0026851759e9csm1842689pjl.29.2023.08.10.09.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:47:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qU8oX-005H7B-4H;
        Thu, 10 Aug 2023 13:47:09 -0300
Date:   Thu, 10 Aug 2023 13:47:09 -0300
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
Subject: Re: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Message-ID: <ZNUUjXMrLyU3g5KM@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
 <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNKMz04uhzL9T7ya@ziepe.ca>
 <BN9PR11MB527629949E7D44BED080400C8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <0771c28d-1b31-003e-7659-4f3f3cbf5546@linux.intel.com>
 <BN9PR11MB527686C925E33E0DCDF261CB8C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527686C925E33E0DCDF261CB8C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 02:35:40AM +0000, Tian, Kevin wrote:
> > From: Baolu Lu <baolu.lu@linux.intel.com>
> > Sent: Wednesday, August 9, 2023 6:41 PM
> > 
> > On 2023/8/9 8:02, Tian, Kevin wrote:
> > >> From: Jason Gunthorpe <jgg@ziepe.ca>
> > >> Sent: Wednesday, August 9, 2023 2:43 AM
> > >>
> > >> On Thu, Aug 03, 2023 at 08:16:47AM +0000, Tian, Kevin wrote:
> > >>
> > >>> Is there plan to introduce further error in the future? otherwise this
> > should
> > >>> be void.
> > >>>
> > >>> btw the work queue is only for sva. If there is no other caller this can be
> > >>> just kept in iommu-sva.c. No need to create a helper.
> > >>
> > >> I think more than just SVA will need a work queue context to process
> > >> their faults.
> > >>
> > >
> > > then this series needs more work. Currently the abstraction doesn't
> > > include workqueue in the common fault reporting layer.
> > 
> > Do you mind elaborate a bit here? workqueue is a basic infrastructure in
> > the fault handling framework, but it lets the consumers choose to use
> > it, or not to.
> > 
> 
> My understanding of Jason's comment was to make the workqueue the
> default path instead of being opted by the consumer.. that is my 1st
> impression but might be wrong...

Yeah, that is one path. Do we have anyone that uses this that doesn't
want the WQ? (actually who even uses this besides SVA?)

Jason
