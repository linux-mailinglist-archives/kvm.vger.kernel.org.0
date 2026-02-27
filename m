Return-Path: <kvm+bounces-72173-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GYFADjIoWkVwQQAu9opvQ
	(envelope-from <kvm+bounces-72173-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:37:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1561BAE02
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C6A333054D26
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B757E345CA5;
	Fri, 27 Feb 2026 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="UvJQORvM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hDQJW6C9"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB44D26560A;
	Fri, 27 Feb 2026 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209964; cv=none; b=WO1zOp5U/V5COJd5rR/ZSDoocbuGrjtG5VtNSwTqbTf1+EYOkjjGp1VrXPB/VbRIGIp92ITv1VdcxETsCfgc6ZLYZMV0wxDkBRoXZ3455wYqwCIVal7wiajfvrnAOikNdvLUAk3gpr5Wl45SGoRhkW9wvZmz6cVmrCvj2CE2V1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209964; c=relaxed/simple;
	bh=wrC11vtLTokHCycbkNFYy91o4ea5t4/SpwDnFVAceAw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJC+Hm7Zrb6phev24i00avJQh2sw8+6PGiNKp3oS2pqQx7Tyu9WRanUQzeQ45vyr2p5kXaGQspEligMgvrEp09z2bSRTIT9RlwOMyXPqYgLxd3ah7IgdNH8GvWpKb/6ZGPJ58IKQQWjmhXqJnyWuCF6qylO+Qp3ArJokdL1FgNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=UvJQORvM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hDQJW6C9; arc=none smtp.client-ip=202.12.124.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 471F51300DDC;
	Fri, 27 Feb 2026 11:32:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 11:32:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772209960;
	 x=1772217160; bh=U8o0TeKupqWBpq050X2z2KjPSahNrCwyfHa+2hao158=; b=
	UvJQORvM3WSu1z7xDhvqaxf9hC6sa76YjMz/scZXjdy/L6YljiwPnaTuJ30TFex8
	PNntGEmwaqA+vIv0O+jRj4gyQ4JqJiAsTjaCPr1D9eoxzBb0MdI4dA9c8o/Z5v2S
	Q7gv4UM6c872LJRvs3yM96dYLdxOWYtX0T8q8F/WO51S2yri1/DKv0Rsi/6k4StV
	SJOkAcVzvRHWFuj8vjnWS4vJHiStYc2ycYxTaeRSSSYtEoMXjoX8B8uPGH7gahuN
	Wlz80WBR9iQTvIHWdFYAGZGJtbk21w+DNatLmEZw1qds3V2G/xe8GUqfcxC3fgKg
	fXkztxWj7Y0GgGnzi73A1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772209960; x=
	1772217160; bh=U8o0TeKupqWBpq050X2z2KjPSahNrCwyfHa+2hao158=; b=h
	DQJW6C9ZQsl+cSxSNqXEkYgt1MeeXA/LF+V/Q0vonxd/ZtKg+svWyiVt8Z0aQ9Gb
	oG0Z/DkH/k6F1SsBn4/xRb6V4mz8s20F0k0/F37P0D3aX3UnJAmUZGWONhKWbGHr
	QWgpqzs4CKH2WOJGvtuwZ5MDZGVF0YFNKXQtuIGYlbYDYu5u+xbmjDrbHTQOpYZ+
	JjbPTUa78tPkuJUWrdp9YRAKRCZXuL57/vIzkXCJbPky9cyeiKEwz6BQfcyR5LPy
	ns6iQ0WzaR1UssEeqJpnlymBANVKyhfpBExBaSeb0L6E8p7sLgfPncAbGLZ6auM0
	bwTM1Qb4qg6OGApznwbPw==
X-ME-Sender: <xms:J8ehafZlsZOjc3_GLRFi4h5tWZ_j39o91QnUDyRJrItDzcwi7KraSA>
    <xme:J8ehacD4oLMaXgiufHOx7RuNmUZ2KcT58IQXmnadBxkzX7loWOuT_Faz9z10-R47c
    s_mMj9iSe2a56NsAIHTwW5eXMvsyKiSrrmFI4cRQULuNzzQFJSrFQ>
X-ME-Received: <xmr:J8ehaXgvfUMoIDFx1-N0_S2LZI5xIUBVR4hia4g9tz0jTB1PQar5sxgb1Zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelgeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeeftdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegkeejhedvtdelledvvdekuefgieelgeeuleevhffghffggffhjefhfeeh
    ueffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeeipdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpd
    hrtghpthhtohephhgvlhhgrggrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghj
    rgihrggthhgrnhgurhgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehgrhgrfhesrg
    hmrgiiohhnrdgtohhmpdhrtghpthhtoheprghmrghsthhrohesfhgsrdgtohhmpdhrtghp
    thhtoheprghpohhpphhlvgesnhhvihguihgrrdgtohhmpdhrtghpthhtoheprghkphhmse
    hlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrnhhkihhtrges
    nhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghssehgohhoghhlvgdrtg
    homh
X-ME-Proxy: <xmx:J8ehaZQZcL6lZPF1tlS2vXNQrO4J8CAoDaz7yWMPTyzWglyUwjBO5g>
    <xmx:J8ehaZsrct2tN8zKyTrWREhB4jzHQ_Fv2oAmSJc4BikE_AF4Xj42xg>
    <xmx:J8ehaT_vdDuQ_DgLxEW0346_iNl-iCv0_xBOZodxKDVm2Tf1CiGErw>
    <xmx:J8ehaVYG6UTWYipiljkmMYLzXh80DAKiM45iJealDLXXbTVMK8PklA>
    <xmx:KMehaZfMe4KUyMFYKfHfXG7vObZA_yiAuEBY2xndXJSajNdx2KREBiW2>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 11:32:35 -0500 (EST)
Date: Fri, 27 Feb 2026 09:32:33 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
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
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260227093233.45891424@shazbot.org>
In-Reply-To: <aZ-TrC8P0tLYhxXO@google.com>
References: <20260129212510.967611-3-dmatlack@google.com>
	<20260225224651.GA3711085@bhelgaas>
	<aZ-TrC8P0tLYhxXO@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	FREEMAIL_CC(0.00)[kernel.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72173-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim]
X-Rspamd-Queue-Id: 0F1561BAE02
X-Rspamd-Action: no action

On Thu, 26 Feb 2026 00:28:28 +0000
David Matlack <dmatlack@google.com> wrote:
> > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> > > +{
> > > +	struct pci_dev *dev = NULL;
> > > +	int max_nr_devices = 0;
> > > +	struct pci_ser *ser;
> > > +	unsigned long size;
> > > +
> > > +	for_each_pci_dev(dev)
> > > +		max_nr_devices++;  
> > 
> > How is this protected against hotplug?  
> 
> Pranjal raised this as well. Here was my reply:
> 
> .  Yes, it's possible to run out space to preserve devices if devices are
> .  hot-plugged and then preserved. But I think it's better to defer
> .  handling such a use-case exists (unless you see an obvious simple
> .  solution). So far I am not seeing preserving hot-plugged devices
> .  across Live Update as a high priority use-case to support.
> 
> I am going to add a comment here in the next revision to clarify that.
> I will also add a comment clarifying why this code doesn't bother to
> account for VFs created after this call (preserving VFs are explicitly
> disallowed to be preserved in this patch since they require additional
> support).

TBH, without SR-IOV support and some examples of in-kernel PF
preservation in support of vfio-pci VFs, it seems like this only
supports a very niche use case.  I expect the majority of vfio-pci
devices are VFs and I don't think we want to present a solution where
the requirement is to move the PF driver to userspace.  It's not clear,
for example, how we can have vfio-pci variant drivers relying on
in-kernel channels to PF drivers to support migration in this model.
Thanks,

Alex

