Return-Path: <kvm+bounces-27330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ABE1983F9B
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 09:46:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 203E81F2419E
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 07:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59A414AD02;
	Tue, 24 Sep 2024 07:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nIjkFOgY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765F8148855
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 07:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727163957; cv=none; b=dBgBSbC1c48oD0DAdKlv6xE++YCIRSdN9Nx8atOoO2YJaK4TSgiouDFexycKzXQ0batL+lIzLts+3a2WszUu071PV1dTe4/zn/pa16pX/6r1o0G6kbf0fwxM+MH8fPNGeB2DS72NMfI3QhT+s4yG1zfGRGmz3wB537XVeQqVX4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727163957; c=relaxed/simple;
	bh=l08cQdXWihPaRKBPjiePc2JDBhMjEU+fAYF5sfdJpqw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P+k0bRz3ni5Oh7cNqdRZ+JHQTI7h86uRx8AMuAjURAH9ipxWKfMK2rssmAYvWO26NolfD3v85CsIshrSpJZzAShBdrvmJ5D8iEIqc4a9N19Z56PavUYio3/bg5rNAidpbAwiiXYz3/g1snWQI1wPaEmNribUtZYTAbyGzc5vjl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nIjkFOgY; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2058456b864so90367135ad.3
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 00:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727163956; x=1727768756; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LPW+26/rhTFGTD1mqsdatrHifgyew0bOQKR7ZHJ/lKo=;
        b=nIjkFOgY6o0917D+pPgsB90/DoMKptVBOJdB3Y/I5fcL6coyMgHDKsvkCST3hr3pd3
         jhVsSDKjTnJ5qWfK1zc2eAj8ChQXbMHQqsagU3PJJurYmhwIZkS3+Y/10ah+efmWv/1f
         7O9V+CmbStgMw51sEd9pUSOiO22YJkdkeU26MBa2NKOFwsyOMha0JUysWV7PqVDVT7wM
         S8xzKWdtEVjbVfXxQt+qVNY3I6827U7xM1MFQEX5z2oeTIF7ei8ZPfNmKQGqY9fUsgLh
         trvFnd7w7GoZFUJwbKYjrAr/0QjpeRSyPItAoofl0vn+yT2gWYbuZDQ4rSPN8u07d5yb
         Nenw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727163956; x=1727768756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LPW+26/rhTFGTD1mqsdatrHifgyew0bOQKR7ZHJ/lKo=;
        b=RoWiqByfd8wy5dPf41NmEfttIPv1KF5BkGSQIOPdNZ46X8/6rqcMKInIIkbmeUYk0D
         +S/de/zje8wdLL4ARyR8Te4ZJ1zVBrDjdQp181N+4HHQG8yvAd3uZPGEhtr3AsUhtOJ2
         e5pQHYfPm9K7C0CqWdUqHcWldcZQIsKJjv3aPGUGAJjp4nXJxf9OE99XWIGWib6lxy5z
         oMukRpLaZH1NCwlzRNFKfdkVyHXf/gGUGZS0mjQz6JRE+7NIwrZKOvh/wygGVtJ08xeD
         K3G+523YBxMw5qD0g1qWVRM1TKKzE6hfUicZSWwTUimlVXGzAkqRDh8dDJMnsWDDYVC9
         r4Mg==
X-Forwarded-Encrypted: i=1; AJvYcCV1sWWYhIWt88wOPTUlYMbhKoTUCjdh4+xJnOWXUoZXcuSg4gPoCu5NQlRw2hpVkTgh/mI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzARAQjqeWdITtKMqsZ1T4RBIVAL4BY1/dXujltLocAf7shoAn5
	v2jeoGtMe8A1bl+oB4mprF+CAZcLWw78QjEwV9tbWUGMymiHebxhg+gp6tviTPD7gwPHbraHm7G
	WJQ==
X-Google-Smtp-Source: AGHT+IFTbqmJJfq29+DpJvy9XBe6WodScDx+dQjeroXmCCrwMNoNzJvWaB1qOa1AKJaWaQpzxTfiia20RNI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecce:b0:206:a1c9:273 with SMTP id
 d9443c01a7336-208d83f5295mr5049535ad.7.1727163955519; Tue, 24 Sep 2024
 00:45:55 -0700 (PDT)
Date: Tue, 24 Sep 2024 00:45:52 -0700
In-Reply-To: <ZvIOox8CncED/gSL@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240703020921.13855-1-yan.y.zhao@intel.com> <20240703021043.13881-1-yan.y.zhao@intel.com>
 <ZvG1Wki4GvIyVWqB@google.com> <ZvIOox8CncED/gSL@yzhao56-desk.sh.intel.com>
Message-ID: <ZvJuMGmpYT60Qh6I@google.com>
Subject: Re: [PATCH v2 1/4] KVM: x86/mmu: Introduce a quirk to control memslot
 zap behavior
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	isaku.yamahata@intel.com, dmatlack@google.com, sagis@google.com, 
	erdemaktas@google.com, graf@amazon.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 24, 2024, Yan Zhao wrote:
> On Mon, Sep 23, 2024 at 11:37:14AM -0700, Sean Christopherson wrote:
> > > +static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
> > > +{
> > > +	struct kvm_gfn_range range = {
> > > +		.slot = slot,
> > > +		.start = slot->base_gfn,
> > > +		.end = slot->base_gfn + slot->npages,
> > > +		.may_block = true,
> > > +	};
> > > +	bool flush = false;
> > > +
> > > +	write_lock(&kvm->mmu_lock);
> > > +
> > > +	if (kvm_memslots_have_rmaps(kvm))
> > > +		flush = kvm_handle_gfn_range(kvm, &range, kvm_zap_rmap);
> > 
> > This, and Paolo's merged variant, break shadow paging.  As was tried in commit
> > 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot"),
> > all shadow pages, i.e. non-leaf SPTEs, need to be zapped.  All of the accounting
> > for a shadow page is tied to the memslot, i.e. the shadow page holds a reference
> > to the memslot, for all intents and purposes.  Deleting the memslot without removing
> > all relevant shadow pages results in NULL pointer derefs when tearing down the VM.
> > 
> > Note, that commit is/was buggy, and I suspect my follow-up attempt[*] was as well.
> > https://lore.kernel.org/all/20190820200318.GA15808@linux.intel.com
> > 
> > Rather than trying to get this functional for shadow paging (which includes nested
> > TDP), I think we should scrap the quirk idea and simply make this the behavior for
> > S-EPT and nothing else.
> Ok. Thanks for identifying this error. Will change code to this way.

For now, I think a full revert of the entire series makes sense.  Irrespective of
this bug, I don't think KVM should commit to specific implementation behavior,
i.e. KVM shouldn't explicitly say only leaf SPTEs are zapped.  The quirk docs
should instead say that if the quirk is disabled, KVM will only guarantee that
the delete memslot will be inaccessible.  That way, KVM can still do a fast zap
when it makes sense, e.g. for large memslots, do a complete fast zap, and for
small memslots, do a targeted zap of the TDP MMU but a fast zap of any shadow
MMUs.

> BTW: update some findings regarding to the previous bug with Nvidia GPU
> assignment:
> I found that after v5.19-rc1+, even with nx_huge_pages=N, the bug is not
> reproducible when only leaf entries of memslot are zapped.
> (no more detailed info due to limited time to debug).

Heh, I've given up hope on ever finding a root cause for that issue.

