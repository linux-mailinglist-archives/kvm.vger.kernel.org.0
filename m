Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB91549C8B
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345595AbiFMTAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346244AbiFMTAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:00:20 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C7799697
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:45 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id nn9-20020a17090b38c900b001e82e1ec1deso4278644pjb.0
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=tBGKoaqTyFq4mhd8hJg4IAsXKcwBUi8nZnrjhPy9tbs=;
        b=cqWhUzx1G8LbAkjjC0yKje1DM9bRasRid++QwMSv6QwcL347OdAirlHlpvcTPbuAci
         St2hTRZRcFNbx1Bihwo/+78YRZ2bOwQLilIyqDYwGqVD5jdhoV/mRy6vy7C63iUcJO+v
         Q85S53kbXkqE0mD2EssqrT1WhUU5FyL6cSrlz0nZQ80UJfWYJkX1AwtR+QS5CADhMbBD
         XLa6rKWcy2GWtNHBdyS8BdOiu4fdN+ivSUEOCqezWmZ7lsfjhZOQtntfV+lo/rbM4UOG
         qKrq4L0TN76vpgH1YChETmeWeCABLlmJ6035mIYwp70tmKWd0gxtmZPVQTouC48a0lAq
         WpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=tBGKoaqTyFq4mhd8hJg4IAsXKcwBUi8nZnrjhPy9tbs=;
        b=V4nQ6lvRgEQKj/18UY+IJ/iu3QB+dORyWgMJ/Eo2LBgPFHfCyJ3VgQ3PeiWwmsxzrc
         chLnFuVZUBqI1zkUbAOyKpKJ4gVtnhp92kbfaFniAalMDDPwYZ/zB+VFNv8ferg0rJEi
         kLlIoOrgIYsTtPpnWangTFCxNPxSYEWXDKwObXrGPzkb6JzBrhWBr1N6cb3MYVVVtl8S
         aOYds057tqXXteJS4QOJRHSUDLGdmQMUWfh+LfwdVGZ/7kpFgAhmsNiz/v0TlKyPqwqB
         9wFFfsmXJ4plUXn/gVsfyaulhG/2bpRJhB3Ax1TaBke3zVXXz5YwK4e2+1NWpGojN+At
         Dm3Q==
X-Gm-Message-State: AOAM531PFmwako1feBnyCDQvzzS6ijdDaunUJdhxosuqbSHMDmuTHo8A
        QSAmtyIS9GujxuDwxcHzg7bKTpQAcLw=
X-Google-Smtp-Source: ABdhPJyAU+rsKytZ5oc49Rl+a8soAa6X65jdGz1tfrsz0BQM7dBobS9Lu7hc+Rj33QmNdj55e0Vqe66s1vM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2353:b0:520:6d4f:4594 with SMTP id
 j19-20020a056a00235300b005206d4f4594mr130246pfj.34.1655137185274; Mon, 13 Jun
 2022 09:19:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 16:19:38 +0000
Message-Id: <20220613161942.1586791-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 0/4] KVM: selftests: Fixups for overhaul
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Fixups for the overhaul, all of which come from Drew's code review.  The
first three should all squash cleanly, but the kvm_check_cap() patch will
not due to crossing the TEST_REQUIRE() boundary.

Sean Christopherson (4):
  KVM: selftests: Add a missing apostrophe in comment to show ownership
  KVM: selftests: Call a dummy helper in VM/vCPU ioctls() to enforce
    type
  KVM: selftests: Drop a duplicate TEST_ASSERT() in
    vm_nr_pages_required()
  KVM: selftests: Use kvm_has_cap(), not kvm_check_cap(), where possible

 .../testing/selftests/kvm/aarch64/psci_test.c |  2 +-
 .../selftests/kvm/include/kvm_util_base.h     | 57 ++++++++++---------
 tools/testing/selftests/kvm/lib/kvm_util.c    |  6 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  4 +-
 .../selftests/kvm/s390x/sync_regs_test.c      |  2 +-
 .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  |  6 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +-
 .../testing/selftests/kvm/x86_64/state_test.c |  2 +-
 9 files changed, 42 insertions(+), 41 deletions(-)


base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
-- 
2.36.1.476.g0c4daa206d-goog

