Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87E5BC11F
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 06:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394439AbfIXEm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 00:42:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:41859 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390852AbfIXEm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 00:42:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 21:42:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,542,1559545200"; 
   d="scan'208";a="200775783"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 23 Sep 2019 21:42:25 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        sanjay.k.kumar@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] Use 1st-level for DMA remapping in guest
To:     "Raj, Ashok" <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122715.53de79d0@jacob-builder>
 <20190923202552.GA21816@araj-mobl1.jf.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <da9513dc-dd46-f2ba-1ed5-e207b6fe07f0@linux.intel.com>
Date:   Tue, 24 Sep 2019 12:40:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923202552.GA21816@araj-mobl1.jf.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/24/19 4:25 AM, Raj, Ashok wrote:
> Hi Jacob
> 
> On Mon, Sep 23, 2019 at 12:27:15PM -0700, Jacob Pan wrote:
>>>
>>> In VT-d 3.0, scalable mode is introduced, which offers two level
>>> translation page tables and nested translation mode. Regards to
>>> GIOVA support, it can be simplified by 1) moving the GIOVA support
>>> over 1st-level page table to store GIOVA->GPA mapping in vIOMMU,
>>> 2) binding vIOMMU 1st level page table to the pIOMMU, 3) using pIOMMU
>>> second level for GPA->HPA translation, and 4) enable nested (a.k.a.
>>> dual stage) translation in host. Compared with current shadow GIOVA
>>> support, the new approach is more secure and software is simplified
>>> as we only need to flush the pIOMMU IOTLB and possible device-IOTLB
>>> when an IOVA mapping in vIOMMU is torn down.
>>>
>>>       .-----------.
>>>       |  vIOMMU   |
>>>       |-----------|                 .-----------.
>>>       |           |IOTLB flush trap |   QEMU    |
>>>       .-----------.    (unmap)      |-----------|
>>>       | GVA->GPA  |---------------->|           |
>>>       '-----------'                 '-----------'
>>>       |           |                       |
>>>       '-----------'                       |
>>>             <------------------------------
>>>             |      VFIO/IOMMU
>>>             |  cache invalidation and
>>>             | guest gpd bind interfaces
>>>             v
>> For vSVA, the guest PGD bind interface will mark the PASID as guest
>> PASID and will inject page request into the guest. In FL gIOVA case, I
>> guess we are assuming there is no page fault for GIOVA. I will need to
>> add a flag in the gpgd bind such that any PRS will be auto responded
>> with invalid.
> 
> Is there real need to enforce this? I'm not sure if there is any
> limitation in the spec, and if so, can the guest check that instead?

For FL gIOVA case, gPASID is always 0. If a physical device is passed
through, hPASID is also 0; If an mdev device (representing an ADI)
instead, hPASID would be the PASID corresponding to the ADI. The
simulation software (i.e. QEMU) maintains a map between gPASID and
hPASID.

I second Ashok's idea. We don't need to distinguish these two cases in
the api and handle page request interrupt in guest as an unrecoverable
one.

> 
> Also i believe the idea is to overcommit PASID#0 such uses. Thought
> we had a capability to expose this to the vIOMMU as well. Not sure if this
> is already documented, if not should be up in the next rev.
> 
> 
>>
>> Also, native use of IOVA FL map is not to be supported? i.e. IOMMU API
>> and DMA API for native usage will continue to be SL only?
>>>       .-----------.
>>>       |  pIOMMU   |
>>>       |-----------|
>>>       .-----------.
>>>       | GVA->GPA  |<---First level
>>>       '-----------'
>>>       | GPA->HPA  |<---Scond level
> 
> s/Scond/Second

Yes. Thanks!

Best regards,
Baolu
