Return-Path: <kvm+bounces-58359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC559B8F435
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E8B4169E15
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CCE2F3614;
	Mon, 22 Sep 2025 07:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eH9HHVAg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBCDA59;
	Mon, 22 Sep 2025 07:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758525518; cv=none; b=tH+lGkSZaFSv2Q5NULLYJS1Q1/LIIwlYlhpQGL+OpazLomMV16u+KQ9pkgvXb4IgNL9RJTXmNoC0xU3X1Rbif73CYsuPODcPhtpasyAslG/8gYVgPSSOo5ufLSw+D8MjZBmoTHYau7Txdt/b01mYv05Wm/3kjlC4H5jMH5DiNpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758525518; c=relaxed/simple;
	bh=TSRV/nN75yMi1ybHk1PdJ4vt0PQ+gQfIrvR5pfbL+30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBvjBAk9dBc3E9YSrL+hU/GfWAgOX+f/xli1Qy9zOON5B1ezuXVGLyX2JjUpSwa7/stKtdK7W1GsjcPvIrM2ohsi9Gze6pSY6Xshfo/LoWq6an2XZbTUDdaKbK6a0CMGuSB9yCOCgqh+DMdPWis2e9xHqYrRq4jsqUxkOK7ccAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eH9HHVAg; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758525517; x=1790061517;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TSRV/nN75yMi1ybHk1PdJ4vt0PQ+gQfIrvR5pfbL+30=;
  b=eH9HHVAguWEUENRs8/430w4QR2M6lALlBG0xvgeHDud/kb3flTizx78c
   /7jc/qtrF+rDTAkmHTdKb+YuQ+BaiNfhT9k85AxudkxG3x+OCyrkiE8ac
   o7Xa6vdp4CYpKt7jAFWYdmpFbF242jLQRo4z6c44NC7ylVQPaCJcjIKq1
   jPBRcM/6rEi7V1sng/onXUDDa9O4xENea0VPwPv0U7d+Kdhj9TWO54giN
   RwuVSbxYbzjv6tfetBdl97DEeBrfGxPnPLcy/qW8rMKdc2Qu9MigaWGKL
   i7FznDiqlfDhZ/UL3f27EeNToB4s5drkJnwAkv1mG9gwADKzIqbYLp4zK
   A==;
X-CSE-ConnectionGUID: 8tZ0BPxpQLO9aqdj8R5DMw==
X-CSE-MsgGUID: 1pLYnlMpRSmXgZRI2UE2wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60898718"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="60898718"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:18:36 -0700
X-CSE-ConnectionGUID: 07kL62xkQpmHkLCuM74T8w==
X-CSE-MsgGUID: 19/0fEsjROWbQNPlsYI4lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="213554045"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:18:33 -0700
Message-ID: <8bf4690c-36ce-46cf-8646-5238ad65086a@linux.intel.com>
Date: Mon, 22 Sep 2025 15:18:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 22/51] KVM: x86/mmu: Pretty print PK, SS, and SGX
 flags in MMU tracepoints
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-23-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-23-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Add PK (Protection Keys), SS (Shadow Stacks), and SGX (Software Guard
> Extensions) to the set of #PF error flags handled via
> kvm_mmu_trace_pferr_flags.  While KVM doesn't expect PK or SS #PFs
Also SGX.

> in
> particular, pretty print their names instead of the raw hex value saves
> the user from having to go spelunking in the SDM to figure out what's
> going on.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

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


