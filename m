Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7F53F0EC4
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 01:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhHRXqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 19:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbhHRXqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 19:46:16 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6DFC061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:45:41 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso1326706otp.1
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RUnnHp2x6lac/DuEMi/Ec/ZO7YztuXo/kC0FCIAI+cE=;
        b=pFwsYB6alvFxzdLLmzs543UtNK3LbQIJ5FZBBo85ZtiQJTSRlfXo0lSZxF0M31zubk
         dYs32c0VU8doW/YlySEIryI7DKNxYndVq8YBuASLGZ4YkcdSXpnJ6iTAQaj0vS755VEh
         ISEr+RmDG+8FtD730Mh34x8rC/3yMvUXKfGt2kTXIB06EW7u3g+nxMJKnqRX374C5Q00
         N9Tx9Aik2i+fLhSraH3whIJ0+lZr1Dfx00rmDWOZJNRKkOp+vXtvI+747yQo8XyNnA8y
         3SV0RFryNum67YR4DQM00gZSoRqSdNMb3nkAiy0rG/GuoOctJeeL0mZ12sES7AG8Wr+L
         PUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RUnnHp2x6lac/DuEMi/Ec/ZO7YztuXo/kC0FCIAI+cE=;
        b=VTqK5x0/4vEtoMPwLNjRGfYutyijTHpPpnp1Q0nRCaWZ4uEMg7FGafqHmgc0qlEc/3
         wRY46414vyPXqjLZr2xrC++gTlH/K+QiHedXteeGqxQxptkXsYxSiKlizG550gLRO4ZJ
         9R+PjWd3eckFzAQa8NhXBscvHa09qRGxGsjrkdDIlG4fDluE8XorfkmL5WEOp6tS4JmI
         t9l1HEdHyp2GRAiqW3Bx0pNJXHH+VBhBD4HvLyoHp/cyl2TGRtHRsRyY7/x+O9SByJuk
         ez1Yhf0rcOtdFj8Q+Ho/a9JW21PXvQGs2ghFGwqXrfJvpdM6nwUQdashI0xHr5eQeHhG
         XKCQ==
X-Gm-Message-State: AOAM5310ne0+J8Cc4pfJAdBv6S05LlaI3RezPEWCnMyLhzVaXEMOZilT
        jxY+UXz7lsjtq/okuBzaPUQVQjipnnF6rYocrQelyA==
X-Google-Smtp-Source: ABdhPJwsxFVj+NGviAMqkb+rpbwB/W4heCrPPBRLy8HN+yzUdYeFidJ/KZ4YujKaAU2YKimMLCSO/WRZTym1exvMFN4=
X-Received: by 2002:a9d:76d0:: with SMTP id p16mr9222545otl.241.1629330340057;
 Wed, 18 Aug 2021 16:45:40 -0700 (PDT)
MIME-Version: 1.0
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
 <YRvbvqhz6sknDEWe@google.com> <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
 <YR2Tf9WPNEzrE7Xg@google.com>
In-Reply-To: <YR2Tf9WPNEzrE7Xg@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 18 Aug 2021 16:45:28 -0700
Message-ID: <CALMp9eQnq9RDQiRmfOge52Yx8SCM5D2nAM-0bcqaGJQJXvgfDA@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write respects
 field existence bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 4:11 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Aug 18, 2021, Robert Hoo wrote:
> > > Limiting this to VMREAD/VMWRITE means we shouldn't need a bitmap and
> > > can use a more static lookup, e.g. a switch statement.
> > Emm, hard for me to choose:
> >
> > Your approach sounds more efficient for CPU: Once VMX MSR's updated, no
> > bother to update the bitmap. Each field's existence check will directly
> > consult related VMX MSR. Well, the switch statement will be long...
>
> How long?  Honest question, off the top of my head I don't have a feel for how
> many fields conditionally exist.
>
> > My this implementation: once VMX MSR's updated, the update needs to be
> > passed to bitmap, this is 1 extra step comparing to aforementioned
> > above. But, later, when query field existence, especially the those
> > consulting vm{entry,exit}_ctrl, they usually would have to consult both
> > MSRs if otherwise no bitmap, and we cannot guarantee if in the future
> > there's no more complicated dependencies. If using bitmap, this consult
> > is just 1-bit reading. If no bitmap, several MSR's read and compare
> > happen.
>
> Yes, but the bitmap is per-VM and likely may or may not be cache-hot for back-to-back
> VMREAD/VMWRITE to different fields, whereas the shadow controls are much more likely
> to reside somewhere in the caches.
>
> > And, VMX MSR --> bitmap, usually happens only once when vCPU model is
> > settled. But VMRead/VMWrite might happen frequently, depends on guest
> > itself. I'd rather leave complicated comparison in former than in
> > later.
>
> I'm not terribly concerned about the runtime performance, it's the extra per-VM
> allocation for something that's not thaaat interesting that I don't like.
>
> And for performance, most of the frequently accessed VMCS fields will be shadowed
> anyways, i.e. won't VM-Exit in the first place.
>
> And that brings up another wrinkle.  The shadow VMCS bitmaps are global across
> all VMs, e.g. if the preemption timer is supported in hardware but hidden from
> L1, then a misbehaving L1 can VMREAD/VMWRITE the field even with this patch.
> If it was just the preemption timer we could consider disabling shadow VMCS for
> the VM ifthe timer exists but is hidden from L1, but GUEST_PML_INDEX and
> GUEST_INTR_STATUS are also conditional :-(
>
> Maybe there's a middle ground, e.g. let userspace tell KVM which fields it plans
> on exposing to L1, use that to build the bitmaps, and disable shadow VMCS if
> userspace creates VMs that don't match the specified configuration.  Burning
> three more pages per VM isn't very enticing...
>
> This is quite the complicated mess for something I'm guessing no one actually
> cares about.  At what point do we chalk this up as a virtualization hole and
> sweep it under the rug?

Good point! Note that hardware doesn't even get this right. See
erratum CF77 in
https://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/xeon-e7-v2-spec-update.pdf.
I'd cut and paste the text here, but Intel won't allow that.
