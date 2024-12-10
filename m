Return-Path: <kvm+bounces-33386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B46979EA8B6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 07:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A1EC16A34F
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 06:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9420122B8D7;
	Tue, 10 Dec 2024 06:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MH5izCcI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B44235967;
	Tue, 10 Dec 2024 06:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811750; cv=none; b=Sw6nhsqVKsPPQLCHmhSpKQFmHiMcZAApHcZ67ZCYUDTCdvZL5T+rjhCnpdcE9XO7Fw9kl5V3phcBCGoDw6NNryGA+fzXExkkLeF3T1lxa1RRnKinHDpjzb9N3h5/7SqSjQGceNHu8ihLopa+vE2NhssQ4k3RQJJ/tWhG69ssFRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811750; c=relaxed/simple;
	bh=C52ca7ldp7tKS2PLEUoErlOoMTwEGvbNIjRSGFP6HHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQWR8reMM7iRUhDc+1oSs9llYcrN9OIrJSgiah1WLXThNn/Pb1BZdjzQfluMRY/dPBc6nmRAbyEzNhBjnKRtdqcO9BI1ioRUemT00opsuhv6yDRao+c0iFP6Wx41b5ico3jMe574k+F6fJjopX6YORGcFdjMylnbuDUgnup0ubE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MH5izCcI; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733811749; x=1765347749;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C52ca7ldp7tKS2PLEUoErlOoMTwEGvbNIjRSGFP6HHs=;
  b=MH5izCcIEZM9KIFLpcPeF91P6BXMYK5M1ePjGHntsSBg79i7+yHK3wVF
   Xd8D7oTf33XlR7obUCCkolxJ5huD4T305ZD/RwVzqj8UBG/yGpwaTk/+f
   E20sAGDs3WwOhuJTY7yTtYQJmtU8bZKA7bW/iXaffRwVOyaXuORilWON4
   nVsaUaSJXKRPnjh6mzLc5cgrYP1Y5g2hLENo1fGmiR/+im1sDTlw1Gq3Q
   gIkzo3UOepdItX0t/jwooDAxUupNVT1gg6L8Sae+FbaHA8awA4MF8KQy/
   j6Aa2vuPDRjsY6sQT9fDX87y076DN7TvgYeicSgHq32JW6fTKjehyJ5nv
   Q==;
X-CSE-ConnectionGUID: Zj7SKRhKQO6VDPmgChJxlg==
X-CSE-MsgGUID: DCfkcEO+Sr6EANO//Z5bOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44814992"
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="44814992"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 22:22:28 -0800
X-CSE-ConnectionGUID: 3D73PjioRbm/NcXI/A9FOA==
X-CSE-MsgGUID: N3i8LgfyTT6Y1ESBEScmKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="95145761"
Received: from mev-dev.igk.intel.com ([10.237.112.144])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 22:22:24 -0800
Date: Tue, 10 Dec 2024 07:19:23 +0100
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
	Yury Norov <yury.norov@gmail.com>,
	Michael Kelley <mhklinux@outlook.com>
Subject: Re: [PATCH v2 2/2] net: mana: Fix irq_contexts memory leak in
 mana_gd_setup_irqs
Message-ID: <Z1fda7FRu+vmkt0S@mev-dev.igk.intel.com>
References: <20241209175751.287738-1-mlevitsk@redhat.com>
 <20241209175751.287738-3-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209175751.287738-3-mlevitsk@redhat.com>

On Mon, Dec 09, 2024 at 12:57:51PM -0500, Maxim Levitsky wrote:
> gc->irq_contexts is not freeded if one of the later operations
> fail.
> 
> Suggested-by: Michael Kelley <mhklinux@outlook.com>
> Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index aba188f9f10f..6297c0869cd6 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1318,7 +1318,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
>  				   GFP_KERNEL);
>  	if (!gc->irq_contexts) {
>  		err = -ENOMEM;
> -		goto free_irq_vector;
> +		goto free_irq_array;
>  	}
>  
>  	for (i = 0; i < nvec; i++) {
> @@ -1388,8 +1388,9 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
>  	}
>  
>  	kfree(gc->irq_contexts);
> -	kfree(irqs);
>  	gc->irq_contexts = NULL;
> +free_irq_array:
> +	kfree(irqs);
>  free_irq_vector:
>  	cpus_read_unlock();
>  	pci_free_irq_vectors(pdev);

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

> -- 
> 2.26.3

