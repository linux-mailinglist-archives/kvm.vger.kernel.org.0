Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBD35603D6
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiF2PGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiF2PGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:06:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 314AB13CD3
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rVgaRC1iHp+TixDi6SmECfMb1vkUScvqSyrOozckYA8=;
        b=c2JvxTPOpH0/EG76RE8PvHG/SnsCsh5edWUkxgitBBuuQu4SV63/U13XnULJwTQE1eripW
        VABa9uO/99VD8iSfXTY2UUCssJ188Pzr17UCxqb3vbw0i8MaZ7InDxDm2W4jXmwteoyCp+
        Wp+Ftr3mdFzPVVvecttyTpeMUxh33/o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-wJTPDIUQMzivuzqhkwJ-wA-1; Wed, 29 Jun 2022 11:06:29 -0400
X-MC-Unique: wJTPDIUQMzivuzqhkwJ-wA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 593781C0898F;
        Wed, 29 Jun 2022 15:06:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A347040EC002;
        Wed, 29 Jun 2022 15:06:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/28] KVM: VMX: Support TscScaling and EnclsExitingBitmap with eVMCS + use vmcs_config for L1 VMX MSRs
Date:   Wed, 29 Jun 2022 17:05:57 +0200
Message-Id: <20220629150625.238286-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series combines previously sent:
- "[PATCH 00/11] KVM: VMX: Support TscScaling and EnclsExitingBitmap
 with eVMCS" 
(https://lore.kernel.org/kvm/20220621155830.60115-1-vkuznets@redhat.com/)
and 
- "[PATCH 00/14] KVM: nVMX: Use vmcs_config for setting up nested VMX MSRs"
(https://lore.kernel.org/kvm/20220627160440.31857-1-vkuznets@redhat.com/)

this is done to address Jim's concern that any changes to L1 VMX control
MSRs will inevitably break live migration. This version should not produce
changes.

Original description:

Enlightened VMCS v1 definition was updates to include fields for the
following features:
    - PerfGlobalCtrl
    - EnclsExitingBitmap
    - TSC scaling
    - GuestLbrCtl
    - CET
    - SSP

Add support for EnclsExitingBitmap and TSC scaling to KVM. PerfGlobalCtrl 
doesn't work correctly with Win11, don't enable it yet. SSP, CET and 
GuestLbrCtl are not currently supported by KVM.

Note: adding new field for KVM on Hyper-V case is easy but adding them to
Hyper-V on KVM requires some work to not break live migration as we never
expected this to happen without eVMCS version update. The series introduces
new KVM_CAP_HYPERV_ENLIGHTENED_VMCS2 capability and a notion of KVM 
internal 'Enlightened VMCS revision'.

While on it, implement Sean's idea to use vmcs_config for setting up
L1 VMX control MSRs instead of re-reading host MSRs.

Sean Christopherson (1):
  KVM: VMX: Clear controls obsoleted by EPT at runtime, not setup

Vitaly Kuznetsov (27):
  KVM: x86: hyper-v: Expose access to debug MSRs in the partition
    privilege flags
  x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
  x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
  KVM: VMX: Define VMCS-to-EVMCS conversion for the new fields
  KVM: nVMX: Support several new fields in eVMCSv1
  KVM: nVMX: Introduce KVM_CAP_HYPERV_ENLIGHTENED_VMCS2
  KVM: selftests: Switch to KVM_CAP_HYPERV_ENLIGHTENED_VMCS2
  KVM: VMX: Support TSC scaling with enlightened VMCS
  KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
  KVM: selftests: Switch to updated eVMCSv1 definition
  KVM: selftests: Enable TSC scaling in evmcs selftest
  KVM: VMX: Enable VM_{EXIT,ENTRY}_LOAD_IA32_PERF_GLOBAL_CTRL for KVM on
    Hyper-V
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
  KVM: VMX: Add missing VMENTRY controls to vmcs_config
  KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
  KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of
    setup_vmcs_config()
  KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
  KVM: VMX: Store required-1 VMX controls in vmcs_config
  KVM: nVMX: Use sanitized required-1 bits for VMX control MSRs
  KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
  KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up
    nested MSR

 Documentation/virt/kvm/api.rst                |  43 ++-
 arch/x86/include/asm/hyperv-tlfs.h            |  19 +-
 arch/x86/include/asm/kvm_host.h               |   2 +-
 arch/x86/kvm/hyperv.c                         |   1 +
 arch/x86/kvm/vmx/capabilities.h               |  16 +-
 arch/x86/kvm/vmx/evmcs.c                      | 135 ++++++---
 arch/x86/kvm/vmx/evmcs.h                      |  34 ++-
 arch/x86/kvm/vmx/nested.c                     |  80 ++++--
 arch/x86/kvm/vmx/nested.h                     |   2 +-
 arch/x86/kvm/vmx/vmx.c                        | 269 +++++++++---------
 arch/x86/kvm/vmx/vmx.h                        | 133 ++++++++-
 arch/x86/kvm/x86.c                            |  15 +-
 include/asm-generic/hyperv-tlfs.h             |   2 +
 include/uapi/linux/kvm.h                      |   3 +-
 .../selftests/kvm/include/kvm_util_base.h     |   8 +
 .../selftests/kvm/include/x86_64/evmcs.h      |  46 ++-
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   5 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  33 ++-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |   2 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c    |   2 +-
 21 files changed, 597 insertions(+), 255 deletions(-)

-- 
2.35.3

