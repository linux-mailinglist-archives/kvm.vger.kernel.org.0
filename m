Return-Path: <kvm+bounces-32342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3189D592E
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 06:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B40F2833EC
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 05:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CAA165EE3;
	Fri, 22 Nov 2024 05:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TE+d7Xi9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8003B13C3D6;
	Fri, 22 Nov 2024 05:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732254978; cv=none; b=g+ISJ/1dsOAWbDwurJeAddF9VX7stK61g5b0lfbfCDej99GZ9IAxDzV3tOyZrE0kx4LcTW0phA2L/diMq9q7yhj2i++gWZIoNhs+OPqETRL/royoCdOGrcSfHECA7iHLZ10yILrsynUxzO9jUlx3hgtAlAEbOiVE77GeCMCTNxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732254978; c=relaxed/simple;
	bh=mVrb0/NxmqhX2KZitLzqNLMF0oQXVLmww7MyRTvzVsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QPQVEHkpt/2rmg/qQSPUjLsR5vqcatOWSc+GhIPRiixSDp4TnivDaozgdjvzU+AeFXUhE7jxXAp2l0Cma4oZ+UV2hVNgSbJSaCtpJR3A50o+lYg80FSL1kaIZViX2+bf6sMrK5/jVuuQMnIL3FgBHOdY82xEcZt1Oys+Pos0dyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TE+d7Xi9; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732254977; x=1763790977;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mVrb0/NxmqhX2KZitLzqNLMF0oQXVLmww7MyRTvzVsc=;
  b=TE+d7Xi9PilimPsfFvdtBP5if2vxqedIopFjWGiejqrp1BAuTbstGGu4
   uT602OypyL+UMw7gkiNFzwc64nnKj0AJG7fvp1zERudkQjJsvBrRGdl+a
   GS2tNzjHONoKeR1nEyU0DG2OmJ8oD7OPMzo4Si5hU3P0/5wYgKJ7z/faP
   N89wSPspGIzMbOKhvujiGoFNaK78IG8FpIcbOq+wmt5xiv1gyuZF5ZCoY
   U3O9M3jEkr/DCanFx/QOSjsgFZajepIxqUguIwXPNbZPqvqZQqNXJlZ9y
   qUiUAmZSobHO4kNz8/WWkCK4UPdB5UigEtFBWBbFwMv+bmOZTIXq6Nk3S
   Q==;
X-CSE-ConnectionGUID: m986vN7XRdSJKpep/1/oMQ==
X-CSE-MsgGUID: BDBd/W/5Tc+i/Dh2EJ3TQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="42911260"
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="42911260"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 21:56:17 -0800
X-CSE-ConnectionGUID: N9g3oiu/Ra6NDMK3MpKRGQ==
X-CSE-MsgGUID: Oj3tBr6BQRuHShF6V2n2zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="95560348"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.227.33]) ([10.124.227.33])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 21:56:13 -0800
Message-ID: <91eccab3-2740-4bb7-ac3f-35dea506a0de@linux.intel.com>
Date: Fri, 22 Nov 2024 13:56:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] KVM: TDX: Implement TDX vcpu enter/exit path
To: Xiaoyao Li <xiaoyao.li@intel.com>, Adrian Hunter
 <adrian.hunter@intel.com>, pbonzini@redhat.com, seanjc@google.com,
 kvm@vger.kernel.org, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-3-adrian.hunter@intel.com>
 <2f22aeeb-7109-4d3f-bcb7-58ef7f8e0d4c@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <2f22aeeb-7109-4d3f-bcb7-58ef7f8e0d4c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/22/2024 1:23 PM, Xiaoyao Li wrote:
[...]
>> +
>> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>> +{
>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>> +    /* TDX exit handle takes care of this error case. */
>> +    if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
>> +        /* Set to avoid collision with EXIT_REASON_EXCEPTION_NMI. */
>
> It seems the check fits better in tdx_vcpu_pre_run().

Indeed, it's cleaner to move the check to vcpu_pre_run.
Then no need to set the value to vp_enter_ret, and the comments are not
needed.

>
> And without the patch of how TDX handles Exit (i.e., how deal with vp_enter_ret), it's hard to review this comment.
>
>> +        tdx->vp_enter_ret = TDX_SW_ERROR;
>> +        return EXIT_FASTPATH_NONE;
>> +    }
>> +
>> +    trace_kvm_entry(vcpu, force_immediate_exit);
>> +
>> +    tdx_vcpu_enter_exit(vcpu);
>> +
>> +    vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>> +    trace_kvm_exit(vcpu, KVM_ISA_VMX);
>> +
>> +    return EXIT_FASTPATH_NONE;
>> +}
>> +
[...]

