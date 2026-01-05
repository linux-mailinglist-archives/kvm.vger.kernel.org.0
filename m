Return-Path: <kvm+bounces-67042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B736CF305F
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 11:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E4F4306B79D
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 10:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71F0F314B9F;
	Mon,  5 Jan 2026 10:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+MADKkZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8365F314D05;
	Mon,  5 Jan 2026 10:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767609503; cv=none; b=mS5rrhquYPYHl9vRvWJQryXmbqP8yQHUEUy/LdB4ZYOm2O2ttW9Pmxe283wTR8zFQ0gc9Hl79EVR1k5xOCenZ1O6gQVzHwie3ihOafeFWVau4yYHBQXMXmFGnTjXWQvsZc4lOFzLTthYTyBJ4oASlex2CCEeRSudXODasOl1XH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767609503; c=relaxed/simple;
	bh=KHZ7NQkpRAHt8FC7knbT4JsGL/W9gz8FeFxY75EaJh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3t/vjASI+OYKHgy0knbgFhXZhgIEcalShghBxRhoNMf6yhIORm8uVSOoNtSVdO18v3PVXPT/e8iRKZ+elJc5gmN6qQUVKxjHEpp70aDDwHt0KWv5DV2bHKnjjUmzBWtaihqWjmevnq4aJNHQ3VViIA8S6ZW4dLqEcylAsSrAZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+MADKkZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85505C4AF09;
	Mon,  5 Jan 2026 10:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767609503;
	bh=KHZ7NQkpRAHt8FC7knbT4JsGL/W9gz8FeFxY75EaJh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n+MADKkZEHODA7S4in+VnuQ3XiIzpNKJFa2bzbXbHU6cZxzdBZqWNLMrPgKlhV/lL
	 +awkpFSe0zKoNc3qD7HPo8Jbf7utxV4HmBK6spKx5v/4bJXYXjOpZhbyP2gw+M721e
	 D4fQaGWreiEKmLnO9gWM4yQh++TwwlKAjY7bRMgEG74d/BmCuVdQGRp6vkJI2rRRa0
	 wSy0hMUeGdbobDsyJL1DXIv6XCVwyYqWH9wxAaowE21qgsxcoiQ620UF0cog6KFj92
	 by4/gV8JFffoxXpIZHCMgfKzQKhZhYlT2gckzoWkx2/uixRr95HAIlbzDDJUbtXJ0n
	 gAlRrvrYz9ecw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id A8FB2F40069;
	Mon,  5 Jan 2026 05:38:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 05 Jan 2026 05:38:21 -0500
X-ME-Sender: <xms:nZRbaYwmHa7-9wIBrS62w5ESyTexyOCnB-7Xcsj04LTXafNn3rBsGA>
    <xme:nZRbaZ7supFxh1LHc2n6_ziayZlplKyo2cnm_kRl8biOHpMKiB-faZZkwaSDOnGh1
    h6iqmXhyyR73R3Lp_3VrMqlJE_qMwxOyMi1Qjz7gVkGIazAwEIWIDMp>
X-ME-Received: <xmr:nZRbaRtFDfLjfknGyQtKllCe8fCAG36AF67gGHtTqKJRztTnqwn4Q5zT8KVZVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeljedtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheptghhrghordhgrghosehinhhtvghlrdgtohhmpdhrtghpthhtohepkhhvmhesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishht
    shdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvihhshhgrlhdrlhdrvhgvrhhmrgesihhnthgvlhdrtghomhdprhgtph
    htthhopehkrghirdhhuhgrnhhgsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrnhdr
    jhdrfihilhhlihgrmhhssehinhhtvghlrdgtohhmpdhrtghpthhtohephihilhhunhdrgi
    husehlihhnuhigrdhinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:nZRbaet6yOwvgd-HUqpPcpSrCOrc-Nh0XjhpJDvtktvz5QKb3X0UDw>
    <xmx:nZRbaRswVxQDD325pkMsnIMI0kvddF2LoUG7p8e9GOO2YKRt5nC1MA>
    <xmx:nZRbaW4-y6QpwOwoLBYXbW5Hag7W94MPaPmqEl5ZDll2hNpNEnW4dA>
    <xmx:nZRbacCz5sAY0czwANYL330mlFsFBqnZdbvZ_SZQNdXxj8q7Q2j1Qg>
    <xmx:nZRbaeskDlrXO5WuaPpquK2Rggu3I20pViuSANqnY8SbtOUggljQKuFk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jan 2026 05:38:21 -0500 (EST)
Date: Mon, 5 Jan 2026 10:38:19 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, x86@kernel.org, vishal.l.verma@intel.com, kai.huang@intel.com, 
	dan.j.williams@intel.com, yilun.xu@linux.intel.com, vannapurve@google.com, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/3] Expose TDX Module version
Message-ID: <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
References: <20260105074350.98564-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105074350.98564-1-chao.gao@intel.com>

On Sun, Jan 04, 2026 at 11:43:43PM -0800, Chao Gao wrote:
> Hi reviewers,
> 
> This series is quite straightforward and I believe it's well-polished.
> Please consider providing your ack tags. However, since it depends on
> two other series (listed below), please review those dependencies first if
> you haven't already.
> 
> Changes in v2:
>  - Print TDX Module version in demsg (Vishal)
>  - Remove all descriptions about autogeneration (Rick)
>  - Fix typos (Kai)
>  - Stick with TDH.SYS.RD (Dave/Yilun)
>  - Rebase onto Sean's VMXON v2 series
> 
> === Problem & Solution === 
> 
> Currently, there is no user interface to get the TDX Module version.
> However, in bug reporting or analysis scenarios, the first question
> normally asked is which TDX Module version is on your system, to determine
> if this is a known issue or a new regression.
> 
> To address this issue, this series exposes the TDX Module version as
> sysfs attributes of the tdx_host device [*] and also prints it in dmesg
> to keep a record.

The version information is also useful for the guest. Maybe we should
provide consistent interface for both sides?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

