Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F9436C9F7
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 19:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbhD0RCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 13:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236627AbhD0RCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 13:02:34 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74C1C061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 10:01:50 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id o7-20020a0cf4c70000b02901a53a28706fso21080905qvm.19
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 10:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Qg5Ee0t3O4ULaTp1MifOKduMGn8W4DB1DYGG/KAxPOA=;
        b=ckeZVXD4I1jR43ADeaLseamGFJ9weSz+agtatcaC7O1Isd0ujDOXxDs5F/2WdvMUmX
         +utQiJVTjVnPiSwVFTI3UY2K7Np2k6sV43Xhj6PpJMNb5LlWhdzHEEhTGZ3VIRCrnHQC
         Ph51S19RxpSWwhu1ZnZJRijMzrsYG49Z7TSz/2d1VDIAwptsJlMn96JBotyfm572vW8m
         DcLnxqITIIxsMWLoV/UrXtw2NhJjgx1r5/ajeN/R5v9WSnfSChqeuHmn1GMp4q//8Pqs
         AWsoAQkD2Rekx8xyKC7sqFIw9n6qFLkImViZQslnIH7qlpa0EFlldznWQbXNv1y/v5V2
         fQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Qg5Ee0t3O4ULaTp1MifOKduMGn8W4DB1DYGG/KAxPOA=;
        b=NAl+aOxT4YUEhxLLCUydUZ3hd/N1Z1DdKrcKQyZx0TmHtx5rllgFaSoSnPM2svPwPF
         BF1uQvrMMMxFyZRbp/WPsF2650KpC4bF3A2L2gveJhJ4RMk+A8xqoeL1BYm7JkngJ7Lf
         24rGllxQultMU4TeZEjKTJ7lLjUQXYMJR2wRLupfjN2bX2+SPT7hWIebUJ2e2fBFkR2D
         T9RRrCf4ZEipcSV5ntgcePu3stSuZDaddOlBws3oZGIIDcdOipZAaGIq27EPXxpzVgrb
         ynF+IIIqhbZfOqaEwyVto15Tqg2cSjXm5IL2pGHtH3HLuXgSBCQsOPB0+hU0fYaAZL0i
         5gcA==
X-Gm-Message-State: AOAM531POGPQyxrByQYYWoFnTE1MQCOB4qkaga51Ip5FbfcdmOL9WwAZ
        Bl/H0caREjdHMwFPPtDPf4TnkoNpBCl/LkuB
X-Google-Smtp-Source: ABdhPJxDJ7pDKR0HPyjDsrGZJmmh/cI4Gs+3jL1WzHZWC/qXT1Cukr3r8HRmiKIfH61Qd6E8qR0JBxbtVIE+udhE
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:de04:ef9c:253d:9ead])
 (user=aaronlewis job=sendgmr) by 2002:ad4:4312:: with SMTP id
 c18mr23824516qvs.44.1619542910062; Tue, 27 Apr 2021 10:01:50 -0700 (PDT)
Date:   Tue, 27 Apr 2021 09:59:57 -0700
Message-Id: <20210427165958.705212-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v4 0/2] kvm: x86: Allow userspace to handle emulation errors
From:   Aaron Lewis <aaronlewis@google.com>
To:     david.edmondson@oracle.com, seanjc@google.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset allows userspace to be a fallback for handling emulation errors.

v1 -> v2:

 - Added additional documentation for KVM_CAP_EXIT_ON_EMULATION_FAILURE.
 - In prepare_emulation_failure_exit():
   - Created a local variable for vcpu->run.
   - Cleared the flags, emulation_failure.flags.
   - Or'd the instruction bytes flag on to emulation_failure.flags.
 - Updated the comment for KVM_INTERNAL_ERROR_EMULATION flags on how they are
   to be used.
 - Updated the comment for struct emulation_failure.

v2 -> v3:

 - Update documentation for KVM_CAP_EXIT_ON_EMULATION_FAILURE.
 - Fix spacing in prepare_emulation_failure_exit().

v3 -> v4:

 - In prepare_emulation_failure_exit():
   - Clear instruction bytes to 0x90.
   - Copy over insn_size bytes rather than sizeof(ctxt->fetch.data).
 - set_page_table_entry() takes a pte rather than mask.
 - In _vm_get_page_table_entry():
   - Removed check for page aligned addresses only.
   - Added canonical check.
   - Added a check to make sure no reserved bits are set along the walk except
     for the final pte (the pte cannot have the reserved bits checked otherwise
     the test would fail).
   - Added check to ensure superpage bits are clear.
 - Added check in test for 'allow_smaller_maxphyaddr' module parameter.
 - If the is_flds() check fails, only look at the first byte.
 - Don't use labels to increment the RIP.  Decode the instruction well enough to
   ensure it is only 2-bytes.

Aaron Lewis (2):
  kvm: x86: Allow userspace to handle emulation errors
  selftests: kvm: Allows userspace to handle emulation errors.

 Documentation/virt/kvm/api.rst                |  18 ++
 arch/x86/include/asm/kvm_host.h               |   6 +
 arch/x86/kvm/x86.c                            |  37 ++-
 include/uapi/linux/kvm.h                      |  23 ++
 tools/include/uapi/linux/kvm.h                |  23 ++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   3 +
 .../selftests/kvm/lib/x86_64/processor.c      |  79 ++++++
 .../kvm/x86_64/emulator_error_test.c          | 224 ++++++++++++++++++
 10 files changed, 411 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/emulator_error_test.c

-- 
2.31.1.498.g6c1eba8ee3d-goog

