Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304F156BC8A
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbiGHOmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbiGHOme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:42:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 425055722F
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657291351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=T4/lX3GtkFoEUn7AHHNPmGNZmkEvYlCcVIk40bRD/7k=;
        b=EVD81Ljx/w3YwjCQr7Hbw0qZkPsy5G2OQcl5/3fYUbfQgB2x1OxtsdVESzsKlLnmAjRuDe
        DPeo9uPfLEOuZi8g9tyJnr9t5Xh+2R30eWHE4pAtNBcr0qWJkblFtRmb9q2h97SKyYaahF
        1nYeWzEEJewjWloAitV4brpQIraej6A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-UYT2hIByMLSykwEEktHYBA-1; Fri, 08 Jul 2022 10:42:28 -0400
X-MC-Unique: UYT2hIByMLSykwEEktHYBA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2546E1C05AF1;
        Fri,  8 Jul 2022 14:42:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50D69492C3B;
        Fri,  8 Jul 2022 14:42:24 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/25] KVM: VMX: Support updated eVMCSv1 revision + use vmcs_config for L1 VMX MSRs
Date:   Fri,  8 Jul 2022 16:41:58 +0200
Message-Id: <20220708144223.610080-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series continues:
- "[PATCH v2 00/28] KVM: VMX: Support TscScaling and EnclsExitingBitmap
 with eVMCS + use vmcs_config for L1 VMX MSRs" work:
https://lore.kernel.org/kvm/20220629150625.238286-1-vkuznets@redhat.com/

Changes since v1:
- Turns out the updated eVMCSv1 revision comes with a CPUID feature bit
  and this changes a lot as we don't need to invent our own eVMCS
  revisions. Adjust the whole series accordingly, drop now unneeded
  KVM_CAP_HYPERV_ENLIGHTENED_VMCS2.
- VM_{EXIT,ENTRY}_LOAD_IA32_PERF_GLOBAL_CTRL are now supported for both
  Hyper-V on KVM and KVM on Hyper-V.
- Make CPU_BASED_NMI_WINDOW_EXITING optional [Sean].
- Drop erroneous "KVM: VMX: Add missing VMENTRY controls to vmcs_config"
  [Jim].
- Include Jim's "KVM: x86: VMX: Replace some Intel model numbers with
  mnemonics" into the series.
- "KVM: nVMX: Always set required-1 bits of pinbased_ctls to 
  PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR" added [Jim]. It allows to get rid
  of required-1 bits caching in vmcs_config, patches dropped.
- Collect R-b tags [Jim].
- Other minor tweaks (descriptions, comments) [Jim, Sean].

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
(BIT 0). Use a made up HV_X64_NESTED_EVMCS1_2022_UPDATE name for it.

Add support for the new revision to KVM. SSP, CET and GuestLbrCtl
features are not currently supported by KVM.

While on it, implement Sean's idea to use vmcs_config for setting up
L1 VMX control MSRs instead of re-reading host MSRs.

Jim Mattson (1):
  KVM: x86: VMX: Replace some Intel model numbers with mnemonics

Sean Christopherson (1):
  KVM: VMX: Adjust CR3/INVPLG interception for EPT=y at runtime, not
    setup

Vitaly Kuznetsov (23):
  KVM: x86: hyper-v: Expose access to debug MSRs in the partition
    privilege flags
  x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
  x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
  KVM: VMX: Define VMCS-to-EVMCS conversion for the new fields
  KVM: nVMX: Support several new fields in eVMCSv1
  KVM: x86: hyper-v: Cache HYPERV_CPUID_NESTED_FEATURES CPUID leaf
  KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
  KVM: selftests: Switch to updated eVMCSv1 definition
  KVM: VMX: nVMX: Support TSC scaling and PERF_GLOBAL_CTRL with
    enlightened VMCS
  KVM: selftests: Enable TSC scaling in evmcs selftest
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
 arch/x86/kvm/hyperv.c                         |  12 +-
 arch/x86/kvm/vmx/capabilities.h               |  14 +-
 arch/x86/kvm/vmx/evmcs.c                      | 127 +++++++---
 arch/x86/kvm/vmx/evmcs.h                      |  18 +-
 arch/x86/kvm/vmx/nested.c                     |  70 ++++--
 arch/x86/kvm/vmx/nested.h                     |   2 +-
 arch/x86/kvm/vmx/vmx.c                        | 235 ++++++++----------
 arch/x86/kvm/vmx/vmx.h                        | 116 +++++++++
 include/asm-generic/hyperv-tlfs.h             |   2 +
 .../selftests/kvm/include/x86_64/evmcs.h      |  45 +++-
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  31 ++-
 14 files changed, 477 insertions(+), 221 deletions(-)

-- 
2.35.3

