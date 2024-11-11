Return-Path: <kvm+bounces-31502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA129C4313
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C86661F20FEE
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F9F1A42C4;
	Mon, 11 Nov 2024 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b="pIpm2nQ/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="F2PbeZsF"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2C71A256E;
	Mon, 11 Nov 2024 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731344232; cv=none; b=ZVx6Na06b3vBJV6P7cjuq1uAdNjmQHPmtpbns4TJSSRRABLxGnzkQe44ucfu3TzyYkCxT+6JFXbWCGp5FJD0YxZS2T/Myea/iopmhiYP2/5FzhRY4wl3UN0VOHeVgPXcfiMfLvuMuZB8+YKEBsvO58JF2X66ewr0AS/ou5oVHTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731344232; c=relaxed/simple;
	bh=iBeofKxtXt/U2EDsL9YNBmEqwLBUdloff3KWlN6Gpqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ICaH9egJ+xmHOCxgRJFq0UiPgAOJ49CHh8TJF4qdivc/yQX26qR1rz3LxjMMRNHQE+z2DzD0oe+JPDDJtU2B5/OQyz5MNWeerTUeTM+kIFZf29EgSm/wX2aF1Iv6UtftWxrC5mCAGbe/hM4uo9Cwf3v80GRgsW5kctWeWbA9qQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org; spf=pass smtp.mailfrom=joshtriplett.org; dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b=pIpm2nQ/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=F2PbeZsF; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joshtriplett.org
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C0039114019F;
	Mon, 11 Nov 2024 11:57:08 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Mon, 11 Nov 2024 11:57:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	joshtriplett.org; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1731344228;
	 x=1731430628; bh=63vV/Bi15kbpukbdHEocuq/m8VKOg/ssBshmERhp+Vw=; b=
	pIpm2nQ/89mfc0LwcH32aGEDvSQWG/EZLnB0ZwLJe1UmP5Ck7VRd3DAerjCaQgqS
	k8wB4E5XBhCBHfqtfiFekP6hM5LWJTOf25kFx4QFI0GfgoEfg9pbLqLU9Z9z/2v1
	cOohNqkuEd7yFwLkeD367Qy9EuO6xfwLw2SUA/JU4DpVl78sq2cUYWYsE3lI+nlt
	o5zItPCdcQ/OU8anoUfw2r31HuGUj5TgeuVYjBgr7KNoQAhBo1m8t5ePVcYeklTR
	zRmvpEwL1pU0wzi33eMDs4Ajg8AEEiJ7Lq/A7q3sM55r6ciy23piVisDN7ks7TnS
	+T1GJrv9RYAZ5fBfyX1XmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1731344228; x=1731430628; bh=63vV/Bi15kbpukbdHEocuq/m8VKOg/ssBsh
	mERhp+Vw=; b=F2PbeZsFoEh8yh3pLw0iUJzLBKFe5KHcNS2BU2iX0NXkNESja1o
	QTC25D5kWAzZBd1y/6WgXZkDt+v9o0rewMvr6xpppmEGKZr+f1QT3h+Yo/Fn+Rb9
	3baZ4FVRCFbOSGUMqEyXc/b8455bMEPEqjd594dXUIBmHsqbegR/ExMqalnNbKO6
	MgvW0yEz7cFOrwRwlT6/EXQ+T5PKHJph7aUYSCGx+R0t2u3r4aHVOq2ByxlK5/KR
	hECJjN3kWnYvx/xtO8dvy+vu8Tw4Kg3qG0xhoHBwe/LaidiLqKUGKoBFgOwRL2nh
	Fhp91gqXGlivDPd3zzTDJioH/2LrbnxAtYQ==
X-ME-Sender: <xms:ZDcyZ7glvAnxk_-U1EOTuiNn8n0oHSDOZrWzXacEXlN82Xm-jKiIuQ>
    <xme:ZDcyZ4B7lcwhzGIY3PBV4YwIjO-xgJ9jYqTrNgccueML8gWD2E9eAXIFKpT31SSvZ
    dtL_M-lZXbf7B3285c>
X-ME-Received: <xmr:ZDcyZ7Ht-jnnnIdl-jtg45r2UxsmvrBs0NJhGRHEBJgdxFxTiZn98SVZRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddruddvgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecu
    hfhrohhmpeflohhshhcuvfhrihhplhgvthhtuceojhhoshhhsehjohhshhhtrhhiphhlvg
    htthdrohhrgheqnecuggftrfgrthhtvghrnhepudeigeehieejuedvtedufeevtdejfeeg
    ueefgffhkefgleefteetledvtdfftefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepjhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrghdp
    nhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhhlvg
    hvihhtshhksehrvgguhhgrthdrtghomhdprhgtphhtthhopehsrghnughiphgrnhdruggr
    shesrghmugdrtghomhdprhgtphhtthhopeguohhnghhlihdriihhrghnghesohhrrggtlh
    gvrdgtohhmpdhrtghpthhtoheplhhinhhugidqphgvrhhfqdhushgvrhhssehvghgvrhdr
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:ZDcyZ4SmcwMSCy7kIa7JX515IuWuCEWAOrY0Prv1sJSBVpCgVbf7VA>
    <xmx:ZDcyZ4xCzJV3eLzkBxTbIApByAKeSQNJO5l1Qe7gBwWSDVBn-qve6g>
    <xmx:ZDcyZ-65uI02QxtsEbZ9NZVQVrblwcgN6BxQAt4kW0T7AB2kPuD-UQ>
    <xmx:ZDcyZ9yPuIxM3DHV-qHQ-D1c2MMkA8R-IzZsL35ePcI1PbGjaUQVyQ>
    <xmx:ZDcyZ_lo3rMPmqfF5gTB1rMGs9azuCM_yGth8IBjYzP7lyGqKaWZ-XWe>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Nov 2024 11:57:07 -0500 (EST)
Date: Mon, 11 Nov 2024 08:57:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sandipan Das <sandipan.das@amd.com>, dongli.zhang@oracle.com,
	linux-perf-users@vger.kernel.org, x86@kernel.org,
	kvm@vger.kernel.org
Subject: Re: Small question about reserved bits in
 MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
Message-ID: <ZzI3YrmTjbFZ0Lfz@localhost>
References: <5ddfb6576d751aa948069edc905626ca27e175ae.camel@redhat.com>
 <2e3f168c-3b0f-4f18-9db3-0cb2be69bb5c@oracle.com>
 <04a91009-c160-4920-a5d0-81a8e1e7cf97@amd.com>
 <36f601823359ed6d694d42c6c79e11a0403b0da3.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36f601823359ed6d694d42c6c79e11a0403b0da3.camel@redhat.com>

On Tue, Sep 17, 2024 at 08:54:04AM -0400, Maxim Levitsky wrote:
> I also tested on bare metal Zen4 system just now, and I also see that MSR 0xc0000302 can be set
> to any value.
> 
> So this is a hypervisor bug, I'll report it to AWS.

Have you gotten any response from AWS? I'm still seeing this bug on
current c7a instances.

- Josh Triplett

