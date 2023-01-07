Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC412660BDB
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 03:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbjAGCTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 21:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAGCTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 21:19:50 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DFE93;
        Fri,  6 Jan 2023 18:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673057989; x=1704593989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uqRXSv+w2S4+7Q/28oxX65phfR+wQelpxsc+b44OilQ=;
  b=YhT88yCfF9JuA5S2SIrDg9szqh+wFVD/baEd2XlIRU315t1vAadmtdsA
   Mzrb4XC6FCRavVIRM2tFIolYN+OJX2PPUL0O2M38Cl/xompvfe1CV5ru0
   jKzt2QUlRy7/q9aJyVJpxYJ9BTA9+9tDfEcvaxEC9KEkCLhtO/Wvi18MO
   ihk2eNoYkbCjxji+WBtg1P76hLYRbGdtoOWmStRuHbVSrYlY08Pvs2wMg
   z2ECavMbMc1orG81IiUrPqB333vFIqRhrWfL4s5dGYxjFLW+MI1Y627Z3
   Y3hJJNcyzbD5AAiEG00XXGr39ylJE7ZFICzQOc5iKwYdoiiQU22bZY5J7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="321305976"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="321305976"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 18:19:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="763702557"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="763702557"
Received: from yiweihua-mobl1.ccr.corp.intel.com (HELO [10.254.209.158]) ([10.254.209.158])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 18:19:43 -0800
Message-ID: <e06f65a5-11e9-527e-97fd-857abe7e2e16@linux.intel.com>
Date:   Sat, 7 Jan 2023 10:19:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH iommufd v3 2/9] iommu: Add iommu_group_has_isolated_msi()
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
References: <2-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
 <2c12143b-eaa9-2f6b-d367-e55d6f1e180d@linux.intel.com>
 <Y7geJZkCdXmgaD8V@nvidia.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <Y7geJZkCdXmgaD8V@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/2023 9:12 PM, Jason Gunthorpe wrote:
> On Fri, Jan 06, 2023 at 07:28:46PM +0800, Baolu Lu wrote:
> 
>>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>>> index 46e1347bfa2286..9b7a9fa5ad28d3 100644
>>> --- a/include/linux/iommu.h
>>> +++ b/include/linux/iommu.h
>>> @@ -455,6 +455,7 @@ static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
>>>    extern int bus_iommu_probe(struct bus_type *bus);
>>>    extern bool iommu_present(struct bus_type *bus);
>>>    extern bool device_iommu_capable(struct device *dev, enum iommu_cap cap);
>>> +extern bool iommu_group_has_isolated_msi(struct iommu_group *group);
>> This lacks a static inline definition when CONFIG_IOMMU_API is false?
> It is not needed, the call sites are all compilation protected by
> CONFIG_IOMMU_API already.

Thanks for the explanation. It's okay to me as it has been considered.

--
Best regards,
baolu
