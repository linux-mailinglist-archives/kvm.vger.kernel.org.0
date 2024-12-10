Return-Path: <kvm+bounces-33404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF919EAD29
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABCE928F375
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF35212D7D;
	Tue, 10 Dec 2024 09:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="erU/mSMO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6E9210F53
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 09:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733824359; cv=none; b=tqwnYiFv4Cb9jAP/x3xBiQMjjcN+AJkEk6Ow6tdfolnbA5eRw+TzJLeHZuuePQ+LimZNCmxBpA57Oo6AWIIkWugF7PvgWksf7zEj9fhFSLZyesO5ENcwXaiJTqczD9XIW9nf1vW25/bgwiMq7D7yS/wZxXwhGfka1ZV/+CDyHh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733824359; c=relaxed/simple;
	bh=mbt1Tzn3G4j9ikosL+IGehHKtsixKOT72u9Om4iub3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ToJY71c0rvG47LLhgt6n0CZYBXIHHT3wTe5oRv5/mCKJu5pLVj8jPg049fafMMKk/5VYP15o77U//w9sZp9n//BWP/dcljzlHqmQ/98ZrESyuwwU8WgYNOeEzdEoswi2BIL1taVY6+uda2tnKIiKPDADIirKaux/wQZ/fPb1zqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=erU/mSMO; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733824358; x=1765360358;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mbt1Tzn3G4j9ikosL+IGehHKtsixKOT72u9Om4iub3g=;
  b=erU/mSMOGabEmZs/xcjwvMJS4plnveNmkDjBaKIK1kfDKyA2+oovtAoX
   f+AlpLgMRhCUWqMITcFk6MK5Ki/6XEg8StzA0kGch3wfWSkMY5AMXJ3if
   SwMr9lRXUTL8mrRtPGGLU9d72svViM4QEmazYOkixNtCUO6xz+F4jATFZ
   7vt9MzCnI+granVFviZlOmw5oTte53PjCcE+VTJoenl0xwWOhRQ5XfSIa
   0qB8USSoPSs9T6Uv8jGrjx6D9prwGvXs5mTssp7EWJ0hHtBruPJ7pcZ+c
   aSoA99dBGhOU9f1do+SAkvenQ7H9JWI9UkqnzZyr1RE605TJJ++/F6Et1
   A==;
X-CSE-ConnectionGUID: ED8C0/SGT5qYAHIR9CtcKg==
X-CSE-MsgGUID: MBI3DcMXT5qQF9Xf99xXIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="34406650"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="34406650"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:52:38 -0800
X-CSE-ConnectionGUID: /DxWmtcJQC64gFNjONesog==
X-CSE-MsgGUID: b0omFVIfQhqoX2aWLCxWOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="95181525"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.246.224])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:52:33 -0800
Date: Tue, 10 Dec 2024 11:52:28 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Hunter, Adrian" <adrian.hunter@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
Message-ID: <Z1gPXHbwOaO8C9H3@tlindgre-MOBL1>
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
 <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com>

On Tue, Dec 10, 2024 at 11:22:39AM +0800, Xiaoyao Li wrote:
> On 12/7/2024 2:41 AM, Edgecombe, Rick P wrote:
> > As we've been working on this, I've started to wonder whether this is a halfway
> > solution that is not worth it. Today there are directly configurable bits,
> > XFAM/attribute controlled bits, other opt-ins (like #VE reduction). And this has
> > only gotten more complicated as time has gone on.
> > 
> > If we really want to fully solve the problem of userspace understanding which
> > configurations are possible, the TDX module would almost need to expose some
> > sort of CPUID logic DSL that could be used to evaluate user configuration.
> > 
> > On the other extreme we could just say, this kind of logic is just going to need
> > to be hand coded somewhere, like is currently done in the QEMU patches.
> 
> I think hand coded some specific handling for special case is acceptable
> when it's unavoidable. However, an auto-adaptive interface for general cases
> is always better than hand code/hard code something. E.g., current QEMU
> implementation hardcodes the fixed0 and fixed1 information based on TDX
> 1.5.06 spec. When different versions of TDX module have different fixed0 and
> fixed1 information, QEMU will needs interface to get the version of TDX
> module and maintain different information for each version of TDX module.
> It's a disaster IMHO.

While it would be nice to have the data available for the configuration
options, the code configuring the settings in QEMU still needs to
understand the meaning of the configuration options. So having the
configurable options data available in QEMU may not be that much better
from setting the information based on the detected version.

Maybe the revision specific information needed could be in a Linux
header file so kernel can use it too?

Regards,

Tony

