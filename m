Return-Path: <kvm+bounces-28421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EFE49985CE
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD8781F24B29
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC1D1C5791;
	Thu, 10 Oct 2024 12:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="JtYFE4SI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DKvnZcY9"
X-Original-To: kvm@vger.kernel.org
Received: from flow-a5-smtp.messagingengine.com (flow-a5-smtp.messagingengine.com [103.168.172.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E061C463B;
	Thu, 10 Oct 2024 12:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728562882; cv=none; b=pWb+hQ1PPzyTYQctnaWB2F2UJ3emmZD/6QMcJP0LhiyQtRRciI5dhqA/87w1jG46qm7msAk2ZTPZ5D1qhfxJSWP1WDmko6u6mYfU2uHZU1SDHlobjQT9fWbUsxfpO4ZFEwq8LnnTzP8r6FXCDlpGJ3XZMYmcZd1LMFGyctLdTdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728562882; c=relaxed/simple;
	bh=ePQQb3EDmotyKCDIHSwxfwJpDRGufOq8FWlB3rDhWKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=huFDrA1UHTlAxSINoTtp/kvvcq4S17Xv2WCJROrCl19KnKYegchRHuVZtZ8Vtzzfr8fU2CftuPDDskfiu4NLWJ+erNii+Ci6zUkxV2K9vRyRV49bRetyfSqC2KSqz73pGbr9Amh2ZBkf0e1ysbDZ1IkNHAG0uI8UzXD8DHz22Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=JtYFE4SI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DKvnZcY9; arc=none smtp.client-ip=103.168.172.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailflow.phl.internal (Postfix) with ESMTP id 400F9200344;
	Thu, 10 Oct 2024 08:21:19 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Thu, 10 Oct 2024 08:21:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1728562879; x=
	1728570079; bh=wBckN4g9HCrUa7WIs9G8yP0tJY8h3Lm/AXSNnRL5pU0=; b=J
	tYFE4SIib1Wgi59JR0TJx16z4KCxUGv8ED194GZ/bd/zc21RY01WRu8Hes8lVQQI
	xnQx83Ucf7ipDPIM0OmHF3LbqDqGWFOSwKgKYdQVGdVmBSFFtjbB5s13hrb6MKS5
	u31uPGTkaK7CjBpI9+yp712FK6vTc9VPqH/mq7sZg6Obtnc1DEqFA0epyN3sQBCb
	VS5HKIHdpfPkjS28WdPO1xjE6nCD0errkAtyA2QJLdWUIHeF/13nMpSa5xbvc4Dj
	j7vUc+HkZBjCr9r90oqsA4cRDxb4M76rHfyZP6i42l+8526FSRbIC475ApLM9mHq
	Zg44s+2VZoqyoRC+MjkWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728562879; x=1728570079; bh=wBckN4g9HCrUa7WIs9G8yP0tJY8h
	3Lm/AXSNnRL5pU0=; b=DKvnZcY9lUUcq0YBc2xyE4Mn+W5dbwkEZq4fiiWEpLKt
	JOG3CTFHsFK4O45kw3Vbtt28gKdvK1yiNQzyq1AnM+Z5XYZSF2akc3ByPnla3fyz
	0vEJ3I/wiwtM9VSZF+whYTOlRpvW5icM2fHtTf/CKOaEDxU36kcH8NOPsrvfAFlh
	YVPIkL9OMJRTbmUznl09OSEMHsH+Vl4qQ4WrXd2AlGP//CgNucg+Zr3MVgnfT0v5
	c3ia3a+UMkYHSQgtxCF/Cp1AMGJtOrdpv1vncU9GU7t0AnmXGa0Or5WtGJNDidXY
	KirW0xxd+pqhIlnG/tpJI1fiwIDKwY32MUxW/lPANQ==
X-ME-Sender: <xms:vMYHZ0eMMUqF-wmBR4gJMJyp1WZOpeYn8aABwkbZmqMJ_yuESyo_wg>
    <xme:vMYHZ2OgikZs-NvZ_N50OU3D0u8wiyDJKoKycrrZrfvs0OUMv7M_6xDAVoBSC2acN
    J3x_QlM6m6k7V7hE9o>
X-ME-Received: <xmr:vMYHZ1iUw0HJRJ2U6rch5NgWDzWAoFSUGfcQ3elSIvNFOVe9hRCioEy5gX_o92JmhNl18Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdefhedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvden
    ucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlse
    hshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfhhfff
    veelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhv
    rdhnrghmvgdpnhgspghrtghpthhtohepiedupdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehtrggssggrsehgohhoghhlvgdrtghomhdprhgtphhtthhopehkvhhmsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqmhhsmhesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggt
    khdrohhrghdprhgtphhtthhopehpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtoheptghhvghnhhhurggtrghisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehm
    phgvsegvlhhlvghrmhgrnhdrihgurdgruhdprhgtphhtthhopegrnhhuphessghrrghinh
    hfrghulhhtrdhorhhgpdhrtghpthhtohepphgruhhlrdifrghlmhhslhgvhiesshhifhhi
    vhgvrdgtohhm
X-ME-Proxy: <xmx:vMYHZ5-lkA3vh2yNayyw8_e3gh4yUdU_fRa1xGomjMjBe5aIQxJGxQ>
    <xmx:vMYHZwsjO4jusl4thJ5ewRHLNkPSygIqYWvIYfYAPtPgjbrq9onAkg>
    <xmx:vMYHZwFqtHuqZlLfJ_E48fqrqwmPAT_BbPKawyWkx4OIUKGeqa8DrA>
    <xmx:vMYHZ_OZl8yFn4ftINnwWCBb_pdG5D9BBp171_aRkS-kwOJajveR1w>
    <xmx:v8YHZ4KOXHr4xzJQCBXhaAuTTUirDRhHlXj9ChjTFusAtIrgjTdfQk_S>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Oct 2024 08:21:00 -0400 (EDT)
Date: Thu, 10 Oct 2024 15:20:55 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, 	paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, 	viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, 	akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, 	chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, 	vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, 	david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, 	liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, 	suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com,
 	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, 	quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
 	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
 	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
 qperret@google.com, 	keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, 	jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com,
 	hughd@google.com, jthoughton@google.com
Subject: Re: [PATCH v3 04/11] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
Message-ID: <mr26r6uvvvdevwqz6flhnzbqjwkf7ucictnjhk3xsuktwsujh5@ncf57r3v6w6p>
References: <20241010085930.1546800-1-tabba@google.com>
 <20241010085930.1546800-5-tabba@google.com>
 <i44qkun5ddu3vwli7dxh27je72ywlrb7m5ercjhvprhleapv6x@52dwi3kwp2zx>
 <CA+EHjTwOsbNRN=6ZQ4rAJLhpVNifrtmLLs84q4_kOixghaSHBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwOsbNRN=6ZQ4rAJLhpVNifrtmLLs84q4_kOixghaSHBg@mail.gmail.com>

On Thu, Oct 10, 2024 at 11:23:55AM +0100, Fuad Tabba wrote:
> Hi Kirill,
> 
> On Thu, 10 Oct 2024 at 11:14, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >
> > On Thu, Oct 10, 2024 at 09:59:23AM +0100, Fuad Tabba wrote:
> > > +out:
> > > +     if (ret != VM_FAULT_LOCKED) {
> > > +             folio_put(folio);
> > > +             folio_unlock(folio);
> >
> > Hm. Here and in few other places you return reference before unlocking.
> >
> > I think it is safe because nobody can (or can they?) remove the page from
> > pagecache while the page is locked so we have at least one refcount on the
> > folie, but it *looks* like a use-after-free bug.
> >
> > Please follow the usual pattern: _unlock() then _put().
> 
> That is deliberate, since these patches rely on the refcount to check
> whether the host has any mappings, and the folio lock in order not to
> race. It's not that it's not safe to decrement the refcount after
> unlocking, but by doing that i cannot rely on the folio lock to ensure
> that there aren't any races between the code added to check whether a
> folio is mappable, and the code that checks whether the refcount is
> safe. It's a tiny window, but it's there.
> 
> What do you think?

I don't think your scheme is race-free either. gmem_clear_mappable() is
going to fail with -EPERM if there's any transient pin on the page. For
instance from any physical memory scanner.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

