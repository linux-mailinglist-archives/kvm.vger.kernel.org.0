Return-Path: <kvm+bounces-58535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA51B964D7
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21B6D1899525
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7E525B31B;
	Tue, 23 Sep 2025 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iE/o9gZZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB4121FF46;
	Tue, 23 Sep 2025 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758637792; cv=none; b=Tm+WHRrpQbrQr4DSseEcuNdgi8nXIsPPNv11kJNJ/oMq/MN6TmathKafGN1JetRu49oGw74lwxeOuxNd3oNd9ApREhSIFeGEkI+cd+0pNBeEyohB0ox501m9xh4ZJmC30xbGLyA5LJHpYbnumbWfmjP+M33PbBnTCSxkl9adlO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758637792; c=relaxed/simple;
	bh=hruTljb0URqYxOL2QAbMu1/HycqOjx60ccVzZB6vPbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kN4OXMSX9C738RQQPcKHePUHjHcjLJZVplXg5otdzz9LPbpEHqjQUefc3xcXuUWXE6xbBQPvs4378YHU0r9Q1ukvPTxqD9ghI5r0233vEaZD2Zrv7AQVvAx789qCAd8thuhIkPNBV2ogqEze9QaasVeoYDKT55ajkH6LN2oZzZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iE/o9gZZ; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758637791; x=1790173791;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hruTljb0URqYxOL2QAbMu1/HycqOjx60ccVzZB6vPbg=;
  b=iE/o9gZZa6qhv6aH3TvNeaNFFRta8IoVc16Z3VrkQvUTDEPkyR9+c90E
   avwH7BAF1FgQbOKZmTKaKT7aZ7lZ7O2XcbG0ZfhK+ZDKDk4JJXBZi8VhU
   +4NEPKPAzezyZNQ8eCgoaHejCqQxKAornwTd4bZuBS4oZriBKDKLGwKzU
   P5zgushrFAsdJiz1GawY0/2MfrYIsybg41K2Q7CUnfZ3dmJ+mAMXqIWet
   G6WnpuVzQGpiwbDu7ywWmSjPfxQ6oegfLp5cd4IXMWsB48FRaeaO6TDfG
   y0jBw9INuhlqUkGgyUtj4hTqPXZVFcBZoIeSYQ9EFx0Em+NFRsGL/rpbF
   A==;
X-CSE-ConnectionGUID: iOSlJcQKRL2wRAvKC4kCeQ==
X-CSE-MsgGUID: A7mmOGfaREW9o3e/uTxlnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60810329"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="60810329"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:29:50 -0700
X-CSE-ConnectionGUID: sIBNKXhKTVOSMz4bTexYzw==
X-CSE-MsgGUID: Rt9WRdoxSRWwfrJYkNjzYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="177553911"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:29:46 -0700
Message-ID: <cd2d17b2-59e8-45eb-ba1e-0f3160d5beb5@intel.com>
Date: Tue, 23 Sep 2025 22:29:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 20/51] KVM: x86: Emulate SSP[63:32]!=0 #GP(0) for FAR
 JMP to 32-bit mode
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-21-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919223258.1604852-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Emulate the Shadow Stack restriction that the current SSP must be a 32-bit
> value on a FAR JMP from 64-bit mode to compatibility mode.  From the SDM's
> pseudocode for FAR JMP:
> 
>    IF ShadowStackEnabled(CPL)
>      IF (IA32_EFER.LMA and DEST(segment selector).L) = 0
>        (* If target is legacy or compatibility mode then the SSP must be in low 4GB *)
>        IF (SSP & 0xFFFFFFFF00000000 != 0); THEN
>          #GP(0);
>        FI;
>      FI;
>    FI;
> 
> Note, only the current CPL needs to be considered, as FAR JMP can't be
> used for inter-privilege level transfers, and KVM rejects emulation of all
> other far branch instructions when Shadow Stacks are enabled.
> 
> To give the emulator access to GUEST_SSP, special case handling
> MSR_KVM_INTERNAL_GUEST_SSP in emulator_get_msr() to treat the access as a
> host access (KVM doesn't allow guest accesses to internal "MSRs").  The
> ->get_msr() API is only used for implicit accesses from the emulator, i.e.
> is only used with hardcoded MSR indices, and so any access to
> MSR_KVM_INTERNAL_GUEST_SSP is guaranteed to be from KVM, i.e. not from the
> guest via RDMSR.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

