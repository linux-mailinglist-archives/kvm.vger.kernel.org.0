Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13CE48B612
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 19:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350133AbiAKSrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 13:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243059AbiAKSrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 13:47:40 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8BFC06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 10:47:39 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so551849pjp.0
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 10:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=yFm/72khGOzDGuFloPTXkx3ofKp3oHgAX0/2+vtRUTk=;
        b=sn0bbmgBLIT8J2GNU/KU/vX4gMqD6KD09hpw9IfuryBzjMFsACaoyGKgcKxk7bNqCG
         v9smN74s601Lc/u3FY91Ksm+/SmsZ6sToA+saQ9/vETOSDwF6oOKJi7+FpTDeQDWZ5RS
         A8aFeaM5tjpqRaQpaLuD33zOJ9hNTwGcF2Tp/s1ss6dBGNSfUkIQpkjoFgNWXU38Lw6c
         Vyq6Pe6GuwdzDM2F3LfabeZLQGBcbz35FWNdhDkkvi9PGCvtelJWPWOQ64HtHuc0cJgI
         OrPiw/RSK3I/Mwoq64ZWGMKYdFmZ9jZ5A1AAJFsgHFUfIAhxrQbDQQfw6cBi03htD6Ww
         ssRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=yFm/72khGOzDGuFloPTXkx3ofKp3oHgAX0/2+vtRUTk=;
        b=u12W4R07ExG6lv3jGFxk6DgO90q46Eik7QGSic981eLTG4Mqwru3Bwwxivhl76MlvR
         WM7pffON8CmQDC25POGCnev5LRL18JZWHfETrvG7zaRGj5BW92Hdm3GEpdDSMWTS6hte
         zgWl/eZusBB6bBt+e2WZ/t6M6A5j/Pq6aWw1huEYHUf9hEPiua1z+wYuoVhwhsl4etkW
         4Gm8jqEWN63f3g1YI15pGz9cRbKjAouM8f5h1MtopmuHU4iHfWvVTnZeRHCWo19Z5Y31
         cLUeEqK7xHiAyZiL9o+bUNsJ4XbgVSLMtQl8kZAYwjNiSqHnTJwrqCNHv+njr7eeZUhX
         qoYA==
X-Gm-Message-State: AOAM533jgBVbwElAOGqi/mbD0A+rzUvPfW3jPQRYtFIPdjhmvE0wdxt/
        O8TG1jNevHlgJ+jM4gk9+DB7cQ==
X-Google-Smtp-Source: ABdhPJz7UuyllrZ02SpHg/7DvQ1A/J0L4kgnQ0XK5dFo0rLp5b7Q1yCW4dVjmvp/v/qtDn88L83//A==
X-Received: by 2002:a05:6a00:2313:b0:4bb:8b68:3677 with SMTP id h19-20020a056a00231300b004bb8b683677mr6049563pfh.2.1641926859302;
        Tue, 11 Jan 2022 10:47:39 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id u64sm6233199pfb.208.2022.01.11.10.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:47:38 -0800 (PST)
Date:   Tue, 11 Jan 2022 10:47:38 -0800 (PST)
X-Google-Original-Date: Tue, 11 Jan 2022 10:47:12 PST (-0800)
Subject:     Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
In-Reply-To: <20220111153539.2532246-1-mark.rutland@arm.com>
CC:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup@brainfault.org,
        aou@eecs.berkeley.edu, Atish Patra <atishp@rivosinc.com>,
        benh@kernel.crashing.org, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, chenhuacai@kernel.org,
        dave.hansen@linux.intel.com, david@redhat.com,
        frankja@linux.ibm.com, frederic@kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, james.morse@arm.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        mark.rutland@arm.com, Marc Zyngier <maz@kernel.org>,
        mingo@redhat.com, mpe@ellerman.id.au, nsaenzju@redhat.com,
        paulmck@kernel.org, paulus@samba.org,
        Paul Walmsley <paul.walmsley@sifive.com>, pbonzini@redhat.com,
        seanjc@google.com, suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, Will Deacon <will@kernel.org>
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     mark.rutland@arm.com
Message-ID: <mhng-d83df857-7865-4514-a339-68439336974a@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jan 2022 07:35:34 PST (-0800), mark.rutland@arm.com wrote:
> Several architectures have latent bugs around guest entry/exit, most
> notably:
>
> 1) Several architectures enable interrupts between guest_enter() and
>    guest_exit(). As this period is an RCU extended quiescent state (EQS) this
>    is unsound unless the irq entry code explicitly wakes RCU, which most
>    architectures only do for entry from usersapce or idle.
>
>    I believe this affects: arm64, riscv, s390
>
>    I am not sure about powerpc.
>
> 2) Several architectures permit instrumentation of code between
>    guest_enter() and guest_exit(), e.g. KASAN, KCOV, KCSAN, etc. As
>    instrumentation may directly o indirectly use RCU, this has the same
>    problems as with interrupts.
>
>    I believe this affects: arm64, mips, powerpc, riscv, s390

Moving to Atish and Anup's new email addresses, looks like MAINTAINERS 
hasn't been updated yet.  I thought I remembering seeing patches getting 
picked up for these, but LMK if you guys were expecting me to send them 
along -- sorry if I misunderstood!

>
> 3) Several architectures do not inform lockdep and tracing that
>    interrupts are enabled during the execution of the guest, or do so in
>    an incorrect order. Generally
>    this means that logs will report IRQs being masked for much longer
>    than is actually the case, which is not ideal for debugging. I don't
>    know whether this affects the correctness of lockdep.
>
>    I believe this affects: arm64, mips, powerpc, riscv, s390
>
> This was previously fixed for x86 specifically in a series of commits:
>
>   87fa7f3e98a1310e ("x86/kvm: Move context tracking where it belongs")
>   0642391e2139a2c1 ("x86/kvm/vmx: Add hardirq tracing to guest enter/exit")
>   9fc975e9efd03e57 ("x86/kvm/svm: Add hardirq tracing on guest enter/exit")
>   3ebccdf373c21d86 ("x86/kvm/vmx: Move guest enter/exit into .noinstr.text")
>   135961e0a7d555fc ("x86/kvm/svm: Move guest enter/exit into .noinstr.text")
>   160457140187c5fb ("KVM: x86: Defer vtime accounting 'til after IRQ handling")
>   bc908e091b326467 ("KVM: x86: Consolidate guest enter/exit logic to common helpers")
>
> But other architectures were left broken, and the infrastructure for
> handling this correctly is x86-specific.
>
> This series introduces generic helper functions which can be used to
> handle the problems above, and migrates architectures over to these,
> fixing the latent issues.
>
> I wasn't able to figure my way around powerpc and s390, so I have not
> altered these. I'd appreciate if anyone could take a look at those
> cases, and either have a go at patches or provide some feedback as to
> any alternative approaches which work work better there.
>
> I have build-tested the arm64, mips, riscv, and x86 cases, but I don't
> have a suitable HW setup to test these, so any review and/or testing
> would be much appreciated.
>
> I've pushed the series (based on v5.16) to my kvm/entry-rework branch:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=kvm/entry-rework
>   git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git kvm/entry-rework
>
> ... also tagged as kvm-entry-rework-20210111
>
> Thanks,
> Mark.
>
> Mark Rutland (5):
>   kvm: add exit_to_guest_mode() and enter_from_guest_mode()
>   kvm/arm64: rework guest entry logic
>   kvm/mips: rework guest entry logic
>   kvm/riscv: rework guest entry logic
>   kvm/x86: rework guest entry logic
>
>  arch/arm64/kvm/arm.c     |  51 +++++++++++-------
>  arch/mips/kvm/mips.c     |  37 ++++++++++++--
>  arch/riscv/kvm/vcpu.c    |  44 ++++++++++------
>  arch/x86/kvm/svm/svm.c   |   4 +-
>  arch/x86/kvm/vmx/vmx.c   |   4 +-
>  arch/x86/kvm/x86.c       |   4 +-
>  arch/x86/kvm/x86.h       |  45 ----------------
>  include/linux/kvm_host.h | 108 +++++++++++++++++++++++++++++++++++++--
>  8 files changed, 206 insertions(+), 91 deletions(-)
