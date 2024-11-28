Return-Path: <kvm+bounces-32725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8069DB2C6
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 07:26:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A200A28290A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 06:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A30A145B39;
	Thu, 28 Nov 2024 06:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NOii/i97"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0851FAA;
	Thu, 28 Nov 2024 06:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732775205; cv=none; b=q8IZldKvENdHNhuAG8T/LIu7gdTYXrhiTAOhA6URicdu2CReqR5sFq6XgkJmCjeCmMzFhad/qayZzTWUT8wAyB+a2peiLHXmEqw/uG9FtRrxRIckf0gzvIWy4i3JfN+txjDscOr7AEriknvimGo3Q+oYXLlv0i2axeWiqAxcb+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732775205; c=relaxed/simple;
	bh=27BH3kTMnXkvncqDOFR5UON2No4G40nB9lU0s4Y1g3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o1ItQ1cO6d+kAaAjmGbZUk0+FrQrK7G8A9bDChSaL26irfaQPGi58jdze93YmHh+fIIpZxS3E/WqyNu3e3B3zk9LcGI2wWhgb5HNs4yyTuBVG0IMqO+PLYxqn1EkvyFuw11LTBSYqjSIRMgZ6JaRDOgf6nTsnuPSCHEtwTVznK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NOii/i97; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732775203; x=1764311203;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=27BH3kTMnXkvncqDOFR5UON2No4G40nB9lU0s4Y1g3I=;
  b=NOii/i97syU0X3u348dGmAokbnItTjvxGJU31PkVqF1UVhWCbeconfpJ
   cdL7Lw5QJCILq8m2Cz7HD/wh8vh/76rclHic+6dAGIwPLGzTXmkOWwthC
   LfM3QYpqqMVnekgZKP/r8eDoFbdUhWMlV/t5aglMI3CzXn7Dt2KinROrJ
   TSWNz2gJIvA1rMsHB3H6iGH9Jc/DVFzj7NEO5pKk3Q2icSDXq1Zfk4X7Q
   pcVbGLmBi+BpNsQC6llFChcMPeNgGbaBegpVzZuKKC7JsluBM3Pmr2Zs2
   utcAUBN0URiIaMpIllistdhwG8ZDaqwTYeVXcOlDLRa8D6Hi6GXBNigeU
   A==;
X-CSE-ConnectionGUID: UpuhkVzRQ+6Uo+rSgSOQBA==
X-CSE-MsgGUID: nOSvH/QSSSuSqMY4xSkY2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="32931819"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="32931819"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 22:26:41 -0800
X-CSE-ConnectionGUID: 4xBOJ8xgSo2NIknwWKwx0w==
X-CSE-MsgGUID: sHZ70yT6QpmUMBHt17+2EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="91756519"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 22:26:36 -0800
Message-ID: <3576c721-3ef2-40bd-8764-b50912df93a2@intel.com>
Date: Thu, 28 Nov 2024 08:26:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] KVM: TDX: Implement TDX vcpu enter/exit path
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com,
 tony.lindgren@linux.intel.com, dmatlack@google.com,
 isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, chao.gao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-3-adrian.hunter@intel.com>
 <2f22aeeb-7109-4d3f-bcb7-58ef7f8e0d4c@intel.com>
 <91eccab3-2740-4bb7-ac3f-35dea506a0de@linux.intel.com>
 <837bbbc7-e7f3-4362-a745-310fe369f43d@intel.com>
 <Z0gGBnTcFzY99/iG@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z0gGBnTcFzY99/iG@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 28/11/24 07:56, Yan Zhao wrote:
> On Fri, Nov 22, 2024 at 04:33:27PM +0200, Adrian Hunter wrote:
>> On 22/11/24 07:56, Binbin Wu wrote:
>>>
>>>
>>>
>>> On 11/22/2024 1:23 PM, Xiaoyao Li wrote:
>>> [...]
>>>>> +
>>>>> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>>>> +{
>>>>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>>>>> +
>>>>> +    /* TDX exit handle takes care of this error case. */
>>>>> +    if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
>>>>> +        /* Set to avoid collision with EXIT_REASON_EXCEPTION_NMI. */
>>>>
>>>> It seems the check fits better in tdx_vcpu_pre_run().
>>>
>>> Indeed, it's cleaner to move the check to vcpu_pre_run.
>>> Then no need to set the value to vp_enter_ret, and the comments are not
>>> needed.
>>
>> And we can take out the same check in tdx_handle_exit()
>> because it won't get there if ->vcpu_pre_run() fails.
> 
> And also check for TD_STATE_RUNNABLE in tdx_vcpu_pre_run()?

Yes, let's also do that.

> 
>>>
>>>>
>>>> And without the patch of how TDX handles Exit (i.e., how deal with vp_enter_ret), it's hard to review this comment.
>>>>
>>>>> +        tdx->vp_enter_ret = TDX_SW_ERROR;
>>>>> +        return EXIT_FASTPATH_NONE;
>>>>> +    }
>>>>> +
>>>>> +    trace_kvm_entry(vcpu, force_immediate_exit);
>>>>> +
>>>>> +    tdx_vcpu_enter_exit(vcpu);
>>>>> +
>>>>> +    vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>>>>> +    trace_kvm_exit(vcpu, KVM_ISA_VMX);
>>>>> +
>>>>> +    return EXIT_FASTPATH_NONE;
>>>>> +}
>>>>> +
>>> [...]
>>


