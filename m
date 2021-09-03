Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D93A3FFB57
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 09:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348093AbhICHxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 03:53:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348025AbhICHxZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 03:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630655545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CAww2Pu9T9uLrDa7tGvh1V9RqD8zqzV1FJuxb6/DyjY=;
        b=fx7QY0HPCqxhogj8o8CwPUykW9Oymll34QLO9EgAyJwu/hrp114t3fyH3iZvp9c2Z0/yG9
        lCq2uwvimHVyGtucrnmsR5s9YtE1sXvtD6LNVBYI7KZyhJHNSORl/cyBgP/5Wp2sFm5BKA
        Vvqztn2AGveB7H0HZv+KeEBYlxFcJFo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-nYRdqdyUPXqPZxa8QeBqGg-1; Fri, 03 Sep 2021 03:52:24 -0400
X-MC-Unique: nYRdqdyUPXqPZxa8QeBqGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53914501EC;
        Fri,  3 Sep 2021 07:52:02 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB2AA10016F5;
        Fri,  3 Sep 2021 07:51:59 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/8] KVM: Drop 'except' parameter from kvm_make_vcpus_request_mask()
Date:   Fri,  3 Sep 2021 09:51:38 +0200
Message-Id: <20210903075141.403071-6-vkuznets@redhat.com>
In-Reply-To: <20210903075141.403071-1-vkuznets@redhat.com>
References: <20210903075141.403071-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both remaining callers of kvm_make_vcpus_request_mask() pass 'NULL' for
'except' parameter so it can just be dropped.

No functional change intended ©.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c    | 2 +-
 arch/x86/kvm/x86.c       | 2 +-
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 3 +--
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 783a7f2441bd..5704bfe53ee0 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1850,7 +1850,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 						    vp_bitmap, vcpu_bitmap);
 
 		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
-					    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
+					    vcpu_mask, &hv_vcpu->tlb_flush);
 	}
 
 ret_success:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..a4752dcc2a75 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9229,7 +9229,7 @@ void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
 	kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
-				    NULL, vcpu_bitmap, cpus);
+				    vcpu_bitmap, cpus);
 
 	free_cpumask_var(cpus);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e4d712e9f760..2f149ed140f7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -160,7 +160,6 @@ static inline bool is_error_page(struct page *page)
 #define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
-				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e649b939dda7..1238976ef614 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -298,7 +298,6 @@ static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
 }
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
-				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
 	struct kvm_vcpu *vcpu;
@@ -309,7 +308,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 
 	for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
 		vcpu = kvm_get_vcpu(kvm, i);
-		if (!vcpu || vcpu == except)
+		if (!vcpu)
 			continue;
 		kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
 	}
-- 
2.31.1

