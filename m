Return-Path: <kvm+bounces-10737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A93A086F594
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 15:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48D4B1F22E6E
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 14:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E1767A15;
	Sun,  3 Mar 2024 14:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HAVjpDeU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB3D2EB09;
	Sun,  3 Mar 2024 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709477148; cv=none; b=cb3BQ8La/+s0Ofncp8Zhu13kqKxdzF/V4oFDyjs4CgNvjTbvlQmWhA1ZdT4I9wKJ4gxGtAV6T6ga8Oh6dmwT8QwbvSWe8nGNBYakfp+I80L7uTZi/zr2MDCdZywLIhG1X7SpM/pgqk76v1Ei7Fw7+t2bIUTsyXzQPpvzDqf15p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709477148; c=relaxed/simple;
	bh=Lla/Lbk/BFpYbCgKYKgOofS/ieuIKnepxJxl1QWSEv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTopyj5Cy9DdDfW7cBJtp8tUy/6wH7iRtkoGI08xnkzfmdQ9U5NH4D30CTEW9tncN68goiQVjoGVTpKiEg32AZJiwCcsV8HyI1obbOybr5NUO45e1la92hg9/MFtPEQe5aURf/RDHgnaVFRbWrE/RTYxXaOB9Bd715EZAlsCm6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HAVjpDeU; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709477145; x=1741013145;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lla/Lbk/BFpYbCgKYKgOofS/ieuIKnepxJxl1QWSEv8=;
  b=HAVjpDeU3bv2dmKb+uwqy2VPjtDemc/0p/lYwRG3Rxh4oG2lYWQttHHo
   DwLdcBNWmSX/cEvzp7cxRDRrQt1UhmDBqz0ulC5V2wUXYJ+pE+iOw5sB+
   NCy3yZRSzfiQmvSMbL6R7a2vz6BqOIHU2n7/aPyUiL6exsj8RPGU9b2m4
   KpaWov40rBrS0LcecA3YI5ab0gFarrHTXXzQ93lE1HGM+Lc8b1JDaU+DC
   usoUSvQw0WosEaPzkl7CEUFISAds+u6rSKsWDwoKdXtoU/steg7gsh0Al
   KehHZz5ACfK1stcnOhYM+6D4ngsQpejc+q+3S1uMKufXPdSuGFsUE/gjR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11001"; a="14679406"
X-IronPort-AV: E=Sophos;i="6.06,201,1705392000"; 
   d="scan'208";a="14679406"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 06:45:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,201,1705392000"; 
   d="scan'208";a="13222029"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa005.fm.intel.com with ESMTP; 03 Mar 2024 06:45:42 -0800
Date: Sun, 3 Mar 2024 22:41:32 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: Re: [PATCH 16/21] KVM: guest_memfd: pass error up from
 filemap_grab_folio
Message-ID: <ZeSMHIEmnzUVUplr@yilunxu-OptiPlex-7050>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-17-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227232100.478238-17-pbonzini@redhat.com>

On Tue, Feb 27, 2024 at 06:20:55PM -0500, Paolo Bonzini wrote:
> Some SNP ioctls will require the page not to be in the pagecache, and as such they
> will want to return EEXIST to userspace.  Start by passing the error up from
> filemap_grab_folio.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/guest_memfd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 0f4e0cf4f158..de0d5a5c210c 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -20,7 +20,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  	/* TODO: Support huge pages. */
>  	folio = filemap_grab_folio(inode->i_mapping, index);
>  	if (IS_ERR_OR_NULL(folio))
> -		return NULL;
> +		return folio;

I think it impacts kvm_gmem_get_pfn()

{
	...

	folio = kvm_gmem_get_folio(file_inode(file), index);
	if (!folio) {
		r = -ENOMEM;
		goto out_fput;
	}

	...
}

Thanks,
Yilun

>  
>  	/*
>  	 * Use the up-to-date flag to track whether or not the memory has been
> @@ -146,8 +146,8 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>  		}
>  
>  		folio = kvm_gmem_get_folio(inode, index);
> -		if (!folio) {
> -			r = -ENOMEM;
> +		if (IS_ERR_OR_NULL(folio)) {
> +			r = folio ? PTR_ERR(folio) : -ENOMEM;
>  			break;
>  		}
>  
> -- 
> 2.39.0
> 
> 
> 

