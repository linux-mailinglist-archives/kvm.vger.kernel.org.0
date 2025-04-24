Return-Path: <kvm+bounces-44089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D028FA9A4C0
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A4D77B2735
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED861F460B;
	Thu, 24 Apr 2025 07:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="QZSU+U25";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oAMSk4a1"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181BC1E1E0B;
	Thu, 24 Apr 2025 07:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745480948; cv=none; b=JQ961OAjIilmi1hkFLgIb0yqmqbPY7FnuzSKLxqkKWXdOnmcS656VObXZZfgUsJGzXkQTZG2XEAPMPHB9C6IkC5yODNdc7nEgKfnF2I9ZBZz2LGSolad4iyp4rO7WTuaZAoNEZJ3N4gt5+98MQInhc7u8P4OBIUTFhA4UoiWFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745480948; c=relaxed/simple;
	bh=5rqtFzqootFSChXvYMUWn6GhsW3oKVWEt0dqvLi8/ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iKrVkWNdVWOUncm1tzcZksdYhti2vCDPbNEYzcH2wSGuKSnu4yzO9cU4tEzSAYvNlSgFkX8rHfA7gzBueJLR9aDWLAuYI8WPyLHpB7f80pd/o7fij9zymomH/fyQVHZFjwSVLII5lxmtxMI4CKPgei6rPfH+PHyfoLPEW/rxoZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=QZSU+U25; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oAMSk4a1; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2A99111402CF;
	Thu, 24 Apr 2025 03:49:05 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 24 Apr 2025 03:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1745480945; x=
	1745567345; bh=hjgOlGzyuUts0fVVNf3iH4m6Ug06tDRN1v46IIYPYNA=; b=Q
	ZSU+U254xGJaQDwHsGh+Go8x/A3laVE4wQPDVUBg5Fr+GgMqButYIPfwRj2PhJU4
	VjF83dsy2oOVHZdidquZgyfQJS8J/Z+sCIV4l43wxPSiiPfGeOtwG/ipiEFavoMf
	AAEjESIPH2OehVzHN0kUTAu58ldwYc47OTipfcEMUw8JuWKz9FGojWgUDWjGkwVt
	GxHrM8tMgIdGt14JN8gN5miEqQ5+bFE7KyML6IWv2OATOsNB1CghLxQgAjZ5hI5T
	/xwq9LtYi+/XrUNlJgW+VV1n4V0ddDkvzPeN2SBnCqe+tN7T1zDmDF6WMmqMz0WI
	ROcCudQJmHHDkYL+5ZPBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1745480945; x=1745567345; bh=hjgOlGzyuUts0fVVNf3iH4m6Ug06tDRN1v4
	6IIYPYNA=; b=oAMSk4a11MTbmGUsMFK+lo58+HthNdSCYo4NJDY1rZIFZ00vKUd
	zEAZaPAdAdrF0Pkq6Cg0x8DzgX4lLEg1S8Ocll9ysHR8QQ35FPPGXE1y4NuWA0JB
	wQgY+iJLC5rY4rCBCI5iytEe736umneX7sxJF/C+zGV/SPrXO/ncicNNDfMEOz/T
	3YvEw14puOaldMSF0Za/ll7LpENwGtFF58wrO4/fmZL1ixn0NYaZz/pp+zFnmwvf
	Xts3QRbh2ZWbX3tkCOoHtMm7SlqsamQsOkNzqA5mVBT1gTsp/lhgRiyf9UhCIekB
	ZfIRsfsoR5LJfUG/mZ7XWbex+1az2AuL0Gg==
X-ME-Sender: <xms:8OwJaBWgXcFJqsxPCT2iG2tgh4vExi_z6CkgxUfVgi-ELi3RJGkikw>
    <xme:8OwJaBkjAoQq_kLNw1wq2qF-5PNfzZoobHred0mfwrOIoSFwQ5S6jOGwN8uQoInx6
    2A8qdx60nP-Jf-P76I>
X-ME-Received: <xmr:8OwJaNa_3SCaNCFcTNJC0fSLrkvZ9ZbZ3w-fufOFMBRIy1KpDfdw6NVmwNk48vz--ASLdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvgeekleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddt
    vdenucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilh
    hlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfh
    hfffveelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghm
    ohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdejpdhmohguvgepshhmthhpohhuthdprh
    gtphhtthhopeihrghnrdihrdiihhgrohesihhnthgvlhdrtghomhdprhgtphhtthhopehp
    sghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhitghk
    rdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrd
    hhrghnshgvnhesihhnthgvlhdrtghomhdprhgtphhtthhopehkihhrihhllhdrshhhuhht
    vghmohhvsehinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:8OwJaEVe8OpTCoEuaomq3rdjSfdSyFOMhcOXqxwWBhTHkA_rR70YSA>
    <xmx:8OwJaLnl6fZIasiijhc5h3AiSqwgG6NHp5-eLU5X2Rehp1bns9VtRA>
    <xmx:8OwJaBeibfvuXZ02AQnNcwSoHW5eaW7l8LoZIhaF8-73Dpu9egQLoA>
    <xmx:8OwJaFE_IF_4QsPiydh4mbK2PTPPwThgDOjdQZOVDRegd0YnReK0xQ>
    <xmx:8ewJaM9gUMm_O4WgnqFPIITTvHahLrrBIXdohGvR2QetBt_cNcqqQTwU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Apr 2025 03:48:56 -0400 (EDT)
Date: Thu, 24 Apr 2025 10:48:53 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, david@redhat.com, 
	vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, xiaoyao.li@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Message-ID: <stswyrtsciz3ujhzhs72ncpozax7nawg5sbg7gbsclb5jgw5vt@y5fxmsstslca>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424030428.32687-1-yan.y.zhao@intel.com>

On Thu, Apr 24, 2025 at 11:04:28AM +0800, Yan Zhao wrote:
> Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
> 
> Verify the validity of the level and ensure that the mapping range is fully
> contained within the page folio.
> 
> As a conservative solution, perform CLFLUSH on all pages to be mapped into
> the TD before invoking the SEAMCALL TDH_MEM_PAGE_AUG. This ensures that any
> dirty cache lines do not write back later and clobber TD memory.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index f5e2a937c1e7..a66d501b5677 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
>  		.rdx = tdx_tdr_pa(td),
>  		.r8 = page_to_phys(page),
>  	};
> +	unsigned long nr_pages = 1 << (level * 9);

PTE_SHIFT.

> +	struct folio *folio = page_folio(page);
> +	unsigned long idx = 0;
>  	u64 ret;
>  
> -	tdx_clflush_page(page);
> +	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||

Do we even need this check?

> +	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
> +		return -EINVAL;
> +
> +	while (nr_pages--)
> +		tdx_clflush_page(nth_page(page, idx++));
> +
>  	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
>  
>  	*ext_err1 = args.rcx;
> -- 
> 2.43.2
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

