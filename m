Return-Path: <kvm+bounces-72168-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MFIxH5+9oWnCwAQAu9opvQ
	(envelope-from <kvm+bounces-72168-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:51:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E17F1BA51C
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0DC6F306E211
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 15:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD13441053;
	Fri, 27 Feb 2026 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="nSbeJn09";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="A7cma9dB"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180F33624D2;
	Fri, 27 Feb 2026 15:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772207232; cv=none; b=ikzB0v/ow4l1qX5mVQBVfQB+0g5dWDDmPPNinL5B5ilST95rLL56mWrAGad66F51OWaeD2ZTbOY0V0o2M8OYTrmS4Jy6uqgWteML10BoI1kTBKdmBmLEyPm3yhw6PvQvTliJ9O+yskYbtkU2zTs63A3DYbGeWAGiJkCXA5xbl80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772207232; c=relaxed/simple;
	bh=UgSApk6Vz42Cpkj7RvGNFPFj/GJVlPPsed5rfjh7CB4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VX8w4FVfb6Tr6R20AvKz+j5VU+BdU94jzazsKJQea2qr3Ht487wraRMVu5iSIeKnA4B9/CItG5SnDI13GYUjov9LtQSyHh3+H+45yFuz1kgKX+zcD5Z40vbiYGO5M0TJx82osZIbsHo2GBvpXYy3OvZ3OJfu8m++pFMkk/p8WP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=nSbeJn09; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=A7cma9dB; arc=none smtp.client-ip=202.12.124.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 1409613013DF;
	Fri, 27 Feb 2026 10:47:06 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 27 Feb 2026 10:47:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772207225;
	 x=1772214425; bh=P3lrzFyQElxBxtWsP+osjrtrIRj/rA3HI8aIxSL+eHc=; b=
	nSbeJn091CVUD7FTBlfHAGofIbMFpGvhhKPN5P+AXxi2R6g+zB9bTzPy8M7zKOX9
	190koYZVQtOhErFW5Nk2ZXp3dvbyl6UiMLVn8Vdws7SsR0yodwKy9wHBllJkNGeA
	AsGuDTTDeNXhDKsH6A+ttPLVwAgWN6I/IDfUUfKYIDL7djAhXluESe2mDgoVuE/0
	H5H5lmhuaO4ap/bK0tc8OziXtOlDMPcxvZ9+r+b71xqQG/wIdKjH1rs6QDjOCkRk
	NLaqv5GEjMIEAoVWLHqK6FLBpxQhya3L1m/31iVG+OzOLBESOmuKD7/FN0SBI+f3
	94CVvMVtttES7JAOlQJp3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772207225; x=
	1772214425; bh=P3lrzFyQElxBxtWsP+osjrtrIRj/rA3HI8aIxSL+eHc=; b=A
	7cma9dBosB0GIWXa1m7+Lm/GchbRtgqA/xwo85CSUbQlkjtuGWtWnsFqnFaEz26K
	XIjU47rn+BcT8PvTsqtvovSTHPoqwmFxcttdD8BqQeCdzm/9K2blLDhKqWUl3idP
	wIyeWR3wYpc5y+VTOnLFWijeVmHt3I48Wf5E5jBf3bfwmmPzfIEl5Uiq1ztEtCUb
	TtxChaiXmQlGbcnDqB0XuSPH9RUPouePhNnHw66TqOLnqCXBdIR+BZZwgl/mePTT
	2Ndu2PcdwnDMxOAC1MaII1xlSg8Ocgn1jc3idGiGtiMejdDwaHcAThhlfyHUQ01U
	YmEbEKrgFw3TDqLvqVi1A==
X-ME-Sender: <xms:eLyhae8NLfiHQAfvFbwIf5yfJxGrx7KxbtT7pspvJckoKaT9zcfsGw>
    <xme:eLyhae4tsQgypPwTHo2DeWnsQy7bTLUs3VcUPfd9RrYRFV5seJeMAhrG_sP3LC7Is
    d9Lnz9eMprZ9jmWg9vNexMWxYMBNR85faQxljPC31hLURgUua9RsQ>
X-ME-Received: <xmr:eLyhadjLu8rkkCiD9LuU-gLeXJaelMWBSD-DAgNH5GYD2MjN3YfraFIWVNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelfeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:eLyhaViQEXxZhGRPLBgx3cIxwcB6BJldmDuFBveN-s3uybKGEg4BVQ>
    <xmx:eLyhaT1gmUrj3pS2nastletXexcegngkRYpkqQAlCWEUiBVKvt_8Uw>
    <xmx:eLyhaQjFwwGVa8eE3K-VjdGUDc_gumNbDo92PQ-hmX33aTYcusuheg>
    <xmx:eLyhaWqfdVOxky2hgCGNQH7N4KhqFKsCvw6Ruxq0xBQwJyfcQ9Ociw>
    <xmx:ebyhaTuRNv-HWsJCaeyQT_E-CL0vqudE11keKbVebqGUMZseVXYpmczH>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 10:47:00 -0500 (EST)
Date: Fri, 27 Feb 2026 08:46:58 -0700
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
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260227084658.3767d801@shazbot.org>
In-Reply-To: <aaDqhjdLyf1qSTSh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
	<20260226170030.5a938c74@shazbot.org>
	<aaDqhjdLyf1qSTSh@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72168-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 5E17F1BA51C
X-Rspamd-Action: no action

On Fri, 27 Feb 2026 00:51:18 +0000
David Matlack <dmatlack@google.com> wrote:

> On 2026-02-26 05:00 PM, Alex Williamson wrote:
> > On Thu, 29 Jan 2026 21:24:57 +0000
> > David Matlack <dmatlack@google.com> wrote:  
> > >  
> > > -	vdev->reset_works = !ret;
> > >  	pci_save_state(pdev);
> > >  	vdev->pci_saved_state = pci_store_saved_state(pdev);  
> > 
> > Isn't this a problem too?  In the first kernel we store the initial,
> > post reset state of the device, now we're storing some arbitrary state.
> > This is the state we're restore when the device is closed.  
> 
> The previous kernel resets the device and restores it back to its
> post reset state in vfio_pci_liveupdate_freeze() before handing off
> control to the next kernel. So my intention here is that VFIO will
> receive the device in that state, allowing it to call
> pci_store_saved_state() here to capture the post reset state of the
> device again.
> 
> Eventually we want to drop the reset in vfio_pci_liveupdate_freeze() and
> preserve vdev->pci_saved_state across the Live Update. But I was hoping
> to add that in a follow up series to avoid this one getting too long.

I appreciate reviewing this in smaller chunks, but how does userspace
know whether the kernel contains a stub implementation of liveupdate or
behaves according to the end goal?

Also, didn't we violate our own contract in this patch by adding the
reset_works field to the serialization data without updating the
compatibility string?  Thanks,

Alex

