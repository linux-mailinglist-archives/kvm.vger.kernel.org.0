Return-Path: <kvm+bounces-33459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 369939EBFAB
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 00:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FDEE167DA5
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 23:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E636A22C366;
	Tue, 10 Dec 2024 23:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G0UlM6LY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AAF22C35F
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 23:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733874983; cv=none; b=gzi54TUgPaElppDoqMFOs4vUuRwuoitfNMZ/NKFoZHY65ueacGLa9sJKH31H0Qjx96nSoA8zElTlToiKCGfhGvthb65TyvWr1VluXxZ9ztLWymptvb4D/ZnRpeveblnKEvVlhsx1yu2p42r3zdQEvKXvxEhrJEbokA17E7R658k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733874983; c=relaxed/simple;
	bh=2Ow9LlROqIyEAz9EG6mPsd2hn95O6sGJC2wGIVsR7qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q8dbHKROnqe8Rcm/u2KR5vrBL6hUeI6fNmfwlnBv3fWdipwbnnjOhsYM2akCoA2Lbq0zeCQRXQ0ecO/0nrLMDW7JUzmMio+mstxLfFIFSjXwQkjVFu4TUUmdqe5fZg67J2rPEodzvLjBHosEvZBQqnUKCX5lXOzI6Ly9I9M1Xoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G0UlM6LY; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4afe99e5229so938076137.3
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 15:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733874980; x=1734479780; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3kwAmyuDFZ+JtjhHtbhOmYC5QC1yfvYh82vh9rsnmts=;
        b=G0UlM6LYX6jC7Uh3GzGxc7EH+/tETcPtDzFAJMqPT1YRdQFVlAyNkJpJB3cKfYyGeE
         Q0tcWli1N/0pi+dni4sWa16UWP3bKH3YAP3TXZhYr2OAjPZCrK8AI0cEf1M/nlFIJcms
         CeNnEx+jMT5wbcqiLX7ZQXWj2cDqpNfx8txTsQgdZvIMnl+lpox9qoBX+kVm7IpU1nkx
         qLQC+8R4z4EXS4FFTXE6ZwOduUh2bmv6AEzWA2tpzVDYE+IVRMzMXpPCWbiLusXYAcfP
         D+Yu906v5Ob2O/oB6DizKk4aTFDbLQ/OnpPs8p/7CU2hsI0/vbE58PTUsZ/ug0TDVulu
         KLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733874980; x=1734479780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3kwAmyuDFZ+JtjhHtbhOmYC5QC1yfvYh82vh9rsnmts=;
        b=Kp52KT7sxeA+EUE2y/bToUoR/cULMQBzeC5Fbv2FMUqTgg7xRNDiQPRaquymoamuv3
         LrR2GaiHNyKO/OVT+lv9vgkqkdDphc8kAngoO+P4nUsZUC6XucaOzaI1nSMHbPeARlgP
         5ukpx9L60KFPceYtRhdPo3HfYEQu1JVqA5deFpjezbPl+sWfFt8LL52HQ+s+zojFy4nx
         vcWQ8qtMdtrFIgkY+ETfp+IXU7RGWYMmXbBgHzUwEfEHnZZfm/IziHkxq1qaGM3Sk+YY
         Bhajskhn/mPN18B8zeYh9er88Sp7c4f7YN6tQc0XA/mscmRqsKgHj2ekmlsKael/r4Cj
         Krlw==
X-Forwarded-Encrypted: i=1; AJvYcCUvlcR09JkXaeoueT+VYBiwVYx8hH2Z2A/F13gdvsSJGJNU/OVttxMYCawctITt+EhZH2g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk8OAonbMs1DtV/BMvfDel/LL7sMgJBCEzDImplGf/4gbpSbo2
	HFY1aWbPY7JwEcMziBw7Us1Ug2H78Jz6tbFFKHUe02Owjc/n8DQbFNK3NJI+J3OWOWRQYPI323m
	XgtBSw8ftyL+UfinHUp9Aw6XDmyX9fvq2HuSm+8Y0gKGMadwPQ9nLdWA=
X-Gm-Gg: ASbGncv7rSAakRMqKy2qVwOjRm7CsBtYNMYLW8tpAQWdzZAiRH04byqxXVdibndoxZ9
	ltJev96TZ8qSpnNUY/2qgvVgzqvmtDtgRrcXNyHlUKdrZ4e/af5WJ2P+44XBOTreFcg==
X-Google-Smtp-Source: AGHT+IHiK45i6sqf43YynZwmE988GilFOTC5Jdyljc1cxZqmMNWNnrT3LVvQcykRgNL3RZkhEy9HV9H3u7LSVuTbuPo=
X-Received: by 2002:a05:6102:a49:b0:4af:eed0:9211 with SMTP id
 ada2fe7eead31-4b128ff5c22mr1466389137.13.1733874979997; Tue, 10 Dec 2024
 15:56:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411140445.1038319-1-szy0127@sjtu.edu.cn> <20240411140445.1038319-3-szy0127@sjtu.edu.cn>
 <Z0-h73xBQgGuAI3H@google.com> <CAGdbjm+GmtYEQJsVspFC3_-5nx83qABDroPmyCHPebiKRt-4HQ@mail.gmail.com>
 <Z1DSgmzo3sX0gWY3@google.com>
In-Reply-To: <Z1DSgmzo3sX0gWY3@google.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Tue, 10 Dec 2024 15:56:09 -0800
Message-ID: <CAGdbjm+jyG_V5auZD_MYtMd1j6NXDodTeH1kWGQFWmYRcA5aww@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] KVM: SVM: Flush cache only on CPUs running SEV guest
To: Sean Christopherson <seanjc@google.com>
Cc: Zheyun Shen <szy0127@sjtu.edu.cn>, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 2:07=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Dec 04, 2024, Kevin Loughlin wrote:
> > On Tue, Dec 3, 2024 at 4:27=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > > @@ -2152,7 +2191,7 @@ void sev_vm_destroy(struct kvm *kvm)
> > > >        * releasing the pages back to the system for use. CLFLUSH wi=
ll
> > > >        * not do this, so issue a WBINVD.
> > > >        */
> > > > -     wbinvd_on_all_cpus();
> > > > +     sev_do_wbinvd(kvm);
> > >
> > > I am 99% certain this wbinvd_on_all_cpus() can simply be dropped.  se=
v_vm_destroy()
> > > is called after KVM's mmu_notifier has been unregistered, which means=
 it's called
> > > after kvm_mmu_notifier_release() =3D> kvm_arch_guest_memory_reclaimed=
().
> >
> > I think we need a bit of rework before dropping it (which I propose we
> > do in a separate series), but let me know if there's a mistake in my
> > reasoning here...
> >
> > Right now, sev_guest_memory_reclaimed() issues writebacks for SEV and
> > SEV-ES guests but does *not* issue writebacks for SEV-SNP guests.
> > Thus, I believe it's possible a SEV-SNP guest reaches sev_vm_destroy()
> > with dirty encrypted lines in processor caches. Because SME_COHERENT
> > doesn't guarantee coherence across CPU-DMA interactions (d45829b351ee
> > ("KVM: SVM: Flush when freeing encrypted pages even on SME_COHERENT
> > CPUs")), it seems possible that the memory gets re-allocated for DMA,
> > written back from an (unencrypted) DMA, and then corrupted when the
> > dirty encrypted version gets written back over that, right?
> >
> > And potentially the same thing for why we can't yet drop the writeback
> > in sev_flush_encrypted_page() without a bit of rework?
>
> Argh, this last one probably does apply to SNP.  KVM requires SNP VMs to =
be backed
> with guest_memfd, and flushing for that memory is handled by sev_gmem_inv=
alidate().
> But the VMSA is kernel allocated and so needs to be flushed manually.  On=
 the plus
> side, the VMSA flush shouldn't use WB{NO}INVD unless things go sideways, =
so trying
> to optimize that path isn't worth doing.

Ah thanks, yes agreed for both (that dropping WB{NO}INVD is fine on
the sev_vm_destroy() path given sev_gmem_invalidate() and that the
sev_flush_encrypted_page() path still needs the WB{NO}INVD as a
fallback for now).

On that note, the WBINVD in sev_mem_enc_unregister_region() can be
dropped too then, right? My understanding is that the host will
instead do WB{NO}INVD for SEV(-ES) guests in
sev_guest_memory_reclaimed(), and sev_gmem_invalidate() will handle
SEV-SNP guests.

All in all, I now agree we can drop the unneeded case(s) of issuing
WB{NO}INVDs in this series in an additional commit. I'll then rebase
[0] on the latest version of this series and can also work on the
migration optimizations atop all of it, if that works for you Sean.

[0] https://lore.kernel.org/lkml/20241203005921.1119116-1-kevinloughlin@goo=
gle.com/

Thanks!

