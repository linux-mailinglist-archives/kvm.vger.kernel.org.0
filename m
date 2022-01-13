Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D5948D922
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 14:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbiAMNhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 08:37:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235332AbiAMNhc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 08:37:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642081051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wZ7iMB67P+9Li/lwf/QAPR5SYAwUFLNT/MhfqUtdg2I=;
        b=gK28qB6Zf0JXFsu4rYnsZR0uBEPS6zkgeezUTNEkWrQK5fJKl58ikk/bR/g388vh/YBCoP
        fc9NpUc17w0Xkl2kGMQr9AkWrHvHXK5rD2W5gfa2duEhFxS7G7ySFH77Qg3HlZJG4UE/lm
        3AzK/t7bjk+uekNFiCx2JgOKCTU/Tto=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-RBo32oHdO7uAxCr1z29GLw-1; Thu, 13 Jan 2022 08:37:28 -0500
X-MC-Unique: RBo32oHdO7uAxCr1z29GLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7CB087111D;
        Thu, 13 Jan 2022 13:37:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 991A484A1C;
        Thu, 13 Jan 2022 13:37:24 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
Date:   Thu, 13 Jan 2022 14:37:01 +0100
Message-Id: <20220113133703.1976665-4-vkuznets@redhat.com>
In-Reply-To: <20220113133703.1976665-1-vkuznets@redhat.com>
References: <20220113133703.1976665-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
forbade changing CPUID altogether but unfortunately this is not fully
compatible with existing VMMs. In particular, QEMU reuses vCPU fds for
CPU hotplug after unplug and it calls KVM_SET_CPUID2. Checking for
full equality of the data with what's in 'vcpu->arch.cpuid_entries' is
not feasible for two reasons: the data is tweaked by KVM itself
(__kvm_update_cpuid_runtime()) and QEMU may use vCPU fd for some other
virtual CPU so it may want to change LAPIC/x2APIC ids. Relax the
requirement by implementing an allowlist of entries which are allowed
to change.

Reported-by: Igor Mammedov <imammedo@redhat.com>
Fixes: feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 70 +++++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c   | 19 ------------
 2 files changed, 66 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c4d4c350afbe..4a8e1c8ada6c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -80,9 +80,11 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	return NULL;
 }
 
-static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
+static int kvm_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
+			   int nent, bool is_update)
 {
-	struct kvm_cpuid_entry2 *best;
+	struct kvm_cpuid_entry2 *best, *e;
+	int i;
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -96,6 +98,59 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 			return -EINVAL;
 	}
 
+	if (!is_update)
+		return 0;
+
+	/*
+	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
+	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
+	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
+	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
+	 * the core vCPU model on the fly. It would've been better to forbid any
+	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
+	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and they
+	 * need to set CPUID to e.g. change [x2]APIC id. Implement an allowlist
+	 * of CPUIDs which are allowed to change.
+	 */
+	for (i = 0; i < nent; i++) {
+		e = &entries[i];
+
+		best = kvm_find_cpuid_entry(vcpu, e->function, e->index);
+		if (!best)
+			return -EINVAL;
+
+		switch (e->function) {
+		case 0x1:
+			/* Only initial LAPIC id is allowed to change */
+			if (e->eax != best->eax ||
+			    (e->ebx & ~0xff000000u) != (best->ebx & ~0xff000000u) ||
+			     e->ecx != best->ecx || e->edx != best->edx)
+				return -EINVAL;
+			break;
+		case 0x3:
+			/* processor serial number */
+		case 0x4:
+			/* cache parameters */
+		case 0xb:
+		case 0x1f:
+			/* x2APIC id and CPU topology */
+		case 0x80000005:
+			/* AMD l1 cache information */
+		case 0x80000006:
+			/* l2 cache information */
+		case 0x8000001d:
+			/* AMD cache topology */
+		case 0x8000001e:
+			/* AMD processor topology */
+			break;
+		default:
+			if (e->eax != best->eax || e->ebx != best->ebx ||
+			    e->ecx != best->ecx || e->edx != best->edx)
+				return -EINVAL;
+			break;
+		}
+	}
+
 	return 0;
 }
 
@@ -290,10 +345,11 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
 	int r;
+	bool is_update = vcpu->arch.last_vmentry_cpu != -1;
 
 	__kvm_update_cpuid_runtime(vcpu, e2, nent);
 
-	r = kvm_check_cpuid(e2, nent);
+	r = kvm_check_cpuid(vcpu, e2, nent, is_update);
 	if (r)
 		return r;
 
@@ -302,7 +358,13 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_nent = nent;
 
 	kvm_update_kvm_cpuid_base(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);
+
+	/*
+	 * KVM_SET_CPUID{,2} after KVM_RUN is not allowed to change vCPU features, see
+	 * kvm_check_cpuid().
+	 */
+	if (!is_update)
+		kvm_vcpu_after_set_cpuid(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 829d03fcb481..935b60c37c6d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5148,17 +5148,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid __user *cpuid_arg = argp;
 		struct kvm_cpuid cpuid;
 
-		/*
-		 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
-		 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
-		 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
-		 * faults due to reusing SPs/SPTEs.  In practice no sane VMM mucks with
-		 * the core vCPU model on the fly, so fail.
-		 */
-		r = -EINVAL;
-		if (vcpu->arch.last_vmentry_cpu != -1)
-			goto out;
-
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
@@ -5169,14 +5158,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid2 __user *cpuid_arg = argp;
 		struct kvm_cpuid2 cpuid;
 
-		/*
-		 * KVM_SET_CPUID{,2} after KVM_RUN is forbidded, see the comment in
-		 * KVM_SET_CPUID case above.
-		 */
-		r = -EINVAL;
-		if (vcpu->arch.last_vmentry_cpu != -1)
-			goto out;
-
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
-- 
2.34.1

