Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F0629CD53
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgJ1BiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:20 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:32867 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833028AbgJ0Xhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:37:38 -0400
Received: by mail-qt1-f201.google.com with SMTP id d22so1830227qtn.0
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=6Ug1lZtYrMX0hCX8/6f/DPUAAEkbtDYFeA5DkZlPqkc=;
        b=N/DzRsM28GY4x8CL71pjPGO3OSYCLyWIfrd1PuG4H2reL0PZccSPqVKIPqcokadAHH
         87rBHn3QDGRQVvW/Acuawsefr3+ORuHfUTjkkzZ/RmLMfpg47YhCPgv/TuSrQa5pbbyY
         FEkgZ4zZskh+o7+pYgWEWwW+6GUT787ftFXvG31zpkZBFTykq48XevHS6tjmLt7AkD4H
         ZgPWGZxGWmqVdpjJSCwM+zJv4FqJNi75ltZhN4mfOPo5ReM3QesZ7avjZmuz+V2qtVQb
         M0lKEZoLJ1Rhicw7meOHPruMttaqTDxLByWmxaSf/GKmHioobmSLuVD1AAY5A9UPonF+
         Vgqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=6Ug1lZtYrMX0hCX8/6f/DPUAAEkbtDYFeA5DkZlPqkc=;
        b=qIoFQ3M74s7bkcZzWf67f+knMAj4CCk3S2uMOGcyyFTzYAmc/GWve0F0MgJJ/hAOsx
         cyd80qOPwt4HOSR9kn4128SlWIJgdQnTjJEIlNJU6pTx0RB0I0yYd50KHiJzG8XYAtUE
         1Reiw9JeMA+buTBM8ozxgP8kTeOFDAFhkky6SRvKtk3wecFzxBx+W0C3NIPIrxVa0YYR
         L46cs1ppGpPUFPXA+boYDlTgnda8RUaJtP55HtwQRuP/K8peJ0tu9q3sMcKJ2eXja5i8
         duy/J57tIXSeE4JL2fP969lFSCK5ICj56aTGj8h8FQK7w7MUaLy38isiiCaJkrmG418p
         55Ug==
X-Gm-Message-State: AOAM5336+UtYE1B4wvSMRRoAKYV16d31+IQDzeb5A24Us5fti6eQ5ebG
        Xt8n1LRx1K4Op4CvVpbVbb8KnM6o7Zpf
X-Google-Smtp-Source: ABdhPJzgmw/OsHwejrlvXN9zgTn2DaC0Cj6MaccnzISVSAYnhjrxqVck1OnPb87+0mr+urAsDflzv3ecUEb2
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a05:6214:136f:: with SMTP id
 c15mr4922924qvw.57.1603841856812; Tue, 27 Oct 2020 16:37:36 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:37:28 -0700
Message-Id: <20201027233733.1484855-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 0/5] Add a dirty logging performance test
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently KVM lacks a simple, userspace agnostic, performance benchmark for
dirty logging. Such a benchmark will be beneficial for ensuring that dirty
logging performance does not regress, and to give a common baseline for
validating performance improvements. The dirty log perf test introduced in
this series builds on aspects of the existing demand paging perf test and
provides time-based performance metrics for enabling and disabling dirty
logging, getting the dirty log, and dirtying memory.

While the test currently only has a build target for x86, I expect it will
work on, or be easily modified to support other architectures.

Ben Gardon (5):
  KVM: selftests: Factor code out of demand_paging_test
  KVM: selftests: Remove address rounding in guest code
  KVM: selftests: Simplify demand_paging_test with timespec_diff_now
  KVM: selftests: Add wrfract to common guest code
  KVM: selftests: Introduce the dirty log perf test

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/demand_paging_test.c        | 230 ++---------
 .../selftests/kvm/dirty_log_perf_test.c       | 382 ++++++++++++++++++
 .../selftests/kvm/include/perf_test_util.h    | 192 +++++++++
 .../testing/selftests/kvm/include/test_util.h |   2 +
 tools/testing/selftests/kvm/lib/test_util.c   |  22 +-
 7 files changed, 635 insertions(+), 195 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/dirty_log_perf_test.c
 create mode 100644 tools/testing/selftests/kvm/include/perf_test_util.h

-- 
2.29.0.rc2.309.g374f81d7ae-goog

