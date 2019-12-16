Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03616121BF6
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 22:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfLPVjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 16:39:06 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:38755 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfLPVjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 16:39:05 -0500
Received: by mail-pg1-f201.google.com with SMTP id l13so5968782pgt.5
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 13:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=flMQx0RQ+tn1L0OZWy96vlecDFYT8pwNVqw/lok2bBY=;
        b=tNj7oz/OwoSNeC7zluPeALLNBPcWJXHClCBomAaTTJ3r1XoRHk4FzXlifGIQxkFHwr
         YyUiRjCh4I9ahZnOEgsvxBqjDsxM1kSxy/7UNJyu4T69g7p3dzMg6CzTOzSGAFXX/+Yq
         2aQeBvyGrS/w2jF4cwiKGr0dBjCSaj97giU1sSky3b3JJCv6rwsKPHYwSaeeWYauS7G2
         iSlKKO8bKmJxFWPLEmxj1PSSSe8kW4JVV5AmGyfbs6JIflu6e4EHrCeG+DRIVCC44dS7
         B1Kcbt1NsVz0gQx+6wyMRS3BAAlTsuwh3OQodCFgJvnK1535qy0qoZX2wE9esYJi1Yzr
         B//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=flMQx0RQ+tn1L0OZWy96vlecDFYT8pwNVqw/lok2bBY=;
        b=UVR2iALeRV6PBRAVpjePfdRD2rh1YQ/TIwg82aivDXDJyaG7yU15Z/vVZv9IOJT5Pq
         Ogl9WCS1zEf6eYMxb0RLryv8/dR5M5+TtdAsIIQiTb+8cndeuAeBlf8Vefse3+h9JEgU
         XWKvuoO9qPTpOuInb4+R1xSdulE5XWcV9/56tdA3ST/LWPChZohjv58O4+dMvda1JIoW
         jX9lQKqD0faRaldEChVjkifcL2Pez95rFS2nb4XK+wpRAenQ3EyJereqxKHImoEfyljU
         LWzTxJGCKKDZJZm0PakMhTHuOHFCyjTLGp5990zxIrmBUkBtc0OnyNu4HHOzyaHt8lG1
         Qg2w==
X-Gm-Message-State: APjAAAVQD2ordlfxFjNUHUAww0k/Puv5LKjCnRIrKg/q2NePyrQFniMu
        qfHb2xGiq6ecAg5alJSbQrEYYusZGt0w
X-Google-Smtp-Source: APXvYqyt7PiZ8I6H4u3XH7x8jvxymQ4VP2vS+iyUjYUqs1LQFO+Fm+X+YTzQ1i0lIBpLid8KhiK0ug3fKcWp
X-Received: by 2002:a65:6216:: with SMTP id d22mr20828964pgv.437.1576532345144;
 Mon, 16 Dec 2019 13:39:05 -0800 (PST)
Date:   Mon, 16 Dec 2019 13:38:53 -0800
Message-Id: <20191216213901.106941-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v3 0/8] Create a userfaultfd demand paging test
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
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

