Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A5841CF7E
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 00:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347241AbhI2WxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 18:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346417AbhI2WxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 18:53:09 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210BDC061767
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 15:51:28 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id a3so4895824oid.6
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 15:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WU8/s6nJZiqD5ikoIrIIIMlSsQFbRRodZMrkDYnksts=;
        b=hncdGne2BieVpABEtTAeJVqRRcRcM5dL1EKjajKjDPYP7c7AXe4zyINvFForPlku5s
         MUs4BAfjombbizNyRC3Fg4vM2G1eOm6RB56RW+K8+3JM0cgWSMpBkwhpxl3TW+Rte4XT
         vxCbpbgELHVVKfiDjCe6Z30AWbvCi4JKxjSXjuTjPzSIHmbE8LkCNHwrc1sdwcrwO8bz
         AHZopxOYKz8vI4+dqtp9NB0zciG0m2s3yiQ7FussPTQigfB9QXhZbdipe57Apcg+NEp2
         Vwq1vja1ihLb+9RrCeVSkmOE2MNVSj+lb/+qkZGsWXIRDtNBnq6r+nN0Fcc2vBd/iwHp
         qfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WU8/s6nJZiqD5ikoIrIIIMlSsQFbRRodZMrkDYnksts=;
        b=M+4HqwOu9dp6k0NtmXpLenaBAyjZmSgZLw/82/BClQMCcnRm5gsn+1cE2SM1q20tSG
         uQF7j4p8yVE81vMU0ssyhhRflmsXbO8cTdf45Y6lymPs+T9cmoTjVxTesgCGzirl0zEw
         /01erYh28MAU2kkyxhPn3Axk+HtYfnpUakstb5I9+w36VnkY5Z4yB5xbzKQIzVearpTV
         H77VQyVxwBW5EI8/oKS/UfzpT8JSGs9EA86r9ToO41vI5EBkg5HuEntLXmb46isengQE
         289IBbdzcWUXMFZzLLbQvpHj0QW64ZRH7UDKd6hZSuZrMwdyOXAsECblYQQJ6DqCw1eX
         B+GA==
X-Gm-Message-State: AOAM533iqg/yVNfKTUbWLdcjIDrv3+P+CUeXHqQOcuD3oaPtEwm60zR1
        vnXohhYlZrz/kt2uJJJSoSWofSU9FMMzM6MB3Y30mx1uM9Nc4Q==
X-Google-Smtp-Source: ABdhPJxljSFAAfihTbRWBIHykA6XCaBVvncALTdtJO0lg7XDHGlWcEph7S3ncu9oyZVxNnbiqqzefo0HJiL7sI5kyHQ=
X-Received: by 2002:a05:6808:1494:: with SMTP id e20mr109086oiw.28.1632955887226;
 Wed, 29 Sep 2021 15:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210929222426.1855730-1-seanjc@google.com> <20210929222426.1855730-2-seanjc@google.com>
In-Reply-To: <20210929222426.1855730-2-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Sep 2021 15:51:16 -0700
Message-ID: <CALMp9eS4S1d-8nSdJDG8E1unemVB06=cb3_OWSaVivPJmk63PQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Swap order of CPUID entry "index" vs.
 "significant flag" checks
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 3:24 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Check whether a CPUID entry's index is significant before checking for a
> matching index to hack-a-fix an undefined behavior bug due to consuming
> uninitialized data.  RESET/INIT emulation uses kvm_cpuid() to retrieve
> CPUID.0x1, which does _not_ have a significant index, and fails to
> initialize the dummy variable that doubles as EBX/ECX/EDX output _and_
> ECX, a.k.a. index, input.
>
> Practically speaking, it's _extremely_  unlikely any compiler will yield
> code that causes problems, as the compiler would need to inline the
> kvm_cpuid() call to detect the uninitialized data, and intentionally hose
> the kernel, e.g. insert ud2, instead of simply ignoring the result of
> the index comparison.
>
> Although the sketchy "dummy" pattern was introduced in SVM by commit
> 66f7b72e1171 ("KVM: x86: Make register state after reset conform to
> specification"), it wasn't actually broken until commit 7ff6c0350315
> ("KVM: x86: Remove stateful CPUID handling") arbitrarily swapped the
> order of operations such that "index" was checked before the significant
> flag.
>
> Avoid consuming uninitialized data by reverting to checking the flag
> before the index purely so that the fix can be easily backported; the
> offending RESET/INIT code has been refactored, moved, and consolidated
> from vendor code to common x86 since the bug was introduced.  A future
> patch will directly address the bad RESET/INIT behavior.
>
> The undefined behavior was detected by syzbot + KernelMemorySanitizer.
>
>   BUG: KMSAN: uninit-value in cpuid_entry2_find arch/x86/kvm/cpuid.c:68
>   BUG: KMSAN: uninit-value in kvm_find_cpuid_entry arch/x86/kvm/cpuid.c:1103
>   BUG: KMSAN: uninit-value in kvm_cpuid+0x456/0x28f0 arch/x86/kvm/cpuid.c:1183
>    cpuid_entry2_find arch/x86/kvm/cpuid.c:68 [inline]
>    kvm_find_cpuid_entry arch/x86/kvm/cpuid.c:1103 [inline]
>    kvm_cpuid+0x456/0x28f0 arch/x86/kvm/cpuid.c:1183
>    kvm_vcpu_reset+0x13fb/0x1c20 arch/x86/kvm/x86.c:10885
>    kvm_apic_accept_events+0x58f/0x8c0 arch/x86/kvm/lapic.c:2923
>    vcpu_enter_guest+0xfd2/0x6d80 arch/x86/kvm/x86.c:9534
>    vcpu_run+0x7f5/0x18d0 arch/x86/kvm/x86.c:9788
>    kvm_arch_vcpu_ioctl_run+0x245b/0x2d10 arch/x86/kvm/x86.c:10020
>
>   Local variable ----dummy@kvm_vcpu_reset created at:
>    kvm_vcpu_reset+0x1fb/0x1c20 arch/x86/kvm/x86.c:10812
>    kvm_apic_accept_events+0x58f/0x8c0 arch/x86/kvm/lapic.c:2923
>
> Reported-by: syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com
> Reported-by: Alexander Potapenko <glider@google.com>
> Fixes: 2a24be79b6b7 ("KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping")
> Fixes: 7ff6c0350315 ("KVM: x86: Remove stateful CPUID handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
