Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649B83A18A1
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbhFIPLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:11:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235239AbhFIPLS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:11:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623251363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r+LkmQyJ3vQ8do9cBrR/D4CmvKu7s9jpc3d8fV/Ox9o=;
        b=D/dmjBQfroc3XQsM+WcFmex6sYnbCcrrPItmf05a5FdWM3fvzPg1nIp/mvsgjImoLfghGt
        LRSSI/JfXyDBP0Q2VRVW5dja2FUcAs6RqO8AE8nF2OEsnHIrUgYTtVKewHw6pv9I6JG7DJ
        iHOmYlKngzeJFscQJHPMjvvfwFU77AQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-O1jFkgdRNZqVk0pE9OaFoA-1; Wed, 09 Jun 2021 11:09:22 -0400
X-MC-Unique: O1jFkgdRNZqVk0pE9OaFoA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EBF3BBEE1;
        Wed,  9 Jun 2021 15:09:21 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 694A7620DE;
        Wed,  9 Jun 2021 15:09:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] KVM: x86: Drop vendor specific functions for APICv/AVIC enablement
Date:   Wed,  9 Jun 2021 17:09:09 +0200
Message-Id: <20210609150911.1471882-3-vkuznets@redhat.com>
In-Reply-To: <20210609150911.1471882-1-vkuznets@redhat.com>
References: <20210609150911.1471882-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that APICv/AVIC enablement is kept in common 'enable_apicv' variable,
there's no need to call kvm_apicv_init() from vendor specific code.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm/svm.c          | 1 -
 arch/x86/kvm/vmx/vmx.c          | 1 -
 arch/x86/kvm/x86.c              | 6 +++---
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bb4f827cbacd..ed4e2aae13d1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1663,7 +1663,6 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception);
 
 bool kvm_apicv_activated(struct kvm *kvm);
-void kvm_apicv_init(struct kvm *kvm, bool enable);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
 			      unsigned long bit);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 200aabe6de23..2e766a608faf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4438,7 +4438,6 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
-	kvm_apicv_init(kvm, enable_apicv);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4eb369e66372..e354433334cd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6999,7 +6999,6 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
-	kvm_apicv_init(kvm, enable_apicv);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7139725303da..0f461f111a0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8345,16 +8345,15 @@ bool kvm_apicv_activated(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_apicv_activated);
 
-void kvm_apicv_init(struct kvm *kvm, bool enable)
+static void kvm_apicv_init(struct kvm *kvm)
 {
-	if (enable)
+	if (enable_apicv)
 		clear_bit(APICV_INHIBIT_REASON_DISABLE,
 			  &kvm->arch.apicv_inhibit_reasons);
 	else
 		set_bit(APICV_INHIBIT_REASON_DISABLE,
 			&kvm->arch.apicv_inhibit_reasons);
 }
-EXPORT_SYMBOL_GPL(kvm_apicv_init);
 
 static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 {
@@ -10741,6 +10740,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
+	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
 	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
-- 
2.31.1

