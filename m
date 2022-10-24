Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E623460A1F1
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiJXLhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiJXLhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:21 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC831BE95;
        Mon, 24 Oct 2022 04:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611430; x=1698147430;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wie0KRK07xUN7/EuZ7ywHo0LLhf937NSiICWnDJkrNM=;
  b=gtyqVztj/zHIP2P34ZpZ1mdvAT40eMqHm0BZMCsAZ4xlZ9MoKO3zUR5P
   H55HZft2GCSsbZfbYBExwXWLSBa3Fq5g631p2Ljjt4DNV5jeHJyTEpa1o
   i1sV0w1eyX7ds7BeAN2WBrgJWeb91WjNjc4NPJ3t+oef0E0D5zTY+SkOj
   yhfqMUOCwFoO2ameISHGRQm2qH9NW22u3X6Dvusotyxi/ryaH7gRjXL/r
   SEZkiLfXwXMxWvWytX+KKe+FzZMNH0mNqnw4UbpG6KmU87Rc6dRr07Jz/
   M0sNmBfapWwElLqQFNUcb6MrFfqd0s3s/cYkrqHSmIP5RmSLwlZIkInMH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="371612750"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="371612750"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:34:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784589"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784589"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:34:48 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 00/18] KVM selftests code consolidation and cleanup
Date:   Mon, 24 Oct 2022 19:34:27 +0800
Message-Id: <20221024113445.1022147-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series intends to improve kvm selftests with better code
consolidation using the helper functions to perform vcpu and thread
related operations.

In general, several aspects are improved:
1) The current users allocate an array of vcpu pointers to the vcpus that
   are added to a vm, and an array of vcpu threads. This isn't necessary
   as kvm_vm already maintains a list of added vcpus. This series changes
   the list of vcpus in the kvm_vm struct to a vcpu array for users to
   work with and removes each user's own allocation of such vcpu arrays.
   Aslo add the vcpu thread to the kvm_vcpu struct, so that users don't
   need to explicitly allocate a thread array to manage vcpu threads on
   their own.
2) Change the users to use the helper functions provided by this series
   with the following enhancements:
   - Many users working with pthread_create/join forgot to check if
     error on returning. The helper functions have handled thoses inside,
     so users don't need to handle them by themselves;
   - The vcpu threads created via the helper functions are named in
     "vcpu-##id" format. Naming the threads facilitates debugging,
     performance tuning, runtime pining etc;
   - helper functions named with "vm_vcpu_threads_" iterates over all the
     vcpus that have been added to the vm. Users don't need a explicit
     loop to go through the added cpus by themselves.
3) kvm_vcpu is used as the interface parameter to the vcpu thread's
   start routine, and the user specific data is made to be the private
   data in kvm_vcpu. This can simplify the user specific data structures,
   as kvm_vcpu has already included the required info for the thread, for
   example, in patch 13, the cpu_idx field from "struct vcpu_thread"
   is a duplicate of vcpu->id.

The changes have been tested on an SPR server. Patch 15 and 16 haven't
been tested due to the lack of an ARM environment currently.

Wei Wang (18):
  KVM: selftests/kvm_util: use array of pointers to maintain vcpus in
    kvm_vm
  KVM: selftests/kvm_util: use vm->vcpus[] when create vm with vcpus
  KVM: selftests/kvm_util: helper functions for vcpus and threads
  KVM: selftests/kvm_page_table_test: vcpu related code consolidation
  KVM: selftests/hardware_disable_test: code consolidation and cleanup
  KVM: selftests/dirty_log_test: vcpu related code consolidation
  KVM: selftests/max_guest_memory_test: vcpu related code consolidation
  KVM: selftests/set_memory_region_test: vcpu related code consolidation
  KVM: selftests/steal_time: vcpu related code consolidation and cleanup
  KVM: selftests/tsc_scaling_sync: vcpu related code consolidation
  KVM: selftest/xapic_ipi_test: vcpu related code consolidation
  KVM: selftests/rseq_test: name the migration thread and some cleanup
  KVM: selftests/perf_test_util: vcpu related code consolidation
  KVM: selftest/memslot_perf_test: vcpu related code consolidation
  KVM: selftests/vgic_init: vcpu related code consolidation
  KVM: selftest/arch_timer: vcpu related code consolidation
  KVM: selftests: remove the *vcpu[] input from __vm_create_with_vcpus
  KVM: selftests/kvm_create_max_vcpus: check KVM_MAX_VCPUS

 .../selftests/kvm/aarch64/arch_timer.c        |  42 ++--
 .../testing/selftests/kvm/aarch64/vgic_init.c |  35 ++-
 .../selftests/kvm/access_tracking_perf_test.c |  18 +-
 .../selftests/kvm/demand_paging_test.c        |   9 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  11 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  16 +-
 .../selftests/kvm/hardware_disable_test.c     |  56 ++---
 .../testing/selftests/kvm/include/kvm_util.h  |  24 ++
 .../selftests/kvm/include/kvm_util_base.h     |  12 +-
 .../selftests/kvm/include/perf_test_util.h    |   9 +-
 .../selftests/kvm/kvm_create_max_vcpus.c      |   7 +
 .../selftests/kvm/kvm_page_table_test.c       |  16 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 217 +++++++++++++++---
 .../selftests/kvm/lib/perf_test_util.c        |  68 ++----
 .../selftests/kvm/lib/x86_64/perf_test_util.c |  11 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   2 +-
 .../selftests/kvm/max_guest_memory_test.c     |  53 ++---
 .../kvm/memslot_modification_stress_test.c    |   9 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 137 +++++------
 tools/testing/selftests/kvm/rseq_test.c       |  10 +-
 .../selftests/kvm/set_memory_region_test.c    |  16 +-
 tools/testing/selftests/kvm/steal_time.c      |  15 +-
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  25 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |  54 ++---
 24 files changed, 476 insertions(+), 396 deletions(-)

-- 
2.27.0

