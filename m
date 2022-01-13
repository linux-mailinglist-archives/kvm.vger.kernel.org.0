Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C23E48D917
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 14:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiAMNhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 08:37:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32830 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235284AbiAMNhY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 08:37:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642081044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dwJK1y+tLTc2sbN3KuFxFocd1+lOlCoMGQ0ACbyDWGs=;
        b=SebRbctnxERRrg+BYbLqMLSzfJgzLUzUzVc3QZ+QU3z/Ub6KYbi9gnz/E7EedOkEwmjJRb
        eiFW8ApxNjAaEko6EN+Dv+qawBNuABQuttRCeUow4cML6rDMW7tDxhIvKhUAWKi/7l8aj8
        JbTUWEBOBqe9Hcwc89UHov3e8fgHo1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-6mgDpTk4P9y3G56OBcxa0w-1; Thu, 13 Jan 2022 08:37:20 -0500
X-MC-Unique: 6mgDpTk4P9y3G56OBcxa0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 744D41083F64;
        Thu, 13 Jan 2022 13:37:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D5CE84A26;
        Thu, 13 Jan 2022 13:37:04 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug
Date:   Thu, 13 Jan 2022 14:36:58 +0100
Message-Id: <20220113133703.1976665-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently, KVM made it illegal to change CPUID after KVM_RUN but
unfortunately this change is not fully compatible with existing VMMs.
In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
calls KVM_SET_CPUID2. Relax the requirement by implementing an allowlist
of entries which are allowed to change.

Going forward, VMMs are supposed to change the behavior. There is no real
need to change CPUID information. For hotplug purposes (and if reusing vCPU
fds is still considered being worthy), VMMs can be a bit smarter and always
pick the fd with the required LAPIC/x2APIC id to eliminate the need to
change this info later.

Vitaly Kuznetsov (5):
  KVM: x86: Fix indentation in kvm_set_cpuid()
  KVM: x86: Do runtime CPUID update before updating
    vcpu->arch.cpuid_entries
  KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
  KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
  KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN

 arch/x86/kvm/cpuid.c                          | 120 ++++++++++++++----
 arch/x86/kvm/x86.c                            |  19 ---
 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   5 +-
 .../selftests/kvm/include/x86_64/processor.h  |   7 +
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++++-
 .../x86_64/{get_cpuid_test.c => cpuid_test.c} |  78 ++++++++++++
 7 files changed, 216 insertions(+), 48 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (66%)

-- 
2.34.1

