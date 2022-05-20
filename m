Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FC752F1BE
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 19:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352204AbiETRgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 13:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbiETRgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 13:36:42 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36B180221
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:41 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 15-20020aa7920f000000b0050cf449957fso4552757pfo.9
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=q1W2cETP/PGdc7K+yjcpeKM7X2tKBthgwgAGxzabNqs=;
        b=UNt4LfacHhwGIVlzBUK8F/EHU9DoBgtCrQ+UEjs5gHkjWgGIxeShapzPo2rynDg/4y
         U4pP6c/t4WmNK8dMnS708bxJbJOKXnCRp4hKBCHtUdt0oqEhhc54jfKnBkd+sfZMRY3U
         75kpDk9eGGxf2ray3O6WCQemAa+3lnEQKv8Et4yY+YIdf4FCRDwoS2CPalOsRjlhKFq/
         Vy82Hv7uj/mifoRq8Lc8PyLSjWanGYT/I0nDtq+286OwDcjImHLoL44KUU463+fl+S9d
         FDTqzGIBdLUOlcNMDp4zLQQ9P+TfXJxjjv4PypmiptSwM/sDIDTrbXvspuxJpdGnLOXm
         y/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=q1W2cETP/PGdc7K+yjcpeKM7X2tKBthgwgAGxzabNqs=;
        b=2UhklrmsZNf1O/+eNFd2HLgmNYy23dnvtNU1LMqCOH6nfdy8lndVWNP3hmSsfO9z6u
         ebUDjf0TORZjDEs3tR3/2/RWYWUZI5TnKoeq/Dyf6fSE0vwTW0+27HVCR18i06iOTx92
         Ph+jrdtbyfwVEMMSsynNx09H/PvrEMZWr/i7HwMS8g/+evVFAvr2srjPjaYwzrgwdxny
         ZG9zUbsp0qiCI2z8BzUiVuSl/tUgxLbRaK3ZfXLJ/JcoPSpCNalIlozKq0VUUKJvRj/a
         u/OT/Qcko8YJIj5O+IYLB/UnnFl23bkri9ZzmB2qgX2rVq/GST/rDejtaWY/Y/VVax51
         yJHw==
X-Gm-Message-State: AOAM531T+4Go3/RtI0xkmslhlO48AXeCiCOmttE+LrLeyi7k7fKluPiy
        2QutzBeVp7RFLoTjV7SfO5Kwsdlb
X-Google-Smtp-Source: ABdhPJxQ/A+52gSrgfpxwfVjkjdQqN1sZinII0MTLgwd0/hYy6Cbe6bldq92AGo4jA1+4iBrtdSRlvTW
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:4c5:ddc5:8182:560f])
 (user=juew job=sendgmr) by 2002:a63:ec54:0:b0:3c6:aa29:15fe with SMTP id
 r20-20020a63ec54000000b003c6aa2915femr9281469pgj.552.1653068201374; Fri, 20
 May 2022 10:36:41 -0700 (PDT)
Date:   Fri, 20 May 2022 10:36:30 -0700
Message-Id: <20220520173638.94324-1-juew@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 0/8] KVM: x86: Add CMCI and UCNA emulation
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
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


Patch 1-3 clean up KVM APIC LVT logic in preparation to adding APIC_LVTCMCI.

Patch 4 adds CMCI emulation to lapic.

Patch 5 updates the allocation of mce_banks to use array allocation api.

Patch 6 adds emulation for MSR_IA32_MCx_CTL2 registers that provide per
bank control of CMCI signaling.

Patch 7 enables MCG_CMCI_P by default and handles injected UCNA errors.

Patch 8 adds a KVM self test that exercises UCNA injection.

v4 changes
- Incorporate feedback from David Matlack <dmatlack@google.com>
- Rewrite the change logs to be more descriptive.
- Add a KVM self test.

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

Jue Wang (8):
  KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
  KVM: x86: Fill apic_lvt_mask with enums / explicit entries.
  KVM: x86: Add APIC_LVTx() macro.
  KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to
    lapic.
  KVM: x86: Use kcalloc to allocate the mce_banks array.
  KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.
  KVM: x86: Enable CMCI capability by default and handle injected UCNA
    errors
  KVM: x86: Add a self test for UCNA injection.

 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/lapic.c                          |  58 +++-
 arch/x86/kvm/lapic.h                          |  15 +-
 arch/x86/kvm/vmx/vmx.c                        |   1 +
 arch/x86/kvm/x86.c                            | 182 ++++++++---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   1 +
 .../selftests/kvm/include/x86_64/mce.h        |  25 ++
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/lib/x86_64/processor.c      |   2 +-
 .../kvm/x86_64/ucna_injection_test.c          | 287 ++++++++++++++++++
 12 files changed, 517 insertions(+), 58 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/mce.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/ucna_injection_test.c

-- 
2.36.1.124.g0e6072fb45-goog

