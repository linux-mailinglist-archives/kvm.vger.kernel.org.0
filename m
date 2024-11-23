Return-Path: <kvm+bounces-32390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E6A9D669A
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2024 01:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFAC3B2203B
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2024 00:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B639F2F5A;
	Sat, 23 Nov 2024 00:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YdBLM1ey"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5240E817;
	Sat, 23 Nov 2024 00:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732320517; cv=none; b=Ux8H5X0s9/yUCt1tL7JI/zWk9GvfH7uitzq/jbOVkxqGffvEOLCECi+HydUoAqFe6y3lXV46ByVix5M7DH1isDi9pH+OG7oSODH6efGeKN8CmKixtOJpJXGzDYjec9YrdusnkGBoqVoiJ2AXY4oYReAjNIug23e7Sx6mhQ/rAkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732320517; c=relaxed/simple;
	bh=APVj4q25ZayGfJKZ9Lm/pwT5JHS27FOdlBrt2jGCVQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1uz+mLtggKQFUTBEeASO+ExMHyhy/q2WMkU06I78+p/e27Twrj4UkNguV3QhuVtLSnVeHXVTo1Rm9xMCfUozW8MswETFbMCoDMvuhdM9fk9c7pfbjjw1zuvtoFy8DoxuMjFoIIlUuXd/mr1bpUsqz3xdcXOcaX3SilAmZs6Kfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YdBLM1ey; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732320516; x=1763856516;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=APVj4q25ZayGfJKZ9Lm/pwT5JHS27FOdlBrt2jGCVQM=;
  b=YdBLM1ey76FZuW1ymThGLhsTQAy2NgkNS75n/pXdr1uHlCB5IwKgJ1Qn
   7FkGselpdw8la7wBTzJEcUoMyrfe+VN7k7SkA1lrjaplFsHEx3gyikQ6V
   fIPrDuuGKnhNyKF2sWNteN1Jn8128q1sBAiFhPFvTCVzRw13FS8mLzuJU
   5JOYEcIIhsyr7VrwvWqpbfRiTwczJFPP1ZqiLuX5CowS5b/QSU/irWDa0
   gRl9f+DZR7+vm2LH/NyJb5W8A9eQubnluGJIBIPUktA+XK9iswyWpY1tN
   B8O+f7Ur6Iu+75zPxagG6M+nyFqXez3rdP6JOVduN6R9P1rP2rw7+2Zzu
   g==;
X-CSE-ConnectionGUID: BLcnPmM+TVmFq7SfrDbfwA==
X-CSE-MsgGUID: hGQdiSC2R8afukgOFNL5dQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="20078715"
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="20078715"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 16:08:36 -0800
X-CSE-ConnectionGUID: PJ0fQCx4S72wuaV7268a7Q==
X-CSE-MsgGUID: p1nuRMkJRauskh1buPU2KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="95794788"
Received: from bjrankin-mobl3.amr.corp.intel.com (HELO [10.124.220.110]) ([10.124.220.110])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 16:08:35 -0800
Message-ID: <6903d890-c591-4986-8c88-a4b069309033@intel.com>
Date: Fri, 22 Nov 2024 16:08:34 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID
 management
To: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 linux-kernel@vger.kernel.org, tony.lindgren@linux.intel.com,
 xiaoyao.li@intel.com, yan.y.zhao@intel.com, x86@kernel.org,
 adrian.hunter@intel.com, Isaku Yamahata <isaku.yamahata@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Yuan Yao <yuan.yao@intel.com>
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
 <20241115202028.1585487-2-rick.p.edgecombe@intel.com>
 <30d0cef5-82d5-4325-b149-0e99833b8785@intel.com>
 <Z0EZ4gt2J8hVJz4x@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <Z0EZ4gt2J8hVJz4x@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/22/24 15:55, Sean Christopherson wrote:
> On Fri, Nov 22, 2024, Dave Hansen wrote:
> I don't know the full context, but working with "struct page" is a pain when every
> user just wants the physical address.  KVM SVM had a few cases where pointers were
> tracked as "struct page", and it was generally unpleasant to read and work with.

I'm not super convinced. page_to_phys(foo) is all it takes

> I also don't like conflating the kernel's "struct page" with the architecture's
> definition of a 4KiB page.

That's fair, although it's pervasively conflated across our entire
codebase. But 'struct page' is substantially better than a hpa_t,
phys_addr_t or u64 that can store a full 64-bits of address. Those
conflate a physical address with a physical page, which is *FAR* worse.

>> You know that 'tdr' is not just some random physical address.  It's a
>> whole physical page.  It's page-aligned.  It was allocated, from the
>> allocator.  It doesn't point to special memory.
> 
> Oh, but it does point to special memory.  If it *didn't* point at special memory
> that is completely opaque and untouchable, then KVM could use a struct overlay,
> which would give contextual information and some amount of type safety.  E.g.
> an equivalent without TDX is "struct vmcs *".
> 
> Rather than "struct page", what if we add an address_space (in the Sparse sense),
> and a typedef for a TDX pages?  Maybe __firmware?  E.g.
> 
>   # define __firmware	__attribute__((noderef, address_space(__firmware)))
> 
>   typedef u64 __firmware *tdx_page_t;
> 
> That doesn't give as much compile-time safety, but in some ways it provides more
> type safety since KVM (or whatever else cares) would need to make an explicit and
> ugly cast to misuse the pointer.

It's better than nothing. But I still vastly prefer to have a type that
tells you that something is physically-allocated out of the buddy, RAM,
and page-aligned.

I'd be better to have:

struct tdx_page {
	u64 page_phys_addr;
};

than depend on sparse, IMNHO.

Do you run sparse every time you compile the kernel, btw? ;)

