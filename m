Return-Path: <kvm+bounces-11915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 356AA87D06D
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 16:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6D6328404D
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 15:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091D03FB1D;
	Fri, 15 Mar 2024 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ru4fDqPw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7D03D97F;
	Fri, 15 Mar 2024 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710517100; cv=none; b=K/PLCvZsnLdQ55SjtWxjbpnh4agNcOvOlhi6Kql9JEH/lu+Y9juj5WBVvHkXj51YVq48FtCINHpZuKwfF7Q8SIChCKkRk/no6XbyvayNB9YfZdPNemj5a1T41GPtdC/IgsXQVqGjZWhJRVlD9mykCu02U7b2LbPJQFj60y3TDbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710517100; c=relaxed/simple;
	bh=Yv7GWG66L6MKS+tklPfllW5x0ebZyHWQk2w657IjuTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTUb/c5dZaVAtzuDuI9e9esX38HTY0SJ86QLbWzNEKUgjsp7mfYmMmQjjLfS86/GgBSBvsKDjd29zp2hV89lpwKaxTJHX/2R00sa96YZZN1hJkRrG4mTriyB2w2igA2C6jO9BV1Ey4eW5wsNUQkk4/dQm9jHDx0ypogXYDDeQ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ru4fDqPw; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710517098; x=1742053098;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Yv7GWG66L6MKS+tklPfllW5x0ebZyHWQk2w657IjuTI=;
  b=Ru4fDqPw8Qu6EaQ6WXebbZ+6QQmgH3jndCIKOWSLc1c0+NaTHbQ3Y7rN
   Ke+oU3IDkF3o6ygSWzDufdU1XggYMxjgoKyJZUTa4VNajrrREDtRFZgat
   nWNTW4Xs6Np/Aq+xgkcmIpIsg1ZKK06WhZtUpqF3Eca/SfCJ3kjb8PDQc
   5+6u6fosgNG3L5m/3xvI7BraEedrkO0VPwyQsDdRioakzpvle4n0AmkDS
   vjhwjgqygQ0xY+CIK2qPtEZzya51NZKC/DGy3j/xGWKZ/tzK4CGTyUWto
   3Eq7imZXrAkLfuzNCVQ4AToN/rMcq/sR9K1VCbbeG119FeCn+cSrMEU7b
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="9225829"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="9225829"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 08:38:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="13115050"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 15 Mar 2024 08:38:14 -0700
Date: Fri, 15 Mar 2024 23:52:04 +0800
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
Subject: Re: [PATCH v6 9/9] KVM: nVMX: Use macros and #defines in
 vmx_restore_vmx_misc()
Message-ID: <ZfRupNB+eFNQC9l2@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-10-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309012725.1409949-10-seanjc@google.com>

On Fri, Mar 08, 2024 at 05:27:25PM -0800, Sean Christopherson wrote:
> Date: Fri,  8 Mar 2024 17:27:25 -0800
> From: Sean Christopherson <seanjc@google.com>
> Subject: [PATCH v6 9/9] KVM: nVMX: Use macros and #defines in
>  vmx_restore_vmx_misc()
> X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
> 
> From: Xin Li <xin3.li@intel.com>
> 
> Use macros in vmx_restore_vmx_misc() instead of open coding everything
> using BIT_ULL() and GENMASK_ULL().  Opportunistically split feature bits
> and reserved bits into separate variables, and add a comment explaining
> the subset logic (it's not immediately obvious that the set of feature
> bits is NOT the set of _supported_ feature bits).
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog, drop #defines]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


