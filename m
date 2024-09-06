Return-Path: <kvm+bounces-25969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4A096E6A0
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 02:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5DCEB2383D
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 00:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD872CA6;
	Fri,  6 Sep 2024 00:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ymm+G0EG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E4ABE65
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 00:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725581055; cv=none; b=THnudoYjVju3eoTHZL5nsUUwdR4lGOlRxqZRq5BIct9JqrxX48YkxMbvP5QpAPkpJsq0pRtPk9p855aUO1MLN1HhOj4FM4co+nZxey7yN8eLNvFznZXZuu0c2ryiS2yo1BmUGo8luy95wCJPi4IfnWBsxkDnwl6p8HBo0LfbyXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725581055; c=relaxed/simple;
	bh=vxIWujGqhPTCGyL/i3GMrPhZGk4DUWsLbFpyhK+I/UY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i/w4IopjWQ6WsMQS9q0yZipTcZbUxBCSXocFux2nohMF7EQXfIUJBJB6ohWTp15uD65Bdp0fCagHluXCR0LJ1pRO91WnWJIAF/E0Binw3uQVcZU4rPsBaeR19RxFLhR9679mqJA9CtIXk1XKYK1+t+vyScaSVz9qKtsrpEzxDYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ymm+G0EG; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e1a9dc3f0a3so1642959276.0
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 17:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725581053; x=1726185853; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k7JJm/OFDJtoUiYUYkfk+OMw1WKtnOqHwTx5Hs/+mMw=;
        b=ymm+G0EG33lBibLvuSCz0QeyK9BEAnhDOmucUfZzbY62SeMPGkQqMuOcmMKlckIis3
         VnFMK2e0tM/VY5ivemu+QavTuloosNTBoi0mhjZKz/V7hJVRzMwWaqBkxqAq2MLa0dr9
         rrI5DDZtIJMmVeBSXnOW9jvHr62vkoOKK9BisjzYrqch72+f7V8HTVlcb7/aV5WFDnnT
         bmkvS+fU9M6FViOMenptAUm9rdmn/g73XstiL6fqHBcV0100dvd65u5SREmKoSxLfoaD
         iFagjXcaUlgaU50fHtw33iAJ7QkpGaon+TsmaKEarj6K3ugKeZWSeSAn5SyTlxv63rFc
         c6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725581053; x=1726185853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k7JJm/OFDJtoUiYUYkfk+OMw1WKtnOqHwTx5Hs/+mMw=;
        b=k5FddPD0w6q49TZBce2tGvGoDS9yaOImDaQR880dUDPWrlia3fKFo5598/dfPEr0NP
         fhbVahlzkiYmArFXZwRlm1hpxu3iNQNZ1OaMcgaQemgx4pglwH4mX7d4BL8ijcufXnMX
         Wq9YJF/3jcM4qHxrzsYDWOBzxbnOm9KrGZeLLtD9hVgVM87nkYNIR5GRCBxrGytujrgx
         3yiCvx4WE6G3/gfXvUvbGi5eSkEb0n6OTlILyl4jzeTmherq8mGBLJfG4DJCq/Atrs9i
         p+M+pjHsRkkyMWBttfRhKiH28mF7z0p3mkueuVsgT/XHf2tVhGuC6geR+bnMVuqbJQGe
         xGtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkQUspEHdPps4ETv7jxnucGo1+R7UWhrtFXZLmmnwt84Zf/PDOE3N+uTdnYV0dwKnjphQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWoi03vr6iRH2t2xzZf3n42k18GfNsGZi2oDacseywookhr33O
	VLOzqw5sGc1m6eahshGcCrVdnqKEhEMwhAdElL6kfU8nMGmCUGDWc+kkisHtW3gms7aWjJ/WwF3
	bPrlhmbIEtxPO/eUfGipcrkpnf5fooYt99LmJ
X-Google-Smtp-Source: AGHT+IGjek6FC1zkqSa5WmJejIOpCTcmlQOu90gXV/5ELDWlBdpuQ1chlRH24U+btvb4pU68ycGzAHLVH3xy4zkXxKg=
X-Received: by 2002:a05:690c:39c:b0:6d7:3c0d:3aac with SMTP id
 00721157ae682-6db4516fb3emr11610257b3.33.1725581053106; Thu, 05 Sep 2024
 17:04:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-5-seanjc@google.com>
In-Reply-To: <20240809194335.1726916-5-seanjc@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 5 Sep 2024 17:03:36 -0700
Message-ID: <CADrL8HW6fFuFTm1wuW9UC4kr+rmRK4MqrU=bQEWram4xo9JBOw@mail.gmail.com>
Subject: Re: [PATCH 04/22] KVM: selftests: Compute number of extra pages
 needed in mmu_stress_test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Create mmu_stress_tests's VM with the correct number of extra pages neede=
d
> to map all of memory in the guest.  The bug hasn't been noticed before as
> the test currently runs only on x86, which maps guest memory with 1GiB
> pages, i.e. doesn't need much memory in the guest for page tables.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/mmu_stress_test.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testin=
g/selftests/kvm/mmu_stress_test.c
> index 847da23ec1b1..5467b12f5903 100644
> --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> @@ -209,7 +209,13 @@ int main(int argc, char *argv[])
>         vcpus =3D malloc(nr_vcpus * sizeof(*vcpus));
>         TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
>
> -       vm =3D vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
> +       vm =3D __vm_create_with_vcpus(VM_SHAPE_DEFAULT, nr_vcpus,
> +#ifdef __x86_64__
> +                                   max_mem / SZ_1G,
> +#else
> +                                   max_mem / vm_guest_mode_params[VM_MOD=
E_DEFAULT].page_size,
> +#endif
> +                                   guest_code, vcpus);

Hmm... I'm trying to square this change with the logic in
vm_nr_pages_required(). That logic seems to be doing what you want
(though it always assumes small mappings IIUC).

So it seems like there's something else that's not being accounted
for? (Also without the extra pages, how does this test actually fail?)

