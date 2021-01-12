Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEA12F3950
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 20:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392489AbhALS71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbhALS7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:59:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C7E523122
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610477923;
        bh=Jkxzx/dOR0c5k8NGl3pEzAS/bD9tAjrYe/YXEoyBaoA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pBVhWwGsrmptpBZKz2FMSC7b3zKTjBlNfsL5JPfaC5MmR/QLEGQhNoQEc+FKglEe0
         faQzMmYZob7a3ckCXfBeTfpiVm87OPKn2iszMI18SZuZt5+1tPDoKBxVd4aV7k86c8
         4e8LRAXkVH1xmiIS0HZM0M+DkVkCp/hAgUtEjNZEzhqDVgQfRAiegGZkqCiEEK6c0P
         DLIz5P3IxCVYEBk2Y7SIXk7Nc/8GkTa9eU0dosDm9VUVXTLONb5LjwN83TscAhFC/x
         aXRJhAlgILMLzc2rxrmZmfKd4YayxJyovPQx0ovvRKc5iJJjtfiEGpuHPDrivzR3Ww
         VafDQQVIDz6zw==
Received: by mail-ej1-f50.google.com with SMTP id jx16so4981147ejb.10
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:58:43 -0800 (PST)
X-Gm-Message-State: AOAM531yS7MrKc+nyPFCqDkGELa/s12LSDryjsEiJxYbZzrPe9kk1IB7
        go3dSWOLKd+tuk/wKjC1pzRXBEiG5mUoVGPKi3Lv0Q==
X-Google-Smtp-Source: ABdhPJyg9N6zufAtosZsX+Dg846jKSeXYkJVBLiP0AQ389v4U5jB6JPQvtC54wdOWyJVn3euUfKe8LzqWLxQ1ZT4EFM=
X-Received: by 2002:a17:906:410e:: with SMTP id j14mr158592ejk.253.1610477921736;
 Tue, 12 Jan 2021 10:58:41 -0800 (PST)
MIME-Version: 1.0
References: <20210112063703.539893-1-wei.huang2@amd.com> <X/3eAX4ZyqwCmyFi@google.com>
 <X/3jap249oBJ/a6s@google.com>
In-Reply-To: <X/3jap249oBJ/a6s@google.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 12 Jan 2021 10:58:29 -0800
X-Gmail-Original-Message-ID: <CALCETrXsNBmXg8C4Tmz4YgTSAykKoWFHgXHFFcK-C65LUQ0r4w@mail.gmail.com>
Message-ID: <CALCETrXsNBmXg8C4Tmz4YgTSAykKoWFHgXHFFcK-C65LUQ0r4w@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Bandan Das <bsd@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 9:59 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 12, 2021, Sean Christopherson wrote:
> > On Tue, Jan 12, 2021, Wei Huang wrote:
> > > From: Bandan Das <bsd@redhat.com>
> > >
> > > While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
> > > CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
> > > before checking VMCB's instruction intercept.
> >
> > It would be very helpful to list exactly which CPUs are/aren't affected, even if
> > that just means stating something like "all CPUs before XYZ".  Given patch 2/2,
> > I assume it's all CPUs without the new CPUID flag?
>
> Ah, despite calling this an 'errata', the bad behavior is explicitly documented
> in the APM, i.e. it's an architecture bug, not a silicon bug.
>
> Can you reword the changelog to make it clear that the premature #GP is the
> correct architectural behavior for CPUs without the new CPUID flag?

Andrew Cooper points out that there may be a nicer workaround.  Make
sure that the SMRAM and HT region (FFFD00000000 - FFFFFFFFFFFF) are
marked as reserved in the guest, too.

--Andy
