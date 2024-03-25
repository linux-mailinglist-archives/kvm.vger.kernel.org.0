Return-Path: <kvm+bounces-12616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48EC588B267
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73CD01C3369E
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B496DD08;
	Mon, 25 Mar 2024 21:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OIBlQ7rS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96EF5BACF;
	Mon, 25 Mar 2024 21:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711401037; cv=none; b=e1jU+Nh7WC3GX2VuOeB5gst+udlddH+ElegtusnbLz7MKCzGNCZqN5oas4TZGnM/3hUzokXRqxMN67E5isE6QS/tkvzvBAwGQDEQ0QXWWr73qnZtr5C7eS+3LAcnDFlf0u5I6UsETmT9jMb+7uz2o0hDv3Z4lFqOkgyOY/lOfeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711401037; c=relaxed/simple;
	bh=bD9EHdp5oUi2hIVxQ11FjGnl4+h7/y9I/u/Wkxfttt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZlA4gvDe8SiDvPofwuKmOgbiePNLLI2uAbOzw3qTjbqgPJebWGBf+rjSd8rdOshzO7gbEwpv8BIikYSrqnHw37FS8DAPBFXhhpMsUlM3UqvW5U1QVlrsJE2IXHpkeuj7L1Xr0h1bkb/1QnftRrj7e7XREfXwT3d8PF5ZLZsRdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OIBlQ7rS; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711401035; x=1742937035;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=bD9EHdp5oUi2hIVxQ11FjGnl4+h7/y9I/u/Wkxfttt0=;
  b=OIBlQ7rS5cozP0fkV+L4WWLXTYMuCMLnCbUMvyQpyYPcWx4/04svAuqP
   yMI6fZwSGiZ3xgAU43RLS2E5OzyqbUo9oNRw/H8IN/2CCsE/4NRsH0duH
   k6L1Ont5+LHn9RHIrGkQgD2qoFR7PNTT8ZYjDtxl20Et4SpbET3NrZGrB
   Z70SLy7xL528SxHCmIIhbd4/Ffp2nvJed5BehQEjUQJS+qzDK8AaqSmhZ
   bCfW4eHHrNIyUCRfrEXn2iIU1h1vravQHYyMIRF2A5wpk/8vbk1r4tOTm
   GM2/IMg5QnQ2or+JfxK80IKRa9aOOfaHgbJiMt4HAC5l4hfpAxhTdzMWs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="7024484"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="7024484"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:10:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="15825643"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:10:33 -0700
Date: Mon, 25 Mar 2024 14:10:33 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Message-ID: <20240325211033.GI2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
 <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
 <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
 <f019df484b2fb636b34f64b1126afa7d2b086c88.camel@intel.com>
 <bea6cb485ba67f0160c6455c77cf75e5b6f8eaf8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bea6cb485ba67f0160c6455c77cf75e5b6f8eaf8.camel@intel.com>

On Mon, Mar 25, 2024 at 11:14:21AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Fri, 2024-03-22 at 16:06 +0000, Edgecombe, Rick P wrote:
> > On Fri, 2024-03-22 at 07:10 +0000, Huang, Kai wrote:
> > > > I see that this was suggested by Sean, but can you explain the
> > > > problem
> > > > that this is working around? From the linked thread, it seems like
> > > > the
> > > > problem is what to do when userspace also calls SET_CPUID after
> > > > already
> > > > configuring CPUID to the TDX module in the special way. The choices
> > > > discussed included:
> > > > 1. Reject the call
> > > > 2. Check the consistency between the first CPUID configuration and
> > > > the
> > > > second one.
> > > > 
> > > > 1 is a lot simpler, but the reasoning for 2 is because "some KVM
> > > > code
> > > > paths rely on guest CPUID configuration" it seems. Is this a
> > > > hypothetical or real issue? Which code paths are problematic for
> > > > TDX/SNP?
> > > 
> > > There might be use case that TDX guest wants to use some CPUID which
> > > isn't handled by the TDX module but purely by KVM.  These (PV) CPUIDs
> > > need to be
> > > provided via KVM_SET_CPUID2.
> > 
> > Right, but are there any needed today? 
> > 
> 
> I am not sure.  Isaku may know better?

It's not needed to boot TD.  The check is safe guard.  The multiple of source of
cpuids can be inconsistent.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

