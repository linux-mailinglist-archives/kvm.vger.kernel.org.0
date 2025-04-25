Return-Path: <kvm+bounces-44255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E79F0A9BFAF
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0758466419
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A0622E41D;
	Fri, 25 Apr 2025 07:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KNphlBOb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E67134A8;
	Fri, 25 Apr 2025 07:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745565922; cv=none; b=AL+c19oBFW6LTbZidwdc3uCOiOrCGNnp8mS161767MAk/8O6ATBWTBHnIj0Avai8lY2MRb/ZHGLcB4bMxwKWMj5AZ0SZTbREEi/Wy97fYzQMkiaDWYv3noUJORym8UGPN5+MrVEWFElMeLwW2pTPVmnZa9LggqSL1UyDTyzc/F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745565922; c=relaxed/simple;
	bh=OSzvSNriURJD0afIhu4/ueRDsc2WgjRVHGzjYaUrp2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dPGi/t5rQIl5/4PgzEjz5bYW61Jf2gd/6HlpLhTdAUlbZUw3e2DoiXcVUxzADxflaGZEjxPqCYXiFaosYPPQjlD6LzHagRoXRJ2VgPHpBRRXy7c2baAifBZkzzjyJ8SliTUuoiqw2n54LC+mUrVkmCc50nY+FkAiFI5MSt6Oz9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KNphlBOb; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745565921; x=1777101921;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OSzvSNriURJD0afIhu4/ueRDsc2WgjRVHGzjYaUrp2o=;
  b=KNphlBObda0qxuQjqt5gSUiSMoHsFGsoZCxYhU2TNtr2a9y9jbWYSfoO
   QnDqreoM0/avXlAh0PmWULZdpMBqdkKgm21BtHzP0OSwpMrncTOEymRiL
   hEvB8DNXaqf+9hrta2bOLSC+JfXt8jpGtZBt8q4FmxoKMk+OoRGzyrIu6
   BX0oAmxoDuF2YCZFK4xv9ZeC3i/TQ5/WjTnUAl45cqLZQ/zmAAkgIHwbz
   lRPCp7cMaIcvqpwcO0I4vARBV1pSLveOT4pbR+3pOXEk9JUsPv1xs5GPL
   EGIgCMrrIO7tCD4yJN2Yb48y6Y9X54KV4G0Vu+kVRGA/2B2X59/fCGVmR
   A==;
X-CSE-ConnectionGUID: uhnvy5wvQGOpjyT+ANiX1w==
X-CSE-MsgGUID: 48NzfkMaTsKYjN4IUteThQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="57420590"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="57420590"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:25:20 -0700
X-CSE-ConnectionGUID: 4EgUmxgkTJusLEPeGPuzVQ==
X-CSE-MsgGUID: bjkkdP/lQG6xE877BZKp1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="132757664"
Received: from yijiemei-mobl.ccr.corp.intel.com (HELO [10.238.2.108]) ([10.238.2.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:25:14 -0700
Message-ID: <55990bb0-9fbe-4b38-95db-bd257914b157@linux.intel.com>
Date: Fri, 25 Apr 2025 15:25:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030445.32704-1-yan.y.zhao@intel.com>
 <8e15c41e-730f-493e-9628-99046af50c1e@linux.intel.com>
 <aAs3I2GW8hBR0G5N@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aAs3I2GW8hBR0G5N@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/25/2025 3:17 PM, Yan Zhao wrote:
> On Fri, Apr 25, 2025 at 03:12:32PM +0800, Binbin Wu wrote:
>>
>> On 4/24/2025 11:04 AM, Yan Zhao wrote:
>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>
>>> Add a wrapper tdh_mem_page_demote() to invoke SEAMCALL TDH_MEM_PAGE_DEMOTE
>>> to demote a huge leaf entry to a non-leaf entry in S-EPT. Currently, the
>>> TDX module only supports demotion of a 2M huge leaf entry. After a
>>> successful demotion, the old 2M huge leaf entry in S-EPT is replaced with a
>>> non-leaf entry, linking to the newly-added page table page. The newly
>>> linked page table page then contains 512 leaf entries, pointing to the 2M
>> 2M or 4K?
> The 512 leaf entries point to 2M guest private pages together,
If this, it should be 2M range, since it's not a huge page after demotion.
Also, the plural "pages" is confusing.

>   each pointing to
> 4K.
>
>>> guest private pages.


