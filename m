Return-Path: <kvm+bounces-37823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD78FA30553
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F01DC7A1F87
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164021EEA4B;
	Tue, 11 Feb 2025 08:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S3xJ+O8Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408811EE01A;
	Tue, 11 Feb 2025 08:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739261487; cv=none; b=loF5Y+2X8i80sCh5MOO1DDzIjsL3GdGy06KSbVGHKAOv7TL9QxCmNsGB8EmkIcSQXJZFikiXeiYi7r78bPuhYx15jVVNeNu+jIxfV57Gj5PssSgk9wUxcAMwuwPMIcy1GMpjDtEFIiur1ncbgWixex0yFv2rNvJwGbV6vYBD3L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739261487; c=relaxed/simple;
	bh=yAVS7/UAdzD+L/UiLjdpIB9yA3clBOoPXjHHpbPmdrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EltCtUOtzorhJBaSA1EUfOD5jkCd86gukQHV+Wv9dmQbA7yDRGJZ4B4U0lJevYoJkTuRavWOSbT7WuLj4VawbfXY65D4gFVA+jpFlq5zcOq6lc3E921VGmHBNyNW+/UPYndHd7SQE1NW0g3paskP44e782CnlvHUMiJiJr1JzUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S3xJ+O8Z; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739261485; x=1770797485;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yAVS7/UAdzD+L/UiLjdpIB9yA3clBOoPXjHHpbPmdrI=;
  b=S3xJ+O8ZjW5Gon8K4nx/B4tqwcuFI4jFv14WLH2k2qmjO8O9iU11J5yX
   5ceNDu2aFmOdn5XIoD9fl1EGds5nGbjDkky812rsy75w3xDfVPVaNQhmt
   j62Vj3nawzD8GjrvF0f+SXEOtMHoBZeianLEj+u5+Z1UItz1HfvWWFccc
   Y7WgpjsW9vepEsGUwVIDpCs5AFB/rRMQB/VleHFdDW2Z5mt9SIqosGrOI
   JfTgtqEpUSUslRuZvRrn93xYDTtoRQOzAIqN4pn/rhVvwaVj4n4mQQgMY
   QtXOQwpGMUbzEfEv4NO4AQyrH8p7+cc5czNrUKDPRt278rvkSuV3esBTP
   Q==;
X-CSE-ConnectionGUID: AsKC2jxwTEWysMyrCkcdGQ==
X-CSE-MsgGUID: b9H1H7b+Rv+5Z1UTU41xPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43796016"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43796016"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 00:11:24 -0800
X-CSE-ConnectionGUID: H8mAlub3QDCfbdM6yki3aw==
X-CSE-MsgGUID: 3absUTiSRt2P9pq/5lS9FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112265382"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 00:11:21 -0800
Message-ID: <926a035f-e375-4164-bcd8-736e65a1c0f7@linux.intel.com>
Date: Tue, 11 Feb 2025 16:11:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
To: Yan Zhao <yan.y.zhao@intel.com>, seanjc@google.com
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com,
 chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-6-binbin.wu@linux.intel.com>
 <Z6r0Q/zzjrDaHfXi@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z6r0Q/zzjrDaHfXi@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/11/2025 2:54 PM, Yan Zhao wrote:
> On Tue, Feb 11, 2025 at 10:54:39AM +0800, Binbin Wu wrote:
>> +static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>> +	if (vcpu->run->hypercall.ret) {
>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>> +		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
>> +		return 1;
>> +	}
>> +
>> +	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
>> +	if (tdx->map_gpa_next >= tdx->map_gpa_end)
>> +		return 1;
>> +
>> +	/*
>> +	 * Stop processing the remaining part if there is pending interrupt.
>> +	 * Skip checking pending virtual interrupt (reflected by
>> +	 * TDX_VCPU_STATE_DETAILS_INTR_PENDING bit) to save a seamcall because
>> +	 * if guest disabled interrupt, it's OK not returning back to guest
>> +	 * due to non-NMI interrupt. Also it's rare to TDVMCALL_MAP_GPA
>> +	 * immediately after STI or MOV/POP SS.
>> +	 */
>> +	if (pi_has_pending_interrupt(vcpu) ||
>> +	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
> Should here also use "kvm_vcpu_has_events()" to replace
> "pi_has_pending_interrupt(vcpu) ||
>   kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending" as Sean
> suggested at [1]?
>
> [1] https://lore.kernel.org/all/Z4rIGv4E7Jdmhl8P@google.com

For TDX guests, kvm_vcpu_has_events() will check pending virtual interrupt
via a SEAM call.  As noted in the comments, the check for pending virtual
interrupt is intentionally skipped to save the SEAM call. Additionally,
unnecessarily returning back to guest will has performance impact.

But according to the discussion thread above, it seems that Sean prioritized
code readability (i.e. reuse the common helper to make TDX code less special)
over performance considerations?

>
>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
>> +		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
>> +		return 1;
>> +	}
>> +
>> +	__tdx_map_gpa(tdx);
>> +	return 0;
>> +}
>   


