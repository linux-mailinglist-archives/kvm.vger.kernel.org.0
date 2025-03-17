Return-Path: <kvm+bounces-41172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D05A644E3
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9EA83AF877
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCC021B9FC;
	Mon, 17 Mar 2025 08:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Txc4MHT5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F731B042F;
	Mon, 17 Mar 2025 08:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742199237; cv=none; b=pdtCevPGCxCgAHO9x46BEZDLmSUmSg4o9qSMl+zPY9JBtgjY6XgMynaEapXTRYNOxvX2WbxUh6a79gSkLk2kbLRQ3YPVq4pdsgC6ueqAGQGUAYuEJhMryQYHr0qTRbFTtJ6/eaXrF0mVX32cbKMh+uNcqjPuxwNTahfoFt2SSSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742199237; c=relaxed/simple;
	bh=gQf+Lt8p20EGFJVSJ+FVRsAM390Ky3G+/MPAOlYIbkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVDAEtaZkiNHW28ApRkJ75+BszRDorjG/giLiu/qv9HXqP84eI37qyI3X9OIa9a7Q0fJU2TCrILwt38sZ2d/uueryQYdu6bc3oZ690EuguqJvL0LveNOVzWA9+MFlLalU6iNjfIB/e3UVPtlvuMtyZbWcOuyI1ePYpLJlNLC0E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Txc4MHT5; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742199236; x=1773735236;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gQf+Lt8p20EGFJVSJ+FVRsAM390Ky3G+/MPAOlYIbkU=;
  b=Txc4MHT5a46TxFnZEeb0nGqmCkbzHhSHNrXw8LaSgCKyXrqJNyVOkX85
   r2JxGiUizfITmsC0cyTOIirB+hVjpn7YN3EGFiiAe6a1PBxkMTqViTEoN
   GN1R6Qkc97jUIcgAoNFcIcryJaIqDmJm8pYC0pwNxwxekUngVwlviUVnT
   9Gbq2SM0YuoD4eUGYuUmyRewkzjFZsiQUF4GmwnXLl2KjTE9E1e7N3Vxz
   DOyKNv/jslnurcrzVmOmuAmpsmpRBV7+JfIydvNTbdBeh/veuLHss7Khm
   78iH7PbXgXFc0ifjithosoBVGNyQxnxZ8F4fVAtlFxZz5HqyfBsaTXr9D
   A==;
X-CSE-ConnectionGUID: oCeViLjeRJaaoTO0dAwmhQ==
X-CSE-MsgGUID: wTEm/u7fQyCrDiWLqBZwLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="54279184"
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="54279184"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 01:13:54 -0700
X-CSE-ConnectionGUID: KQBmuXvqQcewqb79Od9Plg==
X-CSE-MsgGUID: oWJvVKwRRlqcDHlhQWKHCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="126905363"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa004.jf.intel.com with ESMTP; 17 Mar 2025 01:13:51 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 2FF9D200; Mon, 17 Mar 2025 10:13:50 +0200 (EET)
Date: Mon, 17 Mar 2025 10:13:50 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
Message-ID: <ful5rg4jmtxtpyf4apdgrcp3ohttqvwfdwbcrszf6h3jnlhlr5@pfkl6uvadwhu>
References: <20250313181629.17764-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313181629.17764-1-adrian.hunter@intel.com>

On Thu, Mar 13, 2025 at 08:16:29PM +0200, Adrian Hunter wrote:
> @@ -3221,6 +3241,19 @@ int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  	return PG_LEVEL_4K;
>  }
>  
> +int tdx_gmem_defer_removal(struct kvm *kvm, struct inode *inode)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	if (kvm_tdx->nr_gmem_inodes >= TDX_MAX_GMEM_INODES)
> +		return 0;

We have graceful way to handle this, but should we pr_warn_once() or
something if we ever hit this limit?

Hm. It is also a bit odd that we need to wait until removal to add a link
to guest_memfd inode from struct kvm/kvm_tdx. Can we do it right away in
__kvm_gmem_create()?

Do I read correctly that inode->i_mapping->i_private_list only ever has
single entry of the gmem? Seems wasteful.

Maybe move it to i_private (I don't see flags being used anywhere) and
re-use the list_head to link all inodes of the struct kvm?

No need in the gmem_inodes array.
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

