Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1380250139E
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 17:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244752AbiDNNfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 09:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244522AbiDNN1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 09:27:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90667A0BD8
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 06:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649942421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kd6yprk4VlEg5xosbW/30KWUxD+GYa+hGTxr9KOLLms=;
        b=SiH4I/i/URHLsBn4k20JLXHenJ+MAmWfJCEP6RSzX9ihl84/sjGn0vfFhuHHZDh/uHEVw8
        J2jT+IbiFdMxtTB/ul8Xydg9en46SKNEAclIyKq+8LM1rN002l8rQYOf7y027gQAFbN8wH
        Xg/qIQGwVi/VmGy5N6j9HqQs5Fi1i8I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-EXkFvnH2PfCglnShalZ-Ew-1; Thu, 14 Apr 2022 09:20:17 -0400
X-MC-Unique: EXkFvnH2PfCglnShalZ-Ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FFA9805A30;
        Thu, 14 Apr 2022 13:20:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F6957C28;
        Thu, 14 Apr 2022 13:20:14 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/34] KVM: x86: hyper-v: Fine-grained TLB flush + L2 TLB flush feature
Date:   Thu, 14 Apr 2022 15:19:39 +0200
Message-Id: <20220414132013.1588929-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
To address Sean's review comments:
- s,Direct,L2, everywhere.
- s,tlbflush,tlb_flush, everywhere.
- "KVM: x86: hyper-v: Add helper to read hypercall data for array" patch
  added.
- "x86/hyperv: Introduce HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK
  constants" patch added.
- "KVM: x86: hyper-v: Use HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK
  instead of raw '64'" patch added.
- Other code improvements.

Other changes:
- Rebase to the latest kvm/queue.
- "KVM: selftests: add hyperv_svm_test to .gitignore" patch dropped
 (already fixed).
- "KVM: x86: Rename 'enable_direct_tlbflush' to 'enable_l2_tlb_flush'" 
 patch added.
- Fix a race in the newly introduced Hyper-V IPI test.

Original description:

Currently, KVM handles HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} requests
by flushing the whole VPID and this is sub-optimal. This series introduces
the required mechanism to make handling of these requests more 
fine-grained by flushing individual GVAs only (when requested). On this
foundation, "Direct Virtual Flush" Hyper-V feature is implemented. The 
feature allows L0 to handle Hyper-V TLB flush hypercalls directly at
L0 without the need to reflect the exit to L1. This has at least two
benefits: reflecting vmexit and the consequent vmenter are avoided + L0
has precise information whether the target vCPU is actually running (and
thus requires a kick).

Sean Christopherson (1):
  KVM: x86: hyper-v: Add helper to read hypercall data for array

Vitaly Kuznetsov (33):
  KVM: x86: hyper-v: Resurrect dedicated KVM_REQ_HV_TLB_FLUSH flag
  KVM: x86: hyper-v: Introduce TLB flush ring
  KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls
    gently
  KVM: x86: hyper-v: Expose support for extended gva ranges for flush
    hypercalls
  KVM: x86: Prepare kvm_hv_flush_tlb() to handle L2's GPAs
  x86/hyperv: Introduce
    HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK constants
  KVM: x86: hyper-v: Use
    HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK instead of raw
    '64'
  KVM: x86: hyper-v: Don't use sparse_set_to_vcpu_mask() in
    kvm_hv_send_ipi()
  KVM: x86: hyper-v: Create a separate ring for L2 TLB flush
  KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv'
    instead of on-stack 'sparse_banks'
  KVM: nVMX: Keep track of hv_vm_id/hv_vp_id when eVMCS is in use
  KVM: nSVM: Keep track of Hyper-V hv_vm_id/hv_vp_id
  KVM: x86: Introduce .post_hv_l2_tlb_flush() nested hook
  KVM: x86: hyper-v: Introduce kvm_hv_is_tlb_flush_hcall()
  KVM: x86: hyper-v: L2 TLB flush
  KVM: x86: hyper-v: Introduce fast kvm_hv_l2_tlb_flush_exposed() check
  x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
  KVM: nVMX: hyper-v: Enable L2 TLB flush
  KVM: x86: KVM_REQ_TLB_FLUSH_CURRENT is a superset of
    KVM_REQ_HV_TLB_FLUSH too
  KVM: nSVM: hyper-v: Enable L2 TLB flush
  KVM: x86: Expose Hyper-V L2 TLB flush feature
  KVM: selftests: Better XMM read/write helpers
  KVM: selftests: Hyper-V PV IPI selftest
  KVM: selftests: Make it possible to replace PTEs with __virt_pg_map()
  KVM: selftests: Hyper-V PV TLB flush selftest
  KVM: selftests: Sync 'struct hv_enlightened_vmcs' definition with
    hyperv-tlfs.h
  KVM: selftests: nVMX: Allocate Hyper-V partition assist page
  KVM: selftests: nSVM: Allocate Hyper-V partition assist and VP assist
    pages
  KVM: selftests: Sync 'struct hv_vp_assist_page' definition with
    hyperv-tlfs.h
  KVM: selftests: evmcs_test: Introduce L2 TLB flush test
  KVM: selftests: Move Hyper-V VP assist page enablement out of evmcs.h
  KVM: selftests: hyperv_svm_test: Introduce L2 TLB flush test
  KVM: x86: Rename 'enable_direct_tlbflush' to 'enable_l2_tlb_flush'

 arch/x86/include/asm/hyperv-tlfs.h            |   6 +-
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  37 +-
 arch/x86/kvm/Makefile                         |   3 +-
 arch/x86/kvm/hyperv.c                         | 376 ++++++++--
 arch/x86/kvm/hyperv.h                         |  48 ++
 arch/x86/kvm/svm/hyperv.c                     |  18 +
 arch/x86/kvm/svm/hyperv.h                     |  37 +
 arch/x86/kvm/svm/nested.c                     |  25 +-
 arch/x86/kvm/svm/svm_onhyperv.c               |   2 +-
 arch/x86/kvm/svm/svm_onhyperv.h               |   6 +-
 arch/x86/kvm/trace.h                          |  21 +-
 arch/x86/kvm/vmx/evmcs.c                      |  24 +
 arch/x86/kvm/vmx/evmcs.h                      |  11 +
 arch/x86/kvm/vmx/nested.c                     |  32 +
 arch/x86/kvm/vmx/vmx.c                        |   6 +-
 arch/x86/kvm/x86.c                            |  20 +-
 arch/x86/kvm/x86.h                            |   1 +
 include/asm-generic/hyperv-tlfs.h             |   5 +
 include/asm-generic/mshyperv.h                |  11 +-
 tools/testing/selftests/kvm/.gitignore        |   2 +
 tools/testing/selftests/kvm/Makefile          |   4 +-
 .../selftests/kvm/include/x86_64/evmcs.h      |  40 +-
 .../selftests/kvm/include/x86_64/hyperv.h     |  35 +
 .../selftests/kvm/include/x86_64/processor.h  |  72 +-
 .../selftests/kvm/include/x86_64/svm_util.h   |  10 +
 .../selftests/kvm/include/x86_64/vmx.h        |   4 +
 .../testing/selftests/kvm/lib/x86_64/hyperv.c |  21 +
 .../selftests/kvm/lib/x86_64/processor.c      |   6 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  10 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   7 +
 .../selftests/kvm/max_guest_memory_test.c     |   2 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  53 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |   5 +-
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c | 374 ++++++++++
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  60 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   | 647 ++++++++++++++++++
 .../selftests/kvm/x86_64/mmu_role_test.c      |   2 +-
 38 files changed, 1883 insertions(+), 162 deletions(-)
 create mode 100644 arch/x86/kvm/svm/hyperv.c
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/hyperv.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c

-- 
2.35.1

