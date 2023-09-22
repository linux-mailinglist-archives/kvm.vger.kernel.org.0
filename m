Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF5E7AB25A
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 14:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbjIVMnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 08:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIVMnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 08:43:12 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187B28F
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:43:06 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-77063481352so166491185a.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695386585; x=1695991385; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dJYX5wUywumkDIjBBuCsh0129IAPGx0MBB+MpKbn2U4=;
        b=S/+WhR0EEnJ8PYQjfLxvP/f8zSmaS2TJz8yqoHYbn5vdHZaiYYf26Ob1MkfvPAyqs8
         oFSKekKBQ/mU3IC/CGv2bNtSuI0E2q2cIsp9cQMsQ6VMRcQAOibLdgBphE1cx7ezNubB
         gG5g4o2UxEbb/Rn23c+zj+9JWLw3kA0ubjdblJlIT/+oc+8ECUap29TaOlyzH4Hn59GL
         qBm58FEiOltgDH71IGtrO3xTlLHtMs1e6vZ4PURnJMPpz11XC+hofEdZzWHlu/vmh3oe
         2uIsmQr71MkMohuReFCgLi+L+q+hBH+Zxeh/DwVCHDBlPDWizLecyMlkCZYohhU+cYZS
         K2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695386585; x=1695991385;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dJYX5wUywumkDIjBBuCsh0129IAPGx0MBB+MpKbn2U4=;
        b=BhV2xLE91ZRKkEeAxIMgwf4k1bLHMEJk4fsJd5a6glg/ZVZkg4SdE6H7ubTQZom9cu
         NvxnE7+fx8KxzL/0IwOs3vGSnOhMY3P39MYTSJZe1NcZnmiOOoddrYBgp6v8g+U0ZNuZ
         a+UA/Mgbj2oz9w53O0pkjfOnpCivIZHz4ElrpsRuDnHbyzivvwkmBr47I5gO2zqCg5EA
         IiIOfGrwR1VPfvhCqRjOuiXx5M13HQFe14ycq012ePm0WeDOvJlDTcjCkbQfwJiJGq38
         /9L9cCqOBhKWsNudUup0pEgxHSCUYNXflbWdQSeYaqCuQvMs0a3Jet0UlVkSTMxtS3pK
         vuyA==
X-Gm-Message-State: AOJu0YybVR7vSTkXFyMtDoGf6S7LvPiCn+suAwgD0y+R7b7Wr7Nxw3WF
        AvVKL7IhydnyXQsK1+D8UB7XDA==
X-Google-Smtp-Source: AGHT+IHm/qwy9v94zwoSSNba4IDdrqDeA5MFzZIlrmmRnzEbwpTUWaYrkAhTSt+q/0yib09m0ubygQ==
X-Received: by 2002:ad4:5de7:0:b0:656:519c:5a07 with SMTP id jn7-20020ad45de7000000b00656519c5a07mr3118747qvb.25.1695386585198;
        Fri, 22 Sep 2023 05:43:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id t15-20020a0cde0f000000b006588f418323sm1396225qvk.64.2023.09.22.05.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 05:43:04 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qjfUt-000Y5A-VB;
        Fri, 22 Sep 2023 09:43:03 -0300
Date:   Fri, 22 Sep 2023 09:43:03 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     "Liu, Jingqi" <jingqi.liu@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/12] iommu: Make iommu_queue_iopf() more generic
Message-ID: <20230922124303.GE13795@ziepe.ca>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-10-baolu.lu@linux.intel.com>
 <f20b9e78-3a63-ca3e-6c04-1d80ec857898@intel.com>
 <20230921233402.GC13795@ziepe.ca>
 <e7c773f6-969c-0097-1bca-24d276e8a8f6@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7c773f6-969c-0097-1bca-24d276e8a8f6@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 10:44:45AM +0800, Baolu Lu wrote:

> > > > @@ -112,6 +110,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
> > > >    {
> > > >    	int ret;
> > > >    	struct iopf_group *group;
> > > > +	struct iommu_domain *domain;
> > > >    	struct iopf_fault *iopf, *next;
> > > >    	struct iommu_fault_param *iopf_param;
> > > >    	struct dev_iommu *param = dev->iommu;
> > > > @@ -143,6 +142,19 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
> > > >    		return 0;
> > > >    	}
> > > > +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
> > > > +		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
> > > > +	else
> > > > +		domain = iommu_get_domain_for_dev(dev);
> > > > +
> > > > +	if (!domain || !domain->iopf_handler) {
> > > 
> > > Does it need to check if 'domain' is error ?  Like below:
> > > 
> > >           if (!domain || IS_ERR(domain) || !domain->iopf_handler)
> > 
> > Urk, yes, but not like that
> > 
> > The IF needs to be moved into the else block as each individual
> > function has its own return convention.
> 
> iommu_get_domain_for_dev_pasid() returns an ERR_PTR only if the matching
> domain type is specified (non-zero).
> 
> Adding IS_ERR(domain) in the else block will make the code more
> readable. Alternatively we can put a comment around above code to
> explain that ERR_PTR is not a case here.

You should check it because you'll probably get a static tool
complaint otherwise

Jason
