Return-Path: <kvm+bounces-67725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E84E9D12457
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 12:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F3B4A301D526
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00FE9356A13;
	Mon, 12 Jan 2026 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnMNaKXE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A3434DB7C
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 11:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768217034; cv=none; b=NeWOo8cxGtED7uaujf+srqo3zOKj3PlfG1Cj0nckgrbL1dom2zV7j+4+BpRVcCiWgSI17XJIrmVlfApbG4qd4HR7bCGgkXcQKL0yml6TrTlZIYeKA/n1/hMvtlyD0lyatTtx2vtJarTHvKinoUxUVEHc4Tsm3YPv76WSFMHOq3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768217034; c=relaxed/simple;
	bh=l0dWg9Pih1Ls0Lks8qWNFOChTy0MPCbkBVoJQfnRCxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lT30p6NNxcVRJoIPqPcYbsE8NBLVoOzf19FU9B9Ybn/cJ6khAZyLeZOWvk0zPk8aC2Dntu7Yf+aDAiFIzUJafgChV6XS4DWHoiJETwRNR5UDt3eKkRJUtIidQkWJexWim/QiwXld1vj8OmRyTSlimfg4fzomihEAc7i2ukVD1Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnMNaKXE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A979C4AF0B;
	Mon, 12 Jan 2026 11:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768217033;
	bh=l0dWg9Pih1Ls0Lks8qWNFOChTy0MPCbkBVoJQfnRCxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LnMNaKXEHRBWXzlnpzn8WUonIv2Xs+8YABkyKkwy/eeVA3xdtJ6xuCoVjX5qvz8Y7
	 hxWWSW90ISb22OYchyuTyF4n0eJav2ePoPzdjtxy+DCL8M4FRiytkXyG1DNr2Fm7kD
	 MbdkPL6yhfZBS1H3Kz3/WHhhJG0eUwyvKx3bIacGyzLiz+NEbJjIuC3JF2b6yQ6p2T
	 NPST7UqyPqSxwvhryaixs9GBpGvTQZnLCZkCO0cyxJJh0onlIlBPI+8HGcZYvhxH70
	 eg5/gpS0VDrvTAzT2ytfcW7CDArW5S1U35Q1Sk/lfu9kHHv04THGJuGfCEOs/dly+7
	 5J0o8ZQtXYlvQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6C705F40068;
	Mon, 12 Jan 2026 06:23:52 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 12 Jan 2026 06:23:52 -0500
X-ME-Sender: <xms:yNlkaV09gBKvl6p_PcQrAIMX3lfNQSYCCJpWoVxC63c9MUl1280wwQ>
    <xme:yNlkacOOf73T9vkKIuaT10vwP3tlon9VZkCyHB-8Gu41UfQdz4--XhpBO2IbFARS3
    cQV1rbHRbb1DlzzfT-zRvc08602qnRMeV6kLFhTMO6wDP6mrKMQhw0>
X-ME-Received: <xmr:yNlkaTtZLfruUiQ94z7tQZB6iIYm3i0-SS5cBtEFC0xqqzQNAV1iBplXwpTCMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduudejfedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepffffkeegffejgfekvdejgeegtddtleejkefhhfduieduhfeigfduuefghfehffdu
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkh
    gvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    kedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepvhhishhhrghlrdhlrdhvvghrmh
    grsehinhhtvghlrdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghotghosehlihhsth
    hsrdhlihhnuhigrdguvghvpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopegthh
    grohdrghgrohesihhnthgvlhdrtghomhdprhgtphhtthhopegurghnrdhjrdifihhllhhi
    rghmshesihhnthgvlhdrtghomhdprhgtphhtthhopehkrghirdhhuhgrnhhgsehinhhtvg
    hlrdgtohhmpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhigidruggv
X-ME-Proxy: <xmx:yNlkaXE_00PLc0KzT3HB6rYaKWTH43w_8iGbOVrAFESfgukNmlMmFQ>
    <xmx:yNlkaWQ3N4CjwFw7_C20ay2rJrcjci37negE3LGMEZofO5iCk7ksjw>
    <xmx:yNlkaThh_Ko52TfSbtUlAsWWJAlHdalFkwEogpleFHY1aRBTmNy-fw>
    <xmx:yNlkaSbb35_Ofwpgfd5hxYgyCZcgp_elt75Fr5RLSfjHQzEo58-tWQ>
    <xmx:yNlkacV0zyXdptqxmClrfpfNHI8lhLwK3nKEDzddTkaT79vSc7mWlArH>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Jan 2026 06:23:50 -0500 (EST)
Date: Mon, 12 Jan 2026 11:23:44 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, x86@kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 2/2] x86/virt/tdx: Print TDX module version during init
Message-ID: <aWTZo_SrAKfnQo9O@thinkstation>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>

On Fri, Jan 09, 2026 at 12:14:31PM -0700, Vishal Verma wrote:
> It is useful to print the TDX module version in dmesg logs. This is
> currently the only way to determine the module version from the host. It
> also creates a record for any future problems being investigated. This
> was also requested in [1].
> 
> Include the version in the log messages during init, e.g.:
> 
>   virt/tdx: TDX module version: 1.5.24
>   virt/tdx: 1034220 KB allocated for PAMT
>   virt/tdx: module initialized
> 
> Print the version in get_tdx_sys_info(), right after the version
> metadata is read, which makes it available even if there are subsequent
> initialization failures.
> 
> Based on a patch by Kai Huang <kai.huang@intel.com> [2]
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/all/CAGtprH8eXwi-TcH2+-Fo5YdbEwGmgLBh9ggcDvd6N=bsKEJ_WQ@mail.gmail.com/ # [1]
> Link: https://lore.kernel.org/all/6b5553756f56a8e3222bfc36d0bdb3e5192137b7.1731318868.git.kai.huang@intel.com # [2]

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

