Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30137D70C7
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbjJYPZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbjJYPZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:25:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E781187
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jWQYarhNRcwIZbYlb9j2r0GLuTlnKZLQKWCz9r2/OU0=;
        b=ZRBvzhEbTIXLag96Um3bbj8oIZUAFXwWT/S6VtKdopwVOOlFYy1pBvdCUnOGhu4lLv+9PB
        W1J7ibYrB4z6+3MXsA62h4GNGuiw7JKZGFLwcnTFHSJgABUfjbUrEhxoUzYQE9rKVdXTOC
        xp1zXN+wRQxdseJngpN1AePfTBGaPbE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-lBvtGK4dP4uNWFkrXak9LQ-1; Wed, 25 Oct 2023 11:24:08 -0400
X-MC-Unique: lBvtGK4dP4uNWFkrXak9LQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35A43811E91;
        Wed, 25 Oct 2023 15:24:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4555E2166B27;
        Wed, 25 Oct 2023 15:24:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] KVM: x86: Make Hyper-V emulation optional
Date:   Wed, 25 Oct 2023 17:23:52 +0200
Message-ID: <20231025152406.1879274-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RFC:
  https://lore.kernel.org/kvm/20231010160300.1136799-1-vkuznets@redhat.com/

Changes since RFC:
- Enhance Kconfig message [Max, Sean]
- Introduce nested_vmx_is_evmptr12_valid [Max, Sean]
- Collected R-b tags [Max]
- Add a common function to allocate partition assist page [Max]
- Fix KVM selftest to skip gracefully when !CONFIG_KVM_HYPERV
- Other minor tweaks.

KVM supports emulating Microsoft Hyper-V as well as running as a nested
(L1) hypervisor on top of Hyper-V whileusing Hyper-V specific PV features.
Support for the later is only compiled in when CONFIG_HYPERV is set. This
series makes it possible to disable the former with a newly introduced 
CONFIG_KVM_HYPERV option. This helps to reduce sized of KVM modules as well
as the attack surface for some specific deployments when no Windows/Hyper-V
guests are expected. The size gain is significant:

    # CONFIG_KVM_HYPERV is not set
    # CONFIG_HYPERV is not set

    -rw-r--r--. 1 user user 3612632 Oct 10 16:53 arch/x86/kvm/kvm-amd.ko
    -rw-r--r--. 1 user user 5343968 Oct 10 16:53 arch/x86/kvm/kvm-intel.ko

    CONFIG_KVM_HYPERV=y
    # CONFIG_HYPERV is not set

    -rw-r--r--. 1 user user 3925704 Oct 10 16:51 arch/x86/kvm/kvm-amd.ko
    -rw-r--r--. 1 user user 5819192 Oct 10 16:51 arch/x86/kvm/kvm-intel.ko

    # CONFIG_KVM_HYPERV is not set
    CONFIG_HYPERV=m

    -rw-r--r--. 1 user user 3928440 Oct 10 16:40 arch/x86/kvm/kvm-amd.ko
    -rw-r--r--. 1 user user 8156464 Oct 10 16:40 arch/x86/kvm/kvm-intel.ko

    CONFIG_KVM_HYPERV=y
    CONFIG_HYPERV=m

    -rw-r--r--. 1 user user 4245440 Oct 10 16:37 arch/x86/kvm/kvm-amd.ko
    -rw-r--r--. 1 user user 8583872 Oct 10 16:37 arch/x86/kvm/kvm-intel.ko

The series should not supposed to introduce any functional change for the 
"CONFIG_KVM_HYPERV=y && CONFIG_HYPERV=m/y" case. Tested with KVM selftests,
kvm-unit-tests and real Windows guests on VMX and SVM. Note, kvm-unit-tests
have to be updated to not fail miserably when CONFIG_KVM_HYPERV is not set,
I'll send a separate series.

Vitaly Kuznetsov (14):
  KVM: x86: xen: Remove unneeded xen context from struct kvm_arch when
    !CONFIG_KVM_XEN
  KVM: x86: hyper-v: Move Hyper-V partition assist page out of Hyper-V
    emulation context
  KVM: VMX: Split off vmx_onhyperv.{ch} from hyperv.{ch}
  KVM: x86: hyper-v: Introduce kvm_hv_synic_auto_eoi_set()
  KVM: x86: hyper-v: Introduce kvm_hv_synic_has_vector()
  KVM: VMX: Split off hyperv_evmcs.{ch}
  KVM: x86: hyper-v: Introduce kvm_hv_nested_transtion_tlb_flush()
    helper
  KVM: selftests: Make all Hyper-V tests explicitly dependent on Hyper-V
    emulation support in KVM
  KVM: selftests: Fix vmxon_pa == vmcs12_pa == -1ull
    vmx_set_nested_state_test for !eVMCS case
  KVM: x86: Make Hyper-V emulation optional
  KVM: nVMX: hyper-v: Introduce nested_vmx_evmptr12() and
    nested_vmx_is_evmptr12_valid() helpers
  KVM: nVMX: hyper-v: Introduce nested_vmx_evmcs() accessor
  KVM: nVMX: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV
  KVM: nSVM: hyper-v: Hide more stuff under
    CONFIG_KVM_HYPERV/CONFIG_HYPERV

 arch/x86/include/asm/kvm_host.h               |  11 +-
 arch/x86/kvm/Kconfig                          |  14 +
 arch/x86/kvm/Makefile                         |  19 +-
 arch/x86/kvm/cpuid.c                          |   6 +
 arch/x86/kvm/hyperv.h                         |  52 +-
 arch/x86/kvm/irq.c                            |   2 +
 arch/x86/kvm/irq_comm.c                       |   9 +-
 arch/x86/kvm/kvm_onhyperv.h                   |  20 +
 arch/x86/kvm/lapic.c                          |   5 +-
 arch/x86/kvm/svm/hyperv.h                     |   7 +
 arch/x86/kvm/svm/nested.c                     |  30 +-
 arch/x86/kvm/svm/svm.h                        |   2 +
 arch/x86/kvm/svm/svm_onhyperv.c               |  10 +-
 arch/x86/kvm/vmx/hyperv.c                     | 447 ------------------
 arch/x86/kvm/vmx/hyperv.h                     | 196 ++------
 arch/x86/kvm/vmx/hyperv_evmcs.c               | 315 ++++++++++++
 arch/x86/kvm/vmx/hyperv_evmcs.h               | 166 +++++++
 arch/x86/kvm/vmx/nested.c                     | 102 ++--
 arch/x86/kvm/vmx/nested.h                     |   3 +-
 arch/x86/kvm/vmx/vmx.c                        |  18 +-
 arch/x86/kvm/vmx/vmx.h                        |   2 +
 arch/x86/kvm/vmx/vmx_onhyperv.c               |  36 ++
 arch/x86/kvm/vmx/vmx_onhyperv.h               | 125 +++++
 arch/x86/kvm/vmx/vmx_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |  66 ++-
 .../selftests/kvm/x86_64/hyperv_clock.c       |   2 +
 .../selftests/kvm/x86_64/hyperv_evmcs.c       |   5 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c   |   2 +
 .../selftests/kvm/x86_64/hyperv_features.c    |   2 +
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c |   2 +
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |   1 +
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   |   2 +
 .../kvm/x86_64/vmx_set_nested_state_test.c    |  16 +-
 33 files changed, 963 insertions(+), 734 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.c
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.h
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.c
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.h

-- 
2.41.0

