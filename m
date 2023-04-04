Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C96C6D6984
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbjDDQyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbjDDQx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:53:59 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C02A5B8C
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:53:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e5-20020a17090301c500b001a1aa687e4bso19640950plh.17
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627224;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EL0zXJxWbCwjKanOmqkxBV7MLGNMefGyqz0/6QxSTAg=;
        b=lWAlsSpA51u/Edbsz2a78RVBU7Q/jA47hKdallZtM2bskw0zHB2o4m32FddzEYoi7g
         YkG+ovPI811YPXCXIP2BsASNSXz0zwFefK56iYnC8eZDusszCdnvsJqkVk/peE+52X6i
         PGEURaVDorjet2nXK2IvBTHHTFGrth+eOwNoAfA63q7M09JDAZGMvvUmqeiIbaExZ0b4
         Egx85jeb1hLEG/lrty9b5euzSinU5uKKjmaLLzN1FiUIs2/gKL8y2GVxMIeIJZnQDImA
         BLIfRID6Qix0bZ1mKKGeXdpQtspi/rmG/2EsIYWCZyJkcvqVDBR/ng6XUZceQCx8VqA7
         xzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627224;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EL0zXJxWbCwjKanOmqkxBV7MLGNMefGyqz0/6QxSTAg=;
        b=rXyJsAURtTb/IHhpxe0TpjUXzPPmWUauG459dTQSPaP/w2XpvXOulqx4jxv66DZfyx
         wljGVxZAK6vlt6+DAwFsqUqIEtOThhCU47urVakA4rBHuiUc3YknwVMdk/UcR1sFKMbf
         /uYneAjrEhVp98zindMfVgop91x6xyajLWFpcYZ1+vsV/oUu8JO2D5FzYYuCMNRer1WM
         jZ7XV+byGmOdnx1JOfQ6ThG8ODbBwxBjT5awS8J47FQgCNogo8FqZD7xEWkXCaXBaUTz
         1iLATr4b/z7xwMUjUorhw5flVXh3lJtAoBhRKfaoF27obTjVEEYawwtSnuMOQDZ880nj
         Jdmg==
X-Gm-Message-State: AAQBX9dAJ3gebFf8ldYMXvCErrwSQxljOseAKu4dig7ED0sbxdE7BROr
        100qh3QF5wLLmvMPeOtdzfwZUVvvVIE=
X-Google-Smtp-Source: AKy350Zb0ttcuAQcenLQxMSArQVf4Kt8PRYY7JKNn8bWTuyhA6jqv52MeoCAynlWKit16Nnc0B4kwSL8cJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8c05:b0:23d:1121:f211 with SMTP id
 a5-20020a17090a8c0500b0023d1121f211mr1198957pjo.5.1680627224111; Tue, 04 Apr
 2023 09:53:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:31 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 0/9] x86/access: CR0.WP=0/1 r/o tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mathias' series to add explicit CR0.WP toggling tests, along with related
cleanups from me to allow enabling forced emulation for the "core" of the
access test.

The potentially controversial change is to make the extra-slow variants,
including forced emulation, nodefault, i.e. so called "manual" testcases.
Using nodefault is the most elegant solution I could find, e.g. makes it
relatively simple to run all tests on bare metal without triggering a pile
of timeouts when running in a VM.

v4:
 - Make FEP manual-only, but included in the core loop.
 - Mark the extra-slow (4+ minutes each in a VM) VPID-based variants
   manual-only
 - Use the standard reporting machinery so that SKIPs show up
   correctly.

v3:
 - https://lore.kernel.org/all/20230403105618.41118-1-minipli@grsecurity.net 
 - Rewrite changelogs.
 - Use helper for guts of CR0.WP test.

v2: https://lore.kernel.org/kvm/20230331135709.132713-1-minipli@grsecurity.net

Mathias Krause (4):
  x86: Use existing CR0.WP / CR4.SMEP bit definitions
  x86/access: CR0.WP toggling write to r/o data test
  x86/access: Add forced emulation support
  x86/access: Try forced emulation for CR0.WP test as well

Sean Christopherson (5):
  x86/access: Replace spaces with tabs in access_test.c
  x86/access: Use standard pass/fail reporting machinery
  x86: Drop VPID invl tests from nested reduced MAXPHYADDR access
    testcase
  x86: Mark the VPID invalidation nested VMX access tests nodefault
  nVMX: Add forced emulation variant of #PF access test

 x86/access.c      | 114 +++++++++++++++++++++++++++++++++++++++-------
 x86/access.h      |   2 +-
 x86/access_test.c |  28 ++++++------
 x86/pks.c         |   5 +-
 x86/pku.c         |   5 +-
 x86/unittests.cfg |  20 ++++++--
 x86/vmx_tests.c   |  27 ++++++++---
 7 files changed, 154 insertions(+), 47 deletions(-)


base-commit: 5b5d27da2973b20ec29b18df4d749fb2190458af
-- 
2.40.0.348.gf938b09366-goog

