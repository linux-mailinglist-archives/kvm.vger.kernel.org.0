Return-Path: <kvm+bounces-33384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBEF59EA8A4
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 07:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B5332824C3
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 06:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFEE622B8D8;
	Tue, 10 Dec 2024 06:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QT//Xhru"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D38B226182;
	Tue, 10 Dec 2024 06:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811430; cv=none; b=e4GWkSmF/OQXjMGT92u+uVSr4UBYzKujzmoZBx4nqSK6ttbtYprt2k3n0udbHZn35YkMF+l9ZHGdxJeBr0poGPFwyTFwfw2kcj0QEKAiN7kTMo32yhjzKSwdMYbnne3xfu6YU3DmqfDriqePeU21QazoPflUb8s4TrJ97gaf+uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811430; c=relaxed/simple;
	bh=rXuQ1U1NC7bVLF2BcTB7d4Y/ETWhTKJK6BvKDWuC1FQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6QQ7CcF9cQQuVztJRIDj/QdcPhM0HfXk0xyqQNXRCnn9i/3BJanzJTpJ9Q0vbke6H6HfdYTFPHj1sCHcl8oPDmyfHBxdxoTsG3UlVjrJHVq7eA0MC5Vla/NnGHjlCdDgkV71ub/uSTf9Bk+F4PycMpM4HvdotyJJmG0+XK/8l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QT//Xhru; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733811429; x=1765347429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rXuQ1U1NC7bVLF2BcTB7d4Y/ETWhTKJK6BvKDWuC1FQ=;
  b=QT//XhruwqNei2/LN4tTpNyaBC/62RZbYwSCoeEpnbnAguA4yCV80TL9
   vVxv0j+9Dr4QHswe278wPEvxuKvOItStbByZDSo0Rdn1F2S+Zhg1enVc+
   9ENyw0EH8lub707A3bDDh4njAt9JDW3NWW7DWsy0a5wyLotN3NaaYkbvr
   8LnZYpJ3A2Um8orsPnskwqdugIfRMgpwgCKtKV+dbh6UrGnPEV7c8BWZ0
   YLTc+kqvip+KIEf81Tld7mOg6F5wCPa8CS4sQnxzuXbGDTC1br3+8Z4Py
   L20DCEGKk8EKw8ICKHaTXgnjCw9qW1ceKbrEfHIs7jROVmjgU2OZHCQ3V
   A==;
X-CSE-ConnectionGUID: Xc9Z8U3ZTWyr7B01hWq5MA==
X-CSE-MsgGUID: Wu1E4WrsRbuip5P5YC7ycw==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="51549772"
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="51549772"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 22:17:08 -0800
X-CSE-ConnectionGUID: FSYz5DUbQKS0MeqUrxuXZg==
X-CSE-MsgGUID: Jq2ngkAuQSK5xsWRxCqkdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="95649257"
Received: from mev-dev.igk.intel.com ([10.237.112.144])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 22:17:04 -0800
Date: Tue, 10 Dec 2024 07:13:53 +0100
From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>, Long Li <longli@microsoft.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH v2 1/2] net: mana: Fix memory leak in mana_gd_setup_irqs
Message-ID: <Z1fcIa7n+hI+v2Nq@mev-dev.igk.intel.com>
References: <20241209175751.287738-1-mlevitsk@redhat.com>
 <20241209175751.287738-2-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209175751.287738-2-mlevitsk@redhat.com>

On Mon, Dec 09, 2024 at 12:57:50PM -0500, Maxim Levitsky wrote:
> Commit 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> added memory allocation in mana_gd_setup_irqs of 'irqs' but the code
> doesn't free this temporary array in the success path.
> 
> This was caught by kmemleak.
> 
> Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index e97af7ac2bb2..aba188f9f10f 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1375,6 +1375,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
>  	gc->max_num_msix = nvec;
>  	gc->num_msix_usable = nvec;
>  	cpus_read_unlock();
> +	kfree(irqs);

Ther is still memleak in case of jumping to free_irq_vector when
gc->irq_contexts allocation is failing.

Thanks
>  	return 0;
>  
>  free_irq:
> -- 
> 2.26.3

