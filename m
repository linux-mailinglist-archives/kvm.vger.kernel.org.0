Return-Path: <kvm+bounces-72110-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHeyHJPaoGk+ngQAu9opvQ
	(envelope-from <kvm+bounces-72110-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:43:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A0D1B0FCC
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 508A03069001
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD973314A4;
	Thu, 26 Feb 2026 23:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="gLN0v/HG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AVqkdu04"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368F33328E7;
	Thu, 26 Feb 2026 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772149367; cv=none; b=cJQojp8PA804Fap0z1f1b/G6wkpLtLmEUrHSBySHlz44LmaJh+2D1Xgz9ND101ZAXJTSgIZ8CDr4gofJJKgahQpAw8E76Gio8IlEHmFtrtc68GNRICIfp8yzZx3rbVU8668MtNwJxS2LQIBdAY4ZrM3RV4jqAaZkxUNmcyixucc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772149367; c=relaxed/simple;
	bh=IENANlu85/u2WVrzmqkEiDnGXgZ22/KDKpTypluMqyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJuNWLQHyOnanul1muIoYTlFhDiEWBo90B7DhTH6e3WaKmPjTDy/hDTBCctV1qk2HVXEtP30clN3ajAkGCafAGqaHjsy0/WPwQ5ZOjiWwpMYyD8wZ999zam8f2BtAV997687wWpaQR98bVk8XC51jxgXQ9d7ol9Y07Sd4ORw9K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=gLN0v/HG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=AVqkdu04; arc=none smtp.client-ip=202.12.124.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id B11A81300CD7;
	Thu, 26 Feb 2026 18:42:41 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 26 Feb 2026 18:42:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772149361;
	 x=1772156561; bh=du7fewflJTiy4RY4M9JcEhPtcfpcGR3V2HHqx7PYFdQ=; b=
	gLN0v/HGUd/V0nfv+tewCC0psNtLQyjZbWvqVO9SniKU+XNel86qvzNsxsTS2rhP
	+Sasie1tUUqBrpPWrS09obG6ygRmkANwrxgWOkCDM99YeG1dyTDlauIbYKRX8PE2
	WMakPQx/cPdRv4HjyoQeOHuAIZTAsaIRiUHu3wpM4uMYzA7nCBVjEz06MLdEm41A
	Sd4QgIB3SB6ZjLRB8hTA+mwlxHlwx7LRGMAhY+tlWeo8q2rfRxajhWY6qzz8WA9h
	w990EEzbp4MIikkoNHGMBz72bsWhYPccOx4lL3iso06dObf9sebg+f59s/ouRF2H
	bgZsfIzIQ8mNqjwY526TqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772149361; x=
	1772156561; bh=du7fewflJTiy4RY4M9JcEhPtcfpcGR3V2HHqx7PYFdQ=; b=A
	Vqkdu04ZkIyGghzqKCUsqcO0POg3Ui7ZMXshuBnxTI388SOk5n10HzYar+rqSDAe
	C/6uGkhD0UC469ivtIUm6MMC5QT+s8RjGroeEQvOS7hXEzSI7hPHQ1ifklfb12AJ
	PZd4rLcWNzS3UBm315m+HpVcQYcoJZ47S4md1oBQZBtfB/90epcrjjt5NDuahanp
	yQ3OJeL9M9U+r3JPhk7hScLGNo3WIMaBA+LMuiOdPtSeCN+7DALf2bLoYs+W0zFh
	vTB1GITGhgd6ioaYRTmpsF+ZbOVhD3SSJMh1OEJPx8/oaB0nIvL/n0pYvarZcmQ1
	/SgJdlDJNbNiv4KcTcrxQ==
X-ME-Sender: <xms:cNqgaXpMmxoB3kSOky1mjx1TJLbpYE_Q3lq2_z-dSIS4jA6vVHQ8qA>
    <xme:cNqgaec7-4keVSCV7QvjAX8g0Bou_cq9lPLalblxCAnCUWGc4psij64v2CSOOGvJO
    09nNikj6hf5yRVfrj5XEWa0utzNlcS8aA1clUFTK3T5w5NPDwIqAQ>
X-ME-Received: <xmr:cNqgaYaQZ8vQYnZbKPuXo5gMhT_Lqft1yYIxjfNrQSAa3SsKG1FQ_U4-QlY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeejgeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpd
    hrtghpthhtoheprghjrgihrggthhgrnhgurhgrsehnvhhiughirgdrtghomhdprhgtphht
    thhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheprghmrghsthhrohesfh
    gsrdgtohhmpdhrtghpthhtoheprghpohhpphhlvgesnhhvihguihgrrdgtohhmpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghs
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhhrihhslheskhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:cNqgaZBWGEMBMo6wAeDnQPoMQ1RB3_FyXD2bgYUBYWWoy3Nil71WIQ>
    <xmx:cNqgabDwuVEK97fr6qnquLcLxnx5_OEE9X7aEzrRhC22YMC0y9IyVw>
    <xmx:cNqgabV1-aqR1IFCc4MWo42xThetUjXbFjeGkiZ1NoD4KZoSUHe_tw>
    <xmx:cNqgaSC5ljiRgzmy6yv2HrPe3PYxrEU4Q8gCyruiHKSfRU2iM0Ohlw>
    <xmx:cdqgadKScMQkDT3KYeKNbDm9q2hUFzCVi1EFn1C9LtAtHYSjWGZ0Cjjz>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 18:42:37 -0500 (EST)
Date: Thu, 26 Feb 2026 16:42:36 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?B?TWlj?= =?UTF-8?B?aGHFgg==?= Winiarski
 <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>,
 Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>, alex@shazbot.org
Subject: Re: [PATCH v2 08/22] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
Message-ID: <20260226164236.1d091ffe@shazbot.org>
In-Reply-To: <aaDW86eWuQLZ3cfP@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-9-dmatlack@google.com>
	<20260226161512.532609ec@shazbot.org>
	<aaDW86eWuQLZ3cfP@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72110-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,messagingengine.com:dkim]
X-Rspamd-Queue-Id: C9A0D1B0FCC
X-Rspamd-Action: no action

On Thu, 26 Feb 2026 23:27:47 +0000
David Matlack <dmatlack@google.com> wrote:

> On 2026-02-26 04:15 PM, Alex Williamson wrote:
> > On Thu, 29 Jan 2026 21:24:55 +0000 David Matlack <dmatlack@google.com> wrote:  
> 
> > > +	/*
> > > +	 * This device was preserved across a Live Update. Accessing it via
> > > +	 * VFIO_GROUP_GET_DEVICE_FD is not allowed.
> > > +	 */
> > > +	if (vfio_liveupdate_incoming_is_preserved(device)) {
> > > +		vfio_device_put_registration(device);
> > > +		return -EBUSY;  
> > 
> > Is this an EPERM issue then?  
> 
> I was thinking EBUSY in the sense that the device is only temporarily
> inaccesible through this interface due it being in a preserved state as
> part of a Live Update. Once the preserved device file is retreived and
> closed, the device can be accessed again through
> VFIO_GROUP_GET_DEVICE_FD.
> 
> EPERM might lead to confusion that there is a filesystem permission
> issue?

Ok, fair explanation.  Thanks,

Alex

