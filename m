Return-Path: <kvm+bounces-7679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 330878452F0
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2C1B1F292AA
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 08:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CC615AAAC;
	Thu,  1 Feb 2024 08:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jgnklMa2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91A52E3FE;
	Thu,  1 Feb 2024 08:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706776905; cv=none; b=Fm2XbmSKBP5CQU0RdizUe4rRpLfO1PdlwvYUbBBN2zJpbIOn1n+CH9dXZCXNB+DmjIsPF+kc1RG7zD1Cjp+M3O18d1O/zV4OQr4q2j7eOBTEF/9lqRVzjOjz3Iop4UWVVpinip7DQEqhENXFR5uk6avS76e9rV0CdKu+6TOQHR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706776905; c=relaxed/simple;
	bh=VTaH4OKD+0kQFzbSZV77olKsxgKVO4SzwSYHx1uKUlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRyQ/OMsjdLduDZcvH8KNSuCEGjIX7QHJPAj1QoWCh/SesPwbzascxbAnXqXd1o5+s9hkHGxeJkoA3f4HjA06nTwTF8xhmsjAaKs+50SS1fVFteOSKzXqagrUmgVoPbGmY9AWBQjkCfqR/RMu4K1ZC9AOnLy1nKa7TZSNwSPTpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jgnklMa2; arc=none smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706776903; x=1738312903;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VTaH4OKD+0kQFzbSZV77olKsxgKVO4SzwSYHx1uKUlQ=;
  b=jgnklMa2AYkv0SLg+wedUt9MYG5O3nME/8tdi3C9USx9F/UCSnULR7aR
   X2s+Xv+zaPAm8n7+l7I5jGhdhDBxR2fTZqaqABipejFNnpiLsbNmbCGfX
   G8PgIKWST+dYyzDYuYRfTRU3qkzlTObj2fruzNi4JHHijMP+VCEr5ZZIr
   gAtOAnjUAeWGKrbY/womhz8T77f22A/45zdikZ03CI8fewwUL2NK7iygp
   AWC8h6P6mIg2laD9DjX1Ei4FXBlPlL8W6jw0zR34g/zZJ8xed30PCWVkY
   2SOuqvB9JTrPJzJKsTo4k9yvLTOTIHcw0dLFqr1rjyYxY6Eq97/nVS8Ku
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="403457233"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="403457233"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 00:41:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="879052024"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="879052024"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Feb 2024 00:41:40 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 49F0E789; Thu,  1 Feb 2024 10:33:55 +0200 (EET)
Date: Thu, 1 Feb 2024 10:33:55 +0200
From: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@kernel.org>, x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/cpu: allow reducing x86_phys_bits during
 early_identify_cpu()
Message-ID: <hhzgb6ymqhba3snzk5zjorxr57h6jykaedqftgm2veapsazfnd@ldwehefzpkfx>
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <20240131230902.1867092-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131230902.1867092-2-pbonzini@redhat.com>

On Thu, Feb 01, 2024 at 12:09:01AM +0100, Paolo Bonzini wrote:
> In commit fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct
> value straight away, instead of a two-phase approach"), the initialization
> of c->x86_phys_bits was moved after this_cpu->c_early_init(c).  This is
> incorrect because early_init_amd() expected to be able to reduce the
> value according to the contents of CPUID leaf 0x8000001f.
> 
> Fortunately, the bug was negated by init_amd()'s call to early_init_amd(),
> which does reduce x86_phys_bits in the end.  However, this is very
> late in the boot process and, most notably, the wrong value is used for
> x86_phys_bits when setting up MTRRs.
> 
> To fix this, call get_cpu_address_sizes() as soon as X86_FEATURE_CPUID is
> set/cleared, and c->extended_cpuid_level is retrieved.
> 
> Fixes: fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct value straight away, instead of a two-phase approach")
> Cc: Adam Dunlap <acdunlap@google.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

