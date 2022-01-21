Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D517495FC8
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 14:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380782AbiAUN3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 08:29:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380714AbiAUN3J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 08:29:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642771748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XcWu6s4pN5jlEkVju4/UBrdbowSjhtmAIaPpgML9RtY=;
        b=DZxgFXkGayLgzZ9GtHQ0sVX+gXyAjBv2oYUPK9PIscYkyHY5Cgr9psFaF1ig1xq4vcXb+5
        ZJaS2EdVj91u+o8Gjxx4U6HpTPXSaVQBufwqlFYFxlZhXaS6n4pVS+O4yMdGIbjq1t6VqZ
        8PPNkwTPk3RwTkslTiWIujaSl53qulU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-HZhNq7LqNTe5hEetPfEeuQ-1; Fri, 21 Jan 2022 08:29:05 -0500
X-MC-Unique: HZhNq7LqNTe5hEetPfEeuQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FC6084DA41;
        Fri, 21 Jan 2022 13:29:04 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E8457E228;
        Fri, 21 Jan 2022 13:29:01 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/5] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
Date:   Fri, 21 Jan 2022 14:28:50 +0100
Message-Id: <20220121132852.2482355-4-vkuznets@redhat.com>
In-Reply-To: <20220121132852.2482355-1-vkuznets@redhat.com>
References: <20220121132852.2482355-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 arch/x86/kvm/cpuid.c | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   | 19 -------------------
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7c48daee6670..96556bf494fc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -119,6 +119,19 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
 }
 
+/* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
+static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+				 int nent)
+{
+	if (nent != vcpu->arch.cpuid_nent)
+		return -EINVAL;
+
+	if (memcmp(e2, vcpu->arch.cpuid_entries, nent * sizeof(*e2)))
+		return -EINVAL;
+
+	return 0;
+}
+
 static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 {
 	u32 function;
@@ -325,6 +338,24 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 
 	__kvm_update_cpuid_runtime(vcpu, e2, nent);
 
+	/*
+	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
+	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
+	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
+	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
+	 * the core vCPU model on the fly. To avoid potential hard to debug
+	 * problems, forbid changing CPUID data after successfully entering the
+	 * guest. Banning KVM_SET_CPUID{,2} altogether is incompatible with
+	 * certain VMMs (e.g. QEMU) which reuse vCPU fds for CPU hotplug as
+	 * KVM_SET_CPUID{,2} call (with the same CPUID data) may be issued again
+	 * upon hotplug.
+	 * Note, there are other problematic scenarios which are currently not
+	 * being handled, e.g. supplying different CPUID data for different
+	 * vCPUs also won't be handled correctly by KVM MMU.
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

