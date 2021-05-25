Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5477C390326
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 15:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhEYN4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 09:56:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233380AbhEYNz4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 09:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621950865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=gOuDbl0+VRR8LPwx8tZdmeXgGsQE7zoWmnV3C2G7mxU=;
        b=LnB2KBpK8c1eN5PNkH7vMhDoL2v8ebK2MKfNssjG31WskDkW4gIWdAMGNy5X21BVKOVNBn
        geUKGfj/2IMZyIANI5Z8mLxdPQAmyDwZ7esC+A9AB67J0qmpljmvh/ZAvo+XtRh+4Zsaqx
        4NRvvOxo6jiY88Wc57F9Jc2mt0uwVVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-Jj8Ku6JYNjODYHDQ7nHDVQ-1; Tue, 25 May 2021 09:54:21 -0400
X-MC-Unique: Jj8Ku6JYNjODYHDQ7nHDVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCC14501E0;
        Tue, 25 May 2021 13:54:20 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B4F1421F;
        Tue, 25 May 2021 13:54:07 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id B3FDC4172EDE; Tue, 25 May 2021 10:44:35 -0300 (-03)
Message-ID: <20210525134321.303768132@redhat.com>
User-Agent: quilt/0.66
Date:   Tue, 25 May 2021 10:41:17 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 2/3] KVM: rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK
References: <20210525134115.135966361@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_REQ_UNBLOCK will be used to exit a vcpu from
its inner vcpu halt emulation loop.

Rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK, switch
PowerPC to arch specific request bit.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Index: kvm/include/linux/kvm_host.h
===================================================================
--- kvm.orig/include/linux/kvm_host.h
+++ kvm/include/linux/kvm_host.h
@@ -146,7 +146,7 @@ static inline bool is_error_page(struct
  */
 #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_PENDING_TIMER     2
+#define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
 #define KVM_REQUEST_ARCH_BASE     8
 
Index: kvm/virt/kvm/kvm_main.c
===================================================================
--- kvm.orig/virt/kvm/kvm_main.c
+++ kvm/virt/kvm/kvm_main.c
@@ -2794,6 +2794,8 @@ static int kvm_vcpu_check_block(struct k
 		goto out;
 	if (signal_pending(current))
 		goto out;
+	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
+		goto out;
 
 	ret = 0;
 out:
Index: kvm/Documentation/virt/kvm/vcpu-requests.rst
===================================================================
--- kvm.orig/Documentation/virt/kvm/vcpu-requests.rst
+++ kvm/Documentation/virt/kvm/vcpu-requests.rst
@@ -118,10 +118,11 @@ KVM_REQ_MMU_RELOAD
   necessary to inform each VCPU to completely refresh the tables.  This
   request is used for that.
 
-KVM_REQ_PENDING_TIMER
+KVM_REQ_UNBLOCK
 
   This request may be made from a timer handler run on the host on behalf
-  of a VCPU.  It informs the VCPU thread to inject a timer interrupt.
+  of a VCPU, or when device assignment is performed. It informs the VCPU to
+  exit the vcpu halt inner loop.
 
 KVM_REQ_UNHALT
 
Index: kvm/arch/powerpc/include/asm/kvm_host.h
===================================================================
--- kvm.orig/arch/powerpc/include/asm/kvm_host.h
+++ kvm/arch/powerpc/include/asm/kvm_host.h
@@ -51,6 +51,7 @@
 /* PPC-specific vcpu->requests bit members */
 #define KVM_REQ_WATCHDOG	KVM_ARCH_REQ(0)
 #define KVM_REQ_EPR_EXIT	KVM_ARCH_REQ(1)
+#define KVM_REQ_PENDING_TIMER	KVM_ARCH_REQ(2)
 
 #include <linux/mmu_notifier.h>
 
Index: kvm/arch/x86/kvm/lapic.c
===================================================================
--- kvm.orig/arch/x86/kvm/lapic.c
+++ kvm/arch/x86/kvm/lapic.c
@@ -1657,7 +1657,7 @@ static void apic_timer_expired(struct kv
 	}
 
 	atomic_inc(&apic->lapic_timer.pending);
-	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
+	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
 	if (from_timer_fn)
 		kvm_vcpu_kick(vcpu);
 }
Index: kvm/arch/x86/kvm/x86.c
===================================================================
--- kvm.orig/arch/x86/kvm/x86.c
+++ kvm/arch/x86/kvm/x86.c
@@ -9300,7 +9300,7 @@ static int vcpu_run(struct kvm_vcpu *vcp
 		if (r <= 0)
 			break;
 
-		kvm_clear_request(KVM_REQ_PENDING_TIMER, vcpu);
+		kvm_clear_request(KVM_REQ_UNBLOCK, vcpu);
 		if (kvm_cpu_has_pending_timer(vcpu))
 			kvm_inject_pending_timer_irqs(vcpu);
 


