Return-Path: <kvm+bounces-29928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3068E9B446C
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61C971C2217C
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 08:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3528B2038DE;
	Tue, 29 Oct 2024 08:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cGVUXbnh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788F3204029;
	Tue, 29 Oct 2024 08:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730191318; cv=none; b=incVKjdUgGS9qZ9spk1XSZzZ3IBlOpLUt8naZMEdH4hWt1WSMKqKHwveGt0guJ0ZZZH4ykgTjuvnJFrp2aa7jH3d4duvW+uqWkcwltjZXYp9b8KJ87p0WZUiWY+815k+8yInvFEDeoiDsD11Ks4IFGEh/u8aeOUe5Ty7I1zCBb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730191318; c=relaxed/simple;
	bh=8ak5RGYBzjbtN3YpNDZddChuIs0PU12mBPClI1VjPNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OYWsrrfwc2kcWzfY7AyAsSE12NixxO12gwKsU55vmydUPWJyjfRr+urczHOiyNhtnqiEtpQWLmaz8OsmENFsN9JFBphAQRQcUuc4o4774bWtsfPMmgHg9Otw6LFBd3U1d5AtLoLaCtelX8rNGE3pDOLnxeXZ4s8rqfurDA0bkNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cGVUXbnh; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730191317; x=1761727317;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8ak5RGYBzjbtN3YpNDZddChuIs0PU12mBPClI1VjPNA=;
  b=cGVUXbnhfyIr2afvEz+nDwGLCjqX7FgrqmlqC80VfRAHsTulBdXfulfx
   APZLu8chr0NZqDim/20pdF3C80tyg/Cu0UPoWcOvtxFmxedAo1F+vtRRu
   YuQONX66MU1wL0t9Cq4XnRDWO24YuuEY+BSsWNBOimsn1CCKMtmAfS3YJ
   5/4yC/MAol8AKfa8Vd6sf1ilIHfcfnvypX4QbH3wiKyEmD7PLmidknwNO
   DbIRKcrW222H4/UGldS3PJUN3tR9BFPRXhh/6pd+gEKT/epexQqskHZRo
   brz2K/davsKqj1PiwuZRXdvf12mi89k6vrtHHWXzr0Gcce/ogffyj4IvG
   A==;
X-CSE-ConnectionGUID: yZhJjbmlTvuwN6UBtHwBBQ==
X-CSE-MsgGUID: mY5GHJ5LTzSd7t23tCaPqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30003572"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30003572"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 01:41:56 -0700
X-CSE-ConnectionGUID: /uckz70sTWSGcWNuTdkc/Q==
X-CSE-MsgGUID: +sVMFk6ZQzSDWFiR12Qkow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="86445491"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 01:41:52 -0700
Message-ID: <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
Date: Tue, 29 Oct 2024 16:41:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241028053431.3439593-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/2024 1:34 PM, Nikunj A Dadhania wrote:
> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
> used cannot be altered by the hypervisor once the guest is launched.
> 
> Secure TSC-enabled guests need to query TSC information from the AMD
> Security Processor. This communication channel is encrypted between the AMD
> Security Processor and the guest, with the hypervisor acting merely as a
> conduit to deliver the guest messages to the AMD Security Processor. Each
> message is protected with AEAD (AES-256 GCM). Use a minimal AES GCM library
> to encrypt and decrypt SNP guest messages for communication with the PSP.
> 
> Use mem_encrypt_init() to fetch SNP TSC information from the AMD Security
> Processor and initialize snp_tsc_scale and snp_tsc_offset.

Why do it inside mem_encrypt_init()?

It's better to introduce a snp_guest_init/setup() like tdx_early_init() 
to do all the SNP related setup stuff instead of scattering them all 
around the kernel code.

> During secondary
> CPU initialization, set the VMSA fields GUEST_TSC_SCALE (offset 2F0h) and
> GUEST_TSC_OFFSET (offset 2F8h) with snp_tsc_scale and snp_tsc_offset,
> respectively.
> 



