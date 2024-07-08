Return-Path: <kvm+bounces-21109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DDB692A79D
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 18:51:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3514A281F3B
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 16:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9E8147C6E;
	Mon,  8 Jul 2024 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CKwtyjKJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588C71459FE
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 16:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720457490; cv=none; b=O0AFU2A/jJD+oPfZYgwfxDuSjSdbKASxi3hmZBi1zBdOs1fKHyhbaANP72x6tCcCZYr2W7vEtCmaOC/43Uu9ux3xi5WbCpViy54+mgG3EtE/Ew6D4zE2lAN1sp2AX1CSP5avSi/71zA4Fqqx1498mZKNi3BFioGo+RbheScS67Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720457490; c=relaxed/simple;
	bh=bT7f63TQT0nCVI2e044tDWWSBtyBG+UKBLYM/Q2ACJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pRnwQ0/WwYuaE/PR/XIb/l1A7YWtY3yGlbTSdJZnWgKTufttTMkvk0iJxPPCXe7bEbaYWgly1WOdt//0LOJ4wkhSxt/dkQxWa3adPmNsk/ovMjA0M0TF7evagzDAMWErp0hKuUr7PYpMSxyl5IYHGEwW9k2RFqDGzpQvX3/2rYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CKwtyjKJ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fb67f59805so3975ad.1
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 09:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720457488; x=1721062288; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTLNn4LGmic6uz3SST2MPov4JwAtgFvBXVkhyUNj6Ls=;
        b=CKwtyjKJf+SJzdT9BMAE2zgNNJESaz26MmRxY5V9XkOp6g8TDVYbg92xAJq0Bqa1D5
         pQpO+c+aAm7YTNq5IApktSnyKs6GE4W+6Ytl2mb/hzEaJsFvpVpeQCb3MkjM2ghmE9uG
         MJGEqG5Ym5YL/YW5cltx62c3fQJgEFuoxQz3JOJlEr9JK0M/8vwfIkpfiIuFB16I1HCA
         wi7rnEuLPbhEhmH9F93rjJTWu/lzkc1kS/bOsp6vsMNFRtAkvovkd63ykGSndybQeHh7
         F9WpEEGz4VVJvoz1zE4Fe/Q/JPCu2vlkTNA+sSLSoCfxMb1+0qkK0qG/LvsprA/IANXo
         AzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720457488; x=1721062288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZTLNn4LGmic6uz3SST2MPov4JwAtgFvBXVkhyUNj6Ls=;
        b=WmM2aw6LdWGWOc9EdOpW4tSaGI+LM544ZgkApJcLb0CkeQ1wfwQGNNPHC9GtBcHmg8
         zevwZQH7UI9NajTjmRfTm5lcl6FHswujmD0MiuQcefAfiAn8k6Czd64k9b0jlskuMRAi
         0a8oVLDcklaZ2ZaAvQYQCJZ1rznQRM2o4fVYlk7KMSrUespkDirIpNbdyRiaJouxLAJg
         TsCZljh6sdQYodNR+wMA0gkSrGNDZmxXt/OLFy2sYpQ3JSidB0c1dmLehJFYZHQ7PDjJ
         gexs/p7qvGzC8n4qjtXk7koBKzLNj2usB4JqKmb1nyTk2cczMUxvg9Jp30qDkYutGc8A
         5nsg==
X-Forwarded-Encrypted: i=1; AJvYcCW/TM40LkIIiWHyN6d4UcgXxeHjcgPyj5QEJKtBfKHZECCtxA9OD9XBW/wVLi91ETkw3Qo770ACg6tiKGiJIY2/uicv
X-Gm-Message-State: AOJu0Yyrn7h7ipyJQ1Mc7W7wSQOKwiKSFbB0jsuXtmcLWMMqaZ7mC+Dl
	IMiwZ29964R27Hh6n7dMKo8049b1q8rXSmdu/ffuQXQHiSaJDCail9MmdyPrW2VB3JCujRyV0tC
	ovRrNS7xVqpTA40tOKJyyxgW+G4+YpquvlVhu
X-Google-Smtp-Source: AGHT+IGMZBuODG5Qg+BsiQ0JMRrEsApbDVZodAf/W97JpFbZBYOVdGRDLcd2wERkfLVJkW8bcAp1r3ymFzBf2tplW5Q=
X-Received: by 2002:a17:903:6d0:b0:1fa:cd15:985e with SMTP id
 d9443c01a7336-1fb30b895c8mr9496525ad.6.1720457488179; Mon, 08 Jul 2024
 09:51:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
 <ZmioedgEBptNoz91@google.com> <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
 <ZmjtEBH42u7NUWRc@google.com> <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
 <ZmxsCwu4uP1lGsWz@google.com> <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
 <ZmzPoW7K5GIitQ8B@google.com> <CADrL8HW3rZ5xgbyGa+FXk50QQzF4B1=sYL8zhBepj6tg0EiHYA@mail.gmail.com>
 <ZnCCZ5gQnA3zMQtv@google.com> <CADrL8HW=kCLoWBwoiSOCd8WHFvBdWaguZ2ureo4eFy9D67+owg@mail.gmail.com>
In-Reply-To: <CADrL8HW=kCLoWBwoiSOCd8WHFvBdWaguZ2ureo4eFy9D67+owg@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 8 Jul 2024 09:50:51 -0700
Message-ID: <CADrL8HUv6T4baOi=VTFV6ZA=Oyn3dEc6Hp9rXXH0imeYkwUhew@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2024 at 7:38=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Mon, Jun 17, 2024 at 11:37=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Mon, Jun 17, 2024, James Houghton wrote:
> > > On Fri, Jun 14, 2024 at 4:17=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > Ooh!  Actually, after fiddling a bit to see how feasible fast-aging=
 in the shadow
> > > > MMU would be, I'm pretty sure we can do straight there for nested T=
DP.  Or rather,
> > > > I suspect/hope we can get close enough for an initial merge, which =
would allow
> > > > aging_is_fast to be a property of the mmu_notifier, i.e. would simp=
lify things
> > > > because KVM wouldn't need to communicate MMU_NOTIFY_WAS_FAST for ea=
ch notification.
> > > >
> > > > Walking KVM's rmaps requires mmu_lock because adding/removing rmap =
entries is done
> > > > in such a way that a lockless walk would be painfully complex.  But=
 if there is
> > > > exactly _one_ rmap entry for a gfn, then slot->arch.rmap[...] point=
s directly at
> > > > that one SPTE.  And with nested TDP, unless L1 is doing something u=
ncommon, e.g.
> > > > mapping the same page into multiple L2s, that overwhelming vast maj=
ority of rmaps
> > > > have only one entry.  That's not the case for legacy shadow paging =
because kernels
> > > > almost always map a pfn using multiple virtual addresses, e.g. Linu=
x's direct map
> > > > along with any userspace mappings.
>
> Hi Sean, sorry for taking so long to get back to you.
>
> So just to make sure I have this right: if L1 is using TDP, the gfns
> in L0 will usually only be mapped by a single spte. If L1 is not using
> TDP, then all bets are off. Is that true?
>
> If that is true, given that we don't really have control over whether
> or not L1 decides to use TDP, the lockless shadow MMU walk will work,
> but, if L1 is not using TDP, it will often return false negatives
> (says "old" for an actually-young gfn). So then I don't really
> understand conditioning the lockless shadow MMU walk on us (L0) using
> the TDP MMU[1]. We care about L1, right?

Ok I think I understand now. If L1 is using shadow paging, L2 is
accessing memory the same way L1 would, so we use the TDP MMU at L0
for this case (if tdp_mmu_enabled). If L1 is using TDP, then we must
use the shadow MMU, so that's the interesting case.

> (Maybe you're saying that, when the TDP MMU is enabled, the only cases
> where the shadow MMU is used are cases where gfns are practically
> always mapped by a single shadow PTE. This isn't how I understood your
> mail, but this is what your hack-a-patch[1] makes me think.)

So it appears that this interpretation is actually what you meant.

>
> [1] https://lore.kernel.org/linux-mm/ZmzPoW7K5GIitQ8B@google.com/
>
> >
> > ...
> >
> > > Hmm, interesting. I need to spend a little bit more time digesting th=
is.
> > >
> > > Would you like to see this included in v6? (It'd be nice to avoid the
> > > WAS_FAST stuff....) Should we leave it for a later series? I haven't
> > > formed my own opinion yet.
> >
> > I would say it depends on the viability and complexity of my idea.  E.g=
. if it
> > pans out more or less like my rough sketch, then it's probably worth ta=
king on
> > the extra code+complexity in KVM to avoid the whole WAS_FAST goo.
> >
> > Note, if we do go this route, the implementation would need to be tweak=
ed to
> > handle the difference in behavior between aging and last-minute checks =
for eviction,
> > which I obviously didn't understand when I threw together that hack-a-p=
atch.
> >
> > I need to think more about how best to handle that though, e.g. skippin=
g GFNs with
> > multiple mappings is probably the worst possible behavior, as we'd risk=
 evicting
> > hot pages.  But falling back to taking mmu_lock for write isn't all tha=
t desirable
> > either.
>
> I think falling back to the write lock is more desirable than evicting
> a young page.
>
> I've attached what I think could work, a diff on top of this series.
> It builds at least. It uses rcu_read_lock/unlock() for
> walk_shadow_page_lockless_begin/end(NULL), and it puts a
> synchronize_rcu() in kvm_mmu_commit_zap_page().
>
> It doesn't get rid of the WAS_FAST things because it doesn't do
> exactly what [1] does. It basically makes three calls now: lockless
> TDP MMU, lockless shadow MMU, locked shadow MMU. It only calls the
> locked shadow MMU bits if the lockless bits say !young (instead of
> being conditioned on tdp_mmu_enabled). My choice is definitely
> questionable for the clear path.

I still don't think we should get rid of the WAS_FAST stuff.

The assumption that the L1 VM will almost never share pages between L2
VMs is questionable. The real question becomes: do we care to have
accurate age information for this case? I think so.

It's not completely trivial to get the lockless walking of the shadow
MMU rmaps correct either (please see the patch I attached here[1]).
And the WAS_FAST functionality isn't even that complex to begin with.

Thanks for your patience.

[1]: https://lore.kernel.org/linux-mm/CADrL8HW=3DkCLoWBwoiSOCd8WHFvBdWaguZ2=
ureo4eFy9D67+owg@mail.gmail.com/

