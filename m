Return-Path: <kvm+bounces-51832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF13BAFDE1E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED0673B673C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF291FDE22;
	Wed,  9 Jul 2025 03:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UIkV8UMm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6D61E9B19;
	Wed,  9 Jul 2025 03:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752031905; cv=none; b=hYBrZDfiJlVIV06DORFnyRlmM3lcL/VkHaVuoC4qsDh8o+R+NUCL/A9GLmQQg8jsJpgxRgibzNjbeJYcTZ51l4uV/T5i4ZqAPcQQykP5rOS57s/+Csaq161N8/AkTkpzeaJAalDskPx0rSGVUgVKtn2QxVafT6PhOGnijWvHuq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752031905; c=relaxed/simple;
	bh=xGIuUaaocjK8kiuoAdV8Jf3heLndUvTMshbUkZUB6Rw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r/LJLIzvEtYVP6tBKDMqcotxzBJUkWVSbZFGOdaAi2j6HjKVp6X7vRMsGvBjAXiEM1lM7hIhY23wxEna8kL94UjmPG37LUYPACtV4OR0d5li6JBEhzmm6B4oQ9WreQ4G2fFLgCbACwxPtHEcHqAOUs3tWE+sEKX9+sYtHythSsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UIkV8UMm; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752031904; x=1783567904;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xGIuUaaocjK8kiuoAdV8Jf3heLndUvTMshbUkZUB6Rw=;
  b=UIkV8UMmK7QLSUn/d8NfvWsgLoiG99NrxtZAZN7CXvFjplxouScJNI05
   21ME3I0T1tw8QcTIOmhN79gZnwQcYuZJW42ozy6tOlEP8BImzym7hpm0F
   3rCq+6gaUSl+2lHMoH76FKykW8GhcRSCmkXP7EexbBsRIWrMhL+/TGn+q
   VVPJDj4wW8xEK/xMBnAP0bzX07b26xiADf2u488WGYIH8+dYzXr9My638
   nxgtKnPQfh7mJHTNbBoqVb57a2+upGYovBneLs9FTgf83S4SxX2Evtg//
   quvFALkvJygik+83iv1QJN/axADLrliXCeENsjqgJalA0SwzDh3OOGzEn
   A==;
X-CSE-ConnectionGUID: UOJlVpzPRCSAldtuQgXnNg==
X-CSE-MsgGUID: 8tOIYE/8TL6RdRhJdaW9tA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54138708"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54138708"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 20:31:44 -0700
X-CSE-ConnectionGUID: Mh0G1tYGRgGocxXY5Mf2bg==
X-CSE-MsgGUID: dTxAKNm4TGi8Gcy35H7dbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159972360"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 20:31:13 -0700
Message-ID: <4068a586-532f-4c87-bcd3-c345cbf168c0@intel.com>
Date: Wed, 9 Jul 2025 11:31:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] MAINTAINERS: Update the file list in the TDX entry.
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
 <20250708101922.50560-2-kirill.shutemov@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250708101922.50560-2-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/2025 6:19 PM, Kirill A. Shutemov wrote:
> Include files that were previously missed in the TDX entry file list.
> It also includes the recently added KVM enabling.

Side topic:

Could we add kvm maillist to the "L:" ?

So that KVM people can be aware of the changes on TDX.

> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>   MAINTAINERS | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 993ab3d3fde9..8071871ea59c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26952,12 +26952,18 @@ L:	linux-coco@lists.linux.dev
>   S:	Supported
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/tdx
>   F:	Documentation/ABI/testing/sysfs-devices-virtual-misc-tdx_guest
> +F:	Documentation/arch/x86/tdx.rst
> +F:	Documentation/virt/coco/tdx-guest.rst
> +F:	Documentation/virt/kvm/x86/intel-tdx.rst
>   F:	arch/x86/boot/compressed/tdx*
> +F:	arch/x86/boot/compressed/tdcall.S
>   F:	arch/x86/coco/tdx/
> -F:	arch/x86/include/asm/shared/tdx.h
> -F:	arch/x86/include/asm/tdx.h
> +F:	arch/x86/include/asm/shared/tdx*
> +F:	arch/x86/include/asm/tdx*
> +F:	arch/x86/kvm/vmx/tdx*
>   F:	arch/x86/virt/vmx/tdx/
> -F:	drivers/virt/coco/tdx-guest
> +F:	drivers/virt/coco/tdx-guest/
> +F:	tools/testing/selftests/tdx/
>   
>   X86 VDSO
>   M:	Andy Lutomirski <luto@kernel.org>


