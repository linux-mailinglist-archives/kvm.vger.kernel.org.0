Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CC9487CA3
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbiAGS5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:57:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231373AbiAGSz2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uONjmy/t03IFtZZk5ERo0Inexunbz5jKfMIPTzX4NIk=;
        b=Hlf/DYOfu2b3WrhOOjEBUxi2c6Fl9TDcXXPF9nY82HN3N1pisyGqR4c+pKhsseqcAtEO1k
        F3f11e6sP3RnhHEd+xaD4qpkhgOQTEE77vHnJnw55ztucWd/Hpa+8Jf3Cy38mhd68ybqgp
        aYkp95V06jRVdhN7tWL8qj5gNUw0lrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-xx3t5jXNMv-mEeFoeyJQfA-1; Fri, 07 Jan 2022 13:55:22 -0500
X-MC-Unique: xx3t5jXNMv-mEeFoeyJQfA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E77AB81EE61;
        Fri,  7 Jan 2022 18:55:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E21C838F0;
        Fri,  7 Jan 2022 18:55:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 08/21] kvm: x86: Enable dynamic xfeatures at KVM_SET_CPUID2
Date:   Fri,  7 Jan 2022 13:54:59 -0500
Message-Id: <20220107185512.25321-9-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

KVM can request fpstate expansion in two approaches:

  1) When intercepting guest updates to XCR0 and XFD MSR;

  2) Before vcpu runs (e.g. at KVM_SET_CPUID2);

The first option doesn't waste memory for legacy guest if it doesn't
support XFD. However doing so introduces more complexity and also
imposes an order requirement in the restoring path, i.e. XCR0/XFD
must be restored before XSTATE.

Given that the agreement is to do the static approach. This is
considered a better tradeoff though it does waste 8K memory for
legacy guest if its CPUID includes dynamically-enabled xfeatures.

Successful fpstate expansion requires userspace VMM to acquire
guest xstate permissions before calling KVM_SET_CPUID2.

Also take the chance to adjust the indent in kvm_set_cpuid().

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-9-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index eb52dde5deec..a0fedf1514ab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -84,9 +84,12 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	return NULL;
 }
 
-static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
+static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
+			   struct kvm_cpuid_entry2 *entries,
+			   int nent)
 {
 	struct kvm_cpuid_entry2 *best;
+	u64 xfeatures;
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -100,7 +103,20 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 			return -EINVAL;
 	}
 
-	return 0;
+	/*
+	 * Exposing dynamic xfeatures to the guest requires additional
+	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
+	 */
+	best = cpuid_entry2_find(entries, nent, 0xd, 0);
+	if (!best)
+		return 0;
+
+	xfeatures = best->eax | ((u64)best->edx << 32);
+	xfeatures &= XFEATURE_MASK_USER_DYNAMIC;
+	if (!xfeatures)
+		return 0;
+
+	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
 }
 
 static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
@@ -280,21 +296,21 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
-    int r;
+	int r;
 
-    r = kvm_check_cpuid(e2, nent);
-    if (r)
-        return r;
+	r = kvm_check_cpuid(vcpu, e2, nent);
+	if (r)
+		return r;
 
-    kvfree(vcpu->arch.cpuid_entries);
-    vcpu->arch.cpuid_entries = e2;
-    vcpu->arch.cpuid_nent = nent;
+	kvfree(vcpu->arch.cpuid_entries);
+	vcpu->arch.cpuid_entries = e2;
+	vcpu->arch.cpuid_nent = nent;
 
-    kvm_update_kvm_cpuid_base(vcpu);
-    kvm_update_cpuid_runtime(vcpu);
-    kvm_vcpu_after_set_cpuid(vcpu);
+	kvm_update_kvm_cpuid_base(vcpu);
+	kvm_update_cpuid_runtime(vcpu);
+	kvm_vcpu_after_set_cpuid(vcpu);
 
-    return 0;
+	return 0;
 }
 
 /* when an old userspace process fills a new kernel module */
-- 
2.31.1


