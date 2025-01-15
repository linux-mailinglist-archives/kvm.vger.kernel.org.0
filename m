Return-Path: <kvm+bounces-35510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB76A11A19
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 07:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27A4F164891
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 06:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E0022FAE6;
	Wed, 15 Jan 2025 06:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MjhvJ/Fq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FA92D600;
	Wed, 15 Jan 2025 06:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736923882; cv=none; b=kGNbLZIkXLHGJsbfuxOZpOAosO6vV5fAasYiiHB1lIIxp5CzQm6qZ+DBisTZPTwMU2jwAksfWs9DwZlEnDMWM4Y4D+NIXuFSAys8HY/fkyfUkQt9hyeqzEHvLJsJU9N7ftm1Ee1Qdvkyqd0RLY5/qQBL+wtYr4niS3nr8hmeKNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736923882; c=relaxed/simple;
	bh=6x5GaOBazmJBVf45eIwSujIIlFSB06Lq9chIR+Hv2W0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UwqyVivTvQV4BYXDd4N8u1OtFNTVaoSLj9A4441kl5PJsdFcd0b20Yr5UqsrGVACnVlSPnxPk94I6Tg3EcB2AYUNtfaN0zUE8OoX+SpR3pVyrXg1Ha69/na6Efo1XwNCzuX1Dbn7RccMO0Rvr6iqttCocM7DQFspJ8f6SPLv38k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MjhvJ/Fq; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736923881; x=1768459881;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6x5GaOBazmJBVf45eIwSujIIlFSB06Lq9chIR+Hv2W0=;
  b=MjhvJ/FqyZLbLiEWccPGvepTqF8BLHU2uhyMG07u/YW7GB2bEs+PH3wb
   v7Ec7aVftpDlyEQ7xg3rpHPoqZNAciI63GE0diyL7GbikVYBgHKZngIZM
   1EvYRprbhxHtPQVBHA9EC76AnC8LoCTuQ3ZQkMvXseJzddUE17exCUDtV
   518Fwwna5dKcCdVxFquKpuDouniJ7d0cyovBUmGGwHmxmQFhM4OMkdXGU
   xuMkxWDuhjM8FGW7m2RmOS09xqGH4LEfyMlZV6qOOM7dD27oB9XzEhXBF
   2mRgFJIyjF9ECtT33nQqhHWuCs34uK6k3bCDOAnzuuJXHPoYxaG3dsXrj
   A==;
X-CSE-ConnectionGUID: t75v/38TQg6PJsJPKevJ5Q==
X-CSE-MsgGUID: iAfu5BBgQkazdlqIqlbgTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37130553"
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="37130553"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 22:51:21 -0800
X-CSE-ConnectionGUID: gg8kNBFbT5GiQB6/4wP1lw==
X-CSE-MsgGUID: V5Ql++XYRcOJvGVmyafDYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="110025655"
Received: from dliang1-mobl.ccr.corp.intel.com (HELO [10.238.10.216]) ([10.238.10.216])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 22:51:17 -0800
Message-ID: <67dd44fb-0211-4435-a294-b9f00dc681d8@linux.intel.com>
Date: Wed, 15 Jan 2025 14:51:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/18] KVM: TDX: Add methods to ignore accesses to CPU
 state
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
 <20241210004946.3718496-12-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241210004946.3718496-12-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 12/10/2024 8:49 AM, Binbin Wu wrote:
[...]
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 413359741085..4bf3a6dc66fc 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -733,8 +733,15 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   
>   	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
>   	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> -	vcpu->arch.guest_state_protected =
> -		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTR_DEBUG);
> +	/*
> +	 * TODO: support off-TD debug.  If TD DEBUG is enabled, guest state
> +	 * can be accessed. guest_state_protected = false. and kvm ioctl to
> +	 * access CPU states should be usable for user space VMM (e.g. qemu).
> +	 *
> +	 * vcpu->arch.guest_state_protected =
> +	 *	!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTR_DEBUG);
> +	 */
> +	vcpu->arch.guest_state_protected = true;
This was mistakenly introduced during re-base and should be discarded.


>   
>   	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
>   		vcpu->arch.xfd_no_write_intercept = true;
> @@ -2134,6 +2141,23 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   	}
>   }
>   
[...]

