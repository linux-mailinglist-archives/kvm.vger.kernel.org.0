Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5157D4F53
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjJXMCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjJXMCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:02:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF00120;
        Tue, 24 Oct 2023 05:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698148924; x=1729684924;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aPOLTqz6uP6WaCFzg7y4GFdJcJn10yPDR/rrSJsgu+M=;
  b=KFwjoNcIVGNKcnTvLXq4rWR7S9Esk0KXPLSWad/5Yjb6/qJsCs4Fh9yG
   3eDsiF2HUw8PkOxtFlUlWojcbc3nSHxF11EkI/fiRZbTy6ynYbKaLwa1u
   xlxT1WOGJ+1er02AZz3qszFEtAUuK44KVYwdJgRkb+Oz6hHWGM+Bs5fIW
   w42BsnPe4q5+p8h/EBizrrdpYXz/TJQjbdmQFc+ntKyGIcQhoNcikyX8M
   b7VKyPKSMgFYMSSOq6zmWnhgaSNGWohqQmPO6YsCqHCa1viGK/pdZ1MdN
   oS/zF945vZ4euOamj4KJ4vm0JkdxgeF2QF9U74OruhOQCwW8NwVhTLwWa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="384239727"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="384239727"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 05:01:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="1005635705"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="1005635705"
Received: from qiangfu1-mobl1.ccr.corp.intel.com (HELO [10.254.212.47]) ([10.254.212.47])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 05:01:27 -0700
Message-ID: <b53672fe-cad4-4aa7-94ef-59895892b75a@linux.intel.com>
Date:   Tue, 24 Oct 2023 20:01:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc:     baolu.lu@linux.intel.com, jacob.jun.pan@linux.intel.com,
        kevin.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu/vt-d: Adopt new helper for looking up pci
 device
Content-Language: en-US
To:     Huang Jiaqing <jiaqing.huang@intel.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev
References: <20231024084124.11155-1-jiaqing.huang@intel.com>
 <20231024084124.11155-2-jiaqing.huang@intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231024084124.11155-2-jiaqing.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/24 16:41, Huang Jiaqing wrote:
> Adopt the new iopf_queue_find_pdev func() to look up PCI device
> for better efficiency and avoid the CPU stuck issue with parallel
> heavy dsa_test.
> 
> Signed-off-by: Huang Jiaqing <jiaqing.huang@intel.com>
> ---
>   drivers/iommu/intel/svm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
> index 659de9c16024..0f1018b76557 100644
> --- a/drivers/iommu/intel/svm.c
> +++ b/drivers/iommu/intel/svm.c
> @@ -672,7 +672,7 @@ static irqreturn_t prq_event_thread(int irq, void *d)
>   		if (unlikely(req->lpig && !req->rd_req && !req->wr_req))
>   			goto prq_advance;
>   
> -		pdev = pci_get_domain_bus_and_slot(iommu->segment,
> +		pdev = iopf_queue_find_pdev(iommu->iopf_queue,
>   						   PCI_BUS_NUM(req->rid),
>   						   req->rid & 0xff);

Minor: align the new line with the left parenthesis.

>   		/*
> @@ -688,7 +688,6 @@ static irqreturn_t prq_event_thread(int irq, void *d)
>   			trace_prq_report(iommu, &pdev->dev, req->qw_0, req->qw_1,
>   					 req->priv_data[0], req->priv_data[1],
>   					 iommu->prq_seq_number++);
> -		pci_dev_put(pdev);
>   prq_advance:
>   		head = (head + sizeof(*req)) & PRQ_RING_MASK;
>   	}

Best regards,
baolu
