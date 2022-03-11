Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4A14D64F3
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 16:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349507AbiCKPvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 10:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349531AbiCKPu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 10:50:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 195931C4692
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 07:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647013792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TLKVUzf5prrCo+BWdLLoS9CndOmOZ6emWbQjAHJaifo=;
        b=PD9OWruUjkkTQwtq+b4jYEYaX4TShDA4sq+FzACqfGbSfgowt3MIgYfH+06vKSkuPy/D4h
        BD+s95ehIA7BV06IIXG8/Q3Sd/qB8+TqIASEPnMAh8lDW1VJ5q4ApIxP7DgOyISFMu4Tqo
        Ou+Ip/+/d8GDp0b9bkptpbaP6zmImBo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-aWU8IK2gOleYP1HucngJiQ-1; Fri, 11 Mar 2022 10:49:49 -0500
X-MC-Unique: aWU8IK2gOleYP1HucngJiQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C2BD1091DA0;
        Fri, 11 Mar 2022 15:49:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B73FF866CB;
        Fri, 11 Mar 2022 15:49:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/31] KVM: x86: hyper-v: Fine-grained TLB flush + Direct TLB flush feature
Date:   Fri, 11 Mar 2022 16:49:12 +0100
Message-Id: <20220311154943.2299191-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since RFCv1:
- Tests! Brand new hyperv_ipi/hyperv_tlb_flush tests as well as Direct TLB
 flush tests added to evmcs_test/hyperv_svm_test.
- Michael's R-b tag added to "x86/hyperv: Fix 'struct hv_enlightened_vmcs'
 definition".
- Use HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL to avoid updating
 hv_vm_id/hv_vp_id/partition_assist_page every VMLAUNCH/VMRESUME.

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

Vitaly Kuznetsov (31):
  KVM: x86: hyper-v: Resurrect dedicated KVM_REQ_HV_TLB_FLUSH flag
  KVM: x86: hyper-v: Introduce TLB flush ring
  KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls
    gently
  KVM: x86: hyper-v: Expose support for extended gva ranges for flush
    hypercalls
  KVM: x86: Prepare kvm_hv_flush_tlb() to handle L2's GPAs
  KVM: x86: hyper-v: Don't use sparse_set_to_vcpu_mask() in
    kvm_hv_send_ipi()
  KVM: x86: hyper-v: Create a separate ring for Direct TLB flush
  KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv'
    instead of on-stack 'sparse_banks'
  KVM: nVMX: Keep track of hv_vm_id/hv_vp_id when eVMCS is in use
  KVM: nSVM: Keep track of Hyper-V hv_vm_id/hv_vp_id
  KVM: x86: Introduce .post_hv_direct_flush() nested hook
  KVM: x86: hyper-v: Introduce kvm_hv_is_tlb_flush_hcall()
  KVM: x86: hyper-v: Direct TLB flush
  KVM: x86: hyper-v: Introduce fast kvm_hv_direct_tlb_flush_exposed()
    check
  x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
  KVM: nVMX: hyper-v: Direct TLB flush
  KVM: x86: KVM_REQ_TLB_FLUSH_CURRENT is a superset of
    KVM_REQ_HV_TLB_FLUSH too
  KVM: nSVM: hyper-v: Direct TLB flush
  KVM: x86: Expose Hyper-V Direct TLB flush feature
  KVM: selftests: Add hyperv_svm_test to .gitignore
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
  KVM: selftests: evmcs_test: Direct TLB flush test
  KVM: selftests: Move Hyper-V VP assist page enablement out of evmcs.h
  KVM: selftests: hyperv_svm_test: Add Direct TLB flush test

 arch/x86/include/asm/hyperv-tlfs.h            |   6 +-
 arch/x86/include/asm/kvm_host.h               |  30 +
 arch/x86/kvm/Makefile                         |   3 +-
 arch/x86/kvm/hyperv.c                         | 305 ++++++++-
 arch/x86/kvm/hyperv.h                         |  55 ++
 arch/x86/kvm/svm/hyperv.c                     |  18 +
 arch/x86/kvm/svm/hyperv.h                     |  37 +
 arch/x86/kvm/svm/nested.c                     |  25 +-
 arch/x86/kvm/trace.h                          |  21 +-
 arch/x86/kvm/vmx/evmcs.c                      |  24 +
 arch/x86/kvm/vmx/evmcs.h                      |   4 +
 arch/x86/kvm/vmx/nested.c                     |  29 +
 arch/x86/kvm/x86.c                            |  15 +-
 arch/x86/kvm/x86.h                            |   1 +
 tools/testing/selftests/kvm/.gitignore        |   3 +
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
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  53 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |   5 +-
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c | 362 ++++++++++
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  60 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   | 647 ++++++++++++++++++
 .../selftests/kvm/x86_64/mmu_role_test.c      |   2 +-
 31 files changed, 1793 insertions(+), 121 deletions(-)
 create mode 100644 arch/x86/kvm/svm/hyperv.c
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/hyperv.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c

-- 
2.35.1

