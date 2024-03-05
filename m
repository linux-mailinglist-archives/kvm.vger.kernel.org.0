Return-Path: <kvm+bounces-10883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D72A38717BB
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 09:13:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DA971F22240
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 08:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4310F8004E;
	Tue,  5 Mar 2024 08:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ADOCVDV7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EB67F7E9;
	Tue,  5 Mar 2024 08:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709626342; cv=none; b=I19bnlvUgCXg1dWdcLn0SrJg5oIgjwR+QiagQCw68Zhm9iqc+Mugf5ZIM9Y2rmfN55l1MwZUuXo5Uzh3Qm34n0tvSdrV3hxAMibZAlp5sIxrVHGmshkusrdq2y1GhxRpV2YWNEwe6r8cO2cpTWuErCVL9BwHfip66zsoQ2GTYyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709626342; c=relaxed/simple;
	bh=88ek+UxDG050RNVEu9EGg8jJALfsBYFXgvNa3kzC4ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekTUIuQXF90w9Az2Vuu55OThOa2SBT1/8a8lzhd4uwMJwOm+nF57TN1DAIKj7mVa0naGpVjuYgpeBtsSpVcmEl2A+sCIB+FGkP7RqxVMgOsmHbutN/KVyQxayIA5Xq3nVEbEehGd0n7GWZyYwTB8sJpgiFtfEptoDm/iOBeYwS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ADOCVDV7; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709626341; x=1741162341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=88ek+UxDG050RNVEu9EGg8jJALfsBYFXgvNa3kzC4ho=;
  b=ADOCVDV7aBjjxuj/jiZ5MIIlaFElcJMl0tBO7YGlhinF30bODbaBOONi
   CUMqpa+aZ7a5WTKOWiZj41E/tdAN4dSg3y0tXBX9f0TJ7YRs1Tp8UC+Jf
   /6/GCPReFn+9num0pSP+Hgk1XH8FMn3OJEO09sx8mtn4stV3rV8WYC8iP
   A9cEHFjUKwcO4qHtedvNBekaFQ42AMuQDeNssusIDnRw0dlAzsOXR2Jk5
   s7tBQsH9BtfH1NPq7U44FPXg3/4SnY9C6Cb9zydzzRnHR9dcAuNdIL93a
   OgzPEig739DR/UVlmNs3lBydQb5X+cbFV+PFN6OPfa7q3oyR7vznlzU+P
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="14743767"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="14743767"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 00:12:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="40282761"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 00:12:19 -0800
Date: Tue, 5 Mar 2024 00:12:19 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 008/130] x86/tdx: Warning with 32bit build
 shift-count-overflow
Message-ID: <20240305081219.GC10568@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a50918ba3415be4186a91161fe3bbd839153d8b2.1708933498.git.isaku.yamahata@intel.com>
 <2f6897c0-1b57-45b3-a1f1-9862b0e4c884@intel.com>
 <jvyz3nuz225ry6ss6hs42jyuvrytsnsi2l74cwibtt5sedaimb@v2vilg4mbhws>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <jvyz3nuz225ry6ss6hs42jyuvrytsnsi2l74cwibtt5sedaimb@v2vilg4mbhws>

On Fri, Mar 01, 2024 at 01:36:43PM +0200,
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> On Thu, Feb 29, 2024 at 11:49:13AM +1300, Huang, Kai wrote:
> > 
> > 
> > On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > This patch fixes the following warnings.
> > > 
> > >     In file included from arch/x86/kernel/asm-offsets.c:22:
> > >     arch/x86/include/asm/tdx.h:92:87: warning: shift count >= width of type [-Wshift-count-overflow]
> > >     arch/x86/include/asm/tdx.h:20:21: note: expanded from macro 'TDX_ERROR'
> > >     #define TDX_ERROR                       _BITUL(63)
> > > 
> > >                                             ^~~~~~~~~~
> > > 
> 
> I think you trim the warning message. I don't see the actual user of the
> define. Define itself will not generate the warning. You need to actually
> use it outside of preprocessor. I don't understand who would use it in
> 32-bit code. Maybe fixing it this way masking other issue.
>
> That said, I don't object the change itself. We just need to understand
> the context more.

v18 used it as stub function. v19 dropped it as the stub was not needed.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

