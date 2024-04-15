Return-Path: <kvm+bounces-14631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E34638A4A2F
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 10:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 124EA1C21405
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE21237163;
	Mon, 15 Apr 2024 08:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GAhEyjoK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97722CCA0;
	Mon, 15 Apr 2024 08:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713169065; cv=none; b=H4oMn89zjLOSm57VN9ghmT16173YLD9AnGFLQXZeDvdpL0fXP17k+6kPEY8uh7XzuBoDXLxPXg+40SbzwaPj/YYWCou3okSR4BtT12u+Z0Ru0o5/BQGlGmxF47cYU8rSYRX88zfgV/QylempH7L+qL/9jeiLcoIK/Y+xuWl5OIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713169065; c=relaxed/simple;
	bh=6OAv9QPri5z1S4Vu/PHhZDPi6HY+09W8Rpwi/+Gne9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q6yZFKLZMJFCVNbScBbCII43rz6TBD0DGf7fkrkwkajrZqlqWTPpgdNtOc4VuGm9PES8NibyfEBzSevqKUS+pdJUY9R2BEvO91PMr/+q2BhOCrDp+vd+Dl00YoyTVTiOuKKnO8dGrTF9r2lgZDCcb2GDOJxDvqNS+dJ4rzZr3Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GAhEyjoK; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713169063; x=1744705063;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6OAv9QPri5z1S4Vu/PHhZDPi6HY+09W8Rpwi/+Gne9g=;
  b=GAhEyjoKVFnvgEJDIX26FTV2Ac4l8XPuE8hX1Tmr8LhCxx8T1KOhcFow
   Vej1SrAI9pAnHdzXh4mJHeoDmVtzs5mwQ1fQJRnIPBuBIEqrf2I8p+OQh
   jOrB6oU3y6uizaGfreZUA56fXmIexvS3ibOIRlvnYUMf3t2N/ixOj/1xs
   w2FteqmCSAn4V+wtQsExqbcQl6F0yoBjN9Dcfl2nMg8g5QE3/BOZjQUn9
   UTqJEk56BLLHqxcTZNPXiAdfn291fQxCQ+F4xmryW04T3StA/UY8xUtmM
   1KRs7uderR0qMSU2IxX2MTKs1kDE+4BOK9fCW5K5MIShFB8/o8XFRX+nj
   w==;
X-CSE-ConnectionGUID: 7+9K7IA0QjmsFAZMVDY4Lw==
X-CSE-MsgGUID: LK4/fSn1S3Gi1+zLFBwzqA==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="8416341"
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="8416341"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 01:17:43 -0700
X-CSE-ConnectionGUID: mp2SmpmuTQGL5/2fIEBkAQ==
X-CSE-MsgGUID: ccew7FXfRxKGWXAxDFDtRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="26262909"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 01:17:39 -0700
Message-ID: <8aad3a39-dc7a-471e-a5f0-b3b1d5a51a00@intel.com>
Date: Mon, 15 Apr 2024 16:17:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:

...

> +
> +	kvm_tdx->tdcs_pa = tdcs_pa;
> +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> +		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
> +		if (err == TDX_RND_NO_ENTROPY) {
> +			/* Here it's hard to allow userspace to retry. */
> +			ret = -EBUSY;

So userspace is expected to stop creating TD and quit on this?

If so, it exposes an DOS attack surface that malicious users in another 
can drain the entropy with busy-loop on RDSEED.

Can you clarify why it's hard to allow userspace to retry? To me, it's 
OK to retry that "teardown" cleans everything up, and userspace and 
issue the KVM_TDX_INIT_VM again.

> +			goto teardown;
> +		}
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> +			ret = -EIO;
> +			goto teardown;
> +		}
> +	}
> +
> +	/*
> +	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> +	 * ioctl() to define the configure CPUID values for the TD.
> +	 */
> +	return 0;
> +
> +	/*
> +	 * The sequence for freeing resources from a partially initialized TD
> +	 * varies based on where in the initialization flow failure occurred.
> +	 * Simply use the full teardown and destroy, which naturally play nice
> +	 * with partial initialization.
> +	 */
> +teardown:
> +	for (; i < tdx_info->nr_tdcs_pages; i++) {
> +		if (tdcs_pa[i]) {
> +			free_page((unsigned long)__va(tdcs_pa[i]));
> +			tdcs_pa[i] = 0;
> +		}
> +	}
> +	if (!kvm_tdx->tdcs_pa)
> +		kfree(tdcs_pa);
> +	tdx_mmu_release_hkid(kvm);
> +	tdx_vm_free(kvm);
> +	return ret;
> +
> +free_packages:
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +free_tdcs:
> +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> +		if (tdcs_pa[i])
> +			free_page((unsigned long)__va(tdcs_pa[i]));
> +	}
> +	kfree(tdcs_pa);
> +	kvm_tdx->tdcs_pa = NULL;
> +
> +free_tdr:
> +	if (tdr_pa)
> +		free_page((unsigned long)__va(tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +free_hkid:
> +	if (is_hkid_assigned(kvm_tdx))
> +		tdx_hkid_free(kvm_tdx);
> +	return ret;
> +}
> +



