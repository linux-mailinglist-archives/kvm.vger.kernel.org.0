Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E779613CC2
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiJaSAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiJaSAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:00:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4302B13D0E
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 129-20020a250087000000b006ca5c621bacso10951782yba.3
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OXd4LdxPnZnn3ysYo6x5dwfLb893wsK20EHOWX/QI3Q=;
        b=JPiMydq5MrQK3isg7jW4TfaWldHsofJRGyjhni4ekzaMHdozxteA2nO/wdolMaHUiC
         kBlT3gvGBafcthuuD/H2LRWVFJqh1nDmRpIrhe4aDze3T6Ebwx7lypbgNWz9CMA9h5kV
         svvgTTN0Xu9Jpqd/AHUULwkTfXmzhCZ32ZfXOPGTcPJTL7FG1D2emy+yM2Z7sRkW1/Ps
         m5ZaRr/rDNNO9AQw1wIcmE6bcH3DLO9fNElCGYp5fKn+unXHmlGCcu3NaUW/rOJGGZh/
         g1WcgM+W/3QQ1INDkv2zMOpoxuXNWUAPzoh2S2WFIrioodfe+F2gFVyDKd+g4IqxIFbu
         vo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OXd4LdxPnZnn3ysYo6x5dwfLb893wsK20EHOWX/QI3Q=;
        b=Rq46OnsIl9BhiIvSA4Kjg+0bl4vzF+T+Pwwy0QFA+XpXttnAARVuKksBrGOahdMaSd
         GJhB3TOh9H+0NqAy4IHop+TD4L/N4umDMgpqbTMhXfoXA24jlEzygtlltxx9LP7qmCdf
         i8FHiz7+rq+5yPV9yWuMcOcgH4rHEALDwWNxIyUj/YH1YKfopepcGT4Yn+XZoseNN0kn
         Z2vaFqGySZWkyAJsFi3zaNRBD0q/6XVbFaU0HqdvJcQLFjtMRrgYSJc2iOibgcAfaGlG
         451vVLfWqnpPyG/gtXxVEB7x9WAhJnmY2tMDE/sKWxX1/M9AUAJRZKyrafHf8t8wUZxI
         jVrA==
X-Gm-Message-State: ACrzQf3ixcxwHke+twLT0BfSH2dM38jniDNoCHdWcmBUeST4mHRJn3BH
        +4wtAQKgNH9DmwD6L7ZDIL3lKk0Hrk1Mlg==
X-Google-Smtp-Source: AMsMyM4uFRcUHKuaPa9cJ+1XPvzNt3A23MPmyKNMHXXboLmsGfN7smVPBhY/r+NS17oFdF5JDm21L2eqRPJF1g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:d5d2:0:b0:36a:1c12:b60f with SMTP id
 x201-20020a0dd5d2000000b0036a1c12b60fmr0ywd.45.1667239249883; Mon, 31 Oct
 2022 11:00:49 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-1-dmatlack@google.com>
Subject: [PATCH v3 00/10] KVM: selftests: Fix and clean up emulator_error_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

Miscellaneous fixes and cleanups to emulator_error_test. The reason I
started looking at this test is because it fails when TDP is disabled,
which pollutes my test results wheneveer I am testing a new series for
upstream.

v3:
 - Collect R-b tags from Sean.
 - Drop ModR/M decoding in favor of hard-coded instruction [Sean]
 - Fix gspurious gcc warning about using uninitialized variable [Sean]
 - Drop assert_ucall_done() helper [Sean]
 - Spelling fixes [Sean]
 - Use kvm_asm_safe*() to check #PF(RSVD) instead of an exception
   handler [Sean]

v2:
 - Split emulator_error_test into 2 separate tests to ensure continued
   test coverage of KVM emulation in response to EPT violations when
   "allow_smaller_maxphyaddr && guest.MAXPHYADDR < host.MAXPHADDR".  [Sean]
 - Test that flds generates #PF(RSVD) when TDP is disabled [Sean]

v1: https://lore.kernel.org/kvm/20220929204708.2548375-1-dmatlack@google.com/

David Matlack (8):
  KVM: selftests: Rename emulator_error_test to
    smaller_maxphyaddr_emulation_test
  KVM: selftests: Explicitly require instructions bytes
  KVM: selftests: Delete dead ucall code
  KVM: selftests: Move flds instruction emulation failure handling to
    header
  KVM: x86/mmu: Use BIT{,_ULL}() for PFERR masks
  KVM: selftests: Copy KVM PFERR masks into selftests
  KVM: selftests: Expect #PF(RSVD) when TDP is disabled
  KVM: selftests: Add a test for KVM_CAP_EXIT_ON_EMULATION_FAILURE

Sean Christopherson (2):
  KVM: selftests: Avoid JMP in non-faulting path of KVM_ASM_SAFE()
  KVM: selftests: Provide error code as a KVM_ASM_SAFE() output

 arch/x86/include/asm/kvm_host.h               |  20 +-
 tools/testing/selftests/kvm/.gitignore        |   3 +-
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/include/x86_64/processor.h  |  66 ++++--
 .../selftests/kvm/lib/x86_64/processor.c      |   1 +
 .../kvm/x86_64/emulator_error_test.c          | 193 ------------------
 .../x86_64/exit_on_emulation_failure_test.c   |  42 ++++
 .../selftests/kvm/x86_64/flds_emulation.h     |  59 ++++++
 .../selftests/kvm/x86_64/hyperv_features.c    |   3 +-
 .../smaller_maxphyaddr_emulation_test.c       | 107 ++++++++++
 10 files changed, 276 insertions(+), 221 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/emulator_error_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/flds_emulation.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c


base-commit: d5af637323dd156bad071a3f8fc0d7166cca1276
-- 
2.38.1.273.g43a17bfeac-goog

