Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C0B492829
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 15:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiAROSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 09:18:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233736AbiAROSI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 09:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642515487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LaoOdZeqAvoTwa6+riHOKr5I9NqWvC95zGV+ZFgaJBE=;
        b=Dh4OFRChJ84r0Y6kMHk3fiDb5T+a5mL0g/LN0KhVrDV+ZAKGiFFGlkrK9QVDFNR5oAqHAb
        pTGmmWepeWNvs8zL1rN6Xh/XYz3AC9bu2x3SnGHK807LiZD82rmDeIaezpbvFCzMzed7gP
        hovgokv/vnIC2FC50sDxXV3HHABvtHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-EQOCP24nNYSJ23XCTjew-Q-1; Tue, 18 Jan 2022 09:18:06 -0500
X-MC-Unique: EQOCP24nNYSJ23XCTjew-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BEE684B9A4;
        Tue, 18 Jan 2022 14:18:05 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3970C7E2C6;
        Tue, 18 Jan 2022 14:18:02 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug
Date:   Tue, 18 Jan 2022 15:17:57 +0100
Message-Id: <20220118141801.2219924-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v2:
- Tighten the check for CPUID data equality, require CPUID entries for the
update to be supplied in the exact same order as the original data [Paolo]

Recently, KVM made it illegal to change CPUID after KVM_RUN but
unfortunately this change is not fully compatible with existing VMMs.
In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
calls KVM_SET_CPUID2. Relax the requirement by implementing an allowing
KVM_SET_CPUID{,2} with the exact same data.

Vitaly Kuznetsov (4):
  KVM: x86: Do runtime CPUID update before updating
    vcpu->arch.cpuid_entries
  KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
  KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
  KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN

 arch/x86/kvm/cpuid.c                          | 70 ++++++++++++++++---
 arch/x86/kvm/x86.c                            | 19 -----
 tools/testing/selftests/kvm/.gitignore        |  2 +-
 tools/testing/selftests/kvm/Makefile          |  4 +-
 .../selftests/kvm/include/x86_64/processor.h  |  7 ++
 .../selftests/kvm/lib/x86_64/processor.c      | 33 +++++++--
 .../x86_64/{get_cpuid_test.c => cpuid_test.c} | 30 ++++++++
 7 files changed, 129 insertions(+), 36 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (83%)

-- 
2.34.1

