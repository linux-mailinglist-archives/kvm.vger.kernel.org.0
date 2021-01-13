Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497EA2F4D4E
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbhAMOiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:38:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbhAMOiy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610548648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1oISxi4cwAd1j9TwXCFVU/K5vT9SVgURCoIs14qvGh0=;
        b=UAuUcYgKJRiQgF72o8Lufe5HewGzfxa8LuvxMk15jy3A4CuPdinVpjYHNXgzLco8E5SRDp
        0LKOFw9XVnHS2e5E3SpVGGzOTLUX6+b71sWOzlMSAQ1Z5knF94VToGR4cOmvSBn+jC729y
        8J1jZ3oIm6VTgQStqwYkSPbxV7Ywokw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-FAIIWUrJMuOmrVxrirW_RQ-1; Wed, 13 Jan 2021 09:37:27 -0500
X-MC-Unique: FAIIWUrJMuOmrVxrirW_RQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C14A8C7400;
        Wed, 13 Jan 2021 14:37:24 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E51F674AA0;
        Wed, 13 Jan 2021 14:37:22 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 0/7] KVM: x86: Conditional Hyper-V emulation enablement
Date:   Wed, 13 Jan 2021 15:37:14 +0100
Message-Id: <20210113143721.328594-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Vitaly Kuznetsov (7):
  selftests: kvm: Move kvm_get_supported_hv_cpuid() to common code
  selftests: kvm: Properly set Hyper-V CPUIDs in evmcs_test
  KVM: x86: hyper-v: Always use vcpu_to_hv_vcpu() accessor to get to
    'struct kvm_vcpu_hv'
  KVM: x86: hyper-v: Prepare to meet unallocated Hyper-V context
  KVM: x86: hyper-v: Allocate 'struct kvm_vcpu_hv' dynamically
  KVM: x86: hyper-v: Make Hyper-V emulation enablement conditional
  KVM: x86: hyper-v: Allocate Hyper-V context lazily

 arch/x86/include/asm/kvm_host.h               |   4 +-
 arch/x86/kvm/cpuid.c                          |   2 +
 arch/x86/kvm/hyperv.c                         | 104 +++++++++++++-----
 arch/x86/kvm/hyperv.h                         |  30 +++--
 arch/x86/kvm/lapic.c                          |   6 +-
 arch/x86/kvm/lapic.h                          |   6 +-
 arch/x86/kvm/vmx/vmx.c                        |   7 +-
 arch/x86/kvm/x86.c                            |  17 +--
 .../selftests/kvm/include/x86_64/processor.h  |   3 +
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++++++
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  39 ++++++-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |  31 +-----
 12 files changed, 203 insertions(+), 79 deletions(-)

-- 
2.29.2

