Return-Path: <kvm+bounces-24126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFDA9519AB
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:12:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9843C28365F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 11:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD161B011F;
	Wed, 14 Aug 2024 11:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d/c3zn+R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEF11AE86B;
	Wed, 14 Aug 2024 11:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723633900; cv=none; b=lMEMc5FbrXe3nJsW4LfIyN4r4Gjy9IwBqfY25xM3Q6mejZcp6SvZ1nJSomzdm0r7XZ+0vInu7Ayj+fJPgHA03bgqs/JK6poaClqrw0ZLqAW/XEWFf20GdrDs/a8RcYgKkm2PjCdsZa+XlNvljam463wQ4TgJibYNYQRiD+y2p8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723633900; c=relaxed/simple;
	bh=xqM5LZS0SvwsLy/HDNwBS2CgCRuPEeZDqlJFprF2lsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pw91TWP2Woy5ekOhbJKB7chEgUa1YglSOeFm+ONP97yX9TgxCpHtizsg6/eWj8Zz0gDO1Okz1OT8/u4yOs5QhrxHefUG3me8py15SrJsdgANol3WGrwu1IRqC2RXiWctaBi8u/CzqP+c2EFruouoUB1rzvkcNhjHee2Bp8pB7d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d/c3zn+R; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723633898; x=1755169898;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xqM5LZS0SvwsLy/HDNwBS2CgCRuPEeZDqlJFprF2lsY=;
  b=d/c3zn+RX46FhHzJmlQcdWYd1wxsymOzVEbZmwOukY4gB3iUT+7HMDR4
   Cn8Gdjl5LeIZmT3zFY1pBSP8y0VEirO1JHg8ZWBaplnhXqf/asK7KjPMV
   onXgIIxkMZBPvUA0h2AbnHQu1Q/SG1nVBKXv71xmKZWZXWEJgvhx7edqY
   9DfcOrodAdjrcg8gCN+R/IkJTVnZSeCTARHTL/++wFx/UmigPAHrLiS5J
   hOe2bpqpyVbXsSWp5NodMG9hxh2ZDzlPoyjwm+CCBoxRc9Lzx+MC9qKjp
   rBwbq61+m7ZsDJmOFTItB+tiElbM1Yh/2tM1wKw0gzE20DnYSEjfvNaYK
   w==;
X-CSE-ConnectionGUID: ZKy3UyHZS7aILLD/SrKoYg==
X-CSE-MsgGUID: NUYJii/kTze++ExYO1fIOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21485499"
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="21485499"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 04:11:37 -0700
X-CSE-ConnectionGUID: qZk2U76xR0uV+8vZTi8vMg==
X-CSE-MsgGUID: BVJlP2a/SPCbEAZ0xJ5dhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="63380508"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa005.fm.intel.com with ESMTP; 14 Aug 2024 04:11:35 -0700
Date: Wed, 14 Aug 2024 19:11:34 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerly Tng <ackerleytng@google.com>
Subject: Re: [PATCH 02/22] KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and
 only if the GVA is valid
Message-ID: <20240814111134.susqam5ecwdb26ky@yy-desk-7060>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240809190319.1710470-3-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Fri, Aug 09, 2024 at 12:02:59PM -0700, Sean Christopherson wrote:
> Set PFERR_GUEST_{FINAL,PAGE}_MASK based on EPT_VIOLATION_GVA_TRANSLATED if
> and only if EPT_VIOLATION_GVA_IS_VALID is also set in exit qualification.
> Per the SDM, bit 8 (EPT_VIOLATION_GVA_TRANSLATED) is valid if and only if
> bit 7 (EPT_VIOLATION_GVA_IS_VALID) is set, and is '0' if bit 7 is '0'.
>
>   Bit 7 (a.k.a. EPT_VIOLATION_GVA_IS_VALID)
>
>   Set if the guest linear-address field is valid.  The guest linear-address
>   field is valid for all EPT violations except those resulting from an
>   attempt to load the guest PDPTEs as part of the execution of the MOV CR
>   instruction and those due to trace-address pre-translation
>
>   Bit 8 (a.k.a. EPT_VIOLATION_GVA_TRANSLATED)
>
>   If bit 7 is 1:
>     • Set if the access causing the EPT violation is to a guest-physical
>       address that is the translation of a linear address.
>     • Clear if the access causing the EPT violation is to a paging-structure
>       entry as part of a page walk or the update of an accessed or dirty bit.
>       Reserved if bit 7 is 0 (cleared to 0).
>
> Failure to guard the logic on GVA_IS_VALID results in KVM marking the page
> fault as PFERR_GUEST_PAGE_MASK when there is no known GVA, which can put
> the vCPU into an infinite loop due to kvm_mmu_page_fault() getting false
> positive on its PFERR_NESTED_GUEST_PAGE logic (though only because that
> logic is also buggy/flawed).
>
> In practice, this is largely a non-issue because so GVA_IS_VALID is almost
> always set.  However, when TDX comes along, GVA_IS_VALID will *never* be
> set, as the TDX Module deliberately clears bits 12:7 in exit qualification,
> e.g. so that the faulting virtual address and other metadata that aren't
> practically useful for the hypervisor aren't leaked to the untrusted host.
>
>   When exit is due to EPT violation, bits 12-7 of the exit qualification
>   are cleared to 0.
>
> Fixes: eebed2438923 ("kvm: nVMX: Add support for fast unprotection of nested guest page tables")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f18c2d8c7476..52de013550e9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5804,8 +5804,9 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
>  		      ? PFERR_PRESENT_MASK : 0;
>
> -	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
> -	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> +	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
> +		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
> +			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>
>  	/*
>  	 * Check that the GPA doesn't exceed physical memory limits, as that is
> --
> 2.46.0.76.ge559c4bf1a-goog
>
>

