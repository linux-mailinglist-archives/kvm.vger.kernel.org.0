Return-Path: <kvm+bounces-53581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B9DB143EF
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 23:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09AB0188051B
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 21:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6732276059;
	Mon, 28 Jul 2025 21:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3yQSOS4j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC3526A0DF
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 21:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753738738; cv=none; b=LzCqyO04W+QhAoDmZXLBnYONfvcOiCMhRbXjj5zKaCL/Ve1wMDYF6twLvwPP/n8hplJYymK17Ep/JtILre1PmWLtKw595WeekckDTlkxC8US76L2MIEkVSq5k/qZXfZenrobHJ64WdM2iRo62GHMwGCgv3R3wU6Qq59Qe44Ekvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753738738; c=relaxed/simple;
	bh=LOfd0vHjMNejVUvbvNWDBiGEYNfSLM8vMq7V6Z9EF7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R3iclh3hJAaKt6gypx1kdKiLlbhLx7ZeRMJ6/RjmuxWUCqrD61YUdGydr2YFKR9Sp4/ZPW+lYuiBMp7tUdcKrp0aZpZIiBdUTUL4zBKMjMcni20udP+0bH3J4y5gw9N6GgbQU4fB1oJk9xAjuyy2BHSVxuNsWHcPVlhqgsxKYwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3yQSOS4j; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2403c86ff97so13044915ad.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 14:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753738736; x=1754343536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Qzsw1VtUTY4pn1HE8xcAZoBHNUjQcfll7dBGQyXeZ8=;
        b=3yQSOS4jS8DExoaCU89AKXdHCoxApqdRPqCdjg+Lu0WX3V119XPa4lYC1Hri/eI4/G
         29nR28nWXpsxfAyPDtVTFeqoPAmUnYMPvV0kxpWKvobq8qlJg7D//eEDcOueqtCXssro
         jTYjwwxA8hdoLgaUxwD+P5Lkqbsqd3cMmOplhe+W7DN2AFMvp5GwMIfTSJ8cgVMLpAXH
         IwuRex9Q+mbwZ6w7+e3aRHJ7nKsbCftiYkiwMjBN4dNIhoVnzpGDkYRzMpX5OQ2IAzsc
         jeCcbC9tYjIeWckzJOWLLOkuDHh1X+5RzajOzsVlLyEPe8t0R2VKL6JiSX0UuiJQeUx+
         agLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753738736; x=1754343536;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+Qzsw1VtUTY4pn1HE8xcAZoBHNUjQcfll7dBGQyXeZ8=;
        b=DTMufcE56PdPWASQk86D5pS+xdPNYLF8qBJCxJFGoQuwo0mjsJcy0Ywa+CCNf80KJH
         vgyF4OgCVc+OM+ZQ3UAftxUs5PScPm0bHPkpa2WqaWA5AySqsyLFM9RFVBJZwxY89q2+
         +oSRbZeaYjsoUebAdwv5cnyRYZzfvoFga/loTT4dEL3zYbBl+7zY42J5C9qTfWRLzFnL
         HiLk3QDiS8/o6rdOEoDlAsfPNQjW4v+sJl0g/7mGllN2IIP6jdduHeRb7GJZio4as5iK
         awSQeElbi6yhtTSpC/werYQjGzHIN8Iv60VC4M41NGb7pjNEN+3iUaIFyiUtvleKi96Y
         QagA==
X-Forwarded-Encrypted: i=1; AJvYcCWOxUOojZko7++Q++KQXWDTuFCilO3fH427UXmLelhKKphIHB3KHRnaSaF0jz/VPyeOWKY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPFQkBGo+GppK9mzztGbnFqRh/89qO+5x+o2wmeIVvdW7Ai5Yt
	aCAn8FOInD8PFQlr/vTWaHYZqcUkqnQxxSS8+XsKXr6qo8eFxH884Dj1mLS89FrITsiTxOnyHsB
	UCUR0Xg==
X-Google-Smtp-Source: AGHT+IEZrkPEJG3cebOIkuivVavvJbQnzIudGhOMIpdjHX58AE2AU/k8vYvp80MKmMTuR8uwmPUPq0yanhw=
X-Received: from pjqq12.prod.google.com ([2002:a17:90b:584c:b0:2ff:6132:8710])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:320a:b0:23d:d2d2:b511
 with SMTP id d9443c01a7336-23fb30cb6c3mr186721765ad.19.1753738735880; Mon, 28
 Jul 2025 14:38:55 -0700 (PDT)
Date: Mon, 28 Jul 2025 14:38:54 -0700
In-Reply-To: <CALzav=e0cUTMzox7p3AU37wAFRrOXEDdU24eqe6DX+UZYt9FeQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-4-jthoughton@google.com> <aIFHc83PtfB9fkKB@google.com>
 <CADrL8HW46uQQKYUngYwomzfKWB0Vf4nG1WRjZu84hiXxtHN14Q@mail.gmail.com> <CALzav=e0cUTMzox7p3AU37wAFRrOXEDdU24eqe6DX+UZYt9FeQ@mail.gmail.com>
Message-ID: <aIft7sUk_w8rV2DB@google.com>
Subject: Re: [PATCH v5 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025, David Matlack wrote:
> On Mon, Jul 28, 2025 at 11:08=E2=80=AFAM James Houghton <jthoughton@googl=
e.com> wrote:
> > On Wed, Jul 23, 2025 at 1:35=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > > @@ -7559,8 +7590,17 @@ static void kvm_recover_nx_huge_pages(struct=
 kvm *kvm,
> > > >       rcu_read_lock();
> > > >
> > > >       for ( ; to_zap; --to_zap) {
> > > > -             if (list_empty(nx_huge_pages))
> > > > +#ifdef CONFIG_X86_64
> > >
> > > These #ifdefs still make me sad, but I also still think they're the l=
east awful
> > > solution.  And hopefully we will jettison 32-bit sooner than later :-=
)
> >
> > Yeah I couldn't come up with anything better. :(
>=20
> Could we just move the definition of tdp_mmu_pages_lock outside of
> CONFIG_X86_64? The only downside I can think of is slightly larger kvm
> structs for 32-bit builds.

Hmm, I was going to say "no, because we'd also need to do spin_lock_init()"=
, but
obviously spin_(un)lock() will only ever be invoked for 64-bit kernels.  I =
still
don't love the idea of making tdp_mmu_pages_lock visible outside of CONFIG_=
X86_64,
it feels like we're just asking to introduce (likely benign) bugs.

Ugh, and I just noticed this as well:

  #ifndef CONFIG_X86_64
  #define KVM_TDP_MMU -1
  #endif

Rather than expose kvm->arch.tdp_mmu_pages_lock, what about using a single =
#ifdef
section to bury both is_tdp_mmu and a local kvm->arch.tdp_mmu_pages_lock po=
inter?

Alternatively, we could do:

	const bool is_tdp_mmu =3D IS_ENABLED(CONFIG_X86_64) && mmu_type !=3D KVM_S=
HADOW_MMU;

to avoid referencing KVM_TDP_MMU, but that's quite ugly.  Overall, I think =
the
below strikes the best balance between polluting the code with #ifdefs, and
generating robust code.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 52bf6a886bfd..c038d7cd187d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1372,10 +1372,6 @@ enum kvm_mmu_type {
        KVM_NR_MMU_TYPES,
 };
=20
-#ifndef CONFIG_X86_64
-#define KVM_TDP_MMU -1
-#endif
-
 struct kvm_arch {
        unsigned long n_used_mmu_pages;
        unsigned long n_requested_mmu_pages;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a6a1fb42b2d1..e2bde6a5e346 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7624,8 +7624,14 @@ static bool kvm_mmu_sp_dirty_logging_enabled(struct =
kvm *kvm,
 static void kvm_recover_nx_huge_pages(struct kvm *kvm,
                                      const enum kvm_mmu_type mmu_type)
 {
+#ifdef CONFIG_X86_64
+       const bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
+       spinlock_t *tdp_mmu_pages_lock =3D &kvm->arch.tdp_mmu_pages_lock;
+#else
+       const bool is_tdp_mmu =3D false;
+       spinlock_t *tdp_mmu_pages_lock =3D NULL;
+#endif
        unsigned long to_zap =3D nx_huge_pages_to_zap(kvm, mmu_type);
-       bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
        struct list_head *nx_huge_pages;
        struct kvm_mmu_page *sp;
        LIST_HEAD(invalid_list);
@@ -7648,15 +7654,12 @@ static void kvm_recover_nx_huge_pages(struct kvm *k=
vm,
        rcu_read_lock();
=20
        for ( ; to_zap; --to_zap) {
-#ifdef CONFIG_X86_64
                if (is_tdp_mmu)
-                       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-#endif
+                       spin_lock(tdp_mmu_pages_lock);
+
                if (list_empty(nx_huge_pages)) {
-#ifdef CONFIG_X86_64
                        if (is_tdp_mmu)
-                               spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
-#endif
+                               spin_unlock(tdp_mmu_pages_lock);
                        break;
                }
=20
@@ -7675,10 +7678,8 @@ static void kvm_recover_nx_huge_pages(struct kvm *kv=
m,
=20
                unaccount_nx_huge_page(kvm, sp);
=20
-#ifdef CONFIG_X86_64
                if (is_tdp_mmu)
-                       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
-#endif
+                       spin_unlock(tdp_mmu_pages_lock);
=20
                /*
                 * Do not attempt to recover any NX Huge Pages that are bei=
ng
--

