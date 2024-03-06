Return-Path: <kvm+bounces-11204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B03E5874296
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1C9D1C22FCD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F374E1BDC4;
	Wed,  6 Mar 2024 22:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EiZIfPzR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575141B95B;
	Wed,  6 Mar 2024 22:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709763451; cv=none; b=qP2RS8/pOq1zb02xqfDoh4Catp+k3Ab0hmJzXUBYphALMepOdUyZbffRO730uoA6w6ilJCup2wvEUMOWsY0/7AlfQs3HL21k2qZTWyuFkpH1JQXUOfxxM1oaLI3wllk+UG46XwGhI21QHUz3glBy9BsimwgiV1FaUVd0egYOKgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709763451; c=relaxed/simple;
	bh=Q/HnkSBjRtmv2HAo1EODOvFiwirAxHCTijp7h5jPD2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lLEpuqolgxyoY+NOCwWSf3FOW79rXUuQ+BigGNtpRNA26kuVFuppMDFaIi9P0lKP+j1LXDp35WyaeOEiY8heGZIWE1St1f5kq/P87lsw2GIKTxQ5w+S8Fgy3k5rtjHKm5gAJzWn9UeENW1TgiHhXxc6kPDXMLOOCGJmGKD6Bec8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EiZIfPzR; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709763449; x=1741299449;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q/HnkSBjRtmv2HAo1EODOvFiwirAxHCTijp7h5jPD2M=;
  b=EiZIfPzRJRLESFLLnzJj3wl2e6+aQDb6XyVhK4FgftoE5ao7NdMm1/d8
   I4xnBJVSTo02Xhp4czfQuOOACSp6SCc3rVRpaMicqP+b7T5vBGYST6QLK
   2S++jmaQjLMoWAuEGrTmtqxnDuqBN6yIn+i3UuFfENO88hGOIt3EnDV1M
   dCrhgrFphs78580oODg6qR1EXw1S5iizWRoLqduqbv7IVRurV1mshbf1U
   zDSzdu7EsZ7f5y7UZAZRoOA+fnRAObvKJ0tQzwF4G1xmAr3hD3xHleEtq
   1BJT6n8PIH6OWzmpoMKy2TQHm8l+GtaYKLUn+gsEEOv8zoXWPg0QlzmSQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15054814"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15054814"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 14:17:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="40882683"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 14:17:28 -0800
Date: Wed, 6 Mar 2024 14:17:28 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v19 008/130] x86/tdx: Warning with 32bit build
 shift-count-overflow
Message-ID: <20240306221728.GB368614@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a50918ba3415be4186a91161fe3bbd839153d8b2.1708933498.git.isaku.yamahata@intel.com>
 <2f6897c0-1b57-45b3-a1f1-9862b0e4c884@intel.com>
 <jvyz3nuz225ry6ss6hs42jyuvrytsnsi2l74cwibtt5sedaimb@v2vilg4mbhws>
 <20240305081219.GC10568@ls.amr.corp.intel.com>
 <75adc31d-6632-4ea1-8191-dad1659e7b33@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <75adc31d-6632-4ea1-8191-dad1659e7b33@intel.com>

On Wed, Mar 06, 2024 at 10:35:43AM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 5/03/2024 9:12 pm, Isaku Yamahata wrote:
> > On Fri, Mar 01, 2024 at 01:36:43PM +0200,
> > "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> > 
> > > On Thu, Feb 29, 2024 at 11:49:13AM +1300, Huang, Kai wrote:
> > > > 
> > > > 
> > > > On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > 
> > > > > This patch fixes the following warnings.
> > > > > 
> > > > >      In file included from arch/x86/kernel/asm-offsets.c:22:
> > > > >      arch/x86/include/asm/tdx.h:92:87: warning: shift count >= width of type [-Wshift-count-overflow]
> > > > >      arch/x86/include/asm/tdx.h:20:21: note: expanded from macro 'TDX_ERROR'
> > > > >      #define TDX_ERROR                       _BITUL(63)
> > > > > 
> > > > >                                              ^~~~~~~~~~
> > > > > 
> > > 
> > > I think you trim the warning message. I don't see the actual user of the
> > > define. Define itself will not generate the warning. You need to actually
> > > use it outside of preprocessor. I don't understand who would use it in
> > > 32-bit code. Maybe fixing it this way masking other issue.
> > > 
> > > That said, I don't object the change itself. We just need to understand
> > > the context more.
> > 
> > v18 used it as stub function. v19 dropped it as the stub was not needed.
> 
> Sorry I literally don't understand what you are talking about here.
> 
> Please just clarify (at least):
> 
>  - Does this problem exist in upstream code?

No.

>  - If it does, what is the root cause, and how to reproduce?

v18 had a problem because it has stub function. v19 doesn't have problem because
it deleted the stub function.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

