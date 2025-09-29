Return-Path: <kvm+bounces-58987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 545A8BA9186
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 13:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E1361C27AC
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC7B30216C;
	Mon, 29 Sep 2025 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="llz7MqXS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE23D30214A;
	Mon, 29 Sep 2025 11:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759146295; cv=none; b=gawyyPpBiKwiBx6uK//ABLZv8XVkljgQh+8pmiiJyDTuer6ZvdZg8qpqCuAkCajhtomYccr9JLfoH/aAj4jIBzk2ifMmGA77zlhdAiHWecdR1T0GvW6LsX8WWjWiUEHxMeC//vrARl9JMwvXWRwvdjxaDU+v7UStBsyWQpb1IQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759146295; c=relaxed/simple;
	bh=izGasfRnEi7HbQteCBOxsheAwEE/2zFxEJFimTPnAsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=e0TAkfpL4fD57SrO2ttDQMGxNPtO6qZHa2zeC1xHTzg00pjmymUMXQKYdbbeolyiDBfifqmHkogPoTeI7pEApNUqJRU6AefvH7aKrY6QJglmQHrcyIxEKw/kRELRdjEcfkcXgDKQV3XH9lIXlpMC9mshXGY8BN9m3rSyYguc0i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=llz7MqXS; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759146294; x=1790682294;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=izGasfRnEi7HbQteCBOxsheAwEE/2zFxEJFimTPnAsE=;
  b=llz7MqXSsTbVx2p9AatUeAjPkjDiKahJFClrtEGx1d/VYTtid7OC0z/m
   Bo6cTd6QkFoFFruzKShAp+kNw9ogjkaujN11pq4eFgdx23PrA+9otQXl4
   HgGXw6GdJRvZiY+5pb5kU5be1zb7CT0IYb7NLRAGLov0wZJFE8YM/9yau
   dkT/7v1KNZl8kPS1FbkDIMDCNvJAXEX92ux5Su7oOtZ1HTqj1fqTKay6o
   mbvLkOoI+WVStZJboSX7g0Qlf1eMhGhAVFZsKZx1hKgqaOahDFPSgb89O
   N1JSbooA8j7NnEAKkxNpXNjXuCCp8xlWH64jNDJkU5wgCI+azDYqaV7Li
   Q==;
X-CSE-ConnectionGUID: AOWe2sJGRziAl39An+IU3g==
X-CSE-MsgGUID: Tk2FtYWHQwWEYWO11HAZpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11567"; a="79031491"
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="79031491"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 04:44:53 -0700
X-CSE-ConnectionGUID: cVKjwUhXQSifjHBb6j3iyg==
X-CSE-MsgGUID: VQimLx5OQnip03a65w3pMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="178274556"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 04:44:48 -0700
Message-ID: <d5bfd8bf-2d28-4e79-90c8-bdca581e8000@intel.com>
Date: Mon, 29 Sep 2025 19:44:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-4-rick.p.edgecombe@intel.com>
 <1c29a3fdbc608d597a29cd5a92f40901792a8d7c.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1c29a3fdbc608d597a29cd5a92f40901792a8d7c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/2025 8:50 AM, Huang, Kai wrote:
>>   static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
>> -				      u16 pamt_entry_size)
>> +				      u16 pamt_entry_size[])
> AFAICT you don't need pass the whole 'pamt_entry_size[]' array, passing
> the correct pamt_entry_size should be enough.

While we are at it, how about just moving the definition of 
pamt_entry_size[] from construct_tdmrs() to here?

