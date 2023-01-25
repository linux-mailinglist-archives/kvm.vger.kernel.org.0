Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FEA67B936
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 19:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbjAYSXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 13:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbjAYSXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 13:23:15 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1F4CDE9
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 10:23:14 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id e1-20020a17090301c100b001945de452a1so11024802plh.5
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 10:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M87dcnyKpD7G1vtcjsccWcpFLIefiVPTj+pV2nUpSG4=;
        b=cqpU958WIRRZuxW78R8qLwP+/G95uXUi6naqyOp/KrsDH9if60UbRnnpSi2+pR2nev
         UK0+lCkc1WO0Hpsuy/8qer2ScUxTcEJYaFQyGoElV5ud+7U+8NEi1CsKyjupA4DsYSBl
         6wY/eYBQtIazYv+TRXs9mONbINl5SI/X9zN+sFBW0Ti8ti1GUFv5XiCc01KdJCj87hvm
         JmBFFqc7+pgA6JtPXLoO6x6VspQEw4Vmnm3xWOGBgMo/dhvKSXKAgYxaNqAfttmmUFYW
         HHEkGOtucdfiiqpFfBuyUinQzEo9WwVZ1EwCXBJDlKYfyw8XKi1XHIjs2Q1a8qGrRFx/
         txUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M87dcnyKpD7G1vtcjsccWcpFLIefiVPTj+pV2nUpSG4=;
        b=HN/oSODcJmhthf84LwEjiIJHsnSwJDOzsqsaFdM32oDIMVG8vf60+OXTS3ppTQLOIX
         u5Qut+eefJgUDtX0NvSxLCTYf5J3dpVM8OzfRQmyzd2DsvDimI3amr/UaCOI3ue6ElIj
         hXZBow/Lzv3lzy25XLy2Md+Awth6g6PjhiaS6p/9iz3AaqfFOD3s4Ak4uPEtetkktMae
         dTbWvG0i2OBEno4bEmzBcmizyXof1VSYkCWUC+IYnOKzuQh8GXEgTW2wdApZptQmk3Ef
         aPjs/i/c3s0MMPXWf6UfDs3c1u79eAZOSN06HPs9Yn98CHT3nRq0SoGGYsqX+C9lFiYl
         F1GQ==
X-Gm-Message-State: AFqh2kqbuXCbvTz5E0ooxVcmuKsklcwGKN/ygCzOk8gobayZxmO4IkMd
        mAv6NOxY958EisVgEUUIiL+eBjBeXjWO
X-Google-Smtp-Source: AMrXdXtEpWrAsWzep2D2iByFfZUFSPA1b2tP11R7WCW7y9XyIuLS885Q86bi0AFPoSOC3bUhgujVshoODF4I
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:aa4b:b0:194:b3c6:18ee with SMTP id
 c11-20020a170902aa4b00b00194b3c618eemr3153349plr.29.1674670994101; Wed, 25
 Jan 2023 10:23:14 -0800 (PST)
Date:   Wed, 25 Jan 2023 18:23:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230125182311.2022303-1-bgardon@google.com>
Subject: [PATCH v4 0/2] selftests: KVM: Add a test for eager page splitting
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
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

David Matlack recently added a feature known as eager page splitting
to x86 KVM. This feature improves vCPU performance during dirty
logging because the splitting operation is moved out of the page
fault path, avoiding EPT/NPT violations or allowing the vCPU threads
to resolve the violation in the fast path.

While this feature is a great performance improvement, it does not
have adequate testing in KVM selftests. Add a test to provide coverage
of eager page splitting.

Patch 1 is a quick refactor to be able to re-use some code from
dirty_log_perf_test.
Patch 2 adds the actual test.

V1->V2:
	Run test in multiple modes, as suggested by David and Ricardo
	Cleanups from shameful copy-pasta, as suggested by David
V2->V3:
	Removed copyright notice from the top of
	dirty_log_page_splitting.c
	Adopted ASSERT_EQ for test assertions
	Now skipping testing with MANUAL_PROTECT if unsupported
V3->V4:
	Added the copyright notices back. Thanks Vipin for the right
	thing to do there.

Ben Gardon (2):
  selftests: KVM: Move dirty logging functions to memstress.(c|h)
  selftests: KVM: Add dirty logging page splitting test

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/dirty_log_perf_test.c       |  84 +-----
 .../selftests/kvm/include/kvm_util_base.h     |   1 +
 .../testing/selftests/kvm/include/memstress.h |   8 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +
 tools/testing/selftests/kvm/lib/memstress.c   |  72 +++++
 .../x86_64/dirty_log_page_splitting_test.c    | 257 ++++++++++++++++++
 7 files changed, 351 insertions(+), 77 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c

-- 
2.39.1.456.gfc5497dd1b-goog

