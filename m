Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453427CE51
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 22:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbfGaU2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 16:28:05 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:32863 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbfGaU2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 16:28:05 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so20352348iog.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 13:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dBGsm49OysEg7bHxsXfAQevchwfTyjC8ZOrR2juUMrM=;
        b=Q2Q5ZZvLyygWDWivclFZ/bbeT+uEMirhfkYAS8VsgPhwm33/Jc50fxvztwqBGotkl4
         Z77nFFONeALg1wxjQFQEPl5UoFIbBWWFs4S9nWN1EOgNVML9wAHPIIZQibmOIIzwDJz3
         if2AqAe6gOov1+C6pHUgExQbnR6eZzQ3t9F1GhfgnVBios2EmHYkB3loA3VHMkVMcBYK
         db7fMEI7Srk5UcuHSJku7GmxCP4WnpXaqwUJfvXX2eOWE7En4qRQS569NYYC20Z5nscq
         qV+0lUKrc8OxaEadG5SqiqKehkqy837x0fj+4KGHGek8q/RibYkZ32XYlvloXV18PUvY
         6Rfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dBGsm49OysEg7bHxsXfAQevchwfTyjC8ZOrR2juUMrM=;
        b=YZtpBZhjdDdLDdUeZ9vXKEn5xA9As7k1r71RzjYG6F9lhBYm751pgNlK8QLaH8difW
         c3MpplZMoRQDczAg4khGeiuWUIhSC3QPkTE40z2fBj+WzQLXutEp5LY1YmEKl24UebtF
         9NFMZRO5L+qTQdMt1tJWLwQSmjuvsvkxjuvhXapTbdk2mRuqraj3g1o7rQyJ03Q4vPEI
         t/mAAVjCdNp0NpHSyJp7u9HPmS3CLU3JkPecZv6FfoW4m67CjZ9FtT7DEy1Xa/dN62qn
         P3h7JdQ/HpCiUn7u3swacNpn/tNFFIwDbtONcEWStha8p6mK7ZHLUpYwErxiqBOfbT0V
         duCQ==
X-Gm-Message-State: APjAAAU9OfZxXM9Cb/1FYR8c6LrX9yhstMGyvbPWuQkNQ4mxk8Bm9G4D
        UZZ5YUQzggWaEStLNDdcpHqlnDsRRodWhaEf4jZtjQ==
X-Google-Smtp-Source: APXvYqyOzq7qMPN4kDm5eOtE9EWegyQb/wzIOUIkgNtV+zq8BKZKflp19YlrudQqhSU6vBVMkwR59UO5rIWIwtPEaWs=
X-Received: by 2002:a6b:6310:: with SMTP id p16mr241134iog.118.1564604884032;
 Wed, 31 Jul 2019 13:28:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-4-vkuznets@redhat.com>
 <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
 <87ftmm71p3.fsf@vitty.brq.redhat.com> <36a9f411-f90c-3ffa-9ee3-6ebee13a763f@redhat.com>
In-Reply-To: <36a9f411-f90c-3ffa-9ee3-6ebee13a763f@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 31 Jul 2019 13:27:53 -0700
Message-ID: <CALMp9eQLCEzfdNzdhPtCf3bD-5c6HrSvJqP7idyoo4Gf3i5O1w@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] x86: KVM: svm: clear interrupt shadow on all
 paths in skip_emulated_instruction()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 9:37 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/07/19 15:50, Vitaly Kuznetsov wrote:
> > Jim Mattson <jmattson@google.com> writes:
> >
> >> On Thu, Jun 20, 2019 at 4:02 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>>
> >>> Regardless of the way how we skip instruction, interrupt shadow needs to be
> >>> cleared.
> >>
> >> This change is definitely an improvement, but the existing code seems
> >> to assume that we never call skip_emulated_instruction on a
> >> POP-SS/MOV-to-SS/STI. Is that enforced anywhere?
> >
> > (before I send v1 of the series) I looked at the current code and I
> > don't think it is enforced, however, VMX version does the same and
> > honestly I can't think of a situation when we would be doing 'skip' for
> > such an instruction.... and there's nothing we can easily enforce from
> > skip_emulated_instruction() as we have no idea what the instruction
> > is...

Can't we still coerce kvm into emulating any instruction by leveraging
a stale ITLB entry? The 'emulator' kvm-unit-test did this before the
KVM forced emulation prefix was introduced, but I haven't checked to
see if the original (admittedly fragile) approach still works. Also,
for POP-SS, you could always force emulation by mapping the %rsp
address beyond guest physical memory. The hypervisor would then have
to emulate the instruction to provide bus-error semantics.

> I agree, I think a comment is worthwhile but we can live with the
> limitation.

I think we can live with the limitation, but I'd really prefer to see
a KVM exit with KVM_INTERNAL_ERROR_EMULATION for an instruction that
kvm doesn't emulate properly. That seems better than just a comment
that the virtual CPU doesn't behave as architected. (I realize that I
am probably in the minority here.)
