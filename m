Return-Path: <kvm+bounces-69740-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHS1E9DdfGl1PAIAu9opvQ
	(envelope-from <kvm+bounces-69740-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 17:35:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EC95DBC8FB
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 17:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 79ACF3031ACE
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 16:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7C934F25C;
	Fri, 30 Jan 2026 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jGmybhuY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED8D33A9E0;
	Fri, 30 Jan 2026 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769790914; cv=none; b=hWa93WLOybyVTJh8LS2GByzDsbASFZU8CKZ9llW1hhQ1UW/M5Pm8JPuUZ0b4A7ogYx7DjtISueIn2ucOhCwy/MxTpOChqt38UNfWCLhRTDlef48V1liQ6aSVbmdQruBg87c21wOyvLxJhuaemBDDSgfbedgc4a+joAq/JyO/KVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769790914; c=relaxed/simple;
	bh=mrAJptSB9JCiQxBe1yemLalZlD1MxMTQO0epbrNexOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BJOdVySmRd/+u1H5Y9AoBIKporjGUqvtuXfyZLWGix/w0Lp/oGAnYv1qT9QUt/JyhukpK+T0+MC/0BEgoQhen22P4JvUbXa3yL6+s+tW2CkHU0toGydlPO2Mq8FSm4XiKnBPZpUHqdElOiDSOW9bgy8QKThtclTZfGyUeW64xF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jGmybhuY; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769790914; x=1801326914;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mrAJptSB9JCiQxBe1yemLalZlD1MxMTQO0epbrNexOg=;
  b=jGmybhuYK33k3Nc/D+FECtadfG/T5Cqq5bCZB87w1/FTmPqiPpTMcZ4f
   45NWTgG2DdJHDKFI0FtmGwpJDseFvjrZH0frtFwVts6vFOvsSLnecKnk4
   C76rChatfPOEqMEluzlZ2YRN3sDfEHmfLpFPQyGwwOriDLNvugmCtAekf
   b4NfWhNkEKI9CTScNw66mhuhAOrpmmw3TLUZzlJB4drfZJ8zSO/o+8ZkZ
   +Q+hr+LkhL3eQroPdRVaDWXPh0dMEKRcdh2hzZSCZJSFcJwan6UQ8J4Qw
   AEVX/upcjjxSju9jIxPo6uPdPM5IU0qJ3cIk+HMPJV0b/NAwa+FNwubZT
   A==;
X-CSE-ConnectionGUID: mCr8ghMRTcaXa6HLIOhvkg==
X-CSE-MsgGUID: DGJgPj8DTGa7ASJREQVVlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="74666690"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="74666690"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 08:35:13 -0800
X-CSE-ConnectionGUID: ISFOB53aSryXiS3FBmmp2w==
X-CSE-MsgGUID: aoXY/OmoQbeovt7xPcttNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="213790102"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.110.58]) ([10.125.110.58])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 08:35:11 -0800
Message-ID: <1b1a2fe7-d225-414c-9055-8ad06938a0bf@intel.com>
Date: Fri, 30 Jan 2026 08:35:09 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/26] x86/virt/seamldr: Retrieve P-SEAMLDR information
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Chao Gao <chao.gao@intel.com>, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 reinette.chatre@intel.com, ira.weiny@intel.com, kai.huang@intel.com,
 dan.j.williams@intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 Farrah Chen <farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-9-chao.gao@intel.com>
 <b2e2fd5e-8aff-4eda-a648-9ae9f8234d25@intel.com>
 <aXwtILdwb/KMX9uH@yilunxu-OptiPlex-7050>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzUVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT7CwXgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lczsFNBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABwsFfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
In-Reply-To: <aXwtILdwb/KMX9uH@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_FROM(0.00)[bounces-69740-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EC95DBC8FB
X-Rspamd-Action: no action

On 1/29/26 20:01, Xu Yilun wrote:
>> I'd also prefer a
>>
>> 	BUILD_BUG_ON(sizeof(struct seamldr_info) != 2048);
>                                                     ^
> BUILD_BUG_ON(sizeof(struct seamldr_info) != 256);   is it?
Whatever the documentation says. I might have been looking at the
seamldr_seaminfo.

>> just as a sanity check. It doesn't cost anything and it makes sure that
>> as you muck around with reserved fields and padding that there's at
>> least one check making sure it's OK.
> 
> And I recently received a comments that "never __packed for naturally
> aligned structures cause it leads to bad generated code and hurts
> performance", but I really want to highlight nearby it is for a
> formatted binary blob, so:
> 
>   struct seamldr_info {
> 	u32     version;
> 	u32     attributes;
> 	u32     vendor_id;
> 	u32     build_date;
> 	u16     build_num;
> 	u16     minor_version;
> 	u16     major_version;
> 	u16     update_version;
> 	u8      reserved0[4];
> 	u32     num_remaining_updates;
> 	u8      reserved1[224];
>   };   //delete __packed here
> 
>  static_assert(sizeof(struct seamldr_info) == 256);
> 
> Is it better?

I'm pretty sure __packed is used all over the place.

I'd be shocked if access to a __packed structure generated different
code than a non-packed one for the same layout. But it wouldn't be the
first time I was shocked by a compiler.

I think you might be confusing the fact that access to unaligned data
can really stink on some architectures. The code generation for *that*
can be garbage. But not on x86 really and not for data that's already
naturally aligned.

Plus, *this* data structure is far, far from being performance sensitive
anyway. So it doubly or triply doesn't matter here.

If nothing else, __packed is a good indicator that WYSIWYG for structure
layout because it's an ABI. I honestly don't see a lot of downsides.

