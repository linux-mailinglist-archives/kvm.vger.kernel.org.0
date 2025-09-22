Return-Path: <kvm+bounces-58377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F0A1B8FDD5
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 11:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22E6F18A2535
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D750D2F5A08;
	Mon, 22 Sep 2025 09:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GyH4W6GW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037CF2F5315
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758534868; cv=none; b=BCJXcljeNEvxt3VVDVetTJAnts28ITOXJHNNK0Kr9TmVEqdKtmHMXI6wpjZDXnV5yFbAj/UD8/BEreUfb9ztoG7ZLpoK5kewkJzIM67tx6yHseqmYMWlH9Dr85fc2ma6U9cLp9mwuMd9WATIPjscanZrZHwZah1+pc1+Jc6ynEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758534868; c=relaxed/simple;
	bh=8w6/o14ZXBOrZ5fcQwirnz0Nsc2q9gxNt8eNNNzu6mQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knKjE0U7pzGURaEPeVcVol7Iq+jBo5MmihJ7wvOc+xNMrMvCfcXAbOBfXzEts841ItiSKFCUAFnR59eiVst7N6sYRy+isunpd/+k6hxqQzexBHtnlHzaIW8Dg2eoT/6hDj552Xsaas1Fhj8O5G0b5jaFv+NYnyCD0AEq3JoK7K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GyH4W6GW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A2CC16AAE
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758534867;
	bh=8w6/o14ZXBOrZ5fcQwirnz0Nsc2q9gxNt8eNNNzu6mQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GyH4W6GWIhCtzhojtNAKnnNT3V4TSsQuNRdntOF0HddNjN5q1dWXKhT2WEtrE29sw
	 dOqGF7XkXKhBwz0J/MJ36HFHZe/DcC/9u6sn/bWpXKqfWdqOa64aZelsyjuUvEf/Eb
	 u6A9cTCQNFWqHuuoBgsq3aRtI4Xa4ORPEcWghaARpSxt+xAxVPCEoVCQDrebOzULz4
	 TYDwhH33FkuEdaaYPPRS/uA5qQvgVNO067j2ctbZ0CVQ3L1fs8tFeQk5ayxPgEVkoB
	 qnD31iJsBmNI9dZNylKZZpsKejo8x4NHE5GwcQOznc2/NXE2UvWT3VVx7+pKf9tmat
	 uusk313WH3Q9A==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7788CF40066;
	Mon, 22 Sep 2025 05:54:26 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 22 Sep 2025 05:54:26 -0400
X-ME-Sender: <xms:0hzRaPDy7YTN00wQ7F9AdRbAc3f48LRKlq6vX1dU37hHwB3xnpXCsA>
    <xme:0hzRaBAXrM0KpYoCKN2tNH7ajEkhR-pHOoLUMiIrCMINwH5jfyvP_xBv3yi4mjG0E
    8TlGLGOyodQu8Qzlo0>
X-ME-Received: <xmr:0hzRaAnpbjncp3NO83SBZpFhw_-inT8PX_Ozmz0KqHBpeu-DxH4fkffC8NRE9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehjeehgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedviedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepnhgvvghrrghjrdhuphgrughhhigrhiesrghmugdrtghomhdprhgtphhtthhopehrih
    gtkhdrphdrvggughgvtghomhgsvgesihhnthgvlhdrtghomhdprhgtphhtthhopehthhho
    mhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepjhhohhhnrdgrlh
    hlvghnsegrmhgurdgtohhmpdhrtghpthhtoheptghhrghordhgrghosehinhhtvghlrdgt
    ohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhope
    igihgrohihrghordhlihesihhnthgvlhdrtghomhdprhgtphhtthhopehlihhnuhigqdhk
    vghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehmihhnihhplh
    hisehgrhhsvggtuhhrihhthidrnhgvth
X-ME-Proxy: <xmx:0hzRaPgja_LiSqIlFl1iQEvsFllHCj8NS-IxwsP_Dxk97Elv6fn-ug>
    <xmx:0hzRaJdmaQX2cUwVC8Phea1gUNgGL2OUQfFwS_vifUy6q7mNa-Qfpw>
    <xmx:0hzRaPATkaP1IqLbnlOsIquu8LgK2z6hHVkKntlZefJDsit2pTI6cQ>
    <xmx:0hzRaN61M-jNpmPgbfnkEfdANdJUjJDpA-9ySLSx1N9ybho-nRqPeA>
    <xmx:0hzRaMw71qp7PqRJm_0fXe5xz7tJA_J6QJbEojxIyLdx7W_v64Ts_t8C>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Sep 2025 05:54:25 -0400 (EDT)
Date: Mon, 22 Sep 2025 10:54:23 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "john.allen@amd.com" <john.allen@amd.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"minipli@grsecurity.net" <minipli@grsecurity.net>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, naveen.rao@amd.com
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Message-ID: <nvd4fg4mfd6cdcnqqaqyaqthn5ljuzswplvnslpv2pkuano4mf@yn45t5solwzp>
References: <aMxs2taghfiOQkTU@google.com>
 <aMxvHbhsRn40x-4g@google.com>
 <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
 <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
 <aMyFIDwbHV3UQUrx@AUSJOHALLEN.amd.com>
 <2661794f-748d-422a-b381-6577ee2729ee@amd.com>
 <bb3256d7c5ee2e84e26d71570db25b05ada8a59f.camel@intel.com>
 <ecaaef65cf1cd90eb8f83e6a53d9689c8b0b9a22.camel@intel.com>
 <7ds23x6ifdvpagt3h2to3z5gmmfb356au5emokdny7bcuivvql@3yl3frlj7ecb>
 <bd8831a3-2a23-43d2-9998-73cd5165716c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd8831a3-2a23-43d2-9998-73cd5165716c@amd.com>

On Mon, Sep 22, 2025 at 03:03:59PM +0530, Upadhyay, Neeraj wrote:
> 
> > 
> > In TDX case, VAPIC state is protected VMM. It covers ISR, so guest can
> > safely check ISR to detect if the exception is external or internal.
> > 
> > IIUC, VAPIC state is controlled by VMM in SEV case and ISR is not
> > reliable.
> > 
> > I am not sure if Secure AVIC[1] changes the situation for AMD.
> > 
> > Neeraj?
> > 
> 
> For Secure AVIC enabled guests, guest's vAPIC ISR state is not visible to
> (and not controlled by) host or VMM.

In this case, I think you should make ia32_disable() in sme_early_init()
conditional on !Secure AVIC.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

