Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2FD603525
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiJRVqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiJRVqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:46:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB180BBE2A
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:15 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-356a9048111so150618827b3.6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bnjKRO1Jjs2jHP6DoGJsiluSLKIdkDLSSjeGZPUpjjA=;
        b=Da0pPy4X3ZVFaEuMNV6dm/Y5modIMGa/eD2ANcXTlnok0eWAqQ+Filcde9fkXKVmwA
         GZ9R5Jbb4zjPyBNOpwGcbLikhUl2skOWZKneCjSV/vNx3xO7b4HDrA7TwxaDqczsbtSI
         DPS3JSXISkeMQ24TvcMCFOrvEPAJKHNLV+xw7mL3qFJ296Qmiz0gYrCc7ZJlE33ZkXyq
         jid8saX0B6iJpstshD5u5B4SAW5P+nZfDxCB/epWdOlydkP+LwR7ORr+lKhrrlY3Xm3j
         6uYyrygfwhIJyVfW2SLTRSl2/x3IU3HOm8wyb3kEEQwD3ZvKAmc6TFXrQIMOdTP5X+pm
         FugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bnjKRO1Jjs2jHP6DoGJsiluSLKIdkDLSSjeGZPUpjjA=;
        b=DoG3sBvfiT7hwtMqjtqCrJSsx42IxGGtZMMFwheJJa8A3reJ5Vi5wlLLNZgqToKCEH
         rQGtEp9L8dMmCVEEfu+bxgD6IoIcg0O3aP5sWLra64g44UPbvrFMAqFEXDKPGhClHEr7
         22M4sScV3UFUXgzchyxYsyOs0NnEb+0AJYB5gVsGE2NKsSYlRlwV3KbsQWlSrXkeCcgy
         iWr6replzoXzHSR89Zq0tyzzV5l9VKiHMp9KSuWuyosoYpjT52665WY2yXae5zyDz3oR
         P0mfO5VKotsM5pOZKR4LienaM7UMcnrvzDAbIsVCtoOprh+dN22RNZrWw9NbCdf7PNGZ
         yzvg==
X-Gm-Message-State: ACrzQf3t91G/oUZwF83lAgKnmnlQiNj/gu2QbReOgz/FwPii2tpsl3q0
        zp4lHR3OMbAchLG7K4diNgk9Kspn/npZ6A==
X-Google-Smtp-Source: AMsMyM6kOM1/KDXTnhAIrM+3akQ/2wmWhzbI2obNuuVIFXvEOJJ4px9Rer6g5gqO5ruTGcJQZ28bXOusRpPFQw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:6304:0:b0:358:7d68:b6d with SMTP id
 x4-20020a816304000000b003587d680b6dmr4182378ywb.268.1666129575264; Tue, 18
 Oct 2022 14:46:15 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:46:04 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018214612.3445074-1-dmatlack@google.com>
Subject: [PATCH v2 0/8] KVM: selftests: Fix and clean up emulator_error_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
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
  KVM: selftest: Add a test for KVM_CAP_EXIT_ON_EMULATION_FAILURE

 arch/x86/include/asm/kvm_host.h               |  20 +-
 tools/testing/selftests/kvm/.gitignore        |   3 +-
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/include/x86_64/processor.h  |  31 +++
 .../kvm/x86_64/emulator_error_test.c          | 193 ------------------
 .../x86_64/exit_on_emulation_failure_test.c   |  42 ++++
 .../selftests/kvm/x86_64/flds_emulation.h     |  67 ++++++
 .../smaller_maxphyaddr_emulation_test.c       | 118 +++++++++++
 8 files changed, 272 insertions(+), 205 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/emulator_error_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/flds_emulation.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c


base-commit: 458e98746fa852d744d34b5a8d0b1673959efc2f
-- 
2.38.0.413.g74048e4d9e-goog

