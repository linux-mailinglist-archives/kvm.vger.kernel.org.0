Return-Path: <kvm+bounces-57206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83DABB51CFC
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC3BD189926A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 16:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BC3334395;
	Wed, 10 Sep 2025 16:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IE8gWm6R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4215332CF9D;
	Wed, 10 Sep 2025 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757520418; cv=none; b=FjfQnlMWHfjzMd1uIgt1+guABuQQwtw7lfJ5giYJbOi4rqzVGnBTRllIAK22+gLbpsp0iidUFUn568yrU1m0GPlR4AzDAGzEHTToDXEmI/mEpsqF+/28yRW1A+DkTk40EJ05NVgOe7wS0rn4AVGyFHrTvCeInQaNmk6J2+DJhpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757520418; c=relaxed/simple;
	bh=X3Opqbf4Sq+VdENBJ2CJl3eBFHZYoWKXwqrY4DDZy8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQ7VuMS1uN0xjywLX3cW5wr+vmsN/jccakJYLiZ6xOvAhaZofAzpfUIuTiHijlA4NZGG3hhT7ALBaZdw9/X6+CRmS3Bjet09fOIHJIOuOqsWoym1zgIwlJwRmSQTX6LKFqfZ7q6AGp1gy7ZmMSOorCTp8w+1JnOyYAZPcUk6Rjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IE8gWm6R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C98C4AF09;
	Wed, 10 Sep 2025 16:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757520417;
	bh=X3Opqbf4Sq+VdENBJ2CJl3eBFHZYoWKXwqrY4DDZy8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IE8gWm6RbvtILLcMnK5svrVKpgU1o8/3DEewwXcU7ylJ/llKvBBmPA8y/lkr4cs54
	 sJSwbpttRuR9HthNJi8Y7l3s5V3PuvzFjj01jkTGlsnOL4jQ7RjeQpr7UFI0/hZtx6
	 5+YiHuPRQ4Ps8VdXmVc1Nl3El8UfzSnsj8sbcOLhSfmZohxQWDpTJ9yk/OsFuq+zLe
	 +djZdPsGZLozR+pxaViO2cMkXGkRJXaRknGh7a8Mz4uzB/YnoJvoFYkCYEO9sAu8nc
	 vXvNhXrszOp/sKisTnYTj3EdVrBCMSTrInYZyXZ/BMM4eDP++T6R1yTiGUdiTU6zQP
	 wqdn8zO5dW53w==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9458BF40067;
	Wed, 10 Sep 2025 12:06:56 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 10 Sep 2025 12:06:56 -0400
X-ME-Sender: <xms:IKLBaMNepMD5v37U4UYgsicrObZiXlGeCH5ph8QLCVeTYr66WFP3Gw>
    <xme:IKLBaBcgRGcE7bgJ_3pij3BJ97ArSEaRz7cpyGwj8PJJWZcNBYpmVCqlZQu903smE
    hMyPVxi2eiVI1U06No>
X-ME-Received: <xmr:IKLBaJeM-0-OKU7zLj2xaeiOwSBc1HhZQdqfpCfOeePyssVJffam4ymG3wvGyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeejfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtth
    hopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphht
    thhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhnghhose
    hrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgtphht
    thhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehhphgrseiihihtohhrrd
    gtohhmpdhrtghpthhtoheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrdgt
    ohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:IKLBaJcy45g9FsLU4wbQXNU0oTTt1GezFD_oWgdDnx_C-F_kaJdf9Q>
    <xmx:IKLBaClTo-tqVAPBVsSe9M4PL9V4OhM3cjccg0wl6H6xS7l6ybtFfw>
    <xmx:IKLBaL5EvnXkhmINzmqoYk8lqzWsrWO-Om-mqyPE8DUrTnyBcrpFmA>
    <xmx:IKLBaKtAWaqBx_wFWBWFM-PszmEGf1iQrFwm9alGqU0LMgs40Gbr3w>
    <xmx:IKLBaBQWZ6XUSUnitJL-tDoTVIWl8mN6IVW7uNtSaRFZ1MMB1n2mhY4z>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 10 Sep 2025 12:06:56 -0400 (EDT)
Date: Wed, 10 Sep 2025 17:06:53 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Thomas Huth <thuth@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH] x86/virt/tdx: Use precalculated TDVPR page physical
 address
Message-ID: <oyagitkaefceadeqoqgycqhubw4hnlsjxf6lytazxpjnzueb4k@bmcvegkzrycq>
References: <20250910144453.1389652-1-dave.hansen@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910144453.1389652-1-dave.hansen@linux.intel.com>

On Wed, Sep 10, 2025 at 07:44:53AM -0700, Dave Hansen wrote:
> From: Kai Huang <kai.huang@intel.com>
> 
> All of the x86 KVM guest types (VMX, SEV and TDX) do some special context
> tracking when entering guests. This means that the actual guest entry
> sequence must be noinstr.
> 
> Part of entering a TDX guest is passing a physical address to the TDX
> module. Right now, that physical address is stored as a 'struct page'
> and converted to a physical address at guest entry. That page=>phys
> conversion can be complicated, can vary greatly based on kernel
> config, and it is definitely _not_ a noinstr path today.
> 
> There have been a number of tinkering approaches to try and fix this
> up, but they all fall down due to some part of the page=>phys
> conversion infrastructure not being noinstr friendly.
> 
> Precalculate the page=>phys conversion and store it in the existing
> 'tdx_vp' structure.  Use the new field at every site that needs a
> tdvpr physical address. Remove the now redundant tdx_tdvpr_pa().
> Remove the __flatten remnant from the tinkering.
> 
> Note that only one user of the new field is actually noinstr. All
> others can use page_to_phys(). But, they might as well save the effort
> since there is a pre-calculated value sitting there for them.
> 
> [ dhansen: rewrite all the text ]
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

One nitpick is below.

> ---
>  arch/x86/include/asm/tdx.h  |  2 ++
>  arch/x86/kvm/vmx/tdx.c      |  9 +++++++++
>  arch/x86/virt/vmx/tdx/tdx.c | 21 ++++++++-------------
>  3 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 6120461bd5ff3..6b338d7f01b7d 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -171,6 +171,8 @@ struct tdx_td {
>  struct tdx_vp {
>  	/* TDVP root page */
>  	struct page *tdvpr_page;
> +	/* precalculated page_to_phys(tdvpr_page) for use in noinstr code */
> +	phys_addr_t tdvpr_pa;

Missing newline above the new field?


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

