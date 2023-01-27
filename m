Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5493F67F090
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 22:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbjA0Vn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 16:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjA0Vn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 16:43:57 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D989A59B7F
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:43:56 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n8-20020a258d08000000b007facaf67acfso6681224ybl.0
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m/RabSljBhZ9UUQSJRI1BylATrQl4vx1wTwVBab6KOg=;
        b=hnYIO1DqcXYmL4VaGlmbSIyGBXMwCCofyp10m1F/jucbrsquWi8yL40rOVZz+GqF3H
         s+MgTBvwSlgCYzu8ZykTISF2X/PuamkdRYBuOBoHqk53eo2AK/6CYD3CDsRvcPmdUdZF
         N+fx6+4UiHhw9sFeCx9WWzStdvDs4jSFXwGfIcDobyuu4WhGgTHS/WFcDGdcSA1zL40s
         xTc86+vu09iirLZzNugpZ+rjXWRqX2sTRBq83eafJyCbK4jL81r4h5KCWJnmIgoXyER6
         RHNzt1H8VXwsTk/rfPpTmtvC3nHpOmME2XD+Tq+LNX6TRuM4Hd275MuOi36bS0iKvVVg
         uGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m/RabSljBhZ9UUQSJRI1BylATrQl4vx1wTwVBab6KOg=;
        b=KQVtTMHrSZmiQCSGrzXIf6CZinGb3AXnNbKsukjADWPZPX5oas5QArDQuHPUtEojqA
         ClvTFezRxvNufYj9UqMu81aTzaW9Nf70oyK2FjoeS0Nq30rqpGo3Ue14UmKV0beq3Kxk
         3n5lWAlIsDXBUulPb/W9Giy77ukp8VWkjWNaGFij7fhQXru80dfMFpdrKnD3vnPrByuW
         GfJBuqxQnFeob22Zn98/2vBn3rxUp69Gme7tNSxjfZ+UL4UkrQVWAeFOWBCCiMzloqnt
         mj7vcvqe7BslsF4O4D9L0IycrwPNBqgiin1ZlKSOLfnJQmRwsMHnJ2afmsqubevkRPws
         ZQqA==
X-Gm-Message-State: AFqh2kqt7nSLZPGcrmpsel5Xs+vY39Us3aL06SAH0l8GStp2J5AceB/9
        faxhjN8zVxfCm1WmQ/EiaOHvSDJfjKV9sCaWNk7r792Sig2S4jEKPrgxnh4ruPHNU2a369yyFvS
        W1EYw1fHAr3PKefNbZEi6UF0gpdnHt52N5Q4XIcnzGoEougbAt5SMI+XDNf+HsnU=
X-Google-Smtp-Source: AMrXdXuZFCRsF43mKJP/JrWWay+JHAtZ0w0wGfXsDCq5zzUMO++Q+S7T4cqFlsYVwbhQhkI+936g7Kn62LNPsg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:7589:0:b0:7dc:116c:8499 with SMTP id
 q131-20020a257589000000b007dc116c8499mr4440641ybc.9.1674855835993; Fri, 27
 Jan 2023 13:43:55 -0800 (PST)
Date:   Fri, 27 Jan 2023 21:43:49 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230127214353.245671-1-ricarkol@google.com>
Subject: [PATCH v2 0/4] KVM: selftests: aarch64: page_fault_test S1PTW related fixes
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

Commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")
changed the way S1PTW faults were handled by KVM.  Before this fix,
KVM treated any fault due to any S1PTW as a write, even S1PTW that
didn't update the PTE.  Some tests in page_fault_test mistakenly check
for this KVM behavior and are currently failing.  For example, there's
a dirty log test that asserts that a S1PTW without AF or DA results in
the PTE page getting dirty.

The first commit fixes the userfaultfd check by relaxing all read vs.
write checks.  The second commit fixes the dirtylog tests by only
asserting dirty bits when the AF bit is set.  The third commit fixes
an issue found after fixing the previous two: the dirty log test was
checking for the first page in the PT region.  Finally, commit "KVM:
arm64: Fix S1PTW handling on RO memslots" allows for having readonly
memslots holding page tables, so commit 4 add tests for it.

Changes from v1:
- added sha1's for commit "KVM: arm64: Fix S1PTW handling on RO
  memslots" in all messages. (Oliver)
- removed _with_af from RO macro. (Oliver)

Ricardo Koller (4):
  KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
  KVM: selftests: aarch64: Do not default to dirty PTE pages on all
    S1PTWs
  KVM: selftests: aarch64: Fix check of dirty log PT write
  KVM: selftests: aarch64: Test read-only PT memory regions

 .../selftests/kvm/aarch64/page_fault_test.c   | 187 ++++++++++--------
 1 file changed, 103 insertions(+), 84 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

