Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814B43B0F18
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFVVDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFVVDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:07 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1236C061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:00:50 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id m11-20020ad45dcb0000b029027aeaa8ae9dso471523qvh.12
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=f02BNxyhGTF1v6wZfFhEqECHiYDL58GUK6jABuHFgS4=;
        b=fx78gtbKHeuWTkn9F82Hna6o6HfLWGgqcIwMXJpZD8S4/BdLQ9bNDdq7HBtvLmWIyE
         m6lBEkseR0kojiQbJIQ9TzdCdied9n0nmwO/+JeBpMwOcCAcLYoqJWZKnoUby+YNqTCi
         GPATBB5g/ZkqKpWx//L7cTOlg4lbV0+uSGJ6eGqNNs9p4idHI903yaU2r9rueCZsRKdG
         pdIDlJHw7sCBX8KRmIwpEXbqQpgkiZwMqUxpMey0oqaJ3MEuDL6M1LhBQyHUjqrgCqFR
         pZj4TVwCFO2y+NYnDDU1mGFvtRI89qOOv6EZ20oewSyEBdNFQRprNZGGmyxZU1Yp7n9i
         jYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=f02BNxyhGTF1v6wZfFhEqECHiYDL58GUK6jABuHFgS4=;
        b=X4UxN7teMDM+MDXQ5LgC+2NgzZ0S/YfVBfBv4bvPyxrG7sqaiz8rlPOesgROn7NV+r
         ltKbfQYtSC9iEFr4YdWkI8YJZUxRbr/al3LcEXW/IKpRufEJCVI5j43EPLNS3HJmmtw5
         Q8M0Eq+cuzYBJkwgonSVYkE30urljG5rlmjlUc5lDM0Dj8x7tRGvufhOWw4Yf84QwOLL
         GYXagSxCxuWtaJbeNXNo1K7eARDXrkg79xpM5WA/HW61ETkgQWlzJekFao9bwanHtRc1
         CSQyvg6dah2fy2iaH5GPFb51npzIvVW8tP8gXhlfBeEvd++9MxcMnA0rnTLPrgdczGJ9
         Zb2g==
X-Gm-Message-State: AOAM533gMuv8Ok5oHnzcdzIb5Vba8skLtttIG5FJUD9VL1XYSoH/2G1C
        B2PmNcZbzGzQcGAuVgToGEN8SCePQKE=
X-Google-Smtp-Source: ABdhPJznehS39G0QZt7H0DXB3+X7maT3yZndpXuSx31AJBSd9g+rjJNMvDjt591nwmqjzclu9vE5E2uG+/o=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a0c:cc91:: with SMTP id f17mr744311qvl.61.1624395649798;
 Tue, 22 Jun 2021 14:00:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:35 -0700
Message-Id: <20210622210047.3691840-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 00/12] nSVM: NPT improvements and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first chunk of this series (everything up to the lib/vmalloc patch)
are cleanups and bug fixes for existing nSVM tests that I collected on
my first attempt at the new NPT test.  I originally wanted to piggyback
the existing "v1" nSVM tests and implemented the fixes/cleanups, but that
approach didn't go so well because of the v1 infrastructure limitations.

The common lib/vmalloc changes are to allow arch code to pass arbitrary
data to its setup_mmu() function.  x86-64 uses the param to avoid marking
PTEs a USER so that tests can enable SMEP (#PF if supervisor mode fetches
from a USER PTE) without exploding or having to duplicate all page tables.

The "new" test targets nested NPT by running L1 and L2 with different
EFER.NX and CR4.SMEP settings to verify that KVM uses the correct MMU
settings when injecting page faults.

Sean Christopherson (12):
  nSVM: Provide expected and actual exit codes on VMRUN test failure
  nSVM: Replace open coded NX manipulation with appropriate macros
  nSVM: Reset the VMCB before every v1 test
  nSVM: Explicitly save/update/restore EFER.NX for NPT NX test
  nSVM: Remove NPT reserved bits tests (new one on the way)
  nSVM: Stop forcing EFER.NX=1 for all tests
  nSVM: Remove a superfluous modification of guest EFER.NX in NPT NX
    test
  nSVM: Clear guest's EFER.NX in NPT NX test
  lib/vmalloc: Let arch code pass a value to its setup_mmu() helper
  x86: Let tests omit PT_USER_MASK when configuring virtual memory
  x86: Add GBPAGES CPUID macro, clean up CPUID comments
  nSVM: Add test for NPT reserved bit and #NPF error code behavior

 lib/arm/mmu.c       |   2 +-
 lib/s390x/mmu.c     |   3 +-
 lib/vmalloc.c       |   9 +-
 lib/vmalloc.h       |   4 +-
 lib/x86/processor.h |  15 +--
 lib/x86/vm.c        |  15 ++-
 s390x/uv-host.c     |   2 +-
 x86/svm.c           |  10 +-
 x86/svm_tests.c     | 220 +++++++++++++++++++++++++++++++-------------
 9 files changed, 196 insertions(+), 84 deletions(-)

-- 
2.32.0.288.g62a8d224e6-goog

