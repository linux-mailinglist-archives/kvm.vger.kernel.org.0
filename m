Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA2977ACE
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 19:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388044AbfG0RiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 13:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387856AbfG0RiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 13:38:17 -0400
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 409182085A
        for <kvm@vger.kernel.org>; Sat, 27 Jul 2019 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564249096;
        bh=kUWslRPU39oVlObLtgG3Hl8pm76FUT1cLz91UMA48ew=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RZCyy6gKHyjKvKUJjlqGamViQZCRDsV+acvbcEuofVU9B8hzZAdEB/H4cnHobpPwR
         PR0yvQHQb/YlLGvJQmyht1q9N9wniM3yxQfd/mdd2RUjT8UcSp5z9rt6DmOF3+KKxN
         yDb3Opss3OxfKY6/XBocj611pRRXj9B5ZQEcZSSw=
Received: by mail-wm1-f44.google.com with SMTP id u25so39738922wmc.4
        for <kvm@vger.kernel.org>; Sat, 27 Jul 2019 10:38:16 -0700 (PDT)
X-Gm-Message-State: APjAAAXYBHk4d77i7tgl1UKix5H2uy7VB4/gJysX3gpYBzGNcbqEa0Vz
        bZzuV5P+c7kn4KIRas0/nfM51Dzk/lUtudhVLUVmXQ==
X-Google-Smtp-Source: APXvYqz/y9qS7PXle2+Y7h5CA9LtEoMkB5vxXCCNxEHyrQDG/47qNC8Mg4ReFpz0N33XeD+HzMjP0b21IZQ3+VviJvA=
X-Received: by 2002:a1c:c5c2:: with SMTP id v185mr96261509wmf.161.1564249094779;
 Sat, 27 Jul 2019 10:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190727055214.9282-1-sean.j.christopherson@intel.com> <20190727055214.9282-9-sean.j.christopherson@intel.com>
In-Reply-To: <20190727055214.9282-9-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 27 Jul 2019 10:38:03 -0700
X-Gmail-Original-Message-ID: <CALCETrU_51Ae=F9HzUwsUuSkJ1or63p_eG+f3uKkBqFx=bheUA@mail.gmail.com>
Message-ID: <CALCETrU_51Ae=F9HzUwsUuSkJ1or63p_eG+f3uKkBqFx=bheUA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: x86: Add kvm_x86_ops hook to short circuit emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 26, 2019 at 10:52 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Similar to the existing AMD #NPF case where emulation of the current
> instruction is not possible due to lack of information, virtualization
> of Intel SGX will introduce a scenario where emulation is not possible
> due to the VMExit occurring in an SGX enclave.  And again similar to
> the AMD case, emulation can be initiated by kvm_mmu_page_fault(), i.e.
> outside of the control of the vendor-specific code.
>
> While the cause and architecturally visible behavior of the two cases
> is different,  e.g. Intel SGX will inject a #UD whereas AMD #NPF is a
> clean resume or complete shutdown, the impact on the common emulation
> code is identical: KVM must stop emulation immediately and resume the
> guest.
>
> Replace the exisiting need_emulation_on_page_fault() with a more generic
> is_emulatable() kvm_x86_ops callback, which is called unconditionally
> by x86_emulate_instruction().
>

Having recently noticed that emulate_ud() is broken when the guest's
TF is set, I suppose I should ask: does your new code function
sensibly when TF is set?

Also, anyone want to fix that emulate_ud() bug?  The test case is merged now:

# ./tools/testing/selftests/x86/syscall_arg_fault_32
[RUN]    SYSENTER with invalid state
[OK]    Seems okay
[RUN]    SYSCALL with invalid state
[SKIP]    Illegal instruction
[RUN]    SYSENTER with TF and invalid state
[OK]    Seems okay
[RUN]    SYSCALL with TF and invalid state
[WARN]    Got stuck single-stepping -- you probably have a KVM bug
