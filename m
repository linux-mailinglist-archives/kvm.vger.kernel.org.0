Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467235A1D16
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 01:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244306AbiHYXZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 19:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244336AbiHYXZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 19:25:27 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572A252821
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:25:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3328a211611so362777327b3.5
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc;
        bh=y2TyZVHOzKZlb9wECS9yMCNcXCNpwqCPWpTxl29+IMY=;
        b=dkM+A09pjx32V3tjxCAZAaj4iTr2QWwZFTx14MwcUXXnZscAY3fsOcj6h5WXQXxdoD
         pE2ASAcwod4FD0N0sCT4FjUT0tg9Opertqs8xb3KgjTkUGEmN0krLyCYuuqUGRjMcltU
         i55uCtWc8Su1TGA6H/a9JTuhvCJcNgBM50Y1A4ihMCdqTUfplBKQUaiEUX2n1Vh4N710
         3yOt5OJYxOGq7VwXawE8F72ZOkRT8JCFAjGnVJAcUhtb87iwBUwK1cOzoECBWrP6U0Ke
         ZtEkGqxLhvl3GVE9ZNy1Tt1CBoQxoOnHS9H5jY9/byfHRVWvrd+Zhz17D7ZlFyP3ffIM
         c1wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=y2TyZVHOzKZlb9wECS9yMCNcXCNpwqCPWpTxl29+IMY=;
        b=HgVlho/T6ijbY51NBFbaJvL0XlthdGIMbPUkKH55sE2UsbGX9d1wzM74q8orB7mS+b
         +qXOgbqXwzGx77vaysiHNvxfGEXwN/sP1M2wyNNlj6TrFa0zh3JMFz+MKXfx1r9xdvgM
         AIdV+8A0o0JIZCjU+Z3VJWEHYww5m4cSSzlBVcEcwgFgcvE8URli2yFh7CYer1bpRCMO
         cGEacicAl1lVSPrZ95E3uSl2hmGoc8IL/plJcSwPdUG5wSIcJyH8WQf+cujhu7cDQfo3
         UGVP2pJ3GLWnsRvgHm85F6HmRxUJYmKLowuMbTDM2bZ/4Ar6c/wYIHyMJ197QTq57P6i
         wv8w==
X-Gm-Message-State: ACgBeo2ItrbmeXkmAKXVk0c0QQlWz/i2xNQpXSIs+7Yq2rZ8/CwVsCE2
        UAOCTV+KBOdl2j9YNoo7Knww2hZyqCo=
X-Google-Smtp-Source: AA6agR4iAX55dcIo3IUqvlfKkqmyFpPiECgmLWRpTah2t3s+pqlFTA2hJbEvjHCDMn3ntt/fdb4I5rKg3Mw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6143:0:b0:335:3076:168e with SMTP id
 v64-20020a816143000000b003353076168emr5851445ywb.460.1661469924695; Thu, 25
 Aug 2022 16:25:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 23:25:15 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825232522.3997340-1-seanjc@google.com>
Subject: [PATCH v5 0/7] KVM: selftests: Implement ucall "pool" (for SEV)
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

v5:
 - Use less convoluted method of writing per-VM "globals". [Oliver]
 - Add patch to drop ucall_uninit().

v4: https://lore.kernel.org/all/20220824032115.3563686-1-seanjc@google.com

Peter Gonda (2):
  tools: Add atomic_test_and_set_bit()
  KVM: selftests: Add ucall pool based implementation

Sean Christopherson (5):
  KVM: selftests: Consolidate common code for populating ucall struct
  KVM: selftests: Consolidate boilerplate code in get_ucall()
  KVM: selftests: Automatically do init_ucall() for non-barebones VMs
  KVM: selftests: Make arm64's MMIO ucall multi-VM friendly
  KVM: selftest: Drop now-unnecessary ucall_uninit()

 tools/arch/x86/include/asm/atomic.h           |   7 ++
 tools/include/asm-generic/atomic-gcc.h        |  12 +++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/arch_timer.c        |   1 -
 .../selftests/kvm/aarch64/debug-exceptions.c  |   1 -
 .../selftests/kvm/aarch64/hypercalls.c        |   1 -
 .../testing/selftests/kvm/aarch64/psci_test.c |   1 -
 .../testing/selftests/kvm/aarch64/vgic_init.c |   2 -
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   1 -
 tools/testing/selftests/kvm/dirty_log_test.c  |   3 -
 .../selftests/kvm/include/kvm_util_base.h     |  15 +++
 .../selftests/kvm/include/ucall_common.h      |  10 +-
 .../selftests/kvm/kvm_page_table_test.c       |   2 -
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 102 +++---------------
 tools/testing/selftests/kvm/lib/kvm_util.c    |  11 ++
 .../selftests/kvm/lib/perf_test_util.c        |   3 -
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  42 ++------
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  39 ++-----
 .../testing/selftests/kvm/lib/ucall_common.c  | 102 ++++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  39 ++-----
 .../testing/selftests/kvm/memslot_perf_test.c |   1 -
 tools/testing/selftests/kvm/rseq_test.c       |   1 -
 tools/testing/selftests/kvm/steal_time.c      |   1 -
 .../kvm/system_counter_offset_test.c          |   1 -
 24 files changed, 189 insertions(+), 210 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.2.672.g94769d06f0-goog

