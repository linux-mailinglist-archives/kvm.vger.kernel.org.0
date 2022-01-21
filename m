Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD80495FC2
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 14:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380700AbiAUN3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 08:29:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380699AbiAUN3B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 08:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642771740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P+l3L/j9Eu3Wgxbpi7SxLlX6lvZGaYKNloUWEV08+bI=;
        b=Tw1fo0ciUbXZx+n1vHgl2+GOlkgkSXWmiKyMAfpn/MSYu70Ht0nn87qWsUIyducA1yKLMQ
        agQQvDTsN8kI47m4mkKZ4G95VMbjpyLg0pvWwHiDkP8YQ8lSYxoUzYmDIYfm4rPcLm8Mha
        SiPTp6cI/1PpncPo6LQZiIIE/M2ypeQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-jnFO5ECkPzKbuNQ0SfN45A-1; Fri, 21 Jan 2022 08:28:57 -0500
X-MC-Unique: jnFO5ECkPzKbuNQ0SfN45A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18DB584DA40;
        Fri, 21 Jan 2022 13:28:56 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7634B7E228;
        Fri, 21 Jan 2022 13:28:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug
Date:   Fri, 21 Jan 2022 14:28:47 +0100
Message-Id: <20220121132852.2482355-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v3:
- Use memcmp() [Sean].
- Update the comment in kvm_set_cpuid() making (hopefully) it more clear
 that the introduced check does not cover all potentially problemmatic
 scenarios [Sean].
- Add "KVM: x86: Move CPUID.(EAX=0x12,ECX=1) mangling to
 __kvm_update_cpuid_runtime()" patch.

Original description:

Recently, KVM made it illegal to change CPUID after KVM_RUN but
unfortunately this change is not fully compatible with existing VMMs.
In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
calls KVM_SET_CPUID2. Relax the requirement by implementing an allowing
KVM_SET_CPUID{,2} with the exact same data.

Vitaly Kuznetsov (5):
  KVM: x86: Do runtime CPUID update before updating
    vcpu->arch.cpuid_entries
  KVM: x86: Move CPUID.(EAX=0x12,ECX=1) mangling to
    __kvm_update_cpuid_runtime()
  KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
  KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
  KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN

 arch/x86/kvm/cpuid.c                          | 119 +++++++++++++-----
 arch/x86/kvm/x86.c                            |  19 ---
 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   4 +-
 .../selftests/kvm/include/x86_64/processor.h  |   7 ++
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++++-
 .../x86_64/{get_cpuid_test.c => cpuid_test.c} |  30 +++++
 7 files changed, 157 insertions(+), 57 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (83%)

-- 
2.34.1

