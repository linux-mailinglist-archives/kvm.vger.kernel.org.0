Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5022F6FE7
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 02:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbhAOBQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 20:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbhAOBQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 20:16:08 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACD2C061575;
        Thu, 14 Jan 2021 17:15:28 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id d203so8021471oia.0;
        Thu, 14 Jan 2021 17:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f9vV29tH12V5oehUrEWC3EEQU89erOtbIH15ECUnrfI=;
        b=c+5vWvK1S7PltzWJpWuREPDn7qQvaXD5cHcbTb7yhadLTzvABbMggilFAO5C2PxewC
         NcXZ3WBEnMbyp8JcOmRaDbX5Ozy+ulrUjOvdYKbMK06/REVWHOd0KevhhYzTTtazuOv0
         lBY6TpanQVwLVKR8CDwHYBYaQmp6RPNt0TEq13a9aM0Q7VhVVn8FwImxD+/cmjcgTaOl
         nslz1Ezmzmq2HfQD2BOpUGwwUp65l/KfmMEQHLtEBKQ9mxrDHYd+OM6vktC/91oZ/VWS
         hD4SMyZUwEwysx7zCuH35MsvZaO5UfSkt7hZ+GMXEIsbM88+AW0hhn/g5MornR3PtyoB
         af8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f9vV29tH12V5oehUrEWC3EEQU89erOtbIH15ECUnrfI=;
        b=ODN0ovOgYMlMn+OwZKUCYXvwnA1pW2eC5GRefOxb/Whdg4JP1Q/7CkCudWcNBMbZYZ
         8QgHrymDvq0Pl2o9ayllNRdLbL5iivD+gZL6gAEW9ppp2e2QnBKz418nq4b2vzb2kAHb
         VD6eKic7QdbJM0fYeVKYzzmfTZsIU5kX5gEpOCz4bIzaa0sd/xeKcWrWXMeaua38j3my
         j6x4Hrxn9GO/Wmiqt8w2b7QsV5yjgMezu1+gEGsqtPq8gcls+5QuGx76VPGcjOYYlitT
         7iVcXzLnNadAifvVtd5Z4QxpxH0ZTdvq/kjFfc93vhBxbdj/kRKOt4V9zxWoS8MVnkBW
         TOuQ==
X-Gm-Message-State: AOAM530dVy5KGTGHtw3ew6bPLTCrww7AeRexIQ0KGnFnrbTiskj5akIx
        +wRomcfv83RGCVORO6lWlemhvIeJIp3iFKZVmdI=
X-Google-Smtp-Source: ABdhPJzDE4iVRY71WCOtB3Tq6Kkdif0djXRQzln2l/teqzWxQe0HJ5ah8N+ou27q2O9xwn1rJXv4pQ6mwQbsVtla8ok=
X-Received: by 2002:aca:6202:: with SMTP id w2mr4125297oib.5.1610673327505;
 Thu, 14 Jan 2021 17:15:27 -0800 (PST)
MIME-Version: 1.0
References: <1610623624-18697-1-git-send-email-wanpengli@tencent.com> <87pn277huh.fsf@vitty.brq.redhat.com>
In-Reply-To: <87pn277huh.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 15 Jan 2021 09:15:16 +0800
Message-ID: <CANRm+Cz01Xva0_OjTpq3Wbyppa=FZzxBwZJCWJNicV3eCrzpdQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 at 21:45, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The per-cpu vsyscall pvclock data pointer assigns either an element of the
> > static array hv_clock_boot (#vCPU <= 64) or dynamically allocated memory
> > hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if
> > kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in
> > kvmclock_setup_percpu() which returns -ENOMEM. This patch fixes it by not
> > assigning vsyscall pvclock data pointer if kvmclock vdso_clock_mode is not
> > VDSO_CLOCKMODE_PVCLOCK.
> >
> > Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared variables")
> > Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
> > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: stable@vger.kernel.org#v4.19-rc5+
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kernel/kvmclock.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> > index aa59374..0624290 100644
> > --- a/arch/x86/kernel/kvmclock.c
> > +++ b/arch/x86/kernel/kvmclock.c
> > @@ -296,7 +296,8 @@ static int kvmclock_setup_percpu(unsigned int cpu)
> >        * pointers. So carefully check. CPU0 has been set up in init
> >        * already.
> >        */
> > -     if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)))
> > +     if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)) ||
> > +         (kvm_clock.vdso_clock_mode != VDSO_CLOCKMODE_PVCLOCK))
> >               return 0;
>
> The comment above should probably be updated as it is not clear why we
> check kvm_clock.vdso_clock_mode here. Actually, I would even suggest we
> introduce a 'kvmclock_tsc_stable' global instead to avoid this indirect
> check.

I prefer to update the comment above, assign vsyscall pvclock data
pointer iff kvmclock vsyscall is enabled.

    Wanpeng
