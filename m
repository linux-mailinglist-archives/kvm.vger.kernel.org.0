Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4001D45D2AD
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353010AbhKYCBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346893AbhKYB7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:01 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D06EC061370
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:01 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id i26-20020aa7909a000000b004a4c417bfa8so2509700pfa.23
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=n6VrhSmIgMVGXqXPUcuE2muiMxOU1LDCiBFBeGztrXs=;
        b=Nz5BRBPEaJwXA+G3x+HKVtaLGr4kqn8Zx1lQ6txrvIAi1rgYmwWrGRk+G3EjTyLxib
         ECxbsCOlz4Y5LmqY5irzjKVudQyVHWQ6bESjbro+xLzrM2Xv57uUKRxNSQS8QvCK1fHM
         tX5rlqe1ycOQ6pD4wCQXsffXcoUFq30hyqQ/rDfP86RDpmq11p/fELgViTzv2dxBre1C
         fmRjxX7AGngEpwvAt5kzMw+WySl7WGLDS9K3KqSuHoAvvAQgZmrjcR/2Ex+rB/hTXNr4
         XigG4JUOLkahHiV5cNUnBZU3n71CDeHQHDVhd5g5boQjcMOiOUrd/FekJQIUnnId49i2
         2zBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=n6VrhSmIgMVGXqXPUcuE2muiMxOU1LDCiBFBeGztrXs=;
        b=0hmNS22gD5VF6uzQdKT/Vk+VKNXQeY5AUqnAtpVjFsD+AxGTKN+Fb2hsMAQATK6NTI
         yX6h3fA67DSb+NVbqsehGevJQ2D2ElIJ8kXHVRrNUVXoIUxt6b7/DJHKOmAYCNqnU9Dx
         3pvVbfT0QY+29qjTxIpKhqBWxenMF94UEolLNJProsKTmAlUUdU7YLYQGkuCY6Amku8Q
         WEDqs80jXf4/mGy0VNVPWe7mKisk5aDLP43xM4XTyxGwpaOMa1+FgUQDQ/zwaz9fxoZK
         6Vxmspv2XImlHYu8x1t0xhKBqDawBHtjB7Psn1pqq27+aaXyHA5Xe48iRSZ3D/17NsH2
         PYOQ==
X-Gm-Message-State: AOAM5318P8SeTlOog9exvJB1haow/CNCF0IM1dH5yP+HZyr1FzB6iRQO
        JZ9XwyTzoXe72+cB9oPgDQAladzNBMU=
X-Google-Smtp-Source: ABdhPJwCTiaJO8DXeWNMyVCDbampr7NaCmuvbOHNBWKXmlZ/OZ1gJ7dLK4L+s8p0O4ZNRbKukBDMO/lLWLw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8302:b0:143:6e5f:a4a0 with SMTP id
 bd2-20020a170902830200b001436e5fa4a0mr24796827plb.20.1637803741047; Wed, 24
 Nov 2021 17:29:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:18 +0000
Message-Id: <20211125012857.508243-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 00/39] x86/access: nVMX: Big overhaul
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This started out as a very simple test (patch 39/39) to expose a KVM bug
where KVM doesn't sync a shadow MMU on a vmcs12->vpid change.  Except the
test didn't fail.  And it turns out, completely removing INVLPG from the
base access test doesn't fail when using shadow paging either.

The underlying problem in both cases is that the access test is flat out
stupid when it comes to handling page tables.  Instead of allocating page
tables once and manipulating them on each iteration, it "allocates" a new
paging structure when necessary on every. single. iteration.  In addition
to being incredibly inefficient (allocation also zeros the entire 4kb page,
so the test zeros absurd amounts of memory), writing upper level PTEs on
every iteration triggers write-protection mechanisms in KVM.  In effect,
KVM ends up synchronizing the relevant SPTEs on every iteration, which
again is ridiculously slow and makes it all but impossible to actually
test that KVM handles other TLB invalidation scenarios.

Trying to solve that mess by pre-allocating the page tables exposed a
whole pile of 5-level paging issues.  I'd say the test's 5-level support
is held together by duct tape, but I've fixed many things with duct tape
that are far less fragile.

The second half of this series is cleanups in the nVMX code to prepare
for adding the (INV)VPID variants.  Not directly related to the access
tests, but it annoyed me to no end that simply checking if INVVPID is
supported was non-trivial.

Sean Christopherson (39):
  x86/access: Add proper defines for hardcoded addresses
  x86/access: Cache CR3 to improve performance
  x86/access:  Use do-while loop for what is obviously a do-while loop
  x86/access: Stop pretending the test is SMP friendly
  x86/access: Refactor so called "page table pool" logic
  x86/access: Stash root page table level in test environment
  x86/access: Hoist page table allocator helpers above "init" helper
  x86/access: Rename variables in page table walkers
  x86/access: Abort if page table insertion hits an unexpected level
  x86/access: Make SMEP place nice with 5-level paging
  x86/access: Use upper half of virtual address space
  x86/access: Print the index when dumping PTEs
  x86/access: Pre-allocate all page tables at (sub)test init
  x86/access: Don't write page tables if desired PTE is same as current
    PTE
  x86/access: Preserve A/D bits when writing paging structure entries
  x86/access: Make toggling of PRESENT bit a "higher order" action
  x86/access: Manually override PMD in effective permissions sub-test
  x86/access: Remove manual override of PUD/PMD in prefetch sub-test
  x86/access: Remove PMD/PT target overrides
  x86/access: Remove timeout overrides now that performance doesn't suck
  nVMX: Skip EPT tests if INVEPT(SINGLE_CONTEXT) is unsupported
  nVMX: Hoist assert macros to the top of vmx.h
  nVMX: Add a non-reporting assertion macro
  nVMX: Assert success in unchecked INVEPT/INVVPID helpers
  nVMX: Drop less-than-useless ept_sync() wrapper
  nVMX: Move EPT capability check helpers to vmx.h
  nVMX: Drop unused and useless vpid_sync() helper
  nVMX: Remove "v1" version of INVVPID test
  nVMX: Add helper to check if INVVPID type is supported
  nVMX: Add helper to check if INVVPID is supported
  nVMX: Add helper to get first supported INVVPID type
  nVMX: Use helper to check for EPT A/D support
  nVMX: Add helpers to check for 4/5-level EPT support
  nVMX: Fix name of macro defining EPT execute only capability
  nVMX: Add helper to check if a memtype is supported for EPT structures
  nVMX: Get rid of horribly named "ctrl" boolean in test_ept_eptp()
  nVMX: Rename awful "ctrl" booleans to "is_ctrl_valid"
  nVMX: Add helper to check if VPID is supported
  x86/access: nVMX: Add "access" test variants to invalidate via
    (INV)VPID

 x86/access.c      | 391 ++++++++++++++++++++++++++++------------------
 x86/unittests.cfg |  10 +-
 x86/vmx.c         |  71 +--------
 x86/vmx.h         | 229 ++++++++++++++++++---------
 x86/vmx_tests.c   | 327 +++++++++++++++++---------------------
 5 files changed, 543 insertions(+), 485 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

