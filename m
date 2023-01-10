Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B32663741
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbjAJCYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237745AbjAJCYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:24:37 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7FD271B0
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 18:24:36 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id r8-20020a252b08000000b007b989d5e105so7814407ybr.11
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 18:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CKD1lmtKDuCBjqGCBiuqowGuY1aodNaM6un/5m3rvw0=;
        b=PYHzJbjYM/+zeNJLwMOqmkGGfyVWRdJFsEjhkrm95k2wVXABDR1sIxWjpgcgMoxQ2b
         TloUdM7n+qSiYD2dHf+fBb0bEwLw70uTchbXKPr2BQdVda4kak9T0agBUTIJLP//g3z4
         xmVEC5A8WEEUEaZuGS5zQL8BHKO4gmGIfPMPdD7+TczGA16ohRt0xgTphpO1wWIU1pdU
         tKhIYtKYEjop47MqkVXkH1mOUTJ21Ee1YpbjJr0E6ed3OFKep3GtGc+CCbvKLKfA/P5o
         IZwg01t9gdetH43ANwU05JvrIPkkcXYLPJDYHSvYug7AbEEgOTI5JE/j4skBh863HXjZ
         mSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CKD1lmtKDuCBjqGCBiuqowGuY1aodNaM6un/5m3rvw0=;
        b=4O5iV+JqD7qALKHICb7FmygWVNfDABnuGF4n8czRg4x9TXtjDkv6ewiWjhwMGuwDNk
         cMVkCBM2t7w/xCDdgkFNfkg2Jj8zH2f5zvfUKdlvyhLqyadaKmQpC6V9hX2Q5aNaDDTV
         UMmLzD6vdt8e3gpDDiQs+sLJQRluCB07h6i0BnnFat3KpHjLJXWhO71ejDyLLaTu+u2P
         /yPMCSGOvejMbwHFkQE8yiPAR1x6OIu6116bTPs7cxu9Ukpzph363z53Kd3FSy1QKrfp
         llwD3s9T3KGmcFyDP3XfqqHOU/P2gHtJ3LymUHbZFAABG1tAxcZaNPqlpFDI5NbCT2sK
         DJ6A==
X-Gm-Message-State: AFqh2kps2f/rXrO47S/FXpwj5PqR3SicMHvEwO61SkfAD42SgkeXu21+
        f/fsedkheDLlzT0y9yia/TNCv9tUUZmwfK1m7alHU1r56kEosbGrOxD3FxQUZFa3VklSGgQRaqb
        +9/8w38Vuk4O9ZRQm3pCsLcjzXSm1c+UTTtP6xOj/F0Y06kQGO/upVvSX6/Eq0Fo=
X-Google-Smtp-Source: AMrXdXvsa7bTcCa7+KYaI3L5lEV5PsjGF7et8ZP4rdGklbY/kQWwGma8AuaNkeWmSGe8z08sj+8v0XrsskBvbQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:746:0:b0:6f1:4590:92b9 with SMTP id
 67-20020a250746000000b006f1459092b9mr6892803ybh.430.1673317475240; Mon, 09
 Jan 2023 18:24:35 -0800 (PST)
Date:   Tue, 10 Jan 2023 02:24:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110022432.330151-1-ricarkol@google.com>
Subject: [PATCH 0/4] KVM: selftests: aarch64: page_fault_test S1PTW related fixes
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com,
        Ricardo Koller <ricarkol@google.com>
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

Commit "KVM: arm64: Fix S1PTW handling on RO memslots" changed the way
S1PTW faults were handled by KVM.  Before this fix, KVM treated any fault
due to any S1PTW as a write, even S1PTW that didn't update the PTE.  Some
tests in page_fault_test mistakenly check for this KVM behavior and are
currently failing.  For example, there's a dirty log test that asserts that
a S1PTW without AF or DA results in the PTE page getting dirty.

The first commit fixes the userfaultfd check by relaxing all read vs. write
checks.  The second commit fixes the dirtylog tests by only asserting dirty
bits when the AF bit is set.  The third commit fixes an issue found after
fixing the previous two: the dirty log test was checking for the first page
in the PT region.  Finally, commit "KVM: arm64: Fix S1PTW handling on RO
memslots" allows for having readonly memslots holding page tables, so
commit 4 add tests for it.

Ricardo Koller (4):
  KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
  KVM: selftests: aarch64: Do not default to dirty PTE pages on all
    S1PTWs
  KVM: selftests: aarch64: Fix check of dirty log PT write
  KVM: selftests: aarch64: Test read-only PT memory regions

 .../selftests/kvm/aarch64/page_fault_test.c   | 183 ++++++++++--------
 1 file changed, 101 insertions(+), 82 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

