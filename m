Return-Path: <kvm+bounces-58131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6409AB889CF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 11:39:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EE201C83A18
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3273043AD;
	Fri, 19 Sep 2025 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+16I5It"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95C02F25EF;
	Fri, 19 Sep 2025 09:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758274747; cv=none; b=eZlh1fY77M/k7/I/718li4sVhhhwzyCfLMqEU2F04creIrD89TAz3cSeFToXuUt9juPGPbj9xAR4rgGhDVtcu6r8zKFZ8EUt+an3V4Ja92aJhW4EtsC5UuV7wvTlyolOBSrUH3ix7F6iQwrf7yXX2+cYM/QZZRaCzPN6E9lwiyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758274747; c=relaxed/simple;
	bh=iy0PkhwSAeIQTwMFfchedmIPC64gR38fveVhC+odks8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/wGq7R+cKD9G4Uu97XVHekmvyvkgUPdW4yWuE9qiL2ZdblEYCwSPVRtYQaLlqPSLuBnSWj1M46EFC/iENsqF6nxLtkAgBbP/8j7S9p7yUonT84+yhfoe+gOQdwkJKxlwo+tEFNIvfjuMvo+GBhjgEIMGZCPoEI/ZKZYRDi8oTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+16I5It; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975EBC4AF09;
	Fri, 19 Sep 2025 09:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758274747;
	bh=iy0PkhwSAeIQTwMFfchedmIPC64gR38fveVhC+odks8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P+16I5ItE4NigMLF+gUX2mklFfKkn0bfLr6xnufPmH6qMsaiHLwD2JbcijwbcgQTa
	 Wn0tNgD1sd4YNTL2Iax15QZppkB5yofteUI0CT1FRsS3/Ply1QPkXbsFlXt/yes+as
	 9iNFx4+9Id/9E2cvRGMP5ojYG0MFbqoc+C161/PQ7oDU3ROoVyYa9ctzkQTtjMHv+n
	 u7dFQHFBKJbJ9b0MDodzt1I5ZUajv2QX0dB48p2CiRAGzWtWmZCrMKjkUaYG922iTr
	 HPHJyx5grT1pIJ2D20jL4kUb9f0WFpZiMVC57Ts8ebcvlkPvH07L00ZZC4L39LQBNH
	 3rm9PbScYbN5w==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9ABE4F40066;
	Fri, 19 Sep 2025 05:39:05 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 19 Sep 2025 05:39:05 -0400
X-ME-Sender: <xms:uSTNaOXjS7vj5wKwyKZ1QzdscSM7PwZciE4tAFFoMs-KYqcU0gEGcw>
    <xme:uSTNaNhcuXjqVI247lPwJH4bF5K871bvnlg0hraO2XQDwViTtaOuMkPyxQFBPAwBA
    EwD6YaIKusgO-cXASc>
X-ME-Received: <xmr:uSTNaGljeO99XidBUfesO5bGMhTPZzgUzbo1V-zjFgf2184BdtzmXIszyF4rAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegkeekjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtoh
    epsghpsegrlhhivghnkedruggvpdhrtghpthhtoheptghhrghordhgrghosehinhhtvghl
    rdgtohhmpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlh
    drtghomhdprhgtphhtthhopehishgrkhhurdihrghmrghhrghtrgesihhnthgvlhdrtgho
    mhdprhgtphhtthhopehkrghirdhhuhgrnhhgsehinhhtvghlrdgtohhmpdhrtghpthhtoh
    epkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgt
    ohgtoheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvg
    hrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:uSTNaCgtD_IEe6sxYUgk8eWuuoOAeMFHO_ICOasHws4WKK9F5GLaZg>
    <xmx:uSTNaE6S1mbioVgBF0u-LX375LuJ3JP_ro7_IJTh9QLrlHRGoBg2Rg>
    <xmx:uSTNaOubdh-vyQ1rVepsNkajrf66fO0gFUqvK_8mRJvA_6L560LeqQ>
    <xmx:uSTNaJzNog_0qTp6VIn7OrGs5XnEREWEZ_Foa2N5VysOwnk-NCgVmQ>
    <xmx:uSTNaPwoaLLl8uTqlhNy9zadD92pgk-ZNrelWIl6EJlXn-A87BhIBU7A>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Sep 2025 05:39:04 -0400 (EDT)
Date: Fri, 19 Sep 2025 10:39:02 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@linux.intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org, 
	yan.y.zhao@intel.com, vannapurve@google.com, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 08/16] x86/virt/tdx: Optimize tdx_alloc/free_page()
 helpers
Message-ID: <yexfu34vq5wrctlhafkrhvwfdcp5aenkleq6zolgqquz74dmzh@5336rz6kfulo>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-9-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918232224.2202592-9-rick.p.edgecombe@intel.com>

On Thu, Sep 18, 2025 at 04:22:16PM -0700, Rick Edgecombe wrote:
> +		} else if (IS_TDX_HPA_RANGE_NOT_FREE(tdx_status)) {
> +			/*
> +			 * Less obviously, another CPU's call to tdx_pamt_put() could have
> +			 * decremented the refcount before entering its lock section.
> +			 * In this case, the PAMT is not actually removed yet. Luckily
> +			 * TDX module tells about this case, so increment the refcount
> +			 * 0-1, so tdx_pamt_put() skips its pending PAMT.REMOVE.
> +			 *
> +			 * The call didn't need the pages though, so free them.
> +			 */
>  			atomic_inc(pamt_refcount);

It is still 0->1 transition. atomic_set(pamt_refcount, 1) would be
slightly faster here.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

