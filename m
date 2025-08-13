Return-Path: <kvm+bounces-54568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63BB7B243C6
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 10:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5356167F97
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 08:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA812EA172;
	Wed, 13 Aug 2025 08:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVIkcAqV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDAF2EA469;
	Wed, 13 Aug 2025 08:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755072549; cv=none; b=r5BrGTjcToCX2S/IoM0m310yXXfiQNHOldZVpNiI0K8sciKo61uTpR2FyojuOfo3XkLUgweeDYNgtid15tCf3EqE0glpNH8XT1tUnYsEEWkOcYSdVzg+fJOexXyyiSByMhklCG8JHnPMz/qcP6/eSAIeHaqFClprovUX+qdcnfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755072549; c=relaxed/simple;
	bh=D4bJE6P03e+uFhDUw6XmDkecF0BUGB3Fvqqa4yo9gc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaXMpk7OU96lhAarc+9YDs6N5NUn2gGW9J797TMmLDvya22OrNbzEniPVlV3yO20xHD48n1adW9UkhyqoO6SFc37Q+JKXmxygELNkBy0hCvLpr/5qfY8d7eifJmUGZap8/vZA5M/3r8IIffFcRWWgCHhHc6PhsCiXv6v3zv6SEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVIkcAqV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EFDC4CEEB;
	Wed, 13 Aug 2025 08:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755072548;
	bh=D4bJE6P03e+uFhDUw6XmDkecF0BUGB3Fvqqa4yo9gc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DVIkcAqV4K0miVwbj5IYu40KXxM7uDUzFKWos3OpzeT+hQ0psGJ1Byo993+3sRI8J
	 NXh016HLBFtDl9HygPioxYjqouQeBYRAzvbaEhYTBC5G9Q4kH/StikPNlvTeqslYkY
	 0X0uEapf5mKNt+8KyRd0TeotpqXbcnQAzcAmzAAOKfLNIsDUvvr9oA9DvThKYEA8Pv
	 OSODJbNBsWvDmNTqnPqaTPt5TyNGY7BMjFiiJBoRme2LALAr1o/oCr9pXZ7jFQT+Ip
	 t1f7yB69Mw+lBayniBUBHXx7RSIIrT68mnTtCFnfFTt6e71YGgpOfMQwG73anJgp9+
	 H5nK/LJsNv7Mg==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6AF58F40066;
	Wed, 13 Aug 2025 04:09:07 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 13 Aug 2025 04:09:07 -0400
X-ME-Sender: <xms:I0icaDBL2KW65_N0lBYkcRVsvu4GGPxDYH-MauUdeusdDH_tKIYP7A>
    <xme:I0icaD4LVn9htfOlPe1j3znj3QUrJh_SA08CdDUJ3c_NeHscnTK9fNMdU9D-d0WAK
    5MPiGMA5lo1-QAqJ7g>
X-ME-Received: <xmr:I0icaKL-vULmVlhmMQBbvnpf_umMo30IfttuOU4zEZlcaB5uDF3AeodXqKuX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufeejieelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkefstddttddunecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtieetueehudeluedvffeguedvfffgueehfeelueejhffhudegtdetfeeiledv
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeefvddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepshgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehrihgtkhdrph
    drvggughgvtghomhgsvgesihhnthgvlhdrtghomhdprhgtphhtthhopehvrghnnhgrphhu
    rhhvvgesghhoohhglhgvrdgtohhmpdhrtghpthhtoheptghhrghordhgrghosehinhhtvg
    hlrdgtohhmpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    sghpsegrlhhivghnkedruggvpdhrtghpthhtohepkhgrihdrhhhurghnghesihhnthgvlh
    drtghomhdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtthho
    peihrghnrdihrdiihhgrohesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:I0icaPyxoqQ98Dlt1btIJm7FgOVMrhttz_1RHb6auAPMJZwyX1VXrQ>
    <xmx:I0icaCHCtrDK_1K14tW3lnbfukGDp2yOmBOZEklWC6Iu7EG5wRHpIQ>
    <xmx:I0icaHkaztaf_AmAcMbGogOkGJ7pnoexGEvFwQfe9xPVfxiV3EAbhQ>
    <xmx:I0icaJGz_QDy5D7AE85BFgom4hIo-pVFqdU78-sfuHsoaR24rGoQpw>
    <xmx:I0icaKw7lYYzBSrYJXR_FxTXznawLuniisUjDLtHgnOM1dnwFerMuQ5Q>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Aug 2025 04:09:06 -0400 (EDT)
Date: Wed, 13 Aug 2025 09:09:04 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Chao Gao <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"bp@alien8.de" <bp@alien8.de>, Kai Huang <kai.huang@intel.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Message-ID: <sd5jir2s5vr2z7xetdatbffndtjx2f5qn2kixyuappals4mzi4@yfxzqg6eeuvm>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
 <aJqgosNUjrCfH_WN@google.com>
 <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
 <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
 <57755acf553c79d0b337736eb4d6295e61be722f.camel@intel.com>
 <aJtolM_59M5xVxcY@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aJtolM_59M5xVxcY@google.com>

On Tue, Aug 12, 2025 at 09:15:16AM -0700, Sean Christopherson wrote:
> On Tue, Aug 12, 2025, Rick P Edgecombe wrote:
> > On Tue, 2025-08-12 at 09:04 +0100, kas@kernel.org wrote:
> > > > > E.g. for things like TDCS pages and to some extent non-leaf S-EPT
> > > > > pages, on-demand PAMT management seems reasonable.  But for PAMTs that
> > > > > are used to track guest-assigned memory, which is the vaaast majority
> > > > > of PAMT memory, why not hook guest_memfd?
> > > > 
> > > > This seems fine for 4K page backing. But when TDX VMs have huge page
> > > > backing, the vast majority of private memory memory wouldn't need PAMT
> > > > allocation for 4K granularity.
> > > > 
> > > > IIUC guest_memfd allocation happening at 2M granularity doesn't
> > > > necessarily translate to 2M mapping in guest EPT entries. If the DPAMT
> > > > support is to be properly utilized for huge page backings, there is a
> > > > value in not attaching PAMT allocation with guest_memfd allocation.
> 
> I don't disagree, but the host needs to plan for the worst, especially since the
> guest can effectively dictate the max page size of S-EPT mappings.  AFAIK, there
> are no plans to support memory overcommit for TDX guests, so unless a deployment
> wants to roll the dice and hope TDX guests will use hugepages for N% of their
> memory, the host will want to reserve 0.4% of guest memory for PAMTs to ensure
> it doesn't unintentionally DoS the guest with an OOM condition.
> 
> Ditto for any use case that wants to support dirty logging (ugh), because dirty
> logging will require demoting all of guest memory to 4KiB mappings.
> 
> > > Right.
> > > 
> > > It also requires special handling in many places in core-mm. Like, what
> > > happens if THP in guest memfd got split. Who would allocate PAMT for it?
> 
> guest_memfd?  I don't see why core-mm would need to get involved.  And I definitely
> don't see how handling page splits in guest_memfd would be more complicated than
> handling them in KVM's MMU.
> 
> > > Migration will be more complicated too (when we get there).
> 
> Which type of migration?  Live migration or page migration?

Page migration.

But I think after some reading, it can be manageable.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

