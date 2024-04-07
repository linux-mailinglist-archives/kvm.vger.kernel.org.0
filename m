Return-Path: <kvm+bounces-13815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3264789ADE8
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 03:42:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE751B223AF
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 01:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D648517FF;
	Sun,  7 Apr 2024 01:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mT8W+NiI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8618DA47;
	Sun,  7 Apr 2024 01:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712454151; cv=none; b=KzthdZwp4OkpLuopuFYbQkGnU+3sGAdAOSvhuA6sqnZ0IHSFq30o/Su6abgmL/AW4cW8G6XkisWCBeUWJIHr/N3FE5SNwkhXBzbO7T3akx0seOmpDX+dujfJBKpE8151YKt2T+8vbM46RvStZ1/0cqbMA8AV08k6Y71jMQPDRgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712454151; c=relaxed/simple;
	bh=yFSQzAmdtxceEVqM1iibcEA9yqxEDnDRJgDtfWm/MmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aHOQWfO1oavz5RElJoVBnR1szIs4Ucia2asHXWn/HX+I3nrQwRcy/kduqNoJC+KYRzYsb8uGWF/nq4o7YuSK0bbFPuTq/TapbTHdCTobyM7m5lnQB+4ODo0/vVtaBCY7epGrTCXOtSWeByaS6+8PVrgrKX0k2hNFATLbiUX/JvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mT8W+NiI; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712454149; x=1743990149;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yFSQzAmdtxceEVqM1iibcEA9yqxEDnDRJgDtfWm/MmA=;
  b=mT8W+NiIEHBNMPppFFsgJBulkP64D49C2N2nk0DjYR99szTJcYzPfkVx
   pEOEXylzt36wcSfIEipC9Z3tC2w8+Z+YjYu4aWayTP/NjI4FByfQTq2tf
   i4NHySCauxppT2R8S+INDktkqXR+WDtsAMMjvdqywmliCmuSCfhbU2ctO
   DEY2JIO0kde0oDLqG7jg+Ml5No47tIGIIiuKYF85DDl2c8r4FkHr8+Xk1
   eMPG0skhThOrlc/AbD0EruZXQxNq7j4P4hHrHR5nU+jqlw3li9Z0j5typ
   QjHc1Fubk5u6o0+h88e0Egrqy9gMIO8hDzP2zhtjW8NENHnt9OxUUFud1
   Q==;
X-CSE-ConnectionGUID: IKKBYyrfS/C5T7YQAv0OJA==
X-CSE-MsgGUID: QqUZrg2CRq6u8Dn8ns3vew==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="18479756"
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="18479756"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 18:42:28 -0700
X-CSE-ConnectionGUID: 9qd7h2htTBm6PyE3e/fKOw==
X-CSE-MsgGUID: Vbb+W9IjSQCE+G8m21pY2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="42693410"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 18:42:26 -0700
Message-ID: <c7c91b24-c7d0-4d82-b2a6-a6e9ff070132@linux.intel.com>
Date: Sun, 7 Apr 2024 09:42:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
 <ZfSExlemFMKjBtZb@google.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZfSExlemFMKjBtZb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/16/2024 1:26 AM, Sean Christopherson wrote:
> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
>> +	 */
>> +	struct kvm_vcpu *vcpu = &tdx->vcpu;
>> +
>> +	guest_state_enter_irqoff();
>> +
>> +	/*
>> +	 * TODO: optimization:
>> +	 * - Eliminate copy between args and vcpu->arch.regs.
>> +	 * - copyin/copyout registers only if (tdx->tdvmvall.regs_mask != 0)
>> +	 *   which means TDG.VP.VMCALL.
>> +	 */
>> +	args = (struct tdx_module_args) {
>> +		.rcx = tdx->tdvpr_pa,
>> +#define REG(reg, REG)	.reg = vcpu->arch.regs[VCPU_REGS_ ## REG]
> Organizing tdx_module_args's registers by volatile vs. non-volatile is asinine.
> This code should not need to exist.

Did you suggest to align the tdx_module_args with enum kvm_reg for GP 
registers, so it can be done by a simple mem copy?

>
>> +	WARN_ON_ONCE(!kvm_rebooting &&
>> +		     (tdx->exit_reason.full & TDX_SW_ERROR) == TDX_SW_ERROR);
>> +
>> +	guest_state_exit_irqoff();
>> +}
>> +
>>


