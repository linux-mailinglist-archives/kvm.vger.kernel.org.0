Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FEA1A4C97
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgDJXRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:20811 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJXRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:09 -0400
IronPort-SDR: ahf9yIAgh/ID6BGvLPmenEdIkx/8CIib5Jtcm+PHcI/7Tw/JitCHla3DvKUe8fluB3BD0G7t4v
 0aMJVRHmHt/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:09 -0700
IronPort-SDR: Qgfe9naeb34lG70i2WpvN2GvpcCtEKlhfeoLFGPZ46o+IWaseikUsxvwSz1infoc5k/gX8XofK
 2fw/jbzN1JXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542213"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH 00/10] KVM: selftests: Add KVM_SET_MEMORY_REGION tests
Date:   Fri, 10 Apr 2020 16:16:57 -0700
Message-Id: <20200410231707.7128-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v2-ish of my series to add a "delete" testcase[1], and v5.1 of
Wainer's series to add a "max" testcase[2].

I've only tested on x86_64.  I fudged compile testing on !x86_64 by
inverting the ifdefs, e.g. to squish unused var warnings, but by no means
is the code actually tested on other architectures.

I kept Andrew's review for the "max" test.  Other than the 1MB->2MB
change (see below), it was basically a straight copy-paste of code.

v1->v2 of delete:
  - Drop patch to expose primary memslot. [Peter]
  - Add explicit synchronization to MOVE and DELETE tests. [Peter]
  - Use list.h instead of open coding linked lists. [Peter]
  - Clean up the code and separate the testcases into separate functions.
  - Expand GUEST_ASSERT() to allow passing a value back to the host for
    printing.
  - Move to common KVM, with ifdefs to hide the x86_64-only stuff (which
    is a lot at this point).
  - Do KVM_SET_NR_MMU_PAGES in the "zero" testcase to get less obscure
    behavior for KVM_RUN. [Christian]

v5.1 of max:
  - Fix a whitespace issue in vm_get_fd(). [checkpatch]
  - Move the code to set_memory_region_test.  The only _intended_
    functional change is to create 2MB regions instead of 1MB regions.
    The only motivation for doing so was to reuse an existing define in
    set_memory_region_test.

[1] https://lkml.kernel.org/r/20200320205546.2396-1-sean.j.christopherson@intel.com
[2] https://lkml.kernel.org/r/20200409220905.26573-1-wainersm@redhat.com

Sean Christopherson (8):
  KVM: selftests: Take vcpu pointer instead of id in vm_vcpu_rm()
  KVM: selftests: Use kernel's list instead of homebrewed replacement
  KVM: selftests: Add util to delete memory region
  KVM: selftests: Add GUEST_ASSERT variants to pass values to host
  KVM: sefltests: Add explicit synchronization to move mem region test
  KVM: selftests: Add "delete" testcase to set_memory_region_test
  KVM: selftests: Add "zero" testcase to set_memory_region_test
  KVM: selftests: Make set_memory_region_test common to all
    architectures

Wainer dos Santos Moschetta (2):
  selftests: kvm: Add vm_get_fd() in kvm_util
  selftests: kvm: Add testcase for creating max number of memslots

 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   4 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  28 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 154 +++----
 .../selftests/kvm/lib/kvm_util_internal.h     |   8 +-
 .../selftests/kvm/lib/s390x/processor.c       |   5 +-
 .../selftests/kvm/set_memory_region_test.c    | 403 ++++++++++++++++++
 .../kvm/x86_64/set_memory_region_test.c       | 141 ------
 8 files changed, 520 insertions(+), 225 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/set_memory_region_test.c
 delete mode 100644 tools/testing/selftests/kvm/x86_64/set_memory_region_test.c

-- 
2.26.0

