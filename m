Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68AE59F1F9
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiHXDVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiHXDVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:21:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A3D7E010
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:21:18 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oo12-20020a17090b1c8c00b001faa0b549caso218818pjb.0
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=0PgRhcNFQ7wUH/xHyENNgGO5Y68ff82pBwc9ifNEyXw=;
        b=cqHjEyrC8/5Ptg3s0VemFx6Afe05DyCrV8I1WrMH2BuvEwwsDY1YsrbGXctw65VldG
         fAmhyiPz7pkRXrbwBZ38vyCPLv5QBCP4oH+/gu1mKhgYTPOR+Ya+5b3VA+2WH98XQmBq
         1FOvFOP3tIyLS9BehwIqIBtCj8lM/BvWhTdiI/ce9pRiN9eKP9sHPyAITpNwOJ3sO+2N
         4YCabFxHGqjIDcC9CP17NKHtJTtA5CdGAUad7ynG0wNtC4Vfe2QJX6PECaOymuHUk10t
         PuRSnM35P9sTAO+sSnGlTY4exlZjjiMPgXiy+eydM2ZxalQexAZSKP4RIGtkmpgCQfsB
         7euw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=0PgRhcNFQ7wUH/xHyENNgGO5Y68ff82pBwc9ifNEyXw=;
        b=DjkS4mUkpdFA9L6OKobwh/bGtstDej+uVSDWZEEJRNdERnm0EJdKCJZ0QiXUSs/Ce8
         HJkr2j7vAHVFTZ4zNxTirJZ55k+UDaNl7bwmTHRxx5Vm486mLLoYjhoqJ7CRKmYctpnV
         F/iVevoRloGYKt3U+AMjZVceYcvBESI2pL+knJ3dv82Ns2NguohM+Qxm5l5a5lmhw77a
         0miaaSupsGXwBbkxokp95/xWmqvGjZ5nQWeWlaaRsjRteagInjFiKWbWnxcTJ0rgR/bs
         QEh4eKho+6Ce/KkAYAa3W+7BHp1cVtYe6pLb8TP+Yo+iop4x4wIBrPwUyEJr58SjPiaL
         H3HQ==
X-Gm-Message-State: ACgBeo02Nq4tsFCd2CfpqZG1Spguh7pHJ9/FkPWcuY+p9uGc7E1UiMaw
        xZygsfQp0DeUqiNizYVSnjxc5c/N3fY=
X-Google-Smtp-Source: AA6agR63ilrlfg+EIittKBqsUyfiZ4SJp+plrm1tSJz8p5Jon3Gzg8eg5LcSRgWaSK1dHMSOxMnJUkNlhh0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ba8e:b0:172:ddb9:fe45 with SMTP id
 k14-20020a170902ba8e00b00172ddb9fe45mr14718860pls.86.1661311277642; Tue, 23
 Aug 2022 20:21:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:21:09 +0000
Message-Id: <20220824032115.3563686-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v4 0/6] KVM: selftests: Implement ucall "pool" (for SEV)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Peter Gonda <pgonda@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Sean Christopherson <seanjc@google.com>
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

This is "v4" of Peter's SEV series, minus the actual SEV tests.  My plan
is to get this queued sooner than later so that Peter can build on top.

Non-KVM folks, y'all got pulled in because of the atomic_test_and_set_bit()
patch.

Rework the ucall infrastructure to use a pool of ucall structs to pass
memory instead of using the guest's stack.  For confidential VMs with
encrypted memory, e.g. SEV, the guest's stack "needs" to be private memory
and so can't be used to communicate with the host.

Convert all implementations to the pool as all of the complexity is hidden
in common code, and supporting multiple interfaces adds its own kind of
complexity. 

Tested on x86 and ARM, compile tested on s390 and RISC-V.

Peter Gonda (2):
  tools: Add atomic_test_and_set_bit()
  KVM: selftests: Add ucall pool based implementation

Sean Christopherson (4):
  KVM: selftests: Consolidate common code for populating ucall struct
  KVM: selftests: Consolidate boilerplate code in get_ucall()
  KVM: selftests: Automatically do init_ucall() for non-barebones VMs
  KVM: selftests: Make arm64's MMIO ucall multi-VM friendly

 tools/arch/x86/include/asm/atomic.h           |   7 ++
 tools/include/asm-generic/atomic-gcc.h        |  12 ++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/arch_timer.c        |   1 -
 .../selftests/kvm/aarch64/debug-exceptions.c  |   1 -
 .../selftests/kvm/aarch64/hypercalls.c        |   1 -
 .../testing/selftests/kvm/aarch64/psci_test.c |   1 -
 .../testing/selftests/kvm/aarch64/vgic_init.c |   2 -
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   1 -
 tools/testing/selftests/kvm/dirty_log_test.c  |   2 -
 .../selftests/kvm/include/kvm_util_base.h     |  16 +++
 .../selftests/kvm/include/ucall_common.h      |  13 +-
 .../selftests/kvm/kvm_page_table_test.c       |   1 -
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 101 +++-------------
 tools/testing/selftests/kvm/lib/kvm_util.c    |  11 ++
 .../selftests/kvm/lib/perf_test_util.c        |   2 -
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  40 ++----
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  37 ++----
 .../testing/selftests/kvm/lib/ucall_common.c  | 114 ++++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  37 ++----
 .../testing/selftests/kvm/memslot_perf_test.c |   1 -
 tools/testing/selftests/kvm/rseq_test.c       |   1 -
 tools/testing/selftests/kvm/steal_time.c      |   1 -
 .../kvm/system_counter_offset_test.c          |   1 -
 24 files changed, 213 insertions(+), 192 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.1.595.g718a3a8f04-goog

