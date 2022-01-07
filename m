Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4078487C7A
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiAGSzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:55:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231343AbiAGSzW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+3+EjMImidl9Lu9LCLBcfnoGdya+H44S/UpDLAGKtus=;
        b=GjFT1afBFCqw+RoGSGmbDghxnPCOF7jmw1URg/qEi0FOaHn1HvZZfgXJFpccJ1Q2sylc4G
        c3KgFjhNi4Yb5vr1MOx5UvRlujzxDyYB/KB0fCd+U8uzwUO/DCIdxMf7UpYoJY4ZlC6jlk
        1Lf/CqAMNdkpxkuBH4LZwr0cX7aulBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-eyRDmh6XMBaaBr05XTclEw-1; Fri, 07 Jan 2022 13:55:15 -0500
X-MC-Unique: eyRDmh6XMBaaBr05XTclEw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E37264A7B;
        Fri,  7 Jan 2022 18:55:14 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 323F9838FF;
        Fri,  7 Jan 2022 18:55:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 00/21] AMX support for KVM
Date:   Fri,  7 Jan 2022 13:54:51 -0500
Message-Id: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are the final patches that I am committing.  They are the
same as v5 except for some cosmetic changes in patch 7 that
remove the need for the IS_ENABLED(CONFIG_X86_64) check, and
a rebase on top of kvm/next.

Paolo

Guang Zeng (1):
  kvm: x86: Add support for getting/setting expanded xstate buffer

Jing Liu (11):
  kvm: x86: Fix xstate_required_size() to follow XSTATE alignment rule
  kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID
  x86/fpu: Make XFD initialization in __fpstate_reset() a function
    argument
  kvm: x86: Enable dynamic xfeatures at KVM_SET_CPUID2
  kvm: x86: Add emulation for IA32_XFD
  x86/fpu: Prepare xfd_err in struct fpu_guest
  kvm: x86: Intercept #NM for saving IA32_XFD_ERR
  kvm: x86: Emulate IA32_XFD_ERR for guest
  kvm: x86: Disable RDMSR interception of IA32_XFD_ERR
  kvm: x86: Add XCR0 support for Intel AMX
  kvm: x86: Add CPUID support for Intel AMX

Kevin Tian (2):
  x86/fpu: Provide fpu_update_guest_xfd() for IA32_XFD emulation
  kvm: x86: Disable interception for IA32_XFD on demand

Sean Christopherson (1):
  x86/fpu: Provide fpu_enable_guest_xfd_features() for KVM

Thomas Gleixner (5):
  x86/fpu: Extend fpu_xstate_prctl() with guest permissions
  x86/fpu: Prepare guest FPU for dynamically enabled FPU features
  x86/fpu: Add guest support to xfd_enable_feature()
  x86/fpu: Add uabi_size to guest_fpu
  x86/fpu: Provide fpu_sync_guest_vmexit_xfd_state()

Wei Wang (1):
  kvm: selftests: Add support for KVM_CAP_XSAVE2

 Documentation/virt/kvm/api.rst                |  46 +++++-
 arch/x86/include/asm/cpufeatures.h            |   2 +
 arch/x86/include/asm/fpu/api.h                |  11 ++
 arch/x86/include/asm/fpu/types.h              |  32 ++++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/include/uapi/asm/kvm.h               |  16 +-
 arch/x86/include/uapi/asm/prctl.h             |  26 ++--
 arch/x86/kernel/fpu/core.c                    |  99 +++++++++++-
 arch/x86/kernel/fpu/xstate.c                  | 147 +++++++++++-------
 arch/x86/kernel/fpu/xstate.h                  |  19 ++-
 arch/x86/kernel/process.c                     |   2 +
 arch/x86/kvm/cpuid.c                          |  86 +++++++---
 arch/x86/kvm/cpuid.h                          |   2 +
 arch/x86/kvm/vmx/vmcs.h                       |   5 +
 arch/x86/kvm/vmx/vmx.c                        |  68 ++++++++
 arch/x86/kvm/vmx/vmx.h                        |   2 +-
 arch/x86/kvm/x86.c                            | 112 ++++++++++++-
 include/uapi/linux/kvm.h                      |   4 +
 tools/arch/x86/include/uapi/asm/kvm.h         |  16 +-
 tools/include/uapi/linux/kvm.h                |   3 +
 .../selftests/kvm/include/kvm_util_base.h     |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  10 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  32 ++++
 .../selftests/kvm/lib/x86_64/processor.c      |  67 +++++++-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |   2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |   2 +-
 .../testing/selftests/kvm/x86_64/state_test.c |   2 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c    |   2 +-
 28 files changed, 711 insertions(+), 107 deletions(-)

-- 
2.31.1

