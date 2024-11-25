Return-Path: <kvm+bounces-32418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4D29D848E
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:35:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFBFE284AB9
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4BA319645D;
	Mon, 25 Nov 2024 11:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QTikfHGb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176C3A35;
	Mon, 25 Nov 2024 11:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732534501; cv=none; b=BL3g12YdMklSq1HcXs6WG9++Q45+Zt+bZfCQh1a7E3wAEWqVcqYWLTBCazYjzqw9UiZNul5fAFRfFm0i3MIV7ExbMsDPVtsNA4yD89J5c6re40aKXZs1ASglW50XL1J4BqpzfRriWWBtPsTp1Wc8tMhczddtH5lIzHzFNyu69jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732534501; c=relaxed/simple;
	bh=nE25ptCziZyt2rMRHylAZKkIrgFhXXYeTgMji1bGAKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LzZfTOIkNGc4/vwg8yJQ0Zima5EhAfv806hVAJDAdim/vb2qyLONRge+hVcY6+o4z3eXqYDs//MVwJsOJUYpZDpiwDkD85WY20D49pdPKOdznYnbGNBXe2h8ttDyZKkPN368Y05h6IXalifq+/UsYI6QOms1nruxKr7HIrg3xBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QTikfHGb; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732534499; x=1764070499;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nE25ptCziZyt2rMRHylAZKkIrgFhXXYeTgMji1bGAKg=;
  b=QTikfHGbb0C1mgvnGXy+IoXPPEkGF4xVlsM+CmIt32JV/paUe6EKPCVi
   PCpzjRv3oypgpCJG54gXTkx+8wxV4s0WqoA8HkXBAQEsTaw3q4bo1ADdK
   OanAY9Mvq55p/FjNGe++xTBbuixIWdC55nYJyB71CSbv8lXLDGvNIh771
   6O2vORU3v80MAxesgW9R0xnfl83zFV+SlMjDWe2K3DgFbTtmOmrb00Fz6
   h7D2N3lVWiCzPyiqBab7x1rws1ZJRIigCTpactW5SlByM31jyE3bxqUMl
   EunZ1oQLMmMNB/jF4cLTdgLa9VdnyYh+foYnXnf5U4dpbkgAbYfQ4NDnv
   Q==;
X-CSE-ConnectionGUID: Y5vE7nf5QjmoGAHOgiIoEg==
X-CSE-MsgGUID: NKzm5fOATGKhEvTe1XDM8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11266"; a="50045451"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="50045451"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 03:34:58 -0800
X-CSE-ConnectionGUID: 0BxQcY3oQbKrYL87XFVbnw==
X-CSE-MsgGUID: haB6bASuTg2S/4F5fGHPoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="122077147"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 03:34:53 -0800
Message-ID: <87125f6d-8912-41ad-b01f-f6e68f8a6a89@intel.com>
Date: Mon, 25 Nov 2024 13:34:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z0AbZWd/avwcMoyX@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/11/24 07:49, Chao Gao wrote:
>> +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>> +
>> +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
>> +	    kvm_host.xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
>> +		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
>> +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
>> +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
>> +	    kvm_host.xss != (kvm_tdx->xfam &
>> +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
>> +			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)))
> 
> Should we drop CET/PT from this series? I think they are worth a new
> patch/series.
> 
>> +		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
>> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> 
> How about using cpu_feature_enabled()? It is used in kvm_load_host_xsave_state()
> It handles the case where CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not
> enabled.

Seems reasonable

> 
>> +	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
>> +		write_pkru(vcpu->arch.host_pkru);
> 
> If host_pkru happens to match the hardware value after TD-exits, the write can
> be omitted, similar to what is done above for xss and xcr0.
> 
>> +}


