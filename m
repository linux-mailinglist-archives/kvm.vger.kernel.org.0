Return-Path: <kvm+bounces-24089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6145A951290
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 04:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 244B9283DC8
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 02:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2AA142A90;
	Wed, 14 Aug 2024 02:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CGRGBBe4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADC93BBC2;
	Wed, 14 Aug 2024 02:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723603021; cv=none; b=i2gxrvKJHtc9ZtyOK1NDOaF3UfrjFmaOQjiXUDqOh0DBP4iTLDCra6695doeN6XRV53PLM/clUruxxhdYFGRek0JHJGOSHoDgKzNWyo9TFEdWdjYf9fnH0K4dpGm/kB0Bz3EER6EDxw/MoZUqQ3YE/7j/NdRhfIvNAvorKcMneg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723603021; c=relaxed/simple;
	bh=RgdW8Z0FSQjlzBFEKxWJSdLLXdxElhfB5ZVqua+kYb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMeeCpX3R/f0L0uVYO0cO9V3HvjlpoqUtJ65AwzQ9QRWdeObP4fuT6I5WocQdA01TQdcNaFnplw4LcNxn08vIBPVV1Aoh2fJKZgrW1QVq2omRrWSvQJQhhC9iGHM09LHGthkTZaDS0J2/+n6vZWm15tZqHfx+APvNJTiRi6U6Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CGRGBBe4; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723603020; x=1755139020;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RgdW8Z0FSQjlzBFEKxWJSdLLXdxElhfB5ZVqua+kYb4=;
  b=CGRGBBe4B86lGu3IrX7DjDgpddnu9qUdflNmz71cIyp0ZUQevx+WnvwF
   GBCsPijW4taLFhA3vQKaYqUfkcANy4Edd28d5XJSpwZVNqH2RKUGTo/sG
   mg9GVN8F4w0wgUGb+iruLJ8LcICuUsPMqGc16XAMkQ45i+qJKNAq0oGDW
   5iSjRZCwJgvO47uNMYGZPgxA5L8wSqDYFUrpaoPPGw9BTVXRIJs1J087j
   Cg/P6b35kfKWWC/4EOQdoOiBtOSSAgvdrFekfOt3Ao9EX/mPAT08YXc0e
   on+p9M3NjIRTZJZbZU0nFbPU2HNFHLKn4oX+WtGCvANrxeKAk9ltO/5rM
   w==;
X-CSE-ConnectionGUID: p4jq+VQITSG/7egYCbqQaQ==
X-CSE-MsgGUID: VYSz1m69S8qec7/AZtoFYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21954638"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="21954638"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 19:36:59 -0700
X-CSE-ConnectionGUID: Bd8ofUoWR+qjrK0rl5Cfig==
X-CSE-MsgGUID: m205OS+6SZCRk4ixdJT8/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="89674020"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 19:36:57 -0700
Message-ID: <3a215360-32f8-47bb-b804-27124267244e@linux.intel.com>
Date: Wed, 14 Aug 2024 10:36:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Chao Gao <chao.gao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
 isaku.yamahata@gmail.com, tony.lindgren@linux.intel.com,
 xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <ZrrSMaAxyqMBcp8a@chao-email>
 <7ddf7841-7872-4e7b-9194-25c529bd0ae1@linux.intel.com>
 <Zrv5y0zk+prwBxz9@chao-email>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Zrv5y0zk+prwBxz9@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/14/2024 8:26 AM, Chao Gao wrote:
> On Tue, Aug 13, 2024 at 03:24:32PM +0800, Binbin Wu wrote:
>>
>>
>> On 8/13/2024 11:25 AM, Chao Gao wrote:
>>> On Mon, Aug 12, 2024 at 03:48:05PM -0700, Rick Edgecombe wrote:
>>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>
>>>> While TDX module reports a set of capabilities/features that it
>>>> supports, what KVM currently supports might be a subset of them.
>>>> E.g., DEBUG and PERFMON are supported by TDX module but currently not
>>>> supported by KVM.
>>>>
>>>> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
>>>> supported_attrs and suppported_xfam are validated against fixed0/1
>>>> values enumerated by TDX module. Configurable CPUID bits derive from TDX
>>>> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>>>> i.e., mask off the bits that are configurable in the view of TDX module
>>>> but not supported by KVM yet.
>>>>
>>>> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
>>>> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
>>> If we convert KVM_TDX_CPUID_NO_SUBLEAF to 0 when reporting capabilities to
>>> QEMU, QEMU cannot distinguish a CPUID subleaf 0 from a CPUID w/o subleaf.
>>> Does it matter to QEMU?
>> According to "and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the
>> concept of KVM". IIUC, KVM's ABI uses KVM_CPUID_FLAG_SIGNIFCANT_INDEX
>> in flags of struct kvm_cpuid_entry2 to distinguish whether the index
>> is significant.
> If KVM doesn't indicate which CPU leaf doesn't support subleafs when reporting
> TDX capabilities, how can QEMU know whether it should set the
> KVM_CPUID_FLAG_SIGNIFICANT_INDEX flag for a given CPUID leaf?  Or is the
> expectation that QEMU can discover that on its own?
>
When KVM report CPUIDs to userspace, for the entries that index is
significant, it will set KVM_CPUID_FLAG_SIGNIFICANT_INDEX, including
reporting CPUIDs for TDX.
QEMU can check the flag to see if the subleaf is significant or not.

On the other side, when QEMU build its own version, it also set
KVM_CPUID_FLAG_SIGNIFICANT_INDEX for the entries that index is significant.






