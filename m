Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE00379268
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhEJPUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbhEJPSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 11:18:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63C3C061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 07:48:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u7-20020a259b470000b02904dca50820c2so19966404ybo.11
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 07:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Eoa6ihgecNBdFQExHytcx2mx1a+eIjFgjkpb1S01aME=;
        b=SXRFfdTupE+ft3atKQ7rOk+izjlVlxelHEkRgHbANZ2q8q6XU9nwXZZ6NgYEwgmnly
         73W/fN8nSNTbL3oxe/BlDmkDFMwy2vsfqX0+N2XwnSPT8LlDuxkGEu9GCb+wBH2fNH59
         WRIRz4cAaizuXe+BUMtfpv8ZjE848jz3vUQkuEZtS6Ni0HwQ5J98pYQcMCCW76eiWtN+
         Xk+HNnqqHZGk3XELA4bFUOev57e2IQ1SZ7/iP/eKVOVUC/h+1sKLbck7HOi7nVx4qoY7
         mMWr16bSRSmxSPyD1KjXA+CSikaHr16oaq+o+/AgpHcB4Dv9raCxIq41DFd5VFrsc731
         PkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Eoa6ihgecNBdFQExHytcx2mx1a+eIjFgjkpb1S01aME=;
        b=NRQbCSz1E89uFirIXWTQWP6x/akzcS2Lqx2q70vMjrbC47yKw4wpguWUd1/y/LWhfQ
         kq436WzPvsRng37sOX9MPBHvr6gJIRKfMiSuz17nb26zoHjtwxs+juGUjFtbpK0FJo5k
         i6lCei04Kd+8iF3IREulGffhfwpfjQczkKTfFHx7zu1nl6L12d17dRV2ISUl/HQEYAdw
         0Qk6ANOYs+3xZCfejlg1FBZOFKeQb/IzZtoQYSligl8d4fShHWPwJzeqNGEI197Yr6IZ
         j0z0R2ftahqBUAJblYUJ8rtxj2R0rTFGnO8akDdk3GdK84JSjAbswuFIA3/ZN2xkiuDn
         AtEA==
X-Gm-Message-State: AOAM533JNfkCHxbvti/Z/+7QA1628tF7jiGn0JrOhCgKopMFPVvuzmHW
        ePx65hJ/l2yCKwKCHwEv2Eu3hSGKD3mVXvJX
X-Google-Smtp-Source: ABdhPJzvAS2X3pPt3UXGTnxNFMFyZSRhqMZ+qdIpkAXN5cZCT3vYvPEgKkiBoH+UPTMWHci5USPdHfioo8bChEtI
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:3396:9513:fac0:8ec7])
 (user=aaronlewis job=sendgmr) by 2002:a25:4ac4:: with SMTP id
 x187mr29286178yba.478.1620658117824; Mon, 10 May 2021 07:48:37 -0700 (PDT)
Date:   Mon, 10 May 2021 07:48:32 -0700
Message-Id: <20210510144834.658457-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v6 0/2] fallback for emulation errors
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

v4 -> v5:

 - Switch 'insn_size' to u32.
 - Add documentation for how the flags are used.
 - Remove 'max_insn_size' and use 'sizeof(run->emulation_failure.insn_bytes)' instead.
 - Fix typos.
 - Fix canonical check.
 - Add reserved check for bit-7 of PML4E.
 - Add reserved check for bit-63 of all page table levels if EFER.NXE = 0.
 - Remove opcode check (it might be a prefix).
 - Remove labels.
 - Remove detritus (rogue cpuid entry in the test).

v5 -> v6

 - Fix documentation.

Aaron Lewis (2):
  kvm: x86: Allow userspace to handle emulation errors
  selftests: kvm: Allows userspace to handle emulation errors.

 Documentation/virt/kvm/api.rst                |  19 ++
 arch/x86/include/asm/kvm_host.h               |   6 +
 arch/x86/kvm/x86.c                            |  37 ++-
 include/uapi/linux/kvm.h                      |  23 ++
 tools/include/uapi/linux/kvm.h                |  23 ++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   4 +
 .../selftests/kvm/lib/x86_64/processor.c      |  94 ++++++++
 .../kvm/x86_64/emulator_error_test.c          | 219 ++++++++++++++++++
 10 files changed, 423 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/emulator_error_test.c

-- 
2.31.1.607.g51e8a6a459-goog

