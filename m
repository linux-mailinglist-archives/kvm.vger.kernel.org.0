Return-Path: <kvm+bounces-50917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08657AEA9B2
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BD754A3A26
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E86826E14D;
	Thu, 26 Jun 2025 22:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="in2RGG48"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B012F1FC9;
	Thu, 26 Jun 2025 22:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750977194; cv=none; b=JCLjgWkVqiTIEMVVdtmu7QRcc/tKqeCcTdZgXlyahZbRn0l8pwtc4J8Qjxcng7bjlxNARFRPyp/119BsD5j/xwMnNk27odyWQSkTV2CpfH8uzbYftF7yFlwuTVODDVkFKKeMkMJWoJBn6uCnEU47em7fZZ7kdoeEgXF9c4Bn/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750977194; c=relaxed/simple;
	bh=P3BYywIXEQsOhVlcz6dgYcI3443NAtbrw9VtNiSE+9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uy2J6Ft+D75/cepNgzYIz62vKGW8BpmfcXJp61yFo9uqtC6SN/uzCDBOZ2LazYiPt3z6oyujGSC8jDcgEZZ6tuEWwE//Wtt0RsFpEDU+YCPJJKkouYXpfo0f550+50fn0g4ZxIVXq9q4JaQ6Sx3vN69wlI/bMcZplBvoCt+8IRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=in2RGG48; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750977193; x=1782513193;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P3BYywIXEQsOhVlcz6dgYcI3443NAtbrw9VtNiSE+9w=;
  b=in2RGG48UotQBJBhq9cpIFk4UiABjLNdfHlFsxDqVp7bsBX/BKS613GF
   xcAQYApXOpoS2/h2jJm42boEF6pnwmMi+Hk6CWDKyEAv1hFDlWzNTHm8L
   e1/kZU+mwf92xd8DGHHciPQHE99E+F86NhPA+QU2DjQmXcdFLLuvgw++/
   0ygQQz620NDs4pmPcV7yVO0pZYWYf+/9V/MG9Cam7z3sdQ6RmcZ9gdLPe
   YhYBEAUGuGWP70zEV8ARYiFkJFqm7bvTImNO/njZOSu4RzRS3HBbr8w4U
   7HeyfNki2GojUhkVtHQJCzCAtK9BFSEkvyMpGmdlp9UYhcp+3Oib/BnHu
   A==;
X-CSE-ConnectionGUID: FxbJfzuQQxOcLqTBGrjqlQ==
X-CSE-MsgGUID: T/FQdD7SQnyXm4mQYF1csw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="52519542"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="52519542"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 15:33:12 -0700
X-CSE-ConnectionGUID: 2YrduJMoTOm3og1aSVyK4A==
X-CSE-MsgGUID: PKzka5DvQv2VTCcjFUDAEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="157202618"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.109.42]) ([10.125.109.42])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 15:33:12 -0700
Message-ID: <b439abd6-9fd9-4f51-82e2-c8b1304e7cca@intel.com>
Date: Thu, 26 Jun 2025 15:33:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
To: "Huang, Kai" <kai.huang@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "mingo@redhat.com" <mingo@redhat.com>, "seanjc@google.com"
 <seanjc@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "Chatre, Reinette"
 <reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
 <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
 "x86@kernel.org" <x86@kernel.org>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-3-adrian.hunter@intel.com>
 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
 <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
 <c315604761ad760fc29bebdb007fac239a1b45f9.camel@intel.com>
 <91df7051-2405-4609-9e86-2bbc02829644@intel.com>
 <8c24d9b9c888eed972e8ee75fa9d31cc7fd72a73.camel@intel.com>
 <DS7PR11MB6077ED08B85A000014BDAE00FC7AA@DS7PR11MB6077.namprd11.prod.outlook.com>
 <f51e62543aa765da3b4f4ed19aa13340881fbc89.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <f51e62543aa765da3b4f4ed19aa13340881fbc89.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/26/25 15:20, Huang, Kai wrote:
> But IMHO we may should just have a simple policy that when a page is marked
> as poisoned, it should never be touched again.  It's only one page anyway
> (for one TD) so losing that doesn't seem bad to me.  If we want to clear the
> poisoned page, then perhaps we should mark that page to be not-poisoned
> again.

The simplest policy is to do nothing.

The kernel only has 29 places that check PageHWPoison(). I'd guess that
roughly half of those are the memory-failure.c infrastructure and
bare-minimum code to handle poison, like not allowing pages to go back
into the allocator.

There are something like 5,000 lines of code in the kernel that deal
with a literal 'struct page'. 29 checks for ~5,000 sites is pretty
minuscule. We obviously don't have a policy that every place that uses
'struct page' needs to check for poison. We also don't even have a
policy where writes to or reads from a page check for poison.

Why is this TDX code so special that PageHWPoison() needs to be checked.
For instance:

$ grep -r PageHWPoison arch/x86/
arch/x86/kernel/cpu/mce/core.c:	SetPageHWPoison(p);
arch/x86/kernel/cpu/mce/core.c:	SetPageHWPoison(p);

In other words, this would be the *ONLY* arch/x86 site. Why?

