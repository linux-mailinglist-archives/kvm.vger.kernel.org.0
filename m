Return-Path: <kvm+bounces-33387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A699EA8C6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 07:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DF701888A10
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 06:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3232122CBCC;
	Tue, 10 Dec 2024 06:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RY2rDCkn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2F122616F;
	Tue, 10 Dec 2024 06:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733812008; cv=none; b=qR309TGjZXGtv5QyLZY6nPk3OJIKnU+bZdARpoieVQ4OyLKKevgBydVPn5aN3HSu0jt4xzV1BMqqURLZEMPvfJ7tj5+GvGCldP/Qq4mYG2WDcbjEbmTLlCma0qcKyNncPcv2/HVNi1bZZHHUqlf/wGzdgyvcknR7Q3bHWjiSYO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733812008; c=relaxed/simple;
	bh=3m6Wb9gSs1tZJatfSkdFDNxKn7SG6+JznvNzNtrj1mQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5sPJFoh1S06D1kYiDM2AFWQ2usJsC3kgImpVhKfQ6KYi1axzenqma11KpyaSHIjksT4p3VyqC1OWxDdeC1MyXAsNeKgZzTu168XIcGCUwdiAAzeKjdbq0f+iyzA9gC0rs+Xc/4dc+PrA+LQGODZrHrSUDqvHqtV+hc8riLqwNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RY2rDCkn; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733812007; x=1765348007;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3m6Wb9gSs1tZJatfSkdFDNxKn7SG6+JznvNzNtrj1mQ=;
  b=RY2rDCknzyLk4FJOPvhWuAz/6jegiG6LCyuTcrTFAsLptTSeD2gHrTx1
   jwDxkDjuw95RFEPK6mFLF+hMlTboWE65ltmj2Tarud7sZkS24Wn8Yf20W
   k5On2Q6JjJNAa97VdKUeDT3yr9UcneqTsN2OzuQ9Dzi18qu1n9IH8AmYG
   AX1hg7rhMOnlisBG0p8LMs7U10nJ+R8mwbo9fk1rmC6hdQjl1EguG52mj
   9Ly8XVXSxgitEv0RKLVNAnZtft/suzplUoycPYh8N0CY6wplhatZR70sq
   n3KqJfponyGUc3WzyWxsN/4UGG8yuHZVfb1oVQgjhjJ3UvYyyFTlm94Dw
   w==;
X-CSE-ConnectionGUID: gMF4n4nTSZ2gGwKgI2oSwQ==
X-CSE-MsgGUID: DqugDdrxRceNLgXskukIeg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="45152489"
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="45152489"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 22:26:46 -0800
X-CSE-ConnectionGUID: R/pcuTnvTaifMsxrC608rQ==
X-CSE-MsgGUID: Ce7BdnX7QJO6a3Y89pSQ+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="132699639"
Received: from mev-dev.igk.intel.com ([10.237.112.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 22:26:42 -0800
Date: Tue, 10 Dec 2024 07:23:40 +0100
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
Subject: Re: [PATCH v2 0/2] MANA: Fix few memory leaks in mana_gd_setup_irqs
Message-ID: <Z1febCUrMwU2j+GW@mev-dev.igk.intel.com>
References: <20241209175751.287738-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209175751.287738-1-mlevitsk@redhat.com>

On Mon, Dec 09, 2024 at 12:57:49PM -0500, Maxim Levitsky wrote:
> Fix 2 minor memory leaks in the mana driver,
> introduced by commit
> 
> 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> 
> Best regards,
> 	Maxim Levitsky
> 

For next time please add a changleog, like here for example [1].
It is helpfull for the reviewers.

[1] https://lore.kernel.org/netdev/20241204140821.1858263-1-saikrishnag@marvell.com/T/#m5fc2fa8b1d2bd1b47cf7ccacd4031d1aa1aa8c2c

Thanks

> Maxim Levitsky (2):
>   net: mana: Fix memory leak in mana_gd_setup_irqs
>   net: mana: Fix irq_contexts memory leak in mana_gd_setup_irqs
> 
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> -- 
> 2.26.3
> 
> 

