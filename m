Return-Path: <kvm+bounces-21372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D44892DC69
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EF5D1F250FC
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C289A1527BB;
	Wed, 10 Jul 2024 23:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UCE7s+TO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6419D14EC4A
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720653070; cv=none; b=Sj+I9tCSw5UJ3HGrfAsfmbqn5SS+FbrUGplN5YRmNw8a9suCotB189goISBwBfx04YTFMAXWafRCHMSKci+e7cL6I6zbzPOrRPG9dhohMtLGMVJc/C3lSX77rPZWPojW2Wj1AlR2+wI30DZKhOXEzsrhEEctykb2rYkAJ/lrkTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720653070; c=relaxed/simple;
	bh=Pz0I0ZuPQJNsCVP+7BMKlxh3Arp7J6K1rlyeZNl314U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HlBmcPEzgEjFhCdoDa44TmM5P6nj3CmaOTyc7bx3NwtSic+tSycGAXkEewFRM10ayui/EEE/IVMni27KwC56HBo1FIegRgbFq//j7CQJmVFD/l3TBrv9XB4kY/QvIVQzl1OBB8sy7tCI/atQ4NmDY7T0Kgez1mnJ3g68JtDCkso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UCE7s+TO; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-44664ad946eso51711cf.1
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720653067; x=1721257867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJTeSm6eMBTbHXnqICN2W1jCeLI7nzO2Ktbu8vr4Dfo=;
        b=UCE7s+TO1QmRo+sxKxuGzcxMacJfBy92C0nmtraHr8SPFhTz+JStqlWzS4ZPnK4mgB
         pxgWtOjLzq95hbdOAyXWBnch6Dp7ScL2UlGzDHPU12cn5oXM1gCDMroNzvR894gNn8fJ
         aMw18TeG1M0kVuQC10miQlQmhoG23EETgyvi1TYYgrM7+2Q5EZYahhR12b9wrM9Ei75i
         fEoOC/jV+iHYy6VKNWLzC3cHOZVj5w22p8Y+IBu7H5B+CZkvd7ZSI1OidRFQ94SlL8A7
         YhJNSfUu+wQhwdiyTxrzc+9BWE51QKtgIKqEtwWSVFZjFVrIUIE00ejA/XQKxl1DUIVs
         r4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720653067; x=1721257867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJTeSm6eMBTbHXnqICN2W1jCeLI7nzO2Ktbu8vr4Dfo=;
        b=S9JO899vLL2rl5l8xuxVSip8Rk/tmcQEw05hMxtnSvT5VBPqsskZ4ksu/PmnDjIGcF
         By7+SDkuspLRq+8CxpPklJKvudUByda16sOuUPZmW4IWLXXreT1ZPyRr/wq/BIWLTT+K
         13m42UaoE/TFrjKf4Q85QC/104E723pBk7B4soBdvVTg+SrupU7lbhV9QoHcImHNbLdy
         cmtnJKlEKjO3XZVe2N7aEzE94icmp2wKhfgJyoRnVTmrELfXl+evo8hmWnG57bsOdHk9
         k6blXsKMdb9bxkZOiYBix25dGY8J9iLLmX5EXTsvFMclsmCK46TA/MnvPhOKWTJsbN/+
         2rqg==
X-Forwarded-Encrypted: i=1; AJvYcCVJpeT9PivHpFGJAVgkooCH07q8iUSFCwo5Ux64eaY/n4NERwvz5sJoIKNv/8Ns5GMqhgw76G6bds2xgbqx5jj6AX/M
X-Gm-Message-State: AOJu0YyxNyaRIr4q5q+j5YU/4K5+EAepi0XZKNwPUQp35A2pX9bE58E1
	5HHSExCDgPL4P2EiLohVZIGNwGE4cOnDgWX8QNVIZuKxRZgLBcr1KKRNDrBVAtEwby81oInkm72
	K5aF71tfGnNWRzG9rxdnPsOdYiNtzjJKiS3sR
X-Google-Smtp-Source: AGHT+IGzszVF+IxKrY/ClY51Y2kjfgE37Xj8trnZtH5JYTor6nkkszob6If5ud2bc91ZsUHmQ4RjHdSOlc0bNNlnZxM=
X-Received: by 2002:ac8:7cba:0:b0:447:f958:ab83 with SMTP id
 d75a77b69052e-44d35b2b31emr557951cf.21.1720653067221; Wed, 10 Jul 2024
 16:11:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
 <ZmjtEBH42u7NUWRc@google.com> <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
 <ZmxsCwu4uP1lGsWz@google.com> <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
 <ZmzPoW7K5GIitQ8B@google.com> <CADrL8HW3rZ5xgbyGa+FXk50QQzF4B1=sYL8zhBepj6tg0EiHYA@mail.gmail.com>
 <ZnCCZ5gQnA3zMQtv@google.com> <CADrL8HW=kCLoWBwoiSOCd8WHFvBdWaguZ2ureo4eFy9D67+owg@mail.gmail.com>
 <CADrL8HUv6T4baOi=VTFV6ZA=Oyn3dEc6Hp9rXXH0imeYkwUhew@mail.gmail.com> <Zo137P7BFSxAutL2@google.com>
In-Reply-To: <Zo137P7BFSxAutL2@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 10 Jul 2024 16:10:29 -0700
Message-ID: <CADrL8HW4PLTeC9Gq3Fd43-idjzOw8mXOzzG_RP1TYVoGp1_g+g@mail.gmail.com>
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

On Tue, Jul 9, 2024 at 10:49=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 08, 2024, James Houghton wrote:
> > On Fri, Jun 28, 2024 at 7:38=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > On Mon, Jun 17, 2024 at 11:37=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > I still don't think we should get rid of the WAS_FAST stuff.
>
> I do :-)
>
> > The assumption that the L1 VM will almost never share pages between L2
> > VMs is questionable. The real question becomes: do we care to have
> > accurate age information for this case? I think so.
>
> I think you're conflating two different things.  WAS_FAST isn't about acc=
uracy,
> it's about supporting lookaround in conditionally fast secondary MMUs.
>
> Accuracy only comes into play when we're talking about the last-minute ch=
eck,
> which, IIUC, has nothing to do with WAS_FAST because any potential lookar=
ound has
> already been performed.

Sorry, I thought you meant: have the MMU notifier only ever be
lockless (when tdp_mmu_enabled), and just return a potentially wrong
result in the unlikely case that L1 is sharing pages between L2s.

I think it's totally fine to just drop WAS_FAST. So then we can either
do look-around (1) always, or (2) only when there is a secondary MMU
with has_fast_aging. (2) is pretty simple, I'll just do that.

We can add some shadow MMU lockless support later to make the
look-around not as useless for the nested TDP case.

> > It's not completely trivial to get the lockless walking of the shadow
> > MMU rmaps correct either (please see the patch I attached here[1]).
>
> Heh, it's not correct.  Invoking synchronize_rcu() in kvm_mmu_commit_zap_=
page()
> is illegal, as mmu_lock (rwlock) is held and synchronize_rcu() might_slee=
p().
>
> For kvm_test_age_rmap_fast(), KVM can blindly read READ_ONCE(*sptep).  KV=
M might
> read garbage, but that would be an _extremely_ rare scenario, and reporti=
ng a
> zapped page as being young is acceptable in that 1 in a billion situation=
.
>
> For kvm_age_rmap_fast(), i.e. where KVM needs to write, I'm pretty sure K=
VM can
> handle that by rechecking the rmap and using CMPXCHG to write the SPTE.  =
If the
> rmap is unchanged, then the old SPTE value is guaranteed to be valid, in =
the sense
> that its value most definitely came from a KVM shadow page table.  Ah, dr=
at, that
> won't work, because very theoretically, the page table could be freed, re=
allocated,
> and rewritten with the exact same value by something other than KVM.  Hrm=
.
>
> Looking more closely, I think we can go straight to supporting rmap walks=
 outside
> of mmu_lock.  There will still be a "lock", but it will be a *very* rudim=
entary
> lock, akin to the TDP MMU's REMOVED_SPTE approach.  Bit 0 of rmap_head->v=
al is
> used to indicate "many", while bits 63:3/31:2 on 64-bit/32-bit KVM hold t=
he
> pointer (to a SPTE or a list).  That means bit 1 is available for shenani=
gans.
>
> If we use bit 1 to lock the rmap, then the fast mmu_notifier can safely w=
alk the
> entire rmap chain.  And with a reader/write scheme, the rmap walks that a=
re
> performed under mmu_lock don't need to lock the rmap, which means flows l=
ike
> kvm_mmu_zap_collapsible_spte() don't need to be modified to avoid recursi=
ve
> self-deadlock.  Lastly, the locking can be conditioned on the rmap being =
valid,
> i.e. having at least one SPTE.  That way the common case of a gfn not hav=
ing any
> rmaps is a glorified nop.
>
> Adding the locking isn't actually all that difficult, with the *huge* cav=
eat that
> the below patch is compile-tested only.  The vast majority of the churn i=
s to make
> it so existing code ignores the new KVM_RMAP_LOCKED bit.

This is very interesting, thanks for laying out how this could be
done. I don't want to hold this series up on getting the details of
the shadow MMU lockless walk exactly right. :)

> I don't know that we should pursue such an approach in this series unless=
 we have
> to.  E.g. if we can avoid WAS_FAST or don't have to carry too much interm=
ediate
> complexity, then it'd probably be better to land the TDP MMU support firs=
t and
> then add nested TDP support later.

Agreed!

> At the very least, it does make me more confident that a fast walk of the=
 rmaps
> is very doable (at least for nested TDP), i.e. makes me even more steadfa=
st
> against adding WAS_FAST.
>
> > And the WAS_FAST functionality isn't even that complex to begin with.
>
> I agree the raw code isn't terribly complex, but it's not trivial either.=
  And the
> concept and *behavior* is complex, which is just as much of a maintenance=
 burden
> as the code itself.  E.g. it requires knowing that KVM has multiple MMUs =
buried
> behind a single mmu_notifier, and that a "hit" on the fast MMU will trigg=
er
> lookaround on the fast MMU, but not the slow MMU.  Understanding and desc=
ribing
> the implications of that behavior isn't easy.  E.g. if GFN=3DX is young i=
n the TDP
> MMU, but X+1..X+N are young only in the shadow MMU, is doing lookaround a=
nd making
> decisions based purely on the TDP MMU state the "right" behavior?
>
> I also really don't like bleeding KVM details into the mmu_nofitier APIs.=
  The
> need for WAS_FAST is 100% a KVM limitation.  AFAIK, no other secondary MM=
U has
> multiple MMU implementations active behind a single notifier, and other t=
han lack
> of support, nothing fundamentally prevents a fast query in the shadow MMU=
.

Makes sense.

So in v6, I will make the following changes:

1. Drop the WAS_FAST complexity.
2. Add a function like mm_has_fast_aging_notifiers(), use that to
determine if we should be doing look-around.
3. Maybe change the notifier calls slightly[1], still need to check perform=
ance.

Does that sound good to you?

Thanks!

[1]: https://lore.kernel.org/linux-mm/CAOUHufb2f_EwHY5LQ59k7Nh7aS1-ZbOKtkoy=
sb8BtxRNRFMypQ@mail.gmail.com/

