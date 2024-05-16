Return-Path: <kvm+bounces-17492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FEEB8C6F84
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93B81B23025
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1CB1362;
	Thu, 16 May 2024 00:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aHprb2MK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189837E1;
	Thu, 16 May 2024 00:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715819239; cv=none; b=kIgdVSj0ra7zrFYamwRfDsyKyLnhD9fJvXgcBI3/GG/5LotoIKJ0nyU7bRBhFbceQ1u19eVABQ1GOlS0eTyeR96K1xxs/QYVgPELqbYpNP4QrfFyXiCdkJOGzZwG+izVj9U9veTHBT6OgkR49X5IkO6kpVi3Ruu4ipKBhEUkTto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715819239; c=relaxed/simple;
	bh=VRAdImUKYOpidKrbRJhkHOg58OOwmJ7dWBt06FyFeyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TtJIUvqE7VpCMF1sLF6RML4UN0od+jgw5xH+0+2c0giR60hzIOS6FBEGD0opTY9sl5b93fwVW5tLmZSVlSsRNIp9xJO59PvPP5n+8HKzsnaKjEHZrXoVKo/VGaAljgQkyMWH9vhgMqQAXB/u/YMsQMREWpw83NGCOUFiF/kXA5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aHprb2MK; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715819238; x=1747355238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=VRAdImUKYOpidKrbRJhkHOg58OOwmJ7dWBt06FyFeyI=;
  b=aHprb2MKch74RYjbmG4u8sDjSLbL8/ZL38rPpuflLbMcsCqdoSAVTOId
   brhz9YDJnMF1x7W6PcC2a+msj71mkF4KFhPb0x0RPuNZma6TGmpRr6AcW
   KT6j125qIfUadguWgtuf17zMl3kQVn5yD8Xok8BzzRQ6afzpHNGzhgkgR
   TsAWsqyewvm3zWncKLjK7n3c66eUQFUdV3ufVys+PaW65pLt2+r4UPH68
   0kDBLgvnuEScFWbMkvEMXe4cYzHe4j859tYM+DVTattooxnbz75MPJMP1
   CfGd9bpJsuCzuePgThNdircxrXlUc8EjwBL5cA1QlUf0ZJaTF/scBBY+t
   g==;
X-CSE-ConnectionGUID: LEW2yuoGRw+8SinKdsia3A==
X-CSE-MsgGUID: i99yLGAtS8S7RgbANQbkaQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="37282303"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="37282303"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:27:17 -0700
X-CSE-ConnectionGUID: /yXQZ1HFS+WwGjET6CRY3g==
X-CSE-MsgGUID: kVBYgqEDSkW2MtoI0+fnCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="36117289"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:27:18 -0700
Date: Wed, 15 May 2024 17:27:16 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Message-ID: <20240516002716.GH168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <ZkTWDfuYD-ThdYe6@google.com>
 <20240515162240.GC168153@ls.amr.corp.intel.com>
 <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
 <d4c96caffd2633a70a140861d91794cdb54c7655.camel@intel.com>
 <66afc965-b3f5-41e5-8b8e-d19e7084b690@intel.com>
 <3879ed41213652da74c5de3e437f732dfb2324d7.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3879ed41213652da74c5de3e437f732dfb2324d7.camel@intel.com>

On Thu, May 16, 2024 at 12:13:44AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Thu, 2024-05-16 at 11:38 +1200, Huang, Kai wrote:
> > On 16/05/2024 11:14 am, Edgecombe, Rick P wrote:
> > > On Thu, 2024-05-16 at 10:17 +1200, Huang, Kai wrote:
> > > > > TDX has several aspects related to the TDP MMU.
> > > > > 1) Based on the faulting GPA, determine which KVM page table to walk.
> > > > >        (private-vs-shared)
> > > > > 2) Need to call TDX SEAMCALL to operate on Secure-EPT instead of direct
> > > > > memory
> > > > >        load/store.  TDP MMU needs hooks for it.
> > > > > 3) The tables must be zapped from the leaf. not the root or the middle.
> > > > > 
> > > > > For 1) and 2), what about something like this?  TDX backend code will
> > > > > set
> > > > > kvm->arch.has_mirrored_pt = true; I think we will use
> > > > > kvm_gfn_shared_mask()
> > > > > only
> > > > > for address conversion (shared<->private).
> > > 
> > > 1 and 2 are not the same as "mirrored" though. You could have a design that
> > > mirrors half of the EPT and doesn't track it with separate roots. In fact, 1
> > > might be just a KVM design choice, even for TDX.
> > 
> > I am not sure whether I understand this correctly.  If they are not 
> > tracked with separate roots, it means they use the same page table (root).
> 
> There are three roots, right? Shared, private and mirrored. Shared and mirrored
> don't have to be different roots, but it makes some operations arguably easier
> to have it that way.

Do you have something like KVM_X86_SW_PROTECTED_VM with mirrored PT in mind?
or TDX thing?



> > So IIUC what you said is to support "mirror PT" at any sub-tree of the 
> > page table?
> > 
> > That will only complicate things.  I don't think we should consider 
> > this.  In reality, we only have TDX and SEV-SNP.  We should have a 
> > simple solution to cover both of them.
> 
> Look at "bool is_private" in kvm_tdp_mmu_map(). Do you see how it switches
> between different roots in the iterator? That is one use.
> 
> The second use is to decide whether to call out to the x86_ops. It happens via
> the role bit in the sp, which is copied from the parent sp role. The root's bit
> is set originally via a kvm_gfn_shared_mask() check.
> 
> BTW, the role bit is the thing I'm wondering if we really need, because we have
> shared_mask. While the shared_mask is used for lots of things today, we need
> still need it for masking GPAs. Where as the role bit is only needed to know if
> a SP is for private (which we can tell from the GPA).

I started the discussion at [1] for it.

[1] https://lore.kernel.org/kvm/20240516001530.GG168153@ls.amr.corp.intel.com/ 
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

