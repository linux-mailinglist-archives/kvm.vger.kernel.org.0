Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487605A4002
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 00:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiH1WZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 18:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiH1WZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 18:25:48 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E80513FB7
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 15:25:47 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id a13-20020a170902eccd00b001730da9d40fso5037596plh.10
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 15:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc;
        bh=OZhf1uLaFuTr7gNYIqPUtAOr7HAQ3vHIoIbMPBfApMc=;
        b=JPuD5nYGhdwKLryC9iwHbJ7Izxhehx2hV8SaHN/50E6ywE9gtWKZnTzIgEqObCx6GE
         lAeGZulG9oRDFPoRDJIUte96qFkl0ihFHbX4b6wZILmK0YXx9eb+ibzJsD5YQCFx5PG1
         Dghur25hLe2I3Nn6GfdCIoJ4YGk3P5wLkwceUF1B6PquiVaxKsmPxIZ9zjsNgvdJhwji
         lXoSQAUlEhWJhCp7GpxfHNou05vfKwDzeOhfAaomByUE+Z70b1XxFN4BMOlv6gWYDHcL
         ST2AphaibY/HsXDK9Z23DixYcIxBL0eiXKjxtENNR3eX36fXBdrFiPJLML8CY9tLE6mv
         fBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=OZhf1uLaFuTr7gNYIqPUtAOr7HAQ3vHIoIbMPBfApMc=;
        b=05fLjwktjRD7+lJbZaCyrYc14s+aJWrUz+xZyIqoX+eUeyg5LNXQpJ/pL4JMjQgC0e
         f8xchtoxA2MU9H2cl+daZ4sLnI23Z23GDUCrAwxL/mcnlADg81/CJknjrUqMMU0Yfahm
         1pK2dW+gfN/7H2gc9z10iTIw1rtBPy7VyYJQDMVqc3fA4KJej9u2u223+Lgmy7Assirs
         5yUcBIl9d6OJvO+kXgRUnfkzfWnaFWZSBFXbiUpTYcR7ZESbDV/ckHWx5x028N7SmMcp
         rxRoql+41Ly2QQ1hQJWCS7OTbWxXbeO4qiOAo6mHaaIUqrdA36h1hU26NAG9Svtgc8S8
         sE8A==
X-Gm-Message-State: ACgBeo3XZdkSNBDd9D8Tll/FfqEQpnf3nFNxYvyyhCRi4bWvMFKWhhFe
        4bifGoruygcswPvLYmFUkBkSqc8cG5AV
X-Google-Smtp-Source: AA6agR7eSg54S0xB6NTMDfsxMenogaDTicI0NMHcR/8VnjedLqa3FE08FM0kXjaail3+A2otm8Q6rsoOX67E
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:26e2:b0:538:23a6:4d62 with SMTP
 id p34-20020a056a0026e200b0053823a64d62mr3811336pfw.26.1661725546957; Sun, 28
 Aug 2022 15:25:46 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 28 Aug 2022 22:25:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220828222544.1964917-1-mizhang@google.com>
Subject: [PATCH v2 0/4] Fix a race between posted interrupt delivery and
 migration in a nested VM
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
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

This patch set aims to fix a race condition between posted interrupt
delivery and migration for a nested VM. In particular, we proves that when
a nested vCPU is halted and just migrated, it will lose a posted
interrupt from another vCPU in the same VM.

Changelog:

v1 -> v2:
 - Replace the original vmcs12 bug fix patch into one that processes nested
   state pages request in a common function [paolo].
 - Update the commit messages [seanjc, oupton].
 - Remove vcpu_run_interruptable(), use __vcpu_run() instead [seanjc].
 - Fix format issue in prepare_posted_intr_desc() [seanjc].
 - Rebase to kvm/queue.

v1 link:
 - https://lore.kernel.org/lkml/20220802230718.1891356-6-mizhang@google.com/t/


Jim Mattson (1):
  KVM: selftests: Test if posted interrupt delivery race with migration

Mingwei Zhang (3):
  KVM: x86: move the event handling of KVM_REQ_GET_VMCS12_PAGES into a
    common function
  KVM: selftests: Save/restore vAPIC state in migration tests
  KVM: selftests: Add support for posted interrupt handling in L2

 arch/x86/kvm/x86.c                            |  29 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |  10 +
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/include/x86_64/vmx.h        |  10 +
 .../selftests/kvm/lib/x86_64/processor.c      |   2 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  14 +
 .../kvm/x86_64/vmx_migrate_pi_pending.c       | 291 ++++++++++++++++++
 9 files changed, 353 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_migrate_pi_pending.c


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.2.672.g94769d06f0-goog

