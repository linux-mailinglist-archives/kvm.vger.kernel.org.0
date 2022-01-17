Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C49A490B1C
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbiAQPFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:05:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240340AbiAQPFz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 10:05:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642431954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EbDM4wu2EfidM+Hk/2ULEy/PRDdj2I7ZEN6bIKgp+Oo=;
        b=L270cDEk6d7+eUYwirLQLtSy/W8xmWgTUDOre+q3/ayT3ctlL323v2F+eI6N7vI5Uugt3h
        JBjD390dH7F1QZiAw8uABYocycNmbHPpck3B9FOhhBOMvV2xXLqrUPJz4Hkr+5g2o6Wqms
        aBp2eS0xHZ1DQlzR39xcneZTAJAt/5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-YMwTSTYbMy6PWuxla2v57Q-1; Mon, 17 Jan 2022 10:05:51 -0500
X-MC-Unique: YMwTSTYbMy6PWuxla2v57Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73AFB1853028;
        Mon, 17 Jan 2022 15:05:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C9312B5AB;
        Mon, 17 Jan 2022 15:05:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug
Date:   Mon, 17 Jan 2022 16:05:38 +0100
Message-Id: <20220117150542.2176196-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- Drop the allowlist of items which were allowed to change and just allow
the exact same CPUID data [Sean, Paolo]. Adjust selftest accordingly.
- Drop PATCH1 as the exact same change got merged upstream.

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

 arch/x86/kvm/cpuid.c                          | 67 ++++++++++++++++---
 arch/x86/kvm/x86.c                            | 19 ------
 tools/testing/selftests/kvm/.gitignore        |  2 +-
 tools/testing/selftests/kvm/Makefile          |  4 +-
 .../selftests/kvm/include/x86_64/processor.h  |  7 ++
 .../selftests/kvm/lib/x86_64/processor.c      | 33 +++++++--
 .../x86_64/{get_cpuid_test.c => cpuid_test.c} | 30 +++++++++
 7 files changed, 126 insertions(+), 36 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (83%)

-- 
2.34.1

