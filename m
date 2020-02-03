Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAEC3150623
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 13:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgBCM0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 07:26:06 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44465 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgBCM0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 07:26:05 -0500
Received: by mail-ot1-f67.google.com with SMTP id h9so13373704otj.11;
        Mon, 03 Feb 2020 04:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FTCmDQysPO2gEhLvRlu7l+eCldmNVtgMTfK/8SOuiPM=;
        b=nDKbYV6uLewDDeqqtQtLza9EvsovQ7dTpZoqlikdkjx+2dGD7U9IgOCA53Zt8jkjaW
         B9335Rfk4p0quSJrTdgyNQBT8EtMnu9xPRwi99FO9QyAQuHgQlQChej3yMsYrkaiEjiG
         mnaD39diqcN1X6vzeRZBB7NOnZGfwkQqHmpw3UUWPnvUab+9IOqhp2bUvV2QyA/kjRO7
         QFFf35i7+dEJXW++VqEanbYTun9GkBbtPY9ABt7fgljTImboi3KtRwbEENoRdQ61Mm/h
         I/c55CZ1poNhc26OU0x+oFq9P3o+oYSsZ5cZVsgD862BiaHoZiVYg45LsmdF2Cc8OqYB
         37gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FTCmDQysPO2gEhLvRlu7l+eCldmNVtgMTfK/8SOuiPM=;
        b=HUFlFUNY09PGvcSDTr5Q9/hhrPd2QvFaDo8LJri+7szZHnKYHXbH/5BLJbR4moH+bz
         FBDVSrTU4Cy9Px4eCQKtuVGNTuSziKozIufc7CGvqf9s+CQOAaJ+WPy1Cbrti9l/TG9N
         +i2VucUQzUVMuZhvFU6ATXUY/96iWEeHWl2F581Fzcbyo8oJ7FI4wOUmmkOg4Cq6cDyI
         /2d0N23CZblLjkYjm2MFkUZof5yftKBvuz5+M4ZRotamI9NHBuC9i4Yzv+RSULulv7cW
         p6mAVAJ/xpkV1p2ru3Zw6UKve7kr8smwkyC/5jBzSvAUo3rRKVkS+9BMhP3ON2uuX8P2
         Nung==
X-Gm-Message-State: APjAAAV1Y0HMFsQ7kEqza7a5Fo4H4Tt35AXlYFINDZQXnQkZ6Hqrof7H
        /6p8WOtMPOC//xIs3uHQI1ossYPw/sO+XyMLcpU=
X-Google-Smtp-Source: APXvYqwqNc7jOW4X1o9vw1ucUUo0i6FaeyP/isUi3gky2P0yJQVAdgjhhxeql3xNfsaov7xDKy9wb520FK9KJHBcdBk=
X-Received: by 2002:a05:6830:1:: with SMTP id c1mr16142470otp.254.1580732764862;
 Mon, 03 Feb 2020 04:26:04 -0800 (PST)
MIME-Version: 1.0
References: <20200131155655.49812-1-cascardo@canonical.com>
 <87wo94ng9d.fsf@vitty.brq.redhat.com> <20200203101514.GG40679@calabresa>
In-Reply-To: <20200203101514.GG40679@calabresa>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 3 Feb 2020 20:25:53 +0800
Message-ID: <CANRm+CyMmuBYjVh4dK4GQBw7iYu1KEHRMDBmnUn3jLKxzU2h+g@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: do not setup pv tlb flush when not paravirtualized
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Feb 2020 at 18:31, Thadeu Lima de Souza Cascardo
<cascardo@canonical.com> wrote:
>
> On Mon, Feb 03, 2020 at 10:59:10AM +0100, Vitaly Kuznetsov wrote:
> > Thadeu Lima de Souza Cascardo <cascardo@canonical.com> writes:
> >
> > > kvm_setup_pv_tlb_flush will waste memory and print a misguiding message
> > > when KVM paravirtualization is not available.
> > >
> > > Intel SDM says that the when cpuid is used with EAX higher than the
> > > maximum supported value for basic of extended function, the data for the
> > > highest supported basic function will be returned.
> > >
> > > So, in some systems, kvm_arch_para_features will return bogus data,
> > > causing kvm_setup_pv_tlb_flush to detect support for pv tlb flush.
> > >
> > > Testing for kvm_para_available will work as it checks for the hypervisor
> > > signature.
> > >
> > > Besides, when the "nopv" command line parameter is used, it should not
> > > continue as well, as kvm_guest_init will no be called in that case.
> > >
> > > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > > ---
> > >  arch/x86/kernel/kvm.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > index 81045aabb6f4..d817f255aed8 100644
> > > --- a/arch/x86/kernel/kvm.c
> > > +++ b/arch/x86/kernel/kvm.c
> > > @@ -736,6 +736,9 @@ static __init int kvm_setup_pv_tlb_flush(void)
> > >  {
> > >     int cpu;
> > >
> > > +   if (!kvm_para_available() || nopv)
> > > +           return 0;
> > > +
> > >     if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
> > >         !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> > >         kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> >
> > The patch will fix the immediate issue, but why kvm_setup_pv_tlb_flush()
> > is just an arch_initcall() which will be executed regardless of the fact
> > if we are running on KVM or not?
> >
> > In Hyper-V we setup PV TLB flush from ms_hyperv_init_platform() -- which
> > only happens if Hyper-V platform was detected. Why don't we do it from
> > kvm_init_platform() in KVM?
> >
> > --
> > Vitaly
> >
>
> Because we can't call the allocator that early.
>
> Also, see the thread where this was "decided", the v6 of the original patch:
>
> https://lore.kernel.org/kvm/20171129162118.GA10661@flask/

A little change to this function.
https://lore.kernel.org/kvm/CANRm+CwK0Cg45mktda9Yz9fsjPCvtuB8O+fma5L3tV725ki1qw@mail.gmail.com
Testing is a great appreciated. (Still in vacation)

    Wanpeng
