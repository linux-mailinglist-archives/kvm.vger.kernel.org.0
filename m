Return-Path: <kvm+bounces-11337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F06BF875B3F
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 00:54:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABA4F28370D
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 23:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245DA47F6B;
	Thu,  7 Mar 2024 23:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FUGuLAby"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA07DF4FC
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 23:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709855642; cv=none; b=vGPiJAmbwPUt9IGUfBJEBJb9YkOvKOelwkcYsh3Yu5GeH23gikMZaLnQ/kjDP5b1+ByMriM8WLDuUjgWTiOELsssKeX4ScL8rC23Ieg9y4NDRS6qDhE4VonCzNE3tvWxyF2VuMtRHMjlUz+hT7Wm8c1H7zYSJSwYwsr0zVDShq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709855642; c=relaxed/simple;
	bh=JZ5ygIjVV/4srJOVWO3bgdWNYZ7MXsjc9gMzGHYNp00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TSl61+lo9SV0BnQHRdAVom5nva4sVBGAFjf/33iO3rHG+la0sv8JmD4PMP/0wougW37K6NCWbVMmpajZAASCclwNSS2dhyC7gNNukHWicCTXAE+rVj/h9vSm9P/Bw3p0iJ8z3wSPCLC1K4h+CKy6ysyfRNeAV2d4pyG1hlMdgu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FUGuLAby; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-33e709ea81bso217524f8f.0
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 15:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709855639; x=1710460439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MgBHHyXzHI3mVg3phLLavcOUXwtTdUPLd+9TIUfpUGo=;
        b=FUGuLAby1hvNQ1D9jgQhKxWlA8zCQOkMtcecx0PVDCw2Ni07yxR7MVUCRpXS+1WObz
         oJ35nWGh7CuJfj8Y7Zx5AwTNF0Kr8kEfKbGyfTPs7vmwzrb0omRH3tixQ1vVzUDetCoq
         ElLBI+T4arNzL26+O9VO+RXI3H8s5dXtpRhdRtScoLkI3tfoqsCzHImmV2HDsb1SzANt
         z30rERqa0P3WvaLWwk1HHoslyTaPo+zT2iubPH6Sr4XZJGX4NMO2NBKO0gucJCPTtgdD
         ADxksXPeLKmnlwRwP1aAl8KEZD3OXjN7QEO2GYADyNB+6nPBuSAYCmMuSA9aStOeLeV1
         zK3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709855639; x=1710460439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MgBHHyXzHI3mVg3phLLavcOUXwtTdUPLd+9TIUfpUGo=;
        b=AjHQtfXYCLCTxQeXjG9zLw/mk4Ogh/hGLhZYWTwBUBWq6knKLSU53dz4SIFIYTCt2g
         7bhzr+q8TssB0wnZI4R+k7gqQRQ9Zkq6oUqC0eOL/3f/uVuhSX7Du5nT+BR4fwXxqEFY
         RkLu5U03gbCvmJtuw8dL5YUDf5LGp4GRVrCkNEzu5grCMOXbdgfB64VxMrYq1NbXtR/t
         EKXMDUOrDBCzwY6g4Nrk+U9A0IBDM5K3oZIJhczFnfK64fBS6X6tuGZ9sfOwIkqPGQWV
         OBeoogyo1TZfvZvvzisGlcwKtKWlXvDaoas/UrmbqeOV4FyrGwZS04QJjeQ7sVTwgS1+
         TJfw==
X-Forwarded-Encrypted: i=1; AJvYcCWyA4Z0N5Q6P152pfeMLTBdq5y0J36YE4lztdf1VbaxBahh5Y1+Fbt1yY1LDpwQWJ3mIN92f0efll7qTbin6D4bn7UB
X-Gm-Message-State: AOJu0Yzt8F/kBqDDYZhE1hVL3Hv0Yg7YWcj/Q4i4Rqonj4xiravaEpHS
	ZdZOtHGa99ZwyNkfPl3WFyrg8RKFX5THmpXP6mwNipqdHPWnJff9Eb9Qzp+DPQFBgfeBblN2lWm
	idD9aky/qQ9D15kXF9BdgZXtq42oD8eyHQjYg
X-Google-Smtp-Source: AGHT+IELZ4KbRS4xhUWudVtuhKeZTBm16soxPCRIOZr4hHMEpMTwjOF+SMMhbr4inr/Y5jKDR4lhMWKN1bXu7HlZaZ0=
X-Received: by 2002:a5d:61c2:0:b0:33e:d27:4ed3 with SMTP id
 q2-20020a5d61c2000000b0033e0d274ed3mr12683149wrv.64.1709855638683; Thu, 07
 Mar 2024 15:53:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307194255.1367442-1-dmatlack@google.com> <ZepBlYLPSuhISTTc@google.com>
 <ZepNYLTPghJPYCtA@google.com>
In-Reply-To: <ZepNYLTPghJPYCtA@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 7 Mar 2024 15:53:30 -0800
Message-ID: <CALzav=cSzbZXhasD7iAtB4u0xO-iQ+vMPiDeXXz5mYMfjOfwaw@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on x86_64
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Michael Roth <michael.roth@amd.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 3:27=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2024-03-07 02:37 PM, Sean Christopherson wrote:
> > On Thu, Mar 07, 2024, David Matlack wrote:
> > > Create memslot 0 at 0x100000000 (4GiB) to avoid it overlapping with
> > > KVM's private memslot for the APIC-access page.
> >
> > This is going to cause other problems, e.g. from max_guest_memory_test.=
c
> >
> >       /*
> >        * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to =
back
> >        * the guest's code, stack, and page tables.  Because selftests c=
reates
> >        * an IRQCHIP, a.k.a. a local APIC, KVM creates an internal memsl=
ot
> >        * just below the 4gb boundary.  This test could create memory at
> >        * 1gb-3gb,but it's simpler to skip straight to 4gb.
> >        */
> >       const uint64_t start_gpa =3D SZ_4G;
> >
> > Trying to move away from starting at '0' is going to be problematic/ann=
oying,
> > e.g. using low memory allows tests to safely assume 4GiB+ is always ava=
ilable.
> > And I'd prefer not to make the infrastucture all twisty and weird for a=
ll tests
> > just because memstress tests want to play with huge amounts of memory.
> >
> > Any chance we can solve this by using huge pages in the guest, and adju=
sting the
> > gorilla math in vm_nr_pages_required() accordingly?  There's really no =
reason to
> > use 4KiB pages for a VM with 256GiB of memory.  That'd also be more rep=
resantitive
> > of real world workloads (at least, I hope real world workloads are usin=
g 2MiB or
> > 1GiB pages in this case).
>
> There are real world workloads that use TiB of RAM with 4KiB mappings
> (looking at you SAP HANA).
>
> What about giving tests an explicit "start" GPA they can use? That would
> fix max_guest_memory_test and avoid tests making assumptions about 4GiB
> being a magically safe address to use.
>
> e.g. Something like this on top:

Gah, I missed nx_huge_page_test.c, which needs similar changes to
max_memory_test.c.

Also if you prefer the "start" address be a compile time constant we
can pick an arbitrary number above 4GiB and use that (e.g. start=3D32GiB
would be more than enough for a 12TiB guest).

