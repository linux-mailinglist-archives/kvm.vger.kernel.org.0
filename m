Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0674D2808BC
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 22:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgJAUsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 16:48:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:29169 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgJAUsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 16:48:15 -0400
IronPort-SDR: HchZR84M/PAE4jqT/8kMdRKsUIDBwg/SLO/le/AfLbtPWlkkfWIt/oGnep7cRn12FfZuQJ/1Yd
 imhEEViU88Fg==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="163690121"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="163690121"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 13:48:13 -0700
IronPort-SDR: EBusNPlKEIdz3iVcX/dpe+n5ueJaj/fejk+p1qq/6DE8GgK5/vo6qs89WCTnL570fHSN9CbzAR
 dE5EXV1HodjA==
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="351298208"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.6.80]) ([10.212.6.80])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 13:48:11 -0700
Subject: Re: [PATCH v3 05/18] dmaengine: idxd: add IMS support in base driver
To:     Thomas Gleixner <tglx@linutronix.de>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com>
 <87sgazgl0b.fsf@nanos.tec.linutronix.de>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <20743676-1e7e-5535-dcff-c5dadc7ee025@intel.com>
Date:   Thu, 1 Oct 2020 13:48:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87sgazgl0b.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/2020 11:47 AM, Thomas Gleixner wrote:
> On Tue, Sep 15 2020 at 16:28, Dave Jiang wrote:
>>   struct idxd_device {
>> @@ -170,6 +171,7 @@ struct idxd_device {
>>   
>>   	int num_groups;
>>   
>> +	u32 ims_offset;
>>   	u32 msix_perm_offset;
>>   	u32 wqcfg_offset;
>>   	u32 grpcfg_offset;
>> @@ -177,6 +179,7 @@ struct idxd_device {
>>   
>>   	u64 max_xfer_bytes;
>>   	u32 max_batch_size;
>> +	int ims_size;
>>   	int max_groups;
>>   	int max_engines;
>>   	int max_tokens;
>> @@ -196,6 +199,7 @@ struct idxd_device {
>>   	struct work_struct work;
>>   
>>   	int *int_handles;
>> +	struct sbitmap ims_sbmap;
> 
> This bitmap is needed for what?

Nothing anymore. I forgot to remove. All this is handled by MSI core now with 
code from you.

> 
>> --- a/drivers/dma/idxd/init.c
>> +++ b/drivers/dma/idxd/init.c
>> @@ -231,10 +231,51 @@ static void idxd_read_table_offsets(struct idxd_device *idxd)
>>   	idxd->msix_perm_offset = offsets.msix_perm * 0x100;
>>   	dev_dbg(dev, "IDXD MSIX Permission Offset: %#x\n",
>>   		idxd->msix_perm_offset);
>> +	idxd->ims_offset = offsets.ims * 0x100;
> 
> Magic constant pulled out of thin air. #define ....

Will fix

> 
>> +	dev_dbg(dev, "IDXD IMS Offset: %#x\n", idxd->ims_offset);
>>   	idxd->perfmon_offset = offsets.perfmon * 0x100;
>>   	dev_dbg(dev, "IDXD Perfmon Offset: %#x\n", idxd->perfmon_offset);
>>   }
>>   
>> +#define PCI_DEVSEC_CAP		0x23
>> +#define SIOVDVSEC1(offset)	((offset) + 0x4)
>> +#define SIOVDVSEC2(offset)	((offset) + 0x8)
>> +#define DVSECID			0x5
>> +#define SIOVCAP(offset)		((offset) + 0x14)
>> +
>> +static void idxd_check_siov(struct idxd_device *idxd)
>> +{
>> +	struct pci_dev *pdev = idxd->pdev;
>> +	struct device *dev = &pdev->dev;
>> +	int dvsec;
>> +	u16 val16;
>> +	u32 val32;
>> +
>> +	dvsec = pci_find_ext_capability(pdev, PCI_DEVSEC_CAP);
>> +	pci_read_config_word(pdev, SIOVDVSEC1(dvsec), &val16);
>> +	if (val16 != PCI_VENDOR_ID_INTEL) {
>> +		dev_dbg(&pdev->dev, "DVSEC vendor id is not Intel\n");
>> +		return;
>> +	}
>> +
>> +	pci_read_config_word(pdev, SIOVDVSEC2(dvsec), &val16);
>> +	if (val16 != DVSECID) {
>> +		dev_dbg(&pdev->dev, "DVSEC ID is not SIOV\n");
>> +		return;
>> +	}
>> +
>> +	pci_read_config_dword(pdev, SIOVCAP(dvsec), &val32);
>> +	if ((val32 & 0x1) && idxd->hw.gen_cap.max_ims_mult) {
>> +		idxd->ims_size = idxd->hw.gen_cap.max_ims_mult * 256ULL;
>> +		dev_dbg(dev, "IMS size: %u\n", idxd->ims_size);
>> +		set_bit(IDXD_FLAG_SIOV_SUPPORTED, &idxd->flags);
>> +		dev_dbg(&pdev->dev, "IMS supported for device\n");
>> +		return;
>> +	}
>> +
>> +	dev_dbg(&pdev->dev, "SIOV unsupported for device\n");
> 
> It's really hard to find the code inside all of this dev_dbg()
> noise. But why is this capability check done in this driver? Is this
> capability stuff really IDXD specific or is the next device which
> supports this going to copy and pasta the above?

Will look into move this into a common detection function for all similar 
devices. This should be common for all Intel devices that support SIOV.

> 
>>   static void idxd_read_caps(struct idxd_device *idxd)
>>   {
>>   	struct device *dev = &idxd->pdev->dev;
>> @@ -253,6 +294,7 @@ static void idxd_read_caps(struct idxd_device *idxd)
>>   	dev_dbg(dev, "max xfer size: %llu bytes\n", idxd->max_xfer_bytes);
>>   	idxd->max_batch_size = 1U << idxd->hw.gen_cap.max_batch_shift;
>>   	dev_dbg(dev, "max batch size: %u\n", idxd->max_batch_size);
>> +	idxd_check_siov(idxd);
>>   	if (idxd->hw.gen_cap.config_en)
>>   		set_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags);
>>   
>> @@ -347,9 +389,19 @@ static int idxd_probe(struct idxd_device *idxd)
>>   
>>   	idxd->major = idxd_cdev_get_major(idxd);
>>   
>> +	if (idxd->ims_size) {
>> +		rc = sbitmap_init_node(&idxd->ims_sbmap, idxd->ims_size, -1,
>> +				       GFP_KERNEL, dev_to_node(dev));
>> +		if (rc < 0)
>> +			goto sbitmap_fail;
>> +	}
> 
> Ah, here the bitmap is allocated, but it's still completely unclear what
> it is used for.

Need to remove.

> 
> The subject line is misleading as hell. This does not add support, it's
> doing some magic capability checks and allocates stuff which nobody
> knows what it is used for.

With the unneeded code removal and moving the SIOV detection code to common 
implementation, it should be more clear.

> 
> Thanks,
> 
>          tglx
> 
> 
