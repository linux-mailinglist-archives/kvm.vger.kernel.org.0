Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C04E660B5F
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 02:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbjAGBRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 20:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbjAGBRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 20:17:43 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDFB1E3EB
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 17:17:40 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4c0fe6e3f13so35246207b3.0
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 17:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WyvGKzpzx3N94FItes14H220nJNdMOeIXaL9ux0jsIQ=;
        b=Ii1qwhRa2pej1KSG3bq1HJejpupU3uHFfPLNv4H8XwNc6sz1asCNdUkoWVS7Zlk5Mn
         DZN0rVk9bIC1WmPjV5WyQpJn4WWBIaQpMNUBVNR2mpchcsfLSGF2+7tQFGrIJ7PMG403
         vwdr2bkr9FjgkkUwK/gdmYrUKD83odSArsCHy6GvexP+N9fPUe17lLUdNiUxR255JUlv
         6H+3k6ZjhPf+B2If/NLfjMFmJEOM2WFI995DdiJUnK3Y7s/phI3NOrKxkkDrOtVfOeNO
         hhX3ov4KAGPI5FXv391Q1YGb2anpAt5KomVyKpbDQPva143WJAS53t9DaTEiiPRVzJIk
         TQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WyvGKzpzx3N94FItes14H220nJNdMOeIXaL9ux0jsIQ=;
        b=HnyhQm7nmpzyDEJLltd7JFLtfzCWNAaTq9p00S7V4PnGxv4HeLcnuksbu8OM4HD4go
         tKaWzBRGNk79MNhbejAQW71csuIqs5WC7FzI3r4glZr16QsllqmM+KNjFYJkF9FGETD2
         L09q6y3ktY+2VJO0164EdU6wl2U5DoZZNaxD3Bt69MzjLgr9/mTF6HA0aJJaTdoVL3bP
         RH2IR0vxGvo8BrDP37SubOrflzROTdWBIVxf7SGddnZJCgRghWdzx1k7m+qBerdqnijU
         6U3E3AudqA84c243jMxErf6nxCJorV0cEkH4v5dTIbi+wsOx3mA9vAErO76QFAVZoYcZ
         v37w==
X-Gm-Message-State: AFqh2kqd/NolcXjjuS0S/RqMrZqwIWo15j0vX9NJ/qYt620rn+/UhEsB
        kYPUBTAog2YjA2tjvvO4NnI1Y/1Qf9o=
X-Google-Smtp-Source: AMrXdXunqrFYvoIyWCzI/mhQ/azkE/DQy7d4KszJ1rlvC4KSPy8lhvSH1JCbFNEds/ijCVJQ5+xWgmURgXo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cacd:0:b0:7b2:afab:f372 with SMTP id
 a196-20020a25cacd000000b007b2afabf372mr1367968ybg.640.1673054259691; Fri, 06
 Jan 2023 17:17:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  7 Jan 2023 01:17:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230107011737.577244-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/3] x86: Add testcases for x2APIC MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Add tests to verify that RDMSR and WRMSR to x2APIC MSRs behave according
to Intel's architecture, e.g. that writes to read-only MSRs and reads to
write-only MSRs #GP, accesses to non-existent MSRs #GP, etc... 

Many of the testcases fail without the associated KVM fixes:
https://lore.kernel.org/all/20230107011025.565472-1-seanjc@google.com

Sean Christopherson (3):
  x86/msr: Skip built-in testcases if user provides custom MSR+value to
    test
  x86/apic: Refactor x2APIC reg helper to provide exact semantics
  x86/msr: Add testcases for x2APIC MSRs

 lib/x86/apic.h  |  59 ++++++++++---
 x86/msr.c       | 229 ++++++++++++++++++++++++++++++++----------------
 x86/vmx_tests.c |   6 +-
 3 files changed, 203 insertions(+), 91 deletions(-)


base-commit: e11a0e2f881d7bc038f44d8d4f99b2d55a01bc4e
-- 
2.39.0.314.g84b9a713c41-goog

