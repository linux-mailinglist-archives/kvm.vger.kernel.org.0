Return-Path: <kvm+bounces-58133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8258EB88A20
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 11:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41FE71891F64
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70FEA3074BB;
	Fri, 19 Sep 2025 09:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9sAE3mX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9054A306D4B
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 09:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758275089; cv=none; b=ELq0zeYD9SmsbHLaMjbuHQQ87WYS74n7qZH4GHLkhz9lnwzHF1MBZbPd6C3sIAg1vxpsVF6FUmzFoPSYZBGbpYRNM9d28x32Ohv3q4Ofnnod90P5xwIqeTIdHBi4msrjr8XeBlxAePbG5+3ZFznHEZN92HJe655hXJ2wuucoSfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758275089; c=relaxed/simple;
	bh=Zc2EnsY0CcMHndLUfH9ZokqXC5xQl37IFdd7qM4BinM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0mSgMpp3N8r1Cp4/hD8xN6dS6DZgNv1UIpN1HLbsTkuQVRaaNwyUx2IMqomQtnfsW7Ab/QvaM89hHqsl1PqcHs4RwM5x1Zntf4ru6H6KZT41fJMfh1BVhKM4ON3stK5q1ZNmOQuPNulkdRcM06Wea5uSyd7xPk0bScjDWRd9ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o9sAE3mX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0331FC4CEFC;
	Fri, 19 Sep 2025 09:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758275089;
	bh=Zc2EnsY0CcMHndLUfH9ZokqXC5xQl37IFdd7qM4BinM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o9sAE3mXH5E1Uvu5syp41HXl+LkJ3Jai8gXRvi7b2vtZJOF09sYUPAaybJsNiiunL
	 5xSaydEzwkc8DiHy6j6PHl+YSwp8JeKD8GNUyS/LS1Xyf19mYxOqqH8aN6aAscAKKD
	 ScACNMAaIOGWfTy0vsxcyDLg41XXS/nWXDFR98HF7gN80ZJOcrHddJgDjEMva+x0Rr
	 Idbl1iz+6jPgW5mdVtymFhRY4z5M1YaxTOiBbvK9/TKdOID1kGgRT/dbIUaM5Iulp/
	 FF0sX7mQtWWTcx+4hnH1LbxpvEtZvqQFf4V+odUYld/IbCVU7KdpZd5o0w0H06LcF8
	 IDsvaXOrlmpXw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1417CF40066;
	Fri, 19 Sep 2025 05:44:48 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 19 Sep 2025 05:44:48 -0400
X-ME-Sender: <xms:DybNaIUyQvym_iKiasjifmprBiVzxrdTYsYhDEeJaA85y4FmIoJ_Yw>
    <xme:DybNaN2BCGYOJkwCnYM--vu1iK0LDWd-kuCYMDT8AKhkmpTssfym7NkuEwRFGcb4H
    AlJgvYlAgO7gJJcUNQ>
X-ME-Received: <xmr:DybNaBuUp8FimWp9yndR6JYdkp72zwItjmrS6f1kI4LEosZ0hX-SkDcRpil_ew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegkeekkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgestheksfdttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvddufeetkedvheektdefhfefjeeujeejtdejuedufefhveekkeeffeetvedvffek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehrihgtkhdrphdrvggughgvtghomhgsvgesihhnthgvlhdrtghomhdprhgtphhtth
    hopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopegthhgrohdrghgrohesihhnthgv
    lhdrtghomhdprhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvg
    hlrdgtohhmpdhrtghpthhtohepihhsrghkuhdrhigrmhgrhhgrthgrsehinhhtvghlrdgt
    ohhmpdhrtghpthhtohepkhgrihdrhhhurghnghesihhnthgvlhdrtghomhdprhgtphhtth
    hopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    tghotghosehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqkh
    gvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:ECbNaFTjhsWHW_IzDhE-H8l2YhZqx5jadFNl4Q2MNpd0NBunuN7J7Q>
    <xmx:ECbNaDAPRIY6SPhcLaeerYAg5YDusGdMU72Ru3qhNnZj8iYuguRFwA>
    <xmx:ECbNaHxPx_oqJAs-kjWJZ9xWxpl3YR1Fes-P8kAbzXU020HVmk-pmQ>
    <xmx:ECbNaLvAJYpvie9-7MVnoHHbpoDhUMbjpwRYXnNQLOABpeXP0JUvMQ>
    <xmx:ECbNaIlcfZ5wZPb4wfwBz4WfQLVdIWokO_k6HI9OZI4BEnWDpdSnZpPO>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Sep 2025 05:44:47 -0400 (EDT)
Date: Fri, 19 Sep 2025 10:44:45 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@linux.intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org, 
	yan.y.zhao@intel.com, vannapurve@google.com
Subject: Re: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
Message-ID: <x64nziosjtknntkgwmkrginncr67xp2fwdpzooabp3ysfim562@m3kdshgibz6b>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250918232224.2202592-12-rick.p.edgecombe@intel.com>

On Thu, Sep 18, 2025 at 04:22:19PM -0700, Rick Edgecombe wrote:
> Move mmu_external_spt_cache behind x86 ops.
> 
> In the mirror/external MMU concept, the KVM MMU manages a non-active EPT
> tree for private memory (the mirror). The actual active EPT tree the
> private memory is protected inside the TDX module. Whenever the mirror EPT
> is changed, it needs to call out into one of a set of x86 opts that
> implement various update operation with TDX specific SEAMCALLs and other
> tricks. These implementations operate on the TDX S-EPT (the external).
> 
> In reality these external operations are designed narrowly with respect to
> TDX particulars. On the surface, what TDX specific things are happening to
> fulfill these update operations are mostly hidden from the MMU, but there
> is one particular area of interest where some details leak through.
> 
> The S-EPT needs pages to use for the S-EPT page tables. These page tables
> need to be allocated before taking the mmu lock, like all the rest. So the
> KVM MMU pre-allocates pages for TDX to use for the S-EPT in the same place
> where it pre-allocates the other page tables. It’s not too bad and fits
> nicely with the others.
> 
> However, Dynamic PAMT will need even more pages for the same operations.
> Further, these pages will need to be handed to the arch/86 side which used
> them for DPAMT updates, which is hard for the existing KVM based cache.
> The details living in core MMU code start to add up.
> 
> So in preparation to make it more complicated, move the external page
> table cache into TDX code by putting it behind some x86 ops. Have one for
> topping up and one for allocation. Don’t go so far to try to hide the
> existence of external page tables completely from the generic MMU, as they
> are currently stores in their mirror struct kvm_mmu_page and it’s quite
> handy.
> 
> To plumb the memory cache operations through tdx.c, export some of
> the functions temporarily. This will be removed in future changes.
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Makes sense.

Acked-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

