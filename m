Return-Path: <kvm+bounces-58368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA83B8F8C0
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 10:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DF0618A11CA
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 08:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404502FE566;
	Mon, 22 Sep 2025 08:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hELNXOqE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A872EFDB5;
	Mon, 22 Sep 2025 08:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758529763; cv=none; b=tePXpmVkI4iriETgXpZw8iPNFsYHGHfs13FhQ7z17u4+TPO4ZozLxZcOMpNE7cQ1ctFDL4RwCccB8l3w/5mZ4N8bi/UFbO2+Qq+ZrkkFN8dfxFKjUOg5TICgZjXv+iZueZfQlcvQgxpg0c3S/W8tn3+BQkcTYhKUthefbv+4W5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758529763; c=relaxed/simple;
	bh=K7FUXxr4panYFb9ndrVlWxpuvrlJECaYA06OE+T4kg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fltXEX1nOXm0NvhSwh1/Yhesv0n58uowVJaCuY2bs2T6RQy0T4gZ7d+PPp6vH3qtquVgPY7gn1BboqdcREdlpnC5yHxYDgqLjjXDVV4t39XCJGLsnfR3vbHgvGn+UAkTN1h5JH2UjztHcRvfRUF9uijZ6uD76ZDk3ZJ1r0FrqlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hELNXOqE; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758529761; x=1790065761;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K7FUXxr4panYFb9ndrVlWxpuvrlJECaYA06OE+T4kg8=;
  b=hELNXOqENJINepg/TfiiBJnjasajyY2QLKq+YPHwdxk/7hqu3AH8fvsA
   WfXRHHkUD2kItTDsdL8ok3duvcjE9dE8cMVTkmxQFILofbtFYK3k3SnGr
   OZXlFmmjJfsMlYFjI6kO74AVh9fxZ2OUF+0Kwen63xT9otJsZSajRBHuo
   hrXb/DjXa3Pm6TzXFv3wpHuQv14zIRfAExWESgC0aSTM+9Rub90+i1Zsx
   Z7STpv0u8YsYMw3ih6iq7CfD5YYx93cIBHoVi8NxGnhwnC7uYXTlgU1oi
   68wSiH8J0zu/1NOY2B76vtFZnoWqLZ7MPWAba5kHN3/asgWIVd+xus6+/
   g==;
X-CSE-ConnectionGUID: 6b47iwUYSuiN8k0AjQmkNA==
X-CSE-MsgGUID: OS+8f9HQSKC75KeP3C2oGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="71463380"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="71463380"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:29:21 -0700
X-CSE-ConnectionGUID: IAnBXZMfStWaWQrpAw245g==
X-CSE-MsgGUID: xiDlI6urSDeuMHGKnB3pag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="207380739"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:29:18 -0700
Message-ID: <c6a43683-0b5e-4ab4-a0bd-30ffc883ef36@linux.intel.com>
Date: Mon, 22 Sep 2025 16:29:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 41/51] KVM: x86: Add human friendly formatting for
 #XM, and #VE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-42-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-42-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Add XM_VECTOR and VE_VECTOR pretty-printing for
> trace_kvm_inj_exception().
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/trace.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 57d79fd31df0..06da19b370c5 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -461,8 +461,8 @@ TRACE_EVENT(kvm_inj_virq,
>   
>   #define kvm_trace_sym_exc						\
>   	EXS(DE), EXS(DB), EXS(BP), EXS(OF), EXS(BR), EXS(UD), EXS(NM),	\
> -	EXS(DF), EXS(TS), EXS(NP), EXS(SS), EXS(GP), EXS(PF),		\
> -	EXS(MF), EXS(AC), EXS(MC)
> +	EXS(DF), EXS(TS), EXS(NP), EXS(SS), EXS(GP), EXS(PF), EXS(MF),	\
> +	EXS(AC), EXS(MC), EXS(XM), EXS(VE)
>   
>   /*
>    * Tracepoint for kvm interrupt injection:


