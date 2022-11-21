Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3ED16319CD
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 07:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiKUGmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 01:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiKUGmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 01:42:45 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32793273C
        for <kvm@vger.kernel.org>; Sun, 20 Nov 2022 22:42:36 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id g10so9719822plo.11
        for <kvm@vger.kernel.org>; Sun, 20 Nov 2022 22:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nIn/dq+22PWaLv4hHMDs3f3KAdqnytvpjqipVfySebg=;
        b=AWiMixJCpFyWPBEJXHdf7HWjJyHvbXhLMGk+mOjs0xnQYpIsFf66uMAcg5YVl/EIsZ
         4uOMbVTRm1oZskMdV2SP9Z/PznA8Vxs49gV7HRlD+233vh2k5lkmCCd6db4xcrolRLvO
         Udn63wNkw8DoyqzYG0065+J/3jSrFyL4JawTNwBErVvBknBl4N/Zq5H2LGDHGRH+rALF
         6lq/8F2h/xL18440sxn7c0SWSAz8vqHAon02eJggvLmYjWN9PX50Fl82rR4Tn3DTPSRl
         Dkb8wByATyxBMi/xCv+puY7/wnjleMs5VJukq06pzqjHCtv+LSw09a6kQcx3BKRakcn/
         mLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nIn/dq+22PWaLv4hHMDs3f3KAdqnytvpjqipVfySebg=;
        b=cxYCw/WbG46GuYO75nsYL/u9gczKU1YmCaP+Y8XTMYlxUG8W/VxA+pTe/ZI2EOr24F
         GS+h6Kf3yqHaVnInULyv4asmHnsreuTKDyryye/iyk8MwhFkX6vnSBmSoYPukk0T6J5T
         kh5IIMpJmk+Kswm+/8CDaj6I2n17+4Bo6woajyfQIWFhn0Z8DsyA7DTA5/1pYYcFV2c+
         gchOkFUvxiMjxKpO2DiLuwwEe47m1YjC6fdLLFmnAuWv9nV0u5Wui1VOdcV3CKGmikJd
         Lu3s2WoS+IPPUt28BkcbvjClZ0wXVtbdfxBAykfSYANz+GzLNoh5rqezdH8BsTIYStXc
         2Ccg==
X-Gm-Message-State: ANoB5pntbvluFDS2GoY4G7pUoye+kL9s3JrHhwaeMg3lQvioZN5hxlTl
        uxnMYW9XEAt6ldU5O+LmQU4=
X-Google-Smtp-Source: AA0mqf7f9fasqIo0Dos5ZFaGunB3NGyXpA+iFnajmnNiKYLYBEr3Su/T/9qCplxrj2ZqAiODZEgaUg==
X-Received: by 2002:a17:90a:4fc1:b0:213:16b5:f45e with SMTP id q59-20020a17090a4fc100b0021316b5f45emr24562450pjh.170.1669012955526;
        Sun, 20 Nov 2022 22:42:35 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y19-20020a1709027c9300b0017f9db0236asm8805479pll.82.2022.11.20.22.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Nov 2022 22:42:35 -0800 (PST)
Message-ID: <187668e7-f32e-b509-8ce1-4b35d98c7d31@gmail.com>
Date:   Mon, 21 Nov 2022 14:42:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH 0/3] kvm: fix two svm pmu virtualization bugs
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
        chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
        jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
        danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
        groug@kaod.org, palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        joe.jin@oracle.com, qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221119122901.2469-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/2022 8:28 pm, Dongli Zhang wrote:
> This patchset is to fix two svm pmu virtualization bugs.
> 
> 1. The 1st bug is that "-cpu,-pmu" cannot disable svm pmu virtualization.
> 
> To use "-cpu EPYC" or "-cpu host,-pmu" cannot disable the pmu
> virtualization. There is still below at the VM linux side ...

Many QEMU vendor forks already have similar fixes, and
thanks for bringing this issue back to the mainline.

> 
> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
> 
> ... although we expect something like below.
> 
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
> 
> The patch 1-2 is to disable the pmu virtualization via KVM_PMU_CAP_DISABLE
> if the per-vcpu "pmu" property is disabled.
> 
> I considered 'KVM_X86_SET_MSR_FILTER' initially.
> Since both KVM_X86_SET_MSR_FILTER and KVM_PMU_CAP_DISABLE are VM ioctl. I
> finally used the latter because it is easier to use.
> 
> 
> 2. The 2nd bug is that un-reclaimed perf events (after QEMU system_reset)
> at the KVM side may inject random unwanted/unknown NMIs to the VM.
> 
> The svm pmu registers are not reset during QEMU system_reset.
> 
> (1). The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
> is running "perf top". The pmu registers are not disabled gracefully.
> 
> (2). Although the x86_cpu_reset() resets many registers to zero, the
> kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
> some pmu events are still enabled at the KVM side.
> 
> (3). The KVM pmc_speculative_in_use() always returns true so that the events
> will not be reclaimed. The kvm_pmc->perf_event is still active.

I'm not sure if you're saying KVM doing something wrong, I don't think so
because KVM doesn't sense the system_reset defined by QEME or other user space,
AMD's vPMC will continue to be enabled (if it was enabled before), generating pmi
injection into the guest, and the newly started guest doesn't realize the 
counter is still
enabled and blowing up the error log.

> 
> (4). After the reboot, the VM kernel reports below error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> (5). In a worse case, the active kvm_pmc->perf_event is still able to
> inject unknown NMIs randomly to the VM kernel.
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> The patch 3 is to fix the issue by resetting AMD pmu registers as well as
> Intel registers.

This fix idea looks good, it does require syncing the new changed device state 
of QEMU to KVM.

> 
> 
> This patchset does cover does not cover PerfMonV2, until the below patchset
> is merged into the KVM side.
> 
> [PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
> https://lore.kernel.org/all/20221111102645.82001-1-likexu@tencent.com/
> 
> 
> Dongli Zhang (3):
>        kvm: introduce a helper before creating the 1st vcpu
>        i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is disabled
>        target/i386/kvm: get and put AMD pmu registers
> 
>   accel/kvm/kvm-all.c    |   7 ++-
>   include/sysemu/kvm.h   |   2 +
>   target/arm/kvm64.c     |   4 ++
>   target/i386/cpu.h      |   5 +++
>   target/i386/kvm/kvm.c  | 104 +++++++++++++++++++++++++++++++++++++++++++-
>   target/mips/kvm.c      |   4 ++
>   target/ppc/kvm.c       |   4 ++
>   target/riscv/kvm.c     |   4 ++
>   target/s390x/kvm/kvm.c |   4 ++
>   9 files changed, 134 insertions(+), 4 deletions(-)
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> 
> 
