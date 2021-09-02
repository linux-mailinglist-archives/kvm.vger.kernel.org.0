Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310D63FF31B
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhIBSTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346926AbhIBSTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:19:00 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73081C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 11:18:01 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id hg16-20020a17090b301000b00196f63fb4a5so198655pjb.7
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 11:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WUJB2jmEeJlpPyDhfMXOa3YVNomSYYpkpPsVjv3Vi5o=;
        b=MZf2/CTC/QgLAsLsI+3PH8XaVrqFLQG6zKqbfXujTSBkgIUrW2jd2kAzS/aQ8J49lr
         fXOGMmGIDWDrzhTuKH24HivJL/8gDhitHcpU3U7Lo2PWL7nBdGb7OAa0fzK5F3zKB/A4
         iMyIi/VWB//qyhHj1MyGsYET1gkNbq2wv1chsLjaG0120eiis1KuXQKvP7jzytk8e2i0
         Qt1JYv4KQEp78X6GffXKZUcLnR3hD83pntsEDFhvn41zxaGqe48Cx7whQudSt/i2UD6l
         xb7xXX6qS9Wx5Q2XHWtM15jgnbSrfjzdDYGOCqUqyOd54qZt2ELq/wWRSpgHZbFB8voW
         W04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WUJB2jmEeJlpPyDhfMXOa3YVNomSYYpkpPsVjv3Vi5o=;
        b=T0421aJoH36zQN9FC8GCFanWw7aTTkwX/SgVRrp4DQy4V5IQpyX8rGKACKrhcSFki+
         ZuW4SxuiTIju31jxU2WAY3zHs+3yJaU0hr3FWyPxPz4QBhgieysiXhbyGLQw0F3OzNJ3
         xcsArZ3WC1bDLCnfpxEqbh3vwnPIqYWBESUzEHKPY8qL5nvf2q6mCdqCYbDJH8/qYTpW
         NOMjegrCfcYmXl7XPmtLdmff8uPXVQtFvFCN0iMcmIwQghsKzLruQr0VDJx1DBLCpFC0
         5ubwQzXaIgdHcs++XWfbvrw8M4/mNc2pJgQFaZWE+xSU3e8kz9lui7E5X9v22+7A6DgT
         W6Tw==
X-Gm-Message-State: AOAM530AV5PolGQsr0VtDTKaQ+mfOOClVcn0qSfhhDing2DXzTC6kCaq
        grkuDT4w9mzp7JGGnm4NkHlcbGJsvQLlcUDFBKBc6apTQzEGgsbNHSsGrer6EAMNdICx3rXbLVt
        EoXUgi0gizWe0GBkvQEjDfYBoAYeWnpfx+F4wAB8qdkxEnxpaky7xQHbABw==
X-Google-Smtp-Source: ABdhPJymKdUrwiWmf7ytNljGJqbouEkXwGQd6K8m880omQ3rgKM7emZx81FD8naY7xeUkiOEwuXAOnKh0EM=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:faf4:6e40:7b4e:999f])
 (user=pgonda job=sendgmr) by 2002:a65:6919:: with SMTP id s25mr4490335pgq.2.1630606680733;
 Thu, 02 Sep 2021 11:18:00 -0700 (PDT)
Date:   Thu,  2 Sep 2021 11:17:48 -0700
Message-Id: <20210902181751.252227-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 0/2 V7] Add AMD SEV and SEV-ES intra host migration support
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intra host migration provides a low-cost mechanism for userspace VMM
upgrades.  It is an alternative to traditional (i.e., remote) live
migration. Whereas remote migration handles moving a guest to a new host,
intra host migration only handles moving a guest to a new userspace VMM
within a host.  This can be used to update, rollback, change flags of the
VMM, etc. The lower cost compared to live migration comes from the fact
that the guest's memory does not need to be copied between processes. A
handle to the guest memory simply gets passed to the new VMM, this could
be done via /dev/shm with share=on or similar feature.

The guest state can be transferred from an old VMM to a new VMM as follows:
1. Export guest state from KVM to the old user-space VMM via a getter
user-space/kernel API 2. Transfer guest state from old VMM to new VMM via
IPC communication 3. Import guest state into KVM from the new user-space
VMM via a setter user-space/kernel API VMMs by exporting from KVM using
getters, sending that data to the new VMM, then setting it again in KVM.

In the common case for intra host migration, we can rely on the normal
ioctls for passing data from one VMM to the next. SEV, SEV-ES, and other
confidential compute environments make most of this information opaque, and
render KVM ioctls such as "KVM_GET_REGS" irrelevant.  As a result, we need
the ability to pass this opaque metadata from one VMM to the next. The
easiest way to do this is to leave this data in the kernel, and transfer
ownership of the metadata from one KVM VM (or vCPU) to the next. For
example, we need to move the SEV enabled ASID, VMSAs, and GHCB metadata
from one VMM to the next.  In general, we need to be able to hand off any
data that would be unsafe/impossible for the kernel to hand directly to
userspace (and cannot be reproduced using data that can be handed safely to
userspace).

For the intra host operation the SEV required metadata, the source VM FD is
sent to the target VMM. The target VMM calls the new cap ioctl with the
source VM FD, KVM then moves all the SEV state to the target VM from the
source VM.

V7
 * Address selftest feedback.

V6
 * Add selftest.

V5:
 * Fix up locking scheme
 * Address marcorr@ comments.

V4:
 * Move to seanjc@'s suggestion of source VM FD based single ioctl design.

v3:
 * Fix memory leak found by dan.carpenter@

v2:
 * Added marcorr@ reviewed by tag
 * Renamed function introduced in 1/3
 * Edited with seanjc@'s review comments
 ** Cleaned up WARN usage
 ** Userspace makes random token now
 * Edited with brijesh.singh@'s review comments
 ** Checks for different LAUNCH_* states in send function

v1: https://lore.kernel.org/kvm/20210621163118.1040170-1-pgonda@google.com/

base-commit: 680c7e3be6a3

Peter Gonda (3):
  KVM, SEV: Add support for SEV intra host migration
  KVM, SEV: Add support for SEV-ES intra host migration
  selftest: KVM: Add intra host migration tests

 Documentation/virt/kvm/api.rst                |  15 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/svm/sev.c                        | 159 ++++++++++++++++++
 arch/x86/kvm/svm/svm.c                        |   1 +
 arch/x86/kvm/svm/svm.h                        |   2 +
 arch/x86/kvm/x86.c                            |   5 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/sev_vm_tests.c       | 159 ++++++++++++++++++
 9 files changed, 344 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c

-- 
2.33.0.153.gba50c8fa24-goog

