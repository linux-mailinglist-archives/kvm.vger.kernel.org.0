Return-Path: <kvm+bounces-25990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC30096E8C0
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FBB8286D35
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C03354757;
	Fri,  6 Sep 2024 04:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="smlI3izQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC9442069
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 04:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725597770; cv=none; b=YJKF4fT1Qt1+WeOCy8FXMIiEa2dWQSn25SA+Z4miBJAD8uBkWHOwvd8RKPmOWk23o0SdeKFSnNrBQKeXAc2GD6Z+mncdGO8ezP6J6/djz7fyw9pzaZmOcs/FC3RkkgJL3/pM4DI3UPBho4V9V6LAkCckjH/4+1OYaMrvjQqGnWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725597770; c=relaxed/simple;
	bh=2OvKYHSNj0qvxYMKdqnrShNTXfS3KzvEkkQhoFgllKc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uSqMDFpt5yf2azwkWDSsLQlOs4c9P7PvV8pxYoFDqpKJDKyKh5FScRtxCcI2WUiUNalHssnVCkYBjpB7OKGiCD7TShevGhIdPlkjhz5R+bMF2JvluJOgXT7MCyAMHY+I2GMZq+zJZndr79O/t/OilVnjZ3OAtsQdb2J6iRScaQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=smlI3izQ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b47ff8a5c4so59236877b3.2
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 21:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725597768; x=1726202568; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=woIWYgRFzqQLW6cLGelWzd0RVEm9LOVB8S701+UNVhY=;
        b=smlI3izQVRqb6KtPVhIgVnpAu4mZd4iOZf+wVbb0ZdDEsTCe4+2sR04ssry7ZnXYuU
         oZMjgZK5Mu++Zs8cT7NzyIGGcPwFkG5QbGuMjPfBhssQkr/qRFLF6sE5TNzQlbCEwDaq
         +xxL6EOyEMjzwPHLB8pOQYMZYoTQcDhcLcHBa9347HiQjfv8n9GRZLeg6/da49S4f4rm
         jnUdao8AATcjFP7AELR06cXZ3uBAbEe49OnTzZfYPtxOuo/0co7chBDtnWY/ufcYUhqz
         aYisGU/ioET5kN4h61EUgPjwf6HyWbtTczOzGoF69qwi1Lva/k+OK1N7NzxBfaPrUqVq
         hVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725597768; x=1726202568;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=woIWYgRFzqQLW6cLGelWzd0RVEm9LOVB8S701+UNVhY=;
        b=l/rQODG4fFsbGM09VyNdV3MrbS6QGKbjtlcUfGjKMpsBQcTW9fIAhUw2AFr2xWA9Jo
         j9y+tZJ/kGkwT5ykWk5EeUXIgEgwtWjcLwjsLrKrc8z6/60daiEzLEJDGIThNymHRlHX
         9JS/+/BYkpewCSr3XhM6gr/nJi2l27zpnq9kJBihoSkLOpu90PUXyBqpQjjtum4Tz9vr
         4+J/V0YAYu/+WjqtQZunSmmLVh7oRVK5yWcq2LOKeCYsNM/WH1H9QOSqv9ZmRgupK1b3
         gTcVqPn/6R7KTUxKS/o/Jjzm0eQpogfr76RtB2kHQ2e43MyBjmZVQlZn9/azafMadYEc
         yuYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrmNrPzM2/TR3r80zsGI7J8qNFwDcJFmqeJyIqraikQ/0hUjIwsIsSrHomTNTDMg9W3to=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoxvrITwrNS6p2svyrQAmzikH9f4KERee3f9bXzqigRJgo+xXG
	9ot1X2mkHwVS7B2IEe8XnD8l0LUSFDPG1YXOntUueOAHcUfM01USnuy3kkCsGTNGE4q4Xo1e5FQ
	vJg==
X-Google-Smtp-Source: AGHT+IFsb3zlxHrZ9Ohx8b9GVNXPeZzBIGQoJjUM/Jo6S9vA10nasAuXZUZAEtGNpzg9DBYDHf9YJPIna94=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:25c1:b0:6ad:feb0:d01c with SMTP id
 00721157ae682-6db4515dc01mr849587b3.3.1725597767893; Thu, 05 Sep 2024
 21:42:47 -0700 (PDT)
Date: Thu, 5 Sep 2024 21:42:46 -0700
In-Reply-To: <CADrL8HW6fFuFTm1wuW9UC4kr+rmRK4MqrU=bQEWram4xo9JBOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-5-seanjc@google.com>
 <CADrL8HW6fFuFTm1wuW9UC4kr+rmRK4MqrU=bQEWram4xo9JBOw@mail.gmail.com>
Message-ID: <ZtqIRi0pZaI-fPiC@google.com>
Subject: Re: [PATCH 04/22] KVM: selftests: Compute number of extra pages
 needed in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2024, James Houghton wrote:
> On Fri, Aug 9, 2024 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Create mmu_stress_tests's VM with the correct number of extra pages nee=
ded
> > to map all of memory in the guest.  The bug hasn't been noticed before =
as
> > the test currently runs only on x86, which maps guest memory with 1GiB
> > pages, i.e. doesn't need much memory in the guest for page tables.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/mmu_stress_test.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/test=
ing/selftests/kvm/mmu_stress_test.c
> > index 847da23ec1b1..5467b12f5903 100644
> > --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> > +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> > @@ -209,7 +209,13 @@ int main(int argc, char *argv[])
> >         vcpus =3D malloc(nr_vcpus * sizeof(*vcpus));
> >         TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
> >
> > -       vm =3D vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
> > +       vm =3D __vm_create_with_vcpus(VM_SHAPE_DEFAULT, nr_vcpus,
> > +#ifdef __x86_64__
> > +                                   max_mem / SZ_1G,
> > +#else
> > +                                   max_mem / vm_guest_mode_params[VM_M=
ODE_DEFAULT].page_size,
> > +#endif
> > +                                   guest_code, vcpus);
>=20
> Hmm... I'm trying to square this change with the logic in
> vm_nr_pages_required().=20

vm_nr_pages_required() mostly operates on the number of pages that are need=
ed to
setup the VM, e.g. for vCPU stacks.  The one calculation that guesstimates =
the
number of bytes needed, ucall_nr_pages_required(), does the same thing this=
 code
does: divide the number of total bytes by bytes-per-page.

> That logic seems to be doing what you want (though it always assumes smal=
l
> mappings IIUC).

Ya, AFAIK, x86 is the only architecture that let's test map huge pages on t=
he
guest side.

> So it seems like there's something else that's not being accounted for?

I don't think so?  vm_nr_pages_required() uses @nr_pages to determine how m=
any
page table pages will be needed in the guest, and then adds that many non-h=
uge
pages worth of bytes to the size of memslot 0.

> (Also without the extra pages, how does this test actually fail?)

Guest memory allocation failure when trying to create the guest mappings.

