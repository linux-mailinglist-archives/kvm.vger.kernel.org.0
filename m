Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC50752691F
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382994AbiEMSUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381541AbiEMSUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:20:48 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AED2377CB
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:20:47 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p9-20020a170902e74900b0015ef7192336so4711162plf.14
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ChGRQGDq3HDw7LCLaR37RRviS4Bl0l1y7adSXjlnbtM=;
        b=YVda2O0+bVqh7vhihkL4iS5Hcfbdgo8/T90WdVw10/+cGM1vAP0tLipCO+4Z9oQD7Z
         0IEGF0uBWd0H5ZtnzeEcqAeNGctWi3mLyeGGkbYsh2wDODBkZXdNcGQ9Xiqx46W3BepZ
         4a3H2k3yjMvzZtn3fKVILCFujpBw0gay6sgKR4yGFAAbm1kKOqJkj3iDmQAaB8c0xmuu
         AodSHhfujprfh1v9P3WiL0ZowvOkeP6vYsHmnQsIuGFDSdAqrEX8UiB1+ap8SSQRqRdE
         smCM/yB9pDZppZzFjtP9ss0qJ47RGNWPgQyrONpNaY4DFCriTD01CurjAtwgy6ensb5y
         o8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ChGRQGDq3HDw7LCLaR37RRviS4Bl0l1y7adSXjlnbtM=;
        b=gYwPDjTQ+RZphr856RCc0drr6kKpsy/R+NjmRCM2woGIvhyOTekgymlr5aDkerQ3UK
         dP3JxdYoEf55nopd0VMs2ljP1jURsdJvldAA8LB4Qq4WcsBwtYz5hDvGLOqObzzjM4SZ
         PMBRYt7jFnktkJp1GeYSi6EoUbnaMv/DW5EYK4sExZWRF7chJz1w4PzM3dGs+1KSwBWv
         JugpEJa2W12sjMIcSLhjpOsWMMmTi2jhyoUOVoKUzGrsovfKbtqZTrsC2RtSChyw9wiS
         y3Z13Pau9ZGIKaI2JDsaBzLlqUoDF4yf5voTAaUWQWRdCuwK10ggnfoMjcf6tbhleMx5
         n70Q==
X-Gm-Message-State: AOAM530AOyQV0XFXfUw1H7OUw/4jeKNI/T+qcjLIfAcBQ0G1VvASuX/z
        h9VaTP9hRFiu1ewF1SeTOJ7FmRo9
X-Google-Smtp-Source: ABdhPJx77+Q/RdlfDLWhTKgWT8Ex228v1VtjMFiJ6uyp+GY8DtdLnek8wvIe7O8FTiIuMQQXNayPDdph
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:d883:9294:4cf5:a395])
 (user=juew job=sendgmr) by 2002:a17:902:e2d3:b0:15f:249c:2002 with SMTP id
 l19-20020a170902e2d300b0015f249c2002mr6000631plc.159.1652466046599; Fri, 13
 May 2022 11:20:46 -0700 (PDT)
Date:   Fri, 13 May 2022 11:20:31 -0700
Message-Id: <20220513182038.2564643-1-juew@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v3 0/7] KVM: x86: Add CMCI and UCNA emulation
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series implement emulation for Corrected Machine Check
Interrupt (CMCI) signaling and UnCorrectable No Action required (UCNA)
error injection.

UCNA errors signaled via CMCI allow a guest to be notified as soon as
uncorrectable memory errors get detected by some background threads,
e.g., threads that migrate guest memory across hosts or threads that
constantly scan system memory for errors [1].

Upon receiving UCNAs, guest kernel isolates the poisoned pages which may
still be free, preventing future accesses that may cause fatal MCEs.

1. https://lore.kernel.org/linux-mm/8eceffc0-01e8-2a55-6eb9-b26faa9e3caf@intel.com/t/


Patch 1-3 clean up KVM APIC LVT logic.

Patch 4 adds CMCI emulation to lapic.

Patch 5 updates the allocation of mce_array to use array allocation api:
kcalloc.

Patch 6 adds emulation for the per-bank MSR_IA32_MCx_CTL2 MSRs that
controls CMCI signaling.

Patch 7 enables MCG_CMCI_P on x86 and handles injected UCNA errors.


v3 changes
- Incorporate feedback from Sean Christopherson <seanjc@google.com>
- Split clean up to KVM APIC LVT logic to 3 patches.
- Put the clean up of mce_array allocation in a separate patch.
- Base the MCi_CTL2 register emulation on Sean's clean up and fix
series [2]
- Fix bugs around MCi_CTL2 register offset validation and the free of
mci_ctl2_banks array.
- Rewrite the change log with more details in architectural information
about CMCI, UCNA and MCG_CMCI_P.
- Fix various comments and wrapping style.

2. https://lore.kernel.org/lkml/20220512222716.4112548-1-seanjc@google.com/T/


v2 chanegs
- Incorporate feedback from Sean Christopherson <seanjc@google.com>
- Split the single patch into 4:
  1). clean up KVM APIC LVT logic
  2). add CMCI emulation to lapic
  3). add emulation of MSR_IA32_MCx_CTL2
  4). enable MCG_CMCI_P and handle injected UCNAs
- Fix various style issues.

Jue Wang (7):
  KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
  KVM: x86: Fill apic_lvt_mask with enums / explicit entries.
  KVM: x86: Add APIC_LVTx() macro.
  KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to
    lapic.
  KVM: x86: Use kcalloc to allocate the mce_banks array.
  KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.
  KVM: x86: Enable MCG_CMCI_P and handle injected UCNAs.

 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/lapic.c            |  58 +++++++---
 arch/x86/kvm/lapic.h            |  15 ++-
 arch/x86/kvm/vmx/vmx.c          |   1 +
 arch/x86/kvm/x86.c              | 182 +++++++++++++++++++++++++-------
 5 files changed, 200 insertions(+), 57 deletions(-)

-- 
2.36.0.550.gb090851708-goog

