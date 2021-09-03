Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCC33FFB4B
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 09:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347810AbhICHxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 03:53:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234758AbhICHxT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 03:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630655539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aQb/pD/lGy790eUU19gat/WxkTfpYM66cOua1Oob24I=;
        b=htJLrE+8AqjfO9bnrCZCvZrHINRRvKI6XS1d9dWqJmHLHKWgNz5JrobznFxXyvsmNT6cM0
        TG8o6Uhq0iBW2UQ/t228yTu0o0MRs2Rye0GmPOkzhMXktwVMAmVgzFm32LXVzAXqIA/V2d
        I7Zb5x9PJBq1AZd1w4as75wQXW3SyYc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-IGwLnOP9Pxuf-jRW0lTRyA-1; Fri, 03 Sep 2021 03:52:18 -0400
X-MC-Unique: IGwLnOP9Pxuf-jRW0lTRyA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6483C10B7449;
        Fri,  3 Sep 2021 07:51:46 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A44C10016F5;
        Fri,  3 Sep 2021 07:51:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/8] KVM: Various fixes and improvements around kicking vCPUs
Date:   Fri,  3 Sep 2021 09:51:33 +0200
Message-Id: <20210903075141.403071-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v4 (Sean):
- Add Reviewed-by: tag to PATCHes 3 and 5.
- Drop unneeded 'vcpu' initialization from PATCH4.
- Return -ENOMEM from kvm_init() when cpumask allocation fails and drop
 unnecessary braces (PATCH 7).
- Drop cpumask_available() check from kvm_kick_many_cpus() and convert
 kvm_make_vcpu_request()'s parameter from 'cpumask_var_t' to 
 'struct cpumask *' (PATCH 8)

This series is a continuation to Sean's "[PATCH 0/2] VM: Fix a benign race
in kicking vCPUs" work and v2 for my "KVM: Optimize
kvm_make_vcpus_request_mask() a bit"/"KVM: x86: Fix stack-out-of-bounds
memory access from ioapic_write_indirect()" patchset.

From Sean:

"Fix benign races when kicking vCPUs where the task doing the kicking can
consume a stale vcpu->cpu.  The races are benign because of the
impliciations of task migration with respect to interrupts and being in
guest mode, but IMO they're worth fixing if only as an excuse to
document the flows.

Patch 2 is a tangentially related cleanup to prevent future me from
trying to get rid of the NULL check on the cpumask parameters, which
_looks_ like it can't ever be NULL, but has a subtle edge case due to the
way CONFIG_CPUMASK_OFFSTACK=y handles cpumasks."

Patch3 is a preparation to untangling kvm_make_all_cpus_request_except()
and kvm_make_vcpus_request_mask().

Patch4 is a minor optimization for kvm_make_vcpus_request_mask() for big
guests.

Patch5 is a minor cleanup.

Patch6 fixes a real problem with ioapic_write_indirect() KVM does
out-of-bounds access to stack memory.

Patches7 and 8 get rid of dynamic cpumask allocation for kicking vCPUs.

Sean Christopherson (2):
  KVM: Clean up benign vcpu->cpu data races when kicking vCPUs
  KVM: KVM: Use cpumask_available() to check for NULL cpumask when
    kicking vCPUs

Vitaly Kuznetsov (6):
  KVM: x86: hyper-v: Avoid calling kvm_make_vcpus_request_mask() with
    vcpu_mask==NULL
  KVM: Optimize kvm_make_vcpus_request_mask() a bit
  KVM: Drop 'except' parameter from kvm_make_vcpus_request_mask()
  KVM: x86: Fix stack-out-of-bounds memory access from
    ioapic_write_indirect()
  KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
  KVM: Make kvm_make_vcpus_request_mask() use pre-allocated
    cpu_kick_mask

 arch/x86/include/asm/kvm_host.h |   1 -
 arch/x86/kvm/hyperv.c           |  18 ++---
 arch/x86/kvm/ioapic.c           |  10 +--
 arch/x86/kvm/x86.c              |   8 +--
 include/linux/kvm_host.h        |   3 +-
 virt/kvm/kvm_main.c             | 115 +++++++++++++++++++++++---------
 6 files changed, 101 insertions(+), 54 deletions(-)

-- 
2.31.1

