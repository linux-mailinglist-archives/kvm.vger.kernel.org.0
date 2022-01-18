Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FEE492C8B
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347393AbiARRjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbiARRi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 12:38:59 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1C0C061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:38:59 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id s30so73782248lfo.7
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UzlrOGbM3/i25HF9kxgFYG8fQh3xST+SUp2bScetCNs=;
        b=UxDt7Ia9CQAlB7JNoP/uQF5lslId4ANkCtHAs1PNTu0ugKraVrjPy0lzz2qfaItpML
         ejGyBiOAV7NhvTyzLd/Kw2LzOrTPqqmDy2vyvke71BfyCkxcv0d7rIj6Gc1vNuB+DcH2
         3MBtnAb2+95hJBbutt27/UljuOWkbAFNJ8e1xUNW8KYozjETa9tFhdBvTb4SCDjVvKql
         5t3dohh/mc98yiBsihzoPDSkLmM0dooa2qW9CU15jhDHvKU+bKKwyfa0GCT0aPEYApvA
         gTnlh8p8Z87UbiPhGTULtHwYwlsUGIMhZjaqaukRD7aihbQ9Foj6neXpVXWJrCZ05i6q
         9EwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UzlrOGbM3/i25HF9kxgFYG8fQh3xST+SUp2bScetCNs=;
        b=yquiG6cDNPqnGXTJkvm8EnQFGmIPQnkBLUqM+F3p9G6gD9ES/gYOq3sy8D5VB/mi9w
         2ITkRoRMGxijkgCu/gss1PNQTyKvA6PJJGJryJ1cm12Q3d11Mqkwz+eYaAjtFYVhpvDc
         5qkm9gUfmED/no2fzj2/c4MDV86C/nhLMmGLTylMSV44sLTY2z8HXaSPyEG4LpxnWU/W
         Tq+8iLnxwamRllvC5LAEHjfsuZlgIXwgagAh1/7hz8ZkxXGbsx3SCDYMBhyZ+5qXrRVU
         tGNcYTeBelUryk4++KHmh1dk0kUwiYturg43GJWasfHbpsnHDpicyrOOTx4tK5TTdujS
         Ou7g==
X-Gm-Message-State: AOAM531LfKvKD7Fy3e1k02Pmw/TsVKg75JKLI0yCEEiBsAuaO0ya7oRE
        30MMrLdKl8LMv2Fr04VO4hjQhByOp2oPgfqFpvMMIQ==
X-Google-Smtp-Source: ABdhPJyFZm6OmY+XeePTMZECMoe/2/Ytqolr1Q/B0bvcywrG5ceq/UZuLn9Z/QhTRFzd4v4kwwD8hGLXbvshHY8v5u0=
X-Received: by 2002:a19:c505:: with SMTP id w5mr23275838lfe.518.1642527537482;
 Tue, 18 Jan 2022 09:38:57 -0800 (PST)
MIME-Version: 1.0
References: <20220113233020.3986005-1-dmatlack@google.com> <aadbee28-054b-ddac-6b99-f7ee63e19d7c@redhat.com>
In-Reply-To: <aadbee28-054b-ddac-6b99-f7ee63e19d7c@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 18 Jan 2022 09:38:30 -0800
Message-ID: <CALzav=cs7wz3K4jaqF30BHzfwA1qF2M13SQkap81uG8cpW9xzg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: x86/mmu: Fix write-protection bug in the TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 17, 2022 at 9:59 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 1/14/22 00:30, David Matlack wrote:
> > While attempting to understand the big comment in
> > kvm_mmu_slot_remove_write_access() about TLB flushing, I discovered a
> > bug in the way the TDP MMU write-protects GFNs. I have not managed to
> > reproduce the bug as it requires a rather complex set up of live
> > migrating a VM that is using nested virtualization while the TDP MMU is
> > enabled.
> >
> > Patch 1 fixes the bug and is CC'd to stable.
> > Patch 2-3 fix, document, and enforce invariants around MMU-writable
> > and Host-writable bits.
> > Patch 4 fixes up the aformentioned comment to be more readable.
> >
> > Tested using the kvm-unit-tests and KVM selftests.
> >
> > v2:
> >   - Skip setting the SPTE when MMU-writable is already clear [Sean]
> >   - Add patches for {MMU,Host}-writable invariants [Sean]
> >   - Fix inaccuracies in kvm_mmu_slot_remove_write_access() comment [Sean]
> >
> > v1: https://lore.kernel.org/kvm/20220112215801.3502286-1-dmatlack@google.com/
> >
> > David Matlack (4):
> >    KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU
> >    KVM: x86/mmu: Clear MMU-writable during changed_pte notifier
> >    KVM: x86/mmu: Document and enforce MMU-writable and Host-writable
> >      invariants
> >    KVM: x86/mmu: Improve TLB flush comment in
> >      kvm_mmu_slot_remove_write_access()
> >
> >   arch/x86/kvm/mmu/mmu.c     | 31 ++++++++++++++++++++--------
> >   arch/x86/kvm/mmu/spte.c    |  1 +
> >   arch/x86/kvm/mmu/spte.h    | 42 ++++++++++++++++++++++++++++++++------
> >   arch/x86/kvm/mmu/tdp_mmu.c |  6 +++---
> >   4 files changed, 62 insertions(+), 18 deletions(-)
> >
> >
> > base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
>
> Queued, thanks.

Thanks Paolo.

Patches 1 and 4 had some wordsmithing suggestions from Sean that I
think would be worth taking. I'm fine if you want to fold his
suggestions directly into the queued patches or I can resend.

The feedback on Patch 3 would require a follow-up series to address,
which I can handle separately.

>
> Paolo
>
