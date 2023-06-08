Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A777275A8
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 05:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjFHDYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 23:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjFHDYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 23:24:43 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B7F270A
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 20:24:36 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6b28fc7a6dcso79302a34.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 20:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686194676; x=1688786676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p5/+1fA9UdZZNdwm0m4IZsRyaLZTXCA/ALBNzcoctxQ=;
        b=r72vBD0V9bJw0TEBoWHcQsXoI2/S17ZQ+6d18DHgGj2FZJZ7ySvdeAOC7LGAdfrlp8
         xDBOGBN0FRgV4q008qbnWTt2usLpE2uFSlB3Uu/TtPAuAcxkk/2kYpscNeLaXqyDljRk
         55Z+kE9OL2wZu3YITn7AAl5txn6CdKOu7LjmEFf2sGZveqdIClf6ZRWfc5WT4CAnoe0n
         f2UCmZ/yaBs1s7yY2SKJc6O0kbg+bKHu7YacYwa+k09LysMJkS0YmJvbuAWeuXnSXA3j
         u9vXIxcZ4a1imO8k7Bas76cNuCdaot1uW2mqBJEN92a+/EKcW/4naoPy0yxZAthukFUC
         NCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686194676; x=1688786676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p5/+1fA9UdZZNdwm0m4IZsRyaLZTXCA/ALBNzcoctxQ=;
        b=GAbxx2ddBm9zyW+2SXr+J+Wf2hEdFQXp33PTTAKftGtah7FXr9F8Bb6E8Mt+itwcru
         gKtBEasN64QfPoQ3vPTebOPveitMV0DHd+Gkc2u8jMVKHTf+xMgTO+bXZE6I+DdDKQaQ
         SJ2pC6B+EEvOqxeo0XdN9pPg6ck0TXooIc8tFq23idHhL4Eh8KfWjX5t/4yPJMnzWzO8
         oSpi0oQsInmuEtwyndBhMK+4om5FaJ0qPtar66s0R4N+bnGzLKaft84DFQQ5ooFBXgHN
         UOH00Ubrw2GsXPzhcgHWHp+xyLRcWOlH1powY0ifoJkYRbbBFQGRyMysfo4k6Pj9FZO0
         GZRQ==
X-Gm-Message-State: AC+VfDz5HClufT4bTbc/xe8dHDfmkvKWVSjkXPxeWaDN3JtaSr66TELL
        MxTNoZcz+3jEKlnVuufyaGn+GKcPVss=
X-Google-Smtp-Source: ACHHUZ7SSMbx5SlpVrW00IgxXImnEczLcGdqRZGJzWtx+RigbzuqXWtGqLLbKluldGPnlDoLooa+1A==
X-Received: by 2002:a05:6871:503:b0:187:e05e:a4f0 with SMTP id s3-20020a056871050300b00187e05ea4f0mr6654834oal.26.1686194675743;
        Wed, 07 Jun 2023 20:24:35 -0700 (PDT)
Received: from wheely.local0.net (58-6-224-112.tpgi.com.au. [58.6.224.112])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090a5d0c00b0025930e50e28sm2015629pji.41.2023.06.07.20.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 20:24:34 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 0/6] KVM: selftests: add powerpc support
Date:   Thu,  8 Jun 2023 13:24:19 +1000
Message-Id: <20230608032425.59796-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds initial KVM selftests support for powerpc
(64-bit, BookS, radix MMU).

Since v2:
- Added a couple of new tests (patch 5,6)
- Make default page size match host page size.
- Check for radix MMU capability.
- Build a few more of the generic tests.

Since v1:
- Update MAINTAINERS KVM PPC entry to include kvm selftests.
- Fixes and cleanups from Sean's review including new patch 1.
- Add 4K guest page support requiring new patch 2.

Thanks,
Nick

Nicholas Piggin (6):
  KVM: selftests: Move pgd_created check into virt_pgd_alloc
  KVM: selftests: Add aligned guest physical page allocator
  KVM: PPC: selftests: add support for powerpc
  KVM: PPC: selftests: add selftests sanity tests
  KVM: PPC: selftests: Add a TLBIEL virtualisation tester
  KVM: PPC: selftests: Add interrupt performance tester

 MAINTAINERS                                   |   2 +
 tools/testing/selftests/kvm/Makefile          |  23 +
 .../selftests/kvm/include/kvm_util_base.h     |  29 +
 .../selftests/kvm/include/powerpc/hcall.h     |  21 +
 .../selftests/kvm/include/powerpc/ppc_asm.h   |  32 ++
 .../selftests/kvm/include/powerpc/processor.h |  46 ++
 .../selftests/kvm/lib/aarch64/processor.c     |   4 -
 tools/testing/selftests/kvm/lib/guest_modes.c |  27 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  56 +-
 .../selftests/kvm/lib/powerpc/handlers.S      |  93 +++
 .../testing/selftests/kvm/lib/powerpc/hcall.c |  45 ++
 .../selftests/kvm/lib/powerpc/processor.c     | 541 ++++++++++++++++++
 .../testing/selftests/kvm/lib/powerpc/ucall.c |  30 +
 .../selftests/kvm/lib/riscv/processor.c       |   4 -
 .../selftests/kvm/lib/s390x/processor.c       |   4 -
 .../selftests/kvm/lib/x86_64/processor.c      |   7 +-
 tools/testing/selftests/kvm/powerpc/helpers.h |  46 ++
 .../selftests/kvm/powerpc/interrupt_perf.c    | 199 +++++++
 .../testing/selftests/kvm/powerpc/null_test.c | 166 ++++++
 .../selftests/kvm/powerpc/rtas_hcall.c        | 136 +++++
 .../selftests/kvm/powerpc/tlbiel_test.c       | 508 ++++++++++++++++
 21 files changed, 1981 insertions(+), 38 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/hcall.h
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/ppc_asm.h
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/processor.h
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/handlers.S
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/hcall.c
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/processor.c
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/ucall.c
 create mode 100644 tools/testing/selftests/kvm/powerpc/helpers.h
 create mode 100644 tools/testing/selftests/kvm/powerpc/interrupt_perf.c
 create mode 100644 tools/testing/selftests/kvm/powerpc/null_test.c
 create mode 100644 tools/testing/selftests/kvm/powerpc/rtas_hcall.c
 create mode 100644 tools/testing/selftests/kvm/powerpc/tlbiel_test.c

-- 
2.40.1

