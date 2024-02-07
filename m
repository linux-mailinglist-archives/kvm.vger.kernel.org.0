Return-Path: <kvm+bounces-8186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 492C384C297
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 03:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00ECD285DA9
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3FAF9EF;
	Wed,  7 Feb 2024 02:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="grFK2SFK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F070F10961
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 02:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707273822; cv=none; b=uTNUhxeZIekX8KaOoOz57+tS7ghLQ1OIv76tWt6LFDwZM6RFqxANv9K1PPzbGKg7ykvOR2IDk3MBbTru8xi06krXtyys0FfECX138WC/iWmRpAUSephRO4dvX7hHS30HaQfIbacJUWjCuOadyOGN05KRNcH9hmZ5eKys8C9Qi7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707273822; c=relaxed/simple;
	bh=yAc2qDg86yKSHh+BWfG2RTtPpu6Cksg1ErI8pCgZ7jE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qsz5mdFEdNH7pUxh53+O4HeUfN2TrZeefGe8BWvWtaTzbIXjNa/FeJL7YZpqIE0p5VBVCcQ0mQluE9fl9KVxSqFSG09/7b0hArFxv5SuFQ7cvPbB0+Dkc9KiJtH2Dju8WxtfvYm/ZHovHk2F5R1JU3Ionoskpi5EA42tqsIbDao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=grFK2SFK; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6ceade361so256900276.0
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 18:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707273820; x=1707878620; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g7guOO3K6cZeccVPYodTSSR3CLbTuFzc0JepOhwBqf8=;
        b=grFK2SFKZqLTXSDLVLI4bcvE0N08jdaLe1SI3FOpqQ0ljetYoTLDld5EdWLBmT/LbW
         0eINMxXXSg3F9w4BlsaXm7IRfS6/gBFePOjaGmLOOBk8K2dgvImHNZoihGK05rhzS9EM
         sd2OSZ6Fwd372IpKtvHh44VzMFVSoIqQuLQKtLJ+4oHPMwBnmPAU2x8m49+RFnt3lMb8
         QibJ+olqqhcCADpriEKFktx1v0WeIG7zqS7K0juyRfpMBGPWadCBeuB/b2QlrQRFTBUU
         V/d1UhftHn1nmFNSyhSn7AQbvrW3HF+5wmzWYsyPhg3QmSSeBRM2nHzZ2byyjFMNfceA
         Ccqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707273820; x=1707878620;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g7guOO3K6cZeccVPYodTSSR3CLbTuFzc0JepOhwBqf8=;
        b=vAyvnpoOJUIl6ZjUc/XGFxqyfKo/pe+BDYmRtbummkU8841sjDAQ4eUcVFo6y0ucQ7
         I7oUnueq8u9AHmJU+TqghAKbvXp8iqJD2+6hjbfdDOK6iPxKn1N9Gv+EHlQJx6sH2u+r
         mfWK0N0H7f96OjEjKpmZJWQKTvkGe3V7kAfrQNhPjL/SculTieFmoyVDXwZIh7eJzqKl
         XVj5wvqj8d+uXLSaYbDJ0DLjrMsNCWoHTWUTM1tqDY2NnI/rGQKDHMFwwcFxm5vDShTk
         9KXcYOzsyIDg5f9eACWECfXOMWfATu+bnBsS/lvaH0fJ7oWd5Y11y5bcwiiNBVxE7wd8
         Yxng==
X-Gm-Message-State: AOJu0YzXdWgakOFRXyzRrr5uQYxFuAmvQeMS7c+WoZN6LbMJFMooYrpB
	19/Wdx5cflhtNWOZs71X/BOIDSG9FkyTjBlXVixh0Zc5uBQl+EjJcfMUD2GeCLXMW9kEtYGJwOz
	f3Q==
X-Google-Smtp-Source: AGHT+IHFKn95FP8tDKGyeHSLkuyZnMtdrnlqEFcDN45UncE4QphOeyXOIkcKI10ZFatjnFxEnz3hwTc5JAw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2485:b0:dc2:550b:a4f4 with SMTP id
 ds5-20020a056902248500b00dc2550ba4f4mr906756ybb.1.1707273820039; Tue, 06 Feb
 2024 18:43:40 -0800 (PST)
Date: Tue, 6 Feb 2024 18:43:38 -0800
In-Reply-To: <CABgObfa_PbxXdj9v7=2ZXfqQ_tJgdQTrO9NHKOQ691TSKQDY2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-19-michael.roth@amd.com>
 <ZZ67oJwzAsSvui5U@google.com> <20240116041457.wver7acnwthjaflr@amd.com>
 <Zb1yv67h6gkYqqv9@google.com> <CABgObfa_PbxXdj9v7=2ZXfqQ_tJgdQTrO9NHKOQ691TSKQDY2A@mail.gmail.com>
Message-ID: <ZcLuGxZ-w4fPmFxd@google.com>
Subject: Re: [PATCH v11 18/35] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 07, 2024, Paolo Bonzini wrote:
> On Fri, Feb 2, 2024 at 11:55=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > It doesn't really matter if the attributes are set before or after
> > > KVM_SNP_LAUNCH_UPDATE, only that by the time the guest actually launc=
hes
> > > they pages get set to private so they get faulted in from gmem. We co=
uld
> > > document our expectations and enforce them here if that's preferable
> > > however. Maybe requiring KVM_SET_MEMORY_ATTRIBUTES(private) in advanc=
e
> > > would make it easier to enforce that userspace does the right thing.
> > > I'll see how that looks if there are no objections.
> >
> > Userspace owns whether a page is PRIVATE or SHARED, full stop.  If KVM =
can't
> > honor that, then we need to come up with better uAPI.
>=20
> Can you explain more verbosely what you mean?

As proposed, snp_launch_update_gfn_handler() doesn't verify the state of th=
e
gfns' attributes.  But that's a minor problem and probably not a sticking p=
oint.

My overarching complaint is that the code is to be wildly unsafe, or at the=
 very
least brittle.  Without guest_memfd's knowledge, and without holding any lo=
cks
beyond kvm->lock, it=20

 1) checks if a pfn is shared in the RMP
 2) copies data to the page
 3) converts the page to private in the RMP
 4) does PSP stuff
 5) on failure, converts the page back to shared in RMP
 6) conditionally on failure, writes to the page via a gfn

I'm not at all confident that 1-4 isn't riddled with TOCTOU bugs, and that'=
s
before KVM gains support for intrahost migration, i.e. before KVM allows mu=
ltiple
VM instances to bind to a single guest_memfd.

But I _think_ we mostly sorted this out at PUCK.  IIRC, the plan is to have=
 guest_memfd
provide (kernel) APIs to allow arch/vendor code to initialize a guest_memfd=
 range.
That will give guest_memfd complete control over the state of a given page,=
 will
allow guest_memfd to take the appropriate locks, and if we're lucky, will b=
e reusable
by other CoCo flavors beyond SNP.

> > > > > +                  * When invalid CPUID function entries are dete=
cted, the firmware
> > > > > +                  * corrects these entries for debugging purpose=
 and leaves the
> > > > > +                  * page unencrypted so it can be provided users=
 for debugging
> > > > > +                  * and error-reporting.
> > > >
> > > > Why?  IIUC, this is basically backdooring reads/writes into guest_m=
emfd to avoid
> > > > having to add proper mmap() support.
> >
> > Yes, I am specifically complaining about writing guest memory on failur=
e, which is
> > all kinds of weird.
>=20
> It is weird but I am not sure if you are complaining about firmware
> behavior or something else.

This proposed KVM code:

+                               host_rmp_make_shared(pfns[i], PG_LEVEL_4K, =
true);
+
+                               ret =3D kvm_write_guest_page(kvm, gfn, kvad=
dr, 0, PAGE_SIZE);
+                               if (ret)
+                                       pr_err("Failed to write CPUID page =
back to userspace, ret: 0x%x\n",
+                                              ret);


I have no objection to propagating error/debug information back to userspac=
e,
but it needs to be routed through the source page (or I suppose some dedica=
ted
error page, but that seems like overkill).  Shoving the error information i=
nto
guest memory is gross.

But this should naturally go away when the requirement that the source be
covered by the same memslot also goes away.

