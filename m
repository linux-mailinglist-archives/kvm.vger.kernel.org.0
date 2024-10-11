Return-Path: <kvm+bounces-28602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC936999DE8
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 09:29:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26829B218F4
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 07:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE54A209F5C;
	Fri, 11 Oct 2024 07:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="Mi10dHZN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Odbg32uh"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4269197A9A;
	Fri, 11 Oct 2024 07:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728631777; cv=none; b=SuuQudzwEZt9kgLaO2NWLO19KOLpwEsWgNj4CkWxwCyWtp4hvGI/eKZKc0rkJd7HvRrWo/862zfYA2OnMkMc41/H6O1e/Mp3mALDSUyeChbTkjblVBNxQDO7zOSMQl3RHgWZTXeIdqX6OTkifTBdBz8U4VOiSvPT8ueJNCekCfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728631777; c=relaxed/simple;
	bh=Imif9mrwPFVaeXF4kQtkTzQfjhEZVNanJCSWnsWterc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l88jC/crdQYTE8AAGshAWZmPJ8vLA4OCzCXTsaF040G4RgySXeDnW79V3r415OYt1D8ttXozL+2ae9J+jSS+o3pskbvfKJVGGxXN//kRRvwH6wWZmW+U5CuvocGPoaVDGlJKiNKbt+pSFhWZGHYy7okh/TVRXg08kBFM25yFFOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=Mi10dHZN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Odbg32uh; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B189E1140174;
	Fri, 11 Oct 2024 03:29:34 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Fri, 11 Oct 2024 03:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1728631774; x=
	1728718174; bh=myCqt/H/c9dWQNLgBGhUL4KWxptRND5SRhSn1tReYLI=; b=M
	i10dHZN10oqj8DEiVm7jxi45dnprY5F0sdG012NXNtw3btTCK2uvpVPkokHwNH3x
	9dUOQOhD+JlFoQ+/XiUa+9AuI99fB0arxaBXXdcuopMmQzN9Azc31yHHmAVRCelQ
	a4nfH43OwFLxymxGHv+d9DkMjaAjG7aLrK9BthGEcEU/d+ttLeG4H9NavXLNROAA
	KF3SAZo5XjJMMuen7Ig77SkZWu29/tcmqtHegLfIYvVtAsTbf1s5LYjPYqXve4Ct
	slzED57JBJwBB05/q+9I3arTjAIfYdMUiCIhigtBl/yBWjhTObrWwEtBCPpnZs1L
	H9Kp7k1jl/KnbCpPIHJNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728631774; x=1728718174; bh=myCqt/H/c9dWQNLgBGhUL4KWxptR
	ND5SRhSn1tReYLI=; b=Odbg32uhqXdiX8gVepBfivWtBuWECc7wzNYtrfjUYmyd
	58ko4NF2DGjcZtXKKrY10L1rJvOdk34z/coggkplAzylbDcHZaUXjcqymJLOqDMa
	hPZUzbh/WQMgvYHotvJ9hSkQs2RUJv07V+nFReh/DmnS8qch5lpAzlciZy79atdM
	5da2PKIzFMJI1d8Me84z0qVDjfdJbNzoKo3Kvs5eLfBvs+SuKrq8H6fFib2CW8Ol
	/G+JayFzOh2ejUQb85muR5q7SCDtCzRbWkaZKYQ/Hpx9PFIWrHPQICt/+8kjz61e
	uZvEAuuuYqvpl1WbTkiW5QAo8bdYzXWuQR6XdTkZVA==
X-ME-Sender: <xms:3dMIZ9t3lTSk9wVLTGLCt3M8FlD9YCYqEuQu1-VkHegHLiOwluTHcA>
    <xme:3dMIZ2fmLF0uPttXbZQT_dEA5ueM2TCeP1KJINyHnrUHcXH0WWVSg7l3BIfS-h04I
    yoh3NGR6GdOsEqVbIo>
X-ME-Received: <xmr:3dMIZwz8crP8iYjI4vTl8aqwaQKcvwr3zWMC9qpsLrJ4IRnZ0ehi2RnN0hGFyTq7R0YbSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdefjedguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdfstddttddv
    necuhfhrohhmpedfmfhirhhilhhlucetrdcuufhhuhhtvghmohhvfdcuoehkihhrihhllh
    esshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrfgrthhtvghrnhepffdvveeuteduhffh
    ffevlefhteefveevkeelveejudduvedvuddvleetudevhfeknecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhho
    vhdrnhgrmhgvpdhnsggprhgtphhtthhopedukedpmhhouggvpehsmhhtphhouhhtpdhrtg
    hpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepnhgvvghrrghjrdhuphgr
    ughhhigrhiesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhn
    ihigrdguvgdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtth
    hopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthht
    ohepthhhohhmrghsrdhlvghnuggrtghkhiesrghmugdrtghomhdprhgtphhtthhopehnih
    hkuhhnjhesrghmugdrtghomhdprhgtphhtthhopehsrghnthhoshhhrdhshhhukhhlrges
    rghmugdrtghomh
X-ME-Proxy: <xmx:3dMIZ0OFW77EvcyFjLJEdQCUZ-TCr7rhu2h2CVB43DZvVvC8-rmPfg>
    <xmx:3dMIZ9-zuXYtqu6bgptk4jLneGuqfcxbQgr4HsGsqmiZMAyD0-XrHQ>
    <xmx:3dMIZ0WMJhnZgh-G2aFVRtZiH4fkmnGw089zrvJ_MfqG0qx9PQPB8w>
    <xmx:3dMIZ-dIqe982CzZtku4priHTjnhGMmdNLaf8a7R9zDKEVzjheajrg>
    <xmx:3tMIZw2eniM1mvpIjsFFaCSClucwXOWTCbHQVSKaqiROBJOBVFewyMzN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 11 Oct 2024 03:29:28 -0400 (EDT)
Date: Fri, 11 Oct 2024 10:29:23 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Borislav Petkov <bp@alien8.de>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com, 
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, 
	x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <yoqhgkq7ewwqhvrqfae23lz2ke4chetwo6es32zj7z7x6c3zc2@322aqn4s3bgq>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <sng54pb3ck25773jnajmnci3buczq4tnvuofht6rnqbfqpu77s@vucyk6py2wyf>
 <20241009104234.GFZwZeGsJA-VoHSkxj@fat_crate.local>
 <7vgwuvktoqzt5ue3zmnjssjqccqahr75osn4lrdnoxrhmqp5f6@p5cy6ypkchdv>
 <20241009112216.GHZwZnaI89RBEcEELU@fat_crate.local>
 <wb6tvf6ausm23cq4cexwdncz5tfj52ftrrdhhvrge53za3egcf@ayitc4dd6itr>
 <20241009135335.GKZwaK32jOZlA477HX@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009135335.GKZwaK32jOZlA477HX@fat_crate.local>

On Wed, Oct 09, 2024 at 03:53:35PM +0200, Borislav Petkov wrote:
> On Wed, Oct 09, 2024 at 03:12:41PM +0300, Kirill A. Shutemov wrote:
> > If you use SNP or TDX check in generic code something is wrong.  Abstraction
> > is broken somewhere. Generic code doesn't need to know concrete
> > implementation.
> 
> That's perhaps because you're thinking that the *actual* coco implementation type
> should be hidden away from generic code. But SNP and TDX are pretty different
> so we might as well ask for them by their name.
> 
> But I can see why you'd think there might be some abstraction violation there.
> 
> My goal here - even though there might be some bad taste of abstraction
> violation here - is simplicity. As expressed a bunch of times already, having
> cc_platform *and* X86_FEATURE* things used in relation to coco code can be
> confusing. So I'd prefer to avoid that confusion.
> 
> Nothing says anywhere that arch code cannot use cc_platform interfaces.
> Absolutely nothing. So for the sake of KISS I'm going in that direction.
> 
> If it turns out later that this was a bad idea and we need to change it, we
> can always can. As we do for other interfaces in the kernel.
> 
> If you're still not convinced, I already asked you:
> 
> "Do you have a better idea which is cleaner than what we do now?"
> 
> Your turn.

Okay, I've got your point. It is not what I would do, but I don't have
sufficient argument to change what is already there.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

