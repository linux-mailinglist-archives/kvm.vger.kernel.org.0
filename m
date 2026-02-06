Return-Path: <kvm+bounces-70435-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHKfEPPShWmOGwQAu9opvQ
	(envelope-from <kvm+bounces-70435-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 12:39:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 34935FD514
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 12:39:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 95F0230205FF
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 11:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BD93A0E90;
	Fri,  6 Feb 2026 11:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hr0K/6DC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944702EA732;
	Fri,  6 Feb 2026 11:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770377962; cv=none; b=KRpoQ0BbYHuYQ/RuW4bCcV+vyZ65tg0kcGgEpCN5uTOEXAMw62J5cpyxwZythudB+RRsrN02/7/fNt3QButryZ6HOAWH3FaJHZCCkpvRx06FFEED4UAFNCOAiDab6o5JtuH1Xz3Rhb0+2yGI3pDx+UBumQfCmoR26J0A7eXsssE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770377962; c=relaxed/simple;
	bh=w5cKQjFsOjcIjME+bKTjgyct3g6oNQjGUh6F1YZyWpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3v1PYfVIsXPxfwhY6LSWvLW3yZEAIuJcXLqqmVFdZuetyHp4gYEDln0YRqh2owbaYRdKLEpk+i+T9Jti3pSURd43RbEjvfBh9uXKNpWcm/oG9+UUV9k7G/0XuJTs5omT5D9QJ/HMfUAfzsLXDnGXetRbTWxOBIfb4ejFtRgmUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hr0K/6DC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D795C19422;
	Fri,  6 Feb 2026 11:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770377962;
	bh=w5cKQjFsOjcIjME+bKTjgyct3g6oNQjGUh6F1YZyWpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hr0K/6DCn5r6l9+6puYu4goS8nBZ2DFP1Lww9R6v8EG5qqoGX0FzDMBRUcRQJ3uYZ
	 ythy0wLLjl0BusWtqBD+SAmIC2k4i3R0nFQD+YJrII71Li8TLBRPc64IoYZROYWkRs
	 fJf6TFoCC+cf8AihGbEJybKUMuWQBp3v42B9IA0VZxkaxDf74SMdVAM+xs6od1h3gT
	 f1JOSxlQJ4gSpMKZpmaCwfgiINfVn3HZrtOEAivn9JF/gR+tl60srr13GY3A5l0mKb
	 nRkU9iMjdA6bkEc27s50oahKfB8faxW5hzmxwyVkT0YypGwD0c3akpkIGSOqadCme0
	 gpsOLA5hEKiHg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 92A3FF40068;
	Fri,  6 Feb 2026 06:39:19 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 06 Feb 2026 06:39:19 -0500
X-ME-Sender: <xms:59KFaSzYE_RXr164vn8CttXgN9sd8r9pfS75AJBy-bKp8iZEQPgIZQ>
    <xme:59KFaeZyQp8ydK5JX1S6juGT0hFlXnDy05jte73ecaVfjwX4VLk2PVdKkyGTSDAYc
    X0hpNb5UdOykuZF4qIllsTHJpN6naOopSxup2wLAtf71ShmWEoq-Dc>
X-ME-Received: <xmr:59KFaSLuY91bfZZIssrsPlFcVLfKDJrQBGAlq0swoXs9XaXhsUNr53_tPu6d9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeektdejucetufdoteggodetrf
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
    grsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnheslhhinhhu
    gidrihhnthgvlhdrtghomhdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqtghotghosehlihhsthhsrdhlihhnuhigrdgu
    vghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheptghhrghordhgrghosehinhhtvghlrdgtohhmpdhrtghpthht
    oheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtoh
    epkhgrihdrhhhurghnghesihhnthgvlhdrtghomhdprhgtphhtthhopegsphesrghlihgv
    nhekrdguvg
X-ME-Proxy: <xmx:59KFacwvzKIac4Vumi31z5SwA3ol-Q_nWNalg4rSW1ynJfECr9BQjg>
    <xmx:59KFaSNQCxaQeLYlCE-viH92mc8xw3J9tv1_TPeOo1w2OyafbCuhQg>
    <xmx:59KFaYuEmna0Q5KOujSwvg4Q-hnhSGqKN7wJYelgMHrKBu01YkfnHA>
    <xmx:59KFaX13dfCly2p18ZGXOji3LZn-XOZNKUn0o7mx8Rxx_IE0XDRkwQ>
    <xmx:59KFadAvLXJeCVoB8BeDRqbfdQZX63ea1AYR22mIpW8gajwoypSrYf6q>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Feb 2026 06:39:17 -0500 (EST)
Date: Fri, 6 Feb 2026 11:39:11 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, 
	dave.hansen@linux.intel.com
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, 
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 0/2] x86/virt/tdx: Print TDX module version to dmesg
Message-ID: <aYXSd8B00OtKZcAU@thinkstation>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <6d8d37740459963e6fd7f16a890a837b34ebdf17.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d8d37740459963e6fd7f16a890a837b34ebdf17.camel@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70435-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kas@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 34935FD514
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 07:05:39PM +0000, Verma, Vishal L wrote:
> On Fri, 2026-01-09 at 12:14 -0700, Vishal Verma wrote:
> > === Problem & Solution ===
> > 
> > Currently, there is neither an ABI, nor any other way to determine from
> > the host system, what version of the TDX module is running. A sysfs ABI
> > for this has been proposed in [1], but it may need additional discussion.
> > 
> > Many/most TDX developers already carry patches like this in their
> > development branches. It can be tricky to know which TDX module is
> > actually loaded on a system, and so this functionality has been needed
> > regularly for development and processing bug reports. Hence, it is
> > prudent to break out the patches to retrieve and print the TDX module
> > version, as those parts are very straightforward, and get some level of
> > debugability and traceability for TDX host systems.
> > 
> > === Dependencies ===
> > 
> > None. This is based on v6.19-rc4, and applies cleanly to tip.git.
> > 
> > === Patch details ===
> > 
> > Patch 1 is a prerequisite that adds the infrastructure to retrieve the
> > TDX module version from its global metadata. This was originally posted in [2].
> > 
> > Patch 2 is based on a patch from Kai Huang [3], and prints the version to
> > dmesg during init.
> > 
> > === Testing ===
> > 
> > This has passed the usual suite of tests, including successful 0day
> > builds, KVM Unit tests, KVM selftests, a TD creation smoke test, and
> > selected KVM tests from the Avocado test suite.
> > 
> > [1]: https://lore.kernel.org/all/20260105074350.98564-1-chao.gao@intel.com/
> > [2]: https://lore.kernel.org/all/20260105074350.98564-2-chao.gao@intel.com/
> > [3]: https://lore.kernel.org/all/57eaa1b17429315f8b5207774307f3c1dd40cf37.1730118186.git.kai.huang@intel.com/
> > 
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> Hi Kiryl, just wanted to check on the plan for this, I didn't see it
> merged in tip.git x86/tdx (or any other tip branch). Were you planning
> to take it through x86/tdx? Can I help with anything to move it along?

I guess it has to wait after the merge window at this point.

Dave, could you queue this after -rc1 is tagged?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

