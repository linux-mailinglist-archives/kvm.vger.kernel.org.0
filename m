Return-Path: <kvm+bounces-57208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41BA8B51D36
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:13:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23367440677
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 16:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDFF335BAC;
	Wed, 10 Sep 2025 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufXSslpA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6763314C5;
	Wed, 10 Sep 2025 16:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757520763; cv=none; b=tB6fg8G+qGlT/Yd6iddgjqy/VRtj4x2FwJvZHoe6oyXnWg5URN1BFSbJAz4SjxyJz99VMRbHjohTw8qhbz8WPMIJyyF6wbDnb9s5z4XgOqJWXba5lMHjpdpsoJ+XmqFoqvozA4oNK2wJ5c5pwefsKfYLdlYgvFvX8F6soudZ6Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757520763; c=relaxed/simple;
	bh=Bs8gvnoRFpg3lsXpvS6O6gij8IOPpjQN/wWX9IFRQ6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIe+YlTJKqm4IL3Lp/meFTOwBTNaxDbYm8m/eiz7GcnPFEQEFxufZ1PE+NTosP7/EHxPnI/xqgrw1yGFh/4xkr88S/4XNp31OJhsVcN7puBU8dUq+PtX6BaR/tNu2thEZM5e7rf1D/bAu6wldbRQjtalcqyYfsVxzW1FVw12Mk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ufXSslpA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE39C4CEF0;
	Wed, 10 Sep 2025 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757520763;
	bh=Bs8gvnoRFpg3lsXpvS6O6gij8IOPpjQN/wWX9IFRQ6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ufXSslpAktrx49XrR/MZoVymVA8KqyOv2N12h1wFQSjpn0Qz0CowUHIMjDGqc/ofA
	 X6yVrHZuCJlTsWmD2ia4+i0Tdi8fUnry6GqD70BlzdY3IKApwmfEPWfT1ZKlVklam5
	 Rv2TNXXVtukCiWwaW415odpn5a2BV+ptlkgKt7JRTEDqaT3xXOpt5n4Dfh0ncHeioc
	 lwnc9ZgDokXLbxqtjLd2nMx+BHMgcJlW499I32zyQPOqZ+8psrL6JzN/my4eA7IWAm
	 OF2jpnDDN90rmctrgdXxzn/DAjmZozpLAomwVuKyat5YQDmskvM1wHe9dDD+RPi/pV
	 Vy9NVntdQVF2w==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id EF88CF40069;
	Wed, 10 Sep 2025 12:12:41 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 10 Sep 2025 12:12:41 -0400
X-ME-Sender: <xms:eaPBaNqk0Sr04sOJ-mlNxT_LVHsbgbmb5trTazOMvtD0a5hkh9RweA>
    <xme:eaPBaC_76JB4tGdk2yeF_wRov8UNpZKCdL85vtV6VvoxzbE28DmOr-wVxR0Ox4JAX
    JLSbNhhRp_65R9drJU>
X-ME-Received: <xmr:eaPBaOTWamSDqEhaM0KlzBTBLEhrCUXdLsdUWfQR6rVf6EwkZmYwIS-jeBtsbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuggrvhgvrdhhrghnshgvnhesihhnthgvlhdrtghomhdprhgtphhtthhopegurghvvg
    drhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtoheplhhinhhu
    gidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglh
    igsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrght
    rdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepgiekie
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtohephhhprgesiiihthhorhdrtghomhdprhgt
    phhtthhopehrihgtkhdrphdrvggughgvtghomhgsvgesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:eaPBaPSgjcUVsdIP1wCcOgctUaxt29OXsP0AV9-3KxnSHqlAx4KR3Q>
    <xmx:eaPBaC0DraQPvuWoLdxYkCCykp9ZpvAzFoIlRyuTu4U8xrHv8INT5w>
    <xmx:eaPBaC_O1foow97SQ8loCqXhH8WsDgZcVJ9q3U9XytRoyegdnaiM4A>
    <xmx:eaPBaD94cGXegx_HLMPRC9fD8SU7IoaRFQxokL1U0bho7gxNPBeGBA>
    <xmx:eaPBaFEqElTFxOTFG-iqGR9tkL7l9w3oYFNOMgRQ-yWPSjSiiC0wN_25>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 10 Sep 2025 12:12:41 -0400 (EDT)
Date: Wed, 10 Sep 2025 17:12:39 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Thomas Huth <thuth@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH] x86/virt/tdx: Use precalculated TDVPR page physical
 address
Message-ID: <766raob5ltycizxfzcqh5blvdyk5girzfu2575n7gu4g7cmco5@zttwu3qwmjlm>
References: <20250910144453.1389652-1-dave.hansen@linux.intel.com>
 <oyagitkaefceadeqoqgycqhubw4hnlsjxf6lytazxpjnzueb4k@bmcvegkzrycq>
 <684e83b3-756b-4995-9804-6b1d0cfa4103@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <684e83b3-756b-4995-9804-6b1d0cfa4103@intel.com>

On Wed, Sep 10, 2025 at 09:10:06AM -0700, Dave Hansen wrote:
> On 9/10/25 09:06, Kiryl Shutsemau wrote:
> >>  struct tdx_vp {
> >>  	/* TDVP root page */
> >>  	struct page *tdvpr_page;
> >> +	/* precalculated page_to_phys(tdvpr_page) for use in noinstr code */
> >> +	phys_addr_t tdvpr_pa;
> > Missing newline above the new field?
> 
> I was actually trying to group the two fields together that are aliases
> for the same logical thing.
> 
> Is that problematic?

No. Just looks odd to me. But I see 'struct tdx_td' also uses similar
style.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

