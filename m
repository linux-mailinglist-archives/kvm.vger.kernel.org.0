Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EEF5EFED8
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 22:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiI2UrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 16:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiI2UrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 16:47:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4DD153115
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3515a8a6e06so24592707b3.12
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=wZAKV3+3tlzPblRyzChf9vgthT90SPN52QvRl27wRc8=;
        b=IRyal+nOIlxnT0g+OhJ9cEmOwAiTlbnA1IJIMkyAMZAomNHNDWZNPK4a9O8Z4639G0
         7VEHYW0wkVOKBOqlD834WYYOk9kgqcf6cPH33vQyJ6ZFAMqlqI5PM92Q0SrUbKhmol+m
         cJ5a/3yMmNhP6E+CG1/7HgcPvITmQ7PF4cl+3U5NCajTV7/m7efUf0dF6noeIzSY1GR4
         Yh2nIGhYS6YFJZggKfN4BOr+tC6QlC2yN6JlYMBU0v144/yXi4w/RXwLEP0ugsYcF3Vc
         HOCdCXlNmf87baidoddJc844ByV8zQ7+CEjDS1CgfO+TiJZ+oVOgA3k7r9j/iUJSkS8v
         0cBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=wZAKV3+3tlzPblRyzChf9vgthT90SPN52QvRl27wRc8=;
        b=MUXdDbgSgLZe7VBP59SYLYvTJudjylta8/eDC5eeT0m1pOPv8h0lE/9M/iqYTNGxWL
         NTCuDHXAFzJh+ZIEtTFW4sl1UvBhP4ZEmpbskn3aYgD2NrbFeWiNf41EZGOtz/Q80RFy
         s7Pbsn1FlFvOpdzKl3A3mAFGdzrj8U/pMXNCJtL6xQoCeJMmKadPBZd4YP+tXPvH918r
         uSixu6r8BCxZ9fY+S8Q9WDeZ3AdP43qsEIdE7t+HfRmJ3W26n6p4JX0EK+sCg1xi9wBJ
         3iUNqhAL7XjXPVb8tCwg6ply4I6ixe9QqFlVMvaVK5fk0ONSmL4dwaxPGpmX+w9llWW/
         4Q9A==
X-Gm-Message-State: ACrzQf3s6OwrOhhFwwqL8KwoYqP8uXv39i5yJ8S2ttjgXCGRXkE2WQA0
        B7a9EytBth3k2JKh/levmeFW5f3kT4AENg==
X-Google-Smtp-Source: AMsMyM5Lm6aYPQ6sueR+gyhrq35u7Je0Sr70s3EPAgL0j3ibLIX62AE0Hv6LqFWhxUbkIHCx9lHciBINpHQO2Q==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:1082:b0:6b0:77da:d470 with SMTP
 id v2-20020a056902108200b006b077dad470mr5371889ybu.273.1664484433792; Thu, 29
 Sep 2022 13:47:13 -0700 (PDT)
Date:   Thu, 29 Sep 2022 13:47:04 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929204708.2548375-1-dmatlack@google.com>
Subject: [PATCH 0/4] KVM: selftests: Fix and clean up emulator_error_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

Miscellaneous fixes and cleanups to emulator_error_test. The reason I
started looking at this test is because it fails when TDP is disabled,
which pollutes my test results when I am testing a new series for
upstream.

David Matlack (4):
  KVM: selftests: Use MMIO to trigger emulation in emulator_error_test
  KVM: selftests: Delete dead ucall code from emulator_error_test
  KVM: selftests: Skip emulator_error_test if
    KVM_CAP_EXIT_ON_EMULATION_FAILURE not available
  KVM: selftests: Explicitly require instructions bytes in
    emulator_error_test

 .../kvm/x86_64/emulator_error_test.c          | 130 +++++-------------
 1 file changed, 35 insertions(+), 95 deletions(-)


base-commit: 69604fe76e58c9d195e48b41d019b07fc27ce9d7
-- 
2.38.0.rc1.362.ged0d419d3c-goog

