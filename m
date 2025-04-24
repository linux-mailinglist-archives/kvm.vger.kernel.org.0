Return-Path: <kvm+bounces-44078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 431E3A9A29C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D6E67B04E1
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513661E5219;
	Thu, 24 Apr 2025 06:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d8VRBFB5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ECA84FAD
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 06:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745477525; cv=none; b=po2FFiCBgDJejarSeRZObpbbzLIWLj8DycPqyTGF2QY/VhKydvQ6MdVJs/OgPtHv1w+7CKVT/5834Y3vHue44/PLtS0YC9df6Jf7IN994X7o13iPxKoZ/AZ0NJGg0865b9+X6K2tBFoQ4XWTB8ouBlisRhpDZS1epwK/EeyaCes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745477525; c=relaxed/simple;
	bh=Z+pf2uLCHAVuTgZF2E4dT5Xc6nVOnomIMbeyicdunT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0ulzfc4VXIAKuC516twz2AjtIXYhBgUzpdjhmU7jtP/qMytcOK2/lh9OOzTLV3k2Zs3lzLf2Wf+6XYlPI31JAAEp9oy/s6CjWnfz5eZyRmGj/IENMtGLo/sjbI9kPbo9Jl6eat990nBlfuu1heXvuyx+3skzj5VDayq8oWtDZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d8VRBFB5; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745477524; x=1777013524;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Z+pf2uLCHAVuTgZF2E4dT5Xc6nVOnomIMbeyicdunT8=;
  b=d8VRBFB5J1eqlTK2Xms5xZXbeI4/LZNPvUwjccSFE3yeuHMzQyEsVrI1
   +r36y3qxOmmKVybXqIwAjtHvlEBzeNYoWco2/4OcgYMxePLxmCEqTt0U1
   aSj3cKori0I0eTnjm1ZP8zUg4NwBhfuVRC+T8DCH3PU3foPphLo+ITH9s
   uSShArwe9AE4pkZPi4q96/7hOev/d7qewWNngbmi3gwmPsOjm4ef9FnkC
   +OirLrqxTckFHq7bo9YjckQSpzFLRN/qQvj7NqV7GdNISm8ItWz9GBTy3
   oVJif1og0oroskgVeOzO1TXK2YwSLk6isfG3UF7j2Tc4szs+VoBFwoSaF
   g==;
X-CSE-ConnectionGUID: gXt2xE5qT8WmwJYVjflE7g==
X-CSE-MsgGUID: tdO3o1WXQFmwVK8A4W2YMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="46979336"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="46979336"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 23:52:03 -0700
X-CSE-ConnectionGUID: oWEFLy2zTx26jDxOa1cI5A==
X-CSE-MsgGUID: EK24my/PSCyKoktoi1NHXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="155761434"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 23 Apr 2025 23:52:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id A2BCF224; Thu, 24 Apr 2025 09:51:59 +0300 (EEST)
Date: Thu, 24 Apr 2025 09:51:59 +0300
From: "Shutemov, Kirill" <kirill.shutemov@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Wu, Binbin" <binbin.wu@intel.com>
Subject: Re: Drop "KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall"
Message-ID: <ej63wuy64m2ysxzeficvcorvrsmyyy375s4nn34xsizwwbuejn@joaj4hrmdb4d>
References: <da3e2f6bdc67b1b02d99a6b57ffc9df48a0f4743.camel@intel.com>
 <5e7e8cb7-27b2-416d-9262-e585034327be@redhat.com>
 <86730ddd2e0cd8d3a901ffbb8117d897211a9cd4.camel@intel.com>
 <CABgObfaMRjeyhnP+QvTcZ+jKb6q-opCQ_a_MBFbj3AYF0ZDewg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfaMRjeyhnP+QvTcZ+jKb6q-opCQ_a_MBFbj3AYF0ZDewg@mail.gmail.com>

On Wed, Apr 23, 2025 at 04:09:50PM +0200, Paolo Bonzini wrote:
> On Sat, Apr 19, 2025 at 12:16 AM Edgecombe, Rick P
> <rick.p.edgecombe@intel.com> wrote:
> > TDG.VP.VMCALL<INSTRUCTION.WBINVD> - Missing
> > TDG.VP.VMCALL<INSTRUCTION.PCONFIG> - Missing
> 
> WBINVD and PCONFIG need to be implemented (PCONFIG can be a stub).

On the guest side I actively avoided using WBINVD as the only way for VMM
to implement it is to do WBINVD on the host side which is too disruptive
for the system. It is possible way to DoS the host.

Do we really want to implement it on KVM side? It is good incentive for
guests to avoid WBINVD.

Hm. Maybe we would need it for partitioning scenario where L2 guest
doesn't care if it runs under TDX and uses WBINVD.

It would be neat to have per-KeyID WBINVD, but HW cannot do this.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

