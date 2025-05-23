Return-Path: <kvm+bounces-47572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD47AC2167
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 12:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 537DC3B07E8
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56777229B15;
	Fri, 23 May 2025 10:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BTpXHgaD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED3A2288EA;
	Fri, 23 May 2025 10:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747997214; cv=none; b=e/6Tv25JFDv1zLEUTMTkdtTnF3qr+kC0S7ZWrUOM85bIpkbGuABvYXONIs5eLsCiDGOB7nLnpJymbCtmT+l6H8d4hxN0qp5c1q+W9uC3UsWTZBgLLAns3lWmISEtK5RrAzFedRnflqUBkZDD568tDBwFJJDzewEKOBzdkJrRuho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747997214; c=relaxed/simple;
	bh=AdXniMvjoHtes+rn5Tzs8Hl3aYCHjm1S8O3aNvL0dbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lczQFyzOX2El99Fdivv8/Nu1N9Ig1s8gIVWNuwGKA/cN0RihnOdZTKXT8TR8c2rqEx2mDhfj6ypsXa6PB7zXuBtlPmv8s4NE/3NzX+FuruldIh/i52rF97bRUIFdMk3imfSuJ2RLiw4Nj9xstlWICstm6wU+gMmJTUjgr5vTiXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BTpXHgaD; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747997213; x=1779533213;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AdXniMvjoHtes+rn5Tzs8Hl3aYCHjm1S8O3aNvL0dbk=;
  b=BTpXHgaDuh4kpGFeITUkH/NdeRp9RK3q1xU7tc5caqb3/rNu/5mpm7/C
   4xDOuya8orcYGxt1tb+R9+ASbg51HJ4yJYOd1czKpmyb1B+xWqIfRfm4M
   BQcAPzK1DyZwq6zhWw27BJZ85qLIlYAJ932ZO8FOS28X4XLFepLxyTWDp
   iooYVI8OGh7246xE6jHf+hR8pR/VfgsPOXCQ58vpvMhm4AV6s88GqG//E
   tCUngMygtnr5Q5IXF4uUeRogAuAJjUO4R8XW2aTT+asU7bG6FDzRXZzAr
   ujHJMxXtlHD8af9ixdfp8bPuPMFqGrN4sXyVh8Lk1tMjsYzT1p4fTdiI6
   A==;
X-CSE-ConnectionGUID: +qFvdTbjQOu4Jn141rZ2Ww==
X-CSE-MsgGUID: zMcMKAIfR1iynoRWiJDuwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50045467"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="50045467"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 03:46:52 -0700
X-CSE-ConnectionGUID: jNhVUHS2SZaCOyJL+ucXqw==
X-CSE-MsgGUID: 9yGc6FaySXKusBfvhC+QVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="142131768"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa009.fm.intel.com with ESMTP; 23 May 2025 03:46:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 8736B1F6; Fri, 23 May 2025 13:46:47 +0300 (EEST)
Date: Fri, 23 May 2025 13:46:47 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, yan.y.zhao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <wn2enmsk5aqxl452aleri535kgqhkxp2rqzgd2dxolkbjlfsyk@dyqan5zirrxe>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <aCQpUQx5jNQxPBez@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCQpUQx5jNQxPBez@intel.com>

On Wed, May 14, 2025 at 01:25:37PM +0800, Chao Gao wrote:
> >+static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> >+			struct list_head *pamt_pages)
> >+{
> >+	u64 err;
> >+
> >+	hpa = ALIGN_DOWN(hpa, SZ_2M);
> 
> Nit: it is better to use SZ_2M or PMD_SIZE consistently.
> 
> e.g., patch 2 uses PMD_SIZE:
>  
> +atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
> +{
> +	return &pamt_refcounts[hpa / PMD_SIZE];
> +}
> +EXPORT_SYMBOL_GPL(tdx_get_pamt_refcount);
> 
> >+
> >+	spin_lock(&pamt_lock);
> >+
> >+	/* Lost race to other tdx_pamt_add() */
> >+	if (atomic_read(pamt_refcount) != 0) {
> >+		atomic_inc(pamt_refcount);
> >+		spin_unlock(&pamt_lock);
> >+		tdx_free_pamt_pages(pamt_pages);
> >+		return 0;
> >+	}
> >+
> >+	err = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pages);
> >+
> >+	if (err)
> >+		tdx_free_pamt_pages(pamt_pages);
> >+
> 
> >+	/*
> >+	 * tdx_hpa_range_not_free() is true if current task won race
> >+	 * against tdx_pamt_put().
> >+	 */
> >+	if (err && !tdx_hpa_range_not_free(err)) {
> >+		spin_unlock(&pamt_lock);
> >+		pr_tdx_error(TDH_PHYMEM_PAMT_ADD, err);
> >+		return -EIO;
> >+	}
> 
> IIUC, this chunk is needed because tdx_pamt_put() decreases the refcount
> without holding the pamt_lock. Why not move that decrease inside the lock?
> 
> And I suggest that all accesses to the pamt_refcount should be performed with
> the pamt_lock held. This can make the code much clearer. It's similar to how
> kvm_usage_count is managed, where transitions from 0 to 1 or 1 to 0 require
> extra work, but other cases simply increases or decreases the refcount.

Vast majority of cases will take fast path which requires single atomic
operation. We can move it under lock but it would double number of
atomics. I don't see a strong reason to do this.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

