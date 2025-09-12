Return-Path: <kvm+bounces-57427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C1DEB55593
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 19:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33D98AE3368
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFE1326D60;
	Fri, 12 Sep 2025 17:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNCtE1Ka"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E02AC2D1;
	Fri, 12 Sep 2025 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757699189; cv=none; b=E9ceGRnyWB/XTsInGz9oBitXFeqbB2W6+08eVqpCSY/TYwN/ZtB6IS4RyRswPbxqu/1ngpil3spDQx4RNT0Q877apO5xGJmczyZO+/kX6DILK3MbXjgO86Xi+xZFzuwMDztRsf0gncDyF1FENgeoxMBEkphvOXgpjRiwocTJKY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757699189; c=relaxed/simple;
	bh=qxIc1cH8PD+p/SYwz/OkcdUUMSdirqVgnnpLvq3+1Uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=onqXeP/V3vT9LwfsRvenVk96Oo6cB7xFS35iOBQXDtbhAF8nvoAu4WWHeie+gNlrP2c5mhbThUS9ilIbTOXi4OA9/q48ClIxC1AlqH24rJt+MLbmdodgXIyykRtz8agzNsDcFpXPru6nNOeKYEdEYN4BH7W5gHBV5MPlGfeaAgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNCtE1Ka; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2481C4CEF4;
	Fri, 12 Sep 2025 17:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757699188;
	bh=qxIc1cH8PD+p/SYwz/OkcdUUMSdirqVgnnpLvq3+1Uw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mNCtE1KardHVG6HBq59PNpPoJE5SbXzDNwGefsvF3ZQdkdtvW/Qr3VS1ZtTSYWrKd
	 c3/43KRap0kp2H1dGCUMWCcT7QMH1lof+qsKEQunB2VRespMoJhKhewz3Ba0U3XwHm
	 chXrwSxGseeO/eQybO3USpb3FaPHciZBrTol1dMdyxWVwppM9t+5SLDrfHZPUrDTUz
	 wUwhVTo9MFpZf5XqS3NwL+gffLWt/m+Yo+UkGIaROxsaAPCpx0yItv/vma07PYZ747
	 oD8DP8K7w9uQd9DktjRw8myFJ2Y/OEQSC4uZGOtuy4aSmVnKAM6peh1vvMgfh7grhn
	 A021Hepvv7Qqw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id EF5FDF40066;
	Fri, 12 Sep 2025 13:46:26 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 12 Sep 2025 13:46:26 -0400
X-ME-Sender: <xms:clzEaGbLDtsWIjpiGB0U7iPPz5QgFQFVh4LvBFdRapmKV1Hdy5IAIg>
    <xme:clzEaHRE5_61MDqCioZ9Jp2SChODfg7s29HxN0a_9iJD-psuvQ3s1fzYXdQREImWr
    Lmjfl54_RpkJHXEjHw>
X-ME-Received: <xmr:clzEaKDRva5BSS59kgSU0veM4oRJ8FhDUyFnXhmP8UAUbGAwS5p9GuvjxhdikQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvleeilecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepgihirghohigrohdrlhhisehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrd
    hhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhopehsvggrnhhj
    tgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepphgsohhniihinhhisehrvgguhhgrth
    drtghomhdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphht
    thhopehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnh
    ekrdguvgdprhgtphhtthhopehhphgrseiihihtohhrrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqtghotghosehlihhsthhsrdhlihhnuhigrdguvghv
X-ME-Proxy: <xmx:clzEaJ5euosA-rmCw9NCdyOoa2xbgeICH25zpBieMqVPWb13AgZz1w>
    <xmx:clzEaKA_KAAFwiS4Ptc6cyx5zn7n5wXASAinYw2TAA4vNQC7RL_Ptw>
    <xmx:clzEaN5oDcbc-GYycxDEhxml8M06Xf9rupRktDJkD12JoTRL4MDTIw>
    <xmx:clzEaGuZt59k3r8AwLDeYLi1J7lcJZLjCnUtLHJ4_f1KX75mpqSdig>
    <xmx:clzEaLyig2iU1Iv14c4VX_z1awzHAQtUEOiKrTxZTDfozIxjbHaijsC6>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Sep 2025 13:46:26 -0400 (EDT)
Date: Fri, 12 Sep 2025 18:46:23 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, binbin.wu@linux.intel.com, yan.y.zhao@intel.com, 
	reinette.chatre@intel.com, adrian.hunter@intel.com, tony.lindgren@intel.com
Subject: Re: [PATCH v3 3/4] x86/tdx: Rename TDX_ATTR_* to TDX_TD_ATTR_*
Message-ID: <ci2upyx4dxlzpbhuus6hoaoeqyyvb4k4p732cvefvowj46jwlx@cwbkadz3ht6z>
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
 <20250715091312.563773-4-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715091312.563773-4-xiaoyao.li@intel.com>

On Tue, Jul 15, 2025 at 05:13:11PM +0800, Xiaoyao Li wrote:
> The macros TDX_ATTR_* and DEF_TDX_ATTR_* are related to TD attributes,
> which are TD-scope attributes. Naming them as TDX_ATTR_* can be somewhat
> confusing and might mislead people into thinking they are TDX global
> things.
> 
> Rename TDX_ATTR_* to TDX_TD_ATTR_* to explicitly clarify they are
> TD-scope things.
> 
> Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

