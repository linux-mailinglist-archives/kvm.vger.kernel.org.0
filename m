Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FD8C0964
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfI0QSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:18:41 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:42470 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727472AbfI0QSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:18:41 -0400
Received: by mail-vk1-f201.google.com with SMTP id 18so2721764vkm.9
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=flMQx0RQ+tn1L0OZWy96vlecDFYT8pwNVqw/lok2bBY=;
        b=Ar9jvV5xbA8qUlUV3OgckW5CkZ9INmnhnI96YfE1/pFNlm5HZsEljt+QQVsrxnO3Gj
         XD1JMtkUA5ixzhD0C6yhT/hf3TwzBIblDAaOKkGYhmI6nC1sK3xNSVC7CNXDflGHKr+l
         VsD43N8JrjQw11Ev6iDSbJ9/LISWjc3S//kDUW5Au9ju1PxNBO1IQbSBYGWMXGUnwdRk
         JnC4rp7aVpgyGN8B+f0E+5sjCwllidxf0s/pSlbaHmvCn1iLPFgB7p0kNxY2kI+q/aH+
         KeVFAKFnMdWf5bLWG5UEyc7c4/9+IlX8NupoKoBf7vfOJ3IVhuN3KQm5UPBCVvo55hdJ
         chHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=flMQx0RQ+tn1L0OZWy96vlecDFYT8pwNVqw/lok2bBY=;
        b=QBk1De+neBM44JDW8dJBkgj4d51R52aSrFCiyt6odwjK1E/TNVr4FCEoBGeKYjZhZt
         3FegSrAKWX48PqYQ2iDTcKwTzeOggTNB/HlhYWpSRYSY3WUKjkd49DlyVwjdlXBvTdab
         qtRQq88bEcr0Xm4tFNAU6GbLPRs3ncFsFxyl9afAHdxmozp+M71+iJogUZQp1ik7K99g
         asErJtzNozhSN3KPFsG8Vj/3dKAiREnGlxJ9aHjfwL9Qg23LtzVGdE7oXiDcuVvEeZ15
         y+xEp2+Zx5kE6TNzdbETs3VOdWtA05AcKhQ0o3RitKad66XdIHpYdckVfuV3ptELtyN9
         bODw==
X-Gm-Message-State: APjAAAWariyEjMyZfvqiQU2la+iSgJWOvUdZOu7AGVUsUxwHbjQH4Zgi
        /5uIX1qymJaCg25LYRooVUhQuQstE43eOP5tVpv08t2X0hdI5bIzI4E56bn1Cq63yLd1+0I9QcH
        GERO5xSeatNfO7bE2dMSoTg9grdz3PyF+0buMJ1Al+GnP32ccptSuVviaWKXF
X-Google-Smtp-Source: APXvYqxokp5DF4qLKfyp3zZnmBXiq2/CPP9dLbJ1WOoMDDMLgAqqKqO7z3xRx+ZjRpWsHGDd0hiIS9P0JfZP
X-Received: by 2002:ac5:cd4a:: with SMTP id n10mr2362832vkm.82.1569601119998;
 Fri, 27 Sep 2019 09:18:39 -0700 (PDT)
Date:   Fri, 27 Sep 2019 09:18:28 -0700
Message-Id: <20190927161836.57978-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH 0/9] Create a userfaultfd demand paging test
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When handling page faults for many vCPUs during demand paging, KVM's MMU
lock becomes highly contended. This series creates a test with a naive
userfaultfd based demand paging implementation to demonstrate that
contention. This test serves both as a functional test of userfaultfd
and a microbenchmark of demand paging performance with a variable number
of vCPUs and memory per vCPU.

The test creates N userfaultfd threads, N vCPUs, and a region of memory
with M pages per vCPU. The N userfaultfd polling threads are each set up
to serve faults on a region of memory corresponding to one of the vCPUs.
Each of the vCPUs is then started, and touches each page of its disjoint
memory region, sequentially. In response to faults, the userfaultfd
threads copy a static buffer into the guest's memory. This creates a
worst case for MMU lock contention as we have removed most of the
contention between the userfaultfd threads and there is no time required
to fetch the contents of guest memory.

This test was run successfully on Intel Haswell, Broadwell, and
Cascadelake hosts with a variety of vCPU counts and memory sizes.

This test was adapted from the dirty_log_test.

The series can also be viewed in Gerrit here:
https://linux-review.googlesource.com/c/virt/kvm/kvm/+/1464
(Thanks to Dmitry Vyukov <dvyukov@google.com> for setting up the Gerrit
instance)

Ben Gardon (9):
  KVM: selftests: Create a demand paging test
  KVM: selftests: Add demand paging content to the demand paging test
  KVM: selftests: Add memory size parameter to the demand paging test
  KVM: selftests: Pass args to vCPU instead of using globals
  KVM: selftests: Support multiple vCPUs in demand paging test
  KVM: selftests: Time guest demand paging
  KVM: selftests: Add parameter to _vm_create for memslot 0 base paddr
  KVM: selftests: Support large VMs in demand paging test
  Add static flag

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   4 +-
 .../selftests/kvm/demand_paging_test.c        | 610 ++++++++++++++++++
 tools/testing/selftests/kvm/dirty_log_test.c  |   2 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   7 +-
 6 files changed, 621 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/demand_paging_test.c

-- 
2.23.0.444.g18eeb5a265-goog

