Return-Path: <kvm+bounces-64884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 843BDC8F689
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:00:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB2923AACF1
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 15:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E0C3396EE;
	Thu, 27 Nov 2025 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWfekuN5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271D6337B97
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764259067; cv=none; b=eGKddnXfwSm2MgASwAXDXZpsQZrUtzYU7ZMSYpcTQxp75C3luUjQAuvG2G3TgWs9CWSadKss6P5nToJqwtX4XuQ5K3M9FzE2RyTZbg4wszjNo8W0hWXq1IkSZrv2WIA/NlRsRSpTLTpuyCxjerHWnWq0/juPxlyImNRHnNN1IwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764259067; c=relaxed/simple;
	bh=itpV5Jw7JOt+y/eGkVGcUctX+rcKGf8Pok4hWu7jcsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKBCnwi+YpujQNHj6Ns09vpBEkXRvpdZ3Ihwft3E3HukL4FX/tuwcq9/9P7d9VFIg7CJsKzhGWDRI+AvrJn8lACaEwXAoZEPFDcETJP4u60AzYHREkbHfal7LqjfwGpOYGA+c2+TqkN4N0dGVB+v/O7B7GXV2g1clE/O763QTFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWfekuN5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF29EC113D0;
	Thu, 27 Nov 2025 15:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764259067;
	bh=itpV5Jw7JOt+y/eGkVGcUctX+rcKGf8Pok4hWu7jcsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gWfekuN5uI6YIJh3HmY+E69MtD3maVdG9Xa5qtR86uc2ssar1VZ+9Q2gXDrfis4Jd
	 C0TQMXUrgug9tS5WHMFLSUrRdpr0K+DgGzJgpoHTi//FMKg4A+z4seaNE0CeQXIZtZ
	 1gl3HRc8BsbWC+ax1zgHuF0CwhQqVdX7oX0S2rdjVUkwORqirgQGTDR+uD6qtuaui7
	 XaGik7UJ/dCJCmuEyGuRwFESgQcPrMX2Rsm+DkHkAy4dPFLE4CIiKuSiTupykgsOrp
	 g88Bz8Bt7XcOE7NPyLbxw1cVjyL27VV2p3sjKYaar02wp7FozKZJH21bm9PXketqVG
	 JdO2zJYRJqnGQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id CCE72F4008E;
	Thu, 27 Nov 2025 10:57:45 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 27 Nov 2025 10:57:45 -0500
X-ME-Sender: <xms:-XQoaVYhl9x_6zN6I6-Msnw3NjVwY8pBXpBavdUjYoXOl3-HWsmzDg>
    <xme:-XQoafu5bVgQJklvowfe1Sg3yQ9KWHvNBYH2bVx8gATBTSub4V-oQxd67RPnfOOJU
    GIbNPFzwVHyuy6P_eTmgn2CiQ8lyDfYU0K3ekOh1MjKSRDRV0INt-Y>
X-ME-Received: <xmr:-XQoaTygxU9oYS1iw-Axe4CgSG37Fpkfr21wktmM6lfUGXhvKci7qyrKvAfMVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeejieegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehrihgtkhdrphdrvggughgvtghomhgsvgesihhnthgvlhdrtghomhdprhgtphhtth
    hopegsihhnsghinhdrfihusehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohep
    khhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtoh
    gtoheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehkrghirdhhuhgrnhhg
    sehinhhtvghlrdgtohhmpdhrtghpthhtohepgihirghohigrohdrlhhisehinhhtvghlrd
    gtohhmpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnhesihhnthgvlhdrtghomhdprhgt
    phhtthhopeihrghnrdihrdiihhgrohesihhnthgvlhdrtghomhdprhgtphhtthhopegsih
    hnsghinhdrfihusehinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:-XQoaW3LolLDKazxoBbdtMSNkbMR8lxH_l_3gxNBmmLxFVECf1sYgw>
    <xmx:-XQoaUnVX7Xj730wCmJUmFTvYLRuR1rKaQ8kyC3OrThYDbQMcJiIyg>
    <xmx:-XQoaV6pjZB8WyRj-8PF94EkM77NfY1adkfKOdDT2jGad_Z2GP798Q>
    <xmx:-XQoaQyX-PESgx2K-13Y7bDapEGDIAjG6x5BQn9jQW59PN7kOfbdTQ>
    <xmx:-XQoaViMcrFF6JHVLBHNGKPAA6iStrrQ-RA5yYaLCO2787WaMFi8NhOw>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Nov 2025 10:57:45 -0500 (EST)
Date: Thu, 27 Nov 2025 15:57:44 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Wu, Binbin" <binbin.wu@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Message-ID: <irqkfods52iut7se552qo6b5o4qidtmghcdosdxmbytvpyphpi@ol5wuaoydaab>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-7-rick.p.edgecombe@intel.com>
 <468165b7-46aa-4321-a47f-a97befaa993f@linux.intel.com>
 <21a759efdcfb4429ed952303f7d7143263220b22.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21a759efdcfb4429ed952303f7d7143263220b22.camel@intel.com>

On Wed, Nov 26, 2025 at 08:47:19PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2025-11-25 at 11:15 +0800, Binbin Wu wrote:
> > On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
> > [...]
> > > +
> > > +/* Unmap a page from the PAMT refcount vmalloc region */
> > > +static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr, void *data)
> > > +{
> > > +	struct page *page;
> > > +	pte_t entry;
> > > +
> > > +	spin_lock(&init_mm.page_table_lock);
> > > +
> > > +	entry = ptep_get(pte);
> > > +	/* refcount allocation is sparse, may not be populated */
> > 
> > Not sure this comment about "sparse" is accurate since this function is called via
> > apply_to_existing_page_range().
> > 
> > And the check for not present just for sanity check?
> 
> Yes, I don't see what that comment is referring to. But we do need it, because
> hypothetically the refcount mapping could have failed halfway. So we will have
> pte_none()s for the ranges that didn't get populated. I'll use:
> 
> /* Refcount mapping could have failed part way, handle aborted mappings. */

It is possible that we can have holes in physical address space between
0 and max_pfn. You need the check even outside of "failed halfway"
scenario.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

