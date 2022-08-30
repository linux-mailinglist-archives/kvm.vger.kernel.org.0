Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDA75A70F2
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 00:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiH3WnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 18:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiH3WnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 18:43:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B596EF0E
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:43:11 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id e9-20020aa78249000000b00537a62a6175so5199225pfn.20
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=4mKDMKVHAaeHZ2Y8J+aU4K8AFzSpIVcaWcthTECBOoY=;
        b=HT/CTnmwi8O5F4A4U0ZGNwfAAO/3FeZ9G0kzmIriRBlgo0dQrPpefQqMQoV5dnXftO
         RNFfqKIlABGWfil9AJqhFNRwDM35suRqQ6FzUWRUKQZc3eD/lgXrCcELrI2+FG4+jD7n
         ikVDnzkoWXr4Zbrmy2fp8H2+Ukf0TZLe1cuiTZN0DPUg9a8eZwOo6JH+Mk4vW1qenjc+
         QwIPIC0TDirTCUznsaB1JRuXP+70d4EY6ys/1r20fx4fLs8IPQ0UbNC4B+7Dwuqm/y3b
         JxRPXMjHtfo/0KwTD5ipTjFUT4wVRfBn75KyqCFfJDlywgUK6+4IeUF7m1NORIDmMcQp
         Dc0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=4mKDMKVHAaeHZ2Y8J+aU4K8AFzSpIVcaWcthTECBOoY=;
        b=NgOBbc2/jHsvO484BAP00Y9EeMJVro+6iauHqzRThL+8StY4gGIzsyBrDjJ2d/TpAR
         4s4LiIW1YUYI+6bkXshDlwGav76L3CBX0oxNQePE1t8wTmaPLugUAGSpnp7Ac80jd3HO
         KyXndGKb0RWl2jdv72NJMbG8/B0m81l8HeGHc9vvgoUoCgOenl3CS1Iq0ziT6wL7H/eB
         j4y0MtCwhkKT1HidQG2QwR59ZCeF2FQSSLr091I426G0EwHH8t+ZtlZb7mUDxhnZXwmv
         rV3D3TfaPxNPbi3QDvH3V6y7en0r0oM9jfR8grrBvIFpHI2jHnig9xCek9WFzyz1kgDe
         6wAQ==
X-Gm-Message-State: ACgBeo3pOklMEU/h+gMXPYt1iAHik6/c+zFHQK3xZUN/ikHyD12DHw8Q
        1fy+EeN1XUBVq9JyS/mR9iOuKoP+HTTg6g02
X-Google-Smtp-Source: AA6agR7wklK7brvKIIjoEpRwM3j0c/2Ay8bnPrslk0pVotf7Dq3EF3lXilQOW0Hb23535KT7fBUcEIUbYTy+2qj7
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a17:90a:e558:b0:1fb:c4b7:1a24 with SMTP
 id ei24-20020a17090ae55800b001fbc4b71a24mr5260pjb.1.1661899389937; Tue, 30
 Aug 2022 15:43:09 -0700 (PDT)
Date:   Tue, 30 Aug 2022 22:42:51 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830224259.412342-1-vannapurve@google.com>
Subject: [RFC V2 PATCH 0/8] selftests: KVM: SEV: selftests for fd-based
 private memory
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, shuah@kernel.org, yang.zhong@intel.com,
        drjones@redhat.com, ricarkol@google.com, aaronlewis@google.com,
        wei.w.wang@intel.com, kirill.shutemov@linux.intel.com,
        corbet@lwn.net, hughd@google.com, jlayton@kernel.org,
        bfields@fieldses.org, akpm@linux-foundation.org,
        chao.p.peng@linux.intel.com, yu.c.zhang@linux.intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com,
        michael.roth@amd.com, qperret@google.com, steven.price@arm.com,
        ak@linux.intel.com, david@redhat.com, luto@kernel.org,
        vbabka@suse.cz, marcorr@google.com, erdemaktas@google.com,
        pgonda@google.com, nikunj@amd.com, seanjc@google.com,
        diviness@google.com, maz@kernel.org, dmatlack@google.com,
        axelrasmussen@google.com, maciej.szmigiero@oracle.com,
        mizhang@google.com, bgardon@google.com,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series implements selftests executing SEV VMs to target the feature
floated by Chao via:
https://lore.kernel.org/linux-mm/20220706082016.2603916-12-chao.p.peng@linux.intel.com/T/

Below changes aim to test the fd based approach for guest private memory
in context of SEV VMs executing on AMD SEV compatible platforms.

sev_private_mem_test.c file adds selftest to access private memory from the
guest via private/shared accesses and checking if the contents can be
leaked to/accessed by vmm via shared memory view before/after conversions.

To allow SEV/SEV-ES VMs to toggle the encryption bit during memory
conversion, support is added for mapping guest pagetables to guest va
ranges and passing the mapping information to guests via shared pages.

This series has dependency on following patch series:
1) V7 series patches from Chao mentioned above.
2) https://lore.kernel.org/lkml/20220810152033.946942-1-pgonda@google.com/T/#u
  - Series posted by Peter containing patches from Michael and Sean
3) https://lore.kernel.org/lkml/Ywa9T+jKUpaHLu%2Fl@google.com/T/
  - Series posted for similar selftests executing non-confidential VMs.

Github link for the patches posted as part of this series:
https://github.com/vishals4gh/linux/commits/sev_upm_selftests_rfcv2

Vishal Annapurve (8):
  selftests: kvm: x86_64: Add support for pagetable tracking
  kvm: Add HVA range operator
  arch: x86: sev: Populate private memory fd during LAUNCH_UPDATE_DATA
  selftests: kvm: sev: Support memslots with private memory
  selftests: kvm: Update usage of private mem lib for SEV VMs
  selftests: kvm: Support executing SEV VMs with private memory
  selftests: kvm: Refactor testing logic for private memory
  selftests: kvm: Add private memory test for SEV VMs

 arch/x86/kvm/svm/sev.c                        |  99 ++++++-
 include/linux/kvm_host.h                      |   8 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/kvm_util_base.h     | 105 +++++++
 .../kvm/include/x86_64/private_mem.h          |  10 +-
 .../include/x86_64/private_mem_test_helper.h  |  13 +
 .../selftests/kvm/include/x86_64/sev.h        |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  78 ++++-
 .../selftests/kvm/lib/x86_64/private_mem.c    | 189 ++++++++++--
 .../kvm/lib/x86_64/private_mem_test_helper.c  | 273 ++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  32 ++
 tools/testing/selftests/kvm/lib/x86_64/sev.c  |  15 +-
 .../selftests/kvm/x86_64/private_mem_test.c   | 246 +---------------
 .../kvm/x86_64/sev_private_mem_test.c         |  21 ++
 virt/kvm/kvm_main.c                           |  87 +++++-
 16 files changed, 880 insertions(+), 301 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/private_mem_test_helper.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/private_mem_test_helper.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_private_mem_test.c

-- 
2.37.2.672.g94769d06f0-goog

