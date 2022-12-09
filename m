Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AA3647BA0
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 02:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLIBx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 20:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLIBx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 20:53:27 -0500
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A33694191
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 17:53:25 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool + page_fault_test
Date:   Fri,  9 Dec 2022 01:52:59 +0000
Message-Id: <20221209015307.1781352-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The combination of the pool-based ucall implementation + page_fault_test
resulted in some 'fun' bugs. As has always been the case, KVM selftests
is a house of cards.

Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
be squashed into Paolo's merge resolution, if desired.

Tested on Ampere Altra and a Skylake box, since there was a decent
amount of munging in architecture-generic code.

v1 -> v2:
 - Collect R-b from Sean (thanks!)
 - Use a common routine for split and contiguous VA spaces, with
   commentary on why arm64 is different since we all get to look at it
   now. (Sean)
 - Don't identity map the ucall MMIO hole
 - Fix an off-by-one issue in the accounting of virtual memory,
   discovered in fighting with #2
 - Fix an infinite loop in ucall_alloc(), discovered fighting with the
   ucall_init() v. kvm_vm_elf_load() ordering issue

Mark Brown (1):
  KVM: selftests: Fix build due to ucall_uninit() removal

Oliver Upton (6):
  KVM: selftests: Setup ucall after loading program into guest memory
  KVM: selftests: Mark correct page as mapped in virt_map()
  KVM: selftests: Correctly initialize the VA space for TTBR0_EL1
  KVM: arm64: selftests: Don't identity map the ucall MMIO hole
  KVM: selftests: Allocate ucall pool from MEM_REGION_DATA
  KVM: selftests: Avoid infinite loop if ucall_alloc() fails

 .../selftests/kvm/aarch64/page_fault_test.c   |  9 +++-
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../testing/selftests/kvm/lib/aarch64/ucall.c |  6 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 53 ++++++++++++++++---
 .../testing/selftests/kvm/lib/ucall_common.c  | 14 +++--
 5 files changed, 68 insertions(+), 15 deletions(-)


base-commit: 89b2395859651113375101bb07cd6340b1ba3637
-- 
2.39.0.rc1.256.g54fd8350bd-goog

