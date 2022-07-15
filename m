Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4EE576766
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiGOTaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 15:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiGOTaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 15:30:06 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7965F53D02
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:05 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c15-20020a170902d48f00b0016c01db365cso2530292plg.20
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gkgKpwVwA4E3gWq6qL1j4dPhRtpeKr2Jzdx8/7HPNSs=;
        b=aslo0vKzkT3JyIBadqQ5iK76yx3fZ4Vw0o/B/f6rwRPhrGp/ayrUVsSQtEoOmdCQeK
         DcFwsTjumSG+cs59zXI3Mwy9wAhjclOp55v0FkyGkMH/F5PbXwtEU8dJ/+DHCaVCnceA
         +WrcjHM5PTPK1o+ZXqAYejgZGbJqycswqGMkwmv0McKf8I+QNxc3MnNAbTlfhsVmdFPq
         Y2NlMuEgcXerJ9e8OtcODzZNGVCYsXEErzwaeRu7kuLgbqTH48DiopLDsGOZts6tFqyA
         xab1rp7DEuLj8WVA+xdesPykNtBtDNb9IRIrIdHeIumYC4dczKYB42h9wrlIf+Cs3JBL
         4qWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gkgKpwVwA4E3gWq6qL1j4dPhRtpeKr2Jzdx8/7HPNSs=;
        b=gHMZPF8F8RWNYJV/pTEEBQZyg0iQnT46C782en6OclMSc8dnmUNdVGtFvQBbtMpthe
         7LJUsetLTSEslZ1SoXTQoqDOY4mRLZLVFk+evyL43E3RFcKN9YsnBys6WAd85k8b/xCs
         KEKAhBUF4y0NstiI6CPIL53K4iHlJ8Bp84xv4BZJ7Egigh4bzFo9hTCQZ3kkCxzlvfUf
         V2IUKTK0RfUMsIMk0JSnHdex0Yh9swPUw0yfirl/z2I6WA1nbEpojpRDWojWajJHmf+W
         KFiPpaNAR6bPqat0Y492k8HQE6XT15KJYe914//f4XHVAmedd2Rwk38Kjjarbka/xHal
         neHQ==
X-Gm-Message-State: AJIora/RhtMelGocw6/zzty1XTWIdNwN2AieZlDkn5Kw+qF2DTpE9f0O
        GQ+FPep2nDHenxt1gCNaDVErJf7MLtVSdHTtjFaqHmCwcx3JEfws4/wenP4sSzTXKHp6zjEiuRD
        t4UHn2NAbe7h1rlrOOlqRHPzbFd9I0zYxvGJDcau5/xDduD3fOw8z5SabUw==
X-Google-Smtp-Source: AGRyM1sDzmuNLp8E8I/r8DKUVDldNx7DbXD2RlLHhysYjXKFPVqY+ZRy5difu7/iX0BqofSdlsyp9xNwEUs=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:bd4e:b81d:4780:497d])
 (user=pgonda job=sendgmr) by 2002:a17:903:22d0:b0:16b:f798:1cff with SMTP id
 y16-20020a17090322d000b0016bf7981cffmr14911719plg.23.1657913404935; Fri, 15
 Jul 2022 12:30:04 -0700 (PDT)
Date:   Fri, 15 Jul 2022 12:29:45 -0700
Message-Id: <20220715192956.1873315-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [RFC V1 00/10] *** KVM: selftests: Add simple SEV test
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series combines the work Michael Roth has done in supporting
SEV guests in selftests and the work Sean Christopherson suggested to
allow ucalls from SEV guests. And the work Sean has sent to consolidate
the ucall boilerplate code. Along with a very simple version of the
SEV selftests Michael originally proposed.

Michael Roth (7):
  KVM: selftests: move vm_phy_pages_alloc() earlier in file
  KVM: selftests: sparsebit: add const where appropriate
  KVM: selftests: add hooks for managing encrypted guest memory
  KVM: selftests: handle encryption bits in page tables
  KVM: selftests: add support for encrypted vm_vaddr_* allocations
  KVM: selftests: add library for creating/interacting with SEV guests
  KVM: selftests: Add simple sev vm testing

Sean Christopherson (1):
  KVM: selftests: Consolidate boilerplate code in get_ucall()

Peter Gonda (2):
  tools: Add atomic_test_and_set_bit()
  KVM: selftests: Make ucall work with encrypted guests

 tools/arch/x86/include/asm/atomic.h           |   7 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../selftests/kvm/include/kvm_util_base.h     |  50 +++-
 .../testing/selftests/kvm/include/sparsebit.h |  36 +--
 .../selftests/kvm/include/ucall_common.h      |  15 +-
 .../selftests/kvm/include/x86_64/sev.h        |  44 +++
 .../testing/selftests/kvm/lib/aarch64/ucall.c |  36 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 268 +++++++++++++-----
 .../selftests/kvm/lib/perf_test_util.c        |   2 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  40 +--
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  37 +--
 tools/testing/selftests/kvm/lib/sparsebit.c   |  48 ++--
 .../testing/selftests/kvm/lib/ucall_common.c  | 140 +++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 251 ++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  37 +--
 .../selftests/kvm/x86_64/sev_all_boot_test.c  | 134 +++++++++
 18 files changed, 903 insertions(+), 262 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

-- 
2.37.0.170.g444d1eabd0-goog

