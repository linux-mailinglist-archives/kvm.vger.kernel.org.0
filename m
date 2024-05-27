Return-Path: <kvm+bounces-18153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E448CF733
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 02:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1796528177B
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 00:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BA63211;
	Mon, 27 May 2024 00:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nSBEmYo7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D81E64D;
	Mon, 27 May 2024 00:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716771457; cv=none; b=bJ1Fxrp6F0lLVmZrBGnAqf/rBYHtiwHs1VqjHmM7g0Aoa5DJpglOVYQBhvxNbF3LjJXYELhOS0dp2XX7DLpStrdwoBhF7ldPZmP7kATVEVKMkmK5mLz5DvDXxFo4rc/RJBFkR06fq2KsEnFzv9PwhD2lbG3LxucoZYg/kLP/JVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716771457; c=relaxed/simple;
	bh=rsK1IsML/UxFu1xXGLPPqKz0eHkBTwAPomJ3dUFEjqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yu3LfPZoI8CDsP74ATuAnhQmTWIwSkaRRDktW5acIhJpQPoRtR4LGQWVXsk9fccjLZHd9zVzxLl2VUhM/NGbysl0H/CR2MLbGEjXxrCmdKUObine4Wyo/M2sySik5lJ9F3xot4RUCLbL5c2KUHarnMhwLPlfP9aB4lz7zU0hJws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nSBEmYo7; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716771455; x=1748307455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rsK1IsML/UxFu1xXGLPPqKz0eHkBTwAPomJ3dUFEjqk=;
  b=nSBEmYo7d7zbnXPcgUAUYgto3cMUZrZW8kjLUaRAcqJp32EdNgXksCUg
   o/8iUmi5raQKl7tHZAmmc8lpn7E1uMXv9YdCqneo+q52KBM8IFnFRE+py
   XZc7lz0YHyvU8k6+uc2GnWBcjZy++CV6i/1qVJKC724oCowvDINr1CbBi
   3rPKZzBkEVc5wivme7wMuImHOGyPhdo+7YU3i1hMLWM+M8nJiZddCCkYv
   VEnJtEKpGvFFlc85wRZIhLW5eVc4R0hlhHMTUs9UbyqpUpXvFaORgJf//
   yUdNQ+/cE1vI66Q+ynnan8SCGVEg5cm/BCZECh+dWXajEcHfCEAGRaoNo
   g==;
X-CSE-ConnectionGUID: Lm5m4kXsQ423fiQbQh1/4A==
X-CSE-MsgGUID: HUF8mqFGTjq3mnhxW3FI7A==
X-IronPort-AV: E=McAfee;i="6600,9927,11084"; a="30598555"
X-IronPort-AV: E=Sophos;i="6.08,191,1712646000"; 
   d="scan'208";a="30598555"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2024 17:57:34 -0700
X-CSE-ConnectionGUID: FRvCXjwUSQW/K585oeZSCw==
X-CSE-MsgGUID: lYDdnMVtSFGieYRfZHKRzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,191,1712646000"; 
   d="scan'208";a="34503825"
Received: from unknown (HELO [10.238.8.173]) ([10.238.8.173])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2024 17:57:30 -0700
Message-ID: <6a7b865f-9513-4dd2-9aff-e8f19dea6d90@linux.intel.com>
Date: Mon, 27 May 2024 08:57:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 105/130] KVM: TDX: handle KVM hypercall with
 TDG.VP.VMCALL
To: Isaku Yamahata <isaku.yamahata@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
 Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com, isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ab54980da397e6e9b7b8d6636dc88c11c303364f.1708933498.git.isaku.yamahata@intel.com>
 <ZgvHXk/jiWzTrcWM@chao-email>
 <20240404012726.GP2444378@ls.amr.corp.intel.com>
 <8d489a08-784b-410d-8714-3c0ffc8dfb39@linux.intel.com>
 <20240417070240.GF3039520@ls.amr.corp.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240417070240.GF3039520@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/17/2024 3:02 PM, Isaku Yamahata wrote:
> On Wed, Apr 17, 2024 at 02:16:57PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>>
>> On 4/4/2024 9:27 AM, Isaku Yamahata wrote:
>>> On Tue, Apr 02, 2024 at 04:52:46PM +0800,
>>> Chao Gao <chao.gao@intel.com> wrote:
>>>
>>>>> +static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +	unsigned long nr, a0, a1, a2, a3, ret;
>>>>> +
>>>> do you need to emulate xen/hyper-v hypercalls here?
>>> No. kvm_emulate_hypercall() handles xen/hyper-v hypercalls,
>>> __kvm_emulate_hypercall() doesn't.
>> So for TDX, kvm doesn't support xen/hyper-v, right?
>>
>> Then, should KVM_CAP_XEN_HVM and KVM_CAP_HYPERV be filtered out for TDX?
> That's right. We should update kvm_vm_ioctl_check_extension() and
> kvm_vcpu_ioctl_enable_cap().  I didn't pay attention to them.
Currently, QEMU checks the capabilities for Hyper-v/Xen via 
kvm_check_extension(), which is the global version.
Only modifications in KVM can't hide these capabilities. It needs 
userspace to use VM or vCPU version to check the capabilities for 
Hyper-v and Xen.
Is it a change of ABI when the old global version is still workable, but 
userspace switches to use VM/vCPU version to check capabilities for 
Hyper-v and Xen?
Are there objections if both QEMU and KVM are modified in order to 
hide Hyper-v/Xen capabilities for TDX?




