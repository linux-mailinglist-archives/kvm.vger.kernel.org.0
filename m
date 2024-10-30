Return-Path: <kvm+bounces-30017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 610049B6361
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 13:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52297B21BBB
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 12:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF961E906A;
	Wed, 30 Oct 2024 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJW5Dfbs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EA11E47AC
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 12:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730292690; cv=none; b=h3b7XARAclfZEtn2c6rdF6KQge60/OUQ0QJgNpJXAnsjfUDL8UkfDJkpwFBisCYsWmI5bOwQwWsSeaHzikWpY+545tHJCEPW9Y9ZbH8/wypbpjyAnaD4zkxxzlIVTsDP92xTmzq9urLurwjdOoMBJTu/4Znki+kKCjbwkflXLlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730292690; c=relaxed/simple;
	bh=R7BmwOlr5WtleJBlCesb3Yq3ZyF0VV24sURzeamECds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GWyD3YsAJiHRS1HDQ3QD5s2ZpJis0YAsYNadCF0Cr/41WzDSdjtQ482z6lH2JqfayGRC2tE2HC9xqwiUbdVV89WW5gaDmATct+9xpb99jahgvPb7Yr+1tXYg1xDTY6nLpI2acBnInQUc5drW4iOHHpM5v4ubLPZltjWG6q2OHfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IJW5Dfbs; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2e2a999b287so5335866a91.0
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 05:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730292688; x=1730897488; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUElr+XewgO9036D0OFEiFkKs5QXATuo+eL/s62zPh4=;
        b=IJW5DfbsRRyJA4pRanwdbte0z85e1eKhg39oWwz7edNJKaDE+SE2Zlf9JA768zgIUb
         /5buvxVnVV/TVNWOA7n48Nz8Lv5pPZDkn8hK/TtgGvsyquxPnGtBT/M2smir6OwrLo+K
         /MjRHTxnRld3i165qTe7OiFl8MB/ZctYIkz2W50Keg3N9vjjozK62q2jonXtto2Z2Srz
         cXzEwuyAh4aEjAvmVEWkacMN9UVavHu0VTBaT2uBTQKGnW2LOnyGLXPZhyLzAOZZ/KK9
         Zx9PE88biplaJV7YAO0fFvODUJmalEuOXa16QMGremMe9M4iFhHZWlTFNA/WWBeYmefw
         P9xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730292688; x=1730897488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUElr+XewgO9036D0OFEiFkKs5QXATuo+eL/s62zPh4=;
        b=cCQDPq7N3kMT7+jwTdyNxLCCkfdNh0XPUs5qZcqYSAZ0mBDLhKGmmxzNZF2HC+fk3/
         /ZEBSEvVVIFJlYFztClMNqvUUfPf8OrwaY3tm/vttvx+d8Fxn0upbqmfZEHWW1Gt1fVB
         TM0AqBzjwsEwPzkaK24KXB1TLIpzT08XNn7VgkPQkBXum5Jrc9OCfW6WR1+7s7rXuO6/
         8tsS6mGPseq8nN5cqCBjhnCulfx0G7NtOgE8n8q3/QIJBB3L2sNxUWjs7JQwpdEMdABV
         gZfLBYOeiAYJcEGO+XABPAFvNbR+pOlZeP2j7H+W0s7TrhQRrWZmbi3Vof5svex0Jd13
         W7aw==
X-Forwarded-Encrypted: i=1; AJvYcCWKJqGxTMqmD5ypO/VhUGWS1Wy8vG01PyH94WIADGAOFO0MAVYMPicmyoez/uiEFJNGqbI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh17OuMcPnFMsvtoEz9XSyycVOvtP3Kr1Up2l9N1W/i4Q2Ekdg
	XTWdiuWPLsvXOYmzEe246+NwZDz1fh6pYoBNxlhacVUT+bpKvPxJC+JtjT76OnlTQkvZaCrwA/Z
	0YrNNbU+ln+Q9fjX7T3vmJWRKFB0=
X-Google-Smtp-Source: AGHT+IE+517IrfAjOswjuQxHjzmSQ3gC2zsaLau5zStOA2lq1pkpmbPxPO5AIDrQ2CPg9wdtYt4xGsixyIPuzK//7ds=
X-Received: by 2002:a17:90a:e20d:b0:2e2:ddfa:24d5 with SMTP id
 98e67ed59e1d1-2e8f105e9bbmr16954960a91.15.1730292687748; Wed, 30 Oct 2024
 05:51:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029031400.622854-1-alexyonghe@tencent.com>
 <20241029031400.622854-3-alexyonghe@tencent.com> <ZyD76t8kY3dvO6Yg@google.com>
In-Reply-To: <ZyD76t8kY3dvO6Yg@google.com>
From: zhuangel570 <zhuangel570@gmail.com>
Date: Wed, 30 Oct 2024 20:51:16 +0800
Message-ID: <CANZk6aSUzdxT-QjCoaSe2BJJnr=W9Gz0WfBV2Lg+SctgZ2DiHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: introduce cache configurations for previous CR3s
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com, 
	alexyonghe@tencent.com, junaids@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 4:38=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Oct 29, 2024, Yong He wrote:
> > From: Yong He <alexyonghe@tencent.com>
> >
> > Introduce prev_roots_num param, so that we use more cache of
> > previous CR3/root_hpa pairs, which help us to reduce shadow
> > page table evict and rebuild overhead.
> >
> > Signed-off-by: Yong He <alexyonghe@tencent.com>
> > ---
>
> ...
>
> > +uint __read_mostly prev_roots_num =3D KVM_MMU_NUM_PREV_ROOTS;
> > +EXPORT_SYMBOL_GPL(prev_roots_num);
> > +module_param_cb(prev_roots_num, &prev_roots_num_ops,
> > +             &prev_roots_num, 0644);
>
> Allowing the variable to be changed while KVM is running is unsafe.

Sorry, I have no intention to revise prev_roots_num, changing it 0444 is
simpler and can improve performance, will update in next version.

>
> I also think a module param is the wrong way to try to allow for bigger c=
aches.
> The caches themselves are relatively cheap, at 16 bytes per entry.  And I=
 doubt
> the cost of searching a larger cache in fast_pgd_switch() would have a me=
asurable
> impact, since the most recently used roots will be at the front of the ca=
che,
> i.e. only near-misses and misses will be affected.

Maybe the context switch test could see some result, when the processes in =
guest
are 7 or 8 (all cache misses), nearly no performance drop.

>
> The only potential downside to larger caches I can think of, is that keep=
ing
> root_count elevated would make it more difficult to reclaim shadow pages =
from
> roots that are no longer relevant to the guest.  kvm_mmu_zap_oldest_mmu_p=
ages()
> in particular would refuse to reclaim roots.  That shouldn't be problemat=
ic for
> legacy shadow paging, because KVM doesn't recursively zap shadow pages.  =
But for
> nested TDP, mmu_page_zap_pte() frees the entire tree, in the common case =
that
> child SPTEs aren't shared across multiple trees (common in legacy shadow =
paging,
> extremely uncommon in nested TDP).
>
> And for the nested TDP issue, if it's actually a problem, I would *love* =
to
> solve that problem by making KVM's forced reclaim more sophisticated.  E.=
g. one
> idea would be to kick all vCPUs if the maximum number of pages has been r=
eached,
> have each vCPU purge old roots from prev_roots, and then reclaim unused r=
oots.
> It would be a bit more complicated than that, as KVM would need a way to =
ensure
> forward progress, e.g. if the shadow pages limit has been reach with a si=
ngle
> root.  But even then, kvm_mmu_zap_oldest_mmu_pages() could be made a _lot=
_ smarter.

I not very familiar with TDP on TDP.
I think you mean force free cached roots in kvm_mmu_zap_oldest_mmu_pages() =
when
no mmu pages could be zapped. Such as kick all VCPUs and purge cached roots=
.

>
> TL;DR: what if we simply bump the number of cached roots to ~16?

I set the number to 11 because the PCID in guest kernel is 6
(11+current=3D12), when
there are more than 6 processes in guest, the PCID will be reused,
then cached roots
will not easily to hit.
The context switch case shows no performance gain when process are 7 and 8.

