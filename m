Return-Path: <kvm+bounces-42792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29005A7D286
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 05:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7855B16AF86
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 03:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE852135D8;
	Mon,  7 Apr 2025 03:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HnP71YQt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E9B1B042E;
	Mon,  7 Apr 2025 03:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743997089; cv=none; b=btgJsRm8pTuEHLzV4XoUuANiA58JkqLAS7FrFQ68hHyKWFC0ae9IWwC5/mljPi7lJQEwNY6f9Enc3glu1ZJhrSskqCOv+FYeW+a2O+diHs5qr0VJFOxC6ZA0YwI4hIpSgakUn7MVFGe2AkI4BLonKLXrADOpoArwlgqlz0aBxxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743997089; c=relaxed/simple;
	bh=8qencRNmZDgG+9U6EkM/h4JauXYlhWogl6srWsrJpds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XzAi3JKONg1em5iWE+EQQTiMXLbOnUK2aZrOVHMD8mnVuogPtZw5mzd1Chduq77GDpJ+3NvY6uUmbc0HUIv3dLIXB+fief0XE1ICGJg+ytlUGPPULVxBEA3MnyR+X3LxiQyKDUtTiOBpXifO+d2DSu/fap/E8AtkyN3C9JaZhzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HnP71YQt; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743997089; x=1775533089;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8qencRNmZDgG+9U6EkM/h4JauXYlhWogl6srWsrJpds=;
  b=HnP71YQtCeRk1VUQIf1ncOisAjMar9Rv2+q2yaQ+vdOr3/CL1BVNiq1B
   wBE4rOW8QRe/uztnTHXwYuzlgU2cTjYOrd75+5RcZyGF5/475RPaNVwQG
   35R6JDFAcs9CCBbUBSKwkZKw8C3foo6umUuZhqo1T8e2BHpCfdUSnOaSX
   gi7kZ6vIPif+2CDfZwxmmGE1KmEjPNWJ7ZfJcK5fMfUV2RYnLKghNraEq
   LMQk3f2kyg5S6W3RqQU3Ix+Jq+7DbiLdUaO7xJAI0lQRELo4wye9nR/Kb
   WDizBLNamEcO/csVYff5XbVJZ0MLNw2A5vQd0rc3b/SgKKkenf72T/Gv/
   A==;
X-CSE-ConnectionGUID: fAKLeZv1QTiF3Iv6saXF8w==
X-CSE-MsgGUID: NACh4JOYTxieOBvFNteCGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="55550554"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="55550554"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2025 20:38:08 -0700
X-CSE-ConnectionGUID: wgUIx/3zSni/jjWHS3eELw==
X-CSE-MsgGUID: GpfUPQYCRY6HooUPVR78XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128329325"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.247.168.206]) ([10.247.168.206])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2025 20:38:01 -0700
Message-ID: <ff11bfee-b78e-4074-8bc6-d7826ad4d8be@linux.intel.com>
Date: Mon, 7 Apr 2025 11:37:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] irqbypass: Use xarray to track producers and
 consumers
To: Sean Christopherson <seanjc@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
 David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>,
 Yong He <alexyonghe@tencent.com>
References: <20250404211449.1443336-1-seanjc@google.com>
 <20250404211449.1443336-8-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250404211449.1443336-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/5/2025 5:14 AM, Sean Christopherson wrote:
> Track IRQ bypass produsers and consumers using an xarray to avoid the O(2n)
produsers -> producers

> insertion time associated with walking a list to check for duplicate
> entries, and to search for an partner.
>
> At low (tens or few hundreds) total producer/consumer counts, using a list
> is faster due to the need to allocate backing storage for xarray.  But as
> count creeps into the thousands, xarray wins easily, and can provide
> several orders of magnitude better latency at high counts.  E.g. hundreds
> of nanoseconds vs. hundreds of milliseconds.
>
[...]

