Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A1A45946B
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 18:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239825AbhKVSBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:01:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239764AbhKVSBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 13:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637603915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rKBdp+c5ShVw+K+W5BqKDAfh3gXZdMMO+xQSPcJQJv4=;
        b=Su8BlT4fAW1cPkxz2HoG86CdGQjmDCrJozwL4tPK0U8XWQnDApJDzHy7iUAE0wcmNMgbpm
        thL5orjmDpns5bxa8DES7bdErtlImPs5q5/fAfy2ZoZr7XGvJtEOzEWPW2td5U0v5cR7nw
        7bKl+8Z/89aUfm0GmVU5yW9xmIQbmCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427--DQANkk4NAG4cdzY6Hl0Mw-1; Mon, 22 Nov 2021 12:58:32 -0500
X-MC-Unique: -DQANkk4NAG4cdzY6Hl0Mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E56BA0CAE;
        Mon, 22 Nov 2021 17:58:31 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F10F1002D71;
        Mon, 22 Nov 2021 17:58:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Date:   Mon, 22 Nov 2021 18:58:18 +0100
Message-Id: <20211122175818.608220-3-vkuznets@redhat.com>
In-Reply-To: <20211122175818.608220-1-vkuznets@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 63f5a1909f9e ("KVM: x86: Alert userspace that KVM_SET_CPUID{,2}
after KVM_RUN is broken") officially deprecated KVM_SET_CPUID{,2} ioctls
after first successful KVM_RUN and promissed to make this sequence forbiden
in 5.16. It's time to fulfil the promise.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 +++-----------------
 arch/x86/kvm/x86.c     | 27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3be9beea838d..669e86688cbf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5032,24 +5032,10 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 
 	/*
-	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
-	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
-	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
-	 * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
-	 * sweep the problem under the rug.
-	 *
-	 * KVM's horrific CPUID ABI makes the problem all but impossible to
-	 * solve, as correctly handling multiple vCPU models (with respect to
-	 * paging and physical address properties) in a single VM would require
-	 * tracking all relevant CPUID information in kvm_mmu_page_role.  That
-	 * is very undesirable as it would double the memory requirements for
-	 * gfn_track (see struct kvm_mmu_page_role comments), and in practice
-	 * no sane VMM mucks with the core vCPU model on the fly.
+	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
+	 * kvm_arch_vcpu_ioctl().
 	 */
-	if (vcpu->arch.last_vmentry_cpu != -1) {
-		pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} after KVM_RUN may cause guest instability\n");
-		pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} will fail after KVM_RUN starting with Linux 5.16\n");
-	}
+	KVM_BUG_ON(vcpu->arch.last_vmentry_cpu != -1, vcpu->kvm);
 }
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a403d92833f..3cfaccc24efb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5125,6 +5125,25 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid cpuid;
 
 		r = -EFAULT;
+
+		/*
+		 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
+		 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
+		 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
+		 * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
+		 * sweep the problem under the rug.
+		 *
+		 * KVM's horrific CPUID ABI makes the problem all but impossible to
+		 * solve, as correctly handling multiple vCPU models (with respect to
+		 * paging and physical address properties) in a single VM would require
+		 * tracking all relevant CPUID information in kvm_mmu_page_role.  That
+		 * is very undesirable as it would double the memory requirements for
+		 * gfn_track (see struct kvm_mmu_page_role comments), and in practice
+		 * no sane VMM mucks with the core vCPU model on the fly.
+		 */
+		if (vcpu->arch.last_vmentry_cpu != -1)
+			goto out;
+
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
 		r = kvm_vcpu_ioctl_set_cpuid(vcpu, &cpuid, cpuid_arg->entries);
@@ -5135,6 +5154,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid2 cpuid;
 
 		r = -EFAULT;
+
+		/*
+		 * KVM_SET_CPUID{,2} after KVM_RUN is forbidded, see the comment in
+		 * KVM_SET_CPUID case above.
+		 */
+		if (vcpu->arch.last_vmentry_cpu != -1)
+			goto out;
+
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
 		r = kvm_vcpu_ioctl_set_cpuid2(vcpu, &cpuid,
-- 
2.33.1

