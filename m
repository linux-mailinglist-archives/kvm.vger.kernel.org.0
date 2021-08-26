Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7FB3F8753
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 14:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbhHZMZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:25:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229785AbhHZMZq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:25:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629980698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OtB3A12o+ywxDnJB/0RXDbpGMHCGMH2GQSIrRJ5VEEY=;
        b=IymgNQEiIlIUMMzksaqA0rLHQY/3fEIFHQWPrCPIgjJYaoOrrEQMbKWmunSQntWvu9R/QM
        0+dGXhRE0n10qTH4wf5cc6bI67PkicRui2O16ynxRc5RT1xR+JdPonOjBkYr2RFmX485ti
        TDq9GIMYEa4G1bKtKkJ7d8Lxgm1fqYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-1OeVuYPYPDO39qXQNSfBmQ-1; Thu, 26 Aug 2021 08:24:55 -0400
X-MC-Unique: 1OeVuYPYPDO39qXQNSfBmQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8FEF87D541;
        Thu, 26 Aug 2021 12:24:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDA5560877;
        Thu, 26 Aug 2021 12:24:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] KVM: Various fixes and improvements around kicking vCPUs
Date:   Thu, 26 Aug 2021 14:24:38 +0200
Message-Id: <20210826122442.966977-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v2:
- Replace Sean's "KVM: Guard cpusmask NULL check with CONFIG_CPUMASK_OFFSTACK"
 patch with "KVM: KVM: Use cpumask_available() to check for NULL cpumask when
 kicking vCPUs" [Lai Jiangshan]
- Use 'DECLARE_BITMAP' in ioapic_write_indirect [Sean Christopherson]
- Add Maxim's 'Reviewed-by' tag to PATCH4.

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

Patch3 is a minor optimization for kvm_make_vcpus_request_mask() for big
guests.

Patch4 fixes a real problem with ioapic_write_indirect() KVM does
out-of-bounds access to stack memory.

Sean Christopherson (2):
  KVM: Clean up benign vcpu->cpu data races when kicking vCPUs
  KVM: KVM: Use cpumask_available() to check for NULL cpumask when
    kicking vCPUs

Vitaly Kuznetsov (2):
  KVM: Optimize kvm_make_vcpus_request_mask() a bit
  KVM: x86: Fix stack-out-of-bounds memory access from
    ioapic_write_indirect()

 arch/x86/kvm/ioapic.c | 10 ++---
 virt/kvm/kvm_main.c   | 89 +++++++++++++++++++++++++++++++++----------
 2 files changed, 73 insertions(+), 26 deletions(-)

-- 
2.31.1

