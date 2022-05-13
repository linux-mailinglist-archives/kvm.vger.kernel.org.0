Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB425526974
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383212AbiEMSiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359088AbiEMSiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:38:15 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4259F2AC
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:38:12 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u23so15971746lfc.1
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sO+JfLRTLwARBlQEe+5WonPeaEPDxsq/pA0Zx3DxzK0=;
        b=ajLsD9pxaX9zvCJp/tXd1JRDvQK8zx6+40pzcgJ39Vx4fD34ORagHtovGvhXDm9UQL
         jhcHcKGEle2gRL+rk12jzU76OHdH7am51syg4tEA56y4wUJh8L/g+DM1F4ct3/7pPCfs
         WXfXgBynpJoZndkpH4kBPxdjZXG/FPR/QzFo+07Iagnv5REkz/qoOKEP6L3GRotaYVM5
         8/maUw4rSDAuM79jIY5rcgoaZINo4ypnYd+qvefFPXM1uG2zOgtMoj7SoEOjfS8hXdnw
         zTnhTDhEQ6UAyREB692hLQ64SNzxl6CdQDqTnf2hIJ3RWCTmFw1in4goO+pec+pN+pZ6
         dxcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sO+JfLRTLwARBlQEe+5WonPeaEPDxsq/pA0Zx3DxzK0=;
        b=0RIK4i7q6sUB4eRUj8GjJNqboFdB/GAPl0j54/gsFtRMAa6ToC1H2nM47kCxb/knvL
         I+ePLh7jDz6JICGja2d0I4Yj5S7r61KejBE9JL9Rb8mBoZpHZghK6OvaiXypduBo0Ko+
         LFmZbJRKsiyTlyfC7SDGV6smJt9OCjPnD+E3U3kGRUPLYPHbThRilrNLTrSKyvvXhjyM
         VdW412HUKteITXXgNOlMpTS45twru3WkC8zfQ6gDHSaYaWjvdsQYOcKkFx1ngBrY3+Zu
         trQAbjh583//yD4a+rhXOB5DngdvmyQqxFCNpKL/3aefpTbQnOdgpWnz1dXNoF1G3SUT
         eciw==
X-Gm-Message-State: AOAM5339I0EhDLylsorgwWXd2E6dwch1t6UuWPRVaTKSMEjSzFxN5Cli
        kQKXCSSvIF12+u5ght4HMA97stDIzm6A5iIH+zbhpg==
X-Google-Smtp-Source: ABdhPJw2ku9OUMoOS8XgPOvc4Sap4VjndLoVfWeNV7d9/07FkIJ3X/KErEItmUv3wUDjZvct47MT/otZVlLzt2eyDQM=
X-Received: by 2002:a19:8c1a:0:b0:472:315:48db with SMTP id
 o26-20020a198c1a000000b00472031548dbmr4232573lfd.235.1652467090278; Fri, 13
 May 2022 11:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220513182038.2564643-1-juew@google.com>
In-Reply-To: <20220513182038.2564643-1-juew@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 13 May 2022 11:37:43 -0700
Message-ID: <CALzav=edcdA+gDkZFWJsrMBQ49iknTOK8t0m8EgcPRWOycyF8w@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] KVM: x86: Add CMCI and UCNA emulation
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
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

On Fri, May 13, 2022 at 11:22 AM Jue Wang <juew@google.com> wrote:
>
> This patch series implement emulation for Corrected Machine Check
> Interrupt (CMCI) signaling and UnCorrectable No Action required (UCNA)
> error injection.

Can you add some selftest or kvm-unit-test coverage for this feature?
I imagine selftests would be the best approach so that you can control
both the guest and the VMM (e.g. you can inject a CMCI/UCNA error from
the test and then make sure it makes it into the guest properly
according to how the Local APIC has been programmed).

>
> UCNA errors signaled via CMCI allow a guest to be notified as soon as
> uncorrectable memory errors get detected by some background threads,
> e.g., threads that migrate guest memory across hosts or threads that
> constantly scan system memory for errors [1].
>
> Upon receiving UCNAs, guest kernel isolates the poisoned pages which may
> still be free, preventing future accesses that may cause fatal MCEs.
>
> 1. https://lore.kernel.org/linux-mm/8eceffc0-01e8-2a55-6eb9-b26faa9e3caf@intel.com/t/
>
>
> Patch 1-3 clean up KVM APIC LVT logic.
>
> Patch 4 adds CMCI emulation to lapic.
>
> Patch 5 updates the allocation of mce_array to use array allocation api:
> kcalloc.
>
> Patch 6 adds emulation for the per-bank MSR_IA32_MCx_CTL2 MSRs that
> controls CMCI signaling.
>
> Patch 7 enables MCG_CMCI_P on x86 and handles injected UCNA errors.
>
>
> v3 changes
> - Incorporate feedback from Sean Christopherson <seanjc@google.com>
> - Split clean up to KVM APIC LVT logic to 3 patches.
> - Put the clean up of mce_array allocation in a separate patch.
> - Base the MCi_CTL2 register emulation on Sean's clean up and fix
> series [2]
> - Fix bugs around MCi_CTL2 register offset validation and the free of
> mci_ctl2_banks array.
> - Rewrite the change log with more details in architectural information
> about CMCI, UCNA and MCG_CMCI_P.
> - Fix various comments and wrapping style.
>
> 2. https://lore.kernel.org/lkml/20220512222716.4112548-1-seanjc@google.com/T/
>
>
> v2 chanegs
> - Incorporate feedback from Sean Christopherson <seanjc@google.com>
> - Split the single patch into 4:
>   1). clean up KVM APIC LVT logic
>   2). add CMCI emulation to lapic
>   3). add emulation of MSR_IA32_MCx_CTL2
>   4). enable MCG_CMCI_P and handle injected UCNAs
> - Fix various style issues.
>
> Jue Wang (7):
>   KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
>   KVM: x86: Fill apic_lvt_mask with enums / explicit entries.
>   KVM: x86: Add APIC_LVTx() macro.
>   KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to
>     lapic.
>   KVM: x86: Use kcalloc to allocate the mce_banks array.
>   KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.
>   KVM: x86: Enable MCG_CMCI_P and handle injected UCNAs.
>
>  arch/x86/include/asm/kvm_host.h |   1 +
>  arch/x86/kvm/lapic.c            |  58 +++++++---
>  arch/x86/kvm/lapic.h            |  15 ++-
>  arch/x86/kvm/vmx/vmx.c          |   1 +
>  arch/x86/kvm/x86.c              | 182 +++++++++++++++++++++++++-------
>  5 files changed, 200 insertions(+), 57 deletions(-)
>
> --
> 2.36.0.550.gb090851708-goog
>
