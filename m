Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2FE6E145A
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjDMSnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjDMSm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:42:59 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CF07EC5
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:36 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso4194538wmo.0
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411355; x=1684003355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9ouIXXzXkR9iKq5GS3MVc2uoUw4kzcTau4LjDKoSPTA=;
        b=XQk6FDaXTuaLwl7BoDKn4nRtUXfgflZSFgiR/MifCxnNQOvl/c7C4099BTaLwyjCiC
         B+wEa50+0tm5Kttz2PXQunB/rOelf41lnELASyVmNZn8AUqBG8ZJSSDijxRk/wJQ+Y+j
         1ZuBbObbAtT06g0Pbqon3eIVpTujin/WUAEGcnUMjj5BMb64Rx5XTcng0Rwf5KODReYZ
         R+aWkYUe7QfCpzLSEfjXzY7ska8w4XtoEjyoXXVDO+Lhq1vhNwOSgM1s+POavwwAu2Sy
         2XiB2K0OcS1fS9z6ivsBB5jogL658HRbK2n8btlGk7HSNxB9hYlYjcMqQHaw00K3BK8Z
         KGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411355; x=1684003355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ouIXXzXkR9iKq5GS3MVc2uoUw4kzcTau4LjDKoSPTA=;
        b=bgQOTMOlc2wrfiTVFV+WSKrK4mCwYqEvcNuUNCo4rZ5qmdG/IosMAyg6K0W70aIbPy
         H1XclhwwuyOXhPH/wxlrQremzoW4fbufNYAOrJpI/AAQ+frkcnmbdWq9QSPAM5+XSu8j
         iJNYdj6ySFcOud8V4Np36H1+6FhSAnbkD1cdne1Uz2pL5Qbv2rrAqDe/6mg7D1SGiokQ
         C5fVVmACUaWH+EcTKq8/1FYHc+cvqVKNJfAjPAwYuZXFYYOeGb/9GTlZwmeD3WLyaiTW
         mTGGRrI/AQ5jSeKjVeiykVI204vXZNZDrmGGbx60+4fndqJ2v9JZR893C2BVfu/n6WnA
         T2YQ==
X-Gm-Message-State: AAQBX9ftjJftmP6UlQtF/YVUVKP7+BojqSUuwwed67VgfRR4DDXxnxlv
        hva/N7jFtYdpS1y0XcYkKUo/igtwsmOPWjArp+c=
X-Google-Smtp-Source: AKy350aY9kL8Qv/RvZ1+Aiot5F9lPtXL8vnYez7JnIVKMUF3HUHKWI5+zL31bERLPe6gcpL0pGGWvA==
X-Received: by 2002:a05:600c:2289:b0:3ee:6161:7d98 with SMTP id 9-20020a05600c228900b003ee61617d98mr2271965wmf.16.1681411355493;
        Thu, 13 Apr 2023 11:42:35 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:35 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 00/16] x86: cleanups, fixes and new tests
Date:   Thu, 13 Apr 2023 20:42:03 +0200
Message-Id: <20230413184219.36404-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1: https://lore.kernel.org/kvm/b6322bd0-3639-fb2a-7211-974386865bac@grsecurity.net/

This is v2 of the "non-canonical memory access" test. It evolved into a
small series, bringing cleanups and fixes along the way.

I integrated Sean's feedback and changed the test to make use of
ASM_TRY() instead of using the hand-rolled exception handler. I also
switched all other users in emulator64.c to ASM_TRY() and was able to
drop the one-off exception handler all together.

Sean, this should be a solid ground to refine it further when [1] lands?

[1] https://lkml.kernel.org/r/20230406025117.738014-1-seanjc@google.com

As for the fixes, run_in_user() didn't restore the exception handler it
overwrites, which leads to interesting bugs when the handler fires again
for an unrelated exception -- that longjmp() won't do the right thing in
this case ;)

I fixed fault_test() as well, as it has the same behaviour.

For new tests, I added the non-canonical memory access exception test of
v1 and added another SS segment register load test to check non-NULL
selectors as well, as I stumbled over the bugs in run_in_user() while
switching test_sreg() over to TRY_ASM().

Be aware that the types.h removal (first patch) has an unfortunate side
effect. It breaks compilation in already build trees, as the dependency
files (.*.d) don't get regenerated / cleaned if a source file changes.
This leads to stale references to types.h which can only be solved by a
'make clean'. :(

We really should change the dependency file generation to avoid that
problem, as the current state is kinda awkward. Tho, I didn't had the
time to look into it further myself.

Please apply!

Thanks,
Mathias

PS: I'm on holidays for three weeks from Saturday on, so won't respond
to feedback any time soon.

Mathias Krause (16):
  x86: Drop types.h
  x86: Use symbolic names in exception_mnemonic()
  x86: Add vendor specific exception vectors
  x86/cet: Use symbolic name for #CP
  x86/access: Use 'bool' type as defined via libcflat.h
  x86/run_in_user: Change type of code label
  x86/run_in_user: Preserve exception handler
  x86/run_in_user: Relax register constraints of inline asm
  x86/run_in_user: Reload SS after successful return
  x86/fault_test: Preserve exception handler
  x86/emulator64: Relax register constraints for usr_gs_mov()
  x86/emulator64: Switch test_sreg() to ASM_TRY()
  x86/emulator64: Add non-null selector test
  x86/emulator64: Switch test_jmp_noncanonical() to ASM_TRY()
  x86/emulator64: Switch test_mmx_movq_mf() to ASM_TRY()
  x86/emulator64: Test non-canonical memory access exceptions

 lib/x86/processor.h  |  13 ++++++
 lib/x86/desc.c       |  43 ++++++++++--------
 lib/x86/fault_test.c |   4 +-
 lib/x86/usermode.c   |  42 ++++++++++-------
 x86/types.h          |  21 ---------
 x86/access.c         |  11 ++---
 x86/cet.c            |   2 +-
 x86/cmpxchg8b.c      |   1 -
 x86/emulator.c       |   1 -
 x86/emulator64.c     | 105 ++++++++++++++++++++++++-------------------
 x86/pmu_pebs.c       |   1 -
 x86/svm.c            |   1 -
 x86/svm_tests.c      |   1 -
 x86/vmx_tests.c      |   1 -
 14 files changed, 129 insertions(+), 118 deletions(-)
 delete mode 100644 x86/types.h

-- 
2.39.2

