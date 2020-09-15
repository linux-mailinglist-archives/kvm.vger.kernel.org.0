Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6DA26B290
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 00:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgIOWtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 18:49:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29612 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727459AbgIOPnt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 11:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600184610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XXFy/q65vk1jisWRQyxPpPLWskYCS/ybqHocfTlHIhM=;
        b=il0gFn7FVD2it0uil+cFzYmlpK6yDm4WO5HNfYBnopbt2gikMTNTYSFF8kxlw+im9NEPFJ
        m3+G+yLl3kMJO8+CclUsP3PQM5z1nqsWB564RpHqiCHSzbfKYdI7dq4SQRq7OkagYamAv0
        pG+bSIUyp7ebEGOjoyZ5age3Lfyw3ms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-6yHQjql2OuyEZgQS79cm9w-1; Tue, 15 Sep 2020 11:43:25 -0400
X-MC-Unique: 6yHQjql2OuyEZgQS79cm9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6856C1963FE6;
        Tue, 15 Sep 2020 15:43:13 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23E9C1992D;
        Tue, 15 Sep 2020 15:43:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/2] KVM: x86: allocate vcpu->arch.cpuid_entries dynamically
Date:   Tue, 15 Sep 2020 17:43:05 +0200
Message-Id: <20200915154306.724953-2-vkuznets@redhat.com>
In-Reply-To: <20200915154306.724953-1-vkuznets@redhat.com>
References: <20200915154306.724953-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current limit for guest CPUID leaves (KVM_MAX_CPUID_ENTRIES, 80)
is reported to be insufficient but before we bump it let's switch to
allocating vcpu->arch.cpuid_entries dynamically. Currenly,
'struct kvm_cpuid_entry2' is 40 bytes so vcpu->arch.cpuid_entries is
3200 bytes which accounts for 1/4 of the whole 'struct kvm_vcpu_arch'
but having it pre-allocated (for all vCPUs which we also pre-allocate)
gives us no benefits.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/cpuid.c            | 55 ++++++++++++++++++++++++---------
 arch/x86/kvm/x86.c              |  1 +
 3 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5303dbc5c9bc..0c5f2ca3e838 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -636,7 +636,7 @@ struct kvm_vcpu_arch {
 	int halt_request; /* real mode on Intel only */
 
 	int cpuid_nent;
-	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
+	struct kvm_cpuid_entry2 *cpuid_entries;
 
 	int maxphyaddr;
 	int max_tdp_level;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3fd6eec202d7..0ce943a8a39a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -195,6 +195,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 {
 	int r, i;
 	struct kvm_cpuid_entry *cpuid_entries = NULL;
+	struct kvm_cpuid_entry2 *cpuid_entries2 = NULL;
 
 	r = -E2BIG;
 	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
@@ -207,31 +208,42 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			r = PTR_ERR(cpuid_entries);
 			goto out;
 		}
+		cpuid_entries2 = kvmalloc_array(cpuid->nent, sizeof(cpuid_entries2[0]),
+						GFP_KERNEL_ACCOUNT);
+		if (!cpuid_entries2) {
+			r = -ENOMEM;
+			goto out_free_cpuid;
+		}
 	}
 	for (i = 0; i < cpuid->nent; i++) {
-		vcpu->arch.cpuid_entries[i].function = cpuid_entries[i].function;
-		vcpu->arch.cpuid_entries[i].eax = cpuid_entries[i].eax;
-		vcpu->arch.cpuid_entries[i].ebx = cpuid_entries[i].ebx;
-		vcpu->arch.cpuid_entries[i].ecx = cpuid_entries[i].ecx;
-		vcpu->arch.cpuid_entries[i].edx = cpuid_entries[i].edx;
-		vcpu->arch.cpuid_entries[i].index = 0;
-		vcpu->arch.cpuid_entries[i].flags = 0;
-		vcpu->arch.cpuid_entries[i].padding[0] = 0;
-		vcpu->arch.cpuid_entries[i].padding[1] = 0;
-		vcpu->arch.cpuid_entries[i].padding[2] = 0;
+		cpuid_entries2[i].function = cpuid_entries[i].function;
+		cpuid_entries2[i].eax = cpuid_entries[i].eax;
+		cpuid_entries2[i].ebx = cpuid_entries[i].ebx;
+		cpuid_entries2[i].ecx = cpuid_entries[i].ecx;
+		cpuid_entries2[i].edx = cpuid_entries[i].edx;
+		cpuid_entries2[i].index = 0;
+		cpuid_entries2[i].flags = 0;
+		cpuid_entries2[i].padding[0] = 0;
+		cpuid_entries2[i].padding[1] = 0;
+		cpuid_entries2[i].padding[2] = 0;
 	}
+	kvfree(vcpu->arch.cpuid_entries);
+	vcpu->arch.cpuid_entries = cpuid_entries2;
 	vcpu->arch.cpuid_nent = cpuid->nent;
+
 	r = kvm_check_cpuid(vcpu);
 	if (r) {
+		kvfree(vcpu->arch.cpuid_entries);
+		vcpu->arch.cpuid_entries = NULL;
 		vcpu->arch.cpuid_nent = 0;
-		kvfree(cpuid_entries);
-		goto out;
+		goto out_free_cpuid;
 	}
 
 	cpuid_fix_nx_cap(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
+out_free_cpuid:
 	kvfree(cpuid_entries);
 out:
 	return r;
@@ -241,18 +253,31 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 			      struct kvm_cpuid2 *cpuid,
 			      struct kvm_cpuid_entry2 __user *entries)
 {
+	struct kvm_cpuid_entry2 *cpuid_entries2 = NULL;
 	int r;
 
 	r = -E2BIG;
 	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
 		goto out;
 	r = -EFAULT;
-	if (copy_from_user(&vcpu->arch.cpuid_entries, entries,
-			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
-		goto out;
+
+	if (cpuid->nent) {
+		cpuid_entries2 = vmemdup_user(entries,
+					      array_size(sizeof(cpuid_entries2[0]),
+							 cpuid->nent));
+		if (IS_ERR(cpuid_entries2)) {
+			r = PTR_ERR(cpuid_entries2);
+			goto out;
+		}
+	}
+	kvfree(vcpu->arch.cpuid_entries);
+	vcpu->arch.cpuid_entries = cpuid_entries2;
 	vcpu->arch.cpuid_nent = cpuid->nent;
+
 	r = kvm_check_cpuid(vcpu);
 	if (r) {
+		kvfree(vcpu->arch.cpuid_entries);
+		vcpu->arch.cpuid_entries = NULL;
 		vcpu->arch.cpuid_nent = 0;
 		goto out;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1994602a0851..42259a6ec1d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9610,6 +9610,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_destroy(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	free_page((unsigned long)vcpu->arch.pio_data);
+	kvfree(vcpu->arch.cpuid_entries);
 	if (!lapic_in_kernel(vcpu))
 		static_key_slow_dec(&kvm_no_apic_vcpu);
 }
-- 
2.25.4

