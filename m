Return-Path: <kvm+bounces-15057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ADEBC8A947B
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 09:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B13CB21DAF
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 07:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B99176050;
	Thu, 18 Apr 2024 07:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JVxzn7Sr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E82C3C489;
	Thu, 18 Apr 2024 07:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713427039; cv=none; b=CFiTxac4bjyFVvILc87G5Pnt4yQds/Ns4CiS8rup85EQ71eRtxcpmRpbKz+wWOAiE5OhgjAq24HLUztaVz9Dkvrv6nRu9L95lNbUFYCfmsgYVPsnpQjVRJhJvQ2cG+nNel801f50V7wnsAWtuQv3shzfX4BwLSSBUsY4rBmcSWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713427039; c=relaxed/simple;
	bh=Si78ZIO9jiOjKMkvkEkeQyg6jJmQr3a25j/e+Fe5PfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XkxLCHATfIVUOCoRUBPEqQvJVfExOMiJZjP9pZoiUW5O+lG6VIB0OfJgzxz3CWFh+LnT8fvxx2rXPDsUj/iR5Ofwl21GHBme6kxuARPTk7ljn0lXuB1QS+/p+/iRV+BOdxCu+CB9YNZ7zUl80WlXGBH0/2JWQNxIgggmsZxJ4y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JVxzn7Sr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713427038; x=1744963038;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Si78ZIO9jiOjKMkvkEkeQyg6jJmQr3a25j/e+Fe5PfU=;
  b=JVxzn7SrwmQAm027223Y+RVltl2N+rouumSIVZzj2Hegf3v36P00Z333
   NUMvNg2vkHAKWGjUAyG7PenH5k84xGzmrJtuNrZCFN9F4ObTOphoPJayP
   KBSGeNL8uq4z8if2dDAkO3FwCjNsLdG4Npn7VtqF4JOILOML1c1f9YBJI
   Bd3JAejAzVCHGZ39bQBOX1Qel7id+m0VTpAFI5mr96E1o4XgFOi+InhHT
   jxcst3blwDsNZS2u+9fncHJOku+9wqt7NhP94/5zgMN72V8E/PlvUoIR8
   GtpyBtMXeo8ceJIKhM+OfshzxbHUnpkzILqCUs0HXdtvU+miBvjVl3VTB
   w==;
X-CSE-ConnectionGUID: 4c0bemaCTmmtfth1zbJPcQ==
X-CSE-MsgGUID: Eb4X4tPZTWCVTeTb7KAgHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9114847"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="9114847"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 00:57:17 -0700
X-CSE-ConnectionGUID: YLzzTWRuSryGJs9Wf85SKQ==
X-CSE-MsgGUID: tuT1HyI5QB6HsphomVrlIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="23507802"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 00:57:14 -0700
Message-ID: <d83e5fea-492e-4bd8-ba75-113bfd0c6643@linux.intel.com>
Date: Thu, 18 Apr 2024 15:57:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 079/130] KVM: TDX: vcpu_run: save/restore host
 state(host kernel gs)
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a766983346b2c01e943348af3c5ca6691e272f9.1708933498.git.isaku.yamahata@intel.com>
 <8132ddff-16f3-482f-b08b-a73aa8eddbbc@linux.intel.com>
 <20240412201702.GJ3039520@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240412201702.GJ3039520@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/13/2024 4:17 AM, Isaku Yamahata wrote:
>>> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>> Just like vmx_prepare_switch_to_host(), the input can be "struct vcpu_tdx
>> *", since vcpu is not used inside the function.
>> And the callsites just use "to_tdx(vcpu)"
>>
>>> +{
>>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> Then, this can be dropped.
> prepare_switch_to_guest() is used for kvm_x86_ops.prepare_switch_to_guest().
> kvm_x86_ops consistently takes struct kvm_vcpu.

Oh yes, it's not suitable for tdx_prepare_switch_to_guest().
Still, it can be for tdx_prepare_switch_to_host().




