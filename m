Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1875429544B
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 23:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506273AbgJUVgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 17:36:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506253AbgJUVge (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 17:36:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603316193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6+HPUwysBYP7wqKa1dhDe87/mU8XIlbid5TDmgjrd1s=;
        b=L+1el1S9XauRKvL9CObezS1Vb+MOAsbwuZNgN3LnulxlPgoOo07gO1S5c4Nig0Ogh4tMKR
        mIv1yDl+wmu4al7/RF30u0o3oKhnNsGnZ5U70lUbTwaR2Rt2x9tKW0DpsRw2AeyiMEKjD/
        S8zB1xzEz9LGQJy/Zkh3mN+ieC0Fp4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-qjbi3N9qNhuKPc2tx5Gljw-1; Wed, 21 Oct 2020 17:36:31 -0400
X-MC-Unique: qjbi3N9qNhuKPc2tx5Gljw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C50F1804024;
        Wed, 21 Oct 2020 21:36:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3C3F5B4A1;
        Wed, 21 Oct 2020 21:36:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     graf@amazon.com, Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
Date:   Wed, 21 Oct 2020 17:36:25 -0400
Message-Id: <20201021213625.2377378-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allowing userspace to intercept reads to x2APIC MSRs when APICV is
fully enabled for the guest simply can't work.   But more in general,
the LAPIC could be set to in-kernel after the MSR filter is setup
and allowing accesses by userspace would be very confusing.

We could in principle allow userspace to intercept reads and writes to TPR,
and writes to EOI and SELF_IPI, but while that could be made it work, it
would still be silly.

Cc: Alexander Graf <graf@amazon.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 18 ++++++++++--------
 arch/x86/kvm/x86.c             |  9 ++++++++-
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bd94105f2960..9ece9a827a58 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4777,20 +4777,22 @@ specify whether a certain MSR access should be explicitly filtered for or not.
 If this ioctl has never been invoked, MSR accesses are not guarded and the
 default KVM in-kernel emulation behavior is fully preserved.
 
+Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
+filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
+an error.
+
 As soon as the filtering is in place, every MSR access is processed through
 the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff);
 x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
 and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
 register.
 
-If a bit is within one of the defined ranges, read and write
-accesses are guarded by the bitmap's value for the MSR index. If it is not
-defined in any range, whether MSR access is rejected is determined by the flags
-field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW`` and
-``KVM_MSR_FILTER_DEFAULT_DENY``.
-
-Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
-filtering. In that mode, KVM_MSR_FILTER_DEFAULT_DENY no longer has any effect.
+If a bit is within one of the defined ranges, read and write accesses are
+guarded by the bitmap's value for the MSR index if the kind of access
+is included in the ``struct kvm_msr_filter_range`` flags.  If no range
+cover this particular access, the behavior is determined by the flags
+field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW``
+and ``KVM_MSR_FILTER_DEFAULT_DENY``.
 
 Each bitmap range specifies a range of MSRs to potentially allow access on.
 The range goes from MSR index [base .. base+nmsrs]. The flags field
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08cfb5e4bd07..0f02d0fe3abb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5252,14 +5252,21 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	struct kvm_msr_filter filter;
 	bool default_allow;
 	int r = 0;
+	bool empty = true;
 	u32 i;
 
 	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
 		return -EFAULT;
 
-	kvm_clear_msr_filter(kvm);
+	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
+		empty &= !filter.ranges[i].nmsrs;
 
 	default_allow = !(filter.flags & KVM_MSR_FILTER_DEFAULT_DENY);
+	if (empty && !default_allow)
+		return -EINVAL;
+
+	kvm_clear_msr_filter(kvm);
+
 	kvm->arch.msr_filter.default_allow = default_allow;
 
 	/*
-- 
2.26.2

