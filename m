Return-Path: <kvm+bounces-37834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F9FA3086B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:23:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A47EE16670A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 10:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2FB1F4285;
	Tue, 11 Feb 2025 10:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EX0F5zir"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CBA1EE00D;
	Tue, 11 Feb 2025 10:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739269392; cv=none; b=QFOQN2Eh3ZLwYv836pJSwKr+f6IquoxRDevklGUoUV4nKNF7yOCpFV9mf19nu1wLKw5Ob5BeaF+nCoUtQ16WqEltLYz2FcPSnxEAlFeIxUGOogz+0eMqJmYPVcuAgwLaCqmkwuFyPdkZ7O1XD/mNSVF3ectBM9YJcGFb5gT1Vq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739269392; c=relaxed/simple;
	bh=WBzlD/CSBro+BN3VXr311R2Rxr6ngOzTHPacYaF3UPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hQzo0THQ3vr9Hnaqg81a6DAqfd9olzuI5DiWZSvoVxMFnwgJgQw2pqH26kI3mkgLI5W7mpFQftDUBky0lDJcWXyYhGB3PtimlfNZKA5VGkL0k1j5xKZ04YCwjnGcM2RUNt89XPzc+U3buS82W0D8VqYXYg6m2jmvKHKpUQEknfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EX0F5zir; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739269391; x=1770805391;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WBzlD/CSBro+BN3VXr311R2Rxr6ngOzTHPacYaF3UPI=;
  b=EX0F5zirLD+FCC7YNzURcDViwsTykv53Iw5UHUlrqZ/q+pWjaYmSC+W1
   uImxsCpInnuQKFsWm0g/4CZcFze1FgBusZ5VBwSUPcXuO1PgLg3xbFfLs
   S1ldQWF4JNQUdj/FN5L/g0cCFhCMyVhN0ZjVwoz4PRtfk5Ea9ldj81Zcw
   ZSPx4Se7K6donhC4Bq7YUGADEL7YaiyHQtSCIqB5mgLdvttwbxomMSWg7
   nMxaJi86M+wm1ScHF6lzfhwzYO1UVMm01FmMH/c0JUE8a9os2K7Ibx02I
   XgO67BinXD4xGz079FLICVl4LU3QbYhx2XvPHnIifFIL4yAtNQGJX/tqs
   w==;
X-CSE-ConnectionGUID: +Ot8igYoQte7LC0bM5Hbgw==
X-CSE-MsgGUID: wXsR3ELAQCCs6pJZqYzR5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="50107965"
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="50107965"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 02:23:10 -0800
X-CSE-ConnectionGUID: 80Zm919CRQe6hlgAv4vCbQ==
X-CSE-MsgGUID: nqZWR2lJS56KHsgV4CzVOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="143376015"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 02:23:07 -0800
Message-ID: <de966c9c-54e4-4da2-8dd3-d23b59b279a3@intel.com>
Date: Tue, 11 Feb 2025 18:23:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] KVM: x86: Have ____kvm_emulate_hypercall() read
 the GPRs
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-2-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250211025442.3071607-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/11/2025 10:54 AM, Binbin Wu wrote:
> Have ____kvm_emulate_hypercall() read the GPRs instead of passing them
> in via the macro.
> 
> When emulating KVM hypercalls via TDVMCALL, TDX will marshall registers of
> TDVMCALL ABI into KVM's x86 registers to match the definition of KVM
> hypercall ABI _before_ ____kvm_emulate_hypercall() gets called.  Therefore,
> ____kvm_emulate_hypercall() can just read registers internally based on KVM
> hypercall ABI, and those registers can be removed from the
> __kvm_emulate_hypercall() macro.
> 
> Also, op_64_bit can be determined inside ____kvm_emulate_hypercall(),
> remove it from the __kvm_emulate_hypercall() macro as well.

After this patch, __kvm_emulate_hypercall() becomes superfluous.
we can just put the logic to call the "complete_hypercall" into 
____kvm_emulate_hypercall() and rename it to __kvm_emulate_hypercall()



