Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2387402E26
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345559AbhIGSLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235343AbhIGSLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 14:11:09 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC57DC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 11:10:02 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id w5-20020a654105000000b002692534afceso6114935pgp.8
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 11:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3EL/0cpyqgf5kZhn/yI/Lhs/U8ef49iFyluZ/iCjP80=;
        b=mhBXZVspu3u44w6TnlIsSrX/pVRWzIeWBIqJN19OPCjAKtUCzp9L1+erO/3M5TG5E2
         YsJQFd2dV86my+qU4BDCIHO9Qp0Gyq4JhiQkKCmwOdaB6Ha2Sa8oiZXIRaEjQ7ARhP/O
         uEyob5uMh30dBZLgRsynbm53OdjaGwG5VNUg0KLKoikkbX1QQ4q0QcPg1yJwnfPCE9IE
         vZ4UaiwFk+dkegtlPWVIOIfbF/443npVnmrOsc4PhEsDE+ZLG9SnIRn9RMJxZ3khEyPj
         sGCEJxfNtZtNLVZrBqKoXihL5r6gTkNHrVANo1j712hzk0QYK8wWsAg63OZ3kL0IO/DL
         ylHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3EL/0cpyqgf5kZhn/yI/Lhs/U8ef49iFyluZ/iCjP80=;
        b=Z2IhQGGiWD25QdMSS3tyx/Xp0teXMCG3hGMAl/PnRTl6W6gTClUAcsy/7JlmSTqDZ8
         I24lWAfihIl/I6gg4I6KqHu2hNvkx9E5g8/O0UTusgSQ2N1FuGbrcZwVtKsPBLGBNi3T
         7pDZj+6819H2myrX2kyai5M2lw3laxLd0/SjLZ/OLxpJTX3wPJIwd1y16XUDUQsOvET3
         CPgkWWr+yk1gEbua1vzGuG5tiJWXdiCyCAWLli0/aWr4V/SAN5n7HnCZ+fKUA98L4Myt
         xfRm1TlP6FPWb2yVyctO07PrxPVzYibkntH9u6VwrjFVsiU99XFE5c0H3VEIlH90e7hK
         Im/Q==
X-Gm-Message-State: AOAM530t5CQv2tVaJqwmY5FS60O5o8z1y/XtuszAEbdeRqSmwhuJpxEi
        wYFaaK40laNPfHh+M50WZOs/TIPEm+E+7kVIqeDRMmV1z4GtTWrb31o3OVGiwddPJgkyICMqGdJ
        42P0NFGmlWqFowc+oNHZ8x7Upo4kqoijqHEDi1rrQX88wN56uNyz0ow29KKSsjuY=
X-Google-Smtp-Source: ABdhPJz/ZY6iRv5Y40MiQYuqg5TkSzsHv35QJyuWITR9HdnZag3X6B7AjX4oAnAHsqIedrszpQ7J/tN3PRlyOw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:7f04:: with SMTP id
 k4mr112383pjl.0.1631038201805; Tue, 07 Sep 2021 11:10:01 -0700 (PDT)
Date:   Tue,  7 Sep 2021 11:09:55 -0700
Message-Id: <20210907180957.609966-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v2 0/2] KVM: selftests: enable the memslot tests in ARM64
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable memslot_modification_stress_test and memslot_perf_test in ARM64
(second patch). memslot_modification_stress_test builds and runs in
aarch64 without any modification. memslot_perf_test needs some nits
regarding ucalls (first patch).

Can anybody try these two tests in s390, please?

Changes:
v2: Makefile tests in the right order (from Andrew).

Ricardo Koller (2):
  KVM: selftests: make memslot_perf_test arch independent
  KVM: selftests: build the memslot tests for arm64

 tools/testing/selftests/kvm/Makefile          |  2 +
 .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
 2 files changed, 36 insertions(+), 22 deletions(-)

-- 
2.33.0.153.gba50c8fa24-goog

