Return-Path: <kvm+bounces-36303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA92FA19AF0
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 23:33:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7D253AA270
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 22:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D601CAA6A;
	Wed, 22 Jan 2025 22:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="HaVjKa3h";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NmI3oJ5v"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8869A16BE3A;
	Wed, 22 Jan 2025 22:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737585181; cv=none; b=Jif16oiNsAdewrvTodL3tPSXsGgXSvaDXBPEB1BOYwKH2XyQ5jNVxz8rZ5rbILV2dmjw+vUxeGQFIrSVgZEPVrMFZXnezXHnd1+CDRCuC7DuWLS1WJ3hEXgVRftohTPhR6TxQ8Q+4zIH/6jN6R/78geXKjdLQ4CBB+9zvzEh93w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737585181; c=relaxed/simple;
	bh=uIsGX+LHC0EqC2LH4ApvsDIJCpRYuK0TibQmiZE5PUQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=c3h8G4HEAGjshkiwG8U+ufUkaLHRUKWS14bmbhYCCLPY+JcF6lyhFfrXULSmuvsyD413wUCDDFNczUnD5ixWASz//EXwDnoAel6tHdkOMllqpybV2ZgeaICMOpokpdLj+5NTw3BYyJiktW1YmohZkWNWwn7XOV47wDq4cgrmihI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=HaVjKa3h; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NmI3oJ5v; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3CD662540201;
	Wed, 22 Jan 2025 17:32:56 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 22 Jan 2025 17:32:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1737585175; x=1737671575; bh=lA/ND5qB5E
	0KhzRBMPyY1ODZmoOf2YPG942wv8O+9hQ=; b=HaVjKa3hYnqkIitoYuNLNJcwFt
	dDLo2oKdGhZmhlMJRWvPTv5CHJKJLwO0tP+p4IB17AAXbD5ezcxSWy1NchtS9zk3
	unnXceAWzWMME9ensGzi9Gw5GeEDTUmqll2scyID217oHf1QFeTpbenyMsqjqN+O
	JnX4SosGkEOr25lU/IOSWgulzft79aea3v9zS08QkuNpXde5Kfk8QO4ESC6Yaf5q
	FMAlsbSvIT3ozcNvYir0/wa8VMXra3B+aB3t7+Vb2DDj8M428VAa6N45xH3/UuWh
	z7SKUqwjYP59lmgVuZPLUnZxvkntSc3xDs+V7DguaAEze9vgmdcRB0SNGPoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1737585175; x=1737671575; bh=lA/ND5qB5E0KhzRBMPyY1ODZmoOf2YPG942
	wv8O+9hQ=; b=NmI3oJ5vDb7AeoAxSyy/2k1FIeklSrRwvap07JpMALIvLnwJkVs
	hAobljHFGRhUQpKyT/0TiMrhXkYpyIRtkmsdXBcuHLcL8Z8520GpBabrb4qYrDOW
	2v5IDZMJz1JxjiGeVGRvwcSpGbi9kCVajm/T4iikUsy8TAZE5ajKFulGcN7+XShI
	6zQVVJRAX88Ud9/Og2unYgDsTK5vO4MvrlzPm6W+RvdFNRNQQoruuqhXVld3b9us
	XS8f29Ng35wHHWauXVmPijSexuvGN5ryFQm2qlRHwf+/YNDI3voQX0uCioQH3qII
	dswyOep5/N4ACAz0Vti5C1jvyY7PSThjkCA==
X-ME-Sender: <xms:FnKRZ8ApCyjB3xosHlCfmfF-dQcGDoTbYJXwjfKupb7LItrEzxUXpA>
    <xme:FnKRZ-hiOVkA0ljKY2x6rs-0oQWou0PSZZh3Qpw4256ZJwEBi1aOMRvWhNdN2RcCM
    2LgAPapuIwMTJzepQ>
X-ME-Received: <xmr:FnKRZ_nki-HXPRd925SOA0x3X5sp2I8IQK72r7lT5VEwDiyJqzn6AhsY1LOEvQhXD3m9Xoz3n8z7kXHuX6O-cLnre2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejfedgvdekhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefhvfevufgjfhffkfggtgesghdtreertddttden
    ucfhrhhomheptehlhihsshgrucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecugg
    ftrfgrthhtvghrnhepieduffeuieelgfetgfdttddtkeekheekgfehkedufeevteegfeei
    ffetvdetueevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhephhhisegrlhihshhsrgdrihhspdhnsggprhgtphhtthhopedutddpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepsghluhgtrgesuggvsghirghnrdhorhhgpdhrtghpth
    htohepshgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehksghushgthhes
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhjsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehrvghgrhgvshhsihhonhhssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghp
    thhtohepmhhitghhrggvlhdrtghhrhhishhtihgvsehorhgrtghlvgdrtghomhdprhgtph
    htthhopehpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtghpthhtohepkhhvmhes
    vhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlh
    esvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:FnKRZyygtwAXrvN3K-Z4bqGj1y4AwNaPnr4xwquiJcWDz8QUGUHNfg>
    <xmx:FnKRZxR_6lTeHhJCAIusFz9PJJSXPqRmJdky-v5fL8Po_TIF_qNB0g>
    <xmx:FnKRZ9avWtUzAqzhhI_zK_YgIo1J1gLYKMIVdWCn5SuPcvJVJKSmHA>
    <xmx:FnKRZ6SzfHFPky75UdE8UrjL2PUjrjoowP0dJvqnnh8Z7l6BkIOp0w>
    <xmx:F3KRZ2L-_gmMcTOL18iAF-Q-HQ1Sbf-4dI4slJKgxeWxx4L7FYWxyw9l>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jan 2025 17:32:53 -0500 (EST)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id A5AEC1AD4DA1; Wed, 22 Jan 2025 23:32:51 +0100 (CET)
From: Alyssa Ross <hi@alyssa.is>
To: Keith Busch <kbusch@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, Luca Boccassi
 <bluca@debian.org>, stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
In-Reply-To: <Z5EHMbv8uezcRM3l@kbusch-mbp>
References: <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z4Uy1beVh78KoBqN@kbusch-mbp>
 <0862979d-cb85-44a8-904b-7318a5be0460@redhat.com>
 <Z4cmLAu4kdb3cCKo@google.com> <Z4fnkL5-clssIKc-@kbusch-mbp>
 <CABgObfZWdwsmfT-Y5pzcOKwhjkAdy99KB9OUiMCKDe7UPybkUQ@mail.gmail.com>
 <Z4gGf5SAJwnGEFK0@kbusch-mbp>
 <twoqrb4bdyujvnf432lqvm3eqzvhqsbotag3q3snecgqwm7lzw@izuns3gun2a6>
 <Z5EHMbv8uezcRM3l@kbusch-mbp>
Date: Wed, 22 Jan 2025 23:32:49 +0100
Message-ID: <87msfijx7y.fsf@alyssa.is>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Keith Busch <kbusch@kernel.org> writes:

> On Wed, Jan 22, 2025 at 12:38:25PM +0100, Alyssa Ross wrote:
>> On Wed, Jan 15, 2025 at 12:03:27PM -0700, Keith Busch wrote:
>> > On Wed, Jan 15, 2025 at 06:10:05PM +0100, Paolo Bonzini wrote:
>> > > You can implement something like pthread_once():
>> >
>> > ...
>> >
>> > > Where to put it I don't know.  It doesn't belong in
>> > > include/linux/once.h.  I'm okay with arch/x86/kvm/call_once.h and ju=
st
>> > > pull it with #include "call_once.h".
>> >
>> > Thanks for the suggestion, I can work with that. As to where to put it,
>> > I think the new 'struct once' needs to be a member of struct kvm_arch,
>> > so I've put it in arch/x86/include/asm/.
>> >
>> > Here's the result with that folded in. If this is okay, I'll send a v2,
>> > and can split out the call_once as a prep patch with your attribution =
if
>> > you like.
>>=20
>> Has there been any progress here?  I'm also affected by the crosvm
>> regression, and it's been backported to the LTS stable kernel.
>
> Would you be able to try the proposed patch here and reply with a
> Tested-by if it's successful for you? I'd also like to unblock this,
> whether this patch is in the right direction or try something else.

Sure!  I can confirm this patch fixes crosvm for me when applied to 6.13.

Tested-by: Alyssa Ross <hi@alyssa.is>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRV/neXydHjZma5XLJbRZGEIw/wogUCZ5FyEQAKCRBbRZGEIw/w
oqArAP9mlBtaJExxPVRjopWGMX2SSA6cCmYTebOejPkPxdNEAwEA/R1STfRNXVDM
ZAqmCdqkv2xfBG2gA2veX9/P01uUBQc=
=979E
-----END PGP SIGNATURE-----
--=-=-=--

