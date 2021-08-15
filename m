Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499F73EC807
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 09:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhHOHuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 03:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbhHOHuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 03:50:52 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71799C0613CF
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 00:50:22 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id z2so28307027lft.1
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 00:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AeOo2/NJjjRZYAUfR03mnALs9Q9w0Q9REEH1kqJO00E=;
        b=TTisQC8k2XZPlvQzmZ2PypsNzh4fKcVGQecrhsZTm8I5mYnu9OEoFUxpfcfGmVEgT0
         oFQVCy2noSHCf0NiWo9oKoMHOWWxBSghDOOQEB1aTBF1eW5SMMzli2h1a71UXuWNN9Ro
         /GlJ3Jun1lsbhCKcSJtjBBoNDi+4kgce+P0wVDtPSRZ3lGAod+4Lo53P4JluPdOuLoeE
         /Sg95KVEy45JHH+yG/mAuMCvsyiBhlqluH2/E0diCzUutcLj2VsqugSNEZ95RftY7Hen
         dpLdQ84kgo55aqPP/JTejkYde7MwWUJf1JMuB4iQo8yBm+SP/PmFmoEGt+jQSyW6zhGq
         c1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AeOo2/NJjjRZYAUfR03mnALs9Q9w0Q9REEH1kqJO00E=;
        b=hvnsB61ZUZ14oejWgCsTZpGQgCkkQ/KFLLmplCf2FKM6BwqX/NoX/QTa9eE1clspGj
         Ji2R4rlBwYFZlr3exBux9itKpWDUNoA3ERRH46cDloxUDjzq7yzDs4FAMatHnxtGGd9r
         Q/PRitXWaNN199s6juekY7/Ks7Sq/gQIqYcHCY/vQ7NBbKt62IMaXfig+Rlh7vJLAh1h
         OJdn6vnIIV+R+iQOyWUWVTbOek1K9c+mvnKj6SfjudxBXvNL9SPQfH679vxD4BAGEBFp
         XE07I3LNl64xV1nSY+NCL+6ZlNbhhGBNIb7QTZXJLwaKyC05Es5vQAetmQqJUiqkzXMF
         lHoA==
X-Gm-Message-State: AOAM533gv7SzwDqV57p7chLiPhvvg0jchkTw6LFCf81nF+NB9QmR874k
        O+QpNwf+30ZRR4lyUVZAKeBpEXUoJFxTBDamhEtfXg==
X-Google-Smtp-Source: ABdhPJwUAMiV1AVeFvyV3z1ePGBOkI+wFqGIWViv3msIS8RjqYqp89UQNSmQ6cy5OtC99JXIbfoUD2ygtROWcboUyrM=
X-Received: by 2002:a05:6512:3608:: with SMTP id f8mr7346112lfs.57.1629013819926;
 Sun, 15 Aug 2021 00:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210802192809.1851010-1-oupton@google.com>
In-Reply-To: <20210802192809.1851010-1-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Sun, 15 Aug 2021 00:50:09 -0700
Message-ID: <CAOQ_Qsj0UH=3FQNP3NTjX-rcU68s0hm6k5g7i_rwqKc4b84DZA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: arm64: Use generic guest entry infrastructure
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Friendly ping :)

--
Thanks,
Oliver

On Mon, Aug 2, 2021 at 12:28 PM Oliver Upton <oupton@google.com> wrote:
>
> The arm64 kernel doesn't yet support the full generic entry
> infrastructure. That being said, KVM/arm64 doesn't properly handle
> TIF_NOTIFY_RESUME and could pick this up by switching to the generic
> guest entry infrasturture.
>
> Patch 1 adds a missing vCPU stat to ARM64 to record the number of signal
> exits to userspace.
>
> Patch 2 unhitches entry-kvm from entry-generic, as ARM64 doesn't
> currently support the generic infrastructure.
>
> Patch 3 replaces the open-coded entry handling with the generic xfer
> function.
>
> This series was tested on an Ampere Mt. Jade reference system. The
> series cleanly applies to kvm/queue (note that this is deliberate as the
> generic kvm stats patches have not yet propagated to kvm-arm/queue) at
> the following commit:
>
> 8ad5e63649ff ("KVM: Don't take mmu_lock for range invalidation unless necessary")
>
> v1 -> v2:
>  - Address Jing's comment
>  - Carry Jing's r-b tag
>
> v2 -> v3:
>  - Roll all exit conditions into kvm_vcpu_exit_request() (Marc)
>  - Avoid needlessly checking for work twice (Marc)
>
> v1: http://lore.kernel.org/r/20210729195632.489978-1-oupton@google.com
> v2: http://lore.kernel.org/r/20210729220916.1672875-1-oupton@google.com
>
> Oliver Upton (3):
>   KVM: arm64: Record number of signal exits as a vCPU stat
>   entry: KVM: Allow use of generic KVM entry w/o full generic support
>   KVM: arm64: Use generic KVM xfer to guest work function
>
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/Kconfig            |  1 +
>  arch/arm64/kvm/arm.c              | 71 +++++++++++++++++++------------
>  arch/arm64/kvm/guest.c            |  1 +
>  include/linux/entry-kvm.h         |  6 ++-
>  5 files changed, 52 insertions(+), 28 deletions(-)
>
> --
> 2.32.0.554.ge1b32706d8-goog
>
