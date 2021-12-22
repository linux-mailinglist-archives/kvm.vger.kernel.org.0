Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2351F47CC15
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 05:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhLVEZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 23:25:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:25944 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232658AbhLVEZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 23:25:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640147157; x=1671683157;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=zybkO6myHTgJXbb9BKIuV/UbCxPTxJVK/qCq3t4VbHo=;
  b=ZNjitHdGdHLYnQtBMefXBOXxV24oludn3zZXn6fyIU136ek/C3d77YUo
   B+ACuou952ZqpO0VxIL1IxsoMArsiqkkKA3qu+2Qc0oaPtK1XAho1i63i
   81tLfbwpmTp7MW2i4zXkcrern+8BZ0oqKfoyt5111k0BYFvVflBPeVAwq
   LhDDm9xncKzTUWxhrg6GR//pt1e6vS4o0nDtrY+DDdKtUa0aWln/ZrXpC
   OR3906AtSAnOajWE8/iRq4wRbt0cPzsvtbyW/9tRMFaY6lLEAopPNT5Es
   c757j/lCg9wdRL0kNajXQT59Hr9we0wDwA6y05HzwjbjkCfzeKNrItbix
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="303912678"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="303912678"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 20:25:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="664155500"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 21 Dec 2021 20:25:50 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/13] iommu: Add iommu_at[de]tach_device_shared() for
 multi-device groups
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
 <20211221184609.GF1432915@nvidia.com>
 <ced7f89a-8857-a8bb-be06-aaaabb4cdf09@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <c8b1e775-6821-59eb-6544-26983857f712@linux.intel.com>
Date:   Wed, 22 Dec 2021 12:25:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ced7f89a-8857-a8bb-be06-aaaabb4cdf09@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/22/21 12:22 PM, Lu Baolu wrote:
> void iommu_detach_device_shared(struct iommu_domain *domain, struct 
> device *dev)

Sorry for typo. Please ignore the _shared postfix.

Best regards,
baolu
