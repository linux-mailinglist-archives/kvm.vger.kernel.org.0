Return-Path: <kvm+bounces-58539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3F4B966E7
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F901323163
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D3A25CC74;
	Tue, 23 Sep 2025 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bz/JnlPn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DA42441A6;
	Tue, 23 Sep 2025 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758638782; cv=none; b=pXPKItDH4XdRblpXQyrqAtCSKyobeLRlLAoJDil7I3eHIP16ikj4nXFbjvcdCik0arusVqzLG0Q/+3mi+jcsVcqB8ZmUvxbmPqBgSP1y4gmsTgxt9EfcwCHIcyEJMpaPS8efWkX+yoI6Eon40JXdMkxureoa6DpNqyBOxUIz1Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758638782; c=relaxed/simple;
	bh=CSLBYnRhltHH6gIJpgRO1I7BgBkribwe57VNZmC946M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jb2qD60WmZ4U6L5DeW7JuqEHSzMNUBzqfmEM1UPt1DRcQFOpt+GX0BSivTaEVNvdA7H65dvpVRLpj5YQWq2/SGYCktYmAyfrOdxkvNg9JL3cntBcZTANdqY2aCNtueS+wyofk0tbmnVhjoyOqg7Pbz8e08MwbXrmBr7s+6RsSzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bz/JnlPn; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758638780; x=1790174780;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CSLBYnRhltHH6gIJpgRO1I7BgBkribwe57VNZmC946M=;
  b=bz/JnlPnuVAZ+xr3leK1SmL/0sdEncp7yEJJOKSGvl+GaMZH/C73yr6E
   13R8r/mVuFt11fCfrCXIWx20eBfb952+t3pGDCv17/x5K3ZxYsPOKVn3o
   Vph8esdUI9feKodjkWTRYig+EWbx9kVownCDqEJT4rSFoFgd0yAB6V7gB
   xkdJjNLEom1LnXLS0vUbjXqCNWA4Dednz21E/Ounv6y+XbMGNrbXgm5BQ
   kEPBNhW+XEmtjfbTpOe8V163+RkJ4eJqv4aj/X68QzcNjGDnkmM5AMhpc
   LrPMbrwj6Z2Ykbsfcr+aKQwhpR0UVOT5vmqML8B7+MbpSvbGnbYCXXPpL
   A==;
X-CSE-ConnectionGUID: QimddnghR+ifX0D7d7YW4A==
X-CSE-MsgGUID: dQ9fehazTKqhaAgtwcAWig==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60975083"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="60975083"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:46:18 -0700
X-CSE-ConnectionGUID: r73OI1hfRASi4Wv8ViwIqg==
X-CSE-MsgGUID: OT1ExQVlTjqtLW/SyMypVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="182048441"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:46:15 -0700
Message-ID: <ca0e5e82-d03a-43e0-940b-a580c20ff450@intel.com>
Date: Tue, 23 Sep 2025 22:46:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 22/51] KVM: x86/mmu: Pretty print PK, SS, and SGX
 flags in MMU tracepoints
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-23-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919223258.1604852-23-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Add PK (Protection Keys), SS (Shadow Stacks), and SGX (Software Guard
> Extensions) to the set of #PF error flags handled via
> kvm_mmu_trace_pferr_flags.  While KVM doesn't expect PK or SS #PFs in
> particular, pretty print their names instead of the raw hex value saves
> the user from having to go spelunking in the SDM to figure out what's
> going on.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmutrace.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index f35a830ce469..764e3015d021 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -51,6 +51,9 @@
>   	{ PFERR_PRESENT_MASK, "P" },	\
>   	{ PFERR_WRITE_MASK, "W" },	\
>   	{ PFERR_USER_MASK, "U" },	\
> +	{ PFERR_PK_MASK, "PK" },	\
> +	{ PFERR_SS_MASK, "SS" },	\
> +	{ PFERR_SGX_MASK, "SGX" },	\
>   	{ PFERR_RSVD_MASK, "RSVD" },	\
>   	{ PFERR_FETCH_MASK, "F" }
>   


