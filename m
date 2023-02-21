Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EED69E4BD
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 17:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbjBUQhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 11:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbjBUQhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 11:37:18 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE27279AA
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 08:37:17 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id la3-20020a170902fa0300b0019ca5ddecedso65934plb.1
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 08:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r9GngjfEiO2YdAiq4afzZtr0guJMgojljVZUby60vN8=;
        b=mAn0vFk+ChTStIeaeuUZlb6J63gdV5C2oabXyKkoizXVxjcJvry0jEzZjeab3B0reB
         rW1OyjgkgRMEodBTmTl732oY1idaSQYNoLoVzQQYe6gcq70V8wBgWRyji6Sd5miDXnk5
         En3GD/SM7Xjx3FIFrJhfqNqbfE08LqNJMsPbMroF5pQjsicLJ6faGW9cKZGnirEyDpxk
         wxj/DLJbeuvdIuELOOzZn0dBx+2c/hyPjWHBEhGu2UYVWf9AhcU8waBl7NqyI6+rEu+4
         AtmXPiN7wX+zF16ZMyP224jrc6LEyWegXd4Z5DBIPfoNQKuUceTZNAfdmMhZc3pKPY4D
         rWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r9GngjfEiO2YdAiq4afzZtr0guJMgojljVZUby60vN8=;
        b=LB/YI4z9y/5Ztjw5LWa2Ic6GUMi80hHgojJhKXrUfW/4EYSSt5jskwPVC7norQ9/oP
         eW4zIQqEj07erD06EiyCZ7mtrWKbV+jLQ6A43/jc3JLUd7u5h7jotvusl5SDHjGgkJqy
         6NoGT++XttMhTB6W5QdqdRHbntL6cryWpkytIcGq8k+qf3eC77yyUMwJmvqnRgRIdGvV
         2idEMAe/vKMVZHSDW2pji+9rWdLBwjSzUEVwcIReIzoerE/ELDuRpgQTTWUu09f/P+td
         +sqpfahWmTs5dVQv2RjoR88472kXnf7n6Z5wuwQU+RzDljoM7Y/4ZLlIoS5g6aTMf3Nn
         y5Qw==
X-Gm-Message-State: AO0yUKVtKyQ7kswlJ7rR2+I+CmHpwDWZ3432iC0YUuN+JWt6IjchjYoR
        BT6ak/90LGpJr+HeOks8qD9Lvy3DUBMx
X-Google-Smtp-Source: AK7set/hGerFqBnOr69r9p+6s6eCl18x7fitzOEmn/UB+O2DhpTWhstOcDjrXbZVn2yXX5JhsI/CY8KvvM47
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:903:551:b0:19a:81a0:4f7 with SMTP id
 jo17-20020a170903055100b0019a81a004f7mr742552plb.35.1676997436891; Tue, 21
 Feb 2023 08:37:16 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 21 Feb 2023 16:36:42 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230221163655.920289-1-mizhang@google.com>
Subject: [PATCH v3 00/13]  Overhauling amx_test
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In this version, I have integrated Aaron's changes to the amx_test. In
addition, we also integrated one fix patch for a kernel warning due to
xsave address issue.

Patch 1:
Fix a host FPU kernel warning due to missing XTILEDATA in xinit.

Patch 2-8:
Overhaul amx_test. These patches were basically from v2.

Patch 9-13:
Overhaul amx_test from Aaron. I modified the changelog a little bit.


v2 -> v3:
 - integrate Aaron's 5 commits with minor changes on commit message.
 - Add one fix patch for a kernel warning.

v2:
https://lore.kernel.org/all/20230214184606.510551-1-mizhang@google.com/


Aaron Lewis (5):
  KVM: selftests: x86: Assert that XTILE is XSAVE-enabled
  KVM: selftests: x86: Assert that both XTILE{CFG,DATA} are
    XSAVE-enabled
  KVM: selftests: x86: Remove redundant check that XSAVE is supported
  KVM: selftests: x86: Check that the palette table exists before using
    it
  KVM: selftests: x86: Check that XTILEDATA supports XFD

Mingwei Zhang (8):
  x86/fpu/xstate: Avoid getting xstate address of init_fpstate if
    fpstate contains the component
  KVM: selftests: x86: Add a working xstate data structure
  KVM: selftests: x86: Fix an error in comment of amx_test
  KVM: selftests: x86: Add check of CR0.TS in the #NM handler in
    amx_test
  KVM: selftests: x86: Add the XFD check to IA32_XFD in #NM handler
  KVM: selftests: x86: Fix the checks to XFD_ERR using and operation
  KVM: selftests: x86: Enable checking on xcomp_bv in amx_test
  KVM: selftests: x86: Repeat the checking of xheader when
    IA32_XFD[XTILEDATA] is set in amx_test

 arch/x86/kernel/fpu/xstate.c                  | 10 ++-
 .../selftests/kvm/include/x86_64/processor.h  | 14 ++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 80 +++++++++----------
 3 files changed, 59 insertions(+), 45 deletions(-)

-- 
2.39.2.637.g21b0678d19-goog

