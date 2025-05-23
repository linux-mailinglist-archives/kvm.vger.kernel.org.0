Return-Path: <kvm+bounces-47519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7A4AC1A0D
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 04:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12170A463A8
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 02:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCFD3204C2F;
	Fri, 23 May 2025 02:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cH4BWnIM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C942DCBE7;
	Fri, 23 May 2025 02:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747967271; cv=none; b=n/ZHgfjzVjho2p9NqyXTTNKS5sA21eISrgo8ixlRfiUvk9lLsw8IEOLzbujnm+UIqmxf71sk0CylGHAogNEz77BsSU/3bNK8Qmfy+6IpdaFmBlVDTUTb/VMgCf/kKjx/xCXEvZnOyq759omkr29Og+X7hn8NyCbHHLyyMS7VgnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747967271; c=relaxed/simple;
	bh=Kb1ndhhY2Sfz29ikvxUA4WsnJEdZhGEg0HU+XweW8xA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gFodlgwcWvLDUtfOKtvlaRNQTzMsBj/8Bms1UBzaZC2dbS4SxqyMLxw2flPB7ruz2TN8WfeSLjzZZnN22Z7iTMa4FQ2njrN3vsr+U1x3KEPt3QLmO7kFwS0qIY4TpjbYp0K1r3sepYsmxOGNX+9S3qVEuWDA1wsJEX5RaAonFuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cH4BWnIM; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747967269; x=1779503269;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Kb1ndhhY2Sfz29ikvxUA4WsnJEdZhGEg0HU+XweW8xA=;
  b=cH4BWnIMDCMtkhuS+dJxfVF0hJQjyWJm+5iIY1O75vFF4R8DrDEKSJUy
   EP7HNc9RmZeUU9prsIHj5jdMfEH8iVuQ/LOpv5bhIy29BaYZDNPl689Dm
   RNCaE//Uz0j16aM6rSoFw0yZzy4U/7ZJRLl6z1WXF/+j9lP0NY/Q+Ld9W
   rCEE9G+JVl2L3N8me3/2A9Gl9Xw9GmUnZ7fyUwYUDWfhQUSJ49Kp1gory
   n65bl87PjKC/oG+WWH4qhaeHJAniMuCYc1zeGsmdLMUDE2t3hWGbZdgRf
   6Esz9aseVesMwQEk8k7GIAzTdLeS3S/rvVzCT6TAd+pjI2OO5EjOa0FMm
   w==;
X-CSE-ConnectionGUID: foU8QiswROiUqvCy7SiEuA==
X-CSE-MsgGUID: J/fPRCuFRd2wtjIJXHpG3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="67578588"
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="67578588"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 19:27:48 -0700
X-CSE-ConnectionGUID: L9gYIFxdTcK3TbugnOnPTQ==
X-CSE-MsgGUID: jlP5GOQKSuiNyIM05ArIPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="171779502"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 19:27:47 -0700
Message-ID: <824cec81-768b-4216-968c-d36c59dac71d@intel.com>
Date: Fri, 23 May 2025 10:27:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] KVM: TDX: Move TDX hardware setup from main.c to
 tdx.c
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
References: <20250523001138.3182794-1-seanjc@google.com>
 <20250523001138.3182794-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250523001138.3182794-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/2025 8:11 AM, Sean Christopherson wrote:
> Move TDX hardware setup to tdx.c, as the code is obviously TDX specific,
> co-locating the setup with tdx_bringup() makes it easier to see and
> document the success_disable_tdx "error" path, and configuring the TDX
> specific hooks in tdx.c reduces the number of globally visible TDX symbols.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

...

> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 51f98443e8a2..ca39a9391db1 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -8,6 +8,7 @@
>   #ifdef CONFIG_KVM_INTEL_TDX
>   #include "common.h"
>   
> +void tdx_hardware_setup(void);

we need define stub function for the case of !CONFIG_KVM_INTEL_TDX

with it fixed,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


