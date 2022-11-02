Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C0E616CFE
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiKBSrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiKBSq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:46:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5FC2CE27
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:46:58 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-37010fefe48so148711967b3.19
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KlOYR8Qeaq/wAWJ2lzry+Znm/MJL+cQ3Uz2M02gh7/0=;
        b=cNl1WsT0PC8mf7yCOxltFM5Da04upOParWzGDQqAN5CssyV44fzMqoGTtt39ZjkOVq
         5U2WL3iGfkkHsT3yCJFLm5oOcbdEQGDq0/bOlq4n7jYj3QXExzVlp9dCJocKWO9DzLjQ
         vA4Ir7IlEoFh/3wR+0tB4zsxydS/pQ6f94ezEsIsVbn+/XPazpS3DZtOLuBMNtudRJTG
         YahTY6u8bftMgfB1H1IUA2WmmjeZZrtKYSbVP52zG5fn19VZNsQDx91PmDGKZiL4BpzA
         qYi4X0W5NFNvSIduFswLyHFbV906OuPJorbHF3MnXtP1XFZulqXpJYPGaCyHRARd1F79
         K9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KlOYR8Qeaq/wAWJ2lzry+Znm/MJL+cQ3Uz2M02gh7/0=;
        b=imStWcqMUqt7p89Qjj0lU5pzSk2x/z4ibFy2FbRc1FgmxtQqcNeo3dohj5FsyxUzMO
         3GtK7cM+us3d9ziPkvZlMbhxOUWgVkE7PCF63PklgdYVH3QpjFpgRXxXioMeoHXpVVV+
         ZJdgJ1F14nrEH1XFeOhfrbzu73u76V/hs5WsQjjCTTAJFg8BKDJMtMDEprkZ2KSa+qhk
         hTWEevgrW4VdkiMhZRNrSwGc92akFzbqh9I24zvGJj2Bs7xTY2UVvAo0VPT0P9/pqZyi
         EIirbBhANrpqB/zDhJ2Jt8bdsUzZPe3869nRSasdGfWF2WmG4VHKCox+RIyOUDY3HV4J
         E6uw==
X-Gm-Message-State: ACrzQf19bRW/UEeB8c5NHWaqNwof8ZCs2xVc0pjD0ebh7j7Pi7Uejokw
        DNrta7JD2ixziqCxGxno4Guzz9szN8CjAg==
X-Google-Smtp-Source: AMsMyM5etykfcW5k30jMkENKo1eiw1lShVx8g9YmBw++NvnwE1Hadmw44LHYGhAEJipO4RIzpj4B6vBrDxYQmA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:5455:0:b0:350:6625:437d with SMTP id
 i82-20020a815455000000b003506625437dmr23598077ywb.326.1667414817531; Wed, 02
 Nov 2022 11:46:57 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:44 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-1-dmatlack@google.com>
Subject: [PATCH v4 00/10] KVM: selftests: Fix and clean up emulator_error_test
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

v4:
 - Collect more R-b tags from Sean.
 - Assert no #PF when TDP is enabled [Sean]
 - Avoid 'we' pronoun in commit message [Sean]
 - Bundle assert+skip in one function [Sean]

v3: https://lore.kernel.org/kvm/20221031180045.3581757-1-dmatlack@google.com/
 - Collect R-b tags from Sean.
 - Drop ModR/M decoding in favor of hard-coded instruction [Sean]
 - Fix gspurious gcc warning about using uninitialized variable [Sean]
 - Drop assert_ucall_done() helper [Sean]
 - Spelling fixes [Sean]
 - Use kvm_asm_safe*() to check #PF(RSVD) instead of an exception
   handler [Sean]

v2: https://lore.kernel.org/kvm/20221018214612.3445074-1-dmatlack@google.com/
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
 .../x86_64/exit_on_emulation_failure_test.c   |  45 ++++
 .../selftests/kvm/x86_64/flds_emulation.h     |  55 +++++
 .../selftests/kvm/x86_64/hyperv_features.c    |   3 +-
 .../smaller_maxphyaddr_emulation_test.c       | 112 ++++++++++
 10 files changed, 280 insertions(+), 221 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/emulator_error_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/flds_emulation.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c


base-commit: d5af637323dd156bad071a3f8fc0d7166cca1276
-- 
2.38.1.273.g43a17bfeac-goog

