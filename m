Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6865B2A6A
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIHXea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiIHXd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:33:59 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828FC10D703
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 16:31:40 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m5-20020a170902f64500b0016d313f3ce7so112139plg.23
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 16:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=JKmSonQmRzAcZ2JyL8gtNHIBqDCeLYTwlzg2gSIdvM0=;
        b=GUJlgXLHsr6D8omv7M3cD1H16BPrGusKkNgNtDezDYjBMZPmiFdjj+ZItVy3yoOCMO
         ajWuHPMCJqfchqiRHIC79a7ISuzd2WF7/9OCDsigF1DV2NiZFDjmbfrexbMOwJ+XqT0r
         J1rMrJZDU/r9fZQ1iICWEaZoP3zrAqfB72v2vMbiA7rPyeVfbrfdnJF+hB58Mf61IXQI
         KF+tLXBaKRtqy2fbeFMcyXL0ai/T8gtPQxxxuv7jYGGaN8uMXlSxGlpBlnqh1QcoQrOa
         IwwOg4eaEYso0GIZSFZz0JKd7frbq0hXwp29EYXByg20nGKKa6He/7u2dZoyMw9G1Ra3
         lr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=JKmSonQmRzAcZ2JyL8gtNHIBqDCeLYTwlzg2gSIdvM0=;
        b=ao1pPl2PezxtO1GK/ueg/xZqkijDzfq8pxi9AF6rS+xdbAtGz0TYnSElHzbklO+NV4
         2LVAwHOfrKWGCzkFwPSRDhReaapIb7R425NKqk9MgdWBrOJezziyv2+v1f9ioUjvaIHO
         ZitZ9xjpziQmQNyxj0Hezl443dSTmVGPBVu04ssW8gBoAKoSTiT3M+mdxdDssReCLqJX
         cAnP202fGV3uTRLbyDedDTEEVVAWzLZ9wuTnn7ERciTGFvYJtX/8H0tGcr3RzKjYajns
         UEazOQyvumjkiqKNLTDJfTFrCssoc/yg/BEtluv3cOsjY7KLCuTuBqBv76j83Bqi8C06
         /hBg==
X-Gm-Message-State: ACgBeo1uekiixfYgLmOJM2x5CBNeHvGN5JRwCWBIDBmAGEJN7pzxh9T3
        Ndw+k9tjSydEJTJknEMnnYi4SlWWaUA=
X-Google-Smtp-Source: AA6agR595BqUn7XSJx8WoBTd5F0VJTT47Upv3fJDl++hnlnXKL88yujnE3ju9NbIO+chawyTNugQJ/vBy1Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:22c7:b0:539:efbb:a9f2 with SMTP id
 f7-20020a056a0022c700b00539efbba9f2mr11388082pfj.54.1662679899238; Thu, 08
 Sep 2022 16:31:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  8 Sep 2022 23:31:29 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908233134.3523339-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: selftests: Fix "fix hypercall test" build errors
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

After a toolchain upgrade (I think), the x86 fix_hypercall_test started
throwing warnings due to -Werror=array-bounds rightly complaining that
the test is generating an out-of-bounds array access.

The "obvious" fix is to replace the memcpy() with a memcmp() and compare
only the exact size of the hypercall instruction.  That worked, until I
fiddled with the code a bit more and suddenly the test started jumping into
the weeds due to gcc generating a call to the external memcmp() through the
PLT, which isn't supported in the selftests.

To fix that mess, which has been a pitfall for quite some time, provide
implementations of memcmp(), memcpy(), and memset() to effectively override
the compiler built-ins.  My thought is to start with the helpers that are
most likely to be used in guest code, and then add more as needed.

Tested on x86 and ARM, compile tested on RISC-V and s390.  Full testing on
RISC-V and s390 would be welcome, the seemingly benign addition of memxxx()
helpers managed to break ARM due to gcc generating an infinite loop for
memset() (see patch 1 for details).

Sean Christopherson (5):
  KVM: selftests: Implement memcmp(), memcpy(), and memset() for guest
    use
  KVM: selftests: Compare insn opcodes directly in fix_hypercall_test
  KVM: selftests: Remove unnecessary register shuffling in
    fix_hypercall_test
  KVM: selftests: Explicitly verify KVM doesn't patch hypercall if
    quirk==off
  KVM: selftests: Dedup subtests of fix_hypercall_test

 tools/testing/selftests/kvm/Makefile          |   8 +-
 .../selftests/kvm/include/kvm_util_base.h     |  10 ++
 tools/testing/selftests/kvm/lib/kvm_string.c  |  33 +++++
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 124 ++++++++----------
 4 files changed, 107 insertions(+), 68 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/kvm_string.c


base-commit: 29250ba51bc1cbe8a87e923f76978b87c3247a8c
-- 
2.37.2.789.g6183377224-goog

