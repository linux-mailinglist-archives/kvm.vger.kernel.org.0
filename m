Return-Path: <kvm+bounces-72170-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sL3HJHnDoWkVwQQAu9opvQ
	(envelope-from <kvm+bounces-72170-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:16:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E2B411BAB10
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:16:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 877D630B5D28
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA7D44BCBD;
	Fri, 27 Feb 2026 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="jr3vgegU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tvscZopf"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CDE220F2D;
	Fri, 27 Feb 2026 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772208300; cv=none; b=PHLCkQZDlnZ+s5E8b8ByZ+nsWVIS9VJQfTQ45cUF2B1UCDBfsnohkHYc9f0n7G0APke03NamkneRlvnhd69Y0BI5F1Wa4eTqD5zcJ5vxDfqYUXjub02pLrwvpVQAJuo6dMi7w0Im4u/dZa1vYwYg8zxlv2/GSseBqlvxIdUOmVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772208300; c=relaxed/simple;
	bh=6xT3Dztb8MKL9P9vHsdzESwQNyYayz+saDCeiG7j2O0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GP/cj+RfjBfkv1o6k3OmWclIxzwqq8TuI7TkuAyH9QL2+uzHuLQn5k6Kc5yDPWG/0tsaqA0fnLKs/3PtIBMLrRDbTPOPinCzacCuMv5RAMImNb0cY2U3NuxYq6LmJZ7osAnmmSqHtL7n08pFsXUt9rQy/kcoMCyeInv+NokYwyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=jr3vgegU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tvscZopf; arc=none smtp.client-ip=202.12.124.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 43E3B1301495;
	Fri, 27 Feb 2026 11:04:56 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 11:04:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772208296;
	 x=1772215496; bh=9iPiw6U5zQK+rw2Kav/sKN2Hf6ijXsHI7/gXVV2UUoE=; b=
	jr3vgegUcdiHcY8N3v9Ti9WcEJ5nINZ1LAG8Tq0MP7dsOTevP5c791I1/P/v4BsQ
	7iHi6zv1sNVSXsUMC/t5FLaK2xSmrbpAOfmmZb18i1xzVnDp580eWMO6P/vu8J3V
	vwZdKbbp158lxye+S/hdnWtDfgurN6NArNK1wHg5kvh2T7k9D3Dl5AgSBo/Oh063
	rgZYEdUC4Z0rqwhPIHKhe/hnwRs9kCtNTpjS0BXScOr88+CNoLHwIpSo9mo5OTMx
	Ry2YwDsNycGr97KOYjlMny2hy9bIhPG3Yt5lw1qqv/D2fwpmZLUn6Ho2FM7GyIHc
	aGqnwznkm0tYuPiEISOBZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772208296; x=
	1772215496; bh=9iPiw6U5zQK+rw2Kav/sKN2Hf6ijXsHI7/gXVV2UUoE=; b=t
	vscZopf+ZIEohHyAEDRhsH6FvskiqkAmDpcbJ929YOc16kdoaID3AUqA/A2BuUaN
	T3NQnehlYy2NHaHOZTy905uPUXQvza+V1dfuXki/6uhpvSoc2L0RtungWGT1jrO7
	ZwCT4v71GqF8Lb2j9Wa5pO6iFsAT82AWVVzzfP6i5qBkN/NLD16OpXnsU9Um2Yit
	tqax0ePNsklBpO7D28r+WHWyEsyEB3dBdPzILFtuFeTep/W/txwnLoEbTm6byCiM
	ZyFo3GtCDe1fofD17VNEpSy38yMrZStnH4Y7exMTr87u2ozA0C9IAtaYmIuUOHGo
	++gnE/qKKaOXz+R9EfRlQ==
X-ME-Sender: <xms:psChaT2sM4Kvl-4-ynL2eVnQMEX39TidibWISnlH_elJUGQErX3wTA>
    <xme:psChae4zqe00s2rW3dmgGMuGnyWrupYFD0bGCo76dIRjuimHTSYe2q3WCJjvWTKjx
    4PzQz43jg2I0fHfbjnTERQhWe1Q9ptrfVZgA1EPP6ANrtJPb8-JHw>
X-ME-Received: <xmr:psChaYF1xEFxlqB1AHJOkAbJUOmtbZjtLf3IJgp5hsYNQFhKllAj9SiL1qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjghhgsehnvhhiughirgdrtghomhdprhgtphhtth
    hopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpdhrtghpthhtohephhgvlhhgrggr
    sheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghjrgihrggthhgrnhgurhgrsehnvh
    hiughirgdrtghomhdprhgtphhtthhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghp
    thhtoheprghmrghsthhrohesfhgsrdgtohhmpdhrtghpthhtoheprghpohhpphhlvgesnh
    hvihguihgrrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurght
    ihhonhdrohhrghdprhgtphhtthhopegrnhhkihhtrgesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:psChaW9Xw982ojlJdwBELBg5nUtIzvooVbtsR4EkEMCm_xurJFXzrg>
    <xmx:psChaaOp5diDrMTGhRQmY7BQEtexZqnvTbnjvKx4-4ezrSFwxx9F2Q>
    <xmx:psChaSyHxbqDw7kNVUBcF1TzS8IrpR_G2LRBbhhRg_GGFr9lHV0HNg>
    <xmx:psChacsS35VypjDMtowdC17AE2t6OJySB2L9fCOTFIyvV5HWrXnqKQ>
    <xmx:qMChac02xKCLa1txMJHJVVZiONFn_n7mbt_yHes_8ALNfR1pvZwQrzfN>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 11:04:50 -0500 (EST)
Date: Fri, 27 Feb 2026 09:04:49 -0700
From: Alex Williamson <alex@shazbot.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Bjorn Helgaas <helgaas@kernel.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
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
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
Message-ID: <20260227090449.2a23d06d@shazbot.org>
In-Reply-To: <20260226144057.GA5933@nvidia.com>
References: <20260129212510.967611-4-dmatlack@google.com>
	<20260225224746.GA3714478@bhelgaas>
	<aZ-Dqi782aafiE_-@google.com>
	<20260226144057.GA5933@nvidia.com>
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
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[google.com,kernel.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,linux.microsoft.com,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72170-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim,nvidia.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E2B411BAB10
X-Rspamd-Action: no action

On Thu, 26 Feb 2026 10:40:57 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Feb 25, 2026 at 11:20:10PM +0000, David Matlack wrote:
> > On 2026-02-25 04:47 PM, Bjorn Helgaas wrote:  
> > > On Thu, Jan 29, 2026 at 09:24:50PM +0000, David Matlack wrote:  
> > > > Inherit bus numbers from the previous kernel during a Live Update when
> > > > one or more PCI devices are being preserved. This is necessary so that
> > > > preserved devices can DMA through the IOMMU during a Live Update
> > > > (changing bus numbers would break IOMMU translation).  
> > > 
> > > I think changing bus numbers would break DMA regardless of whether an
> > > IOMMU is involved.  Completions carrying the data for DMA reads are
> > > routed back to the Requester ID of the read.  
> > 
> > Ahh, makes sense. I'll clarify the commit message in the next
> > version.  
> 
> More broadly you can't shouldn't the fabric topology while Memory
> Enable is active.
> 
> Renumbering or readdressing the fabric requires disabling and flushing
> any memory transactions.
> 
> From that reasoning it is clearer that you can't do that if the device
> is expected to hitlesslly continue performing memory operations.
> 
> That may be a clearer long term basis for describing the requirements
> here.

Not only fabric topology, but also routing.  ACS overrides on the
command line would need to be enforced between the original and kexec
kernel such that IOMMU groups are deterministic.  Thanks,

Alex

