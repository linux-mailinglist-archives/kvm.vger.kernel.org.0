Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B69B27FFB5
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 15:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732150AbgJANF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 09:05:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732104AbgJANFz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 09:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601557553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X023FkD4CJHQd7Fpzt9OiSpx1o5f72B3yqJkQa1RT8k=;
        b=VyRbTIsPpPyV8zLWjdLsoRRFKQPUdMmJY285pFKjBJH6jv2wYtMx9Y95g9KvQMgFIcjHQO
        xmPyX9MWa/nXtrTca1uBgzI1sxNdK3abYpCqDzZM/nIP6cYGG0E+Twx5HBEQREMZzT7CH7
        yWwa2HZG7Ts1wWGcqAjd2HTWmD4lYf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-pYKqZROSN3umcfMtjvlpLg-1; Thu, 01 Oct 2020 09:05:52 -0400
X-MC-Unique: pYKqZROSN3umcfMtjvlpLg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E673E1062724;
        Thu,  1 Oct 2020 13:05:50 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFD705C1CF;
        Thu,  1 Oct 2020 13:05:45 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: disconnect kvm_check_cpuid() from vcpu->arch.cpuid_entries
Date:   Thu,  1 Oct 2020 15:05:39 +0200
Message-Id: <20201001130541.1398392-2-vkuznets@redhat.com>
In-Reply-To: <20201001130541.1398392-1-vkuznets@redhat.com>
References: <20201001130541.1398392-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparatory step to allocating vcpu->arch.cpuid_entries dynamically
make kvm_check_cpuid() check work with an arbitrary 'struct kvm_cpuid_entry2'
array.

Currently, when kvm_check_cpuid() fails we reset vcpu->arch.cpuid_nent to
0 and this is kind of weird, i.e. one would expect CPUIDs to remain
unchanged when KVM_SET_CPUID[2] call fails.

No functional change intended. It would've been possible to move the updated
kvm_check_cpuid() in kvm_vcpu_ioctl_set_cpuid2() and check the supplied
input before we start updating vcpu->arch.cpuid_entries/nent but we
can't do the same in kvm_vcpu_ioctl_set_cpuid() as we'll have to copy
'struct kvm_cpuid_entry' entries first. The change will be made when
vcpu->arch.cpuid_entries[] array becomes allocated dynamically.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 37c3668a774f..529348ddedc1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -54,7 +54,24 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 
 #define F feature_bit
 
-static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
+static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
+	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
+{
+	struct kvm_cpuid_entry2 *e;
+	int i;
+
+	for (i = 0; i < nent; i++) {
+		e = &entries[i];
+
+		if (e->function == function && (e->index == index ||
+		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
+			return e;
+	}
+
+	return NULL;
+}
+
+static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 {
 	struct kvm_cpuid_entry2 *best;
 
@@ -62,7 +79,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
 	 * canonical address checks; exit if it is ever changed.
 	 */
-	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
+	best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
 	if (best) {
 		int vaddr_bits = (best->eax & 0xff00) >> 8;
 
@@ -220,7 +237,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		vcpu->arch.cpuid_entries[i].padding[2] = 0;
 	}
 	vcpu->arch.cpuid_nent = cpuid->nent;
-	r = kvm_check_cpuid(vcpu);
+	r = kvm_check_cpuid(vcpu->arch.cpuid_entries, cpuid->nent);
 	if (r) {
 		vcpu->arch.cpuid_nent = 0;
 		kvfree(cpuid_entries);
@@ -250,7 +267,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
 	vcpu->arch.cpuid_nent = cpuid->nent;
-	r = kvm_check_cpuid(vcpu);
+	r = kvm_check_cpuid(vcpu->arch.cpuid_entries, cpuid->nent);
 	if (r) {
 		vcpu->arch.cpuid_nent = 0;
 		goto out;
@@ -940,17 +957,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index)
 {
-	struct kvm_cpuid_entry2 *e;
-	int i;
-
-	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
-		e = &vcpu->arch.cpuid_entries[i];
-
-		if (e->function == function && (e->index == index ||
-		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
-			return e;
-	}
-	return NULL;
+	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
+				 function, index);
 }
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
-- 
2.25.4

