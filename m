Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1736750330
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 11:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbjGLJdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 05:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbjGLJds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 05:33:48 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B805F10CF
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 02:33:46 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3fbea147034so68044605e9.0
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 02:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689154425; x=1691746425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LEbT69ORmiT4B7gB/4ua+o5DtuaLJ+rxLl7qFmnLAlc=;
        b=uUYdMxWdSfz63WBoFynzEmeS9rS/FmdUm1PR1CTcVchr5vV9aSbJWd1f16LtBcw7D/
         vwrRKbTeOCk6Xgj1qlCYrFWGxfd6Q6M7BIpPMRvTC0vKu2gB/AObNFSDCfjpr6fswCZi
         zm5eOKoRVKdrs47wRs5mlddxIRgxP12fP6ARY5RkzPcenGIu6t21n+BMgd+30Un/5X1q
         Cr+Lfc5PY+A9O50OTlotNKdZDiqjHy+KnR1MqB/TBWF9sXc3nGtPQWZ/2TOfkil7/Wcy
         woOrdB/x7mySbodSMvYf2G1Bqz3jtOWAfz/N6IfutZF8b619b4hyZp1Nc37TLtUuKdpu
         Em2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689154425; x=1691746425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LEbT69ORmiT4B7gB/4ua+o5DtuaLJ+rxLl7qFmnLAlc=;
        b=T7ycwq5ulo3pWWH2UWs4lcaFI9lwA7S1nzyoV8HJLCHg9O+PmUAr9cYvQEgoExAI9C
         Btva1PC51FpZ68/Npi1eM6M04Sao9kXAvEhfPDKm2f2ZcJT8WRTmNg/2Nj3nxsAg0r0U
         SpYgX0JITTQzInNIczp0O+U+n1SqRMab1VV6PXg5w38yTPAC6FjQpxY/NSyqH69xp9Q6
         iCniHXl4E3XFHUmQMuZL/ERAEJ+eseehBRjT7xc88p0+BMzLEBCyUWjvGY377XMQOS6i
         d/+P+w5KEkKGIL+uaYQRrl3Db+7be85a73ZxBflhgH1ejdddK/nbFfxgYDyl+HtpKnJ1
         20GQ==
X-Gm-Message-State: ABy/qLZIi7e6v2HdEkf9ohNtNccAZT7r/duHTn+gPoF2FT/KW82mNmw9
        rErH3t/szTe5LkTLK/BZ49SJDQ==
X-Google-Smtp-Source: APBJJlGLvpS5QqDKmKL+tApWyDTyJ91oFqLDv89odT6Zvd+rWYAJsxdNNWKNCT+b+anOZwPz5lJpiA==
X-Received: by 2002:a05:600c:2283:b0:3fb:e4ce:cc65 with SMTP id 3-20020a05600c228300b003fbe4cecc65mr16251688wmf.25.1689154425088;
        Wed, 12 Jul 2023 02:33:45 -0700 (PDT)
Received: from myrica ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id c18-20020a7bc012000000b003fb40f5f553sm15191235wmb.31.2023.07.12.02.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 02:33:44 -0700 (PDT)
Date:   Wed, 12 Jul 2023 10:33:44 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] iommu: Move iommu fault data to linux/iommu.h
Message-ID: <20230712093344.GA507884@myrica>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276859ED6825C0A496C9C5E8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <38c31fb0-1068-4855-c896-27d6a2bca747@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38c31fb0-1068-4855-c896-27d6a2bca747@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 10:07:22AM +0800, Baolu Lu wrote:
> > > +/**
> > > + * struct iommu_fault_unrecoverable - Unrecoverable fault data
> > > + * @reason: reason of the fault, from &enum iommu_fault_reason
> > > + * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
> > > + * @pasid: Process Address Space ID
> > > + * @perm: requested permission access using by the incoming transaction
> > > + *        (IOMMU_FAULT_PERM_* values)
> > > + * @addr: offending page address
> > > + * @fetch_addr: address that caused a fetch abort, if any
> > > + */
> > > +struct iommu_fault_unrecoverable {
> > > +	__u32	reason;
> > > +#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
> > > +#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
> > > +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
> > > +	__u32	flags;
> > > +	__u32	pasid;
> > > +	__u32	perm;
> > > +	__u64	addr;
> > > +	__u64	fetch_addr;
> > > +};
> > 
> > Currently there is no handler for unrecoverable faults.

Yes those were meant for guest injection. Another goal was to replace
report_iommu_fault(), which also passes unrecoverable faults to host
drivers. Three drivers use that API:
* usnic just prints the error, which could be done by the IOMMU driver,
* remoteproc attempts to recover from the crash,
* msm attempts to handle the fault, or at least recover from the crash.

So the first one can be removed, and the others could move over to IOPF
(which may need to indicate that the fault is not actually recoverable by
the IOMMU) and return IOMMU_PAGE_RESP_INVALID.

> > 
> > Both Intel/ARM register iommu_queue_iopf() as the device fault handler.
> > It returns -EOPNOTSUPP for unrecoverable faults.
> > 
> > In your series the common iommu_handle_io_pgfault() also only works
> > for PRQ.
> > 
> > It kinds of suggest above definitions are dead code, though arm-smmu-v3
> > does attempt to set them.
> > 
> > Probably it's right time to remove them.
> > 
> > In the future even if there might be a need of forwarding unrecoverable
> > faults to the user via iommufd, fault reasons reported by the physical
> > IOMMU doesn't make any sense to the guest.

I guess it depends on the architecture?  The SMMU driver can report only
stage-1 faults through iommu_report_device_fault(), which are faults due
to a guest misconfiguring the tables assigned to it. At the moment
arm_smmu_handle_evt() only passes down stage-1 page table errors, the rest
is printed by the host.

> > Presumably the vIOMMU
> > should walk guest configurations to set a fault reason which makes sense
> > from guest p.o.v.
> 
> I am fine to remove unrecoverable faults data. But it was added by Jean,
> so I'd like to know his opinion on this.

Passing errors to the guest could be a useful diagnostics tool for
debugging, once the guest gets more controls over the IOMMU hardware, but
it doesn't have a purpose beyond that. It could be the only tool
available, though: to avoid a guest voluntarily flooding the host logs by
misconfiguring its tables, we may have to disable printing in the host
errors that come from guest misconfiguration, in which case there won't be
any diagnostics available for guest bugs.

For now I don't mind if they're removed, if there is an easy way to
reintroduce them later.

Thanks,
Jean

