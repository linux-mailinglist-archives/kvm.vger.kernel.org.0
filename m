Return-Path: <kvm+bounces-12635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E6088B616
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 01:29:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 28DA6B2D9DF
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E70883A1F;
	Mon, 25 Mar 2024 23:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HEg/B1+M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C25C81207;
	Mon, 25 Mar 2024 23:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711409731; cv=none; b=DeSvceZ4kaSmMS1JKZZ7gzfVDgxBLtf4LscEdAlzFMlDAaHc28cDSqBnMkVYk2fiHACxU1GMzm2GD8dtezHQbQwxL9Ki8MbBpKYUzxRt42qs6ycjS6EHPVaSB6tbFMFFsK/GYJz+f5uk1J01gtASCgRM00mJkabpO4GNBRfyWU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711409731; c=relaxed/simple;
	bh=J59xWjUPon0R/XloDWvoBmR+mCac40WYEwIramAsVkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQL/6mTwkYHc4mPMMRrpvJdowyWQyvQFljb3Otaizz04+E2KFr+orRlPpayVO6O8NRk1bN9AqcwjJR6Ijdvg0J3HFjTzqfLnd0Civ4IPtGCFcXBuj/j09Pw6CGFy1kuuu6K7IK0sE4lihX8mL+7EJ9zdankbYyUtEaJklIUCdxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HEg/B1+M; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711409730; x=1742945730;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=J59xWjUPon0R/XloDWvoBmR+mCac40WYEwIramAsVkQ=;
  b=HEg/B1+M3TWGjUWe0k7X7AQ4qsl6+Qq3Uai8YK0onC9ZKRYzmtX3YRCO
   PgCGbCqsg2h959ucuqPdQp4rBjMQs66/ntkHDUhIFP3pLrrdpDPvekXhn
   zle7s9UAs+6REwPz5Qc1V/3A3wvhKbY1BnQ4+hlvYgaesIBMY+AT1tSy8
   71ImdwW7fhS+9u+u/v96uuqIXWTKUURtaMsM+xWvLfdvzxkUj9EhHV8We
   WtTinkIBoXJDJ5NhEx6fOREBZQlqYsws/t1lp2R62I1Gh30O4dHLMYf+J
   y7NaZjw4Qh0664v/o5ntBkRfSKZurzFxZnLqtZz4XPioHUu8DFEFsOAB8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="17171693"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="17171693"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 16:35:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="15809290"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 16:35:29 -0700
Date: Mon, 25 Mar 2024 16:35:28 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240325233528.GQ2357401@ls.amr.corp.intel.com>
References: <20240319235654.GC1994522@ls.amr.corp.intel.com>
 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
 <20240321225910.GU1994522@ls.amr.corp.intel.com>
 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
 <20240325221836.GO2357401@ls.amr.corp.intel.com>
 <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>

On Mon, Mar 25, 2024 at 11:21:17PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-03-25 at 16:10 -0700, Isaku Yamahata wrote:
> > > > My understanding is that Sean prefers to exit to userspace when KVM can't handle something,
> > > > versus
> > > > making up behavior that keeps known guests alive. So I would think we should change this patch
> > > > to
> > > > only be about not using the zapping roots optimization. Then a separate patch should exit to
> > > > userspace on attempt to use MTRRs. And we ignore the APIC one.
> > > > 
> > > > This is trying to guess what maintainers would want here. I'm less sure what Paolo prefers.
> > > 
> > > When we hit KVM_MSR_FILTER, the current implementation ignores it and makes it
> > > error to guest.  Surely we should make it KVM_EXIT_X86_{RDMSR, WRMSR}, instead.
> > > It's aligns with the existing implementation(default VM and SW-protected) and
> > > more flexible.
> > 
> > Something like this for "112/130 KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall"
> > Compile only tested at this point.
> 
> Seems reasonable to me. Does QEMU configure a special set of MSRs to filter for TDX currently?

No for TDX at the moment.  We need to add such logic.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

