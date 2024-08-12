Return-Path: <kvm+bounces-23887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C976294F92E
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 23:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53354B22550
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 21:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C61195F04;
	Mon, 12 Aug 2024 21:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K6sJK8QD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A7B1586D3
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 21:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723499640; cv=none; b=mHok9+m71fin5RHMJoPSFbpuqoCnD3sybLCoAxxGooWJEeAAK3xofXgj8xpkYRk2EZi8oQyBAogr0VyNpocGsxSgkbGkuaQUy+PuVt0UDwKBhYAELQbkfy9nogvtvR3G9U0lKz/rxAXwVUynX2FC3Z6q9ywE2J5R3RouIJ1lQWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723499640; c=relaxed/simple;
	bh=iFb81utD+kxg5AVUC9OJqvlmXZarFcIDLBfi3Zt5x5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IoBd/RzFB/R4BavwZNYZ2+v1cC1EkV9w4s4coETHuxR/cCEyPB2lL+8KurXgMoXt46w1pDCXgiDFfMJEXtS5nfkn1Xdt8+NWa2dkWAFRzeLaNtEatsrfHgeXxXo8TXr5hUvksbFTFjySqADXp01WY+6sVjWqvjDj1nJ/LPFAw2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K6sJK8QD; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-36bd70f6522so2635977f8f.1
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723499637; x=1724104437; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imKlkkFUg+JvJB0nb5f6d/5Hvt3G5KlID+hC9c1+ZW0=;
        b=K6sJK8QDL4qjeVSaQ98zRvHUjHiN2oBZhzJS4pTe+STiY298GQXaiBErY9YcBxrxH3
         +9eJqlSeF6DdHM3wqeSXvdm95aufpCiklX4WeZs0wyuQx4ZnSnhi5kdaRTSDu05Cychg
         l38RL+tZioqSDsTjKBO2ADb4HvsMFmqXBC0CSgrJa3jlx5Tc5/ZhrZ+mY4e1R69EZmS5
         zhmP6ikv1lQWyq3dtD5kdtJwosRlkQDaNdZWZR1BpfrGMQ8g4dfB8SNjzKCACqMnsUhF
         rk6xz1lyjhvcm6uhJLadUOfYi8uKrh4497+JTY7YuvCD96FwpuZkmDjEcSMUdloPwvkm
         YT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723499637; x=1724104437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=imKlkkFUg+JvJB0nb5f6d/5Hvt3G5KlID+hC9c1+ZW0=;
        b=f3rVWgsnfQE0Ck83gOmvQLZr/jyr2nY7xi4JjnLj/Z4EbP9djJEJOmUkjoArOAfRfb
         qOBfY+dgfal0a6ALN4F0wxa87ucf+3zIa0mDFjhxuOdhFD/NQ0lUg+Ae5EHqqhLtqX1N
         5183k/+Z1dem4LVjyy9rXIN4qP0n1IxcYJorzfeubbfLqW7bDxFDv3C6KOt80nRG5OqE
         /oDwspm6vjlPkUgLe2BXrT7GdMUJMEDyauayPU9qT36I8nelQDeZbf8jDG8zzo68M4VJ
         EOMBaHFzulkbzFHjF7NodNPh8mEkVDh2tL+nZTL3IJawEDszLTaX2q1yxQC/gXZ0LTMv
         V/Cg==
X-Forwarded-Encrypted: i=1; AJvYcCU6/3mtoCwMaHxuoKWxpHabFJrURAIb4IVaGY0z0YSdNUxoSqK1abSY54G9nemequR6Enpb4TtqNat9J2CIPkP0Ib2y
X-Gm-Message-State: AOJu0YwRKMKDS4MVfelspo/YqQBh1WQeexOuut1QSrufDs78iy+GaCDx
	wWRrsKF5ZPkS3ZYJc+SIVkqW+oPL9JPH89iRvPnLZn6GE5FA90HSR5BurmUmmyNQwfft59CzK6W
	8Gk15+OYyZeeA/AtdZU4Aw2+1jVwXy5Zvd55A
X-Google-Smtp-Source: AGHT+IEq9Z3A8c6NJnVvf2RQgYE7P88YKMQaUxK73bXmj83aH6DHf5GTXyarL8Mu9mgSiyFTWmwXtiXjB7rGW2BOKIM=
X-Received: by 2002:a05:6000:1842:b0:368:4bc0:9210 with SMTP id
 ffacd0b85a97d-3716ccf39e2mr1378800f8f.25.1723499637114; Mon, 12 Aug 2024
 14:53:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-15-seanjc@google.com>
In-Reply-To: <20240809194335.1726916-15-seanjc@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 12 Aug 2024 14:53:29 -0700
Message-ID: <CALzav=cYv4ZqD5q6-hP=WN8gYFxt7xYKCTm8dLaGtjk-kmCy=w@mail.gmail.com>
Subject: Re: [PATCH 14/22] KVM: x86/mmu: Morph kvm_handle_gfn_range() into an
 aging specific helper
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 12:48=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0a33857d668a..88b656a1453d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> +static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
> +                                  struct kvm_gfn_range *range, bool test=
_only)
> +{
> +       struct slot_rmap_walk_iterator iterator;
> +       struct rmap_iterator iter;
> +       bool young =3D false;
> +       u64 *sptep;
> +
> +       for_each_slot_rmap_range(range->slot, PG_LEVEL_4K, KVM_MAX_HUGEPA=
GE_LEVEL,
> +                                range->start, range->end - 1, &iterator)=
 {
> +               for_each_rmap_spte(iterator.rmap, &iter, sptep) {
> +                       if (test_only && is_accessed_spte(*sptep))
> +                               return true;
> +
> +                       young =3D mmu_spte_age(sptep);

It's jarring to see that mmu_spte_age() can get called in the
test_only case, even though I think the code is technically correct
(it will only be called if !is_accessed_spte() in which case
mmu_spte_age() will do nothing).

