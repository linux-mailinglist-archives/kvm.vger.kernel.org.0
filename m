Return-Path: <kvm+bounces-54471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 48BD8B21ACA
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 34AB24E2E0E
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC962D97A3;
	Tue, 12 Aug 2025 02:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bj1CJdES"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405AA311C02
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 02:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754965901; cv=none; b=B7LtCF/Q9oQAomjnXIP3xhHMiib4CQGe+pphZQAMTjov9unuuKngoptVDjeSTo/LZfnRenyFp0XgCMJBj3fANcWHwVYt3fSGEq2lueA3U0BFuYzWOZjCVUJYaQeT5ciDfhWwjikyQo/rNS/ewLRL2opgJf7vCBvavD6m+jewEZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754965901; c=relaxed/simple;
	bh=BJuyteyw9XvfwFNLKSUu1hI0HxKgX0sf6HX0jQtRbkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nH4nF5CS9qCmUwUNZfHh/YeAIw44WNpJSljYLhLgHx2zz+JxsCjERQxoHrW8l4HlYLuCw/ivI39awnqr1X4qEcpgZuqtFcRjap9pCdtyPo3i9NwqbsIY+qv94ajXmj3PYUTVkipU4E/rvkbzXiknnNJsM4LoHA22hOrKjrYiuSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bj1CJdES; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-242d1e9c6b4so113665ad.0
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 19:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754965899; x=1755570699; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gigjc+YHl8yhW0BHFCQHAU5Qlxh88HdkyU2sD42vIKs=;
        b=bj1CJdESzDuYq4wTNO3RpS9S4/v36t6eldPPkwm7HZhBr5i/EEjAOdaoVmo/g8LnYA
         1YwDUoSiavR0gg/YgF3Yi0kGg++guHkQowefq+HvXpRsGc62J2irCpTTnpoyXUsj+7ls
         vC446j8PUAuyy/KV1HbgbB0UDlgbB/ywGCfVMAhTzb9aAX30PelYhHfZvYec5COujKz6
         vk+gL8HZ9WNiy/wkxH+dCvsDJgAkY0f4JZ4Qxkaps32+bmxybuYVYlP3PMBe9mtP7mQv
         hR3LVJU5aoHqsH91t6/69aGc9UniUIwtfuga9zm0p8tCTj9H4LUKPCMnVHeuvAUewkat
         eqBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754965899; x=1755570699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gigjc+YHl8yhW0BHFCQHAU5Qlxh88HdkyU2sD42vIKs=;
        b=AIVKibZQcNHxGmfkVSOyOy70UfZZmFOTvMkPlJgh0DUVaHOfPMOVp2kQqHszOZGXB7
         3FH8mr7X6L7AtqoyvlSwiEMXm2JcGmR/g//2T10LW1TunTuaWIbDlHjfr7dqPrmwcfus
         uZQ8+IPh7vndkUWDHNM+zbcbb1W38/RBvpa1ZhLlMqpA4YgWyyLHSjonYX1GdUtzsnfM
         OqHYitISuLbsKGini5qedo+KT9Cr5tw2K6lzIBXFEUCO/5x/tGKmwtKauIuznF1vfKfa
         ugzzQLqlrjqcbWw7KMeEckN0wv+84DmVeG/wCOHwHAzzqSdaubTlbxTfkAXFuJNPhuP5
         gV3w==
X-Forwarded-Encrypted: i=1; AJvYcCXEouDcQ+5uXepeYqHccHisdukgGlMiJCPrb0/Bec+KN/0nFDi71noB0b38TncOk3ZIlbQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKQlv8B3I//KjISosWtjeJ/GiwKDmJv68m/kXe2quM481tot0T
	n8hVqkFebfZQw+fJj/WhNqACuZ2o98CXhbuE3CyCXzKsI5INQGbJPovqLliW8Lm5hcf8n1VCnCx
	gntO3co7T4uTmdb8mvRxrmnOwGUaFAEk6Nc36F1OP
X-Gm-Gg: ASbGncv3OWDS9OFt/Tfbiau2cpfpz2PESO/NTkqFUcRrQJysTkpXVDPRSBN5Laep4cM
	FfXql1OrHTipO6mUNf6HvWUgl9o/E5hA5BG36iEthYvEk7SYQvgZlB3DF7YoD1akBZxTBRqpoGE
	LkwDC49kSxAjcbaRJ2scVNCOpVCbx/L14CMsStY0rg4Fa5lIdUllJaf2UvbTRAHbxnxNA/PKKXK
	uA27rotpFI73nRtEi1/66CGN91mf1udTVCytstXGKRRwv8ieCo=
X-Google-Smtp-Source: AGHT+IFjR7/59bLXqdMG45ijfjBsstuaKV8l0fouiyv83xrRxHek1RFBXQoId5l45vd44AddM38xuhfanRjJ9FBxe/c=
X-Received: by 2002:a17:903:3c65:b0:22e:1858:fc25 with SMTP id
 d9443c01a7336-242fedd3b9amr1268105ad.9.1754965899018; Mon, 11 Aug 2025
 19:31:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com> <aJqgosNUjrCfH_WN@google.com>
In-Reply-To: <aJqgosNUjrCfH_WN@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 11 Aug 2025 19:31:26 -0700
X-Gm-Features: Ac12FXwemm5QfMsHojPrie984ICUoSlUXi0okP4W4I2ic6L7UZ6Sv14sh72jT4k
Message-ID: <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	Chao Gao <chao.gao@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2025 at 7:02=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Aug 11, 2025, Rick P Edgecombe wrote:
> > On Mon, 2025-08-11 at 07:31 +0100, kas@kernel.org wrote:
> > > > I don't see any other reason for the global spin lock, Kirill was t=
hat
> > > > it?  Did you consider also adding a lock per 2MB region, like the
> > > > refcount? Or any other granularity of lock besides global? Not sayi=
ng
> > > > global is definitely the wrong choice, but seems arbitrary if I got=
 the
> > > > above right.
> > >
> > > We have discussed this before[1]. Global locking is problematic when =
you
> > > actually hit contention. Let's not complicate things until we actuall=
y
> > > see it. I failed to demonstrate contention without huge pages. With h=
uge
> > > pages it is even more dubious that we ever see it.
> > >
> > > [1]
> > > https://lore.kernel.org/all/4bb2119a-ff6d-42b6-acf4-86d87b0e9939@inte=
l.com/
> >
> > Ah, I see.
> >
> > I just did a test of simultaneously starting 10 VMs with 16GB of ram (n=
on huge
>
> How many vCPUs?  And were the VMs actually accepting/faulting all 16GiB?
>
> There's also a noisy neighbor problem lurking.  E.g. malicious/buggy VM s=
pams
> private<=3D>shared conversions and thus interferes with PAMT allocations =
for other
> VMs.
>
> > pages) and then shutting them down. I saw 701 contentions on startup, a=
nd 53
> > more on shutdown. Total wait time 2ms. Not horrible but not theoretical=
 either.
> > But it probably wasn't much of a cacheline bouncing worse case.
>
> Isn't the SEAMCALL done while holding the spinlock?  I assume the latency=
 of the
> SEAMCALL is easily the long pole in the flow.
>
> > And I guess this is on my latest changes not this exact v2, but it shou=
ldn't
> > have changed.
> >
> > But hmm, it seems Dave's objection about maintaining the lock allocatio=
ns would
> > apply to the refcounts too? But the hotplug concerns shouldn't actually=
 be an
> > issue for TDX because they gets rejected if the allocations are not alr=
eady
> > there. So complexity of a per-2MB lock should be minimal, at least
> > incrementally. The difference seems more about memory use vs performanc=
e.
> >
> > What gives me pause is in the KVM TDX work we have really tried hard to=
 not take
> > exclusive locks in the shared MMU lock path. Admittedly that wasn't bac=
ked by
> > hard numbers.
>
> Maybe not for TDX, but we have lots and lots of hard numbers for why taki=
ng mmu_lock
> for write is problematic.  Even if TDX VMs don't exhibit the same pattern=
s *today*
> as "normal" VMs, i.e. don't suffer the same performance blips, nothing gu=
arantees
> that will always hold true.
>
> > But an enormous amount of work went into lettings KVM faults happen und=
er the
> > shared lock for normal VMs. So on one hand, yes it's premature optimiza=
tion.
> > But on the other hand, it's a maintainability concern about polluting t=
he
> > existing way things work in KVM with special TDX properties.
> >
> > I think we need to at least call out loudly that the decision was to go=
 with the
> > simplest possible solution, and the impact to KVM. I'm not sure what Se=
an's
> > opinion is, but I wouldn't want him to first learn of it when he went d=
igging
> > and found a buried global spin lock in the fault path.
>
> Heh, too late, I saw it when this was first posted.  And to be honest, my=
 initial
> reaction was very much "absolutely not" (though Rated R, not PG).  Now th=
at I've
> had time to think things through, I'm not _totally_ opposed to having a s=
pinlock
> in the page fault path, but my overall sentiment remains the same.
>
> For mmu_lock and related SPTE operations, I was super adamant about not t=
aking
> exclusive locks because based on our experience with the TDP MMU, convert=
ing flows
> from exclusive to shared is usually significantly more work than developi=
ng code
> for "shared mode" straightaway (and you note above, that wasn't trivial f=
or TDX).
> And importantly, those code paths were largely solved problems.  I.e. I d=
idn't
> want to get into a situation where TDX undid the parallelization of the T=
DP MMU,
> and then had to add it back after the fact.
>
> I think the same holds true here.  I'm not completely opposed to introduc=
ing a
> spinlock, but I want to either have a very high level of confidence that =
the lock
> won't introduce jitter/delay (I have low confidence on this front, at lea=
st in
> the proposed patches), or have super clear line of sight to making the co=
ntention
> irrelevant, without having to rip apart the code.
>
> My biggest question at this point is: why is all of this being done on-de=
mand?
> IIUC, we swung from "allocate all PAMT_4K pages upfront" to "allocate all=
 PAMT_4K
> pages at the last possible moment".  Neither of those seems ideal.
>
> E.g. for things like TDCS pages and to some extent non-leaf S-EPT pages, =
on-demand
> PAMT management seems reasonable.  But for PAMTs that are used to track g=
uest-assigned
> memory, which is the vaaast majority of PAMT memory, why not hook guest_m=
emfd?

This seems fine for 4K page backing. But when TDX VMs have huge page
backing, the vast majority of private memory memory wouldn't need PAMT
allocation for 4K granularity.

IIUC guest_memfd allocation happening at 2M granularity doesn't
necessarily translate to 2M mapping in guest EPT entries. If the DPAMT
support is to be properly utilized for huge page backings, there is a
value in not attaching PAMT allocation with guest_memfd allocation.

> I.e. setup PAMT crud when guest_memfd is populated, not when the memory i=
s mapped
> into the guest.  That way setups that cares about guest boot time can pre=
allocate
> guest_memfd in order to get the PAMT stuff out of the way.
>
> You could do the same thing by prefaulting guest memory, but TDX has limi=
tations
> there, and I see very little value in precisely reclaiming PAMT memory wh=
en a
> leaf S-EPT is zapped, i.e. when a page is converted from private=3D>share=
d.  As
> above, that's just asking for noisy neighbor issues.
>
> The complaints with static PAMT are that it required burning 0.4% of memo=
ry even
> if the host isn't actively running TDX VMs.  Burning 0.4% of the memory a=
ssigned
> to a guest, regardless of whether it's map private or shared, seems accep=
table,
> and I think would give us a lot more flexibility in avoiding locking issu=
es.
>
> Similarly, we could bind a PAMT to non-leaf S-EPT pages during mmu_topup_=
memory_caches(),
> i.e. when arch.mmu_external_spt_cache is filled.  Then there would be no =
need for
> a separate vcpu->arch.pamt_page_cache, and more work would be done outsid=
e of
> mmu_lock.  Freeing SPTs would still be done under mmu_lock (I think), but=
 that
> should be a much rarer operation.
>

