Return-Path: <kvm+bounces-30280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE7B9B8B43
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 07:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A062B21B38
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 06:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB3814F9FA;
	Fri,  1 Nov 2024 06:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VW9gx1zr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485B713F42A;
	Fri,  1 Nov 2024 06:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730443152; cv=none; b=sOv1ECgAuj4oX9TJIx1jiyUH+0lDu0U2MQhE6r6Ppl8/H7Dd2idO0lA3drJqlyIobijzJib7Eagw/VzWZX5kX0Z0zL2Ve4Af5LfWifnmIjy0Sx1j8081/T6Beoh+NyV/8t6DArrPztdeZKGdqYZBa3USQ1Aej5RXj5e1Bnug8d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730443152; c=relaxed/simple;
	bh=Wi+2HazRFkOLh+eSIuNMSvpLmsxZ9NNS+5DDJmOlUII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=te3t31ICkpaKFs761M3MnJ/QzIcJJrpuQR2uKZk9r+uaVJSy9rizcJ13z76NTFRffQyx3XUKEWLYDOBUmbVyV22M71B7fev3QReS9XL54UPTw5PKxBNyxkfObOGi7WkLuT77ZG7UVAFsL2VMrsk7BcLdBo183o7/kKm+I8VrGVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VW9gx1zr; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730443151; x=1761979151;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Wi+2HazRFkOLh+eSIuNMSvpLmsxZ9NNS+5DDJmOlUII=;
  b=VW9gx1zrBCZ4TMjKYdEz8DCIk0tI/xQ/tXxw8nV1A8joHU6+oLKENnAx
   n9HdmHCPcFvGfst737jwsQnyhsNpZ6bYZPXK0+TcAZIjPoCmET/Dy1tFs
   D2OOQcbeeSeUpb1/B1+vjRM1BGBBCVCUkiap3oLqbdVTVYCtCLt7zBD9U
   1nr9CmzHNtSnJBJi22Zc140mcuf/qSblBQPn/JWxk3GYXwN1X4LWL/opj
   knAaGAAZx7Sy6KoT2y0wudtehn2Nzu4g4EbKc0p0oEEF8KNNEsouPTrkx
   kktucArZBRsVXnFYcGBnjCBDpLntjTQ2X8lH5iA60oKgV+wXpJ2ZrtWXK
   Q==;
X-CSE-ConnectionGUID: P3c/woD8SjKR3w+yYogDPw==
X-CSE-MsgGUID: hknjjrSsQ4qtgeAUwlkLyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40750461"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40750461"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 23:39:10 -0700
X-CSE-ConnectionGUID: QFvsIqq7Q8eK6AtxeByc6w==
X-CSE-MsgGUID: pJ4zTw9UTca72J+DFCa4Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="113668011"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.224.127]) ([10.124.224.127])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 23:39:07 -0700
Message-ID: <cb9225e3-3e06-41ba-9f30-d38d1555bb32@linux.intel.com>
Date: Fri, 1 Nov 2024 14:39:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: yan.y.zhao@intel.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 reinette.chatre@intel.com
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-25-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241030190039.77971-25-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 10/31/2024 3:00 AM, Rick Edgecombe wrote:
[...]
> +
> +#define TDX_MD_UNREADABLE_LEAF_MASK	GENMASK(30, 7)
> +#define TDX_MD_UNREADABLE_SUBLEAF_MASK	GENMASK(31, 7)
> +
> +static int tdx_read_cpuid(struct kvm_vcpu *vcpu, u32 leaf, u32 sub_leaf,
> +			  bool sub_leaf_set, struct kvm_cpuid_entry2 *out)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	u64 field_id = TD_MD_FIELD_ID_CPUID_VALUES;
> +	u64 ebx_eax, edx_ecx;
> +	u64 err = 0;
> +
> +	if (sub_leaf & TDX_MD_UNREADABLE_LEAF_MASK ||
> +	    sub_leaf_set & TDX_MD_UNREADABLE_SUBLEAF_MASK)
> +		return -EINVAL;
It looks weird.
Should be the following?

+	if (leaf & TDX_MD_UNREADABLE_LEAF_MASK ||
+	    sub_leaf & TDX_MD_UNREADABLE_SUBLEAF_MASK)
+		return -EINVAL;


> +
> +	/*
> +	 * bit 23:17, REVSERVED: reserved, must be 0;
> +	 * bit 16,    LEAF_31: leaf number bit 31;
> +	 * bit 15:9,  LEAF_6_0: leaf number bits 6:0, leaf bits 30:7 are
> +	 *                      implicitly 0;
> +	 * bit 8,     SUBLEAF_NA: sub-leaf not applicable flag;
> +	 * bit 7:1,   SUBLEAF_6_0: sub-leaf number bits 6:0. If SUBLEAF_NA is 1,
> +	 *                         the SUBLEAF_6_0 is all-1.
> +	 *                         sub-leaf bits 31:7 are implicitly 0;
> +	 * bit 0,     ELEMENT_I: Element index within field;
> +	 */
> +	field_id |= ((leaf & 0x80000000) ? 1 : 0) << 16;
> +	field_id |= (leaf & 0x7f) << 9;
> +	if (sub_leaf_set)
> +		field_id |= (sub_leaf & 0x7f) << 1;
> +	else
> +		field_id |= 0x1fe;
> +
> +	err = tdx_td_metadata_field_read(kvm_tdx, field_id, &ebx_eax);
> +	if (err) //TODO check for specific errors
> +		goto err_out;
> +
> +	out->eax = (u32) ebx_eax;
> +	out->ebx = (u32) (ebx_eax >> 32);
> +
> +	field_id++;
> +	err = tdx_td_metadata_field_read(kvm_tdx, field_id, &edx_ecx);
> +	/*
> +	 * It's weird that reading edx_ecx fails while reading ebx_eax
> +	 * succeeded.
> +	 */
> +	if (WARN_ON_ONCE(err))
> +		goto err_out;
> +
> +	out->ecx = (u32) edx_ecx;
> +	out->edx = (u32) (edx_ecx >> 32);
> +
> +	out->function = leaf;
> +	out->index = sub_leaf;
> +	out->flags |= sub_leaf_set ? KVM_CPUID_FLAG_SIGNIFCANT_INDEX : 0;
> +
> +	/*
> +	 * Work around missing support on old TDX modules, fetch
> +	 * guest maxpa from gfn_direct_bits.
> +	 */
> +	if (leaf == 0x80000008) {
> +		gpa_t gpa_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
> +		unsigned int g_maxpa = __ffs(gpa_bits) + 1;
> +
> +		out->eax = tdx_set_guest_phys_addr_bits(out->eax, g_maxpa);
> +	}
> +
> +	return 0;
> +
> +err_out:
> +	out->eax = 0;
> +	out->ebx = 0;
> +	out->ecx = 0;
> +	out->edx = 0;
> +
> +	return -EIO;
> +}
> +
>
[...]

