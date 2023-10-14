Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817907C935A
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 09:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbjJNHxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Oct 2023 03:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbjJNHxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Oct 2023 03:53:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A75A9
        for <kvm@vger.kernel.org>; Sat, 14 Oct 2023 00:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697270028; x=1728806028;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8FUCVkEXo2dDBEoDY3Ok5aqS4qxJmKgJGIKKpwEolwk=;
  b=npHAcHNsPPrDf0+XTRCUUN7WGBaWdKmQUTdtjNl4kP+a2DHIeswqACkI
   YpU8YtgwHbXeKhMdsKGX4nC/hrkJ9S/gw942XtGWao9TBBIN4Mkgc83qL
   UzXJoNqnjSu0I2eXMtEdmAlgl7TtJ3EU59eXIgcbky0Q3qIQvSpG6x/Ct
   kE5IayvN3GwwB/Hks+kSYIYkDzSLKycMbaMB1b/WzbzGJVleaO9r82dCP
   NPZ3Sbj/Zs1WvrJbhUnO5CwYavN0Pifet+tSXdbHIeCuJu7LzzAoRnYY4
   J0unPbAL6372iEEP+CBbJHxSxPBIT75lfjHjcQk4eIYSiXfGqfV+pNwxN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="364674188"
X-IronPort-AV: E=Sophos;i="6.03,224,1694761200"; 
   d="scan'208";a="364674188"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2023 00:53:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="754977578"
X-IronPort-AV: E=Sophos;i="6.03,224,1694761200"; 
   d="scan'208";a="754977578"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.238.2.200]) ([10.238.2.200])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2023 00:53:44 -0700
Message-ID: <78e43ae6-99bf-c326-b0a2-930ced04911f@linux.intel.com>
Date:   Sat, 14 Oct 2023 15:53:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Cc:     baolu.lu@linux.intel.com, iommu@lists.linux.dev,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/19] IOMMUFD Dirty Tracking
To:     Joao Martins <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20231013162949.GG3952@nvidia.com>
 <9df305a4-1176-4187-9dae-37dc954289f1@oracle.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <9df305a4-1176-4187-9dae-37dc954289f1@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/14 2:11, Joao Martins wrote:
>> If either AMD or Intel ack the driver part next week I would take it
>> this cycle. Otherwise at -rc1.
>>
> FWIW, I feel more confident on the AMD parts as they have been exercised on real
> hardware.
> 
> Suravee, Vasant, if you could take a look at the AMD driver patches -- you
> looked at a past revision (RFCv1) and provided comments but while I took the
> comments I didn't get Suravee's ACK as things were in flux on the UAPI side. But
> it looks that v4 won't change much of the drivers
> 

I will also take a look at the Intel driver part.

Best regards,
baolu
