Return-Path: <kvm+bounces-11873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E47187C6F2
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 02:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CCB7284CFB
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 01:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49474C80;
	Fri, 15 Mar 2024 01:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fGw9Ijn1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A43D10E4;
	Fri, 15 Mar 2024 01:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710464984; cv=none; b=oh7T6t9a1UHyzha1BQgmwGzd5jlKOjYMlX0HBcOwrSNHHe8h3LXO3w1krLBSGtcm0VZeINM6BhKbFwWftRpEUYalbL+KQC5hSGMg1FE63d/YFfJhPdOigyezviySEdJ8DAygxUe8sqfs2jl2g5zJRLFXvo6o7Wd+L9cma3TMazY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710464984; c=relaxed/simple;
	bh=NGXrtRFb2eCniF9NsNPA6nZlg1KCam4uJIGqlAbZEUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ew6YSE6l0KINFpnY1o6J9sO7x0azs30cczQZJ+fU1H65wRkptf0MCP+aMjlT/Z0UB6kzbTePZrv+C0E03iRWxutAYvmHyXQHQYohFmF1vdU+67YMVhCKnZZUj8ln/5ij915yxUhHoJBk0KI9ipApgdIUw0d2Q4O9u5dnIMeOu/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fGw9Ijn1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710464982; x=1742000982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=NGXrtRFb2eCniF9NsNPA6nZlg1KCam4uJIGqlAbZEUw=;
  b=fGw9Ijn1CsVnSQbgaq7JO0kfEdvdGmOURoLwHgkr1uF6Yx9FdABp4ESc
   G85+Q4ioiFbJNOVV2gMafiYtrvSkRCTe1nX5uxWGzF4Ul2/mBRQ1x4mZ2
   4EOyik4KfP1hTMw9ndVDMrsanatb+oVJM6RMza08keju1gpFgLyPBFN5u
   FMYTGGxBvSeptcn9wp6mNFwZLqYluozxW2qWof0f9W6dQE5X/yBI5m2in
   1jpWMNsIEzNnaOVY2xEq95Srz42QTvCh0wE6e0AXz4c97w98hvKBitZGL
   wFXzxFGFbPL6151k91kU2F7vWQPScvNYSK1q4nGPwDrMtGYixNGyltwnk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="22839256"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="22839256"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 18:09:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="13106051"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 18:09:40 -0700
Date: Thu, 14 Mar 2024 18:09:40 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Message-ID: <20240315010940.GE1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
 <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>
 <20240314181000.GC1258280@ls.amr.corp.intel.com>
 <bfde1328-2d1c-4b75-970f-69c74f3a74f9@intel.com>
 <ada65e3e977c8cde0044b7fa9de5f918e3b1b638.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ada65e3e977c8cde0044b7fa9de5f918e3b1b638.camel@intel.com>

On Thu, Mar 14, 2024 at 09:39:34PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Fri, 2024-03-15 at 10:23 +1300, Huang, Kai wrote:
> > We have 3 page tables as you mentioned:
> > 
> > PT: page table
> > - Shared PT is visible to KVM and it is used by CPU.
> > - Private PT is used by CPU but it is invisible to KVM.
> > - Dummy PT is visible to KVM but not used by CPU.  It is used to
> >    propagate PT change to the actual private PT which is used by CPU.
> > 
> > If I recall correctly, we used to call the last one "mirrored
> > (private) 
> > page table".
> > 
> > I lost the tracking when we changed to use "dummy page table", but it
> > seems to me "mirrored" is better than "dummy" because the latter
> > means 
> > it is useless but in fact it is used to propagate changes to the real
> > private page table used by hardware.
> 
> Mirrored makes sense to me. So like:
> 
> Private - Table actually mapping private alias, in TDX module
> Shared - Shared alias table, visible in KVM
> Mirror - Mirroring private, visible in KVM
> 
> > 
> > Btw, one nit, perhaps:
> > 
> > "Shared PT is visible to KVM and it is used by CPU." -> "Shared PT is
> > visible to KVM and it is used by CPU for shared mappings".
> > 
> > To make it more clearer it is used for "shared mappings".
> > 
> > But this may be unnecessary to others, so up to you.
> 
> Yep, this seems clearer.

Here is the updated one. Renamed dummy -> mirroed.

When KVM resolves the KVM page fault, it walks the page tables.  To reuse
the existing KVM MMU code and mitigate the heavy cost of directly walking
the private page table, allocate one more page to copy the mirrored page
table for the KVM MMU code to directly walk.  Resolve the KVM page fault
with the existing code, and do additional operations necessary for the
private page table.  To distinguish such cases, the existing KVM page table
is called a shared page table (i.e., not associated with a private page
table), and the page table with a private page table is called a mirrored
page table.  The relationship is depicted below.


              KVM page fault                     |
                     |                           |
                     V                           |
        -------------+----------                 |
        |                      |                 |
        V                      V                 |
     shared GPA           private GPA            |
        |                      |                 |
        V                      V                 |
    shared PT root      mirrored PT root         |    private PT root
        |                      |                 |           |
        V                      V                 |           V
     shared PT           mirrored PT ----propagate---->  private PT
        |                      |                 |           |
        |                      \-----------------+------\    |
        |                                        |      |    |
        V                                        |      V    V
  shared guest page                              |    private guest page
                                                 |
                           non-encrypted memory  |    encrypted memory
                                                 |
PT: Page table
Shared PT: visible to KVM, and the CPU uses it for shared mappings.
Private PT: the CPU uses it, but it is invisible to KVM.  TDX module
            updates this table to map private guest pages.
Mirrored PT: It is visible to KVM, but the CPU doesn't use it.  KVM uses it
             to propagate PT change to the actual private PT.

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

