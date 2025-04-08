Return-Path: <kvm+bounces-42898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 219DEA7FB38
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 12:11:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2021D19E4550
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0840E26773C;
	Tue,  8 Apr 2025 10:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hf2oWxQq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F9E2676DE
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 10:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744106521; cv=none; b=Ngz7xPFbW2vEr/p9RI6YaAk8RLoqMcHtkmYq4v1zHV68y1NLbQ7tQ98XMvUC2DOvn4gQ5EY9fIShVwzCta9DtOZzZNdS17S29IFYnPdiV0Es058n+0vJZgdJpjTV8mWHjJyoDw/MByNldI76UvpLaXZuZt2WhE4zbChJZp3Akn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744106521; c=relaxed/simple;
	bh=ZzsMlsyKkY/FXG3dji+XPdROB7fvB/OQJhZ1N6j73bk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QIBLNfQ4X9MYeH8jYeDkKSVEsCbApKkmk10s4JKxxglEQbVQxj1YomWiD0+zIEDKl0CNIwCbd0aHp9Bs5QcddM2xUx2q2to8XU+f+5jfeQMUd1tVV6VFDqQp3Ys/gH0duA6oyklADVrQYbiGi08EuBcvfG66SP0jPgPtALJcTF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hf2oWxQq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744106516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S7vwRWv9mWbyZzeYPX5lAQ7x95n9IfuU+PqoLw+Ao0U=;
	b=Hf2oWxQqETyy0yOviwH/XOxfCZAYnCCNYSzKxcIU3lU3K1kZ1Vm2sXSmvtGiPWqP+evPE4
	q/SiCohtTd03tY4Pb6XZaE3G8xMKguUohxpbhqZlft/0n1gJwnIa9CaYmM2GUd2lVBHgPR
	Z6QWmMZ5JbEke3Cu48Cx14fN6DxgL7Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-9n_VAoXWMv2S9TqzW-NwGA-1; Tue, 08 Apr 2025 06:01:55 -0400
X-MC-Unique: 9n_VAoXWMv2S9TqzW-NwGA-1
X-Mimecast-MFC-AGG-ID: 9n_VAoXWMv2S9TqzW-NwGA_1744106514
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39abdadb0f0so2793094f8f.0
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 03:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744106514; x=1744711314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7vwRWv9mWbyZzeYPX5lAQ7x95n9IfuU+PqoLw+Ao0U=;
        b=TQ9PgtvHZv1/50KWU5WHdrI3/HZWfypDfRpqmg8fr2CXfi1qrmG1A98a5aMA7Z2yFJ
         Jut24vbAm01WWqfT5ckyEx9xtPQnMvK2Y3cqEay/H45+Rva1QFTNoZT7/NvYa2rdtEaz
         TeLqcIY7rcKfjPRd+nhx3AYUC+3QnFXp2AYgYS11Ow4MnC96qasjclJCU0LhnG8RnXsH
         i3UDFx1co7ThgmMan/UB/A1S/8zZM7yxQGGlD/tlol2aPeBjR2eWxg9OS3u4HqoZNK/U
         ED0h7KFwARyONoaF9zoVYw0bQKYvRbwuROOfbhumHbIgWe3IGw5tyVOgsvPdOggPJfN2
         ovfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvZl2R4mFyIfJPF4xedE+2FZMeQjFn2X8yzqyb5xOs5cGnTDwOH595mhgiSPLeCLIJ09w=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp+C4yLWsQkba1uU7QPXQMdA3DGc88cwAOOiaNLRKIajPXSw//
	nuhnaP6hMUk/Kfu968PCxQkMAefNzMnPxz8fZKgxHSpoH03FSp2ATvwH3M4KMITv7xwDVmdw38j
	wsxAnTIzBtrj/kM3f90R4X2dGcJjlmH/wBXMlEZHOEcuxMbvuTe0WY/t/4HXPZwJ4f7iQa0yMz9
	vxpcq0w+EQvO8AVabSmUZ8Yz5M
X-Gm-Gg: ASbGncu8NZdn22YJ2bDp6EN+vAtC8HFb72DJngRxf7LE5uo0saSrjONdUFduCSkD/cp
	uZY2ebCSsA1VB9DiedFD9PJpGPakw6VlCQiXKyQIDM7ZpI7yaUhxFxPsmcUe3l5HakX8O230x3A
	==
X-Received: by 2002:a5d:64ce:0:b0:39c:1f19:f0c3 with SMTP id ffacd0b85a97d-39cba93ce4amr13910545f8f.46.1744106514076;
        Tue, 08 Apr 2025 03:01:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPdD0tZMwUQ1u2VI+ko0QS55Uf8DUI0x6WFuvmtj4nnFQtbx6GDlEiPL4bsRPPHCMMyvA9zIosiuYwmKcEKPs=
X-Received: by 2002:a5d:64ce:0:b0:39c:1f19:f0c3 with SMTP id
 ffacd0b85a97d-39cba93ce4amr13910507f8f.46.1744106513573; Tue, 08 Apr 2025
 03:01:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z_RubCEp4h7sAdjz@linux.dev>
In-Reply-To: <Z_RubCEp4h7sAdjz@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Apr 2025 12:01:42 +0200
X-Gm-Features: ATxdqUEbr6laVVTyQ97z66VXBohS7bVQNuTHIjwemR8RnZR5JDOIXKkUoe4bM9k
Message-ID: <CABgObfa+omBgaJqEtr1Xi3bXZDR5xtA2Emko0p1SqeBNxFRiFA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64: First batch of fixes for 6.15
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 2:32=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Paolo,
>
> Here's the first set of fixes for 6.15. The biggest change here is the
> __get_fault_info() rework where KVM could use stale fault information whe=
n
> handling a stage-2 abort.
>
> Rest of the details can be found in the tag. Please pull.

Done, thanks.

Paolo

> Thanks,
> Oliver
>
> The following changes since commit 369c0122682c4468a69f2454614eded71c5348=
f3:
>
>   Merge branch 'kvm-arm64/pmu-fixes' into kvmarm/next (2025-03-19 14:54:5=
2 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.15-1
>
> for you to fetch changes up to a344e258acb0a7f0e7ed10a795c52d1baf705164:
>
>   KVM: arm64: Use acquire/release to communicate FF-A version negotiation=
 (2025-04-07 15:03:34 -0700)
>
> ----------------------------------------------------------------
> KVM/arm64: First batch of fixes for 6.15
>
>  - Rework heuristics for resolving the fault IPA (HPFAR_EL2 v. re-walk
>    stage-1 page tables) to align with the architecture. This avoids
>    possibly taking an SEA at EL2 on the page table walk or using an
>    architecturally UNKNOWN fault IPA.
>
>  - Use acquire/release semantics in the KVM FF-A proxy to avoid reading
>    a stale value for the FF-A version.
>
>  - Fix KVM guest driver to match PV CPUID hypercall ABI.
>
>  - Use Inner Shareable Normal Write-Back mappings at stage-1 in KVM
>    selftests, which is the only memory type for which atomic
>    instructions are architecturally guaranteed to work.
>
> ----------------------------------------------------------------
> Chen Ni (1):
>       smccc: kvm_guest: Remove unneeded semicolon
>
> Oliver Upton (4):
>       smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
>       KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid
>       arm64: Convert HPFAR_EL2 to sysreg table
>       KVM: arm64: Don't translate FAR if invalid/unsafe
>
> Raghavendra Rao Ananta (2):
>       KVM: arm64: selftests: Introduce and use hardware-definition macros
>       KVM: arm64: selftests: Explicitly set the page attrs to Inner-Share=
able
>
> Will Deacon (1):
>       KVM: arm64: Use acquire/release to communicate FF-A version negotia=
tion
>
>  arch/arm64/include/asm/esr.h                       | 44 +++++++++++++-
>  arch/arm64/include/asm/kvm_emulate.h               |  7 ++-
>  arch/arm64/include/asm/kvm_ras.h                   |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/fault.h             | 70 +++++++++++++++-=
------
>  arch/arm64/kvm/hyp/nvhe/ffa.c                      |  9 +--
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  9 ++-
>  arch/arm64/kvm/mmu.c                               | 31 ++++++----
>  arch/arm64/tools/sysreg                            |  7 +++
>  drivers/firmware/smccc/kvm_guest.c                 |  4 +-
>  .../testing/selftests/kvm/arm64/page_fault_test.c  |  2 +-
>  .../selftests/kvm/include/arm64/processor.h        | 67 ++++++++++++++++=
+++--
>  tools/testing/selftests/kvm/lib/arm64/processor.c  | 60 +++++++++++-----=
---
>  12 files changed, 234 insertions(+), 78 deletions(-)
>


