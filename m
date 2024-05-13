Return-Path: <kvm+bounces-17292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DD18C3B37
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 776051C20F12
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 06:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DAB1465AA;
	Mon, 13 May 2024 06:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JjSwS+fp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B880F4F8BB;
	Mon, 13 May 2024 06:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715580914; cv=none; b=gRUq67IMNEM6DOufuEfCJZA03skvL8ZaLjfCv8u7zpPLjx4+ojG5gVj67AICmrqm2c6YjgR8aFneH3R5u6hr4FuCKedmzzl97c7twtN9J9/FxDsIz5fhLuwgrEzSiUJgl4Q256Hc5cf3Ajnva0lK9P6CUDSsX8aoaczpf0zMQwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715580914; c=relaxed/simple;
	bh=woyyRJfWwQY/0iUy76I+OrfK6KoO5Lu5JSyjFFCPgcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BaNdz2vhxe9sQSHQt61v1bYyk9SFIIppMNH7UhOw113GlDHaXkDUft13aqLhPcx4wMFWYObxXBjmI5PpnZgKLaW2OYRhIBWGuiQJF0RSAsQYM9Ct0mNmjlX7NqW/3pGDUp+py5Zx/Nm+g7ZlVQfMP1Gn1rwB/QdjuiibqCiDvbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JjSwS+fp; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715580913; x=1747116913;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=woyyRJfWwQY/0iUy76I+OrfK6KoO5Lu5JSyjFFCPgcc=;
  b=JjSwS+fp82yCBHyns4wzN5Q+wtiLPmO1l6Mn9UapLkElUKFARG/GrgGt
   9wi3XBzhGAmepgN655X3thJxpTgGkj2muzivRbTAxox47bm+SV9gbOBAM
   z4BIG59HwYQ/qe3LH7drHYcnH4dH4APNjOoIXRhlJpQbeFQKhavEbTtWg
   ATwegxlqL9g0HonsyYyBuSLGDUKt+tuW+XFwqdQ4of8PqtmZ3BvTiDspe
   K89SxM7ldx18voWv5cqTk9NtKSyqWt4oQJHIhWOL+qOUOYDulRfmGhdj4
   qriz/z2ms9IcB1NU51E0h+aNpeJSr11zKIM9AwiluG4LgFFsBRZEzzhCO
   A==;
X-CSE-ConnectionGUID: 9evSE74KQFyJpuoUHjKa5Q==
X-CSE-MsgGUID: 6Qs2zrqvRDOT1gmZGWxKIQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="15308936"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="15308936"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:15:11 -0700
X-CSE-ConnectionGUID: yfZe7SxYTO6ZXljKDKTpMg==
X-CSE-MsgGUID: UrTSZ0MMSA+mWEOgBSmzDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30794151"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:15:09 -0700
Message-ID: <4ec14e43-5497-4ce1-aae0-6d81e4d16e65@intel.com>
Date: Mon, 13 May 2024 14:15:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/17] KVM: x86/mmu: WARN and skip MMIO cache on private,
 reserved page faults
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-10-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-10-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> WARN and skip the emulated MMIO fastpath if a private, reserved page fault
> is encountered, as private+reserved should be an impossible combination
> (KVM should never create an MMIO SPTE for a private access).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-ID: <20240228024147.41573-9-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d52794663290..0d884d0b0f35 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5819,6 +5819,9 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>   
>   	r = RET_PF_INVALID;
>   	if (unlikely(error_code & PFERR_RSVD_MASK)) {
> +		if (WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))
> +			return -EFAULT;
> +
>   		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
>   		if (r == RET_PF_EMULATE)
>   			goto emulate;


