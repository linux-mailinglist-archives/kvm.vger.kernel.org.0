Return-Path: <kvm+bounces-57333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38EEBB53806
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 17:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4881A1BC8485
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 15:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C9B350833;
	Thu, 11 Sep 2025 15:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcWIm2iH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABB62D97A8
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757605310; cv=none; b=LzKVO/aU7BIwOzN+4Uej+D3sLQ0jRvoQzMu5w6zk8H2ycMh5k+n/Og4xFC6KgXySh+lBDhqVOqdy0R18AsrEzY+68/UvEb75xw8vnczmZOKy5tWKmd3kovtff3wOQVEd5/Q56F3/DfqQM329t+8Uwkg+xYzGYhy5qwVZ2yCZU5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757605310; c=relaxed/simple;
	bh=jYpaEDuj8hmZIbVIPi8y6wFH/kWW9EUnWk8efKIm7Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lb35f8U73U580Qnt3qQyyFT6ya3NcucjRBNqa9mgyoOAdtcIGX67FDNyKD4LGgjXu0PNdasZuA0SHb9r3nVKtycJqf7S/qcGDute4hRO7VZ/quA1gfq5jiybOjJEMvnDlJJBcbo4xYNWp3vw0SWwbCR+/rR78ss3uuzvULxJIYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcWIm2iH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505D3C4CEF5;
	Thu, 11 Sep 2025 15:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757605309;
	bh=jYpaEDuj8hmZIbVIPi8y6wFH/kWW9EUnWk8efKIm7Nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fcWIm2iHyUR4VrZ6qkus+tOxAIQRsxmQaemuNzSZKuZD/V7UwMiS04ZUp6u3FqXK8
	 eqJ6MjAEiARkUxcNO8dkEdCpHFggpsGtISAJzTLtl+xEXBMDfDljfKSeQvuPyy9d+L
	 ZUk0Rk782bC5LETiQnAaKwBe/2zuj4Aay44u6HUC0vyNPUvYMdzi/dmxOsOf9egoiU
	 KPpGMHWH/71GUOti248eu3yGKSH8tQ6ntV06zXukZAvTQ2ml0MMXkHC5Gk/fHiAd4j
	 5iQVYeatHzO2FPUMQhrEb3B2YWzhGKrV+M3SJ+eAl3rujZQL9D4x4P4MHpN/z9kkYa
	 hg95e2wACxflg==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8F179F40069;
	Thu, 11 Sep 2025 11:41:48 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 11 Sep 2025 11:41:48 -0400
X-ME-Sender: <xms:vO3CaPiznt_k4aoGNJMbBllzBZwbK6k7OcFw5CPHFbly12MzxV6T8Q>
    <xme:vO3CaPVedbtY4wkFkCCLuz_Ffq7lfg_g8OrHObh9xxSM_l9ZAbdAcmA9ByQsNtu2A
    I14PdeWeBFp4qhJ0dY>
X-ME-Received: <xmr:vO3CaDI2XVKz_avJXIack38eHa4rfkJRwTE-4JJ-8dgEnfFMw8uDyA_0uzSjcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvieehhecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:vO3CaCpJSFc3tv9nlZLWvolMCqe5LVK7dV-tf4ZTy29axwVccMrqXg>
    <xmx:vO3CaCsmD0p3rXXAwC67bv296YfBOg0cqw-TQXT_zqajdh4L4QrJ6Q>
    <xmx:vO3CaFXoNhfeBRZpCtP2xanVIM3nFpIE-Dy0WJEUG1g27QFyG6exqA>
    <xmx:vO3CaG2-TsccKed2OGb74RSbvzmgIsDqWoJDkvQr_dBXHFeqOIvn-g>
    <xmx:vO3CaOdfK0nOBq3Ea4oGU26VCqzg6iOg7GMVLx2yuerffXYuNfv-UqcI>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Sep 2025 11:41:47 -0400 (EDT)
Date: Thu, 11 Sep 2025 16:41:45 +0100
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
Message-ID: <yssp7h44gdgsf36spim2puxu2tqx3cbkezcfcn4gcux2nh4wju@ebcak5bnrpv4>
References: <20250910144453.1389652-1-dave.hansen@linux.intel.com>
 <oyagitkaefceadeqoqgycqhubw4hnlsjxf6lytazxpjnzueb4k@bmcvegkzrycq>
 <684e83b3-756b-4995-9804-6b1d0cfa4103@intel.com>
 <766raob5ltycizxfzcqh5blvdyk5girzfu2575n7gu4g7cmco5@zttwu3qwmjlm>
 <6a5b66e4-d534-41ff-8feb-ce0ad3ebdff5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a5b66e4-d534-41ff-8feb-ce0ad3ebdff5@intel.com>

On Wed, Sep 10, 2025 at 09:57:13AM -0700, Dave Hansen wrote:
> On 9/10/25 09:12, Kiryl Shutsemau wrote:
> > On Wed, Sep 10, 2025 at 09:10:06AM -0700, Dave Hansen wrote:
> >> On 9/10/25 09:06, Kiryl Shutsemau wrote:
> >>>>  struct tdx_vp {
> >>>>  	/* TDVP root page */
> >>>>  	struct page *tdvpr_page;
> >>>> +	/* precalculated page_to_phys(tdvpr_page) for use in noinstr code */
> >>>> +	phys_addr_t tdvpr_pa;
> >>> Missing newline above the new field?
> >> I was actually trying to group the two fields together that are aliases
> >> for the same logical thing.
> >>
> >> Is that problematic?
> > No. Just looks odd to me. But I see 'struct tdx_td' also uses similar
> > style.
> 
> Your review or ack tag there seems to have been mangled by your email
> client. Could you try to resend it, please? ;)

Do you mean my name spelling?

I've decided to move to transliteration from Belarusian rather than
Russian. I will update MAINTAINERS and mailmap later.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

