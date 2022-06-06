Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136A953F252
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiFFXFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbiFFXFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:05:16 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6219B35DE4
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:05:14 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id r12-20020a056830448c00b0060aec7b7a54so11790770otv.5
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Gf/XuQlnrCjV08KAe5I+CdEOdoNW4OlHyRl/hczIyw=;
        b=RoJbrLvaMyL3TNZSGqeRwFOHCQiUF/dZovxTI8CZamCwS9em1FOvAl3lUUycrpi2H/
         33Y8aCRdReJvwgF6IeyGVRFaPU058F+k87WJYU43ROg2DS7Vxx6/67z8oiyNr32rse0H
         Iv7O+ff16d5RPZytV8XapZFr5Mfi7xnHwBfvzqF4vsDc5YxBptI8SV639vG0WDgPDg1I
         IY9L9il/m9a53GRo+rpmdLhAELS4NMLtEDh5AFivT1mwSeUEtlNN63U/S8wGRx1PBAYT
         VGgFC5c7mDLsqkyKFQVSeNYot7KHPQQTCw6ZjvnZ1oPM2imAFudla5sb4Btkn0exBIT8
         ATGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Gf/XuQlnrCjV08KAe5I+CdEOdoNW4OlHyRl/hczIyw=;
        b=qGsOmxePtUlhLBnBwbadZI9mVvNXSd2GQEcQ4NlihrLu6E3Sca6Vc/wtSkb/G/GbrM
         T/74etRJ5oun9UD4+bIKmARZFRrtxOK8EXCG+hMFO5a5BqKaLtIesUFRyV4YWPacObe1
         MangCCJOFbYfZW4za32VJzLsZsRpH7aOYVS/8dUD6xcdYSfODADFkSlmaz69+SHMsoO3
         ZJSPXt99fxUr9NLzbO/4t4nYdqEfVtz7kpNivo8u5RW4Wu1iBhip5sSJD7WAbAdGZxM/
         G2/ZQxxeGppGlCQ8keaERZ5qHVQed+3Y198NLHkJPmta9iJlaL+UQvwsfyxr4NKJB2tl
         MhDw==
X-Gm-Message-State: AOAM531M9OpAYrtS2l0VqMQGJJmusDDh3l7X3JCVgmvePvdALgoWxATO
        Glqz1I3Vm05zHtqCHdVrq14BgIv5RyUGyDWXlJAsIg==
X-Google-Smtp-Source: ABdhPJxaobG+TFd+UMH9XYgpg1jMSz/Wa/dYt6jizxkBMihRMPlW+APjkdsAEQq2EPM9hopFu/e0Ur8w1uhNtHiYh6o=
X-Received: by 2002:a9d:808:0:b0:60c:37:6fcf with SMTP id 8-20020a9d0808000000b0060c00376fcfmr2158290oty.75.1654556713409;
 Mon, 06 Jun 2022 16:05:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jun 2022 16:05:02 -0700
Message-ID: <CALMp9eQS6e=utUK5heRXH4G4hev7u6XHs+PWV994R-zszz8_RQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/17] Introducing AMD x2AVIC and hybrid-AVIC modes
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, jon.grimm@amd.com, wei.huang2@amd.com,
        terry.bowman@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 3:32 AM Suravee Suthikulpanit
<suravee.suthikulpanit@amd.com> wrote:
>
> Introducing support for AMD x2APIC virtualization. This feature is
> indicated by the CPUID Fn8000_000A EDX[14], and it can be activated
> by setting bit 31 (enable AVIC) and bit 30 (x2APIC mode) of VMCB
> offset 60h.
>
> With x2AVIC support, the guest local APIC can be fully virtualized in
> both xAPIC and x2APIC modes, and the mode can be changed during runtime.
> For example, when AVIC is enabled, the hypervisor set VMCB bit 31
> to activate AVIC for each vCPU. Then, it keeps track of each vCPU's
> APIC mode, and updates VMCB bit 30 to enable/disable x2APIC
> virtualization mode accordingly.
>
> Besides setting bit VMCB bit 30 and 31, for x2AVIC, kvm_amd driver needs
> to disable interception for the x2APIC MSR range to allow AVIC hardware
> to virtualize register accesses.
>
> This series also introduce a partial APIC virtualization (hybrid-AVIC)
> mode, where APIC register accesses are trapped (i.e. not virtualized
> by hardware), but leverage AVIC doorbell for interrupt injection.
> This eliminates need to disable x2APIC in the guest on system without
> x2AVIC support. (Note: suggested by Maxim)
>
> Testing for v5:
>   * Test partial AVIC mode by launching a VM with x2APIC mode
>   * Tested booting a Linux VM with x2APIC physical and logical modes upto 512 vCPUs.
>   * Test the following nested SVM test use cases:
>
>              L0     |    L1   |   L2
>        ----------------------------------
>                AVIC |    APIC |    APIC
>                AVIC |    APIC |  x2APIC
>         hybrid-AVIC |  x2APIC |    APIC
>         hybrid-AVIC |  x2APIC |  x2APIC
>              x2AVIC |    APIC |    APIC
>              x2AVIC |    APIC |  x2APIC
>              x2AVIC |  x2APIC |    APIC
>              x2AVIC |  x2APIC |  x2APIC
>
> Changes from v5:
> (https://lore.kernel.org/lkml/20220518162652.100493-1-suravee.suthikulpanit@amd.com/T/#t)
>   * Re-order patch 16 to 10
>   * Patch 11: Update commit message
>
> Changes from v4:
> (https://lore.kernel.org/lkml/20220508023930.12881-5-suravee.suthikulpanit@amd.com/T/)
>   * Patch  3: Move enum_avic_modes definition to svm.h
>   * Patch 10: Rename avic_set_x2apic_msr_interception to
>               svm_set_x2apic_msr_interception and move it to svm.c
>               to simplify the struct svm_direct_access_msrs declaration.
>   * Patch 16: New from Maxim
>   * Patch 17: New from Maxim
>
> Best Regards,
> Suravee
>
> Maxim Levitsky (2):
>   KVM: x86: nSVM: always intercept x2apic msrs
>   KVM: x86: nSVM: optimize svm_set_x2apic_msr_interception
>
> Suravee Suthikulpanit (15):
>   x86/cpufeatures: Introduce x2AVIC CPUID bit
>   KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to
>     [GET/SET]_XAPIC_DEST_FIELD
>   KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
>   KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
>   KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
>   KVM: SVM: Do not support updating APIC ID when in x2APIC mode
>   KVM: SVM: Adding support for configuring x2APIC MSRs interception
>   KVM: x86: Deactivate APICv on vCPU with APIC disabled
>   KVM: SVM: Refresh AVIC configuration when changing APIC mode
>   KVM: SVM: Introduce logic to (de)activate x2AVIC mode
>   KVM: SVM: Do not throw warning when calling avic_vcpu_load on a
>     running vcpu
>   KVM: SVM: Introduce hybrid-AVIC mode
>   KVM: x86: Warning APICv inconsistency only when vcpu APIC mode is
>     valid
>   KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
>   KVM: SVM: Add AVIC doorbell tracepoint
>
>  arch/x86/hyperv/hv_apic.c          |   2 +-
>  arch/x86/include/asm/apicdef.h     |   4 +-
>  arch/x86/include/asm/cpufeatures.h |   1 +
>  arch/x86/include/asm/kvm_host.h    |   1 -
>  arch/x86/include/asm/svm.h         |  16 ++-
>  arch/x86/kernel/apic/apic.c        |   2 +-
>  arch/x86/kernel/apic/ipi.c         |   2 +-
>  arch/x86/kvm/lapic.c               |   6 +-
>  arch/x86/kvm/svm/avic.c            | 178 ++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/nested.c          |   5 +
>  arch/x86/kvm/svm/svm.c             |  75 ++++++++----
>  arch/x86/kvm/svm/svm.h             |  25 +++-
>  arch/x86/kvm/trace.h               |  18 +++
>  arch/x86/kvm/x86.c                 |   8 +-
>  14 files changed, 291 insertions(+), 52 deletions(-)
>
> --
> 2.25.1

When will we see this feature in silicon?

Where is the official documentation?
