Return-Path: <kvm+bounces-25795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0E096AA10
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:27:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8B68281105
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 21:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEE1126C15;
	Tue,  3 Sep 2024 21:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cR9wtbzA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83E51EC011
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 21:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398843; cv=none; b=cik5O4eHBj1hwKw8PG35WZfFlj6dOpqQSS1FrpGsU51FOXLvqdGQWubPfL2x5qTIQvzqB9wE/+WGFRp6OJo1TmXUz/HXFKNL5WFxc3CF1rfcYfQLjbXdquK985zkOAy2hTQ0BZYjO2I/rpjZonVmKnLEhy6pohVqy3IR0LlPMxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398843; c=relaxed/simple;
	bh=qrEVV+atCP7YQHWLRovEDChqJnEVAxmFlKh54HDJg74=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JTD6/NiK3l5l5rN+3uIRsdyS9b4WMRb0uvyufOkkzz8FkbmCM9Wxc7i8k/aK+q8OqslTk597zmuDf811LKfQyBrZlAAwTSDdgNJDiFreDbgyDwPbgBdHVum9+fya+0njOpe6m89AuGwG4ejcD6Wiu8cDufQySsehvHgkhFigGUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cR9wtbzA; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7cd96715e6aso5979343a12.2
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 14:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725398841; x=1726003641; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IR07rgwQIaWEPj4YMn8O/ZcaLcUIXupvfxHt9XUMIM0=;
        b=cR9wtbzAkfq0KN+2a8SIFguzGIGC7yRb19+edEMmhwjyYdDr5X603HJSDgHddjL149
         qIENrZdbTfIE+yV8o79DXwjzTRsOItZP4sixQTW8FDnZyysJIj+rROyEQkHRw5Jg6Cbv
         iwzx2MEVUvMpogmrXQ0Wf71GOgRPQcg2ljMljVlnd8NXvE4VK5CY1YkJ4zJJ0tj2BmNG
         BTgO+RbS2276S7RLr78h/+4yCbtjPKYJMjWIxpz3jK8iPyvG7m7EEyWCjFJFyW8HDsV9
         Gcw0So9jXvwDx+IBqHzath3SBqoais1JV4Lt0qfuBNLfhBZ7ZSNsLoxK9OrySQqz/VMl
         8mgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725398841; x=1726003641;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IR07rgwQIaWEPj4YMn8O/ZcaLcUIXupvfxHt9XUMIM0=;
        b=XHwNjGCzkSHi9iFnKKK7wuqZJN01NwAfr2wXZ9MrJPrL0b/KAnEP5hIOCtBf+D4KrC
         C78fv07vS8q4WiQHgo0AOHnj4egjdt9/wsDV7vriua6LZO2Nbov5Ux7Jy+51b5yLYXsh
         oG5ingqxf4x/J45mqPzrtVr2CooeYN6+/blLjHEtiagzv0kyelF5c9DlaD2WkE5yDtBN
         2F+ChHoC4kkkBf6/ZxP2hYKVf/08waBq0jVQX4ExJDKtG42b5YvDm9Q6ZL3riTCTctyO
         YP+7XdDUx9VE9yxeBUuMGxHAjmGTtq6TYgAgTGTmL1dg9fF7GMDfdjsvetOEaiPB/O9h
         ylnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWX4yJqbDVx0bq1FXgS/c/K8/GBsU7u41cgBU6VULAG2BwImJmIvUZlUg+UJ8B7VH7+SZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyazScXDsZ7udB8Cc2BFeTHg653lwVLPWw0/zD9dT90NYlLrUTp
	46pmuxgr4pErdv4HVEq7pI3czicfOSzK7dNT9DS81Zrnwo2Kaudat9vgjHK6aeGMtdSZDYTJSb7
	cRA==
X-Google-Smtp-Source: AGHT+IHGGObdt+nrbGLN/+Yh5AuDmiJz4qFZ0q/RoulTdosTQa20/tiyRdaw1DNIz9LuC/N23WQmeX8QqMA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:595:b0:6e4:9469:9e3c with SMTP id
 41be03b00d2f7-7d4aa728a2emr31302a12.0.1725398840594; Tue, 03 Sep 2024
 14:27:20 -0700 (PDT)
Date: Tue, 3 Sep 2024 14:27:19 -0700
In-Reply-To: <CADrL8HUvmbtmfcLzqLOVhj-v7=0oEA+0DPrGnngtWoA50=eDPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CADrL8HUvmbtmfcLzqLOVhj-v7=0oEA+0DPrGnngtWoA50=eDPg@mail.gmail.com>
Message-ID: <Ztd_N7KfcRBs94YM@google.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2024, James Houghton wrote:
> On Fri, Aug 9, 2024 at 12:44=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > +/*
> > + * rmaps and PTE lists are mostly protected by mmu_lock (the shadow MM=
U always
> > + * operates with mmu_lock held for write), but rmaps can be walked wit=
hout
> > + * holding mmu_lock so long as the caller can tolerate SPTEs in the rm=
ap chain
> > + * being zapped/dropped _while the rmap is locked_.
> > + *
> > + * Other than the KVM_RMAP_LOCKED flag, modifications to rmap entries =
must be
> > + * done while holding mmu_lock for write.  This allows a task walking =
rmaps
> > + * without holding mmu_lock to concurrently walk the same entries as a=
 task
> > + * that is holding mmu_lock but _not_ the rmap lock.  Neither task wil=
l modify
> > + * the rmaps, thus the walks are stable.
> > + *
> > + * As alluded to above, SPTEs in rmaps are _not_ protected by KVM_RMAP=
_LOCKED,
> > + * only the rmap chains themselves are protected.  E.g. holding an rma=
p's lock
> > + * ensures all "struct pte_list_desc" fields are stable.
> > + */
> > +#define KVM_RMAP_LOCKED        BIT(1)
> > +
> > +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> > +{
> > +       unsigned long old_val, new_val;
> > +
> > +       old_val =3D READ_ONCE(rmap_head->val);
> > +       if (!old_val)
> > +               return 0;
>=20
> I'm having trouble understanding how this bit works. What exactly is
> stopping the rmap from being populated while we have it "locked"?

Nothing prevents the 0=3D>1 transition, but that's a-ok because walking rma=
ps for
aging only cares about existing mappings.  The key to correctness is that t=
his
helper returns '0' when there are no rmaps, i.e. the caller is guaranteed t=
o do
nothing and thus will never see any rmaps that come along in the future.

> aren't holding the MMU lock at all in the lockless case, and given
> this bit, it is impossible (I think?) for the MMU-write-lock-holding,
> rmap-modifying side to tell that this rmap is locked.
>=20
> Concretely, my immediate concern is that we will still unconditionally
> write 0 back at unlock time even if the value has changed.

The "readonly" unlocker (not added in this patch) is a nop if the rmap was =
empty,
i.e. wasn't actually locked.

+static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
+				     unsigned long old_val)
+{
+	if (!old_val)
+		return;
+
+	KVM_MMU_WARN_ON(old_val !=3D (rmap_head->val & ~KVM_RMAP_LOCKED));
+	WRITE_ONCE(rmap_head->val, old_val);
+}

The TODO in kvm_rmap_lock() pretty much sums things up: it's safe to call t=
he
"normal", non-readonly versions if and only if mmu_lock is held for write.

+static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
+{
+	/*
+	 * TODO: Plumb in @kvm and add a lockdep assertion that mmu_lock is
+	 *       held for write.
+	 */
+	return __kvm_rmap_lock(rmap_head);
+}

