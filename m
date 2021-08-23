Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139F93F4C5A
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 16:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhHWObY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 10:31:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230040AbhHWObY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 10:31:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629729041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/eh0h+3M1/EQ0xIV9YAbz4kQ7bCgK+sDeXRpZ7vSkn8=;
        b=JMJTaAER38Uk3dX6pzxSN8HqOksaNTN2MCm4XvxLOM3qj//maPZF+s6IzGG6MxnCriDjsI
        DIg9LQR83CxhUhKwPu+korkjEFhb9ScXfqY3ciuSRtR2nfRxk2GQgFj3cX7Kqhv/LzkV17
        jQlaopH1CV7R/UQvFANtQ+xbtNII7BQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-5EZgzsSeOBOG_UOi-Z3umg-1; Mon, 23 Aug 2021 10:30:39 -0400
X-MC-Unique: 5EZgzsSeOBOG_UOi-Z3umg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 852AE87D542;
        Mon, 23 Aug 2021 14:30:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5A602707F;
        Mon, 23 Aug 2021 14:30:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: Various fixes and improvements around kicking vCPUs
Date:   Mon, 23 Aug 2021 16:30:24 +0200
Message-Id: <20210823143028.649818-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is a continuation to Sean's "[PATCH 0/2] VM: Fix a benign race
in kicking vCPUs" work and v2 for my "KVM: Optimize
kvm_make_vcpus_request_mask() a bit"/"KVM: x86: Fix stack-out-of-bounds
memory access from ioapic_write_indirect()" patchset.

Changes since v1:
- Drop inappropriate added 'likely' from kvm_make_vcpus_request_mask [Sean]
- Keep get_cpu()/put_cpu() and pass 'current_cpu' parameter to 
 kvm_make_vcpu_request() as a minor optimization [Sean]

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

Patch3 is a minor optimization for kvm_make_vcpus_request_mask() for big
guests.

Patch4 fixes a real problem with ioapic_write_indirect() KVM does
out-of-bounds access to stack memory.

Sean Christopherson (2):
  KVM: Clean up benign vcpu->cpu data races when kicking vCPUs
  KVM: Guard cpusmask NULL check with CONFIG_CPUMASK_OFFSTACK

Vitaly Kuznetsov (2):
  KVM: Optimize kvm_make_vcpus_request_mask() a bit
  KVM: x86: Fix stack-out-of-bounds memory access from
    ioapic_write_indirect()

 arch/x86/kvm/ioapic.c | 10 +++---
 virt/kvm/kvm_main.c   | 83 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 68 insertions(+), 25 deletions(-)

-- 
2.31.1

