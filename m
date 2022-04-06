Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1B14F6EDD
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiDFX6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbiDFX6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:58:20 -0400
Received: from mail-ot1-x34a.google.com (mail-ot1-x34a.google.com [IPv6:2607:f8b0:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60684B898A
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 16:56:21 -0700 (PDT)
Received: by mail-ot1-x34a.google.com with SMTP id q18-20020a05683022d200b005b23730dc8eso1997713otc.19
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 16:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fwRsymA/7INPtz5uOlj06FEv7kVaB+utCnxy48AEBxo=;
        b=tHLPte6eqKvlyXBDRIPYKCLDrChMHfeEZx8L7EPrTciBSzA6GjKpM2hUwRIYgHL8Vf
         WbCFZFSQ9yjysfEoEe4joScrVi5mWuEF2Vob3FNBUpKhJeBqSQ5OUv0iGoQdYiOK3Fu4
         wpNOytV1B1GSyY1bwSDaky8abQgztkae3aVbObEoU+tWdOgD8KIv3x9c/q1kpnV9aZIS
         22nklc+Qm6pR7fNYrGUQ8dIFklA+X3FGgUoHCSvSGaoFRvqAVXXDZ7VJpPdOtnigUFx1
         88GQMckg6WyOIQp4YdnS0X6Y4sXKV8n49HaaujyeVOacYu/K7GGyZce1+22r1+vUdDZf
         MTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fwRsymA/7INPtz5uOlj06FEv7kVaB+utCnxy48AEBxo=;
        b=KV/AKr/ULWOvSP3lpV2+0x10u7SIPN3aW4ZmLGtvxIORdxu9JrEzfM59DPuwF6aSQI
         hb1IOf617hUCcRiAjyGpIhBhCS0DKA4rqMKXt8KFMrkkO6eBalobMAVRwqcsXT5h+6YH
         W5/iD00RnbLSjB347EOU+B3BhowSo44eIYjpbAx6+U8cV5OvgHLoFG9aR1qIZWGd9g6+
         TzTT3N1BxNaGEJEq9lu3zCvu4d03vD6YeiPIqc3GQKHR8CSykmeEWSNwZw8x++mPEhtA
         RsIJb2lNESbDk7vELDc+ImOpeOHWvGztE5aZKlYdUm8GqdzRNFGYze/wGmmxNOHlFq+o
         fxiQ==
X-Gm-Message-State: AOAM532KNjqQ8uh5cR3+Fmg+U6q+KPj+BjwQOi2+gLGpNiINszQ4Za+P
        tR8SnO/w664wn5XRW0Z/8yaj8Pm1vlY=
X-Google-Smtp-Source: ABdhPJzj/VGxAMS1iBtHTXCMn1pekmLm2UMBGpiITgnFbH8BraR4aqQ8P5nQ2xVOA8GyeF2fPqDC5v3aSnw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6870:c698:b0:de:8a16:c37 with SMTP id
 cv24-20020a056870c69800b000de8a160c37mr5259350oab.191.1649289380523; Wed, 06
 Apr 2022 16:56:20 -0700 (PDT)
Date:   Wed,  6 Apr 2022 23:56:12 +0000
Message-Id: <20220406235615.1447180-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 0/3] KVM: Fix use-after-free in debugfs
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

Applies cleanly to 5.18-rc1.

Tested on an Ampere Altra system in the following combinations:

  - Bad kernel + fixed selftests
  - Fixed kernel + bad selftests

In both cases there was no vgic-state file at the root of
debugfs. Additionally, I made sure the VM debugfs directory was in fact
cleaned up at exit.

v1: https://lore.kernel.org/kvm/20220402174044.2263418-1-oupton@google.com/
v2: https://lore.kernel.org/kvm/20220404182119.3561025-1-oupton@google.com/

v2 -> v3:
 - Fix error checking in kvm_destroy_vm_debugfs(). Embarrassingly, v2
   worsened the bug by not cleaning up the VM directory... (Marc)

v1 -> v2:
 - Initialize kvm->debugfs_dentry to ERR_PTR(-ENOENT) to
   prevent the creation of all VM debug files, not just vgic-state.
 - Leave logging as-is for now. Consider dropping altogether in a
   later patch (Sean)
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

