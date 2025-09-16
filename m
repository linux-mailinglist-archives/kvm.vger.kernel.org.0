Return-Path: <kvm+bounces-57683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C16DDB58EE1
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ECD952379A
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3392E5429;
	Tue, 16 Sep 2025 07:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NOqEFT0h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F522E11B0;
	Tue, 16 Sep 2025 07:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758006764; cv=none; b=H4NEeCYBhj0qPaXa93ANIyO/EMAuOChMb13XfkCn44hoMemNvySKjuLaH8Jvgs8A/FTr7X4QuqzjWbVdPEp1KAgRGg+hu0FXJRubceY6HWBg89bx2w+58qTlW/dXLzw/wmogBsUYXa2ruSFszJo3+tKIoXqhw4DfxRMM4EcZSiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758006764; c=relaxed/simple;
	bh=s95beaMcaffmyAeVE0mYN7MSCkKmMJwMmOYNqz3JrNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sgml9leRdAASLICo1eI4bQCru5KyJirLnfF7nvRX7DgfsvjZegaHqNObDXCt835jgjCk62l5rS+HoqUDuEE3q6gPlKh74lUXpZ9Kzk2cAKVpb+HBOY78hq7UZ0STGKWVniuOI3VF+7pwLe3xAPYkHfiudW44QDpR/6edCcrrh1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NOqEFT0h; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758006763; x=1789542763;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s95beaMcaffmyAeVE0mYN7MSCkKmMJwMmOYNqz3JrNE=;
  b=NOqEFT0hST83bWiWd5Nzil7A9ZASv0/aXXB8ijq2IMHrT0IXO9lK3jKc
   MkThR0F+1/XUifEJ/Bwsa90mnzXPno/PtqwNyV+aiKiuDJvl0FKmeJ7XW
   lNYpiGdEJx4X1w0ZZv3oyAOFfdXMUZfCFusX7uMmoGoPeGkYElr6elLP5
   eqv/oV+hOcaVHslQdcTVpEOH4zS48lb6xaOlv10cpA7MT+yDyzPzB02+9
   GVN161ssN8Fo7a5c9O3VfzObTCpAxNN9oe51HE0ip4CKr+DhS+VJEjsTC
   qF9AG4y+XhDwMYM4+6445Nu+cdeJoUAACeq4UO8YcL6vEKY/FomRFIGau
   A==;
X-CSE-ConnectionGUID: ts77xjOcT7qnX7ic9vZ3sQ==
X-CSE-MsgGUID: xb0o6BDSSsaSDG4FW/vE+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="70526493"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="70526493"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:12:43 -0700
X-CSE-ConnectionGUID: oMyjekWTTgGplDC4lDzylg==
X-CSE-MsgGUID: 02/409JsSDGe3zVVV41UOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="175650122"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:12:39 -0700
Message-ID: <28a6fa6f-26ab-458d-9f63-547d51dd6aa9@linux.intel.com>
Date: Tue, 16 Sep 2025 15:12:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 05/41] KVM: x86: Report XSS as to-be-saved if there
 are supported features
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-6-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> Add MSR_IA32_XSS to list of MSRs reported to userspace if supported_xss
> is non-zero, i.e. KVM supports at least one XSS based feature.
>
> Before enabling CET virtualization series, guest IA32_MSR_XSS is
> guaranteed to be 0, i.e., XSAVES/XRSTORS is executed in non-root mode
> with XSS == 0, which equals to the effect of XSAVE/XRSTOR.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/x86.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 771b7c883c66..3b4258b38ad8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -332,7 +332,7 @@ static const u32 msrs_to_save_base[] = {
>   	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
>   	MSR_IA32_UMWAIT_CONTROL,
>   
> -	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
> +	MSR_IA32_XFD, MSR_IA32_XFD_ERR, MSR_IA32_XSS,
>   };
>   
>   static const u32 msrs_to_save_pmu[] = {
> @@ -7499,6 +7499,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>   		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
>   			return;
>   		break;
> +	case MSR_IA32_XSS:
> +		if (!kvm_caps.supported_xss)
> +			return;
> +		break;
>   	default:
>   		break;
>   	}


