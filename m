Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232AD41FC25
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 15:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbhJBNQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 09:16:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:15127 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233252AbhJBNQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Oct 2021 09:16:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="225342820"
X-IronPort-AV: E=Sophos;i="5.85,341,1624345200"; 
   d="scan'208";a="225342820"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2021 06:14:53 -0700
X-IronPort-AV: E=Sophos;i="5.85,341,1624345200"; 
   d="scan'208";a="619966367"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.214.7]) ([10.254.214.7])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2021 06:14:51 -0700
Cc:     baolu.lu@linux.intel.com, "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH] iommu: intel: remove flooding of non-error logs, when
 new-DMA-PTE is the same as old-DMA-PTE.
To:     Ajay Garg <ajaygargnsit@gmail.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
References: <20211002124012.18186-1-ajaygargnsit@gmail.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b9afdade-b121-cc9e-ce85-6e4ff3724ed9@linux.intel.com>
Date:   Sat, 2 Oct 2021 21:14:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211002124012.18186-1-ajaygargnsit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/10/2 20:40, Ajay Garg wrote:
> Taking a SD-MMC controller (over PCI) as an example, following is an
> example sequencing, where the log-flooding happened :
> 
> 0.
> We have a host and a guest, both running latest x86_64 kernels.
> 
> 1.
> Host-machine is booted up (with intel_iommu=on), and the DMA-PTEs
> are setup for the controller (on the host), for the first time.
> 
> 2.
> The SD-controller device is added to a (L1) guest on a KVM-VM
> (via virt-manager).

Isn't the domain should be switched from a default domain to an
unmanaged domain when the device is assigned to the guest?

Even you want to r-setup the same mappings, you need to un-map all
existing mappings, right?

Best regards,
baolu

> 
> 3.
> The KVM-VM is booted up.
> 
> 4.
> Above triggers a re-setup of DMA-PTEs on the host, for a
> second time.
> 
> It is observed that the new PTEs formed (on the host) are same
> as the original PTEs, and thus following logs, accompanied by
> stacktraces, overwhelm the logs :
> 
> ......
>   DMAR: ERROR: DMA PTE for vPFN 0x428ec already set (to 3f6ec003 not 3f6ec003)
>   DMAR: ERROR: DMA PTE for vPFN 0x428ed already set (to 3f6ed003 not 3f6ed003)
>   DMAR: ERROR: DMA PTE for vPFN 0x428ee already set (to 3f6ee003 not 3f6ee003)
>   DMAR: ERROR: DMA PTE for vPFN 0x428ef already set (to 3f6ef003 not 3f6ef003)
>   DMAR: ERROR: DMA PTE for vPFN 0x428f0 already set (to 3f6f0003 not 3f6f0003)
> ......
> 
> As the PTEs are same, so there is no cause of concern, and we can easily
> avoid the logs-flood for this non-error case.
> 
> Signed-off-by: Ajay Garg <ajaygargnsit@gmail.com>
> ---
>   drivers/iommu/intel/iommu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index d75f59ae28e6..8bea8b4e3ff9 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -2370,7 +2370,7 @@ __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
>   		 * touches the iova range
>   		 */
>   		tmp = cmpxchg64_local(&pte->val, 0ULL, pteval);
> -		if (tmp) {
> +		if (tmp && (tmp != pteval)) {
>   			static int dumps = 5;
>   			pr_crit("ERROR: DMA PTE for vPFN 0x%lx already set (to %llx not %llx)\n",
>   				iov_pfn, tmp, (unsigned long long)pteval);
> 
