Return-Path: <kvm+bounces-32364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A70FC9D6054
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 15:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D5232828C2
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 14:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A655483A14;
	Fri, 22 Nov 2024 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ix+QncUW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2FE2AF12;
	Fri, 22 Nov 2024 14:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732286023; cv=none; b=DoeY5spGuGNRQbYKD0ElD3/c1KIswqPVv2J7Su1AQUrn0MQasZJnSuFJ9gNRDUJ1XLh/ZMnTWKWLOWf5Synk9YbcVRmroKI7lHxtNvposuV+Fgn92RB2K4gcJyHJoSSEXaV1cn9CIeF5lykdKDNX/Dg0OhD+512iYh3Foned2LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732286023; c=relaxed/simple;
	bh=36CxdThi0cT/QJPnfG6dSFlpyNfVpP3+IY6l53EPypA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YQjkKBhldPrsg/JhUPvCP8GUszKtiMAlW4BZEkz3yCSOL8BXq7mwOlOD8KbVDQUJXVVIXEyisUHEABJMdDGVQ89BjXGWZkmRpnODoy7d6RvIiGQhsvCDn00/K2sWdxkaYwMqP7wqCElA+fKAiPPbXp705K2cYdogyMUryOOSBwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ix+QncUW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732286021; x=1763822021;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=36CxdThi0cT/QJPnfG6dSFlpyNfVpP3+IY6l53EPypA=;
  b=ix+QncUWemUTwYDWKh4g2JpmKRsh1pAwcTJyKkMUy+zBEjihLZs8/itd
   jvLPk8JHb5sZADGrgAjUwoyqpLX8YJebJSOXKkH/Piy8pf3Ud589t8lxE
   pwvbkE5Ve/oelapnEZA7q02s2dDFz8yWwU6nIBg4Oh6Zpg7NyzO3DAV+p
   quMbb+070fBJfT18nQ8avzclcivTfAbErUZSaxKCBIz5y6NaKSjZ4P1Ug
   d5e4QluqsXz7FgGW7VIpc4EUkHI3wZpdmsIUqAq8gs9nP4t7rRE/IN/Jy
   pSlgJfigVu77CaG/lX+qW7oth4R2RXiA/aSs36ZJ7RPoM8wVTpOhnf3MK
   Q==;
X-CSE-ConnectionGUID: oXkKMafqQE64t8DuG2wecA==
X-CSE-MsgGUID: VbCpvwD2RvuhniRctBSU+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="57845028"
X-IronPort-AV: E=Sophos;i="6.12,175,1728975600"; 
   d="scan'208";a="57845028"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 06:33:41 -0800
X-CSE-ConnectionGUID: w80cp0sjRk+6MMoskNonKQ==
X-CSE-MsgGUID: FN4WnogZSYWs57cJaVDkKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,175,1728975600"; 
   d="scan'208";a="91005889"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 06:33:36 -0800
Message-ID: <837bbbc7-e7f3-4362-a745-310fe369f43d@intel.com>
Date: Fri, 22 Nov 2024 16:33:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] KVM: TDX: Implement TDX vcpu enter/exit path
To: Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-3-adrian.hunter@intel.com>
 <2f22aeeb-7109-4d3f-bcb7-58ef7f8e0d4c@intel.com>
 <91eccab3-2740-4bb7-ac3f-35dea506a0de@linux.intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <91eccab3-2740-4bb7-ac3f-35dea506a0de@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 22/11/24 07:56, Binbin Wu wrote:
> 
> 
> 
> On 11/22/2024 1:23 PM, Xiaoyao Li wrote:
> [...]
>>> +
>>> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>> +{
>>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>>> +
>>> +    /* TDX exit handle takes care of this error case. */
>>> +    if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
>>> +        /* Set to avoid collision with EXIT_REASON_EXCEPTION_NMI. */
>>
>> It seems the check fits better in tdx_vcpu_pre_run().
> 
> Indeed, it's cleaner to move the check to vcpu_pre_run.
> Then no need to set the value to vp_enter_ret, and the comments are not
> needed.

And we can take out the same check in tdx_handle_exit()
because it won't get there if ->vcpu_pre_run() fails.

> 
>>
>> And without the patch of how TDX handles Exit (i.e., how deal with vp_enter_ret), it's hard to review this comment.
>>
>>> +        tdx->vp_enter_ret = TDX_SW_ERROR;
>>> +        return EXIT_FASTPATH_NONE;
>>> +    }
>>> +
>>> +    trace_kvm_entry(vcpu, force_immediate_exit);
>>> +
>>> +    tdx_vcpu_enter_exit(vcpu);
>>> +
>>> +    vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>>> +    trace_kvm_exit(vcpu, KVM_ISA_VMX);
>>> +
>>> +    return EXIT_FASTPATH_NONE;
>>> +}
>>> +
> [...]


