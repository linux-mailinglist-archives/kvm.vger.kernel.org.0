Return-Path: <kvm+bounces-37319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A171A28796
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C40D3188A562
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CEF122CBD5;
	Wed,  5 Feb 2025 10:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lqOAu5iL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D02222B5B9
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 10:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738750049; cv=none; b=sCs4DqmilyIq7M5nzS3NMcC3JO4mwZZwyVo9TTboNkJuY2u/yWtDSbOunfweAi4WuaexScZy4d6G2+b/6S1HEZGVepaDTHvZcF5gATfKPwYyGmzMD6QpziIGHCIHL/A5eSX6AACY6tnWIm5MBFoAt/5mED4ZIV6h5+CA7w4hSjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738750049; c=relaxed/simple;
	bh=c20MAwUWneOb5uhlqcc0oyAOyqlg08B0X2hw2T3qX4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ewc1fyfS7Xzthlk1fUJQ5pnmIpByO3YLZCNUvUyMqE5I5DiRF8mD6mqdBY37uQX8buyBi0TQQiTOt74P5PJ8MwsH8CIKyzDXAkym4kbAPan37zCK+ibFD1yhfZ3+ke0k31W/kZ+DFKFfKVuVbr5ZJoLihgayA37DUWaoLQOBRDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lqOAu5iL; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-467abce2ef9so550761cf.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 02:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738750043; x=1739354843; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c20MAwUWneOb5uhlqcc0oyAOyqlg08B0X2hw2T3qX4k=;
        b=lqOAu5iL/NXV+Pkkv9wlDQLmvzOaYX60wHS1RHvvuw/ml+bb8FHPfeSuPhMyUx4ccM
         r2CHAdy4HGXbkwIMOMz0dvbaC4Rg0hxwLMIwy6g4eI/141b3B2Kg1iGJN7IMnNZZsnBX
         68KmtK3PIJU+x22Yfz13ISj4NneAPPJQw9XPKAQBB91IDSQUujadwhei6QCfTG2LbWfu
         72d/0Uz94+wEquObZCa6QjGJtgnIr+kZeKPUzTLa+AqaUHw2MWcw8fCbiXVxjBTAzMie
         x6kYnLfoCzebLyTNtFHR5+9RwT9usP00bD1+7AU4gZUZLUsUJzc799DVBl9HF0Vn99Ci
         EgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738750043; x=1739354843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c20MAwUWneOb5uhlqcc0oyAOyqlg08B0X2hw2T3qX4k=;
        b=dgOjLtbUIU2BUtKw3hGyTWBi4Ull10k342b1qCdtbd2LXEx2rTNakBKHdhunm3ugEh
         shw/olhiiea+TxjqPn7RQxXcjhCKy1qNk+NmDEqRgmFH1T1tEuBiA7urPu8m8QStxkhS
         7iSv3agNOUoxzbUwn0s/gl24kpNFW7GY0G5zNyb8/rUkX1VfjnMJEjX8bWwU/psRhNEy
         A0yAa8u+sba6IeF3uH6k4TQIigQpD/ekKcA584m/wtIb3wrVhKacC1Ot8F6o7XDA8UR9
         uHxbQWcK4eJtAQt7oz40Y430uk28fcExUwy0FzMrK4Lb+HZEfUz02Lsbo5Gs8bsEpq4j
         59yw==
X-Gm-Message-State: AOJu0Yx0F6GAqYC1NKwPhNH/HWlRJKdTlYbuEyOuSP9kp2kYNX4RDDEr
	y+qQ95rv2BPNm3ydaDC5frq4uWeQljFMM4bENje/u1B9AVLe8NbWDgNwl9JhTDD1gh5Q5pq4IHa
	G/OI+ii+9uH72jGj0qnN4X5D3wdDMkkDMeKwL
X-Gm-Gg: ASbGncs0MZQBP6Sv2svRqo4gJtdLYiQSBSgRQ5fF25oSGKMvZ5WZrja6S6at8fliVtj
	ndCD7w5W0Tqz4Cxdeg4imhvr5kYAn/82/HxyXYJCp5kpXURgzibE+8XYUkK91T36HoUjQ583nJ5
	CGK/2CTCvyI9/rKj5caSZnALxAeQ==
X-Google-Smtp-Source: AGHT+IHJm5eP5IJraAdJ0l6P0p5bxXXWPNTIiR8y/Td3Y7ipBJy3707qicLON2w7/iwRKT9isEWGJ+QrxjhJcHJHUKw=
X-Received: by 2002:a05:622a:1452:b0:466:8887:6751 with SMTP id
 d75a77b69052e-4701ab5f39emr6496161cf.23.1738750042843; Wed, 05 Feb 2025
 02:07:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com> <20250117163001.2326672-7-tabba@google.com>
 <CAGtprH90zc3EWSuyqy4hE7hsmSZSYfB3JBC8KBvc1PdMcw5a4w@mail.gmail.com>
In-Reply-To: <CAGtprH90zc3EWSuyqy4hE7hsmSZSYfB3JBC8KBvc1PdMcw5a4w@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 5 Feb 2025 10:06:45 +0000
X-Gm-Features: AWEUYZmTnCpbaOTYVgyU9KFr2DxYz2vXTf9wZYg7lmcYPkuAFt5b5SD3LUAFzWs
Message-ID: <CA+EHjTxhdQR1FrYXepVRb_Fy7Gk0q_ew+g-t8o1qxdJ63r6sPQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Vishal Annapurve <vannapurve@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vishal,

On Wed, 5 Feb 2025 at 00:42, Vishal Annapurve <vannapurve@google.com> wrote=
:
>
> On Fri, Jan 17, 2025 at 8:30=E2=80=AFAM Fuad Tabba <tabba@google.com> wro=
te:
> >
> > Before transitioning a guest_memfd folio to unshared, thereby
> > disallowing access by the host and allowing the hypervisor to
> > transition its view of the guest page as private, we need to be
> > sure that the host doesn't have any references to the folio.
> >
> > This patch introduces a new type for guest_memfd folios, and uses
> > that to register a callback that informs the guest_memfd
> > subsystem when the last reference is dropped, therefore knowing
> > that the host doesn't have any remaining references.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > The function kvm_slot_gmem_register_callback() isn't used in this
> > series. It will be used later in code that performs unsharing of
> > memory. I have tested it with pKVM, based on downstream code [*].
> > It's included in this RFC since it demonstrates the plan to
> > handle unsharing of private folios.
> >
> > [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guest=
mem-6.13-v5-pkvm
>
> Should the invocation of kvm_slot_gmem_register_callback() happen in
> the same critical block as setting the guest memfd range mappability
> to NONE, otherwise conversion/truncation could race with registration
> of callback?

I don't think it needs to, at least not as far potencial races are
concerned. First because kvm_slot_gmem_register_callback() grabs the
mapping's invalidate_lock as well as the folio lock, and
gmem_clear_mappable() grabs the mapping lock and the folio lock if a
folio has been allocated before.

Second, __gmem_register_callback() checks before returning whether all
references have been dropped, and adjusts the mappability/shareability
if needed.

Cheers,
/fuad

