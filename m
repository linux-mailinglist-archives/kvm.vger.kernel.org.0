Return-Path: <kvm+bounces-11738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E58187A978
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:31:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FA7B1C215A8
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70F93FE4;
	Wed, 13 Mar 2024 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gKtYST/C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5248810E5
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710340312; cv=none; b=aftwtAWKggZIxs8nH6W8pNyh8yQ5Ow9H578ZeXYN8xJPpRv74qcRBQcEe1bDcXWp8MhrGgEWJjZPxgmNlQOfu5w5mvevJA6LSUeOpZWL/KNhdnbKgUwAe3VITYq/txtH8ovb0AI9IfiJRdPiymvp3W8Gnq1IYxC8g7A7UmpUi7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710340312; c=relaxed/simple;
	bh=5X2q3T6qpEoOaoWxBZb2w87U1+RAiVCgAedZT1vA3CU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bpsODmdlFZwV1l7ZLJNi6Dn2IMzPKfWOZV+xbChsilwMwamUm73Bpv+PRc2nfVsXKz38qn/OActB96V1qHFMxQ13Ma09Is/qQxpVS4rvS8jgrRImmkMG2V0rzEofIDIRUaZ54JTvt0DQ4n20+21q4WzFut6Do/4wFWhW0S/9z6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gKtYST/C; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc64f63d768so11732164276.2
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 07:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710340310; x=1710945110; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=skkwvusUZTlc3kcrYzW7f5YS6kbCmcLSfC5JgvSV7TY=;
        b=gKtYST/CZMLiMY6dPNq3YDPNJf57w/MIfr2yOIz++7oH53z07EXEa6FZb4CJ3H0l2q
         tco/h2CgAghm6DXP9IXgyC0nddTX2qIxd/U2HbXkWFAc4sNoFtZboZsQIQr75kG8TkO1
         AIfKbsN/5EiB4uES67HTse4MC4vLNCKRrBIHRLwqj3wAOU4A73bDA2lZLsSU9m0aEAsX
         OO/jMuJcok9zUYLUe8lgrr25ve2dDaEHBVdCKrOi9JeauQtscNKJsP4aApo+G/svYfJB
         zmI98ZQZQixqo9AeNQN3W+0BWlutrWDWxix8IWzqKA2ziVHvs77XYG+DVqRmcBDyGXAq
         S5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710340310; x=1710945110;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=skkwvusUZTlc3kcrYzW7f5YS6kbCmcLSfC5JgvSV7TY=;
        b=rol4Zkwn+8neHM9wg7KPCCPAwat0kd0hHrA8xEVVZvZSimioBnka4ZMS0fCirH/QCu
         Nep2zilq6P5j3oF+SmskIdpTISjE9MwlxbzEuFImUP/isBvxg1OcDivhFhosBQ4CRUBZ
         3IwYlA44uydRZLejqn3i0nf+fwmFFp8zU/dJGzu8Z1/QdCLyqqdTOnpbSL1FkjiBZmOh
         zuMUF3fLZfrdIANc6S0WseHE4tTRwUjAlU2DHURzE6pVXGz4GNqPZaGzSoi3hL+pWOyn
         xFiTFcrALb9IBD7T6m6utfQ1rlZ1keX55ifFoOivxnBOt8kJv8EGmy0rlwETMrwOxY4+
         +WXA==
X-Forwarded-Encrypted: i=1; AJvYcCW7fhpwgoXYZd+X6LHeQyUvPyAZf1IGSgrV6XZuhcN1Ttr0Wtnn68s7npwDf6aYNQWSVtA4tOJFNSz5x3FF2sD9ylW/
X-Gm-Message-State: AOJu0YxFFYikq+MR7C+pcOeCPQ150YhdgZW5YvhpVnNAQzky4tzy+10G
	QW33/QqpXe/8aaPVQcILKWZ6+dZ8sC9xUvCveFgFOS1u4PkIcT6eZQ+dKJyjLZ5eB5/jcBl8t1B
	qyg==
X-Google-Smtp-Source: AGHT+IHw91Ii2NgfaS0wASwLXg97aIQ6t1WAdgTXfGINEMewRUiTFbqpXGalstGt6a2jwEq4zPrExqd0m6k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1026:b0:dc6:dfd9:d431 with SMTP id
 x6-20020a056902102600b00dc6dfd9d431mr654348ybt.1.1710340310350; Wed, 13 Mar
 2024 07:31:50 -0700 (PDT)
Date: Wed, 13 Mar 2024 07:31:48 -0700
In-Reply-To: <CALzav=cSzbZXhasD7iAtB4u0xO-iQ+vMPiDeXXz5mYMfjOfwaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307194255.1367442-1-dmatlack@google.com> <ZepBlYLPSuhISTTc@google.com>
 <ZepNYLTPghJPYCtA@google.com> <CALzav=cSzbZXhasD7iAtB4u0xO-iQ+vMPiDeXXz5mYMfjOfwaw@mail.gmail.com>
Message-ID: <ZfG41PbWqXXf6CF-@google.com>
Subject: Re: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on x86_64
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Michael Roth <michael.roth@amd.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 07, 2024, David Matlack wrote:
> On Thu, Mar 7, 2024 at 3:27=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
> >
> > On 2024-03-07 02:37 PM, Sean Christopherson wrote:
> > > On Thu, Mar 07, 2024, David Matlack wrote:
> > > > Create memslot 0 at 0x100000000 (4GiB) to avoid it overlapping with
> > > > KVM's private memslot for the APIC-access page.
> > >
> > > This is going to cause other problems, e.g. from max_guest_memory_tes=
t.c
> > >
> > >       /*
> > >        * Skip the first 4gb and slot0.  slot0 maps <1gb and is used t=
o back
> > >        * the guest's code, stack, and page tables.  Because selftests=
 creates
> > >        * an IRQCHIP, a.k.a. a local APIC, KVM creates an internal mem=
slot
> > >        * just below the 4gb boundary.  This test could create memory =
at
> > >        * 1gb-3gb,but it's simpler to skip straight to 4gb.
> > >        */
> > >       const uint64_t start_gpa =3D SZ_4G;
> > >
> > > Trying to move away from starting at '0' is going to be problematic/a=
nnoying,
> > > e.g. using low memory allows tests to safely assume 4GiB+ is always a=
vailable.
> > > And I'd prefer not to make the infrastucture all twisty and weird for=
 all tests
> > > just because memstress tests want to play with huge amounts of memory=
.
> > >
> > > Any chance we can solve this by using huge pages in the guest, and ad=
justing the
> > > gorilla math in vm_nr_pages_required() accordingly?  There's really n=
o reason to
> > > use 4KiB pages for a VM with 256GiB of memory.  That'd also be more r=
epresantitive
> > > of real world workloads (at least, I hope real world workloads are us=
ing 2MiB or
> > > 1GiB pages in this case).
> >
> > There are real world workloads that use TiB of RAM with 4KiB mappings
> > (looking at you SAP HANA).
> >
> > What about giving tests an explicit "start" GPA they can use? That woul=
d
> > fix max_guest_memory_test and avoid tests making assumptions about 4GiB
> > being a magically safe address to use.
> >
> > e.g. Something like this on top:
>=20
> Gah, I missed nx_huge_page_test.c, which needs similar changes to
> max_memory_test.c.
>=20
> Also if you prefer the "start" address be a compile time constant we
> can pick an arbitrary number above 4GiB and use that (e.g. start=3D32GiB
> would be more than enough for a 12TiB guest).

Aha!  Idea.  I think we can clean up multiple warts at once.

The underlying problem is the memory that is allocated for guest page table=
s.
The core code allocation is constant for any given test, and a complete non=
-issue
unless someone writes a *really* crazy test.  And while core data (stack) a=
llocations
scale with the number of vCPUs, they are (a) articifically bounded by the m=
aximum
number of vCPUs and (b) relatively small allocations (a few pages per vCPU)=
.

And for page table allocations, we already have this absurd magic value:

  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000

which I'm guessing exists to avoid clobbering code+stack allocations, but t=
hat's
an irrelevant tangent.

The other asset we now have is vm->memslots[NR_MEM_REGIONS], and more speci=
fically
allocations for guest page tables are done via vm->memslots[MEM_REGION_PT].

So, rather than more hardcoded addresses and/or a knob to control _all_ cod=
e
allocations, I think we should provide knob to say that MEM_REGION_PT shoul=
d go
to memory above 4GiB.  And to make memslot handling maintainable in the lon=
g term:

  1. Add a knob to place MEM_REGION_PT at 4GiB (and as of this initial patc=
h,
     conditionally in their own memslot).

  2. Use the PT_AT_4GIB (not the real name) knob for the various memstress =
tests
     that need it.

  3. Formalize memslots 0..2 (CODE, DATA, and PT) as being owned by the lib=
rary,
     with memslots 3..MAX available for test usage.

  4. Modify tests that assume memslots 1..MAX are available, i.e. force the=
m to
     start at MEM_REGION_TEST_DATA.

  5. Use separate memslots for CODE, DATA, and PT by default.  This will al=
low
     for more precise sizing of the CODE and DATA slots.

  6. Shrink the number of pages for CODE to a more reasonable number.  Curr=
ently
     vm_nr_pages_required() reserves 512 pages / 2MiB for per-VM assets, wh=
ich
     at a glance seems ridiculously excessive.

  7. Use the PT_AT_4GIB knob in s390's CMMA test?  I suspect it does memslo=
t
     shenanigans purely so that a low gfn (4096 in the test) is guaranteed =
to
     be available.

For #4, I think it's a fairly easy change.  E.g. set_memory_region_test.c, =
just
do s/MEM_REGION_SLOT/MEM_REGION_TEST_DATA.

And for max_guest_memory_test.c:

@@ -157,14 +154,14 @@ static void calc_default_nr_vcpus(void)
 int main(int argc, char *argv[])
 {
        /*
-        * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to ba=
ck
-        * the guest's code, stack, and page tables.  Because selftests cre=
ates
+        * Skip the first 4gb, which are reserved by the core library for t=
he
+        * guest's code, stack, and page tables.  Because selftests creates
         * an IRQCHIP, a.k.a. a local APIC, KVM creates an internal memslot
         * just below the 4gb boundary.  This test could create memory at
         * 1gb-3gb,but it's simpler to skip straight to 4gb.
         */
        const uint64_t start_gpa =3D SZ_4G;
-       const int first_slot =3D 1;
+       const int first_slot =3D MEM_REGION_TEST_DATA;
=20
        struct timespec time_start, time_run1, time_reset, time_run2;
        uint64_t max_gpa, gpa, slot_size, max_mem, i;

