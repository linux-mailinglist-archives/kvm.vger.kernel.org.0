Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF355198CAF
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 09:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgCaHIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 03:08:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:38108 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbgCaHIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 03:08:36 -0400
IronPort-SDR: +I4Vp4PERV3KHVLi56ntMhBm7Q7V6dXcrg9QDLtAVxHP0TN2rI2BPo5Mv8t5BdBTw8JRNqmIVG
 i8eO5Af/gGhA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 00:08:34 -0700
IronPort-SDR: LAcVC48tXZVNzrIzsW1uRGGaOLpng05aY2x0BJTn0dHY1nGGSlzZrj1UeRPTxkE9oc3ynp5abx
 B2/CAwssU0eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="267183304"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.210.112]) ([10.254.210.112])
  by orsmga002.jf.intel.com with ESMTP; 31 Mar 2020 00:08:26 -0700
Cc:     baolu.lu@intel.com,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [PATCH v1 0/2] vfio/pci: expose device's PASID capability to VMs
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D801252@SHSMSX104.ccr.corp.intel.com>
From:   "Lu, Baolu" <baolu.lu@intel.com>
Message-ID: <ce615f64-a19b-a365-8f8e-ca29f69cc6c0@intel.com>
Date:   Tue, 31 Mar 2020 15:08:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D801252@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/31 14:35, Tian, Kevin wrote:
>> From: Liu, Yi L<yi.l.liu@intel.com>
>> Sent: Sunday, March 22, 2020 8:33 PM
>>
>> From: Liu Yi L<yi.l.liu@intel.com>
>>
>> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
>> Intel platforms allows address space sharing between device DMA and
>> applications. SVA can reduce programming complexity and enhance security.
>>
>> To enable SVA, device needs to have PASID capability, which is a key
>> capability for SVA. This patchset exposes the device's PASID capability
>> to guest instead of hiding it from guest.
>>
>> The second patch emulates PASID capability for VFs (Virtual Function) since
>> VFs don't implement such capability per PCIe spec. This patch emulates such
>> capability and expose to VM if the capability is enabled in PF (Physical
>> Function).
>>
>> However, there is an open for PASID emulation. If PF driver disables PASID
>> capability at runtime, then it may be an issue. e.g. PF should not disable
>> PASID capability if there is guest using this capability on any VF related
>> to this PF. To solve it, may need to introduce a generic communication
>> framework between vfio-pci driver and PF drivers. Please feel free to give
>> your suggestions on it.
> I'm not sure how this is addressed on bate metal today, i.e. between normal
> kernel PF and VF drivers. I look at pasid enable/disable code in intel-iommu.c.
> There is no check on PF/VF dependency so far. The cap is toggled when
> attaching/detaching the PF to its domain. Let's see how IOMMU guys
> respond, and if there is a way for VF driver to block PF driver from disabling
> the pasid cap when it's being actively used by VF driver, then we may
> leverage the same trick in VFIO when emulation is provided to guest.

IOMMU subsystem doesn't expose any APIs for pasid enabling/disabling.
The PCI subsystem does. It handles VF/PF like below.

/**
  * pci_enable_pasid - Enable the PASID capability
  * @pdev: PCI device structure
  * @features: Features to enable
  *
  * Returns 0 on success, negative value on error. This function checks
  * whether the features are actually supported by the device and returns
  * an error if not.
  */
int pci_enable_pasid(struct pci_dev *pdev, int features)
{
         u16 control, supported;
         int pasid = pdev->pasid_cap;

         /*
          * VFs must not implement the PASID Capability, but if a PF
          * supports PASID, its VFs share the PF PASID configuration.
          */
         if (pdev->is_virtfn) {
                 if (pci_physfn(pdev)->pasid_enabled)
                         return 0;
                 return -EINVAL;
         }

/**
  * pci_disable_pasid - Disable the PASID capability
  * @pdev: PCI device structure
  */
void pci_disable_pasid(struct pci_dev *pdev)
{
         u16 control = 0;
         int pasid = pdev->pasid_cap;

         /* VFs share the PF PASID configuration */
         if (pdev->is_virtfn)
                 return;


It doesn't block disabling PASID on PF even VFs are possibly using it.

Best regards,
baolu
