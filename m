Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ABA303F80
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 15:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405616AbhAZN7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:59:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404918AbhAZNtu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PDlj9UJuoXlG2+dcv/eqawylXilbohUP5Xl1nIN0jeA=;
        b=cjEMLZjCVs+49bwzHd/s2Bl1Jg1T4QJf+z5YxK1EpFlJoiPgfW9zCGYtW1M3HKp8F4V4/a
        TgZCgNirg7E5Ugn8v35yJlKkZ3qAr+/FO3wo8hFDyeflEi733Y29WJFN2FGLn6Sbaj55Js
        qzoyrFNZrtquIQkA9bnATjkGjZRc3Pc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-OzhTGYyQMlKCuUCYUX8Uug-1; Tue, 26 Jan 2021 08:48:21 -0500
X-MC-Unique: OzhTGYyQMlKCuUCYUX8Uug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29476801AA7;
        Tue, 26 Jan 2021 13:48:20 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3CB45D9C2;
        Tue, 26 Jan 2021 13:48:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 00/15] KVM: x86: Conditional Hyper-V emulation enablement
Date:   Tue, 26 Jan 2021 14:48:01 +0100
Message-Id: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1 [Sean]:
- Add a few cleanup patches ("Rename vcpu_to_hv_vcpu() to to_hv_vcpu()",
  "Rename vcpu_to_synic()/synic_to_vcpu()", ...)
- Drop unused kvm_hv_vapic_assist_page_enabled()
- Stop shadowing global 'current_vcpu' variable in kvm_hv_flush_tlb()/
  kvm_hv_send_ipi()

Original description:

Hyper-V emulation is enabled in KVM unconditionally even for Linux guests.
This is bad at least from security standpoint as it is an extra attack
surface. Ideally, there should be a per-VM capability explicitly enabled by
VMM but currently it is not the case and we can't mandate one without
breaking backwards compatibility. We can, however, check guest visible CPUIDs
and only enable Hyper-V emulation when "Hv#1" interface was exposed in
HYPERV_CPUID_INTERFACE.

Also (and while on it) per-vcpu Hyper-V context ('struct kvm_vcpu_hv') is
currently part of 'struct kvm_vcpu_arch' and thus allocated unconditionally
for each vCPU. The context, however, quite big and accounts for more than
1/4 of 'struct kvm_vcpu_arch' (e.g. 2912/9512 bytes). Switch to allocating
it dynamically. This may come handy if we ever decide to raise KVM_MAX_VCPUS
(and rumor has it some downstream distributions already have more than '288')

Vitaly Kuznetsov (15):
  selftests: kvm: Move kvm_get_supported_hv_cpuid() to common code
  selftests: kvm: Properly set Hyper-V CPUIDs in evmcs_test
  KVM: x86: hyper-v: Drop unused kvm_hv_vapic_assist_page_enabled()
  KVM: x86: hyper-v: Rename vcpu_to_hv_vcpu() to to_hv_vcpu()
  KVM: x86: hyper-v: Rename vcpu_to_synic()/synic_to_vcpu()
  KVM: x86: hyper-v: Rename vcpu_to_stimer()/stimer_to_vcpu()
  KVM: x86: hyper-v: Rename vcpu_to_hv_syndbg() to to_hv_syndbg()
  KVM: x86: hyper-v: Introduce to_kvm_hv() helper
  KVM: x86: hyper-v: Stop shadowing global 'current_vcpu' variable
  KVM: x86: hyper-v: Always use to_hv_vcpu() accessor to get to 'struct
    kvm_vcpu_hv'
  KVM: x86: hyper-v: Prepare to meet unallocated Hyper-V context
  KVM: x86: hyper-v: Allocate 'struct kvm_vcpu_hv' dynamically
  KVM: x86: hyper-v: Make Hyper-V emulation enablement conditional
  KVM: x86: hyper-v: Allocate Hyper-V context lazily
  KVM: x86: hyper-v: Drop hv_vcpu_to_vcpu() helper

 arch/x86/include/asm/kvm_host.h               |   4 +-
 arch/x86/kvm/cpuid.c                          |   2 +
 arch/x86/kvm/hyperv.c                         | 301 +++++++++++-------
 arch/x86/kvm/hyperv.h                         |  54 ++--
 arch/x86/kvm/lapic.c                          |   5 +-
 arch/x86/kvm/lapic.h                          |   7 +-
 arch/x86/kvm/vmx/vmx.c                        |   9 +-
 arch/x86/kvm/x86.c                            |  19 +-
 .../selftests/kvm/include/x86_64/processor.h  |   3 +
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  39 ++-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |  31 +-
 12 files changed, 314 insertions(+), 193 deletions(-)

-- 
2.29.2

