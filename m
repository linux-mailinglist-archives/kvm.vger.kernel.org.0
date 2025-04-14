Return-Path: <kvm+bounces-43210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A2BA877D8
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 08:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A15F188CEF0
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 06:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A2F1A724C;
	Mon, 14 Apr 2025 06:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MuXXbFwh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB75064D;
	Mon, 14 Apr 2025 06:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744611881; cv=none; b=ekLvyVN6bhNCKvKXOcCdKUQ9OlMVMvx08QMfqxioRjxl2nsmz7l/R8fYFyI2UJxSjEFbfSbwfQStBK49DgwA0eeGJBA20NDChp4kDSsHndXVcIWwma+3WLdMgoyn3W3WU+W/BXQULXrFBPeOBXjgz3cERlAdC6TrILaqIyBezcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744611881; c=relaxed/simple;
	bh=udIJAgXR5SL2AhZqoa5YZiZlD+139gJPdgIKbintp4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q+RaXwLtIFIw6w5atTYhKXrJAMXxDMQ8emKFJt+ioTTJ0zwzU+TRlbezoEhKIHhnyGlTXfLKXoggunioihipx5wnbLbPmBrMwnmI79BzzcB3SZq/Ry6AAyr7LBAlFB4+dmECdlGdmA99gapvwWTVn0mCtwbctvrBE22Kuxaedbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MuXXbFwh; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744611880; x=1776147880;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=udIJAgXR5SL2AhZqoa5YZiZlD+139gJPdgIKbintp4o=;
  b=MuXXbFwhmmkGUyZNeec8I+7fuAF3N0+xZVgCNMxGYcFI+mwFfyadila8
   KpUbjC6zhoRg6ZIuuJHYqm65X88fr9BeF+5/f/xZIJAkiiz4gCrmiugYm
   kFxKE88S4Ui9WpdNMU182kGY2VjxpFiC1PCRTakGmZR4IH2DtQkyvknDq
   i5JzgEFLQr8PagMkZpJPbxilj9cQPQrRsv4Rn0RvHYIsSBFTC/vhHPYWF
   ZJxSU/JbnlioziXEPPm+qfRtmI7N+1F80RgstvWhw55FxvpDH75Z7WHuQ
   n/6ZgFoQwA+HaiSTMoJAj1Bzzi2dN2cOiOAZLU+8cBClsiLhJUW4353yp
   g==;
X-CSE-ConnectionGUID: 2HURah+KSXy5bGiuKxtYPA==
X-CSE-MsgGUID: fYLIQxmwTPqjr0RhieFN8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="57436096"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="57436096"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 23:24:39 -0700
X-CSE-ConnectionGUID: ueTyPhbeTJCQQn3leiozDQ==
X-CSE-MsgGUID: qdNAB7s2RO2RRH5lJ7K6ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129722861"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 23:24:35 -0700
Message-ID: <9ffccab8-5e77-4e55-bd92-f31058600e9f@intel.com>
Date: Mon, 14 Apr 2025 14:24:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20250324140849.2099723-1-chao.gao@intel.com>
 <Z_g-UQoZ8fQhVD_2@google.com> <Z/jWytoXdiGdCeXz@intel.com>
 <Z_lKE-GjP3WQrdkR@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z_lKE-GjP3WQrdkR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/2025 12:57 AM, Sean Christopherson wrote:
>> If a VMM wants to leverage the VMXOFF behavior, software enumeration
>> might be needed for nested virtualization. Using CPU F/M/S (SPR+) to
>> enumerate a behavior could be problematic for virtualization. Right?
> Yeah, F/M/S is a bad idea.  Architecturally, I think the behavior needs to be
> tied to support for SEAM.  Is there a safe-ish way to probe for SEAM support,
> without having to glean it from MSR_IA32_MKTME_KEYID_PARTITIONING?

yes, the bit 15 of MSR_IA32_MTRRCAP.

