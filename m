Return-Path: <kvm+bounces-63543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 67246C69853
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 14:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id 0759528CFF
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 13:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BCD12DE200;
	Tue, 18 Nov 2025 13:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WFJtfK0c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFD9275AE4;
	Tue, 18 Nov 2025 13:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763470967; cv=none; b=gGNEfiXnhqdjwuRvdeTDlX8chZa04xRb5eYeRwXvM8BXLw3M39L2MHSCxEIl8v60SH9NifNFi562sjjpniDN9b7wLLg+u+xv1sqaVMk4te0aXXA07nhylGzDEj7sunlWvE/L+9UHwzU0TBgk0JT+GKPY8De4yyAfDryUs0xumUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763470967; c=relaxed/simple;
	bh=l8Q8mNGhNmk90OG2libW1IjxLLKiGopo3PW17f7lBv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpCctmhK2vmOymBS7NqjGREQqbRFq7O3HMkP8SefjxwFhho4OcIAiu6nsTzQ2zxIn3K3yHMBKOON8K3roIfiIjXfYqA1cpVMOfQ15VgLRf2vRG4WXXlrqzeytuTCHqCqgoq8dIbWnZNCHkon3OuCxzBGCbHI14Y3mOLQ7RWCNQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WFJtfK0c; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763470965; x=1795006965;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l8Q8mNGhNmk90OG2libW1IjxLLKiGopo3PW17f7lBv4=;
  b=WFJtfK0cF5bra8r+9XSjBkDJn9ove1z85qDVj5v6HR6vjHFxexnQAv6M
   1JaI9I8IzPKj8L1FmHOBxWcp0KXuD+lerSzjjqRJix5+rT6Oac6otUqLs
   /ttXaLCGD0TBSoecrVmJXEcdicRe5Jq3xKlMOzPsTXmmir3K5bFJk5gkV
   T17iR5QJLQlIAEMZscHxNzBl4oE3guTAY1UYIsDWstiUeDdOnGrr3OwgA
   Hqqk1hSRIX+AWJ0t92caTrnnZEdLC/q7oXv1y0B9C22D2kLkaxDVPp1NP
   fhduUAgmE63AIxoxjr9V2HBX13nuGiB1T2js1Va2hWWrORNprlDI/GDJF
   w==;
X-CSE-ConnectionGUID: dfmXAoTfT+GpdW8jycJHjQ==
X-CSE-MsgGUID: 3Fhk+4qGTvy+/LjWJNcBiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="76093101"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="76093101"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 05:02:44 -0800
X-CSE-ConnectionGUID: kbqC98dGShC0fqX/e+8oJQ==
X-CSE-MsgGUID: VnGycLDxQZOHE/3HgxdoIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190553929"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa009.jf.intel.com with ESMTP; 18 Nov 2025 05:02:41 -0800
Date: Tue, 18 Nov 2025 20:47:55 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for
 new TDX Module objects
Message-ID: <aRxq+/zNuBTobD7i@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-7-yilun.xu@linux.intel.com>
 <96d66314-a0f8-4c63-8f0d-1d392882e007@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96d66314-a0f8-4c63-8f0d-1d392882e007@intel.com>

On Mon, Nov 17, 2025 at 08:41:37AM -0800, Dave Hansen wrote:
> On 11/16/25 18:22, Xu Yilun wrote:
> > +	struct page *root __free(__free_page) = alloc_page(GFP_KERNEL |
> > +							   __GFP_ZERO);
> > +	if (!root)
> > +		return NULL;
> 
> Why don't you just kcalloc() this like the rest of them?

It's feasible for this patch, see the code below.

But when I'm trying to address the copy-and-paste concern in Patch #15,
I realize the common part is the allocation of the supporting structures
(struct tdx_page_array *, struct page **, the root page), and the
different part is the allocation of data pages that TDX module requires.
So I don't think I should allocate root page along with the data pages
here.

> 
> Then you won't need "mm: Add __free() support for __free_page()" either,
> right?

mm.. But I still need this scope-based cleanup in later patch:

  [PATCH v1 22/26] coco/tdx-host: Implement SPDM session setup


--------------8<------
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b5ad3818f222..bb62f8639040 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -148,6 +148,7 @@ struct tdx_page_array {
        unsigned int offset;
        unsigned int nents;
        struct page *root;
+       struct page **raw;
 };

 void tdx_page_array_free(struct tdx_page_array *array);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index fd622445d3d6..c41af2260475 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -360,15 +360,16 @@ void tdx_page_array_free(struct tdx_page_array *array)
        if (!array)
                return;

-       __free_page(array->root);
-       tdx_free_pages_bulk(array->nr_pages, array->pages);
-       kfree(array->pages);
+       tdx_free_pages_bulk(array->nr_pages + 1, array->raw);
+       kfree(array->raw);
        kfree(array);
 }
 EXPORT_SYMBOL_GPL(tdx_page_array_free);

 static struct tdx_page_array *tdx_page_array_alloc(unsigned int nr_pages)
 {
+       /* Need an extra root page to hold the page array HPA list */
+       unsigned int nr_pages_alloc = nr_pages + 1;
        int ret;

        if (!nr_pages)
@@ -379,23 +380,19 @@ static struct tdx_page_array *tdx_page_array_alloc(unsigned int nr_pages)
        if (!array)
                return NULL;

-       struct page *root __free(__free_page) = alloc_page(GFP_KERNEL |
-                                                          __GFP_ZERO);
-       if (!root)
-               return NULL;
-
-       struct page **pages __free(kfree) = kcalloc(nr_pages, sizeof(*pages),
-                                                   GFP_KERNEL);
-       if (!pages)
+       struct page **raw __free(kfree) = kcalloc(nr_pages_alloc, sizeof(*raw),
+                                                 GFP_KERNEL);
+       if (!raw)
                return NULL;

-       ret = tdx_alloc_pages_bulk(nr_pages, pages);
+       ret = tdx_alloc_pages_bulk(nr_pages_alloc, raw);
        if (ret)
                return NULL;

+       array->root = raw[0];
+       array->pages = raw + 1;
        array->nr_pages = nr_pages;
-       array->pages = no_free_ptr(pages);
-       array->root = no_free_ptr(root);
+       array->raw = no_free_ptr(raw);

        return no_free_ptr(array);
 }

