Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99E92AF087
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 13:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgKKM0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 07:26:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbgKKM0r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 07:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605097605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5hWfLU3ylTgBjCk3h+FCJUcXrzNoR1rBAbf42gojaGw=;
        b=IMch+M9Zq0hI8w6/T1bnsqEOTlo9/UfQMf1H8fgTQE4CdnVVBKC140bk5KBuOtHuOpRj9P
        A7egaR4FFBBgjmZEddgE9jPPG98GIc9DfpNN1nizy05VMDwxXLc4mrLd1jcMO6lxcIi01c
        AAMsZRlYAbSXTeJrrnpgeoeLhtJ4F5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-ebeZXl20NE2TTCjQXI9s6w-1; Wed, 11 Nov 2020 07:26:43 -0500
X-MC-Unique: ebeZXl20NE2TTCjQXI9s6w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2E5B879523;
        Wed, 11 Nov 2020 12:26:42 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3D6A10013BD;
        Wed, 11 Nov 2020 12:26:37 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v2 00/11] KVM: selftests: Cleanups, take 2
Date:   Wed, 11 Nov 2020 13:26:25 +0100
Message-Id: <20201111122636.73346-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series attempts to clean up demand_paging_test, dirty_log_perf_test,
and dirty_log_test by factoring out common code, creating some new API
along the way. It also splits include/perf_test_util.h into a more
conventional header and source pair.

I've tested on x86 and AArch64 (one config each), but not s390x.

v2:
  - Use extra_mem instead of per-vcpu mem for the test mem in
    demand_paging_test and dirty_log_perf_test [Ben]

  - Couple more cleanups, like adding perf_test_destroy_vm()
    to balance create/destroy of a perf test vm [drew]

  - Added new patches [drew]:

    - Since dirty_log_perf_test works fine on AArch64,
      "KVM: selftests: Also build dirty_log_perf_test on AArch64"

    - More cleanup of redundant code,
      "KVM: selftests: x86: Set supported CPUIDs on default VM"

    - Keep test skipping consistent,
      "KVM: selftests: Make test skipping consistent"

I definitely want to get x86 people's review on "KVM: selftests: x86:
Set supported CPUIDs on default VM" to be sure it's OK to do that.

Thanks,
drew


Andrew Jones (11):
  KVM: selftests: Update .gitignore
  KVM: selftests: Remove deadcode
  KVM: selftests: Factor out guest mode code
  KVM: selftests: Make vm_create_default common
  KVM: selftests: Introduce vm_create_[default_]_with_vcpus
  KVM: selftests: dirty_log_test: Remove create_vm
  KVM: selftests: Use vm_create_with_vcpus in create_vm
  KVM: selftests: Implement perf_test_util more conventionally
  KVM: selftests: Also build dirty_log_perf_test on AArch64
  KVM: selftests: x86: Set supported CPUIDs on default VM
  KVM: selftests: Make test skipping consistent

 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/demand_paging_test.c        | 118 +++--------
 .../selftests/kvm/dirty_log_perf_test.c       | 183 ++++--------------
 tools/testing/selftests/kvm/dirty_log_test.c  | 182 +++++------------
 .../selftests/kvm/include/guest_modes.h       |  21 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  42 +++-
 .../selftests/kvm/include/perf_test_util.h    | 171 ++--------------
 .../selftests/kvm/lib/aarch64/processor.c     |  17 --
 tools/testing/selftests/kvm/lib/guest_modes.c |  70 +++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  67 ++++++-
 .../selftests/kvm/lib/perf_test_util.c        | 134 +++++++++++++
 .../selftests/kvm/lib/s390x/processor.c       |  22 ---
 .../selftests/kvm/lib/x86_64/processor.c      |  32 ---
 .../selftests/kvm/set_memory_region_test.c    |   2 -
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |   1 -
 .../testing/selftests/kvm/x86_64/debug_regs.c |   1 -
 .../testing/selftests/kvm/x86_64/evmcs_test.c |   2 -
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   4 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |   2 -
 .../testing/selftests/kvm/x86_64/state_test.c |   1 -
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |   1 -
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |   1 -
 .../selftests/kvm/x86_64/user_msr_test.c      |   7 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |   1 -
 .../kvm/x86_64/vmx_close_while_nested_test.c  |   1 -
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   1 -
 .../kvm/x86_64/vmx_preemption_timer_test.c    |  15 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c    |  21 ++
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |   1 -
 30 files changed, 499 insertions(+), 627 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
 create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
 create mode 100644 tools/testing/selftests/kvm/lib/perf_test_util.c

-- 
2.26.2

