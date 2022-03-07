Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277D24D01CC
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243389AbiCGOv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiCGOv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:51:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A52D85BD2
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646664632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hRD/+JUqgxTPFFOSXMLWgiYACum/dExxe7SlZGhyQ9A=;
        b=Gb97/QdyUr5bAhewkDecwb6zr6YMwdk2K8cAiXZf8VKYZayZp3T7CjRNY+dY0Rs0QEtP+v
        eUTKMgYvQzEdLvdwZs437e+Gnz3x/GnJZy8HdWjq8VT5j+U3x5HaqM4S2tIpeOlR9yTAMu
        Jb2aShUXBbU2WD2vurVOZpdvOvbfpLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-xyCHlIzBNVa87SuhJjKrfA-1; Mon, 07 Mar 2022 09:50:29 -0500
X-MC-Unique: xyCHlIzBNVa87SuhJjKrfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BAF61854E26;
        Mon,  7 Mar 2022 14:50:27 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23231797E7;
        Mon,  7 Mar 2022 14:50:24 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 00/19] KVM: x86: hyper-v: Fine-grained TLB flush + Direct TLB flush feature
Date:   Mon,  7 Mar 2022 15:50:04 +0100
Message-Id: <20220307145023.1913205-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

RFC part:
- The series is poorly tested. I've only smoke-tested WS2019 and Win11+WSL2
on VMX and AMD harware to the point that no immediate issues are observed
on boot. We certainly need something added to selftests/kvm-unit-tests.

Vitaly Kuznetsov (19):
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

 arch/x86/include/asm/hyperv-tlfs.h |   6 +-
 arch/x86/include/asm/kvm_host.h    |  30 +++
 arch/x86/kvm/Makefile              |   3 +-
 arch/x86/kvm/hyperv.c              | 305 ++++++++++++++++++++++++++---
 arch/x86/kvm/hyperv.h              |  55 ++++++
 arch/x86/kvm/svm/hyperv.c          |  18 ++
 arch/x86/kvm/svm/hyperv.h          |  37 ++++
 arch/x86/kvm/svm/nested.c          |  25 ++-
 arch/x86/kvm/trace.h               |  21 +-
 arch/x86/kvm/vmx/evmcs.c           |  24 +++
 arch/x86/kvm/vmx/evmcs.h           |   4 +
 arch/x86/kvm/vmx/nested.c          |  41 +++-
 arch/x86/kvm/x86.c                 |  15 +-
 arch/x86/kvm/x86.h                 |   1 +
 14 files changed, 539 insertions(+), 46 deletions(-)
 create mode 100644 arch/x86/kvm/svm/hyperv.c

-- 
2.35.1

