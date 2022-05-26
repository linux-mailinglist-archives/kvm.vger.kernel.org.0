Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6793A535657
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 01:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240851AbiEZXOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 19:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiEZXOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 19:14:39 -0400
Received: from mail.eskimo.com (mail.eskimo.com [204.122.16.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFD4E52A1;
        Thu, 26 May 2022 16:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=eskimo.com;
        s=default; t=1653606876;
        bh=brQFxuJo8vPS3y4lzGJlq1ypgd6jd/P+HXBTPOoOyyU=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=S58o+5zOf7LZhkXnDjwS3R/yU0J3HXSBryXqEyBtrNuHxqqji3Mzz9UCqw1fLjML1
         /67CAA03CzJZMEh2uxdPWfcYO8KZ4xYnON9OEnIgiP77TJN9STKT1iyv8YlMTORKSb
         UjoHb1kYa2VJMTHEYZ5ezJbAc1097LIOaaH9uAfRLJclFEvlYkXLEagsU9jz4/VjHi
         TzWwArh8Wcnit5UVAboP8EESUPTdmWq04JehrpAkv0nuwRexy9PDE5u105L4YwF3ND
         By/i4yTqY19sggdhE6ZWu5pwwRhdGEi5z5ZolkbXzZFy5MnLLthaDxj+Hlsuwfe1qO
         0oXSXH1r3cRQQ==
Received: from ubuntu.eskimo.com (ubuntu.eskimo.com [204.122.16.33])
        by mail.eskimo.com (Postfix) with ESMTPS id C93943CA09F;
        Thu, 26 May 2022 16:14:36 -0700 (PDT)
Date:   Thu, 26 May 2022 16:14:36 -0700 (PDT)
From:   Robert Dinse <nanook@eskimo.com>
To:     Sean Christopherson <seanjc@google.com>
cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 0/8] KVM: x86: Emulator _regs fixes and cleanups
In-Reply-To: <20220526210817.3428868-1-seanjc@google.com>
Message-ID: <d25dc23a-5379-9ad0-25c-9d7ef656c410@eskimo.com>
References: <20220526210817.3428868-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Virus-Scanned: clamav-milter 0.103.6 at mail.eskimo.com
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


      It >DID< build ok with this patch, I applied it and built last night,
I'm presently running that kernel with a KVM/Qemu Windows guest on my
workstation:

Linux nanook 5.18.0 #1 SMP PREEMPT Wed May 25 18:14:43 PDT 2022 x86_64 x86_64 
x86_64 GNU/Linux

      The Windows guest starts and runs but networking isn't working (I am
using a bridge for the guest hosts and a static IP for both the main machine
and guest), it all works including networking with 5.17.9.

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  Eskimo North Linux Friendly Internet Access, Shell Accounts, and Hosting.
    Knowledgeable human assistance, not telephone trees or script readers.
  See our web site: http://www.eskimo.com/ (206) 812-0051 or (800) 246-6874.

On Thu, 26 May 2022, Sean Christopherson wrote:

> Date: Thu, 26 May 2022 21:08:09 +0000
> From: Sean Christopherson <seanjc@google.com>
> To: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>,
>     Vitaly Kuznetsov <vkuznets@redhat.com>,
>     Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
>     Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
>     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
>     Robert Dinse <nanook@eskimo.com>
> Subject: [PATCH v2 0/8] KVM: x86: Emulator _regs fixes and cleanups
> 
> Clean up and harden the use of the x86_emulate_ctxt._regs, which is
> surrounded by a fair bit of magic.  This series was prompted by bug reports
> by Kees and Robert where GCC-12 flags an out-of-bounds _regs access.  The
> warning is a false positive due to a now-known GCC bug, but it's cheap and
> easy to harden the _regs usage, and doing so minimizing the risk of more
> precisely handling 32-bit vs. 64-bit GPRs.
>
> I didn't tag patch 2 with Fixes or Cc: stable@.  It does remedy the
> GCC-12 warning, but AIUI the GCC-12 bug affects other KVM paths that
> already have explicit guardrails, i.e. fixing this one case doesn't
> guarantee happiness when building with CONFIG_KVM_WERROR=y, let alone
> CONFIG_WERROR=y.  That said, it might be worth sending to the v5.18 stable
> tree[*] as it does appear to make some configs/setups happy.
>
> [*] KVM hasn't changed, but the warning=>error was introduced in v5.18 by
>   commit e6148767825c ("Makefile: Enable -Warray-bounds").
>
> v2:
>  - Collect reviews and tests. [Vitaly, Kees, Robert]
>  - Tweak patch 1's changelog to explicitly call out that dirty_regs is a
>    4 byte field. [Vitaly]
>  - Add Reported-by for Kees and Robert since this does technically fix a
>    build breakage.
>  - Use a raw literal for NR_EMULATOR_GPRS instead of VCPU_REGS_R15+1 to
>    play nice with 32-bit builds. [kernel test robot]
>  - Reduce the number of emulated GPRs to 8 for 32-bit builds.
>  - Add and use KVM_EMULATOR_BUG_ON() to bug/kill the VM when an emulator
>    bug is detected.  [Vitaly]
>
> v1: https://lore.kernel.org/all/20220525222604.2810054-1-seanjc@google.com
>
> Sean Christopherson (8):
>  KVM: x86: Grab regs_dirty in local 'unsigned long'
>  KVM: x86: Harden _regs accesses to guard against buggy input
>  KVM: x86: Omit VCPU_REGS_RIP from emulator's _regs array
>  KVM: x86: Use 16-bit fields to track dirty/valid emulator GPRs
>  KVM: x86: Reduce the number of emulator GPRs to '8' for 32-bit KVM
>  KVM: x86: Bug the VM if the emulator accesses a non-existent GPR
>  KVM: x86: Bug the VM if the emulator generates a bogus exception
>    vector
>  KVM: x86: Bug the VM on an out-of-bounds data read
>
> arch/x86/kvm/emulate.c     | 26 ++++++++++++++++++++------
> arch/x86/kvm/kvm_emulate.h | 28 +++++++++++++++++++++++++---
> arch/x86/kvm/x86.c         |  9 +++++++++
> 3 files changed, 54 insertions(+), 9 deletions(-)
>
>
> base-commit: 90bde5bea810d766e7046bf5884f2ccf76dd78e9
> -- 
> 2.36.1.255.ge46751e96f-goog
>
