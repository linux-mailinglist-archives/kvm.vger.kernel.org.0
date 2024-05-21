Return-Path: <kvm+bounces-17848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B30DE8CB200
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90C101C21C89
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230712B9AA;
	Tue, 21 May 2024 16:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J0wUSv4a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92BD4C66;
	Tue, 21 May 2024 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716308123; cv=none; b=TJDBDELqsvqiDMP/zUSunqCNMyPr2uo6+BGMUJI+iqqyw6rdRYd+xSu1NxUh36n9Wb6FVRUqzx3zmxvVduHUdqUvvxqcM0EWnkVyxVkvFAvY+VhJy7uhklJSA2EOeDjJ39G6zTbRMZ4fEsM9Rnpta4Yxm/la7v5128yMD33HpH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716308123; c=relaxed/simple;
	bh=LMTJBP0t0ESm9FrLK7OUQoeH4Ms0acboPhO+Hcj38eU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlAQklu/BWPmBw8RDlpJjXziIADHDHBgDEhaYqf4/lxty153zxxeT2eDDY94hsWAIj3Y4fJ/4nbPz4Fpa+7Y82SDa8zKXrCIzs0wQmQ78Xv2MW1VN1ynklMYX6EKkbXruva73ryyP2fJd+D3Ntx0j2eB+8ek+iykRSocpZNkmvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J0wUSv4a; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716308122; x=1747844122;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=LMTJBP0t0ESm9FrLK7OUQoeH4Ms0acboPhO+Hcj38eU=;
  b=J0wUSv4abrDMTPipz4LoqQuNk2KpKGPym0PmNOTehpiOXs/I8Hw0weo9
   a6ynMWKi1gMcrAzSwDV9EWI7zaV5hAzq3USmzcbozS2LwWRw6oMEdKf9A
   /EDMPH8eIOgly+Xt/xacV7xkS+s67wHz210p6BUJY6Kyp1KZsHF51gB56
   onhezH5DrW12P0Iv3/FK+HA6BgmPMK54n7l/q/AOAf4Pbkn4go3ISw+xq
   ly+IUFmC2PVd6tScJwZaZoFFaV1fWQSExN0TXFQQP5tJZszgPSQ3g2Ghh
   8egsHfMptpX1oSe/JyeagIUVjYMyZhRrKOZFBb1aqm46kD9CP8hLyezwh
   Q==;
X-CSE-ConnectionGUID: hamYn3yoTLWNdjsdLRqoxA==
X-CSE-MsgGUID: +znx0h/hQueU/9NoblSODw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="16344613"
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="16344613"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 09:15:21 -0700
X-CSE-ConnectionGUID: qhRlPD4BSVCM1g1xdeaXgw==
X-CSE-MsgGUID: e9MmXWLCRsysomyOQGmlXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="33520410"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 09:15:21 -0700
Date: Tue, 21 May 2024 09:15:20 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240521161520.GB212599@ls.amr.corp.intel.com>
References: <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
 <20240517090348.GN168153@ls.amr.corp.intel.com>
 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
 <20240517191630.GC412700@ls.amr.corp.intel.com>
 <20240520233227.GA29916@ls.amr.corp.intel.com>
 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>

On Tue, May 21, 2024 at 03:07:50PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> > 1.4.2 Guest Physical Address Translation
> >   Transition to SEAM VMX non-root operation is formatted to require Extended
> >   Page Tables (EPT) to be enabled. In SEAM VMX non-root operation, there
> > should
> >   be two EPTs active: the private EPT specified using the EPTP field of the
> > VMCS
> >   and a shared EPT specified using the Shared-EPTP field of the VMCS.
> >   When translating a GPA using the shared EPT, an EPT misconfiguration can
> > occur
> >   if the entry is present and the physical address bits in the range
> >   (MAXPHYADDR-1) to (MAXPHYADDR-TDX_RESERVED_KEYID_BITS) are set, i.e., if
> >   configured with a TDX private KeyID.
> >   If the CPU's maximum physical-address width (MAXPA) is 52 and the guest
> >   physical address width is configured to be 48, accesses with GPA bits 51:48
> >   not all being 0 can cause an EPT-violation, where such EPT-violations are
> > not
> >   mutated to #VE, even if the “EPT-violations #VE” execution control is 1.
> >   If the CPU's physical-address width (MAXPA) is less than 48 and the SHARED
> > bit
> >   is configured to be in bit position 47, GPA bit 47 would be reserved, and
> > GPA
> >   bits 46:MAXPA would be reserved. On such CPUs, setting bits 51:48 or bits
> >   46:MAXPA in any paging structure can cause a reserved bit page fault on
> >   access.
> 
> In "if the entry is present and the physical address bits in the range
> (MAXPHYADDR-1) to (MAXPHYADDR-TDX_RESERVED_KEYID_BITS) are set", it's not clear
> to be if "physical address bits" is referring to the GPA or the "entry" (meaning
> the host pfn). The "entry" would be my guess.
> 
> It is also confusing when it talks about "guest physical address". It must mean
> 4 vs 5 level paging? How else is the shared EPT walker supposed to know the
> guest maxpa. In which case it would be consistent with normal EPT behavior. But
> the assertions around reserved bit page faults are surprising.
> 
> Based on those guesses, I'm not sure the below code is correct. We wouldn't need
> to remove keyid bits from the GFN.
> 
> Maybe we should clarify the spec? Or are you confident reading it the other way?

I'll read them more closely. At least the following patch is broken.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

