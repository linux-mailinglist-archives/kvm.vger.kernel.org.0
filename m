Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449D241381E
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhIURMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhIURMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 13:12:53 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679B8C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:11:25 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id d17-20020a9287510000b0290223c9088c96so51674164ilm.1
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2WwHnMxfL71q5qYV+BUA5lxnx5JteupLuMVdn6U4PTU=;
        b=aEwnhIyFP9IaWSTElIfZ8AMFpjznSzfegfLjr+adkd9wrEipgEFJlBtbWQ5NJAuR0F
         z7d4mT4kSX9mOV945lduOURu8bJgm4K6oRWx835XZ3ZgLG4UQcMvWcJsCUEjf1Q392B5
         zBcDyYI4ShdLQlbTBN99HqyDwG1Zkfwf8CnHMqlpvNRpvQ+ryq5MUP2IM0/BAROv96Ig
         srjmtDv375Vx+k/bAL6zs1X0t8chbXED/QMMvIcsB9caoGdpgr+hBdpIsW4kJlrOC0xR
         JoLJ5veWD0aswc3BWe/7hzYvQy3Dhc3WrAwN/+TmPhn8ezFoTbhbSnKHhxSbPgcuw0q8
         yGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2WwHnMxfL71q5qYV+BUA5lxnx5JteupLuMVdn6U4PTU=;
        b=3ZOGY3n9YkDCZY2leXzLCqmpNNVklUMxUwJ0RBWHLnyK7xrChNgxjugPNU/mGtFWGb
         /G+GF/sFbeCiUb7s2ISDG9qrfKDKZY7BPmbVECz3q6T5tzOJoxHwS1TRVuep8lijSNqV
         qDf/ajI16WwNJdUfOhQBRhArZ8PziTJYxbUMhCpSeVeWiVGCklj4lFjnfdTWA2hpoYSh
         R5aPgF8YiDx7g5EnDksecwDUJeCLnuZcoXBVrZdrfvVmfPL3Y+qCS4numEFzGuzHOGlw
         eeKCezn/a1J4hEwoRP/xFUV3b8QPknA2If9VHpHhsuTvQ3g4qD94VrSQ7XBB0JEgBEds
         R+0w==
X-Gm-Message-State: AOAM530TZe7Mnhpa5Khk9yqjE6oLvYwyHGFk82sHGB5rR2e1dLba2wy7
        JLAO/9KJN53MvCUrgBP8hTMyvrptFNcrww0M+3UEvs3JBQsEaoO/C99WH/6cCGE1a+n4frVN5uf
        /QLqaWwBMo237zZkgwV4Z7UNCAb/fZjXj5GapLBCqXgZslx9YRTDfgD08lg==
X-Google-Smtp-Source: ABdhPJwd7eZymOGxBpOWau8xHW5PaOuKf1gdGIvDqyp37yR/MO19C0sffJUxUGXJo4bfPDWfL/IZeESa07g=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:12cc:: with SMTP id
 i12mr22545273ilm.273.1632244284627; Tue, 21 Sep 2021 10:11:24 -0700 (PDT)
Date:   Tue, 21 Sep 2021 17:11:19 +0000
Message-Id: <20210921171121.2148982-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 0/2] selftests: KVM: Address some bugs caught by clang
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Building KVM selftests for arm64 using clang throws a couple compiler
warnings. These fixes address a couple of bugs in KVM selftests that
just so happen to also placate the compiler.

Series applies cleanly to 5.15-rc2.

v1 -> v2:
 - Clarify that 1/2 is an actual bugfix, not just an attempt to silence
   clang
 - Adopt Drew's suggested fix, aligning steal_time's SMCCC call with the
   SMC64 convention

Oliver Upton (2):
  selftests: KVM: Fix check for !POLLIN in demand_paging_test
  selftests: KVM: Align SMCCC call with the spec in steal_time

 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 tools/testing/selftests/kvm/steal_time.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.33.0.464.g1972c5931b-goog

