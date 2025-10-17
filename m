Return-Path: <kvm+bounces-60270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FCEDBE62BF
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 04:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D55A5E2FF3
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061F32494F8;
	Fri, 17 Oct 2025 02:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jjtoKwig"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69137081E;
	Fri, 17 Oct 2025 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760669799; cv=none; b=tXzV6k+nfdj9LXln2kuTrlSUpcKfzdXQqbMCi0ClbMyo9Pri+zxL/737XgHFbhUAkYHBiFTF/1rROrjJoz4r7pR1208KiFjEVWQoVy8QpFcGD3Fd/odZkhoG1C+nuA3aVyhwrulfV5UMb1+nWqy7b0/cSwIOSMvp/BpaWjRR1HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760669799; c=relaxed/simple;
	bh=vXnURBvfiB2h0YMQINzhrybelau+KEViF3sr2RyRjko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uCou3oUX5NgMBJgkqzQWLjjOYz7o7DjjP5cLbMavd7NC3qN7+C3i4xRBxMltNuYZORG5zKnhzS8sjf2xu13eR4wRNkWui0o1e5V8dpYQ0n7uy8+Xr8GPp6tKgWlYp36e5Vq+xpBPFoY1rTfdBy7fMRGey5hDXvrCJ/x4aXEs188=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jjtoKwig; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760669798; x=1792205798;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vXnURBvfiB2h0YMQINzhrybelau+KEViF3sr2RyRjko=;
  b=jjtoKwigUkonxXXSkN5pWsl6WWq97buuwq7Kaj+nnfnszOSI8av8UoQo
   wWQcY829600Qs+62L81wOvNl4AkDd2Tn1CTQ+pHuW5yy2P7MgrRbdIgzk
   iZcBrBFP+3H+Vp0dXhc1WKqIvIau/4Z+57hRJWfaf/w3hI7u7vCE8GWPx
   dvR6NoLmHDVdNxHUjsxD4TiYM0YAk6byYR/IWq3aDXFzyCjpJNgScndLj
   CP4YxaSqz68AQdhovNQJDghQBXX9dAaIOIEGDDirT5r5pulIUkHO7zGoV
   X/pZqUEwBKzGdlxUYhLHfar3xlDW4wrDhBPPSw/IeopFAiTmVHLXUTpo3
   g==;
X-CSE-ConnectionGUID: gB7/esHySEiQQ8X3lCW7ow==
X-CSE-MsgGUID: J39ZannoSD6ZUuWnGjQgUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62910735"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62910735"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 19:56:37 -0700
X-CSE-ConnectionGUID: atHUVHuERcuoDQk1yyuSTg==
X-CSE-MsgGUID: HV7KbpjNT2muYi0Ov465sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="187017099"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 19:56:35 -0700
Message-ID: <a2e1bf9c-eca1-4632-b786-f7b58847178d@intel.com>
Date: Fri, 17 Oct 2025 10:56:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way
 out to KVM
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
 <20251016182148.69085-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251016182148.69085-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/2025 2:21 AM, Sean Christopherson wrote:
> WARN if KVM observes a SEAMCALL VM-Exit while running a TD guest, as the
> TDX-Module is supposed to inject a #UD, per the "Unconditionally Blocked
> Instructions" section of the TDX-Module base specification.
> 
> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 097304bf1e1d..ffcfe95f224f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2148,6 +2148,9 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>   		 * - If it's not an MSMI, no need to do anything here.
>   		 */
>   		return 1;
> +	case EXIT_REASON_SEAMCALL:
> +		WARN_ON_ONCE(1);
> +		break;
>   	default:
>   		break;
>   	}


