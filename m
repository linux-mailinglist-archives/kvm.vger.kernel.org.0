Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE3018D9DA
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgCTUzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:55:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:32133 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTUzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:55:47 -0400
IronPort-SDR: Mrtax5r6S7je/QHfg4sI2au75xzgLMcQ/DAQsUZy12gjghMc7G+ERsPFcTQ1PdU++ln95lU7Uf
 gZNnPWKTVK8A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 13:55:47 -0700
IronPort-SDR: Wokbp1xezwQOg04lztcVSu+PjFiTzDPfBLqx5B6LgK3OObVC7Tz3rYthmd8sfETKC33SiH7a3o
 +AAl+xhNCOJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="280543314"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 20 Mar 2020 13:55:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 0/7] KVM: Fix memslot use-after-free bug
Date:   Fri, 20 Mar 2020 13:55:39 -0700
Message-Id: <20200320205546.2396-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a bug introduced by dynamic memslot allocation where the LRU slot can
become invalid and lead to a out-of-bounds/use-after-free scenario.

The patch is different that what Qian has already tested, but I was able
to reproduce the bad behavior by enhancing the set memory region selftest,
i.e. I'm relatively confident the bug is fixed.

Patches 2-6 are a variety of selftest cleanup, with the aforementioned
set memory region enhancement coming in patch 7.

Note, I couldn't get the selftest to fail outright or with KASAN, but was
able to hit a WARN_ON an invalid slot 100% of the time (without the fix,
obviously).

Regarding s390, I played around a bit with merging gfn_to_memslot_approx()
into search_memslots().  Code wise it's trivial since they're basically
identical, but doing so increases the code footprint of search_memslots()
on x86 by 30 bytes, so I ended up abandoning the effort.

Sean Christopherson (7):
  KVM: Fix out of range accesses to memslots
  KVM: selftests: Fix cosmetic copy-paste error in vm_mem_region_move()
  KVM: selftests: Take vcpu pointer instead of id in vm_vcpu_rm()
  KVM: selftests: Add helpers to consolidate open coded list operations
  KVM: selftests: Add util to delete memory region
  KVM: selftests: Expose the primary memslot number to tests
  KVM: selftests: Add "delete" testcase to set_memory_region_test

 arch/s390/kvm/kvm-s390.c                      |   3 +
 include/linux/kvm_host.h                      |   3 +
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 139 ++++++++++--------
 .../kvm/x86_64/set_memory_region_test.c       | 122 +++++++++++++--
 virt/kvm/kvm_main.c                           |   3 +
 6 files changed, 201 insertions(+), 72 deletions(-)

-- 
2.24.1

