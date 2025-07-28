Return-Path: <kvm+bounces-53551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E341B13DE7
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:09:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C0BA189DE98
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095AD271452;
	Mon, 28 Jul 2025 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ct3G2vH3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D00270EA1
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753715336; cv=none; b=JhPdxuEwzWfiqF5VZXPyEqMHHo9gCquo7RvuPMi4foKXG+t4q54w/+zAo09xhiAcc9WoW5da5AfIacElfSsBXmzXmdqrJUW8q0wryja41BW82IaMVH+yUtBgFz0kl6jcO7iT48QqbMTuXOLrkEn6jkw/J3lllrHppNYpOdOFEOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753715336; c=relaxed/simple;
	bh=jLMUpIThVRj9B99qwbkaCZZddI1mjJuIMA2gVWp64EE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QXauc8XGKZiPGZu9I29C8ytUGXA2wdrib++5R2AIcNNsqrKrfP6l+6O/+Z6rZXFqMJaAZCrnaM7fpT4O/fbvxLBygl1dvmQ+FzA6MKEjlMtc3Rj8fpD6vWknTvbZyOYVgABTtzVikxcPWpaRlszwF2LmP7dgxuzkxM3mri7a0YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ct3G2vH3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753715333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WeLrAEmcy9a/KrwIPIKDCcX/OKOyUI8WSyV8CWftljI=;
	b=Ct3G2vH3fodg7PWkTy+4ckevfilMczBoZEEu/3BtGqIR51UeWKjml29EBRoRTGz/zBJPGU
	zIrxSH0PUyF1/rQLWPVGvFAoNzdyqu/KKmBXPuAJSX7MmQckOa5jz3pZhzHW14M+VZasTD
	sd2gbIKzNQ2iVCg/cVlIybEy/UHmGw0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-lIJgMGYVMP6TAW_zoF87QQ-1; Mon, 28 Jul 2025 11:08:50 -0400
X-MC-Unique: lIJgMGYVMP6TAW_zoF87QQ-1
X-Mimecast-MFC-AGG-ID: lIJgMGYVMP6TAW_zoF87QQ_1753715329
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b782c29be3so1379879f8f.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 08:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753715328; x=1754320128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WeLrAEmcy9a/KrwIPIKDCcX/OKOyUI8WSyV8CWftljI=;
        b=IFKOXpdTYSrXfvcuGBmKem1Z2uIMriWn6FcC71iIXvm53WR05L1uHgVqZG6zA1y5Rn
         yIDKgN4AhrVYqLEUdtcLGDMAgeg7wadIBI4Z186VA/neN+eZkra8HU+di34z9JO4cNw6
         W4oJmXje4qk1MNT0jpzn/m/ueC+WPor15jV01h7Sful53xX4aRuODOITvuvUPUgNQjJ1
         aOmKsOgevHpCyHCB/Tq+qK7S3wJt3untZGU/X9E4ntMrURFhF5xmxsmYs5TQ30DIcDFG
         jEkutvW6+80gZtM7MWUCAP+lKkoEDgRelDfoClVe35vY55991f76PFUWq+H3A1xNE418
         /anw==
X-Gm-Message-State: AOJu0Ywb56Sqf+T16oF9b1yDX2bOYXJgyADRrI6sYWuZlG7nBwhfEFpc
	OarY6suADniHAIhSnXUu/KQcVDoijUNzOFQh4aGHEwXEkTK18/fJD07gowewjp/mDMj9vCqUugh
	fl0WI93KBhwjFba2JH5VZE+peistPiHO9XI7el02jVnLaYNObAOanTcDOyke0e5Gwj8kYrnQr91
	/7PNBFyvk6ZRLrvK3gJ3mh7t/KgfVa2dZUidBN
X-Gm-Gg: ASbGncsJJILrS5kfYPyDtduAoko2+L1gyeIYonTA+coLqs3GTOGSOTFH7DCTT4AJPgo
	aFl+BV2FHWQ7zbVsq9HpIYQ9NWJ5DqJHg7Nb8dgrrQiYUyjVHNNKk4frWw0g+PnTJ/zwXmbYOUV
	fep7hNcWMQ9Fa5Nz7SBVMZ3A==
X-Received: by 2002:a05:6000:2289:b0:3b6:13a1:8861 with SMTP id ffacd0b85a97d-3b776777071mr9485024f8f.38.1753715327659;
        Mon, 28 Jul 2025 08:08:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFmHYpmqZ9zAX2CcX08tRRdeZpKf6Z5qzT3uq5pwtKvIAjnzoNsGEd6aRd0vCr+dPvcZ2cQOc9SfTXllEpT6E=
X-Received: by 2002:a05:6000:2289:b0:3b6:13a1:8861 with SMTP id
 ffacd0b85a97d-3b776777071mr9485001f8f.38.1753715327196; Mon, 28 Jul 2025
 08:08:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com> <20250725220713.264711-9-seanjc@google.com>
In-Reply-To: <20250725220713.264711-9-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 28 Jul 2025 17:08:35 +0200
X-Gm-Features: Ac12FXzGVs_0x9CCSPjreZguRYWItHAnWn3AnKIBY24adXqI17Gs_Zsx6oRZp5w
Message-ID: <CABgObfay+-c+xdqA16Df-D1QzzwWry5JAjoZtF2oescoismUDg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Device assignment accounting changes for 6.17
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 26, 2025 at 12:07=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Two changes that depend on the IRQ and MMIO State Data pull requests, to =
kill
> off kvm_arch_{start,end}_assignment().
>
> Note!  To generate the pull request, I used the result of a local merge o=
f
> kvm/next with kvm-x86-irqs-6.17 and kvm-x86-mmio-6.17.  The resulting sho=
rtlog
> matches my expectations (and intentions), but the diff stats showed all o=
f the
> changes from kvm-x86-irqs-6.17, and I couldn't for the life of me figure =
out
> how to coerce git into behaving as I want.
>
> AFAICT, it's just a cosmetic display error, there aren't any duplicate co=
mmits
> or anything.  So, rather that copy+paste those weird diff stats, I locall=
y
> processed _this_ merge too, and then manually generated the stats with
> `git diff --stat base..HEAD`.

Yep, that happens. Not enough to consider writing a replacement for
git-request-pull, but it happens...

For me the problems are usually due to back-merges from Linus's tree
(mostly unintentional, like if arch1 uses rc2 as the base and arch2
uses rc4), so I just do a final merge from Linus's tree and use the
*reverse* of that commit's diffstat (git diff --stat HEAD HEAD^) for
the pull request.

Paolo

> The following changes since <the result of the aforementioned merges>:
>
>   KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps MMIO into the gu=
est (2025-06-25 08:42:51 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-no_assignment-6.17
>
> for you to fetch changes up to bbc13ae593e0ea47357ff6e4740c533c16c2ae1e:
>
>   VFIO: KVM: x86: Drop kvm_arch_{start,end}_assignment() (2025-06-25 09:5=
1:33 -0700)
>
> ----------------------------------------------------------------
> KVM VFIO device assignment cleanups for 6.17
>
> Kill off kvm_arch_{start,end}_assignment() and x86's associated tracking =
now
> that KVM no longer uses assigned_device_count as a bad heuristic for "VM =
has
> an irqbypass producer" or for "VM has access to host MMIO".
>
> ----------------------------------------------------------------
> Sean Christopherson (3):
>       Merge branch 'kvm-x86 mmio'
>       Revert "kvm: detect assigned device via irqbypass manager"
>       VFIO: KVM: x86: Drop kvm_arch_{start,end}_assignment()
>
>  arch/x86/include/asm/kvm_host.h |  2 --
>  arch/x86/kvm/irq.c              |  9 +--------
>  arch/x86/kvm/x86.c              | 18 ------------------
>  include/linux/kvm_host.h        | 18 ------------------
>  virt/kvm/vfio.c                 |  3 ---
>  5 files changed, 1 insertion(+), 49 deletions(-)
>


