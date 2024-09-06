Return-Path: <kvm+bounces-26021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D37796FB30
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 20:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A852F1C2107D
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 18:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA0C1B85D7;
	Fri,  6 Sep 2024 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ncpFnFJd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F211F1B85C7
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 18:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725647141; cv=none; b=Lw1sByrPGo6/kzQ4aKSj3yK7XMWgR80dct65lK88WrZ5FHXzGqx5uk5RPQTCB140ylCc7HVlK5hcdNmAHSzGznhka18LaZ2hpAWsWCbh2qzNcWzocceXhWa8wjZ4rTclf5keuBigLZTLsctjuoqvxN5Xavmujw8f5a1jJVa7WxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725647141; c=relaxed/simple;
	bh=HAWTSejsuBPy6Dtc6prPSyCUqqHuieyfoyh0upBTK8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JUltaWqqzKI94j7/RLcwS71G4CzS/Tr+tyzCFJRyxdJwajktYcIE4jmhuRIox8at9u8R+g9jxL+b6l7HY6ajoFhyPhJNAH5AOSXEKWumiB92vOy5H3DLs1rtKFg4iyM4HnFXOt4WvMvHpCEFxnaIxxDNmUJwhizELIU0KttyPIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ncpFnFJd; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-690aabe2600so21249757b3.0
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 11:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725647139; x=1726251939; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYz/TqaCWGQdn2yy5EUl5NnldNwL91U0JxBVyIUn/6Q=;
        b=ncpFnFJdbfuH1XUPOj/IiFwn0645SNADR930JfufuCvoA0jlnusNH755gngvXeiFyp
         4oDfd3428X+V/gItCPapJ8k2gjKnj/gcJzk2fe5E3/5dPD7OSSxYRUCXZb6vzYayKSD0
         0lo7kxFGomZZATBp4XDUk4tGdHTVdDmcWOwN4Mc8RheaQFj00QeYAroePbTsFXTrb4pl
         Ue8DX/UDEhWtN8Kmcex2iG0jTUXGvvu9xjfhAUGm0nqpnV5SDJgqW8BySzH7ZYFLyMDL
         ic5rczLXr/o+tmhHVWH0f/Pnv4VitIjP4pn8SFcSDV5M02DmjQVpzM81W5k6g0GRQq0F
         UBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725647139; x=1726251939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYz/TqaCWGQdn2yy5EUl5NnldNwL91U0JxBVyIUn/6Q=;
        b=BPQrxFzF8RdmklNT3e9Uu9zdE2Xnc+H/7/V3d4CglZgdIi7ASduHhArEO6QdNs8gqt
         aAzj6Hm7aOqidnxzRtj3fuhHNOxIZ9ItOf8cNu9t/LRwMvb9iniejy/M7edq+4S+UcCw
         bm3+jCixIu4z9ZjdxSUHOXPqoz886Yg+1J8rMYzQkAT7/NDTkZ711j6wHUeb+YRDalfV
         aHmT6JM/ORT8wUW1lGw3htiKvWm0Pc8zMlqDrf/pTU6bMrWfBhVxM1FHKe8vk4D5JsYj
         lG1hxpkL5bXZ4zLzaQWg5ZyEqip+Zka7D1oYvdxFORtCGDLDH54nE9jnlzceDUIYeWwc
         BRyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDgZxyJrCk8Q9k9h+lqYUINr4jMnybIqurI0qR5BytNFBapQPJ4AMtSED560hEZ+eAKKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIVl5eQT1dI/FI3ZK4IX/7u97VYFJmK51eu//jwDD71SnWVkTP
	Wm1tuQybmDpv+j68y37R2nn7qGApBAeceSz+B/zHZWsSc91KjhKwf2zSyA8j+fdNRWKpU+JTbF5
	ZK7IlR9xJJMhpxoqkytf8747OlhfV5o3G2NJD
X-Google-Smtp-Source: AGHT+IGQg0XyYqDNSPWEA3ijI2F+ukJNP9IKqZT6+Xs/BjTbws+aZ89UphNwSgeMnrAkjqxw4PSnXFeRY1HXRZd12w8=
X-Received: by 2002:a05:690c:87:b0:6b7:a7b3:8db2 with SMTP id
 00721157ae682-6db4516ca91mr46220817b3.30.1725647138707; Fri, 06 Sep 2024
 11:25:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-5-seanjc@google.com>
 <CADrL8HW6fFuFTm1wuW9UC4kr+rmRK4MqrU=bQEWram4xo9JBOw@mail.gmail.com> <ZtqIRi0pZaI-fPiC@google.com>
In-Reply-To: <ZtqIRi0pZaI-fPiC@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 6 Sep 2024 11:25:01 -0700
Message-ID: <CADrL8HUFNx8WK1brM5tv=s9bC-wjjYTxuCLsEmXc63N-Q1q2cg@mail.gmail.com>
Subject: Re: [PATCH 04/22] KVM: selftests: Compute number of extra pages
 needed in mmu_stress_test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 9:42=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Sep 05, 2024, James Houghton wrote:
> > On Fri, Aug 9, 2024 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > Create mmu_stress_tests's VM with the correct number of extra pages n=
eeded
> > > to map all of memory in the guest.  The bug hasn't been noticed befor=
e as
> > > the test currently runs only on x86, which maps guest memory with 1Gi=
B
> > > pages, i.e. doesn't need much memory in the guest for page tables.
> > >
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/mmu_stress_test.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/te=
sting/selftests/kvm/mmu_stress_test.c
> > > index 847da23ec1b1..5467b12f5903 100644
> > > --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> > > +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> > > @@ -209,7 +209,13 @@ int main(int argc, char *argv[])
> > >         vcpus =3D malloc(nr_vcpus * sizeof(*vcpus));
> > >         TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
> > >
> > > -       vm =3D vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
> > > +       vm =3D __vm_create_with_vcpus(VM_SHAPE_DEFAULT, nr_vcpus,
> > > +#ifdef __x86_64__
> > > +                                   max_mem / SZ_1G,
> > > +#else
> > > +                                   max_mem / vm_guest_mode_params[VM=
_MODE_DEFAULT].page_size,
> > > +#endif
> > > +                                   guest_code, vcpus);
> >
> > Hmm... I'm trying to square this change with the logic in
> > vm_nr_pages_required().
>
> vm_nr_pages_required() mostly operates on the number of pages that are ne=
eded to
> setup the VM, e.g. for vCPU stacks.  The one calculation that guesstimate=
s the
> number of bytes needed, ucall_nr_pages_required(), does the same thing th=
is code
> does: divide the number of total bytes by bytes-per-page.

Oh, yes, you're right. It's only accounting for the page tables for
the 512 pages for memslot 0. Sorry for the noise. Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

