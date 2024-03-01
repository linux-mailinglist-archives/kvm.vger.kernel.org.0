Return-Path: <kvm+bounces-10635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ACF886E083
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32B5428D259
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26C56D1BF;
	Fri,  1 Mar 2024 11:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QVzUIz6x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4568D6BFC9;
	Fri,  1 Mar 2024 11:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709293010; cv=none; b=PwQmFfHNpWfY90SfWUfmtAKnLASMRXrRn7vYHmNWFB8sJXykbubCdib2CwPHgnPJy1tFkf3c5ommoBhIqbszMvQ+cLXy/rR1OpQ5EIte2Cq3G/EwatGo1TzuIrrMaKcQNsZdTV/zWxpbIK3eRxiTp05V6WgaR3w9mi3S+eXpj3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709293010; c=relaxed/simple;
	bh=VmuLKrIiPvi0d1zugpUUZmB0Q+nwGsD8HuFFE2t/am4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIdJWOs0rH38VuMIvo7GAUuP5uQN2jWU0ME+KIV9M5qIonUtEIHOHGZHT5Y6XjEugRTc2vw7bSB6PSmJ62yKob3nQJA9FGKP6iBsucRzjbFOG21UZO6dO7RJD3YhIG58ddZ+H5xnrYDnD+qh+I+f9yOSHGyDfOzEHHq08/vEwi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QVzUIz6x; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709293008; x=1740829008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VmuLKrIiPvi0d1zugpUUZmB0Q+nwGsD8HuFFE2t/am4=;
  b=QVzUIz6xWYgsyl68cfOKEBv0o1zzUu//hfk+PTP2RaJvJn9Ab7v5dV6x
   hv1uQdDRuKwniprGUCVRMhBYPLJ33K5S4JppTM7gmufLVjnJl008anzKx
   9QHA8VYxzjp93ydzoPFi4Ax2xtYDrVZxNJkGQrFmZ9lDakOku2tqHutX+
   ExO6o6BuXSlS4gA9jNQMZyFY7bvlTXZ7SyES1XT3OVHwWtQt316O95u6d
   gfeCJlgm933PMDgLvKGuZb05MB+/s++7qd5XJ75kO7yzzAJBwelvYo34s
   d1542xcTP0p7d+LMGs3iYoqIq2kVNh82R3R9TONoPx0cJMKzUTsqmEF3F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3688283"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="3688283"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:36:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="937037589"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="937037589"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 01 Mar 2024 03:36:44 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 621B93BC; Fri,  1 Mar 2024 13:36:43 +0200 (EET)
Date: Fri, 1 Mar 2024 13:36:43 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, 
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>, 
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v19 008/130] x86/tdx: Warning with 32bit build
 shift-count-overflow
Message-ID: <jvyz3nuz225ry6ss6hs42jyuvrytsnsi2l74cwibtt5sedaimb@v2vilg4mbhws>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a50918ba3415be4186a91161fe3bbd839153d8b2.1708933498.git.isaku.yamahata@intel.com>
 <2f6897c0-1b57-45b3-a1f1-9862b0e4c884@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f6897c0-1b57-45b3-a1f1-9862b0e4c884@intel.com>

On Thu, Feb 29, 2024 at 11:49:13AM +1300, Huang, Kai wrote:
> 
> 
> On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > This patch fixes the following warnings.
> > 
> >     In file included from arch/x86/kernel/asm-offsets.c:22:
> >     arch/x86/include/asm/tdx.h:92:87: warning: shift count >= width of type [-Wshift-count-overflow]
> >     arch/x86/include/asm/tdx.h:20:21: note: expanded from macro 'TDX_ERROR'
> >     #define TDX_ERROR                       _BITUL(63)
> > 
> >                                             ^~~~~~~~~~
> > 

I think you trim the warning message. I don't see the actual user of the
define. Define itself will not generate the warning. You need to actually
use it outside of preprocessor. I don't understand who would use it in
32-bit code. Maybe fixing it this way masking other issue.

That said, I don't object the change itself. We just need to understand
the context more.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

