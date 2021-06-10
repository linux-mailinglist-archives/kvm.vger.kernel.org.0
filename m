Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307E83A33AA
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 21:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFJTDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 15:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhFJTDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 15:03:20 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50ADCC061574
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 12:01:10 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id v17-20020a4aa5110000b0290249d63900faso143776ook.0
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 12:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WA35BnHu2dMi49s348S3VMHrNRoWHkr7W59D4SMZ5nM=;
        b=ViwF08Z07tkxiSHTzsYWuuVLHypyk6N1PniIVywgptSoMbxmOdODuwakI4BPNOfRMY
         lNmkVyP7WJqKtXOf0J9MrlzT1fMpppDi4GGznO1TVofTokaWfgXsN3rEFsdMElYuROQN
         VSe5x7pX5CrSoOCHqAQSThhdxmzR1uveJAf6QlUPdMru7S1oQF+szat5+RQKNwa0Iunt
         Xwhkae5HQ0/hg7uePb/vyAkfcbNcLsorCns3BDCFiOzhlXT0QcrZmkmuRsMdUfNeAH+E
         nGWGJc8g7e0TnpT8++/dja1Niaiy8dTiIYXUFTU1bfEupe8WjBSPodvbRTeEpQdML0R6
         HisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WA35BnHu2dMi49s348S3VMHrNRoWHkr7W59D4SMZ5nM=;
        b=g0DqGk8dQbaVFG04KZDIfX25ja/nsZ5E04OeMILBKc3MCmO+SCvRql9VjUXYgdZWXM
         52SIT3NQdpUoZ9tdNx59rtVWMVLD2rApKowDigGmrWkJC7eoRK3tuuvLVCTKlU5wfW5T
         2yH8J9GC2eSr7YEppV1SK/47LfpY3TJ4NZ37SSPoU0OQ9+PVxY8u32sGKwpluvfJHpVF
         YPiZHWjpodcTQ+URc6IfMqUZdiH2eJfqRHrum8NWU3+Tbf/qkwYk+KqyC99ZFPhPeSpx
         NcHcu7pmDV/RzJmnnNKHSwy39RXoTH/dB72eM3bkSsptdKb68h9+bH4TlMTeYu8yzRlw
         uHYw==
X-Gm-Message-State: AOAM531MwPLTzf6jiwzRvIEcGxhpFE8ASrx71Ld6AVDV7YwYahbjjQKf
        y4uoBQxg5a46LNXthyxkVvwJdcwDrfIxZI9gH3eJKQ==
X-Google-Smtp-Source: ABdhPJxqGoEs0CXtC6Ddpt0Fov7ayVHhZhL9tpLhV8Hpw/ZEk6FpjbZ8FY7bhqu24hVcUNFEUCLcD+MTw9cNnPGjNk4=
X-Received: by 2002:a4a:e4c1:: with SMTP id w1mr73314oov.81.1623351669414;
 Thu, 10 Jun 2021 12:01:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210609215111.4142972-1-jmattson@google.com> <8b4bbc8e-ee42-4577-39b1-44fb615c080a@oracle.com>
 <CALMp9eRvOFAnSCmXR9DWdWv9hzpOFjMXoo6a2Sd-bRBO3wnd-Q@mail.gmail.com> <e58c19b4-fb4e-04cc-fa58-43d3dfddf5d6@oracle.com>
In-Reply-To: <e58c19b4-fb4e-04cc-fa58-43d3dfddf5d6@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 10 Jun 2021 12:00:58 -0700
Message-ID: <CALMp9eRo5FRx7AHOxKGSV0ZVp2kt0AWdm19gKHeS5RkWdBgSHQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: LAPIC: Restore guard to prevent illegal APIC
 register access
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 9, 2021 at 7:45 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 6/9/21 6:48 PM, Jim Mattson wrote:
> > On Wed, Jun 9, 2021 at 5:45 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >>
> >> On 6/9/21 2:51 PM, Jim Mattson wrote:
> >>> Per the SDM, "any access that touches bytes 4 through 15 of an APIC
> >>> register may cause undefined behavior and must not be executed."
> >>> Worse, such an access in kvm_lapic_reg_read can result in a leak of
> >>> kernel stack contents. Prior to commit 01402cf81051 ("kvm: LAPIC:
> >>> write down valid APIC registers"), such an access was explicitly
> >>> disallowed. Restore the guard that was removed in that commit.
> >>>
> >>> Fixes: 01402cf81051 ("kvm: LAPIC: write down valid APIC registers")
> >>> Signed-off-by: Jim Mattson <jmattson@google.com>
> >>> Reported-by: syzbot <syzkaller@googlegroups.com>
> >>> ---
> >>>    arch/x86/kvm/lapic.c | 3 +++
> >>>    1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> >>> index c0ebef560bd1..32fb82bbd63f 100644
> >>> --- a/arch/x86/kvm/lapic.c
> >>> +++ b/arch/x86/kvm/lapic.c
> >>> @@ -1410,6 +1410,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> >>>        if (!apic_x2apic_mode(apic))
> >>>                valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
> >>>
> >>> +     if (alignment + len > 4)
> >> It will be useful for debugging if the apic_debug() call is added back in.
> > Are you suggesting that I should revert commit 0d88800d5472 ("kvm:
> > x86: ioapic and apic debug macros cleanup")?
>
>
> Oh, I wasn't aware that commit 0d88800d5472 had removed the debug
> macros.  The tracepoint in kvm_lapic_reg_read() fires after these error
> checks pass. A printk may be useful. Or perhaps move the tracepoint up ?

It sounds like you disagree with the claim in commit 0d88800d5472
("kvm: x86: ioapic and apic debug macros cleanup") that "kvm
tracepoints are enough for debugging." I'll let you argue that point
with Yi and Paolo separately, as it seems orthogonal to this change.

My personal opinion is that messages that get written to syslog are
next to useless. Unless the message goes out to userspace, I have no
way of getting the message to my end customers. Similarly, while
tracepoints may be useful for developers, they are useless in
production, and since I can't usually get my hands on a customer
workload to run in a development environment, tracepoints also have
quite limited usefulness.
