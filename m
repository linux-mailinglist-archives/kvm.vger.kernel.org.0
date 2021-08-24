Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489E33F6034
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 16:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhHXOYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 10:24:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237606AbhHXOYf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 10:24:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629815030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eaKLyjNYVTngBJTCQZRJWzBusqzdu0x0pJPgqNd0ExU=;
        b=HC2up+d/LPHm547ay1BEyx9UsJLFi/zTJTZjM/TKsmDyrTG1/mCxp7nF+8maVjDaROnt75
        gj6qvX7EDZIkuBDhlV+DIrHQqCYDj0mW5SaaSMO/qtWCA4pdYHWGBMJnD526Hr0tlh1qYJ
        d0S5SOccYo0jIXfimXEJXPp1OPZ5Ci8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-yiC8GcY0NDu6AV-WdHZ9eA-1; Tue, 24 Aug 2021 10:23:49 -0400
X-MC-Unique: yiC8GcY0NDu6AV-WdHZ9eA-1
Received: by mail-lf1-f69.google.com with SMTP id z26-20020a0565120c1a00b003cf39d5ed62so6186884lfu.16
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eaKLyjNYVTngBJTCQZRJWzBusqzdu0x0pJPgqNd0ExU=;
        b=QTczv19/Fx6wdvXIJ73foFTd9X/sAoelf+pQc1Hdk1mp8Ii8UKPPDuX49Xc6nOSpM6
         0QaUaJYzQh82Vka8azYuDNZGZPla2FSK1FPnIvimzQaD+narojV2D0HjNyjioJW4nAbM
         pVlTrq2GfVLC+b3mA0LXFAhHiYroAkf+IvvLNTGhob85rnMLpgGczCGIbpdHUWzhsIvf
         HX2nfqwsR5r7fy8IQD9qvn3EY5DvK7IyAYlQzJpV1Lrd/6yGcEyu1/aKh6yxt/GZPvx7
         yHOT/2pT66LOguoCvrq5QUO8+Wiqg+aaOaVLINN37qOzL3jXF3f5IQmuimlYePTrGyTb
         buBQ==
X-Gm-Message-State: AOAM531aZ53nPj2vRe5CSeT7WoSTo1UvR86tXvMIGS1eVnjLtetlEdqD
        fvIsWbhXwfoTh/qWNuG9J06nSGnM9Ce7+Ar10Wpyxt890UN7PK7GEJEN+NB+PRi4P1tZ5v5EK1R
        6aJ9HQc8JYLl9U1Ta3BwNIuZUSU55
X-Received: by 2002:a05:6512:21b1:: with SMTP id c17mr29522537lft.34.1629815027674;
        Tue, 24 Aug 2021 07:23:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqBcwBUKtfS96gz3cSbo4cZa2F2q9DeAxMRxLSLPa34KVfe28iJ/ILEaIZ8Byp1A3+/1L8Q21oBe7sOOnYHfs=
X-Received: by 2002:a05:6512:21b1:: with SMTP id c17mr29522524lft.34.1629815027394;
 Tue, 24 Aug 2021 07:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210823143028.649818-1-vkuznets@redhat.com> <20210823143028.649818-5-vkuznets@redhat.com>
 <20210823185841.ov7ejn2thwebcwqk@habkost.net> <87mtp7jowv.fsf@vitty.brq.redhat.com>
In-Reply-To: <87mtp7jowv.fsf@vitty.brq.redhat.com>
From:   Eduardo Habkost <ehabkost@redhat.com>
Date:   Tue, 24 Aug 2021 10:23:31 -0400
Message-ID: <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 3:13 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Eduardo Habkost <ehabkost@redhat.com> writes:
>
> > On Mon, Aug 23, 2021 at 04:30:28PM +0200, Vitaly Kuznetsov wrote:
> >> KASAN reports the following issue:
> >>
> >>  BUG: KASAN: stack-out-of-bounds in kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> >>  Read of size 8 at addr ffffc9001364f638 by task qemu-kvm/4798
> >>
> >>  CPU: 0 PID: 4798 Comm: qemu-kvm Tainted: G               X --------- ---
> >>  Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RYM0081C 07/13/2020
> >>  Call Trace:
> >>   dump_stack+0xa5/0xe6
> >>   print_address_description.constprop.0+0x18/0x130
> >>   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> >>   __kasan_report.cold+0x7f/0x114
> >>   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> >>   kasan_report+0x38/0x50
> >>   kasan_check_range+0xf5/0x1d0
> >>   kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> >>   kvm_make_scan_ioapic_request_mask+0x84/0xc0 [kvm]
> >>   ? kvm_arch_exit+0x110/0x110 [kvm]
> >>   ? sched_clock+0x5/0x10
> >>   ioapic_write_indirect+0x59f/0x9e0 [kvm]
> >>   ? static_obj+0xc0/0xc0
> >>   ? __lock_acquired+0x1d2/0x8c0
> >>   ? kvm_ioapic_eoi_inject_work+0x120/0x120 [kvm]
> >>
> >> The problem appears to be that 'vcpu_bitmap' is allocated as a single long
> >> on stack and it should really be KVM_MAX_VCPUS long. We also seem to clear
> >> the lower 16 bits of it with bitmap_zero() for no particular reason (my
> >> guess would be that 'bitmap' and 'vcpu_bitmap' variables in
> >> kvm_bitmap_or_dest_vcpus() caused the confusion: while the later is indeed
> >> 16-bit long, the later should accommodate all possible vCPUs).
> >>
> >> Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
> >> Fixes: 9a2ae9f6b6bb ("KVM: x86: Zero the IOAPIC scan request dest vCPUs bitmap")
> >> Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >>  arch/x86/kvm/ioapic.c | 10 +++++-----
> >>  1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> >> index ff005fe738a4..92cd4b02e9ba 100644
> >> --- a/arch/x86/kvm/ioapic.c
> >> +++ b/arch/x86/kvm/ioapic.c
> >> @@ -319,7 +319,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
> >>      unsigned index;
> >>      bool mask_before, mask_after;
> >>      union kvm_ioapic_redirect_entry *e;
> >> -    unsigned long vcpu_bitmap;
> >> +    unsigned long vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
> >
> > Is there a way to avoid this KVM_MAX_VCPUS-sized variable on the
> > stack?  This might hit us back when we increase KVM_MAX_VCPUS to
> > a few thousand VCPUs (I was planning to submit a patch for that
> > soon).
>
> What's the short- or mid-term target?

Short term target is 2048 (which was already tested). Mid-term target
(not tested yet) is 4096, maybe 8192.

>
> Note, we're allocating KVM_MAX_VCPUS bits (not bytes!) here, this means
> that for e.g. 2048 vCPUs we need 256 bytes of the stack only. In case
> the target much higher than that, we will need to either switch to
> dynamic allocation or e.g. use pre-allocated per-CPU variables and make
> this a preempt-disabled region. I, however, would like to understand if
> the problem with allocating this from stack is real or not first.

Is 256 bytes too much here, or would that be OK?

--
Eduardo

