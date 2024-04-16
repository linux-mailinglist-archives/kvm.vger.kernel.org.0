Return-Path: <kvm+bounces-14816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EE1A8A72CB
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A562CB20C83
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3EC134CD0;
	Tue, 16 Apr 2024 18:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DY8WdXZf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF459134405
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713290879; cv=none; b=M0CQys38S5vHmVAJ23EZJ+1scwik5xgqmaR7viBkyf4Bc3g1UgBeYLG4Oqz+qch52Evkce2lgKEFQerQTjtgEaATMQjCNqcPSc/SW+GBHTILRXT109CvaEXYIO2HLUHaEzslZ6eAyEWSNlRC8nxOutlGiexhxnGZDJfNtheIoJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713290879; c=relaxed/simple;
	bh=wGM6lCQzoCYZYY3/O+5+3ZEB+AdgKhtNzLowYu3zD3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QVJBja5AGLqKtl1AwJMKcf73+d/iA6yRwv0/CFUmkC6kr6b0nYE9E7abXzP7E+hjlajNQNku+a2nOzhvIRmcbe1NT0j8EyDsqKM6ea2OYZRbP6izxhmAUh/HlFQmSyXF9oHASTzNh84noiQoVx1zFVH6wXRK3FomFWAqjbQvvgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DY8WdXZf; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cfd6ba1c11so3722009a12.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713290877; x=1713895677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EZRlfAMdcL/8llTBrUkN/mqlh/eAPDTBgijgp2y5a74=;
        b=DY8WdXZfXElaN9c5ZJG+dKBT0W1et0MBmzN/BCxrEtiD7yQ4WDh+EEGrmYjEd283zr
         BuzcqDI/am7Lm1DgNQIQwYH6XIBlukPsuplgIhuuZdTGyelP5Tn42xesCgCputGGuuZw
         mjmepecZuwX5BOz1mIuD+yYqfRk5GMDJsupEEKPhGhTyPWwtL8lRWiV1noDU6+OUYdLN
         wA0AX9/CtC9wPsxQEOAkazh/WQTZjio+0tAExlfrVB4TK8OwNnmjUuQWRC6fHYGCwfvD
         eK9oCYY1DyXSNTcouwPpH5Ga5BH0zsplFq0e1IrtPm9IgOWly8aRZDSTYTrM6HBiNKqz
         LX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713290877; x=1713895677;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EZRlfAMdcL/8llTBrUkN/mqlh/eAPDTBgijgp2y5a74=;
        b=dI4walDEJs1uUqy//3YA9aE+1mobdKYhycEqUQoUdv5vhLfLV4vj9HpF3kJ2+d5Bkb
         bmSJtmSEw2Qrg9+xW1WZR067Yhfj8h20QUDloVzRBck5pp4NTIR43FuZzGSH7t9EDErI
         6sRFd6cYCJQd2+b9gTzc0//lleZ4pGU7Z8Kbl8IzW7L42AO3Mg9E3cQTAw9Y25jveKoF
         bVc1Ej6xI9bCaSJlVn6cfa9RBUZNIUCoN1gip4w7718REYKRTXAYf7AOptIBKsnEp7sL
         dF6XO0hhFN9qkswjCb72eCZ0szTLKZdZqd2L1PrT2AwtDaTJQvaSNIbi7HQBP4miqlkc
         QmFA==
X-Forwarded-Encrypted: i=1; AJvYcCUcebRMgdme1/oqOEM/p0x2fGkDHLsmlAznP8q+nBuOedFk/Yxbrxkq5XsKnCKd+IvZqBT44KyF1k6rRnDhRJ7MHCob
X-Gm-Message-State: AOJu0YxhMqoeb87A2b61lH3nEVBTigIuahGQb7dvbcRZFspXkdwLsOLV
	/faU7AxV3pWYYeZxv2yTAI0GjXzEvdVLBA5eagbg7dGt9O+ueCdjLAxBmBo2vyzyjLX0LV0sZkh
	kcA==
X-Google-Smtp-Source: AGHT+IHspMH6UcamKUetOGwUjxZE46EOL80IDIP3kgY2zAIH6BaR2jBx+NGr0u8CL+PNqFSKn7LkRros7Ek=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e00f:b0:2a2:8f19:f484 with SMTP id
 u15-20020a17090ae00f00b002a28f19f484mr42733pjy.3.1713290877079; Tue, 16 Apr
 2024 11:07:57 -0700 (PDT)
Date: Tue, 16 Apr 2024 11:07:55 -0700
In-Reply-To: <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
 <Zh6MmgOqvFPuWzD9@google.com> <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
 <Zh6WlOB8CS-By3DQ@google.com> <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
Message-ID: <Zh6-e9hy7U6DD2QM@google.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
From: Sean Christopherson <seanjc@google.com>
To: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024, Thomas Prescher wrote:
> On Tue, 2024-04-16 at 08:17 -0700, Sean Christopherson wrote:
> > On Tue, Apr 16, 2024, Thomas Prescher wrote:
> > > Hi Sean,
> > >=20
> > > On Tue, 2024-04-16 at 07:35 -0700, Sean Christopherson wrote:
> > > > On Tue, Apr 16, 2024, Julian Stecklina wrote:
> > > > > From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
> > > > >=20
> > > > > This issue occurs when the kernel is interrupted by a signal whil=
e
> > > > > running a L2 guest. If the signal is meant to be delivered to the=
 L0
> > > > > VMM, and L0 updates CR4 for L1, i.e. when the VMM sets
> > > > > KVM_SYNC_X86_SREGS in kvm_run->kvm_dirty_regs, the kernel program=
s an
> > > > > incorrect read shadow value for L2's CR4.
> > > > >=20
> > > > > The result is that the guest can read a value for CR4 where bits =
from
> > > > > L1 have leaked into L2.
> > > >=20
> > > > No, this is a userspace bug.=C2=A0 If L2 is active when userspace s=
tuffs
> > > > register state, then from KVM's perspective the incoming value is L=
2's
> > > > value.=C2=A0 E.g.=C2=A0 if userspace *wants* to update L2 CR4 for w=
hatever
> > > > reason, this patch would result in L2 getting a stale value, i.e. t=
he
> > > > value of CR4 at the time of VM-Enter.
> > > >=20
> > > > And even if userspace wants to change L1, this patch is wrong, as K=
VM
> > > > is writing vmcs02.GUEST_CR4, i.e. is clobbering the L2 CR4 that was
> > > > programmed by L1, *and* is dropping the CR4 value that userspace wa=
nted
> > > > to stuff for L1.
> > > >=20
> > > > To fix this, your userspace needs to either wait until L2 isn't act=
ive,
> > > > or force the vCPU out of L2 (which isn't easy, but it's doable if
> > > > absolutely necessary).
> > >=20
> > > What you say makes sense. Is there any way for
> > > userspace to detect whether L2 is currently active after
> > > returning from KVM_RUN? I couldn't find anything in the official
> > > documentation https://docs.kernel.org/virt/kvm/api.html
> > >=20
> > > Can you point me into the right direction?
> >=20
> > Hmm, the only way to query that information is via KVM_GET_NESTED_STATE=
,
> > which is a bit unfortunate as that is a fairly "heavy" ioctl().

Hur dur, I forgot that KVM provides a "guest_mode" stat.  Userspace can do
KVM_GET_STATS_FD on the vCPU FD to get a file handle to the binary stats, a=
nd
then you wouldn't need to call back into KVM just to query guest_mode.

Ah, and I also forgot that we have kvm_run.flags, so adding KVM_RUN_X86_GUE=
ST_MODE
would also be trivial (I almost suggested it earlier, but didn't want to ad=
d a
new field to kvm_run without a very good reason).

> Indeed. What still does not make sense to me is that userspace should be =
able
> to modify the L2 state. From what I can see, even in this scenario, L0 ex=
its
> with the L1 state.

No, KVM exits with L2.  Or at least, KVM is supposed to exit with L2 state.=
  Exiting
with L1 state would actually be quite difficult, as KVM would need to manua=
lly
switch to vmcs01, pull out state, and then switch back to vmcs02.  And for =
GPRs,
KVM doesn't have L1 state because most GPRs are "volatile", i.e. are clobbe=
red by
VM-Enter and thus need to be manually managed by the hypervisor.

I assume you're using kvm_run.kvm_valid_regs to instruct KVM to save vCPU s=
tate
when exiting to userspace?  That path grabs state straight from the vCPU, w=
ithout
regard to is_guest_mode().  If you're seeing L1 state, then there's likely =
a bug
somewhere, likely in userspace again.   While valid_regs kvm_run.kvm_valid_=
regs
might not be heavily used, the underlying code is very heavily used for doi=
ng
save/restore while L2 is active, e.g. for live migration.

> So what you are saying is that userspace should be allowed to change L2 e=
ven
> if it receives the architectural state from L1?

No, see above.

> What would be the use-case for this scenario?
>=20
> If the above is true, I think we should document this explicitly
> because it's not obvious, at least not for me ;)
>=20
> How would you feel if we extend struct kvm_run with a
> nested_guest_active flag? This should be fairly cheap and would make
> the integration into VirtualBox/KVM much easier. We could also only
> sync this flag explicitly, e.g. with a KVM_SYNC_X86_NESTED_GUEST?

Heh, see above regarding KVM_RUN_X86_GUEST_MODE.

