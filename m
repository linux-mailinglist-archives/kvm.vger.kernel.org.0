Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C54546B86
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 19:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350051AbiFJRLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 13:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346765AbiFJRLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 13:11:41 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9DE1F21B0
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:40 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k10-20020a170902ce0a00b0016774f4a707so8527528plg.22
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2qHdavCGwladcSDrPuxpb40bknh3vM8Nua+2r4SlZ8g=;
        b=lEieDN6FDQ7C77nl/K6wYwQSEdeZ+ihCHBH+IeV9gqDx6uaP0GHEeNh6P39AlzhNoT
         sGiSD7zz0v6sK2a8jK2U8aaTPAqVlybr7bcwSlka5hHo/hrQrLnfkQubCmXJOSR1ZEB5
         cjeM3U+QLsQr4wtLCddUHRG16mgdwlG8hpgZDb6aY76wfs0hJSzh0vl0YyiXJglc9Y8k
         WjudkpDtI7gFr/G1PW1BCMqkLoMBHyBbO80CYs1h+g1W8QJrWVzc5bcPy8hk2H/1MsVz
         fadEs20h1dD5vzo2fP+BoVmwwo0AQfYz0EbBUae5Uor807MvOLnZhlW51XqPUymoSRhS
         sAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2qHdavCGwladcSDrPuxpb40bknh3vM8Nua+2r4SlZ8g=;
        b=5FvdYhq1TDw2Ub909ImPtg+uTa6ICg6SdTKCohyV0ztDc7gxGIVnOFArYkFt6mAG6N
         Yvj7G7MPey4g6X3czKYTvVRQXLZYuzQVDuzceM3qNoHfyj8iKFOPQrtBskoK3Kgj6lke
         eH37cSY/y3x0X3uDdddfwOk6Pn3vYzMhF49i6rMaFFc+VVcchhx1gpqDVs+yPJESGlUS
         9iMq4VHn5z+tyQl6Ry9J0CyQV2x8BZ0jBGPQ7g2jMrhYiRKoZYHqKbGn4lGIdAch9wzP
         EqAYCtm35HZSBwD8dMLURWxcIHDGXcY37zLuI+GFwzrnPbxC7v0IbvqgYE6lUU61+eqG
         ydkg==
X-Gm-Message-State: AOAM530U9vqqjqjjGVkZiiMTdaxBjr26mzBxdHsOZr6p8te9AzGYUfJ0
        EG6TUv1yGO5znkiqa09tYj3O5EFr
X-Google-Smtp-Source: ABdhPJz7U19boG0D0rgA3jnCWAga5atP39DL09V+YYCb9ccm07r+13P9Y+oPrX/pwcG3tGeLytfK76Ot
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:9a6e:681b:67df:5cc4])
 (user=juew job=sendgmr) by 2002:a17:903:2281:b0:167:56a9:935c with SMTP id
 b1-20020a170903228100b0016756a9935cmr36032902plh.27.1654881099825; Fri, 10
 Jun 2022 10:11:39 -0700 (PDT)
Date:   Fri, 10 Jun 2022 10:11:26 -0700
Message-Id: <20220610171134.772566-1-juew@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v5 0/8] KVM: x86: Add CMCI and UCNA emulation
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

Patch 4 adds APIC_LVTCMCI emulation.

Patch 5 updates mce_banks to use array allocation api.

Patch 6 adds emulation for MSR_IA32_MCx_CTL2 registers that provide per
bank control of CMCI signaling.

Patch 7 enables MCG_CMCI_P and handles injected UCNA errors.

Patch 8 adds a KVM self test that validates UCNA injection and CMCI
emulation.

v5 changes
- Incorporate feedback from David Matlack <dmatlack@google.com>
- Rewrite the change log to be more concise and accurate.
- Removes several duplicated checks in UCNA injection code.
- Add test cases that validate CMCI emulation to self test.

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
  KVM: selftests: Add a self test for CMCI and UCNA emulations.

 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/lapic.c                          |  66 ++--
 arch/x86/kvm/lapic.h                          |  16 +-
 arch/x86/kvm/vmx/vmx.c                        |   1 +
 arch/x86/kvm/x86.c                            | 178 ++++++---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   1 +
 .../selftests/kvm/include/x86_64/mce.h        |  25 ++
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/lib/x86_64/processor.c      |   2 +-
 .../kvm/x86_64/ucna_injection_test.c          | 347 ++++++++++++++++++
 12 files changed, 573 insertions(+), 67 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/mce.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/ucna_injection_test.c

-- 
2.36.1.255.ge46751e96f-goog

