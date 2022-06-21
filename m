Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8820C553724
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353487AbiFUP7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353417AbiFUP6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:58:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C631BB60
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655827115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OnM6LWqbySomFL+MYIQvAUbrzoQzHU8UBGdR/EPQFvc=;
        b=YzYq0cDb0J54lNUsXOENlMz1fkqzsXDBzndbeFRMUGo/rKGFMvM7GEOGpziu7N+q5RNcvE
        rIVAcJjXG5saieuPg01TXzms8zS6kcGyaDHfMJmm8riXaZRrlo7MmorNZ9AZK0XMjn/1RD
        6mUKcJZVXK+TB23783dA2LAZD+9ZGTk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-EI-eceqAOPqCr-ag0dv3CQ-1; Tue, 21 Jun 2022 11:58:34 -0400
X-MC-Unique: EI-eceqAOPqCr-ag0dv3CQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F17B0811E75;
        Tue, 21 Jun 2022 15:58:33 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E80F42026985;
        Tue, 21 Jun 2022 15:58:31 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] KVM: VMX: Support TscScaling and EnclsExitingBitmap whith eVMCS
Date:   Tue, 21 Jun 2022 17:58:19 +0200
Message-Id: <20220621155830.60115-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Example QEMU enablement patch for the new capability will be sent as a 
follow-up to the series.

Vitaly Kuznetsov (11):
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

 Documentation/virt/kvm/api.rst                |  42 ++++++-
 arch/x86/include/asm/hyperv-tlfs.h            |  19 ++-
 arch/x86/include/asm/kvm_host.h               |   2 +-
 arch/x86/kvm/hyperv.c                         |   1 +
 arch/x86/kvm/vmx/evmcs.c                      | 116 ++++++++++++++----
 arch/x86/kvm/vmx/evmcs.h                      |  28 +++--
 arch/x86/kvm/vmx/nested.c                     |  43 ++++++-
 arch/x86/kvm/vmx/vmx.c                        |   4 +-
 arch/x86/kvm/vmx/vmx.h                        |  15 +--
 arch/x86/kvm/x86.c                            |  15 ++-
 include/asm-generic/hyperv-tlfs.h             |   2 +
 include/uapi/linux/kvm.h                      |   3 +-
 .../selftests/kvm/include/kvm_util_base.h     |   8 ++
 .../selftests/kvm/include/x86_64/evmcs.h      |  46 ++++++-
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   5 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  33 ++++-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |   2 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c    |   2 +-
 19 files changed, 321 insertions(+), 67 deletions(-)

-- 
2.35.3

