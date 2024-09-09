Return-Path: <kvm+bounces-26158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B53972444
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BAB91C22FF7
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 21:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523A318C036;
	Mon,  9 Sep 2024 21:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T24Ixpgx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E7018C00E
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 21:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725916317; cv=none; b=SoiTHGeCT2tdgBADTQ5rYAFrAyM5stYswA3HtphUDUNTTKMbjil4pei5bnmw5MWVKTfw7d38d9ImoZZ8kAnSvSP5dVU3jMsDmMfz0mRoyFWFf/wHSOuQ3acSsWDznOtQVGeQqv1l2Ig3ZUve1nCT26HCKRRfQb/GaeMytcu8zI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725916317; c=relaxed/simple;
	bh=WPjhjXw2i3ADOwvPMY616fJ0MEFvnnPuvKo/gX5cbu8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B6EtPhNpCugtOyvgVjBc0PocIxop2S0UPQjyp0mb9RQod8VU6AWOlUKBT5+1D2ltAoY7lB+xqXj0P1oOWt7SCqc04cCUPp43D5MZhFRIvM4Sz97vvJoyATNRHAGMhF9TJmlZum7+5d9W9rMC+ys0dW7xft4PWf2CD9je+4pBqoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T24Ixpgx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d8b7c662ccso186a91.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 14:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725916315; x=1726521115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d6b34m8WsPSJ4ekRqhLLXv69ERzykEYpuolvxg7g6LM=;
        b=T24IxpgxOzP/QNER+4+gjAJTdmlRR6uBkScfpDGC7ZAt+7LIRxqetIGnI9P2bt8dj+
         S1cWeK8PTzwxchJ6rLm4gCn2FMbzh5H4ScOtPYYAerPd6WYjFziiKk9Mq3vQXVVdy18P
         CdAF9uiqT+Ba+GFbI3fzu8CWtluooWCsi8KdLLg+xtY5DnQi3YEr5Pa6cDa2UXB9GGog
         sIqB0wBJMqOn1HN1YP8p4AkCLpWrwpDho4Gfjqx1haompEMqfyxNYdJxPiDs2RKGJMS/
         6NiS4DfHA8y20/9gHh5dMvaRBkbHxJP3+Q7KZlPKgq2esQCpZzmqUdoq99Rf79Pux2ab
         AG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725916315; x=1726521115;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d6b34m8WsPSJ4ekRqhLLXv69ERzykEYpuolvxg7g6LM=;
        b=Ige3M+eD9v9uJ4biPssiBrIUYxQnCz/69eKQG2pHUM5x5Z/L0x/QsQZtUaQYfABVFV
         nRWSeg3/bHqLZd1oz142RN8yuFhEVYRdeua8KobKrbC6EmqCtslhYMQQlwX3WjDp9yza
         UHsn7G2QbNVt1IhXI5vbU15VXSgvvEowAmqgtO6XfIxI51zbJDd0bhbYChujaDUUfrFa
         5eH8Hf3iV2wwPtJJy/9rGTPTrA2StLu0wDHM5Id0FvKuo2qQwIfC74lqKcvO9NzDEbvs
         Z+B1HPLv6mcuy00kgB6DxwamYpYCGgWtVQXaWefLex+ajzzCSKgBKmalDWg4E7wTZdpk
         4opw==
X-Gm-Message-State: AOJu0YwVMHcwGt/xalegowwdXSrB0bczyz8yLHGo5UOkvoe0XflGmpR5
	Rb06D+Ekt/0hrVXZNMKQwxxoQZnn1tzou+goy9n2G9FkzD19QjVkTUysvGaWm0q655ghmeSFiAA
	Trw==
X-Google-Smtp-Source: AGHT+IGNURKCQYhJ/Zvei6SYlzyyylDjzeeVTddzmeqAfxmnmG4PFtU5DuvbIKtN4jmXsVwJjhSSo1vpbqI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:55c4:b0:2d8:bf47:947c with SMTP id
 98e67ed59e1d1-2dad517760dmr47559a91.3.1725916315112; Mon, 09 Sep 2024
 14:11:55 -0700 (PDT)
Date: Mon, 9 Sep 2024 14:11:53 -0700
In-Reply-To: <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com> <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
Message-ID: <Zt9kmVe1nkjVjoEg@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Yuan Yao <yuan.yao@intel.com>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	Kai Huang <kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-09-09 at 17:25 +0200, Paolo Bonzini wrote:
> > On 9/4/24 05:07, Rick Edgecombe wrote:
> > > +static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *=
in)
> > > +{
> > > +#define SEAMCALL_RETRY_MAX=C2=A0=C2=A0=C2=A0=C2=A0 16
> >=20
> > How is the 16 determined?=C2=A0 Also, is the lock per-VM or global?
>=20
> The lock being considered here is per-TD, but TDX_OPERAND_BUSY in general=
 can be
> for other locks. I'm not sure where the 16 came from, maybe Yuan or Isaku=
 can
> share the history. In any case, there seems to be some problems with this=
 patch
> or justification.
>=20
> Regarding the zero-step mitigation, the TDX Module has a mitigation for a=
n
> attack where a malicious VMM causes repeated private EPT violations for t=
he same
> GPA. When this happens TDH.VP.ENTER will fail to enter the guest. Regardl=
ess of
> zero-step detection, these SEPT related SEAMCALLs will exit with the chec=
ked
> error code if they contend the mentioned lock. If there was some other (n=
on-
> zero-step related) contention for this lock and KVM tries to re-enter the=
 TD too
> many times without resolving an EPT violation, it might inadvertently tri=
gger
> the zero-step mitigation.=C2=A0I *think* this patch is trying to say not =
to worry
> about this case, and do a simple retry loop instead to handle the content=
ion.
>=20
> But why 16 retries would be sufficient, I can't find a reason for. Gettin=
g this
> required retry logic right is important because some failures
> (TDH.MEM.RANGE.BLOCK) can lead to KVM_BUG_ON()s.

I (somewhat indirectly) raised this as an issue in v11, and at a (very quic=
k)
glance, nothing has changed to alleviate my concerns.

In general, I am _very_ opposed to blindly retrying an SEPT SEAMCALL, ever.=
  For
its operations, I'm pretty sure the only sane approach is for KVM to ensure=
 there
will be no contention.  And if the TDX module's single-step protection spur=
iously
kicks in, KVM exits to userspace.  If the TDX module can't/doesn't/won't co=
mmunicate
that it's mitigating single-step, e.g. so that KVM can forward the informat=
ion
to userspace, then that's a TDX module problem to solve.

> Per the docs, in general the VMM is supposed to retry SEAMCALLs that retu=
rn
> TDX_OPERAND_BUSY.

IMO, that's terrible advice.  SGX has similar behavior, where the xucode "m=
odule"
signals #GP if there's a conflict.  #GP is obviously far, far worse as it l=
acks
the precision that would help software understand exactly what went wrong, =
but I
think one of the better decisions we made with the SGX driver was to have a
"zero tolerance" policy where the driver would _never_ retry due to a poten=
tial
resource conflict, i.e. that any conflict in the module would be treated as=
 a
kernel bug.

> I think we need to revisit the general question of which
> SEAMCALLs we should be retrying and how many times/how long. The other
> consideration is that KVM already has per-VM locking, that would prevent
> contention for some of the locks. So depending on internal details KVM ma=
y not
> need to do any retries in some cases.

Yes, and if KVM can't avoid conflict/retry, then before we go any further, =
I want
to know exactly why that is the case.

