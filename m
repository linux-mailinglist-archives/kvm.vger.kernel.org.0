Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB927444DCC
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 04:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhKDDk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 23:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhKDDk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 23:40:26 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1A4C06127A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 20:37:49 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t11so4980957plq.11
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 20:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ElaBqdcFpl/MNZIl5634QwYYBAAW38SiF7mXocckqIU=;
        b=loBq9pJZVC8qjqv61AUlvq3vp6kX2bgSRAVnYX6biD4FKiUdIUNHSNwPsu/Nqf3Ni6
         4kllfRYw5mAo8Lmc2QhEhIa3bwW9ETiCgoa4D0qC8ZEQ8hBmDzu/ln1jDC+Eknb26Mh+
         ox1LUYmq7CWAtIunf8CszA2Vck8IBch3Ho8Awci8S64R9Yrcxxu6Vt4jpi3aKWV+C+4n
         g/9BNdJ8iRC/8P8zsYo5PVU9Ht4k6gFXIoFWae3983AtGwmKgHh9A6w03Zql+h36HbAA
         vMr8XTW+kX9c2ixS3qd760Od/JzSq9uQreXPwMGICwrse9CDBXToCFn2M0A2QvN2xk0L
         3ZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ElaBqdcFpl/MNZIl5634QwYYBAAW38SiF7mXocckqIU=;
        b=zmiX0wWL1CfNyATynPCTUdbelyr67fUAT1XLhukxUYnwEQHKI7wfxTxMi7/2TfOQU7
         aI8P/eJbVrykD5QIMyv7vGcLh0uJjNdGkXKhWC3wFfvvvg1rB/6wBxmN6EydHBtF/IIP
         f+AJJBKkU34oVtvt7gKO4ZbcmoMdkZL+PWNzPaOHJTrShhKmDjQ+0C57os55zScicM7E
         rynx4ZAlRFow0OqeH+cVD3kjwXlEJzjvSEudkGe/Rtj9M/1W/8OjuqAe4telPCyyXoYo
         xo1ZCBZU9TJDibkeGTnD8IgB+3u7nYHeWhbRlQhIM3257oiAQjOBC6Mnk9KJGGTxXEpu
         LQNA==
X-Gm-Message-State: AOAM530W6TnVvmrpXhhUk6F4YRUYEDVnPwqCnGgcahpRM/EFD7DpLu2o
        StNznGaOt2k1k5Ju/WB+qxGNIVRQOYLUhowiFkI9xA==
X-Google-Smtp-Source: ABdhPJwNPFTCwA+7Dtt3rn91WionPFUP8QV9J1NB4jxb17C5XHsVckC/3AjrySdj5c7OH4UlyAFSgh5A1l8vckD8hls=
X-Received: by 2002:a17:90a:e506:: with SMTP id t6mr17420531pjy.9.1635997068721;
 Wed, 03 Nov 2021 20:37:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com> <20211102094651.2071532-3-oupton@google.com>
 <CAOQ_QsgqLVVwzOhC5QeRm4qvWA-OXPB+bA=JJk4ffAavO5KMqQ@mail.gmail.com>
In-Reply-To: <CAOQ_QsgqLVVwzOhC5QeRm4qvWA-OXPB+bA=JJk4ffAavO5KMqQ@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 3 Nov 2021 20:37:32 -0700
Message-ID: <CAAeT=Fy_nVirAnwM_-vvxx6OTo0tRy=cWGx7k_nnQfasg2OrSw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 2, 2021 at 2:51 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
> >
> > An upcoming change to KVM will context switch the OS Lock status between
> > guest/host. Add OSLSR_EL1 to the cpu context and handle guest reads
> > using the stored value.
> >
> > Wire up a custom handler for writes from userspace and prevent any of
> > the invariant bits from changing.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
> >  2 files changed, 25 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f8be56d5342b..c98f65c4a1f7 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -172,6 +172,7 @@ enum vcpu_sysreg {
> >         MDSCR_EL1,      /* Monitor Debug System Control Register */
> >         MDCCINT_EL1,    /* Monitor Debug Comms Channel Interrupt Enable Reg */
> >         DISR_EL1,       /* Deferred Interrupt Status Register */
> > +       OSLSR_EL1,      /* OS Lock Status Register */
>
> Sorry Marc, forgot to move this up per your suggestion on the last
> series. Only caught it once the patch went out the door.

Except for the above,
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
