Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0745F4305
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiJDMkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJDMkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:40:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6149417054
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664887204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BPloFAh+eWXn70rNMfxuuyHkmfcQh4KW/OIuUbXNtTE=;
        b=Fxx3iNvkNhzKGhQ9cfJOnKGQJBJEe2+vkzaQoI4qWvUBA5zSuGhDCluFeAfLGelL5S3D6q
        8ocvbgB2Mquyrr/47NzOJwSlxZ+uKOIGm7adq8UP+tJH1/jIELM/RL1edVOESQWmOC4tVC
        HN/C8lxDF1jrzW2Kqsbz3z5Run8hJqE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-Iji-AavRPLu2nMmBqz_OYw-1; Tue, 04 Oct 2022 08:40:01 -0400
X-MC-Unique: Iji-AavRPLu2nMmBqz_OYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF6A9299E759;
        Tue,  4 Oct 2022 12:40:00 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9141A7AE5;
        Tue,  4 Oct 2022 12:39:58 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 00/46] KVM: x86: hyper-v: Fine-grained TLB flush + L2 TLB flush features
Date:   Tue,  4 Oct 2022 14:39:10 +0200
Message-Id: <20221004123956.188909-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v10 (Sean):
- New patches added:
  - "x86/hyperv: Move VMCB enlightenment definitions to hyperv-tlfs.h"
  - "KVM: selftests: Move "struct hv_enlightenments" to x86_64/svm.h"
  - "KVM: SVM: Add a proper field for Hyper-V VMCB enlightenments"
  - 'x86/hyperv: KVM: Rename "hv_enlightenments" to "hv_vmcb_enlightenments"'
  - 'KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"'
  - "KVM: x86: Move clearing of TLB_FLUSH_CURRENT to kvm_vcpu_flush_tlb_all()"
  - "KVM: selftests: Drop helpers to read/write page table entries"
  - "KVM: x86: Make kvm_hv_get_assist_page() return 0/-errno"
- Removed patches:
  - "KVM: selftests: Export _vm_get_page_table_entry()"
- Main differences:
  - Move Hyper-V TLB flushing out of kvm_service_local_tlb_flush_requests().
    On SVM, Hyper-V TLB flush FIFO is emptied from svm_flush_tlb_current()
  - Don't disable IRQs in hv_tlb_flush_enqueue().
  - Don't call kvm_vcpu_flush_tlb_guest() from kvm_hv_vcpu_flush_tlb() but
    return -errno instead.
  - Avoid unneded flushes in !EPT/!NPT cases.
  - Optimize hv_is_vp_in_sparse_set().
  - Move TLFS definitions to asm/hyperv-tlfs.h.
  - Use u64 vals in Hyper-V PV TLB flush selftest + multiple smaler changes
  - Typos, indentation, renames, ...

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

Sean Christopherson (7):
  x86/hyperv: Move VMCB enlightenment definitions to hyperv-tlfs.h
  KVM: selftests: Move "struct hv_enlightenments" to x86_64/svm.h
  KVM: SVM: Add a proper field for Hyper-V VMCB enlightenments
  x86/hyperv: KVM: Rename "hv_enlightenments" to
    "hv_vmcb_enlightenments"
  KVM: x86: Move clearing of TLB_FLUSH_CURRENT to
    kvm_vcpu_flush_tlb_all()
  KVM: x86: hyper-v: Add helper to read hypercall data for array
  KVM: selftests: Drop helpers to read/write page table entries

Vitaly Kuznetsov (39):
  KVM: x86: Rename 'enable_direct_tlbflush' to 'enable_l2_tlb_flush'
  KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"
  KVM: x86: hyper-v: Resurrect dedicated KVM_REQ_HV_TLB_FLUSH flag
  KVM: x86: hyper-v: Introduce TLB flush fifo
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
  KVM: x86: hyper-v: Create a separate fifo for L2 TLB flush
  KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv'
    instead of on-stack 'sparse_banks'
  KVM: nVMX: Keep track of hv_vm_id/hv_vp_id when eVMCS is in use
  KVM: nSVM: Keep track of Hyper-V hv_vm_id/hv_vp_id
  KVM: x86: Introduce .hv_inject_synthetic_vmexit_post_tlb_flush()
    nested hook
  KVM: x86: hyper-v: Introduce kvm_hv_is_tlb_flush_hcall()
  KVM: x86: hyper-v: L2 TLB flush
  KVM: x86: hyper-v: Introduce fast guest_hv_cpuid_has_l2_tlb_flush()
    check
  KVM: nVMX: hyper-v: Cache VP assist page in 'struct kvm_vcpu_hv'
  KVM: nVMX: hyper-v: Enable L2 TLB flush
  KVM: x86: Make kvm_hv_get_assist_page() return 0/-errno
  KVM: nSVM: hyper-v: Enable L2 TLB flush
  KVM: x86: Expose Hyper-V L2 TLB flush feature
  KVM: selftests: Better XMM read/write helpers
  KVM: selftests: Move HYPERV_LINUX_OS_ID definition to a common header
  KVM: selftests: Move the function doing Hyper-V hypercall to a common
    header
  KVM: selftests: Hyper-V PV IPI selftest
  KVM: selftests: Fill in vm->vpages_mapped bitmap in virt_map() too
  KVM: selftests: Export vm_vaddr_unused_gap() to make it possible to
    request unmapped ranges
  KVM: selftests: Hyper-V PV TLB flush selftest
  KVM: selftests: Sync 'struct hv_enlightened_vmcs' definition with
    hyperv-tlfs.h
  KVM: selftests: Sync 'struct hv_vp_assist_page' definition with
    hyperv-tlfs.h
  KVM: selftests: Move Hyper-V VP assist page enablement out of evmcs.h
  KVM: selftests: Split off load_evmcs() from load_vmcs()
  KVM: selftests: Create a vendor independent helper to allocate Hyper-V
    specific test pages
  KVM: selftests: Allocate Hyper-V partition assist page
  KVM: selftests: evmcs_test: Introduce L2 TLB flush test
  KVM: selftests: hyperv_svm_test: Introduce L2 TLB flush test
  KVM: selftests: Rename 'evmcs_test' to 'hyperv_evmcs'

 arch/x86/include/asm/hyperv-tlfs.h            |  37 +
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  42 +-
 arch/x86/include/asm/svm.h                    |   7 +-
 arch/x86/kvm/Makefile                         |   5 +-
 arch/x86/kvm/hyperv.c                         | 335 +++++++--
 arch/x86/kvm/hyperv.h                         |  64 +-
 arch/x86/kvm/svm/hyperv.c                     |  18 +
 arch/x86/kvm/svm/hyperv.h                     |  50 +-
 arch/x86/kvm/svm/nested.c                     |  49 +-
 arch/x86/kvm/svm/svm.c                        |   7 +
 arch/x86/kvm/svm/svm.h                        |   5 +-
 arch/x86/kvm/svm/svm_onhyperv.c               |   8 +-
 arch/x86/kvm/svm/svm_onhyperv.h               |  25 +-
 arch/x86/kvm/trace.h                          |  21 +-
 arch/x86/kvm/vmx/{evmcs.c => hyperv.c}        |  45 +-
 arch/x86/kvm/vmx/{evmcs.h => hyperv.h}        |  12 +-
 arch/x86/kvm/vmx/nested.c                     |  43 +-
 arch/x86/kvm/vmx/vmx.c                        |   7 +-
 arch/x86/kvm/vmx/vmx_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |  38 +-
 arch/x86/kvm/x86.h                            |   1 +
 include/asm-generic/hyperv-tlfs.h             |   5 +
 include/asm-generic/mshyperv.h                |  11 +-
 tools/testing/selftests/kvm/.gitignore        |   4 +-
 tools/testing/selftests/kvm/Makefile          |   5 +-
 .../selftests/kvm/include/kvm_util_base.h     |   1 +
 .../selftests/kvm/include/x86_64/evmcs.h      |  48 +-
 .../selftests/kvm/include/x86_64/hyperv.h     | 102 +++
 .../selftests/kvm/include/x86_64/processor.h  |  76 +-
 .../selftests/kvm/include/x86_64/svm.h        |  26 +-
 .../selftests/kvm/include/x86_64/vmx.h        |   8 -
 tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +-
 .../testing/selftests/kvm/lib/x86_64/hyperv.c |  46 ++
 .../selftests/kvm/lib/x86_64/processor.c      |  21 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  45 +-
 .../kvm/x86_64/emulator_error_test.c          |   6 +-
 .../x86_64/{evmcs_test.c => hyperv_evmcs.c}   |  69 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |  25 +-
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c | 330 +++++++++
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  86 ++-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   | 689 ++++++++++++++++++
 42 files changed, 2081 insertions(+), 354 deletions(-)
 create mode 100644 arch/x86/kvm/svm/hyperv.c
 rename arch/x86/kvm/vmx/{evmcs.c => hyperv.c} (95%)
 rename arch/x86/kvm/vmx/{evmcs.h => hyperv.h} (95%)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/hyperv.c
 rename tools/testing/selftests/kvm/x86_64/{evmcs_test.c => hyperv_evmcs.c} (73%)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c

-- 
2.37.3

