Return-Path: <kvm+bounces-11910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD1E87CFA9
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 15:59:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29F061C2285E
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 14:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924E63D555;
	Fri, 15 Mar 2024 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qebpl8Q6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02953CF63;
	Fri, 15 Mar 2024 14:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710514759; cv=none; b=sPt3Rj/ri2xeCj27tcJ90tYzZMPpYe6GOvkWuO0qmtzpY/zxl9zNui6mV9jnc5/K1mzzOC81jJj6AXZRyJSGBOEqm7QJ3EW9ZTern5B6ZKQ7WYmUXfeozrwnVVq//NuQb2nXH+pX8dniElsNIs2M9PoOVRA8CitzFVqg3dUW66U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710514759; c=relaxed/simple;
	bh=47BI4UcF6xx/o1ML1/G+kkfRt13Gck99IbngyiBMNow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+NKCeweN4/8/eDYYleCB2RqDn2hQxIsEaehL479iEU+xILrdf9d5l0q4FbOh9Ko56vnSno9AEaPLSHeGNYk0vlha3AkCKW//+pacXO+C9IKu5p5YsG7usn2QTYlLcTTavOpcZ6IehDDBn/4tUc1WNH9aKXJQNtw1l/EUdAF/Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qebpl8Q6; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710514758; x=1742050758;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=47BI4UcF6xx/o1ML1/G+kkfRt13Gck99IbngyiBMNow=;
  b=Qebpl8Q6kTdVwYJ8HZWH8fI/m+wsXWyhtYCQzXjLrOHebPfPO2b5sLvv
   vkWHicosTBsdBMxyyNDSarJZlYWNkf7Vhezi7+aK7TpYrV0jhKCmHMw+T
   Bdc6r2HYj7pyowZPrkdzjynFbzf6X5T2Fooy4EjIHHA7NltVlNwj7NXOI
   qJm/KyJa/NAiJaP3V0QRjiqkgt1Xi4u0osYUuLl/+xe7qKG61EvCSdJ6p
   L7S61uNnWT8N7MjgDCrdZdTamyifFglZmUiaLNe10xq+/WI7T2PfvYUcF
   AB9rkwMEr3ENCbqwyWwFtCacSIkBxTVB5AO0iu12iIM6nsMTT78ox5Wx8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="8328159"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="8328159"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 07:59:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="17368888"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa004.jf.intel.com with ESMTP; 15 Mar 2024 07:59:14 -0700
Date: Fri, 15 Mar 2024 23:13:03 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Shan Kang <shan.kang@intel.com>,
	Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Subject: Re: [PATCH v6 4/9] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
 asm/vmx.h
Message-ID: <ZfRlf3o0reTkzsM5@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309012725.1409949-5-seanjc@google.com>

On Fri, Mar 08, 2024 at 05:27:20PM -0800, Sean Christopherson wrote:
> Date: Fri,  8 Mar 2024 17:27:20 -0800
> From: Sean Christopherson <seanjc@google.com>
> Subject: [PATCH v6 4/9] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
>  asm/vmx.h
> X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
> 
> From: Xin Li <xin3.li@intel.com>
> 
> Move the bit defines for MSR_IA32_VMX_BASIC from msr-index.h to vmx.h so
> that they are colocated with other VMX MSR bit defines, and with the
> helpers that extract specific information from an MSR_IA32_VMX_BASIC value.
> 
> Opportunistically use BIT_ULL() instead of open coding hex values.
> 
> Opportunistically rename VMX_BASIC_64 to VMX_BASIC_32BIT_PHYS_ADDR_ONLY,
> as "VMX_BASIC_64" is widly misleading.  The flag enumerates that addresses
> are limited to 32 bits, not that 64-bit addresses are allowed.
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/msr-index.h | 8 --------
>  arch/x86/include/asm/vmx.h       | 7 +++++++
>  2 files changed, 7 insertions(+), 8 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


