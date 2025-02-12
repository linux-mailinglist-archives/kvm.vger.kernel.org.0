Return-Path: <kvm+bounces-37952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03DE0A31E08
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 06:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFC2D1670E2
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 05:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E98F1FAC4D;
	Wed, 12 Feb 2025 05:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b5m6tyOJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCD11F9F64;
	Wed, 12 Feb 2025 05:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739338640; cv=none; b=q71fvyfpOfT/HrHxTrdhohMLE+nNxt67lw+Y3TsV0uPS1JVXl+JA8dVURb12OGGu/vo5f4cuRiFV3vKwXCuPYVFzaVoU2PkA61dZDKm3zlXUGbvAgI9U/hP/rNTVT9GcUDW1iaDY0tY5aY32HPOYxYLIHnaADsCrQ8xO3uDEVj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739338640; c=relaxed/simple;
	bh=tpdtplCxwD9o20O/r7cKITmzzmBLuF+M6Z2a5ZkB4GA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e+hepjALjPc8Z6HzL93ZFzR0XzsX6MMHE/FfPIYmdrWps5IlrAf4BP+NRFlCiZP40mb17NXJP7Z5qAotcARQba/YZBPv8F3KHyZwRTZOXe12VJpbMT+DH1Z3AjahOH0BRko0AwI7neitgbVafLLPsC4EKnqcay4M8ytTinfMCiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b5m6tyOJ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739338640; x=1770874640;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tpdtplCxwD9o20O/r7cKITmzzmBLuF+M6Z2a5ZkB4GA=;
  b=b5m6tyOJpUpsskdbLomeUjKsh/R+GIyZPGkr//2sr/dluOYbdGdQTBM5
   ooqydX/Wc2qCTmVon1k3ioIa1Aqe4wOuqRz3T7fsZoyNDjJyqn+Rk4ckd
   H22vvZ9t0SA0FRYaSKLeG2dpvcnyLvDNnQY0KhYqB3dgoQzmzyffAzWPb
   guVnhH0Kge9Kum5ZfE4thoBsa0TRxPuEVr33tn3Tjdhh9fpSRxoUcYMCR
   1ccGR5tQdKp3xGmFQYoHVo1oAdiHYCfaQVFZaYJ4jtHnPu8ozp9JrGRDx
   bpsI4KpaIwHmpFkU6OxJAeOLJtZIAbqKCmW6fBSsrlNQodsmpLTiItipz
   g==;
X-CSE-ConnectionGUID: jF1BPO3KTL+iUtMfqXm4sw==
X-CSE-MsgGUID: uq9SznljQ/W7KBQBIhnpYA==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="43633178"
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="43633178"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 21:37:19 -0800
X-CSE-ConnectionGUID: KMDW/hEDThe6WjOWgPWGXA==
X-CSE-MsgGUID: 6ZsTFlwDT02qdsj5KQJ2Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="112675074"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 21:37:15 -0800
Message-ID: <4b23f7c7-b5e6-41c9-bcae-bd1686b801a6@linux.intel.com>
Date: Wed, 12 Feb 2025 13:37:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
To: Sean Christopherson <seanjc@google.com>, xiaoyao.li@intel.com
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 tony.lindgren@intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-7-binbin.wu@linux.intel.com>
 <Z6vo5sRyXTbtYSev@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z6vo5sRyXTbtYSev@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/12/2025 8:18 AM, Sean Christopherson wrote:
> On Tue, Feb 11, 2025, Binbin Wu wrote:
>> +static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +	u64 reg_mask = tdx->vp_enter_args.rcx;
>> +	u64 *opt_regs;
>> +
>> +	/*
>> +	 * Skip sanity checks and let userspace decide what to do if sanity
>> +	 * checks fail.
>> +	 */
>> +	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>> +	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
>> +	/* Error codes. */
>> +	vcpu->run->system_event.data[0] = tdx->vp_enter_args.r12;
>> +	/* GPA of additional information page. */
>> +	vcpu->run->system_event.data[1] = tdx->vp_enter_args.r13;
>> +	/* Information passed via registers (up to 64 bytes). */
>> +	opt_regs = &vcpu->run->system_event.data[2];
>> +
>> +#define COPY_REG(REG, MASK)						\
>> +	do {								\
>> +		if (reg_mask & MASK) {					\
> Based on past experience with conditionally filling kvm_run fields, I think KVM
> should copy all registers and let userspace sort out the reg_mask.  Unless the
> guest passes an ASCII byte stream exactly as the GHCI suggests,
Yea, GHCI doesn't enforce it to be ASCII byte stream.

> the information
> is quite useless because userspace doesn't have reg_mask and so can't know what's
> in data[4], data[5], etc...  And I won't be the least bit surprised if guests
> deviate from the GHCI.

But it also confuses userspace if guests uses special protocol to pass
information other than ASCII byte stream.

Anyway, dumping all registers to userspace and let userspace to have all
the information passed from guest for parsing is definitely workable.

>
>> +			*opt_regs = tdx->vp_enter_args.REG;		\
>> +			opt_regs++;					\
>> +		}							\
>> +	} while (0)
>> +
>> +	/* The order is defined in GHCI. */
> Assuming I haven't missed something, to hell with the GCHI, just dump *all*
> registers, sorted by their index (ascending).  Including RAX (TDCALL), RBP, and
> RSP.
>


