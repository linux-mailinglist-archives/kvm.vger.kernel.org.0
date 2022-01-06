Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9586485F4F
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 04:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiAFDoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 22:44:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:14946 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230214AbiAFDoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 22:44:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641440651; x=1672976651;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=izTXx3R6T91KwPw+mhLreSSPy1JtAl4lGGpkT1QKBWE=;
  b=EGzFvJZKZ53/2mUyn37cDQ3cAf5jbhD7cvZTygyjDPsXoRtiyfKFHZMT
   TG8niEaEfIB8qoybR2u0ZaBfXFpLoXrcCGQrSmkPB9MKnjBa4HAuxuuPC
   NiB9/1iqnHQCnk0A4EktWoT+wiE2N7z7Pg1QFPTOrApoQnHn1G56fbc/v
   jJiCJ/s8nJFhTt2cTAoYvO61QW7c96L2zuKZRFElj5L1IKTsn1JDDr5iB
   5dzIo4OxCJGtjItvvcotpksn69StbOeTarN2BHMDFSbQJHdM1MdlKiGGH
   tjeUo/48AIbfx4lL79YPSIcz4HgqQocM6y/P1hdreLQadRGgNXbCRW4L4
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240129754"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="240129754"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 19:44:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526814111"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 19:44:03 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [PATCH v5 01/14] iommu: Add dma ownership management interfaces
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20220104164100.GA101735@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <5a2fdbe2-da57-eac4-f115-c5f434080b36@linux.intel.com>
Date:   Thu, 6 Jan 2022 11:43:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104164100.GA101735@bhelgaas>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 1/5/22 12:41 AM, Bjorn Helgaas wrote:
>>> This adds dma ownership management in iommu core and exposes several
>>> interfaces for the device drivers and the device userspace assignment
>>> framework (i.e. vfio), so that any conflict between user and kernel
>>> controlled DMA could be detected at the beginning.
> Maybe I'm missing the point because I don't know what "conflict
> between user and kernel controlled DMA" is.  Are you talking about
> both userspace and the kernel programming the same device to do DMA?

It's about both userspace and kernel programming different devices
belonging to a same iommu group to do DMA. For example, PCI device A and
B sit in a some iommu group. Userspace programs device A for DMA and a
kernel driver programs device B. Userspace may intentionally or
unintentionally program device A to access and change device B's MMIO
with P2P DMA transactions which cause the kernel driver for device B
result in an inconsistent state.

This may not be all, just an example.

Best regards,
baolu

