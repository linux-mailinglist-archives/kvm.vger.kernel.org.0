Return-Path: <kvm+bounces-12871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC79988E751
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 812681C22113
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB5613F43F;
	Wed, 27 Mar 2024 13:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="goTD2+CE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CE3130A4A;
	Wed, 27 Mar 2024 13:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711547363; cv=none; b=gaEQ3gaKMX+fnOd/YTvXwGlZydm3w8w6WOmQtaupHk+FHqkcqG0smUAUVlnG2nhbA29aoZSEzBUiFv6coJLs+MrjyJSOzqD6I8x3xnbUzESMR3qiv7xuVGcEJpIiTwEG6m+Ro9ml2gXPrmCamYkwYmjo8nhfeLLD7UM6eBFYV9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711547363; c=relaxed/simple;
	bh=pYA8JEf+ws3scIsO53epWhsFE2v9Q1/iQbrJFPAduuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GYW5xxw/sARKM18IWdXKQY240OgWH/CzTtaFsEgrzsHqnLUomiEUUCe71EXCI2F9Ojm8ZK2W8EkUshBcyKfQ+Zs8icD4FYyyCMcxCB/XXwBIiWbkqdCZMgoKTPCchlLjkspP9SaCPpP+ZNnc7mllSsrvd2F8Fjkc2VM+sBleejA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=goTD2+CE; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711547363; x=1743083363;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pYA8JEf+ws3scIsO53epWhsFE2v9Q1/iQbrJFPAduuM=;
  b=goTD2+CEGBJxr4X7e0KCK6GyEw5LYcXCm4bt6lucrz/Bgh9hW2uXEU+a
   hfqDXBrklRFvMsHuOCDSaqUFCGuF7KVMBa6eyxwpVeS5kyUSYg33ZRzVW
   9LbcQa23EQCRsC6zMHJtoQchj2D6I22mcgo8eZLQhIFFSD/FBDVmo8n8z
   /gFG7oL6ZMLBEocdtT3bV6UPiYpDvkala3Zm4nn5E/MisBGhERfx1r/Nh
   IjtYJkq6hURIFP1WiB5/yD0ldGL9nNu9+LTWQdGyIhhxgllHr7CnEbd/z
   y2/brj29J1toVCtt8aZp14XL+SGaltLSX+SeBh2PGNms9TxenFywGWwHZ
   w==;
X-CSE-ConnectionGUID: tKAKCmS+Sb2VGyysDzGFwA==
X-CSE-MsgGUID: sjBxa8qAS16wuUjpdMwmJQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="10442145"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="10442145"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 06:49:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="21007556"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 06:49:18 -0700
Message-ID: <35090f7e-4f4d-403c-b95e-f09248fc272d@linux.intel.com>
Date: Wed, 27 Mar 2024 21:49:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
 <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>
 <20240314181000.GC1258280@ls.amr.corp.intel.com>
 <bfde1328-2d1c-4b75-970f-69c74f3a74f9@intel.com>
 <ada65e3e977c8cde0044b7fa9de5f918e3b1b638.camel@intel.com>
 <20240315010940.GE1258280@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240315010940.GE1258280@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/15/2024 9:09 AM, Isaku Yamahata wrote:
> Here is the updated one. Renamed dummy -> mirroed.
>
> When KVM resolves the KVM page fault, it walks the page tables.  To reuse
> the existing KVM MMU code and mitigate the heavy cost of directly walking
> the private page table, allocate one more page to copy the mirrored page

Here "copy" is a bit confusing for me.
The mirrored page table is maintained by KVM, not copied from anywhere.

> table for the KVM MMU code to directly walk.  Resolve the KVM page fault
> with the existing code, and do additional operations necessary for the
> private page table.  To distinguish such cases, the existing KVM page table
> is called a shared page table (i.e., not associated with a private page
> table), and the page table with a private page table is called a mirrored
> page table.  The relationship is depicted below.
>
>
>                KVM page fault                     |
>                       |                           |
>                       V                           |
>          -------------+----------                 |
>          |                      |                 |
>          V                      V                 |
>       shared GPA           private GPA            |
>          |                      |                 |
>          V                      V                 |
>      shared PT root      mirrored PT root         |    private PT root
>          |                      |                 |           |
>          V                      V                 |           V
>       shared PT           mirrored PT ----propagate---->  private PT
>          |                      |                 |           |
>          |                      \-----------------+------\    |
>          |                                        |      |    |
>          V                                        |      V    V
>    shared guest page                              |    private guest page
>                                                   |
>                             non-encrypted memory  |    encrypted memory
>                                                   |
> PT: Page table
> Shared PT: visible to KVM, and the CPU uses it for shared mappings.
> Private PT: the CPU uses it, but it is invisible to KVM.  TDX module
>              updates this table to map private guest pages.
> Mirrored PT: It is visible to KVM, but the CPU doesn't use it.  KVM uses it
>               to propagate PT change to the actual private PT.
>


