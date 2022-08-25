Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A295A19E5
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 21:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242802AbiHYT7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242713AbiHYT7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:59:44 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD99ACA23
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m22-20020a6562d6000000b0042a7471b984so6802245pgv.4
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc;
        bh=/e2769OlgcqufYB4U1Tps3XCuK9GZYp9arseKJu1pCA=;
        b=H6lu5EKRmxbhsiWy44fPio6pjLlUrH1cqROcGb0+YFF9aIFLI6KlRwujHukkHrtrSR
         foSs+9uo6MMxKbAweeW6DGPDPwpJ7DC9JwpQzOxoTQQ67HhSQd/37HOW40+zntahEsY4
         YOSrvmyjHHiPJ+X473hCYHDvK1cBGNC970tCku8rJfPnvu4Cj1exQ1EFykZgDvKXJFO/
         7RqINHHljdo3y1pZQt+9IfEKHaU5jfbpPS7Uk9QDLigrSCZLA2BAYeYJ/mWQMtRdNPGW
         jLwEYGmxHUVh+I6AD0slbJ1SFb3ks3+UvozZnoJ6m5uxNtZObz8/AGnPGpjdUwZP3w0/
         ihcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=/e2769OlgcqufYB4U1Tps3XCuK9GZYp9arseKJu1pCA=;
        b=jplhJftWRQ4Bi0SyJ/HY3KoddiB4cJ48f78MEMxjWA3GOfs4mbLLxxXKRpn0b7GoZ2
         xoG/+pHG3W73+0t3jXE2LXE7wUMfz6iaTqG9PLIvPMizpykdsIc0jMFl2om4PXeLgefE
         qjNkGmISK9nrWnVa/B5CqqAaWZPBC5SL7wfvCK2tvW7lS5fk+/eT0X3nnhgUi0112h4H
         cJ2cP+QlMwcTbv89dNJPuadwAMyaRif5oeKUBAhmIq77lNMSpVH7Rp1RhBwM+3kmd0Ip
         yTfQVufQkTuabmXNHOWBFYEfEdXTQhNJlllKonLJf5u8oVI+RLriHf5bJRXFlkGA0kPO
         +hHQ==
X-Gm-Message-State: ACgBeo3WAa14BzBgJPJIkKppAWRrOBmksiI9c5OFEYwDrwWvYkUe68/l
        cdPnv4Gu4ZMTKr3kmTExqRz+QQ4MMbw=
X-Google-Smtp-Source: AA6agR4E/omOecmBz2eTdphYx7O9gqqzNjEX6EGUedNCUKs+AAbl48UXmWU51TMF2B9cCUIlz7MThDX5sCE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8149:0:b0:536:84bf:69a0 with SMTP id
 d9-20020aa78149000000b0053684bf69a0mr646442pfn.85.1661457582878; Thu, 25 Aug
 2022 12:59:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 19:59:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825195939.3959292-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 0/5] x86/emulator: Test POP/MOV-SS blocking
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
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

Make the emulator test 32-bit friendly by extracting the testcases that are
64-bit only (in practice if not in theory), and add a testcase to verify
that KVM inhibits code breakpoint (#DBs) on Intel CPUs if POP/MOV-SS blocking
is active, and that AMD CPUs do not suppress code #DBs in this case.

Michal Luczaj (1):
  x86/emulator: Test code breakpoint with MOV/POP-SS blocking active

Sean Christopherson (4):
  x86/emulator: Delete unused declarations (copy-pasted from realmode.c)
  x86/emulator: Move basic "MOV" test to its own helper function
  x86/emulator: Make chunks of "emulator" test 32-bit friendly
  x86/emulator: Convert remaining spaces to tabs (indentation)

 x86/Makefile.common |   1 +
 x86/Makefile.x86_64 |   2 +-
 x86/emulator.c      | 921 +++++++++++++-------------------------------
 x86/emulator64.c    | 464 ++++++++++++++++++++++
 x86/unittests.cfg   |   1 -
 5 files changed, 742 insertions(+), 647 deletions(-)
 create mode 100644 x86/emulator64.c


base-commit: 7362976db651a2142ec64b5cea2029ab77a5b157
-- 
2.37.2.672.g94769d06f0-goog

