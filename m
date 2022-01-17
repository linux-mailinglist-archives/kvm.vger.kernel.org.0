Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E37490B1E
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbiAQPF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:05:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240342AbiAQPF5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 10:05:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642431956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XRC1So2PUXU9EUqrVYvvdmXgibZOxvXodE8fKDcbqgQ=;
        b=g33b0B3b3egGczFHjOdKVXviaXRutiYgsuFsaPSCg96DgWWvopZYqTXcBX4xiCJ50H5Zlg
        kYcEZpHJxtqfDkKn+au4K6cB2fs516LDppA1xiyg4uepqVm1CT7Ye5n2KcV9oLjbHln/K0
        Qb33UaQBA7Ibu2tyIe7yCMB61CpdFdM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-LjKgfq4FOy2f_RT_Tq0etg-1; Mon, 17 Jan 2022 10:05:55 -0500
X-MC-Unique: LjKgfq4FOy2f_RT_Tq0etg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 684BB1054F92;
        Mon, 17 Jan 2022 15:05:54 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 545812B59F;
        Mon, 17 Jan 2022 15:05:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
Date:   Mon, 17 Jan 2022 16:05:40 +0100
Message-Id: <20220117150542.2176196-3-vkuznets@redhat.com>
In-Reply-To: <20220117150542.2176196-1-vkuznets@redhat.com>
References: <20220117150542.2176196-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
forbade changing CPUID altogether but unfortunately this is not fully
compatible with existing VMMs. In particular, QEMU reuses vCPU fds for
CPU hotplug after unplug and it calls KVM_SET_CPUID2. Instead of full ban,
check whether the supplied CPUID data is equal to what was previously set.

Reported-by: Igor Mammedov <imammedo@redhat.com>
Fixes: feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   | 19 -------------------
 2 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 812190a707f6..c2e9c860fc3f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -119,6 +119,25 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
 }
 
+/* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
+static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+				 int nent)
+{
+	struct kvm_cpuid_entry2 *best;
+	int i;
+
+	for (i = 0; i < nent; i++) {
+		best = kvm_find_cpuid_entry(vcpu, e2[i].function, e2[i].index);
+		if (!best)
+			return -EINVAL;
+
+		if (e2[i].eax != best->eax || e2[i].ebx != best->ebx ||
+		    e2[i].ecx != best->ecx || e2[i].edx != best->edx)
+			return -EINVAL;
+	}
+
+	return 0;
+}
 static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 {
 	u32 function;
@@ -313,6 +332,20 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 
 	__kvm_update_cpuid_runtime(vcpu, e2, nent);
 
+	/*
+	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
+	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
+	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
+	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
+	 * the core vCPU model on the fly. It would've been better to forbid any
+	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
+	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
+	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
+	 * whether the supplied CPUID data is equal to what's already set.
+	 */
+	if (vcpu->arch.last_vmentry_cpu != -1)
+		return kvm_cpuid_check_equal(vcpu, e2, nent);
+
 	r = kvm_check_cpuid(vcpu, e2, nent);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76b4803dd3bd..ff1416010728 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5230,17 +5230,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
@@ -5251,14 +5240,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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

