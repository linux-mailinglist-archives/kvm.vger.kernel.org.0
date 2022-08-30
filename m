Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785BA5A64EE
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiH3Nhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiH3Nhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:37:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C35CE1915
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9UTBAFUbAYHYUBau1lZ/BOUOjtud9XWZ2JTu1H1Jhfs=;
        b=dF7dHPY4KoOX7YYv8/kKyM4+Uc60hP7ZA6v9NIHDP97OVcUbwda9pSN3tbFatVKY7pDI8G
        DrZyOF5MKHIc1qEF0GzebTWbth4g29EA5T0WI85P2WA3P6LNPQ7/6w9OEuEs0gKEX08gB+
        976l6+QGTsZVJVtH1ymA75Apav4Wf/Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-GJ2Yd-HCPhaqHHQBf1RBgQ-1; Tue, 30 Aug 2022 09:37:42 -0400
X-MC-Unique: GJ2Yd-HCPhaqHHQBf1RBgQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7904585A585;
        Tue, 30 Aug 2022 13:37:40 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65DD52166B26;
        Tue, 30 Aug 2022 13:37:38 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 00/33] KVM: VMX: Support updated eVMCSv1 revision + use vmcs_config for L1 VMX MSRs
Date:   Tue, 30 Aug 2022 15:37:04 +0200
Message-Id: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since "[RFC PATCH v6 00/36] KVM: x86: eVMCS rework":
- Drop the most controversial TSC_SCALING enablement for Hyper-V on KVM:
  - "KVM: nVMX: Enforce unsupported eVMCS in VMX MSRs for host accesses" patch dropped.
  - "KVM: nVMX: Support TSC scaling with enlightened VMCS" patch dropped.
  - "KVM: selftests: Enable TSC scaling in evmcs selftest" patch dropped.

Original description:

Enlightened VMCS v1 definition was updates to include fields for the
following features:
    - PerfGlobalCtrl
    - EnclsExitingBitmap
    - TSC scaling
    - GuestLbrCtl
    - CET
    - SSP
While the information is missing in the publicly available TLFS, the
updated definition comes with a new feature bit in CPUID.0x4000000A.EBX
(BIT 0) for PerfGlobalCtrl.

Add support for the new revision to KVM. SSP, CET and GuestLbrCtl
features are not currently supported by KVM. Note: for Hyper-V on KVM,
only PerfGlobalCtrl is added as it has a dedicated CPUID bit. The way
how to enable different layouts of eVMSC in a VMM friendly way is still
under discussion.

While on it, implement Sean's idea to use vmcs_config for setting up
L1 VMX control MSRs instead of re-reading host MSRs.

Jim Mattson (1):
  KVM: x86: VMX: Replace some Intel model numbers with mnemonics

Sean Christopherson (9):
  KVM: x86: Check for existing Hyper-V vCPU in kvm_hv_vcpu_init()
  KVM: x86: Report error when setting CPUID if Hyper-V allocation fails
  KVM: nVMX: Treat eVMCS as enabled for guest iff Hyper-V is also
    enabled
  KVM: nVMX: Use CC() macro to handle eVMCS unsupported controls checks
  KVM: nVMX: WARN once and fail VM-Enter if eVMCS sees VMFUNC[63:32] !=
    0
  KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to
    vmcs02
  KVM: nVMX: Always emulate PERF_GLOBAL_CTRL VM-Entry/VM-Exit controls
  KVM: VMX: Don't toggle VM_ENTRY_IA32E_MODE for 32-bit kernels/KVM
  KVM: VMX: Adjust CR3/INVPLG interception for EPT=y at runtime, not
    setup

Vitaly Kuznetsov (23):
  x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
  x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
  KVM: x86: Zero out entire Hyper-V CPUID cache before processing
    entries
  KVM: nVMX: Refactor unsupported eVMCS controls logic to use 2-d array
  KVM: VMX: Define VMCS-to-EVMCS conversion for the new fields
  KVM: nVMX: Support several new fields in eVMCSv1
  KVM: x86: hyper-v: Cache HYPERV_CPUID_NESTED_FEATURES CPUID leaf
  KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
  KVM: selftests: Switch to updated eVMCSv1 definition
  KVM: nVMX: Support PERF_GLOBAL_CTRL with enlightened VMCS
  KVM: VMX: Get rid of eVMCS specific VMX controls sanitization
  KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
  KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in
    setup_vmcs_config()
  KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING
    in setup_vmcs_config()
  KVM: VMX: Extend VMX controls macro shenanigans
  KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of
    setup_vmcs_config()
  KVM: VMX: Add missing VMEXIT controls to vmcs_config
  KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
  KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of
    setup_vmcs_config()
  KVM: nVMX: Always set required-1 bits of pinbased_ctls to
    PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
  KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
  KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
  KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up
    nested MSR

 arch/x86/include/asm/hyperv-tlfs.h            |  22 +-
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/cpuid.c                          |  18 +-
 arch/x86/kvm/hyperv.c                         |  70 +++--
 arch/x86/kvm/hyperv.h                         |   6 +-
 arch/x86/kvm/vmx/capabilities.h               |  14 +-
 arch/x86/kvm/vmx/evmcs.c                      | 192 ++++++++-----
 arch/x86/kvm/vmx/evmcs.h                      |  10 +-
 arch/x86/kvm/vmx/nested.c                     |  94 ++++---
 arch/x86/kvm/vmx/nested.h                     |   2 +-
 arch/x86/kvm/vmx/vmx.c                        | 259 ++++++++----------
 arch/x86/kvm/vmx/vmx.h                        | 172 ++++++++++--
 .../selftests/kvm/include/x86_64/evmcs.h      |  45 ++-
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 14 files changed, 584 insertions(+), 324 deletions(-)

-- 
2.37.2

