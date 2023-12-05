Return-Path: <kvm+bounces-3483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A5D8805087
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B13E1C20E52
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8657F59E44;
	Tue,  5 Dec 2023 10:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a7+j6I7c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D127F1BC9
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rI7wmdo4cSVSZktQqg8egY0kWnqM2yjEZBJKjP7VQpY=;
	b=a7+j6I7cHZhuNKjC119irq1lMeC5Hhc5GpX3zcjjQHP16hR0LYLt7A5r48huQUsAjyec1P
	EJpoI8Sqp3/rsKRfjONqBB5bKqJjjjPr1F/ryTheYaup7mStEjFSwlfq46PGlinESfsvQO
	RdO+qA+wzXsgY0vU+3OIkct5nlxO1/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-AbRnc3YWPjKSBcrn76psHQ-1; Tue, 05 Dec 2023 05:36:32 -0500
X-MC-Unique: AbRnc3YWPjKSBcrn76psHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49E9383B82B;
	Tue,  5 Dec 2023 10:36:32 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74F3D2026D66;
	Tue,  5 Dec 2023 10:36:31 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 00/16] KVM: x86: Make Hyper-V emulation optional
Date: Tue,  5 Dec 2023 11:36:14 +0100
Message-ID: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

v1:
  https://lore.kernel.org/kvm/20231025152406.1879274-1-vkuznets@redhat.com/

Changes since RFC:
- "KVM: x86: hyper-v: Split off nested_evmcs_handle_vmclear()" patch added
  [Sean]
- "KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h" patch added [Sean]
- Use evmptr_is_set()/nested_vmx_is_evmptr12_set() helpers instead of 
  nested_vmx_evmptr12() [Sean]
- Move "#ifdef CONFIG_KVM_HYPERV" inside certain functions instead of 
  adding stubs for !CONFIG_KVM_HYPERV case [Sean]
- Minor code re-shuffling [Sean]
- Collect R-b tags [Max]

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

The series is not supposed to introduce any functional change for the 
"CONFIG_KVM_HYPERV=y && CONFIG_HYPERV=m/y" case. Tested with KVM selftests,
kvm-unit-tests and real Windows guests on VMX and SVM. Note, kvm-unit-tests
have to be updated to not fail miserably when CONFIG_KVM_HYPERV is not set:
https://lore.kernel.org/kvm/20231025152915.1879661-1-vkuznets@redhat.com/

Vitaly Kuznetsov (16):
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
  KVM: x86: hyper-v: Split off nested_evmcs_handle_vmclear()
  KVM: selftests: Make all Hyper-V tests explicitly dependent on Hyper-V
    emulation support in KVM
  KVM: selftests: Fix vmxon_pa == vmcs12_pa == -1ull
    vmx_set_nested_state_test for !eVMCS case
  KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h
  KVM: x86: Make Hyper-V emulation optional
  KVM: nVMX: hyper-v: Introduce nested_vmx_is_evmptr12_{valid,set}()
    helpers
  KVM: nVMX: hyper-v: Introduce nested_vmx_evmcs() accessor
  KVM: nVMX: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV
  KVM: nSVM: hyper-v: Hide more stuff under
    CONFIG_KVM_HYPERV/CONFIG_HYPERV

 arch/x86/include/asm/kvm_host.h               |  13 +-
 arch/x86/kvm/Kconfig                          |  14 +
 arch/x86/kvm/Makefile                         |  16 +-
 arch/x86/kvm/cpuid.c                          |   6 +
 arch/x86/kvm/hyperv.h                         |  83 +++-
 arch/x86/kvm/irq.c                            |   2 +
 arch/x86/kvm/irq_comm.c                       |   9 +-
 arch/x86/kvm/kvm_onhyperv.h                   |  20 +
 arch/x86/kvm/lapic.c                          |   5 +-
 arch/x86/kvm/svm/hyperv.h                     |   9 +
 arch/x86/kvm/svm/nested.c                     |  30 +-
 arch/x86/kvm/svm/svm.h                        |   2 +
 arch/x86/kvm/svm/svm_onhyperv.c               |  10 +-
 arch/x86/kvm/vmx/hyperv.c                     | 447 ------------------
 arch/x86/kvm/vmx/hyperv.h                     | 204 ++------
 arch/x86/kvm/vmx/hyperv_evmcs.c               | 315 ++++++++++++
 arch/x86/kvm/vmx/hyperv_evmcs.h               | 166 +++++++
 arch/x86/kvm/vmx/nested.c                     | 149 +++---
 arch/x86/kvm/vmx/nested.h                     |   3 +-
 arch/x86/kvm/vmx/vmx.c                        |  20 +-
 arch/x86/kvm/vmx/vmx.h                        |  12 +-
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
 33 files changed, 1054 insertions(+), 742 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.c
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.h
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.c
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.h

-- 
2.43.0


