Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD116442B0F
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhKBJyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbhKBJyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 05:54:20 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C571C0613F5
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 02:51:35 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id i26so31993059ljg.7
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 02:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ltDk5JK6z+dHqY8fdueOIJnXFQ9epuN/VTXpT5MWcbo=;
        b=dB1O/eAqNcHN1R5TtXUb4Ium887EbOkxo37AnK/8BMd9z/JGifaE1xNVkrSWa5LMMh
         07YxdoVTS/OIMoHQHPutCkgiq9L1DjLVN+3aiQGnfasgaMJZT2JkrdBiej0auqMzj4Zq
         SeM4ASzdOt0EEDJw+/4W7DextFsZHaW0Y9fWezHvThGjnSv7/G41wW+7dEqC1oG/ACET
         9Xzc6fMqSJpq/raOpG4T5jn7IdAUg68R+0iuy8UNcVa7NUOJWFTXwhVdThdLVwusOjhS
         D85uaZLFHrfRqn23fuXjUwJw7svEl6TUbgIJCuE0CD5xCubi44JJLNS7JXRWSf49glWD
         xPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ltDk5JK6z+dHqY8fdueOIJnXFQ9epuN/VTXpT5MWcbo=;
        b=hFXlOnlanrLCKUccw8q86XSXkxL7hWw0BVgVZ69Ghn0/VQwywfc+ObRrFOEJZ/O5QC
         fkwCqmJN3MOLEjw+8QJ/wYiN5vDvIqwQmpVQJx8n7t2SlICRxLIwrWl+kJ0tyntZccaX
         9L3bSlVrlyL5JEqrwWExPAImELzlnWZS/7vkV8JPtDPew/ahVE4J630MRu0RVy+j1Tuy
         WMdxPiyaK2CXirOAx2HWphi809l2qUA++GXI/UcRF+Yc6DWsPKOJJjPqW7JopIFEneBW
         tlkchlqfKfpnQJAp425vo80PYlfCyO+U5QjJ2KHFQ2qwuXpei5zRxCA4/JlPLlcbAL/M
         wUpA==
X-Gm-Message-State: AOAM533kVk7VoQJ3NkBvVtna8z9EQ3LCE/KOiIYs7UcKXwRvQPq1Wfxp
        mR803yRsbsjaKMLmeNBPD05364QdDHFW+BGi6v5zCA==
X-Google-Smtp-Source: ABdhPJzlG6VNtE7PqaH0TRioe9leU6UmH/EsyksQvloUt4hUzw+AxRflWPdOgJuKeeHnODlRb4wS9kPqVoBnzRwawEU=
X-Received: by 2002:a05:651c:556:: with SMTP id q22mr24142315ljp.374.1635846692565;
 Tue, 02 Nov 2021 02:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com> <20211102094651.2071532-3-oupton@google.com>
In-Reply-To: <20211102094651.2071532-3-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 2 Nov 2021 02:51:21 -0700
Message-ID: <CAOQ_QsgqLVVwzOhC5QeRm4qvWA-OXPB+bA=JJk4ffAavO5KMqQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
>
> An upcoming change to KVM will context switch the OS Lock status between
> guest/host. Add OSLSR_EL1 to the cpu context and handle guest reads
> using the stored value.
>
> Wire up a custom handler for writes from userspace and prevent any of
> the invariant bits from changing.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
>  2 files changed, 25 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..c98f65c4a1f7 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -172,6 +172,7 @@ enum vcpu_sysreg {
>         MDSCR_EL1,      /* Monitor Debug System Control Register */
>         MDCCINT_EL1,    /* Monitor Debug Comms Channel Interrupt Enable Reg */
>         DISR_EL1,       /* Deferred Interrupt Status Register */
> +       OSLSR_EL1,      /* OS Lock Status Register */

Sorry Marc, forgot to move this up per your suggestion on the last
series. Only caught it once the patch went out the door.

--
Oliver
