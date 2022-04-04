Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5504F1BA2
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380700AbiDDVVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379926AbiDDSXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:23:25 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B8F22B20
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:21:28 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id b8-20020a92db08000000b002c9a58332cbso6603024iln.16
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 11:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8WwwRyCeCeMlIzr9SxYzcSTADq8P7PlbsRggytaLcp4=;
        b=VQaIdErXUgdjfuVxv831Q/UJ1CWc5wWY7lxH3zvCVtXh16fjW923ZCg+YZuUsWju3h
         4ILe42584P0T1xmue23EdXWW7PxQVhSS77wXAmPxATMxy/cGsyGIM6bUkch6ZVyRElCQ
         rYfBdRc5h8GB9QfjxeOjmesVjpoFyeeH8Zu3wSnbSfQxQ3f/BrQJ4KI3CO5dBC0PNy47
         Yq8oCV8PCHMfzHfZRdiUAWzfhsKGQ1Hpzi816xxYXKutJYAFxMS/T/Z1CZFLs+IWzaVH
         muqotKois0KT0BZ6aZswP/2F+KHpolFWLj99t2uLkL2he7pDHDC+m/o+W1S/4MwTh6cX
         aMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8WwwRyCeCeMlIzr9SxYzcSTADq8P7PlbsRggytaLcp4=;
        b=3SWP+DaiMkknvjHkHRmuPAxUV1fdsD0YMKnaw5kaf8gKBWsZGx6PPmKSdRtnUJJRsc
         IPCEibLA50Jdc+kjlcWlf+l7rRzVTIwRDOYNh2DdOnAcLVSQj16LVWm0/xaDoRlWs+7D
         tiIypOXemZCuCFYtydetS5UBV7savHVweR61AfbF+q2bhgdDdyx1JA25XuUydcJfLsAY
         roLPfNxquqLidpz6rzOfUei8AE1igod/3jdAlca9wuNQ9a0ZdAHlfx8hlmWlFUyQeezm
         ifTOwIIjo3nida59hQtHuIY8Dsx0ynPumEMM81CzzQrqDkUW+A18jv1ED0InVHJ3MuzD
         u5+g==
X-Gm-Message-State: AOAM530z61XMqMoHBpSlxZCihg4UbHsERzf3TK8aGdwjUEHFwSCQwNti
        b6ARkeUbyWngUeBvQfr9bna8Krrav3Q=
X-Google-Smtp-Source: ABdhPJwvPmo526HelrAxxb/UEnfhShlEth+Y810soIVt6pAr1nUtlqyUQGi/Lx6WU18UFIH94tuineOFKlE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:e40a:0:b0:64c:8ce1:3757 with SMTP id
 u10-20020a6be40a000000b0064c8ce13757mr727788iog.106.1649096487896; Mon, 04
 Apr 2022 11:21:27 -0700 (PDT)
Date:   Mon,  4 Apr 2022 18:21:16 +0000
Message-Id: <20220404182119.3561025-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 0/3] KVM: Fix use-after-free in debugfs
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

Patch 1 shuts the door on any mistaken debugfs file creations by
initializing kvm->debugfs_dentry with ERR_PTR() instead of NULL.

The last two patches ensure the GIC FD actually gets closed by the
selftests that use it. Patch 2 is a genuine bug fix since it will create
multiple VMs for a single test run. The arch_timer test also happens to
leak the GIC FD, though it is benign since the test creates a single VM.
Patch 3 gets the arch_timer test to follow the well-behaved pattern.

Applies cleanly to the second KVM pull (tagged kvm-5.18-2), at commit:

  c15e0ae42c8e ("KVM: x86: fix sending PV IPI")

Tested on an Ampere Altra system in the following combinations:

  - Bad kernel + fixed selftests
  - Fixed kernel + bad selftests

In both cases there was no vgic-state file at the root of debugfs.

v1: https://lore.kernel.org/kvm/20220402174044.2263418-1-oupton@google.com/

v1 -> v2:
 - Initialize kvm->debugfs_dentry to ERR_PTR(-ENOENT) to prevent the
   creation of all VM debug files, not just vgic-state.
 - Leave logging as-is for now. Consider dropping altogether in a later
   patch (Sean)
 - Collect R-b from Jing

Oliver Upton (3):
  KVM: Don't create VM debugfs files outside of the VM directory
  selftests: KVM: Don't leak GIC FD across dirty log test iterations
  selftests: KVM: Free the GIC FD when cleaning up in arch_timer

 .../selftests/kvm/aarch64/arch_timer.c        | 15 +++++---
 .../selftests/kvm/dirty_log_perf_test.c       | 34 +++++++++++++++++--
 virt/kvm/kvm_main.c                           | 10 ++++--
 3 files changed, 50 insertions(+), 9 deletions(-)

-- 
2.35.1.1094.g7c7d902a7c-goog

