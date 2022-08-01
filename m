Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B29587203
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 22:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiHAULR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 16:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiHAULP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 16:11:15 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA9419C3B
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 13:11:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q11-20020a170902dacb00b0016efd6984c3so771772plx.17
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 13:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=spLa+8cqriOZAhw1Zi4AYOlRklLSR96sO0vwvWIpDDs=;
        b=NOWEDdkgFqZDD8hZ0NEfLZMXqE32QLY4UxFy8k2Nc5sI+vpryX39pHFxsWXpJ3Zvky
         xuuubFLBR7kkMlia5/tS8XGvZYhSF9iL18Gv8IEVO5UYX7JHuijqyqLiZiQ7rw66IzeB
         bcFm3UlkHTRb8oDdeLATcB9lab3n59LRpLAfr4C6X8R/P6G0VUwA8k6IVf78jtBq/qB+
         34QR8FEBRnzrWGBgs0oozXdZreNy9Q0hOUSHbW9q7ghnKBRirG+eI9Q1SPedw7NTx3iR
         y1ovkgjD+jLXafOW+sFrznI2rQIB81Saqj0J2mjUAvI7/++EcDFyqt4z0pcnVkNcwo8e
         0+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=spLa+8cqriOZAhw1Zi4AYOlRklLSR96sO0vwvWIpDDs=;
        b=Gq2sSsUjpTNMYYUatBE17Ha/DoNUI3aojmC55a+9pt5yeIH7fs98tYwtjOD/G6Jo8m
         aZl3RzgMGoDFaN3ZubkcSd11beDeeeRN9N8LCmuZFf/VNzYJgl7Oaov9HBABhzteowpx
         3xXiqvDg9Lu8wax+ZG2X4qF5sHRgVuwi3LQtJKHlkgPyv9+6aX0T25sAwArhNxvfGVem
         +4QE/R2x8fqZsec/4kWDvNcgwOPtFVvan91wGSiMRRy3R+0k5JnrXZy3C+m1WmWDEc3R
         qiwllMOFeUQfNwP6dh6wwyhI3+VO+QYEKq9i9qM1kUWoLwOtvv4LVXEkGLsFQ09pfx/P
         /B1Q==
X-Gm-Message-State: AJIora/KJir1QA/iCf8izWcTmPFB9SvvBGCIXodHHaB5CmrE6YAi2f7H
        tlMq75wjMYX/A5xYqtoEEZzJ+wJgSGac1uXAM4xy5xHQzKzsJgxyC4DglMzfDorm/7WsfidIsmV
        QNn5hu5XgIWckr8OlSgZaMwDMkjAbkfCRppY7YO0MztO83IjKpToKOY6wlg==
X-Google-Smtp-Source: AGRyM1sUGZIglgDaDk7TTl6TqPw6CNdURLsQ5TG4EFHeDqXvU0dXnNnlu2+kp5P1aHi7O0aXmBEXQLwzXjQ=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:6be2:f99c:e23c:fa12])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:e0e:b0:522:990c:ab60 with SMTP id
 bq14-20020a056a000e0e00b00522990cab60mr17866513pfb.8.1659384672663; Mon, 01
 Aug 2022 13:11:12 -0700 (PDT)
Date:   Mon,  1 Aug 2022 13:10:58 -0700
Message-Id: <20220801201109.825284-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [V2 00/11] KVM: selftests: Add simple SEV test
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
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

This patch series combines the work Michael Roth has done in supporting
SEV guests in selftests and the work Sean Christopherson suggested to
allow ucalls from SEV guests. And the work Sean has sent to consolidate
the ucall boilerplate code. Along with a very simple version of the
SEV selftests Michael originally proposed.

V2
 * Dropped RFC tag
 * Correctly seperated Sean's ucall patches into 2 as originally
   intended.
 * Addressed andrew.jones@ in ucall patches.
 * Fixed ucall pool usage to work for other archs

V1
 * https://lore.kernel.org/all/20220715192956.1873315-1-pgonda@google.com/


Michael Roth (6):
  KVM: selftests: move vm_phy_pages_alloc() earlier in file
  KVM: selftests: sparsebit: add const where appropriate
  KVM: selftests: add hooks for managing encrypted guest memory
  KVM: selftests: handle encryption bits in page tables
  KVM: selftests: add support for encrypted vm_vaddr_* allocations
  KVM: selftests: add library for creating/interacting with SEV guests

Peter Gonda (3):
  tools: Add atomic_test_and_set_bit()
  KVM: selftests: Make ucall work with encrypted guests
  KVM: selftests: Add simple sev vm testing

Sean Christopherson (2):
  KVM: selftests: Consolidate common code for popuplating
  KVM: selftests: Consolidate boilerplate code in get_ucall()

 tools/arch/x86/include/asm/atomic.h           |   7 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../selftests/kvm/include/kvm_util_base.h     |  26 ++
 .../testing/selftests/kvm/include/sparsebit.h |  36 +--
 .../selftests/kvm/include/ucall_common.h      |  15 +-
 .../selftests/kvm/include/x86_64/sev.h        |  47 +++
 .../testing/selftests/kvm/lib/aarch64/ucall.c |  33 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 267 +++++++++++++-----
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  40 +--
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  37 +--
 tools/testing/selftests/kvm/lib/sparsebit.c   |  48 ++--
 .../testing/selftests/kvm/lib/ucall_common.c  | 139 +++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 249 ++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  37 +--
 .../selftests/kvm/x86_64/sev_all_boot_test.c  | 131 +++++++++
 17 files changed, 885 insertions(+), 246 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

-- 
2.37.1.455.g008518b4e5-goog

