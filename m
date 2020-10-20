Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF77292C47
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730897AbgJSRFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 13:05:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730635AbgJSRFb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 13:05:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603127130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8T33BC/57dNGym7wEnyJvGdAxGs0P1jblpQACkcYHg0=;
        b=NFwUCbZ4jj4P5XxAO2BtNK7+hyi13lr2nyUtEJ+q3tHEuNSSK8q3QHtPtPtjdzdf7yp78K
        GRjATeZTDyOqPEbGNU97tvBLPdaFAZVN9sqZHcJmibdZ+z7pVSMr3K1z45hj1zcsQY61Uv
        oDNV2+97Y691Q/V1Xy0H/bHglExSees=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-tOZTp_APOFifK1536HR7MQ-1; Mon, 19 Oct 2020 13:05:26 -0400
X-MC-Unique: tOZTp_APOFifK1536HR7MQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52903D6883;
        Mon, 19 Oct 2020 17:05:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E78F5C22A;
        Mon, 19 Oct 2020 17:05:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Alexander Graf <graf@amazon.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
Date:   Mon, 19 Oct 2020 13:05:19 -0400
Message-Id: <20201019170519.1855564-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allowing userspace to intercept reads to x2APIC MSRs when APICV is
fully enabled for the guest simply can't work.   But more in general,
if the LAPIC is in-kernel, allowing accessed by userspace would be very
confusing.  If userspace wants to intercept x2APIC MSRs, then it should
first disable in-kernel APIC.

We could in principle allow userspace to intercept reads and writes to TPR,
and writes to EOI and SELF_IPI, but while that could be made it work, it
would still be silly.

Cc: Alexander Graf <graf@amazon.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4015a43cc8a..0faf733538f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5246,6 +5246,13 @@ static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user
 	return r;
 }
 
+static bool range_overlaps_x2apic(struct kvm_msr_filter_range *range)
+{
+	u32 start = range->base;
+	u32 end = start + range->nmsrs;
+	return start <= 0x8ff && end > 0x800;
+}
+
 static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_msr_filter __user *user_msr_filter = argp;
@@ -5257,6 +5264,16 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
 		return -EFAULT;
 
+	/*
+	 * In principle it would be possible to trap x2apic ranges
+	 * if !lapic_in_kernel.  This however would be complicated
+	 * because KVM_X86_SET_MSR_FILTER can be called before
+	 * KVM_CREATE_IRQCHIP or KVM_ENABLE_CAP.
+	 */
+	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
+		if (range_overlaps_x2apic(&filter.ranges[i]))
+			return -EINVAL;
+
 	kvm_clear_msr_filter(kvm);
 
 	default_allow = !(filter.flags & KVM_MSR_FILTER_DEFAULT_DENY);
-- 
2.26.2

