Return-Path: <kvm+bounces-24459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 268ED9553CA
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 01:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31A851C21199
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDFA146017;
	Fri, 16 Aug 2024 23:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J+sT0qhc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B10CB661
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 23:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723851348; cv=none; b=DYEK4+ErmOtRoFXVx95AVVph86pHsH6bwVgOouD8990Pu2LkoUWdnLRqDjX9fh1LsEWB3Rjk8npOGaaF5qf03scA3dEgQ51rVfJjNsTm/14Gi61OU5sUHtymRZfS9la9lU1hXJl3bYIHTs/J+BOaE3Fc8W47KNi6434eqffCqDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723851348; c=relaxed/simple;
	bh=ZSBvxfvydpmbkizHG9Z42ry+Ks1BhQkLoaSQgyRJewk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gd3HXxOoGKdm06H6cuwngcWQNC1Fx7t36gRBoi6A572ocFgWRyL1R8BQ68m1ODyfIyYfDVrYj6qvBk7FxDrGlu8qTupwikO69beXbqkyZriJpdde+Tu4b8MPfYkLRfLxuGMX8c52FfpQlsJwT3WE28g65xM7z2KDd+mcwKgse+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J+sT0qhc; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-36d2a601c31so1313748f8f.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 16:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723851345; x=1724456145; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Xlyh8wxCGZECQhtpVQQlz3X3Qi8k4ZaQSWu2kVfRh8=;
        b=J+sT0qhcwtFngQhNtHikBYvDxJPEHVo8rnXNRctRYnnQbXJsC61Um9nYshRvKAKkWe
         bd4T12fwLE7Fm/ca5KZdX1BkHKhVkMJwiWUiM2gUYIN0JJ6NnYTZRLmBEQvJCDWJamba
         IRBBqliM/e3FN5wTeOj0g8tlgTeup4/Fwuvn4Paut0XGiW94OTDabb3yjHxmxDJHvUQr
         RRHAOjF4bejY3Ok41Xr/vcF3bobq2AsqPjwg5hLwo8/e8p9KuwLaZMMWto6x0X4aMPUT
         xZFIpKlTBBWhIZy8wQKriFlM04xceEFvOZI+XoJBpkDJFBcDnFmHhbxrZmS0kNFwjJPZ
         SfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723851345; x=1724456145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Xlyh8wxCGZECQhtpVQQlz3X3Qi8k4ZaQSWu2kVfRh8=;
        b=nzf7IF2IjE4JxS9tlQiyCVHFO/b9uGpntUKyXpEQ/eSmBgkyUfNJzkF8azAZrqYfHr
         OmHdBJvBnSFxUEs+SVixEUMsBu0F/Orgm2LjbrVFjP5m8GlQYp1pxFEhYC2c8EbqBRYs
         u3vVJlD+pLu+v8gLKp2zBi0vBITswUf7E4JGjwpHZfBcAN1wJUxNrWYLxnY0UTbenAiM
         MhurFSG673tbubFn57EoXNRVORs5+sIpYC3nqRPHmgsghNwUGbjlBU4lb49PbgxBCZ2s
         EitwFQDcBp8vu0Pd0O/gtqu6QE0M4HahU09X7RGID48AkqoltE0GTn8y/tZ33UOOVJN6
         R1rg==
X-Forwarded-Encrypted: i=1; AJvYcCWm4KWhCi7j1/HfTXOVse6wj9T0vczORsgwBSdGs9D9HvyX7o7myhnkIxWD6twUVXVUIOXHQaYfHXggBYzysrZLxU2q
X-Gm-Message-State: AOJu0Yw8FkYhB7wodpjMOtHg06uSXIegBnT7asBoRoUYlnZN5UqVCVVE
	r5W36aMYNzboHBkS6ppqFObLv29lH44ZAgUm9RWC2IOvFP0KXY8x4AcD5zVaKWnVhIUnkhQcrNr
	1z63efDOAUAARohFVHEGKJOZWTiWzpT6eqdgO
X-Google-Smtp-Source: AGHT+IHrDOsX4xSf6+jZ6Ga3Z0UQctQLAI7fwXXXeOBbW45NZb3PgcE1C59rxu93hbb/LOZMSg0NYxxmPeKps9z4Tng=
X-Received: by 2002:a5d:43c5:0:b0:368:7fca:9040 with SMTP id
 ffacd0b85a97d-371946a33efmr2434706f8f.39.1723851344331; Fri, 16 Aug 2024
 16:35:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com> <20240805233114.4060019-2-dmatlack@google.com>
 <Zr_XE6NG1c-rNXEl@google.com>
In-Reply-To: <Zr_XE6NG1c-rNXEl@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 16 Aug 2024 16:35:14 -0700
Message-ID: <CALzav=ckxa9iP8zc9oOu69DxVhEjxrqMamv6HwGB+AzRxOf0vQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] Revert "KVM: x86/mmu: Don't bottom out on leafs when
 zapping collapsible SPTEs"
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 3:47=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Aug 05, 2024, David Matlack wrote:
> > This reverts commit 85f44f8cc07b5f61bef30fe5343d629fd4263230.
> >
> > Bring back the logic that walks down to leafs when zapping collapsible
> > SPTEs. Stepping down to leafs is technically unnecessary when zapping,
> > but the leaf SPTE will be used in a subsequent commit to construct a
> > huge SPTE and recover the huge mapping in place.
>
> Please no, getting rid of the step-up code made me so happy. :-D
>
> It's also suboptimal, e.g. in the worst case scenario (which is comically
> unlikely, but theoretically possible), if the first present leaf SPTE in =
a 1GiB
> region is the last SPTE in the last 2MiB range, and all non-leaf SPTEs ar=
e
> somehow present (this is the super unlikely part), then KVM will read 512=
*512
> SPTEs before encountering a shadow-present leaf SPTE.

Haha, I didn't consider that case. That seems extremely unlikely. And
even if it did happen, KVM is holding mmu_lock for read and is able to
drop the lock and yield. So I don't see a strong need to structure the
approach around that edge case.

>
> The proposed approach will also ignore nx_huge_page_disallowed, and just =
always
> create a huge NX page.  On the plus side, "free" NX hugepage recovery!  T=
he
> downside is that it means KVM is pretty much guaranteed to force the gues=
t to
> re-fault all of its code pages, and zap a non-trivial number of huge page=
s that
> were just created.  IIRC, we deliberately did that for the zapping case, =
e.g. to
> use the opportunity to recover NX huge pages, but zap+create+zap+create i=
s a bit
> different than zap+create (if the guest is still using the region for cod=
e).

I'm ok with skipping nx_huge_page_disallowed pages during disable-dirty-log=
.

But why is recovering in-place is worse/different than zapping? They
both incur the same TLB flushes. And recovering might even result in
less vCPU faults, since vCPU faults use tdp_mmu_split_huge_page() to
install a fully populated lower level page table (vs faulting on a
zapped mapping will just install a 4K SPTE).

>
> So rather than looking for a present leaf SPTE, what about "stopping" as =
soon as
> KVM find a SP that can be replaced with a huge SPTE, pre-checking
> nx_huge_page_disallowed, and invoking kvm_mmu_do_page_fault() to install =
a new
> SPTE?  Or maybe even use kvm_tdp_map_page()?  Though it might be more wor=
k to
> massage kvm_tdp_map_page() into a usable form.

My intuition is that going through the full page fault flow would be
more expensive than just stepping down+up in 99.99999% of cases. And
will require more code churn. So it doesn't seem like a win?

>
> By virtue of there being a present non-leaf SPTE, KVM knows the guest acc=
essed
> the region at some point.  And now that MTRR virtualization is gone, the =
only time
> KVM zaps _only_ leafs is for mmu_notifiers and and the APIC access page, =
i.e. the
> odds of stepping down NOT finding a present SPTE somewhere in the region =
is very
> small.  Lastly, kvm_mmu_max_mapping_level() has verified there is a valid=
 mapping
> in the pr imary MMU, else the max level would be PG_LEVEL_4K.  So the odd=
s of
> getting a false positive and effectively pre-faulting memory the guest is=
n't using
> are quite small.

