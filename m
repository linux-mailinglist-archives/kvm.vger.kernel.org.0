Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A28576CFD3
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 16:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjHBOPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 10:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjHBOPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 10:15:36 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECA52121
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 07:15:35 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-768054797f7so596242085a.2
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 07:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1690985735; x=1691590535;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v/v2fhzkoLc0XBqBu1jWFj/Nwn47lwdRkCiLxyO8V30=;
        b=Sxdue3MHFYBbmk6FfucrMbAKCC/vqFsDJvMkC6HXzY02Qba2GTHr0SHy1DwQO07w8A
         Gxi3Fk//XxlHJFW+0AaTYct04Om8rU5nIrErYS8hm82LO9r8W+nPak0n5OWrQEPjNRl1
         8+zxXUx5T3IWrVj9iFJPYAmUwOaFILiqk9eFcGuJzgk6IICab1ppy0/AY1k+AegChCKz
         lpNVHQLxYegoj1+mltezt+ZRXkrP9NhThJ4fnXfbGVot3WaEc8H5FrMRVt9Dn4CbdiZm
         Rozx7DgQC0/x1PP/RXh0wc19ORG6eXFtFDQUtFUP8KqnHGFR4oQLjDUvyDBysjFguDb+
         kDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690985735; x=1691590535;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/v2fhzkoLc0XBqBu1jWFj/Nwn47lwdRkCiLxyO8V30=;
        b=VcsBpEBFpyhWoPJrd+fbBoro3uo/pFeaWVK7Tnj0DUqQvWPG46b/v+59oSWdcM7EIm
         m7ffNhK6Lt1u4/oZMto3GCH7DPgDuhhRsqSgl9KyRpwy+OpUSRR1N/k07R6tSJtrERnf
         y1LN2TCZAMqRlXMuel0TaVz2qi06+K5DGB+0q/U+daKkUefrd76Bk2Eebx0LHxHEDh33
         /+8SLou2VhUBABlVN5KX3NugnAqPvABIcbXqiYriZS+FPQL7hZP+TfXj72rH+VFTutAy
         vTSmm1VZkqBML9cWZLfmzkYmXzDrrTj8avcimG+M2j6Zd5O+Jp/05+Iro+3Da856i/Xr
         I2Fg==
X-Gm-Message-State: ABy/qLb1LdMCoe8uPMlaAdoo0rGKK3wUJ2ExqdUqdLeWRsBjlTCAaGmr
        JQ5yOCRVOkBnP2x88SsN+u42ow==
X-Google-Smtp-Source: APBJJlGInqqbbLPaE80P2pKXirrUYAT7zZzyHhPtLanpiPQ2UB6qB27NxHN+Y/2YgtYZ3tPQ3pH3nQ==
X-Received: by 2002:a05:620a:205d:b0:76c:be58:d770 with SMTP id d29-20020a05620a205d00b0076cbe58d770mr5994984qka.78.1690985734872;
        Wed, 02 Aug 2023 07:15:34 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id a11-20020a05620a124b00b00767cd2dbd82sm2507399qkl.15.2023.08.02.07.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 07:15:34 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qRCdR-0033D9-O2;
        Wed, 02 Aug 2023 11:15:33 -0300
Date:   Wed, 2 Aug 2023 11:15:33 -0300
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
Subject: Re: [PATCH 0/2] iommu: Make pasid array per device
Message-ID: <ZMplBfgSb8Hh9jLt@ziepe.ca>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801063125.34995-1-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023 at 02:31:23PM +0800, Lu Baolu wrote:
> The PCI PASID enabling interface guarantees that the address space used
> by each PASID is unique. This is achieved by checking that the PCI ACS
> path is enabled for the device. If the path is not enabled, then the
> PASID feature cannot be used.
> 
>     if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
>             return -EINVAL;
> 
> The PASID array is not an attribute of the IOMMU group. It is more
> natural to store the PASID array in the per-device IOMMU data. This
> makes the code clearer and easier to understand. No functional changes
> are intended.

Is there a reason to do this?

*PCI* requires the ACS/etc because PCI kind of messed up how switches
handled PASID so PASID doesn't work otherwise.

But there is nothing that says other bus type can't have working
(non-PCI) PASID and still have device isolation issues.

So unless there is a really strong reason to do this we should keep
the PASID list in the group just like the domain.

Jason
