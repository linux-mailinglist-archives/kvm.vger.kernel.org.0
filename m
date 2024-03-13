Return-Path: <kvm+bounces-11757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3234F87B05B
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 19:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA08BB2BA38
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 18:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB5D65BB6;
	Wed, 13 Mar 2024 17:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NSFIDmep"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5B6657DD;
	Wed, 13 Mar 2024 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710351877; cv=none; b=EcrA59Fe5P7haTrFEbJ5E8aXeghhweR7gNiMbpqkzbLsqSYJfBVAUIb7VL73LH533NBv+VEU+kFuw1c2B2YE/PshyyXCTnVr1t2oz5zdnNF6YiTF7YkLKD4oQa6wwBhJeOmF2iCg3OjLhNUQX4rS9YL9s3F2CVBYpKDt9LcDJTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710351877; c=relaxed/simple;
	bh=ma7upt0mkxCiGazRLZGR9ohMqsHaHdle+49JOWHsY4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEeP+9w4lYbi6PDc1hP9PUrhOhWA2tyNTUFVQcfBmItlEdEAUI88XcJKFs79NBorz84iYFxrZUpspOnKN2UPzOtJuNSjVS9uXgTunC5fkDAssZaA2Hu61s5iYDSkruBtXfqfYmrafv5cJqqiaF65V84ekeScDvl4YEvX7HzGSb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NSFIDmep; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710351875; x=1741887875;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ma7upt0mkxCiGazRLZGR9ohMqsHaHdle+49JOWHsY4E=;
  b=NSFIDmepAoMopJ3ctPN7krsvaNLyvWxfi4VFfDfxWNeS8G8iH3ek3VYN
   yidXFovEImepLvyeQh5f1JVbvq8jYiXL0JiX2R3xRRkE52V0Q3wEJy3BX
   ju9d9mrNXdIZAZQ01SfK70Tp57qZ2cPuixMA77DMU8uX0/lmWPocNM6hd
   Ycf0di0MEqcNpNu2CfBtDjDxfx+K44YyxgOx9QIOthKKfVhg21iiMkUxR
   lyqmFE1VYVYDVfhJVQR2ULgHuHzlStcKSIL8axqSy7m/YXq9S4EeRzgLM
   ssRhTMI5meto4nqz75YNpmCizUjGqG7aBDLyz1PkZ6dpTxQ9pQgCuyuoC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="4997163"
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="4997163"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 10:44:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="16739287"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 10:44:35 -0700
Date: Wed, 13 Mar 2024 10:44:34 -0700
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
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 032/130] KVM: TDX: Add helper functions to
 allocate/free TDX private host key id
Message-ID: <20240313174434.GM935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7348e22ba8d0eeab7ba093f3e83bfa7ee4da1928.1708933498.git.isaku.yamahata@intel.com>
 <075322c9db65e2fa19d809357a98fe6067c80508.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <075322c9db65e2fa19d809357a98fe6067c80508.camel@intel.com>

On Wed, Mar 13, 2024 at 12:44:14AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add helper functions to allocate/free TDX private host key id (HKID).
> > 
> > The memory controller encrypts TDX memory with the assigned TDX
> > HKIDs.  The
> > global TDX HKID is to encrypt the TDX module, its memory, and some
> > dynamic
> > data (TDR). 
> 
> I don't see any code about the global key id.
> 
> >  The private TDX HKID is assigned to guest TD to encrypt guest
> > memory and the related data.  When VMM releases an encrypted page for
> > reuse, the page needs a cache flush with the used HKID.
> 
> Not sure the cache part is pertinent to this patch. Sounds good for
> some other patch.
> 
> >   VMM needs the
> > global TDX HKID and the private TDX HKIDs to flush encrypted pages.
> 
> I think the commit log could have a bit more about what code is added.
> What about adding something like this (some verbiage from Kai's setup
> patch):
> 
> The memory controller encrypts TDX memory with the assigned TDX
> HKIDs. Each TDX guest must be protected by its own unique TDX HKID.
> 
> The HW has a fixed set of these HKID keys. Out of those, some are set
> aside for use by for other TDX components, but most are saved for guest
> use. The code that does this partitioning, records the range chosen to
> be available for guest use in the tdx_guest_keyid_start and
> tdx_nr_guest_keyids variables.
> 
> Use this range of HKIDs reserved for guest use with the kernel's IDA
> allocator library helper to create a mini TDX HKID allocator that can
> be called when setting up a TD. This way it can have an exclusive HKID,
> as is required. This allocator will be used in future changes.
> 
> 
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > v19:
> > - Removed stale comment in tdx_guest_keyid_alloc() by Binbin
> > - Update sanity check in tdx_guest_keyid_free() by Binbin
> > 
> > v18:
> > - Moved the functions to kvm tdx from arch/x86/virt/vmx/tdx/
> > - Drop exporting symbols as the host tdx does.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 28 ++++++++++++++++++++++++++++
> >  1 file changed, 28 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index a7e096fd8361..cde971122c1e 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -11,6 +11,34 @@
> >  #undef pr_fmt
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >  
> > +/*
> > + * Key id globally used by TDX module: TDX module maps TDR with this
> > TDX global
> > + * key id.  TDR includes key id assigned to the TD.  Then TDX module
> > maps other
> > + * TD-related pages with the assigned key id.  TDR requires this TDX
> > global key
> > + * id for cache flush unlike other TD-related pages.
> > + */
> 
> The above comment is about tdx_global_keyid, which is unrelated to the
> patch and code.

Will delete this comment as it was moved into the host tdx patch series.

> 
> > +/* TDX KeyID pool */
> > +static DEFINE_IDA(tdx_guest_keyid_pool);
> > +
> > +static int __used tdx_guest_keyid_alloc(void)
> > +{
> > +       if (WARN_ON_ONCE(!tdx_guest_keyid_start ||
> > !tdx_nr_guest_keyids))
> > +               return -EINVAL;
> 
> I think the idea of this warnings is to check if TDX failed to init? It
> could check X86_FEATURE_TDX_HOST_PLATFORM or enable_tdx, but that seems
> to be a weird thing to check in a low level function that is called in
> the middle of in progress setup.
> 
> Don't know, I'd probably drop this warning.
> 
> > +
> > +       return ida_alloc_range(&tdx_guest_keyid_pool,
> > tdx_guest_keyid_start,
> > +                              tdx_guest_keyid_start +
> > tdx_nr_guest_keyids - 1,
> > +                              GFP_KERNEL);
> > +}
> > +
> > +static void __used tdx_guest_keyid_free(int keyid)
> > +{
> > +       if (WARN_ON_ONCE(keyid < tdx_guest_keyid_start ||
> > +                        keyid > tdx_guest_keyid_start +
> > tdx_nr_guest_keyids - 1))
> > +               return;
> 
> This seems like a more useful warning, but still not sure it's that
> risky. I guess the point is to check for returning garbage. Because a
> double free would not be caught, but would be possible to using
> idr_find(). I would think if we are worried we should do the full
> check, but I'm not sure we can't just drop this. There are very limited
> callers or things that change the checked configuration (1 of each).

The related code is stable now and I don't hit them recently.  I'll drop both
of them.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

