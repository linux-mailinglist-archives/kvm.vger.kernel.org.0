Return-Path: <kvm+bounces-12627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF43788B3D5
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:18:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABB4A2E40CD
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD287317F;
	Mon, 25 Mar 2024 22:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i2JBh3og"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF50370CC2;
	Mon, 25 Mar 2024 22:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711405119; cv=none; b=igWmmv9hZk0eJDMLoenBsWIXUdzNb9QHxs0X/yCW+taQNEdXbc2ctiznTSJCVFj+JagIuSddMVup1lKLrcvPjZtrHLHtVys1bPM/Tgm3WtXOKCQCuXWWVV8OKse+gnjjt/UigaBqtAkZG2HkHf0azBBXYZA3DV+1iPVmrBXimCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711405119; c=relaxed/simple;
	bh=feUQgOvzcNlvP1Ks242aVU3gOvHsb8SG3N7apTriglg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMWSEo1ZCirmWOStMRsS9dge+R1u7aQH5LePUeJ+Wc9xIwCH6zzQ/M2oClwzkNhtfCdtXG+eg4jhAkBHXSFXBphcAXPTsn0iZRPlmLbtGf7V8hbVMKqepImzW3Vay70KWNAlMR+sNgaUoNy6r1j4VmmWf35xL9aGj/7EFS09BI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i2JBh3og; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711405118; x=1742941118;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=feUQgOvzcNlvP1Ks242aVU3gOvHsb8SG3N7apTriglg=;
  b=i2JBh3ogKEvpyxNaMbsRpnJwqTkKq6wXi62vTyfprG1jFMijpLHwRuLS
   BDFqSG8mmrcbb01s6Yg04ptYRXn5splQdSwAyyU7ph436SHgP1XefpIZl
   dOrh/e1263u31J6ynvtzlFp5u0sC6JVkCk5uGL58yin83CIj2h2M8cjrv
   AZe3IfkZzENqfkt2hYW9etDM/KA46X2xitUFT33aGYsYL3uUD2U9/kShw
   ovipwz+MupBMTUM5sQwLWrOhGh/DfcHsknvWkaTpdW1+lNeFlIKv/B1BE
   HvldIn8jL78bYKdQg9f0YQNqZWomo1Q5cEL2jqyHLdURYnzwxO4eUhksL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6372056"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="6372056"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 15:18:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="15845759"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 15:18:37 -0700
Date: Mon, 25 Mar 2024 15:18:36 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240325221836.GO2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
 <20240319235654.GC1994522@ls.amr.corp.intel.com>
 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
 <20240321225910.GU1994522@ls.amr.corp.intel.com>
 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>

On Mon, Mar 25, 2024 at 07:55:04PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-03-25 at 12:05 -0700, Isaku Yamahata wrote:
> > Right, the guest has to accept it on VE.  If the unmap was intentional by guest,
> > that's fine.  The unmap is unintentional (with vMTRR), the guest doesn't expect
> > VE with the GPA.
> > 
> > 
> > > But, I guess we should punt to userspace is the guest tries to use
> > > MTRRs, not that userspace can handle it happening in a TD...  But it
> > > seems cleaner and safer then skipping zapping some pages inside the
> > > zapping code.
> > > 
> > > I'm still not sure if I understand the intention and constraints fully.
> > > So please correct. This (the skipping the zapping for some operations)
> > > is a theoretical correctness issue right? It doesn't resolve a TD
> > > crash?
> > 
> > For lapic, it's safe guard. Because TDX KVM disables APICv with
> > APICV_INHIBIT_REASON_TDX, apicv won't call kvm_zap_gfn_range().
> Ah, I see it:
> https://lore.kernel.org/lkml/38e2f8a77e89301534d82325946eb74db3e47815.1708933498.git.isaku.yamahata@intel.com/
> 
> Then it seems a warning would be more appropriate if we are worried there might be a way to still
> call it. If we are confident it can't, then we can just ignore this case.
> 
> > 
> > For MTRR, the purpose is to make the guest boot (without the guest kernel
> > command line like clearcpuid=mtrr) .
> > If we can assume the guest won't touch MTRR registers somehow, KVM can return an
> > error to TDG.VP.VMCALL<RDMSR, WRMSR>(MTRR registers). So it doesn't call
> > kvm_zap_gfn_range(). Or we can use KVM_EXIT_X86_{RDMSR, WRMSR} as you suggested.
> 
> My understanding is that Sean prefers to exit to userspace when KVM can't handle something, versus
> making up behavior that keeps known guests alive. So I would think we should change this patch to
> only be about not using the zapping roots optimization. Then a separate patch should exit to
> userspace on attempt to use MTRRs. And we ignore the APIC one.
> 
> This is trying to guess what maintainers would want here. I'm less sure what Paolo prefers.

When we hit KVM_MSR_FILTER, the current implementation ignores it and makes it
error to guest.  Surely we should make it KVM_EXIT_X86_{RDMSR, WRMSR}, instead.
It's aligns with the existing implementation(default VM and SW-protected) and
more flexible.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

