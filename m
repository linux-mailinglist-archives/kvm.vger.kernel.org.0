Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3844F053C
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 19:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243631AbiDBRmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 13:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiDBRml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 13:42:41 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40613DF82
        for <kvm@vger.kernel.org>; Sat,  2 Apr 2022 10:40:49 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id g2-20020a056e02130200b002c837b25e60so3706168ilr.20
        for <kvm@vger.kernel.org>; Sat, 02 Apr 2022 10:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RL+g93Fijo1SZ8lwfn+Xp7o4bffPLL5ZnXUT6dIwBzU=;
        b=jczsRYruEZAo5WKmoWBK5h9QZfLDn8n1TXFMm6z7O5w5ywolfcnyEixifD0NojlNnV
         KAHqCd/80lYyWIxinRrWpQ6WI+9qcgcD/wT3SQMYw1TPYNWDO3yxvq5J/KUV+5zfUFHn
         N39L/g8DKNJXDMxWHTc+MtWTYW78lMwhKUfqG2kbIxFFEpvIZTO5xLeT4YHvil+DTTee
         nkg/53P1GB18loNhh6P4ztw61Rsa+JbDMPj+g0zX9HZ1CCi8nYLa29eQlnjUiXyyXu2D
         v6t/VdoaGhi/g9jKMdnpb1eNlcGnA8E4iU4S/Ti2iqU3vH90pLUfLeiG7SyeESxPYDQE
         oTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RL+g93Fijo1SZ8lwfn+Xp7o4bffPLL5ZnXUT6dIwBzU=;
        b=lPxbN9XlNBourXu0gsx45UGGWYD4vH4RJeD4ofpXChvE47+AUVccyx9d8VQ3RgeupR
         Z7smj2tBplBxwqWT67ZNFVefe2T6MI3TO9CFSbW7T7uxxrMCWmWm8Na3o2ATwqlrbiCJ
         3lGH/1AmykH+K0HZJYCeCZ06IS6rPmHzK4rTx9vXxunUfPpNNNa24wvu/DcJ5h37CwHS
         hLhM0tMUnyqjDT0NFh3Sxdzk7am3IiJxWn0bQCjjcs5CMW6vJ+5C7BmAqPF6KlWhqxKB
         iDLov2lIgDHzTkuKqB8S5O+8BfiCanzdo6J6tRXKDX5pIuHgv8I8GiSR3PbGKWYjGlyG
         BxMw==
X-Gm-Message-State: AOAM532bHaHkpcVW8w27qi7oI9EnAdN2atKaCPGoceOvfWyd6Pj5U5OM
        J08kDxQRLHZeqgBe0IGZ8f1Q4GdCAZM=
X-Google-Smtp-Source: ABdhPJzYn6lVkuhXlh2hTOvp36IECh6AGHkLwh7F6GtH58BHozTY1KxCiZKAVNa+Y+rlLwHIPZK/zxqBLAA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1645:b0:646:4780:fc28 with SMTP id
 y5-20020a056602164500b006464780fc28mr2144945iow.194.1648921248546; Sat, 02
 Apr 2022 10:40:48 -0700 (PDT)
Date:   Sat,  2 Apr 2022 17:40:40 +0000
Message-Id: <20220402174044.2263418-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 0/4] KVM: arm64: Fix use-after-free in debugfs
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
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

Funny enough, dirty_log_perf_test on arm64 highlights some issues around
the use of debugfs in KVM. The test leaks a GIC FD across test
iterations, and as such the associated VM is never destroyed.
Nonetheless, the VM FD is reused for the next VM, which collides with
the old debugfs directory.

Where things get off is when the vgic-state debugfs file is created. KVM
does not check if the VM directory exists before creating the file,
which results in the file being added to the root of debugfs when the
aforementioned collision occurs.

Since KVM relies on deleting the VM directory to clean up all associated
files, the errant vgic-state file never gets cleaned up. Poking the file
after the VM is destroyed is a use-after-free :)

Patch 1 takes care of the immediate problem by refusing to create the
file if the VM directory does not exist.

Patch 2 tones down logging around debugfs collisions. As demonstrated by
the selftest, this is most likely to happen for a userspace bug, not
KVM.

The last two patches ensure the GIC FD actually gets closed by the
selftests that use it. Patch 3 is a genuine bug fix since it will create
multiple VMs for a single test run. The arch_timer test also happens to
leak the GIC FD, though it is benign since the test creates a single VM.
Patch 4 gets the arch_timer test to follow the well-behaved pattern.

Applies cleanly to the first KVM pull (tagged kvm-5.18-1), at commit:

  c9b8fecddb5b ("KVM: use kvcalloc for array allocations")

The series is intentionally *not* based on the kvmarm/fixes tree because
there is a small dependency on commit:

  456f89e0928a ("KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3")

which isn't present in the fixes branch.

Tested on an Ampere Altra system in the following combinations:

  - Bad kernel + fixed selftests
  - Fixed kernel + bad selftests

In both cases there was no dmesg spew and no unintended vgic-state file
at the root of debugfs.

Oliver Upton (4):
  KVM: arm64: vgic: Don't assume the VM debugfs directory exists
  KVM: Only log about debugfs directory collision once
  selftests: KVM: Don't leak GIC FD across dirty log test iterations
  selftests: KVM: Free the GIC FD when cleaning up in arch_timer

 arch/arm64/kvm/vgic/vgic-debug.c              |  3 ++
 .../selftests/kvm/aarch64/arch_timer.c        | 15 +++++---
 .../selftests/kvm/dirty_log_perf_test.c       | 34 +++++++++++++++++--
 virt/kvm/kvm_main.c                           |  2 +-
 4 files changed, 46 insertions(+), 8 deletions(-)

-- 
2.35.1.1094.g7c7d902a7c-goog

