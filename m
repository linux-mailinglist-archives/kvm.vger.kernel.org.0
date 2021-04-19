Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107A13647A1
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbhDSQCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:02:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238882AbhDSQCH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7buKlKcIzwYjYtSsOH62T0G/8Lr2YM3SFG1mxWF3n4I=;
        b=Cax9/WrbAySxtOAOEwtohVSQ/puBI/uuY6mIwjmtk58dGAkbmybMmewk3CSE+mKAzirpRD
        wPXjt20Y+kHoTc49W7rMbcCe7YTcPNDoUja3fu0ihppdC++wAMUxvnEbss5FC9HXG0h0lj
        TkoU04rQ3CikQABoVA6BUSA/woJIji4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-em6KCmNiM9qdl3VAMQbOww-1; Mon, 19 Apr 2021 12:01:33 -0400
X-MC-Unique: em6KCmNiM9qdl3VAMQbOww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 775168030D5;
        Mon, 19 Apr 2021 16:01:31 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E33CE2BFEC;
        Mon, 19 Apr 2021 16:01:28 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/30] KVM: x86: hyper-v: Fine-grained access check to Hyper-V hypercalls and MSRs
Date:   Mon, 19 Apr 2021 18:00:57 +0200
Message-Id: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since RFC:
- KVM_CAP_HYPERV_ENFORCE_CPUID introduced. Turns out that at least QEMU
  is not doing a great job setting Hyper-V CPUID entries for various
  configurations (when not all enlightenments are enabled).
- Added a selftest.
- Add Wei's A-b tag to PATCH1.

Currently, all implemented Hyper-V features (MSRs and hypercalls) are
available unconditionally to all Hyper-V enabled guests. This is not
ideal as KVM userspace may decide to provide only a subset of the
currently implemented features to emulate an older Hyper-V version,
to reduce attack surface,... Implement checks against guest visible
CPUIDs for all currently implemented MSRs and hypercalls.

Vitaly Kuznetsov (30):
  asm-generic/hyperv: add HV_STATUS_ACCESS_DENIED definition
  KVM: x86: hyper-v: Introduce KVM_CAP_HYPERV_ENFORCE_CPUID
  KVM: x86: hyper-v: Cache guest CPUID leaves determining features
    availability
  KVM: x86: hyper-v: Prepare to check access to Hyper-V MSRs
  KVM: x86: hyper-v: Honor HV_MSR_HYPERCALL_AVAILABLE privilege bit
  KVM: x86: hyper-v: Honor HV_MSR_VP_RUNTIME_AVAILABLE privilege bit
  KVM: x86: hyper-v: Honor HV_MSR_TIME_REF_COUNT_AVAILABLE privilege bit
  KVM: x86: hyper-v: Honor HV_MSR_VP_INDEX_AVAILABLE privilege bit
  KVM: x86: hyper-v: Honor HV_MSR_RESET_AVAILABLE privilege bit
  KVM: x86: hyper-v: Honor HV_MSR_REFERENCE_TSC_AVAILABLE privilege bit
  KVM: x86: hyper-v: Honor HV_MSR_SYNIC_AVAILABLE privilege bit
  KVM: x86: hyper-v: Honor HV_MSR_SYNTIMER_AVAILABLE privilege bit
  KVM: x86: hyper-v: Honor HV_MSR_APIC_ACCESS_AVAILABLE privilege bit
  KVM: x86: hyper-v: Honor HV_ACCESS_FREQUENCY_MSRS privilege bit
  KVM: x86: hyper-v: Honor HV_ACCESS_REENLIGHTENMENT privilege bit
  KVM: x86: hyper-v: Honor HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
    privilege bit
  KVM: x86: hyper-v: Honor HV_FEATURE_DEBUG_MSRS_AVAILABLE privilege bit
  KVM: x86: hyper-v: Inverse the default in hv_check_msr_access()
  KVM: x86: hyper-v: Honor HV_STIMER_DIRECT_MODE_AVAILABLE privilege bit
  KVM: x86: hyper-v: Prepare to check access to Hyper-V hypercalls
  KVM: x86: hyper-v: Check access to HVCALL_NOTIFY_LONG_SPIN_WAIT
    hypercall
  KVM: x86: hyper-v: Honor HV_POST_MESSAGES privilege bit
  KVM: x86: hyper-v: Honor HV_SIGNAL_EVENTS privilege bit
  KVM: x86: hyper-v: Honor HV_DEBUGGING privilege bit
  KVM: x86: hyper-v: Honor HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED bit
  KVM: x86: hyper-v: Honor HV_X64_CLUSTER_IPI_RECOMMENDED bit
  KVM: x86: hyper-v: Honor HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED bit
  KVM: selftests: move Hyper-V MSR definitions to hyperv.h
  KVM: selftests: Move evmcs.h to x86_64/
  KVM: selftests: Introduce hyperv_features test

 Documentation/virt/kvm/api.rst                |  11 +
 arch/x86/include/asm/kvm_host.h               |   9 +
 arch/x86/kvm/hyperv.c                         | 216 +++++-
 arch/x86/kvm/hyperv.h                         |   1 +
 arch/x86/kvm/x86.c                            |   4 +
 include/asm-generic/hyperv-tlfs.h             |   1 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/include/{ => x86_64}/evmcs.h          |   2 +-
 .../selftests/kvm/include/x86_64/hyperv.h     | 185 +++++
 .../selftests/kvm/x86_64/hyperv_clock.c       |   8 +-
 .../selftests/kvm/x86_64/hyperv_features.c    | 649 ++++++++++++++++++
 13 files changed, 1071 insertions(+), 18 deletions(-)
 rename tools/testing/selftests/kvm/include/{ => x86_64}/evmcs.h (99%)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/hyperv.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_features.c

-- 
2.30.2

