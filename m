Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF34B6ACD6A
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 20:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjCFTCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 14:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjCFTCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 14:02:20 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B222F791
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 11:02:00 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id n196-20020a2540cd000000b00889c54916f2so11543006yba.14
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 11:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678129319;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C+DxnQV3hp0RGd+ug96FCObNfG/ILFIXHP4OvcDjXtA=;
        b=VWgYmSrmEfZIk/6E1VMbGjDaim/LrqhaEaWbHuc+fH+V6S1DKdJkRtZ34FezlMlvhM
         U6mcoknL3sAYb7G1m+RD4Ig6gMHZ3RTQuTmwizQCiRBj2rGy41IyS90Qy6jvQXVsrewL
         9SFoAxeMBzW5t2TD3YILUvsMiBUCUbLVi57NBysGJg1yYn7YuGGMcpOxrx1eRRLBIO55
         6Jbb9BwFCYffUcjzVZAFu0HkR94u7+bMfdsXfZ8y0VaWIgzYSxnsXzYIhqkR9LOZ5C0I
         6G5p1/Kff9hdoITAYU26Wdj64V3gzTqUAgddrH7mg7Qk+8AvTWLN0NmGqN/B0ffPRXLb
         3ITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678129319;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C+DxnQV3hp0RGd+ug96FCObNfG/ILFIXHP4OvcDjXtA=;
        b=xnF46SikBY3JhtBCw2tGuRdeZ5YNHAv0JtAmnyjvBQLM4Tq2Wnc2xZ/XREedIMWll1
         OAKOYqBzJqxeO/rrZlCJk5fhsM2SABM8xTSSPh0MxDGIVdjg/zBJwbhXuH59ssckpogG
         Sp3KOhJpItB0n67Lf56pjE+gl2vYXNOVIDZQk5gqnlFn4/6l3mo0zYMUcmR8iATtXrM0
         zlrHjpZHUEUxJPF7R+a6iUPAeI3/isd0DrYuPYDDRf1vwHz6m489dYVquhAwpy3ayX4q
         XZ/u5UtTAngVTdp3dbV+at80lJ/BpjbE6dha6uxCESQRkBkQYHYTjfRw1E2BgBj34HpM
         PUMQ==
X-Gm-Message-State: AO0yUKXKVg656ufTmWk3VCtBS8ncIyg9ZQA9H7pYc23HCButjYiHkFLo
        /XynNqcacZWNDkE6xToPNL3e8mIiWYMfaA==
X-Google-Smtp-Source: AK7set/pVosUQpXpF+342Y6QcFu+4eURtJP2+OiNzV4zJi7D/yZ3hybJi6gL3lLKDOrFj5EE1HIssi/eN+VpiA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:b723:0:b0:536:38b4:f51 with SMTP id
 v35-20020a81b723000000b0053638b40f51mr7493840ywh.5.1678129319569; Mon, 06 Mar
 2023 11:01:59 -0800 (PST)
Date:   Mon,  6 Mar 2023 11:01:52 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306190156.434452-1-dmatlack@google.com>
Subject: [PATCH v2 0/4] KVM: Refactor KVM stats macros and enable custom stat names
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        David Matlack <dmatlack@google.com>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
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

This series refactors the KVM stats macros to reduce duplication and
adds the support for choosing custom names for stats.

Custom name makes it possible to decouple the userspace-visible stat
names from their internal representation in C. This can allow future
commits to refactor the various stats structs without impacting
userspace tools that read KVM stats.

This also allows stats to be stored in data structures such as arrays,
without needing unions to access specific stats. Case in point, the last
patch in this series removes the pages_{4k,2m,1g} union, which is a
useful cleanup to prepare for sharing paging code across architectures
[1].

And for full transparency, another motivation for this series it that at
Google we have several out-of-tree stats that use arrays. Custom name
support is something we added internally and it reduces our technical
debt to get the support merged upstream.

Tested on x86. Compile tested on ARM. Not yet tested on any other
architectures.

Link: https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/

v2:
 - Refactor stat macros (patch 1) to reduce duplication and make it
   simpler to add custom name support [Sean]

v1: https://lore.kernel.org/kvm/20230118175300.790835-1-dmatlack@google.com/

David Matlack (4):
  KVM: Refactor stats descriptor generation macros
  KVM: Refactor designated initializer macros for struct _kvm_stats_desc
  KVM: Allow custom names for KVM_STAT()
  KVM: x86: Drop union for pages_{4k,2m,1g} stats

 arch/arm64/kvm/guest.c          |  14 +--
 arch/mips/kvm/mips.c            |  54 ++++-----
 arch/powerpc/kvm/book3s.c       |  62 +++++-----
 arch/powerpc/kvm/booke.c        |  48 ++++----
 arch/riscv/kvm/vcpu.c           |  16 +--
 arch/s390/kvm/kvm-s390.c        | 198 ++++++++++++++++----------------
 arch/x86/include/asm/kvm_host.h |   9 +-
 arch/x86/kvm/x86.c              |  94 +++++++--------
 include/linux/kvm_host.h        | 179 +++++++++++------------------
 9 files changed, 314 insertions(+), 360 deletions(-)


base-commit: 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

