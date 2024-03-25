Return-Path: <kvm+bounces-12612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7025088AF57
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 20:06:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 288523022DC
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 19:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005EF4C83;
	Mon, 25 Mar 2024 19:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZmWfaYEO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8551B80F;
	Mon, 25 Mar 2024 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711393529; cv=none; b=o8z40Gd8bG5byqCckKd2TErCR61ORRpz6SntK//ylS3AqU8tEkeVvWdRe+Xk0V7NavpoBg9Dht+RJFcNaufreEvv6WVO39xNhNr4CypchNFboFrKHB1XbwQiAtbyAtaCq4tGlV6djW763xIGlZrLF+OjxlT9IcS6YQKzQ3aWGbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711393529; c=relaxed/simple;
	bh=ZgYazPeTafdm9oC34JiziT0P9rS4Rvc4pczqufKqjXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVR3x5XrQmnPxbiCL6JpYcVBWMYbk6ASoPWxJ9c1PLW5BL+NOGsHc7sjNzGJSAT77L0+sqzN9Hc53v+M+zXOymSyjIUIXLVjUn1pKN4xEZwLsUxSkZuVyMPVGRQiKKYejz1lqYBv5FujF/xskHGNaBLEt3oDaq6G6jMbGscM5L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZmWfaYEO; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711393527; x=1742929527;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZgYazPeTafdm9oC34JiziT0P9rS4Rvc4pczqufKqjXQ=;
  b=ZmWfaYEO5p2TfsSf+mCNj2VAbTP3WTgXAqVdudhG4NiiyqGZJTgpyac6
   VUo5jPAl+r1RkOPgZZQFxn3LH9PU/MCHxuRzkvRTxtgaoPjR89JyAqxVI
   L/MmxaOTiqqh2fdNnlQ2oeK6TEw7OQEXiiXMg99D/5RoEsfQdn27Hnz0j
   tZv+0HX8LCE9eVRSll1mMkrh0ta+0PvkuDGSLOvcKsn8S5Iy2Cve36SX5
   ZFvESitAfICDc+XBuuXhihSDNsBgou/VkJ4f38QTaogoYPMtZM3dCryL/
   E5gcCLM+Up+08OF5s02+ejHN1Ipi2bhCiI77kcGZgRazr8VUPKR2n3ePF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="17557571"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="17557571"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 12:05:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="20388398"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 12:05:26 -0700
Date: Mon, 25 Mar 2024 12:05:25 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240325190525.GG2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
 <20240319235654.GC1994522@ls.amr.corp.intel.com>
 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
 <20240321225910.GU1994522@ls.amr.corp.intel.com>
 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>

On Fri, Mar 22, 2024 at 12:40:12AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Thu, 2024-03-21 at 15:59 -0700, Isaku Yamahata wrote:
> > > 
> > > Ok, I see now how this works. MTRRs and APIC zapping happen to use
> > > the
> > > same function: kvm_zap_gfn_range(). So restricting that function
> > > from
> > > zapping private pages has the desired affect. I think it's not
> > > ideal
> > > that kvm_zap_gfn_range() silently skips zapping some ranges. I
> > > wonder
> > > if we could pass something in, so it's more clear to the caller.
> > > 
> > > But can these code paths even get reaches in TDX? It sounded like
> > > MTRRs
> > > basically weren't supported.
> > 
> > We can make the code paths so with the (new) assumption that guest
> > MTRR can
> > be disabled cleanly.
> 
> So the situation is (please correct):
> KVM has a no "making up architectural behavior" rule, which is an
> important one. But TDX module doesn't support MTRRs. So TD guests can't
> have architectural behavior for MTRRs. So this patch is trying as best
> as possible to match what MTRR behavior it can (not crash the guest if
> someone tries).
>
> First of all, if the guest unmaps the private memory, doesn't it have
> to accept it again when gets re-added? So will the guest not crash
> anyway?

Right, the guest has to accept it on VE.  If the unmap was intentional by guest,
that's fine.  The unmap is unintentional (with vMTRR), the guest doesn't expect
VE with the GPA.


> But, I guess we should punt to userspace is the guest tries to use
> MTRRs, not that userspace can handle it happening in a TD...  But it
> seems cleaner and safer then skipping zapping some pages inside the
> zapping code.
> 
> I'm still not sure if I understand the intention and constraints fully.
> So please correct. This (the skipping the zapping for some operations)
> is a theoretical correctness issue right? It doesn't resolve a TD
> crash?

For lapic, it's safe guard. Because TDX KVM disables APICv with
APICV_INHIBIT_REASON_TDX, apicv won't call kvm_zap_gfn_range().

For MTRR, the purpose is to make the guest boot (without the guest kernel
command line like clearcpuid=mtrr) .
If we can assume the guest won't touch MTRR registers somehow, KVM can return an
error to TDG.VP.VMCALL<RDMSR, WRMSR>(MTRR registers). So it doesn't call
kvm_zap_gfn_range(). Or we can use KVM_EXIT_X86_{RDMSR, WRMSR} as you suggested.
-- 
isaku Yamahata <isaku.yamahata@intel.com>

