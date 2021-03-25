Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB45348AB8
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 08:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhCYHxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 03:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhCYHwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 03:52:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B91C06175F;
        Thu, 25 Mar 2021 00:52:32 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w18so1394282edc.0;
        Thu, 25 Mar 2021 00:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7E5ymlHt+LwdGPwWNJG7cjb+/fldc9ZuqOhFEGwieBw=;
        b=gq565vToHpfE/DWAcTkKTg51O1+y6DzEPrC07uv15KlPoxKtQWYMqmjNXTxMqZ1XT0
         euRa7RRFlr0Z+Y6q0E60qXlX5QViot1eZWAlVYS2WnndpuUwB6ReQCMDfCTJM1dwXFg2
         ut5qRjOxgnrXNBtvOQILkvN7hIQTMK0ZlJZeZRbcEyCOTaH780Z6tl4DHBkAd7Zq/VCb
         Q9AMaGXuZlFygBn1uKZnE8I7BB/gN9EC64RbvceWAZyZY+j7dfsyxCdl+ce8hlSRHmcj
         tMWTigBs4C59QKvQXJ13jS2Rm15yzTQkL73tBuPI6KAP2J9gFGk7rJQoFdkcZ8UGrXh5
         ExaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7E5ymlHt+LwdGPwWNJG7cjb+/fldc9ZuqOhFEGwieBw=;
        b=GKrUTH19Pb0Zj9TNPJmMNOX5/73N/4WWHFhLAJELU/vlf6nFffPqB059CumrDm3jDV
         3Y5XlhfIMSejKkOTMXht1CaJhYVWvik0PhCmP5ti344jf4J2wIvXMFVjNLj84cD+KKN1
         ps9fuitNXbpf5XNYY3jY2xugz3IUSiNzONc2Bbu+0c3jlv/j7NUNGarRZP2IcGedC/eH
         HVfq3YVlGA/CLtEi67TRL0IaODxlJghs6K/KgRXAi7MD3xVhKz2tmbd6C/60rCDx28Xf
         OVlFq3A6MNgS2h3dolRvhkulwjNO/rSmaLKnkPEyL1BHFybPyyBsFy39kpiV/PnRDpx4
         CqWg==
X-Gm-Message-State: AOAM530RJqZ3z6BO4bM4acPkhXdai8aRlymxbBJM+OiyW7flITYnrOK3
        8Znf6BU9r5MSKn9gGr/pjWvx66I06zUE33DZCA==
X-Google-Smtp-Source: ABdhPJzNhpviIXrgnlAlFpuvH4fUWDUmVLek2HLovnSD5xKO2tEViyYtmS+In6ZdUo3DO1E5JxG3a081tpJbUwtUAJI=
X-Received: by 2002:a05:6402:19a:: with SMTP id r26mr7515236edv.44.1616658751102;
 Thu, 25 Mar 2021 00:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210323084515.1346540-1-vkuznets@redhat.com>
In-Reply-To: <20210323084515.1346540-1-vkuznets@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Thu, 25 Mar 2021 15:51:52 +0800
Message-ID: <CAB5KdObQ7t4aXFsYioNdVfNt6B+ChJLB5dKsWxAtoXMYpgSoBA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/vPMU: Forbid writing to MSR_F15H_PERF MSRs when
 guest doesn't have X86_FEATURE_PERFCTR_CORE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Wei Huang <wei.huang2@amd.com>, Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 4:48 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> MSR_F15H_PERF_CTL0-5, MSR_F15H_PERF_CTR0-5 MSRs are only available when
> X86_FEATURE_PERFCTR_CORE CPUID bit was exposed to the guest. KVM, however,
> allows these MSRs unconditionally because kvm_pmu_is_valid_msr() ->
> amd_msr_idx_to_pmc() check always passes and because kvm_pmu_set_msr() ->
> amd_pmu_set_msr() doesn't fail.
>
> In case of a counter (CTRn), no big harm is done as we only increase
> internal PMC's value but in case of an eventsel (CTLn), we go deep into
> perf internals with a non-existing counter.
>
> Note, kvm_get_msr_common() just returns '0' when these MSRs don't exist
> and this also seems to contradict architectural behavior which is #GP
> (I did check one old Opteron host) but changing this status quo is a bit
> scarier.

When msr doesn't exist, kvm_get_msr_common() returns KVM_MSR_RET_INVALID
in `default:` and kvm_complete_insn_gp() will inject #GP to guest.

Also i have wrote a kvm-unit-test, tested both on amd EPYC and intel
CascadeLake. A #GP error was printed.
Just like:

Unhandled exception 13 #GP at ip 0000000000400420
error_code=0000      rflags=00010006      cs=00000008
rax=0000000000000000 rcx=0000000000000620 rdx=00000000006164a0
rbx=0000000000009500
rbp=0000000000517490 rsi=0000000000616ae0 rdi=0000000000000001
 r8=0000000000000001  r9=00000000000003f8 r10=000000000000000d
r11=0000000000000000
r12=0000000000000000 r13=0000000000000000 r14=0000000000000000
r15=0000000000000000
cr0=0000000080000011 cr2=0000000000000000 cr3=000000000040b000
cr4=0000000000000020
cr8=0000000000000000
STACK: @400420 400338
