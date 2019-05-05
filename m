Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2886813CA4
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 03:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfEEB3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 May 2019 21:29:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:37208 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbfEEB3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 May 2019 21:29:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:29:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="146324031"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by fmsmga008.fm.intel.com with ESMTP; 04 May 2019 18:29:11 -0700
Cc:     baolu.lu@linux.intel.com, Heiko Stuebner <heiko@sntech.de>,
        kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        David Brown <david.brown@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-s390@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-rockchip@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andy Gross <andy.gross@linaro.org>,
        linux-tegra@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-msm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        linux-kernel@vger.kernel.org, murphyt7@tcd.ie,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC 2/7] iommu/vt-d: Remove iova handling code from non-dma ops
 path
To:     Tom Murphy <tmurphy@arista.com>, iommu@lists.linux-foundation.org
References: <20190504132327.27041-1-tmurphy@arista.com>
 <20190504132327.27041-3-tmurphy@arista.com>
 <bf35694d-3ff4-0df7-0802-b0e87a9a0d47@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <9405cd93-fc16-822e-0b34-4ba2229f176d@linux.intel.com>
Date:   Sun, 5 May 2019 09:22:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bf35694d-3ff4-0df7-0802-b0e87a9a0d47@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/5/19 9:19 AM, Lu Baolu wrote:
> Hi,
> 
> On 5/4/19 9:23 PM, Tom Murphy via iommu wrote:
>> @@ -4181,58 +4168,37 @@ static int intel_iommu_memory_notifier(struct 
>> notifier_block *nb,
>>                          unsigned long val, void *v)
>>   {
>>       struct memory_notify *mhp = v;
>> -    unsigned long long start, end;
>> -    unsigned long start_vpfn, last_vpfn;
>> +    unsigned long start_vpfn = mm_to_dma_pfn(mhp->start_pfn);
>> +    unsigned long last_vpfn = mm_to_dma_pfn(mhp->start_pfn +
>> +            mhp->nr_pages - 1);
>>       switch (val) {
>>       case MEM_GOING_ONLINE:
>> -        start = mhp->start_pfn << PAGE_SHIFT;
>> -        end = ((mhp->start_pfn + mhp->nr_pages) << PAGE_SHIFT) - 1;
>> -        if (iommu_domain_identity_map(si_domain, start, end)) {
>> -            pr_warn("Failed to build identity map for [%llx-%llx]\n",
>> -                start, end);
>> +        if (iommu_domain_identity_map(si_domain, start_vpfn,
>> +                    last_vpfn)) {
>> +            pr_warn("Failed to build identity map for [%lx-%lx]\n",
>> +                start_vpfn, last_vpfn);
>>               return NOTIFY_BAD;
>>           }
>>           break;
> 
> Actually we don't need to update the si_domain if iommu hardware
> supports pass-through mode. This should be made in a separated patch
> anyway.

Oh! please ignore it.

This callback is only registered when hardware doesn't support pass
through mode.

         if (si_domain && !hw_pass_through)
                 register_memory_notifier(&intel_iommu_memory_nb);

Best regards,
Lu Baolu

