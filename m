Return-Path: <kvm+bounces-47909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD11AC7216
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 22:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDCD41664B8
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 20:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA64A220F4C;
	Wed, 28 May 2025 20:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cFVKVZX4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22592220F2B
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 20:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748463482; cv=none; b=UPpr9O/V1MuXQTIgAVgvc7sMwhXzXG1NXGgkHhi36OLWUCRv7IPfn9G/ZmJZC/EOFhJBK+DsxfkRuSxOZmtID66ud1T7l89U8s0oeReSZFYBPR90eljINu2/wH15op3/kDzAJNM4dlgOSbTaIQFHIIo7ocxuoy/pHEO7JgVuhOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748463482; c=relaxed/simple;
	bh=MW9va8ZpX3dYh3E3JLHuTSkrOEon9HLdeDcTvo+YAEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jzKCtaZNbQLhRbTghckmMkDCxMoRXz51iEjpw8z9a9WfjXVt9xEu1LAKFNLQeM1MaS/Rw8E5p6x5QjYWs3oEYMiOdjwBvxOOkCKowZstwxwMd4S31fROkDcUfrRf3ARAjFnMlnWhpu98aIXuco6TsCy7uLt/f9pOSlEZn8CyeKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cFVKVZX4; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-87dfb4a92abso32715241.2
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 13:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748463479; x=1749068279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pS3L3KRfz5KN2f4PHSrDwEqqU16vREHLyymMNsMjI1o=;
        b=cFVKVZX4RH3eioeab6GMuevfGyXtlRZ+XbIy4swTSnD6RPCujGkDSaJobpxXmtX931
         5Z+dK+NFe5o6sgZdHjpYBGNuWp5Pl5UuDtpgCd2NMQN4cNv9kzScLbv4kTUJgBFFtWAi
         Hr7vbQGD/wmfEyd+0dLh37EBKUqGdvpUVxJlbOehYho4yVGgPRFY15XO23poInjJYToN
         prIQnx+KEAsdRdWdw3I59meSwmMNFyn+mc9veZqnt9tBlOcDmp6rkhJ4Rq+bnibZtxdQ
         geYuxQP5ANPsAsvgC1k+hwEMRmZWAq/is1Po2Qg+duaBDAYSOSM0UJrKNore7Vbcjw6H
         jTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748463479; x=1749068279;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pS3L3KRfz5KN2f4PHSrDwEqqU16vREHLyymMNsMjI1o=;
        b=ICKb+TEPAoRuOAVs72IfwAMXgmcCMax2PgVM82QKFQkMlrRClLCeBa5MUts9TzXXZc
         XKsmkehU0Dg//IqmaZUsLEQz4FNdJG7SkTIc6ZAgaJFZX/7OU+jeejbm2L6u6ENANfhU
         K6oi+GQYB5vrJR648574xDYJT2KeETWAr6w/l1GjV/8NNRPr85VrX17++g8+GUGBApOo
         MEuLrA3fIMY1BUAlUxj+pkCqUnYpk9t1NnahoNtmdmEt0hemo+nQajvvH0tGwOS4qQ1q
         H3Euj+5geLRnZ1aQiUWzj0ITPEdiR5yB7nWg6fqpOCWnVjse1oriaxv6/1hhoIzDhDsO
         esag==
X-Forwarded-Encrypted: i=1; AJvYcCW2RBvND0ZfdxClJWBFPT+p+AwERgwWHzTN6fWMEtr1WmOdfo/KwDigdPjY0XlNV5ZYMuo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCMIOWRbZTgurktxxfRdGAjDHWvchULGLyGD4fXWLArRH0GdAr
	3GEb8WjfXO8VdtKoNhBwHMF4Ogq4T8VIoAAUen/bk93OnP6osJXPEEr675OrqKO956idEWZchMq
	khWgjQKuB9UtN2nYzIaFANg==
X-Google-Smtp-Source: AGHT+IGyUJTOXQyn/15OsOvKdvYlJU2g7lRit6+I+UryLZeKjuoksIAEOAqNG3KzRBgJ4D83T1qgfTqVSbHb27/G
X-Received: from vsve42.prod.google.com ([2002:a05:6102:faa:b0:4dd:b083:d38c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:5092:b0:4e5:ac99:e466 with SMTP id ada2fe7eead31-4e5ac99f42fmr1294267137.18.1748463478924;
 Wed, 28 May 2025 13:17:58 -0700 (PDT)
Date: Wed, 28 May 2025 20:17:54 +0000
In-Reply-To: <aDdILHOu9g-m5hSm@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aDdILHOu9g-m5hSm@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250528201756.36271-1-jthoughton@google.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: seanjc@google.com
Cc: amoorthy@google.com, corbet@lwn.net, dmatlack@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, wei.w.wang@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 1:30=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> On Wed, May 28, 2025, James Houghton wrote:
> > On Wed, May 28, 2025 at 11:09=E2=80=AFAM James Houghton <jthoughton@goo=
gle.com> wrote:
> > > On Tue, May 6, 2025 at 8:06=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > > @@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct k=
vm *kvm,
> > > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct kvm=
_memory_slot *new,
> > > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0enum kvm_mr_chan=
ge change)
> > > > =C2=A0{
> > > > - =C2=A0 =C2=A0 =C2=A0 bool log_dirty_pages =3D new && new->flags &=
 KVM_MEM_LOG_DIRTY_PAGES;
> > > > + =C2=A0 =C2=A0 =C2=A0 u32 old_flags =3D old ? old->flags : 0;
> > > > + =C2=A0 =C2=A0 =C2=A0 u32 new_flags =3D new ? new->flags : 0;
> > > > +
> > > > + =C2=A0 =C2=A0 =C2=A0 /* Nothing to do if not toggling dirty loggi=
ng. */
> > > > + =C2=A0 =C2=A0 =C2=A0 if (!((old_flags ^ new_flags) & KVM_MEM_LOG_=
DIRTY_PAGES))
> > > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> > >
> > > This is my bug, not yours, but I think this condition must also check
> > > that `change =3D=3D KVM_MR_FLAGS_ONLY` for it to be correct. This, fo=
r
> > > example, will break the case where we are deleting a memslot that
> > > still has KVM_MEM_LOG_DIRTY_PAGES enabled. Will fix in the next
> > > version.
> >
> > Ah it wouldn't break that example, as `new` would be NULL. But I think
> > it would break the case where we are moving a memslot that keeps
> > `KVM_MEM_LOG_DIRTY_PAGES`.
>
> Can you elaborate? =C2=A0Maybe with the full snippet of the final code th=
at's broken.
> I'm not entirely following what's path you're referring to.

This is even more broken than I realized.

I mean that this diff should be applied on top of your patch:

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5e2ccde66f43c..f1db3f7742b28 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2134,8 +2134,12 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	u32 old_flags =3D old ? old->flags : 0;
 	u32 new_flags =3D new ? new->flags : 0;
=20
-	/* Nothing to do if not toggling dirty logging. */
-	if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+	/*
+	 * If only changing flags, nothing to do if not toggling
+	 * dirty logging.
+	 */
+	if (change =3D=3D KVM_MR_FLAGS_ONLY &&
+	    !((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
 		return;
=20
 	/*

So the final commit looks like:

commit 3c4b57b25b1123629c5f2b64065d51ecdadb6771
Author: James Houghton <jthoughton@google.com>
Date:   Tue May 6 15:38:31 2025 -0700

    KVM: arm64: Add support for KVM userfault exits
   =20
    <to be written by James>
   =20
    Signed-off-by: James Houghton <jthoughton@google.com>
    Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c5d21bcfa3ed4..f1db3f7742b28 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2127,15 +2131,23 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 old_flags =3D old ? old->flags : 0;
+	u32 new_flags =3D new ? new->flags : 0;
+
+	/*
+	 * If only changing flags, nothing to do if not toggling
+	 * dirty logging.
+	 */
+	if (change =3D=3D KVM_MR_FLAGS_ONLY &&
+	    !((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
=20
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (log_dirty_pages) {
-
+	if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
 		if (change =3D=3D KVM_MR_DELETE)
 			return;
=20

So we need to bail out early if we are enabling KVM_MEM_USERFAULT but
KVM_MEM_LOG_DIRTY_PAGES is already enabled, otherwise we'll be
write-protecting a bunch of PTEs that we don't need or want to WP.

When *disabling* KVM_MEM_USERFAULT, we definitely don't want to WP
things, as we aren't going to get the unmap afterwards anyway.

So the check we started with handles this:
> > > > + =C2=A0 =C2=A0 =C2=A0 u32 old_flags =3D old ? old->flags : 0;
> > > > + =C2=A0 =C2=A0 =C2=A0 u32 new_flags =3D new ? new->flags : 0;
> > > > +
> > > > + =C2=A0 =C2=A0 =C2=A0 /* Nothing to do if not toggling dirty loggi=
ng. */
> > > > + =C2=A0 =C2=A0 =C2=A0 if (!((old_flags ^ new_flags) & KVM_MEM_LOG_=
DIRTY_PAGES))
> > > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;

So why also check for `change =3D=3D KVM_MR_FLAGS_ONLY` as well? Everything=
 I just
said doesn't really apply when the memslot is being created, moved, or
destroyed. Otherwise, consider the case where we never enable dirty logging=
:

 - Memslot deletion would be totally broken; we'll see that
   KVM_MEM_LOG_DIRTY_PAGES is not getting toggled and then bail out, skippi=
ng
   some freeing.

 - Memslot creation would be broken in a similar way; we'll skip a bunch of
   setup work.

 - For memslot moving, the only case that we could possibly be leaving
   KVM_MEM_LOG_DIRTY_PAGES set without the change being KVM_MR_FLAGS_ONLY,
   I think we still need to do the split and WP stuff.

