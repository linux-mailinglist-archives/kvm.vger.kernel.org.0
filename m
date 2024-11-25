Return-Path: <kvm+bounces-32437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B11819D86A6
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFDB816265B
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06501ABEBF;
	Mon, 25 Nov 2024 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWPwklWU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D2218872F;
	Mon, 25 Nov 2024 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732542023; cv=none; b=oZk9sXBBROb+nWjJ39EGdQ2uKNv3wK8bHlE9Zul24vRRNNILJlQ6HFhCKrpf6aLWcbeTqpLE+KiLq+cGyA5Rd2HaAAoBpqxoZHvsyT1VgOftzeHQ5wuUr+nLGGaznJBR9MxCa9ELptRnFxk2ySJlH0Lx9JrF4gZK8CFehQ0FhTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732542023; c=relaxed/simple;
	bh=CWLzAsL8EJA5FdIowSi8LwAT/bKMRaCYyLXF+YP09aU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ldgbPyYwWLXH23HK6r1XqcS/RUFviFgPwhgKjGuJtqIt+/J7g6zoWw6yQxo1yXmp5aLaf1EcYfASrv2HWdPrtdS/XF9FLCgyvOvO14r8TJeFKOI1w7jJKxiXduknxu0YVfkFhoM/L/hCBI3Ad2foGexVJ/zr1BmhY7GmD1eAxA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWPwklWU; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732542022; x=1764078022;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CWLzAsL8EJA5FdIowSi8LwAT/bKMRaCYyLXF+YP09aU=;
  b=QWPwklWUH+bI0zZNnU88EH6rf7QgUMeNad7Ny6jnh4gVEvx0pkdkeMjd
   28kZQ0DIT5S85k9rFakozep4199b70BTQB9YaEiHT1kqMe207Xk0P9K1Z
   tKD929fH3VnUesM+sSKpxii7Ms9hFFU9HjbJfPVmG75vnBStSkmtJlmyH
   jgP8Zjr9zEPcyWMbOllzErys4KRS/ZsTS/bvYByCESiEJ8ibMD6KIRUEg
   7ZVMPFL5X0PeJ8NE2TTpoIIC8rlddB5oN8FGAohSjZ4XuQIdNn539BwSH
   DFJC1yoMW8580LTzwKayp+IbWI2ObEGUuVbM5dgucwFsDiU5U1/+jMBwW
   w==;
X-CSE-ConnectionGUID: PszW2Y5dQZK+ib58tu9fHQ==
X-CSE-MsgGUID: U7Zx1BsYRP+0a3enMhUULA==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="44029367"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="44029367"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 05:40:21 -0800
X-CSE-ConnectionGUID: Vqf6dgSQR/y3Xnpn7Cnk1w==
X-CSE-MsgGUID: xukq6NshT/eYbq2TSz+lHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="92058743"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 05:40:16 -0800
Message-ID: <56db8257-6da2-400d-8306-6e21d9af81f8@intel.com>
Date: Mon, 25 Nov 2024 15:40:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
To: Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-2-adrian.hunter@intel.com>
 <fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com>
 <0226840c-a975-42a5-9ddf-a54da7ef8746@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <0226840c-a975-42a5-9ddf-a54da7ef8746@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/11/24 18:33, Dave Hansen wrote:
> On 11/22/24 03:10, Adrian Hunter wrote:
>> +struct tdh_vp_enter_tdcall {
>> +	u64	reg_mask	: 32,
>> +		vm_idx		:  2,
>> +		reserved_0	: 30;
>> +	u64	data[TDX_ERR_DATA_PART_2];
>> +	u64	fn;	/* Non-zero for hypercalls, zero otherwise */
>> +	u64	subfn;
>> +	union {
>> +		struct tdh_vp_enter_vmcall 		vmcall;
>> +		struct tdh_vp_enter_gettdvmcallinfo	gettdvmcallinfo;
>> +		struct tdh_vp_enter_mapgpa		mapgpa;
>> +		struct tdh_vp_enter_getquote		getquote;
>> +		struct tdh_vp_enter_reportfatalerror	reportfatalerror;
>> +		struct tdh_vp_enter_cpuid		cpuid;
>> +		struct tdh_vp_enter_mmio		mmio;
>> +		struct tdh_vp_enter_hlt			hlt;
>> +		struct tdh_vp_enter_io			io;
>> +		struct tdh_vp_enter_rd			rd;
>> +		struct tdh_vp_enter_wr			wr;
>> +	};
>> +};
> 
> Let's say someone declares this:
> 
> struct tdh_vp_enter_mmio {
> 	u64	size;
> 	u64	mmio_addr;
> 	u64	direction;
> 	u64	value;
> };
> 
> How long is that going to take you to debug?

When adding a new hardware definition, it would be sensible
to check the hardware definition first before checking anything
else.

However, to stop existing members being accidentally moved,
could add:

#define CHECK_OFFSETS_EQ(reg, member) \
	BUILD_BUG_ON(offsetof(struct tdx_module_args, reg) != offsetof(union tdh_vp_enter_args, member));

	CHECK_OFFSETS_EQ(r12, tdcall.mmio.size);
	CHECK_OFFSETS_EQ(r13, tdcall.mmio.direction);
	CHECK_OFFSETS_EQ(r14, tdcall.mmio.mmio_addr);
	CHECK_OFFSETS_EQ(r15, tdcall.mmio.value);


