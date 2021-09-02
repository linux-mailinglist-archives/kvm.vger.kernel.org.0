Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B7A3FF454
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 21:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhIBTqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 15:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhIBTqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 15:46:16 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E154C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 12:45:17 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id l10so6789338lfg.4
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 12:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hc2gcVksXzTr1IYZOTogrbXgKL8dWeh0/s29AyPzQmQ=;
        b=nGK4NeA6yxLc1weyQpFYZMrqUi3ivy+2UO+yNScnEseijwiIq21vEMLnYigeNN2xqm
         Yi6Qc1ylsTv2t0Iuok58JzuIduweJpCeJ1pmjZvwXXCKwnNoUWaG/dkE1v0p+ZLG3Mfp
         e1baudwOsKlH/fDwgBAxp8lf9bh/JLcEa+uruQgVKVdY99FIiVYvNBH4rqYDZtFR82al
         JY38xlhEi0kshEEl7eBwj3LgbiqJBijkOpZh9ODqFwQVPDHpDsnX+AeNlaVsFgqUYTap
         ypGZlUzgHzB52a8WMmkq6tkBQpthITzwz5WNifkBD0MTR7pdWkk4JU+w1ROT5lyTkSgK
         Yzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hc2gcVksXzTr1IYZOTogrbXgKL8dWeh0/s29AyPzQmQ=;
        b=XXTBYQzuTf0Q8jt3P2zPaTZvP9q32INu1xckIHS6JDixTAvemiGGWMhb6t8k6M9w7C
         WjEjCNHb4Y2GoFkQDXUY5q4IZdFwBQ0yligPcwp3N0x8GMFYj1BXra0HVOgg+WMb+eLJ
         OVIVrraAiDvOk7wqP8i+4L9Oe0puU6Tq8HYh+yKju0hCYBKbeZZ+Royv7JIJGchpdxl8
         aK43uv4J/udDUX1wKflXc2WmD4DEFIh95uW8WFpyTxLQokzNx/niO5/bu/QZkzVvmoo5
         WThPhjw37YCySCYVkQ480dH6+XWKyCvpz4XrmMaondjH+NpcG7KkCvV/fIqGeJ7mRcpd
         nL/A==
X-Gm-Message-State: AOAM533rSLiOaYipRAC7B+0NMDBYfRVtD9vrszm0sEjgAT7fzjkxteiq
        Y5pnoMunWZMCLhzMrRhWyFHBJowhmYFh92cE2HozkA==
X-Google-Smtp-Source: ABdhPJxs82rjOaFEEVNEFjggRcMRuAgzhuR+/VhLAeGrIKZ+wPbbkII2xn5iYSx51JVsk55zn+AngBAngaE4OnGx1lU=
X-Received: by 2002:a05:6512:1107:: with SMTP id l7mr3883353lfg.80.1630611915246;
 Thu, 02 Sep 2021 12:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com> <YTEkuXQ1cNhPoqP1@google.com>
In-Reply-To: <YTEkuXQ1cNhPoqP1@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 2 Sep 2021 12:45:02 -0700
Message-ID: <CAOQ_QshZCNACJy2f-jJL=U8+NROp1DoM3KXcN_3z5kE4h2JY7Q@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] KVM: x86: Add idempotent controls for migrating
 system counter state
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 2, 2021 at 12:23 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Aug 16, 2021, Oliver Upton wrote:
> > Applies cleanly to kvm/queue.
> >
> > Parent commit: a3e0b8bd99ab ("KVM: MMU: change tracepoints arguments to kvm_page_fault")
>
> This needs a rebase, patch 2 and presumably patch 3 conflict with commit
> 77fcbe823f00 ("KVM: x86: Prevent 'hv_clock->system_time' from going negative in
> kvm_guest_time_update()").

Thanks for the heads up! I've been hands-off with this series for a
bit, as I saw Paolo was playing around with it to fold it with his
pvclock locking changes (branch kvm/paolo). I'll pick up your
suggestions and get another series out with Paolo's additions.

--
Thanks,
Oliver

> > v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com
> >
> > v6 -> v7:
> >  - Separated x86, arm64, and selftests into different series
> >  - Rebased on top of kvm/queue
> >
> > Oliver Upton (6):
> >   KVM: x86: Fix potential race in KVM_GET_CLOCK
> >   KVM: x86: Create helper methods for KVM_{GET,SET}_CLOCK ioctls
> >   KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
> >   KVM: x86: Take the pvclock sync lock behind the tsc_write_lock
> >   KVM: x86: Refactor tsc synchronization code
> >   KVM: x86: Expose TSC offset controls to userspace
> >
> >  Documentation/virt/kvm/api.rst          |  42 ++-
> >  Documentation/virt/kvm/devices/vcpu.rst |  57 ++++
> >  Documentation/virt/kvm/locking.rst      |  11 +
> >  arch/x86/include/asm/kvm_host.h         |   4 +
> >  arch/x86/include/uapi/asm/kvm.h         |   4 +
> >  arch/x86/kvm/x86.c                      | 362 +++++++++++++++++-------
> >  include/uapi/linux/kvm.h                |   7 +-
> >  7 files changed, 378 insertions(+), 109 deletions(-)
> >
> > --
> > 2.33.0.rc1.237.g0d66db33f3-goog
> >
