Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6056058F203
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiHJR7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiHJR7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:59:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F18642C5
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:59:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r4-20020a259a44000000b006775138624fso12728276ybo.23
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=one5M1qF/+BjMIoNR0THsqDyLeUvvatqIwLpqvUgnMw=;
        b=NuBM6cC6NIWl28rtbuCMsGxi0wPnk9xc422jR/bJh3bqaYlBF6JJjsL0LU32g4che9
         kjER2q5tsm4yj8cXoYuEYuadKW9gcQrXC8O+uOdeF4EKXHX6aKXOA9aoTMJBFc6uR8gX
         WH1CSi1JXMYtEeANdtkNHiZUqgptkqyU6mlOrlf+zCNfIxAtly2ebMGXolnZ8zWgD0/R
         hadRKLHXR4pfVO5JzN4VM2nOSUsrUf63FVzUm7Y1WL70p/nruuxcqRhhkbmJodvOWI8x
         +pNjpMKf7jmpW96j/JLchjcoFrjAZGvq+/JVylBHFmqSc0fWejG2JAWxHX/IYNn0WmC5
         JNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=one5M1qF/+BjMIoNR0THsqDyLeUvvatqIwLpqvUgnMw=;
        b=e8ZKkTP92ubCaZVghkSwD2t7CIDcvbq4dMYAZJwH8HLq9MDbkP9CzkpVqkbJdPCCZt
         BW50KpghYnEnGpP/Q2fzFxc078dqHHBKfxDQnbS3hBnkZt0xO1LGtiHndodQvTPWrt6F
         2IgZJnRVd7JSLYj0dghCwkf9R5Ce9rAygCGL5I8WOsOvA6romM8/FmpGTm4YsDPr4fgI
         SrXfown99gVvxTSMOpTqn2AHoleiyuD/3vr1dIZgAckE+gkGsdBtKRBY3PC+hLVFdi/U
         w+HgfNAeTWthTmZcmJl9Fsrb3WMAohE0B4//clWR0Wt4JRkZOT1WE/08+u+lExEiRUvB
         qrig==
X-Gm-Message-State: ACgBeo0vvX5EgvXZYp8lUGdMUoVL5ryQJu9RZs35IA2NpfSQImQpw8xm
        9jFnqtDpNbFAyUeAyvCElc8flmCzigu1sx9G2kPg9jnggImwY1eJpwt9OOE9Y6EPBrvcp/I6Za/
        dmnDdsPLdxdXmBL/0V/JaVPMz0GV0xPUCzmG51X7bCgo3zXsRPZlv6PA2fpSWiSHvwa/4UdM=
X-Google-Smtp-Source: AA6agR4AFbPxYeGcwuqKEyHM6RgQFTZV8Q1u7bB0cPeLxTXNzCX/0MmkfzK6EXuY2C9TS5n6dkMOrnp+PxGFWumoVg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:c406:0:b0:670:903b:941a with SMTP
 id u6-20020a25c406000000b00670903b941amr25704954ybf.327.1660154342126; Wed,
 10 Aug 2022 10:59:02 -0700 (PDT)
Date:   Wed, 10 Aug 2022 17:58:27 +0000
Message-Id: <20220810175830.2175089-1-coltonlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH 0/3] KVM: selftests: Randomize memory access of dirty_log_perf_test
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
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

This patch adds the ability to randomize parts of dirty_log_perf_test,
specifically the order pages are accessed and whether pages are read
or written. This is implemented through a table of random numbers
stored in VM memory and refreshed between test iterations.

Patch series based on kvm/queue

Colton Lewis (3):
  KVM: selftests: Add random table to randomize memory access
  KVM: selftests: Randomize which pages are written vs read
  KVM: selftests: Randomize page access order

 .../selftests/kvm/dirty_log_perf_test.c       | 34 ++++++++--
 .../selftests/kvm/include/perf_test_util.h    |  6 ++
 .../selftests/kvm/lib/perf_test_util.c        | 68 ++++++++++++++++++-
 3 files changed, 98 insertions(+), 10 deletions(-)

-- 
2.37.1.559.g78731f0fdb-goog

