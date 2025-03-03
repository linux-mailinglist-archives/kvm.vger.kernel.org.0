Return-Path: <kvm+bounces-39918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E421A4CB6B
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 19:55:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A08B1897825
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAE52356AE;
	Mon,  3 Mar 2025 18:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1sDF35VW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7525B22DFAF
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 18:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741028018; cv=none; b=WbC2/YdmWdsw+mfyW6Oxf8ec0Nk2J+ACMPpVHl7UJSrP6jJ8r9Re5e0W1oLambAe4Xn/F3+PGniIDhl6n2hZXbFRbH7s+5ylqSWeYwGQts4HIsJC2oFCyWlG06CDjkvteAYJ5J7EyJPGRwlOUBTC7uRaQukQbQ3tHQglDD+bvrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741028018; c=relaxed/simple;
	bh=eyW4uvAiKZw6iNEDEnhVcsa7Mr/hVjNJlE3N7IMkQe0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vi1y91xZf6/YpPtezBoseyKuxzqp/4MNrgQJ2GxO2bKmMMDcKka/6ZmOu4lMq0tXojIhDzzTxeM3W/A1ibN+WfMm1kz3ptI+rl+exSuVu1xv+nM4CyuOI0xAAc7v4mSXQnapifAxL6n+SKlfPM50NREA3sCqthO+qT4F8A7SYTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1sDF35VW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22356964533so67309285ad.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 10:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741028015; x=1741632815; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6r9/NFesFUoIvHadBrGFJSc8h4PL3K25ceD37Tn3zwo=;
        b=1sDF35VWjjOhCMn2db6tJGNhJLGAQj+teW4yazDnHpTs27dntJvakz9FqtqvV/P/jH
         ArzCl6osFI7YbiIn0nAtjNwj60a44yvQY2ep9XnCUvMf6uyitQubo3SrkURljaE/o0z3
         UFgItotiQUXkzUgpfF0tQu7hAwwP4silF6+xCZV+Rv2PC+MeRiz4zvYIorV5vmpe+ckg
         2cYT63RfM0aM7M9cScI9Rj+j9+aej5j1n+aTkdlxOal0AZhVDzFi5ipymk24enej07NG
         j6VFW2pHykeF4tDAfdpVGTMXtkWFL0S5/w9soqkhDi+AHbei21m13wPGpaLlPQGla5mv
         0YCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741028015; x=1741632815;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6r9/NFesFUoIvHadBrGFJSc8h4PL3K25ceD37Tn3zwo=;
        b=i2fjbuicdwSqvpCWNzPHdNRlgLB1PIlJ2zrRmMGbbl11l5iL6GoXB35Biinuy7IdSq
         gGZDMdy4wQOdFyvt/2Gcf1bUUTMD0nHvOpXC9rDuTyaQKVuTRE5BGVH+5xdsUVCnBwPv
         2CliIFOkYbkJ42N/GOCIXvWlMUGQIwUa533DI+6Lc+uQR+yXTKgVTc0JE5bkfkAJnAJu
         Tp+f3v+sWW+5+g4lydUvkO1AIg2CavMKvvJPdLwmBd3nldxo0DRHgKAILOcKkHZi+sAF
         PATFeSjG3V1RgYDNI2ucPEz5BtgI5irJbXm/0bpT0cK3EW7H6BkMquSZNp7ekrxPa7UL
         BKoA==
X-Forwarded-Encrypted: i=1; AJvYcCWKGUdTrgGOlvFbYV8L4d4WssVumOq4mwxwJ+eNtro+F6HsEeQ/s/lSEhmFHrYkMD9qyQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj6booWdibb/JJxOAzgsmqSR5oix085failnjb+c0SwUHUj3EJ
	QohFeCFTo3cRoYPD0UOdwT61g6ZZ3eYThYxJP+dA8ODQoaoRcwmg7p1tO7DS4AJvo1g7HmfMvf1
	XlA==
X-Google-Smtp-Source: AGHT+IGWjx3WHsPRnBz65sq3hR/Pz6bpJVGezrEQ1CdrZWFRxr60xiXoBSKFm6ZFcrNN6JHU7+cWkAXveL8=
X-Received: from pfbhm10.prod.google.com ([2002:a05:6a00:670a:b0:736:38eb:5869])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b95:b0:736:53ef:a04e
 with SMTP id d2e1a72fcca58-73653efa732mr6458527b3a.22.1741028015671; Mon, 03
 Mar 2025 10:53:35 -0800 (PST)
Date: Mon, 3 Mar 2025 10:53:34 -0800
In-Reply-To: <CALMp9eSGRLMj-a_ZrzzeLx_jgAea13-to=ZPHu3F+trQq28YjA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-2-yosry.ahmed@linux.dev> <Z8JOvMx6iLexT3pK@google.com>
 <CALMp9eSGRLMj-a_ZrzzeLx_jgAea13-to=ZPHu3F+trQq28YjA@mail.gmail.com>
Message-ID: <Z8X6rtIwlTtu5rHx@google.com>
Subject: Re: [RFC PATCH 01/13] KVM: nSVM: Track the ASID per-VMCB
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2025, Jim Mattson wrote:
> On Fri, Feb 28, 2025 at 4:03=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > +Jim, for his input on VPIDs.
> >
> > On Wed, Feb 05, 2025, Yosry Ahmed wrote:
> > > The ASID is currently tracked per-vCPU, because the same ASID is used=
 by
> > > L1 and L2. That ASID is flushed on every transition between L1 and L2=
.
> > >
> > > Track the ASID separately for each VMCB (similar to the
> > > asid_generation), giving L2 a separate ASID. This is in preparation f=
or
> > > doing fine-grained TLB flushes on nested transitions instead of
> > > unconditional full flushes.
> >
> > After having some time to think about this, rather than track ASIDs per=
 VMCB, I
> > think we should converge on a single approach for nVMX (VPID) and nSVM =
(ASID).
> >
> > Per **VM**, one VPID/ASID for L1, and one VPID/ASID for L2.
>=20
> When using EPT on VMX, there is probably no advantage to using one
> VPID per VM. The physical ASID is determined by <EPTRTA, VPID, PCID>.
> Two different VMs are not going to share an EPTRTA, so they already
> have different ASIDs, even if they have the same VPID.

For posterity, which the SDM says this:

  Linear mappings may be created. They are derived from the paging structur=
es
  referenced (directly or indirectly) by the current value of CR3 and are a=
ssociated
  with the current VPID and the current PCID.

it explicitly disallows creating or using linear mappings when EPT is enabl=
ed:

  No linear mappings are created while EPT is in use.

  no linear mappings are used while EPT is in use.

I think it's still worth assigning a unique VPID though, e.g. it would prov=
ide
some amount of defense in depth.  I.e. two different VMs *shouldn't* share =
an
EPTRTA :-)

> > For SVM, the dynamic ASID crud is a holdover from KVM's support for CPU=
s that
> > don't support FLUSHBYASID, i.e. needed to purge the entire TLB in order=
 to flush
> > guest mappings.  FLUSHBYASID was added in 2010, and AFAIK has been supp=
orted by
> > all AMD CPUs since.
>=20
> > KVM already mostly keeps the same ASID, except for when a vCPU is migra=
ted, in
> > which case KVM assigns a new ASID.  I suspect that following VMX's lead=
 and
> > simply doing a TLB flush in this situation would be an improvement for =
modern
> > CPUs, as it would flush the entries that need to be flushed, and not po=
llute the
> > TLBs with stale, unused entries.
> >
> > Using a static per-VM ASID would also allow using broadcast invalidatio=
ns[*],
> > would simplify the SVM code base, and I think/hope would allow us to mo=
ve much
> > of the TLB flushing logic, e.g. for task migration, to common code.
> >
> > For VPIDs, maybe it's because it's Friday afternoon, but for the life o=
f me I
> > can't think of any reason why KVM needs to assign VPIDs per vCPU.  Espe=
cially
> > since KVM is ridiculously conservative and flushes _all_ EPT/VPID conte=
xts when
> > running a different vCPU on a pCPU (which I suspect we can trim down?).
> >
> > Am I forgetting something?
>=20
> TDX? IIRC, TDX requires a unique VPID for each vCPU in a VM.

Ha!  Nope, the TDX module actually does what I'm suggesting, and uses a per=
-VM
VPID.  So if I'm forgetting some TLB edge case, TDX is already hosed.

FWIW, the hypervisor, i.e. KVM, has no control over the VPID used by the TD=
X
module.  Intel incorporated SEAM mode into the ASID tag to prevent TLB coll=
isions
between the hypervisor and the TDX module, and that also conveniently provi=
des
separation between VPIDs for non-TDX VMs and TDX VMs (and now I'm curious i=
f TDX
enabling does the "right" thing and skips VPID allocation).

FWIW, TDX's scheme would match what I'm proposing almost exactly.  TDX "com=
poses"
the VPID using the HKID (guaranteed unique per VM) and then a "VM identifie=
r",
which at a glance differentiates L1 from L2.

> > [*] https://lore.kernel.org/all/Z8HdBg3wj8M7a4ts@google.com

