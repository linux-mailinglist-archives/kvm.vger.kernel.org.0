Return-Path: <kvm+bounces-11912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D45387D002
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 16:16:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B87AD282B64
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 15:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5189F4120B;
	Fri, 15 Mar 2024 15:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aCWcEKG7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450463F9E1;
	Fri, 15 Mar 2024 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710515787; cv=none; b=hHzX/iTTRl6VU8S+L3naiAbO9AcAoNhShvh0hED/9F+BCQGrFCYcHhuuqWreD0RC56YBIdpkkEylRF3UrO86o/01xzi5+zPpdXSk9aoLjrrDN33DvPUE0n1z0QwZgbqbrLtuWlLE/qD4EXRvT4ncUjYnLsnw18qB9VQBDxPK3xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710515787; c=relaxed/simple;
	bh=o49BdiajFQ3aTd3PiqpKmFj0FHckAeUVjjEOj6vZCDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBJ5qzWzlOAVPyecRomfdWYIgLA/C1trePno8O7nVXEWhuekl3/I94AUAIJ+r0xyaYuuvZy2wXxAqlCr1KjB4GGssz+u1sonO5PMOuhwIVh8Ako6YGVqKOM/NXpCmepZYWjZY+bV7tE1UAdoL1pkhpsohZRGO+vvFbi/SD6C4MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aCWcEKG7; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710515785; x=1742051785;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o49BdiajFQ3aTd3PiqpKmFj0FHckAeUVjjEOj6vZCDw=;
  b=aCWcEKG7LbcPXFkoEvGz5X07Y/SSQYW/U4AQAJ8JMo7CnV2lour2DJQN
   arOt6BMe/pIJI0ZhAOj5iXXE3a/vOiznEhzFqTHImRpriQZb22upwv5tb
   9zlI+Bk8e1bbUy3t9AcejoEhEbPtum73hxircWKmQbTD91uK1biHnEBrr
   IZyaHFO038L21pfaa+Bx6cPoF3vGRydNj6/J6Jt3vV/PzTWEzRFUUJBWY
   2IARslxsNFYWo8Dzo3L78h/qABP1/ccFNWDHj49LJ6AIqwHhFGX7cOsIA
   sp0nHi15U93lsTAKIqnmWHoE2z4CoAPtfD12hdo0BZMbZiZpnmQsCh5f0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="16036380"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="16036380"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 08:16:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="17420892"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa005.jf.intel.com with ESMTP; 15 Mar 2024 08:16:21 -0700
Date: Fri, 15 Mar 2024 23:30:11 +0800
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
Subject: Re: [PATCH v6 6/9] KVM: nVMX: Use macros and #defines in
 vmx_restore_vmx_basic()
Message-ID: <ZfRpg/IyJOQf60Wf@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309012725.1409949-7-seanjc@google.com>

On Fri, Mar 08, 2024 at 05:27:22PM -0800, Sean Christopherson wrote:
> Date: Fri,  8 Mar 2024 17:27:22 -0800
> From: Sean Christopherson <seanjc@google.com>
> Subject: [PATCH v6 6/9] KVM: nVMX: Use macros and #defines in
>  vmx_restore_vmx_basic()
> X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
> 
> From: Xin Li <xin3.li@intel.com>
> 
> Use macros in vmx_restore_vmx_basic() instead of open coding everything
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
>  arch/x86/kvm/vmx/nested.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


