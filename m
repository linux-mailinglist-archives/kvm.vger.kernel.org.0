Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC738F727
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 00:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbfHOWoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 18:44:14 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40269 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731244AbfHOWoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 18:44:14 -0400
Received: by mail-io1-f67.google.com with SMTP id t6so2491003ios.7
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 15:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vYnRzQCzvJ6xVXV2Ir1Hss3qYL4NFdJMHTD/1znFY/I=;
        b=BHhn6KR+iQBO+RV5M6r9plg4YfokvrcpZXaqT43MgnviIOPlDKwyAt/ztjC5rAgLwS
         KXbt6d5sEFNyyTI1G11Zj7q9I7iDhNJ999ryYw4c0l05AaTYDwMGI6pUskjLyhK9CGnJ
         eyaZXdrD0xazF2xEz9HdEQ1/ThzXuHBiHfbouZcPgVGhqvQsgkfM2QCuZEagYkjucT++
         XxTGbbf3gXWvUHvv4httOjttDVK5xL1q3I5CG7JqHJ/3oQ6nXPv4KCDhwBk3RD1YonlH
         mfnEAaHl2HpJsZl8L3aZUHt4+X0hp2pj9EIolkdsbuZznrbHEkyWf41s4eBI6JaqugtI
         m9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vYnRzQCzvJ6xVXV2Ir1Hss3qYL4NFdJMHTD/1znFY/I=;
        b=ZSCsGB+JUCQfEstHOAVY8/4AeC+JHV5ehY7LDX72FtGVsY/f/kpqViJtHVXk53Mfur
         RHZV+LYnT9UeRU/zFDNb/Sue8GiGmcSNBvZBU2HhJ/q6a7+CuOPLj3shPAK4bC6Wt7bE
         nbehHcSVOb3F9HDz2a2IC4JMiUKpqgBzcB4ay1fODvNRWTNQTBwtEx+e5dCKOFgM3PNO
         xWGj03rgABBISeA8Bp2+/sKkvM8l7qKRn0JzHNzhvBekf488Sy7DDHo8o7Ae+1SVnYbx
         0MyvDH/J1H9JgS368uBDygaOjvmpVl3w1sWcHyVMJ21DD2l0mx87LDNbGZB/4yQJzbDY
         PSLw==
X-Gm-Message-State: APjAAAWAb3yfu04UoP51ecEJyidzdH9ZrzD5ZKDtke/E8v5qzQahX3tq
        1mSws0YnW25bW02TCfcX8H3hDvGPfZKvZVpV4kWLjNkKiQNqNg==
X-Google-Smtp-Source: APXvYqwRssW3qg+SL3tM24HVuvjcOuCx9YwImmi37/ZIQBAce8v2eHi5CA7H4bniol3RSxq3w4XWUtc3GA+vR9giDFM=
X-Received: by 2002:a6b:f906:: with SMTP id j6mr8008057iog.26.1565909052649;
 Thu, 15 Aug 2019 15:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com> <20190424231724.2014-7-krish.sadhukhan@oracle.com>
In-Reply-To: <20190424231724.2014-7-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 15 Aug 2019 15:44:01 -0700
Message-ID: <CALMp9eR8u6qPF5Gv-UEXSmB9NX=H=AGb4jh4d=mEm7jyTqBfWg@mail.gmail.com>
Subject: Re: [PATCH 6/8][KVM nVMX]: Load IA32_PERF_GLOBAL_CTRL MSR on vmentry
 of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 24, 2019 at 4:43 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "Loading Guest State" in Intel SDM vol 3C, the
> IA32_PERF_GLOBAL_CTRL MSR is loaded on vmentry of nested guests:
>
>     "If the =E2=80=9Cload IA32_PERF_GLOBAL_CTRL=E2=80=9D VM-entry control=
 is 1, the
>      IA32_PERF_GLOBAL_CTRL MSR is loaded from the IA32_PERF_GLOBAL_CTRL
>      field."
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index a7bf19eaa70b..8177374886a9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2300,6 +2300,10 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, s=
truct vmcs12 *vmcs12,
>         vcpu->arch.cr0_guest_owned_bits &=3D ~vmcs12->cr0_guest_host_mask=
;
>         vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits=
);
>
> +       if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CT=
RL)
> +               vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
> +                            vmcs12->guest_ia32_perf_global_ctrl);
> +
>         if (vmx->nested.nested_run_pending &&
>             (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT)) {
>                 vmcs_write64(GUEST_IA32_PAT, vmcs12->guest_ia32_pat);
> --
> 2.17.2
>

This isn't quite right. The GUEST_IA32_PERF_GLOBAL_CTRL value is just
going to get overwritten later by atomic_switch_perf_msrs().

Instead of writing the vmcs12 value directly into the vmcs02, you
should call kvm_set_msr(), exactly as it would have been called if
MSR_CORE_PERF_GLOBAL_CTRL had been in the vmcs12
VM-entry MSR-load list. Then, atomic_switch_perf_msrs() will
automatically do the right thing.
