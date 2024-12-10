Return-Path: <kvm+bounces-33385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FD89EA8B1
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 07:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45549285726
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 06:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83BB22CBD2;
	Tue, 10 Dec 2024 06:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NjPb8dKq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DA6226182;
	Tue, 10 Dec 2024 06:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811668; cv=none; b=HtXVxSSN53czQOiD+eLsj9t8Rk67F7K4f8srz34Cnxxfu+usVXc4hqCLIhUDgY7OCDv+sux82240HVZ5wecy0CVPkFa1eWhtmU1o9cHqSgSaR0HrFLOARvEyP9bQO0Mv/bd5YutCLxyfPXK/hxuPG7FfVD27K5xHGAzrZu9cvao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811668; c=relaxed/simple;
	bh=gvyYavweTul/uYFkIKPLsimVQMnn3wsNlvpu7zAc+X8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4QjnbvTwtZq13UuqrNeIdGw9djqEy5YDsJLYLE6hLjmVl85Hrvj81SaOU4M/FiegzhBjO4QvZZTP/t7KSKQnU15nfOzkim1/NWpLMevZ4n7QFjeI96zS5Uj1Vp+Hj6bf5lrqSIZMx1bRjujfq+TYcXmNRNpHj6yg+0T7E9CLuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NjPb8dKq; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733811662; x=1765347662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gvyYavweTul/uYFkIKPLsimVQMnn3wsNlvpu7zAc+X8=;
  b=NjPb8dKqqtjgTUZO2q5EgTbdSjrYdHyvxtiIL+9sAv9F9OQd4nNqhp9J
   qpl5ObUI12/sJn0PoafU/ZRqojN8lb9ODILUXDGZSbCzK6UZTGlT5b0Te
   6vjOS6325Yhrz8xhJOMNSUTE8S0NLqvADLFA5zONJ+j7hWRGUOrGfgZr5
   JW6zBld6W0L5h9u62VddMsuHKxiCCj4JQsj8ulBE6okxyZaVxKEQpJEcM
   ra6n/r2E27PJKTkCtdVCNVvC+k3lKPid/LZmI+tkBnJbW3dmbp6MVm5tf
   wbaVcVFCovWjBvxEQLdzb8adNj7hwl9lFe9DQi2s7iuv5tz3diZ40K/rk
   A==;
X-CSE-ConnectionGUID: FUephcQGTn6lxRk9NhLgTw==
X-CSE-MsgGUID: tVqsU+omTR6DAPDEy/uoXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="38069483"
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="38069483"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 22:21:01 -0800
X-CSE-ConnectionGUID: M6XQJAbXSGat2VMh9TrghA==
X-CSE-MsgGUID: t+rNslufT9W+fe/21hLc7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="95008679"
Received: from mev-dev.igk.intel.com ([10.237.112.144])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 22:20:56 -0800
Date: Tue, 10 Dec 2024 07:17:55 +0100
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
Message-ID: <Z1fdE6ftFMtVFeW5@mev-dev.igk.intel.com>
References: <20241209175751.287738-1-mlevitsk@redhat.com>
 <20241209175751.287738-2-mlevitsk@redhat.com>
 <Z1fcIa7n+hI+v2Nq@mev-dev.igk.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fcIa7n+hI+v2Nq@mev-dev.igk.intel.com>

On Tue, Dec 10, 2024 at 07:13:53AM +0100, Michal Swiatkowski wrote:
> On Mon, Dec 09, 2024 at 12:57:50PM -0500, Maxim Levitsky wrote:
> > Commit 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> > added memory allocation in mana_gd_setup_irqs of 'irqs' but the code
> > doesn't free this temporary array in the success path.
> > 
> > This was caught by kmemleak.
> > 
> > Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > index e97af7ac2bb2..aba188f9f10f 100644
> > --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > @@ -1375,6 +1375,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
> >  	gc->max_num_msix = nvec;
> >  	gc->num_msix_usable = nvec;
> >  	cpus_read_unlock();
> > +	kfree(irqs);
> 
> Ther is still memleak in case of jumping to free_irq_vector when
> gc->irq_contexts allocation is failing.
> 

Ignore that, just took a look at second patch.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

> Thanks
> >  	return 0;
> >  
> >  free_irq:
> > -- 
> > 2.26.3

