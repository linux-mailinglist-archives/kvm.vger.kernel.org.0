Return-Path: <kvm+bounces-44118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38162A9AB0D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB4117A3E10
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725EB232386;
	Thu, 24 Apr 2025 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="XaJ7BtUC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nLTnflKt"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2E922688C;
	Thu, 24 Apr 2025 10:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491172; cv=none; b=XM5iY4iLavvsRqJyiPkl1L2LeKrOTahCMf2jMpW1xcFZMyNF9sdfo0uPlAaKX0j8iaBnfem2P06UIGlBRhtP2a/elaoHVwV/FZSB7KF62Nzco5zewWZ7T7gAC8GU6WOm4/7fUggXoIqWXk6v/e25gkhUtPdhMha+QnAZy+XPsRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491172; c=relaxed/simple;
	bh=M/GTo3I52NXu8ighvWmgklVXc8dRXzoeIiGkIZjkk1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mVXZoOJuu1WaJZFPabrDfj/HeHwJvYFndwzLK4nqD5v4f+qw9L2U4Fg1ROkzkaEx5ErvFmuvIfnppqrs+LCyPbZSpMBjf+OIqjDlMuXasdpvDlt4T/DN3oo26OODgmWGQuKLTkkbqG6VUhEIf6AaA+UNIUTIh6hniQ1V9dt7Bq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=XaJ7BtUC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nLTnflKt; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7680111402A5;
	Thu, 24 Apr 2025 06:39:28 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 24 Apr 2025 06:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1745491168; x=
	1745577568; bh=stUVXB5LohVz9IeHVm96Fl6lmKlj3bOnocGi8pRm1/Y=; b=X
	aJ7BtUCCatjEciLWCpniIwMLq4h2m1/ix8TadWZOEFjaGZ18e3KulGeqXi9TT9zo
	wr+RPBsmcSzRTXJCpRcLplLKFkmGcrm7BPO162pJL/AHrLIJg5QJ7KBLQJDXOuW4
	WEh/AYJ5dan3s8CeSMdZUfifeFK9qJAT6+GvD+tj+G7aLPDKLN2RwcjHK+4j7BbK
	xzpFMJGK97cd+Gubjyxh4b6meIxe7XttVzep6uyDVRzfrT1UlQ/lN86nMuShnv4m
	h5AajxCk2EfJxfpj+SMid9+NBLBekvYYNPY4WuTg1k7lR5mUtXE/zzuxxyH6ntYt
	O2tZ3HP71hCRmRQlKr0lA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1745491168; x=1745577568; bh=stUVXB5LohVz9IeHVm96Fl6lmKlj3bOnocG
	i8pRm1/Y=; b=nLTnflKtwf4i8QRFq+9jVOy76nvqf1H1sJ4Ia1Pg+xwXP3UOao3
	EXXlSDYGQ5A/o9O7jyENCTm/JjzoWNuNKnNZTlc1S2uFgORIMcTcgU3lHR3idEcQ
	BTHu7gUuyZqJG9hMMY0hgAvC1Y2i+X5mjEjPZmbn20EN9Q5/UCQJUHZbjsXNPWjJ
	7vu16B393ezu2R2KVccU+MkTRCQPGNfCjMPouYvl6xwVP4y/EeVBvE9l8KzjnyoI
	EmJKAuC69csVS5/EHmBuKQ94bJhJ/IlbCMdhzcWjnCmruOzC8Lz9Xj3gbxfttxxZ
	iEehC2hq8wgLKFtLSFPe5F8f7s3NulwHyNw==
X-ME-Sender: <xms:4BQKaOkp1gNliTZV6NevYnYdrK9T5NUC_f7y1VOFWyJQhIPZjAMOyA>
    <xme:4BQKaF1KmQQrhzYeBNhDU752ua-WE9gzf5g1zoeytpUepmlW5L6zpfaHM1nCru_yK
    a2xfwQFVLkPZZclCmY>
X-ME-Received: <xmr:4BQKaMqPMNnXRikdPY_Klf1Ia9D5JWdkirRNeVeiizfFMV_XY9M-oA0ko5jRlIQ1nrSDRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvgeelvdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddt
    vdenucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilh
    hlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfh
    hfffveelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghm
    ohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprh
    gtphhtthhopeihrghnrdihrdiihhgrohesihhnthgvlhdrtghomhdprhgtphhtthhopehp
    sghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhitghk
    rdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrd
    hhrghnshgvnhesihhnthgvlhdrtghomhdprhgtphhtthhopehkihhrihhllhdrshhhuhht
    vghmohhvsehinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:4BQKaCkh-Blx2Tv3Kt-HkpPHS1ogLxkmj_zt7yscutvFNBZs1ZeEPQ>
    <xmx:4BQKaM24gFjQ0S7aeTsO7CYQh8CJZqFg4B0wWv39hvL1TsJr8b73Gg>
    <xmx:4BQKaJt5ufiIVthjrFD5gklpscjXlt8Ryz1wXG5zZhPWm0E05VagJg>
    <xmx:4BQKaIWau4EAGBYbom84VhXVcoov3RQ_zjEzPpAFmToaLMFtrA35fQ>
    <xmx:4BQKaEZ7pzCdYK0SlWcjK190XoMX_EsTwIsibo7G6d4REGnCyxAB0GlE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Apr 2025 06:39:20 -0400 (EDT)
Date: Thu, 24 Apr 2025 13:39:16 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, david@redhat.com, 
	vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	ira.weiny@intel.com, chao.p.peng@intel.com
Subject: Re: [RFC PATCH 00/21] KVM: TDX huge page support for private memory
Message-ID: <y6k6j3kzoaze3gk4duhxhca6vq6mll2n3iabrm32o4mi3qi2hz@4nanpujhbkib>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <e735cpugrs3k5gncjcbjyycft3tuhkm75azpwv6ctwqfjr6gkg@rsf4lyq4gqoj>
 <aAn3SSocw0XvaRye@yzhao56-desk.sh.intel.com>
 <6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y>
 <aAoJHXsAbdOx+ljo@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAoJHXsAbdOx+ljo@yzhao56-desk.sh.intel.com>

On Thu, Apr 24, 2025 at 05:49:17PM +0800, Yan Zhao wrote:
> > Accepting everything at 4k level is a stupid, but valid behaviour on the
> > guest behalf. This splitting case has to be supported before the patchset
> > hits the mainline.
> Hmm. If you think this is a valid behavior, patches to introduce more locks
> in TDX are required :)
> 
> Not sure about the value of supporting it though, as it's also purely
> hypothetical and couldn't exist in Linux guests.

Linux is not the only possible guest.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

