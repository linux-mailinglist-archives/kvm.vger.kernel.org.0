Return-Path: <kvm+bounces-11811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BA587C26B
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 19:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA683283524
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33ADE74C05;
	Thu, 14 Mar 2024 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nCXGeSYa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC3B1A38D0;
	Thu, 14 Mar 2024 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710439807; cv=none; b=MAvKag1XfwLMw04Bk3PsYafQyajkqINblZHH9vUj+zssKa2GkjUN6uO7tmQg1peInL0etiYvUsRTHWoAzGbeVs4b/iZYrZPu+f6CJlVYaGiu8h/GBnlR7n4a7swHqnchyM5akDSr2iw2u5JyvlcHe+yG0gZVN8yfdat4NMwzE54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710439807; c=relaxed/simple;
	bh=gFHRFDN/CPcON7olO+kUcyYx7VC4Z2A9CcSi4q2BeGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJCTOerF5KKUQ2Ub3NDaLeyjMNsBiK+zczqrEiV8mO+koFWWRRvguvvNb6ZEmOt6Q5kg/7bqaIf7tRV6H3FeJRCd6nUrjSj5/oyqFKsXx5dzfQ8DHquxbWBKowiUr7RUZv4XEtVTxlRBrP6e1deBykQLUr6M1ScJyq35MdSNOSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nCXGeSYa; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710439805; x=1741975805;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=gFHRFDN/CPcON7olO+kUcyYx7VC4Z2A9CcSi4q2BeGM=;
  b=nCXGeSYaKXJYlwc3XtcWSnz7aZ9l7JL3+4Z2y9vQb9iKNRLfGWcqFRoN
   PbxZzvKPdLpHugE5Gzma/1RTIGWcLmfQQWNvDmlFtO6vRCy4M5QwGQrYg
   LI5nN1My/pI69ykiJlgfUvMt4A5sYxtywDM6p+yYos61zboMjd8RrmSIg
   YF+Lx+b4IsiGPwsnLZ3AxV3TxPVSOx+epQVHBGPVcz4NLiH+ZcEm14Vhd
   6Rcl/YqgyExWpiYfOEbr6uMinzux2Rngn6wk1WwHqHjrEg9wv5/2wB1rl
   aSij4laYy5y5zsveKxI+As0SoEjeAuY3pfV/lNOq+mvR4SBbd0EmOI4L5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="16732519"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="16732519"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 11:10:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="12454131"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 11:10:00 -0700
Date: Thu, 14 Mar 2024 11:10:00 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Message-ID: <20240314181000.GC1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
 <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>

On Wed, Mar 13, 2024 at 08:51:53PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:26 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > For private GPA, CPU refers a private page table whose contents are
> > encrypted.  The dedicated APIs to operate on it (e.g.
> > updating/reading its
> > PTE entry) are used and their cost is expensive.
> > 
> > When KVM resolves KVM page fault, it walks the page tables.  To reuse
> > the
> > existing KVM MMU code and mitigate the heavy cost to directly walk
> > private
> > page table, allocate one more page to copy the dummy page table for
> > KVM MMU
> > code to directly walk.  Resolve KVM page fault with the existing
> > code, and
> > do additional operations necessary for the private page table. 
> 
> >  To
> > distinguish such cases, the existing KVM page table is called a
> > shared page
> > table (i.e. not associated with private page table), and the page
> > table
> > with private page table is called a private page table.
> 
> This makes it sound like the dummy page table for the private alias is
> also called a shared page table, but in the drawing below it looks like
> only the shared alias is called "shared PT".

How about this,
Call the existing KVM page table associated with shared GPA as shared page table.
Call the KVM page table associate with private GPA as private page table.

> >   The relationship
> > is depicted below.
> > 
> > Add a private pointer to struct kvm_mmu_page for private page table
> > and
> > add helper functions to allocate/initialize/free a private page table
> > page.
> > 
> >               KVM page fault                     |
> >                      |                           |
> >                      V                           |
> >         -------------+----------                 |
> >         |                      |                 |
> >         V                      V                 |
> >      shared GPA           private GPA            |
> >         |                      |                 |
> >         V                      V                 |
> >     shared PT root      dummy PT root            |    private PT root
> >         |                      |                 |           |
> >         V                      V                 |           V
> >      shared PT            dummy PT ----propagate---->   private PT
> >         |                      |                 |           |
> >         |                      \-----------------+------\    |
> >         |                                        |      |    |
> >         V                                        |      V    V
> >   shared guest page                              |    private guest
> > page
> >                                                  |
> >                            non-encrypted memory  |    encrypted
> > memory
> >                                                  |
> > PT: page table
> > - Shared PT is visible to KVM and it is used by CPU.
> > - Private PT is used by CPU but it is invisible to KVM.
> > - Dummy PT is visible to KVM but not used by CPU.  It is used to
> >   propagate PT change to the actual private PT which is used by CPU.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> > ---

...snip...

> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h
> > b/arch/x86/kvm/mmu/mmu_internal.h
> > index e3f54701f98d..002f3f80bf3b 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -101,7 +101,21 @@ struct kvm_mmu_page {
> >                 int root_count;
> >                 refcount_t tdp_mmu_root_count;
> >         };
> > -       unsigned int unsync_children;
> > +       union {
> > +               struct {
> > +                       unsigned int unsync_children;
> > +                       /*
> > +                        * Number of writes since the last time
> > traversal
> > +                        * visited this page.
> > +                        */
> > +                       atomic_t write_flooding_count;
> > +               };
> 
> I think the point of putting these in a union is that they only apply
> to shadow paging and so can't be used with TDX. I think you are putting
> more than the sizeof(void *) in there as there are multiple in the same
> category.

I'm not sure if I'm following you.
On x86_64, sizeof(unsigned int) = 4, sizeof(atomic_t) = 4, sizeof(void *) = 8.
I moved write_flooding_count to have 8 bytes.


> But there seems to be a new one added, *shadowed_translation.
> Should it go in there too? Is the union because there wasn't room
> before, or just to be tidy?

Originally TDX MMU support was implemented for legacy tdp mmu.  It used
shadowed_translation.  It was not an option at that time.  Later we switched to
(new) TDP MMU.  Now we have choice to which member to overlay.


> I think the commit log should have more discussion of this union and
> maybe a comment in the struct to explain the purpose of the
> organization. Can you explain the reasoning now for the sake of
> discussion?

Sure.  We'd like to add void * pointer to struct kvm_mmu_page.  Given some
members are used only for legacy KVM MMUs and not used for TDP MMU, we can save
memory overhead with union.  We have options.
- u64 *shadowed_translation
  This was not chosen for the old implementation. Now this is option.
- pack unsync_children and write_flooding_count for 8 bytes
  This patch chosen this for historical reason. Other two option is possible.
- unsync_child_bitmap
  Historically it was unioned with other members. But now it's not.

I don't have strong preference for TDX support as long as we can have void *.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

