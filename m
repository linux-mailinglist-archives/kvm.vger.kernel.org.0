Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF73387B89
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 16:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbhEROpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 10:45:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237362AbhEROpR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 10:45:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621349039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qxRIIFiEldY6Ml0BKK2jUVZ5etl0da89Lyfbq7fHtU4=;
        b=hFsz0kWdj6q8Dt26LGcLx/xtSRUnybTvCdfrzfd1UwTFiJ2iu3xjICD63D5yK7QaxbeP/0
        6rcTXIGr4fHVKhNqj4QV/pjtG4x6hoV2AVr79776OVRHx4njTtOiOQcLuOpdGIEhhIt9Up
        4NX0c3rj5mUvx10ddY3ivhGhPPHhRN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-7eWQzjCZO-uYqat9yAf-1A-1; Tue, 18 May 2021 10:43:57 -0400
X-MC-Unique: 7eWQzjCZO-uYqat9yAf-1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CDF0188E3D2;
        Tue, 18 May 2021 14:43:56 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4428963B8C;
        Tue, 18 May 2021 14:43:54 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] KVM: x86: Invert APICv/AVIC enablement check
Date:   Tue, 18 May 2021 16:43:38 +0200
Message-Id: <20210518144339.1987982-5-vkuznets@redhat.com>
In-Reply-To: <20210518144339.1987982-1-vkuznets@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that APICv/AVIC enablement is kept in common 'enable_apicv' variable,
there's no need to call kvm_apicv_init() from vendor specific code.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm/svm.c          | 1 -
 arch/x86/kvm/vmx/vmx.c          | 1 -
 arch/x86/kvm/x86.c              | 6 +++---
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a2197fcf0e7c..bf5807d35339 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1662,7 +1662,6 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception);
 
 bool kvm_apicv_activated(struct kvm *kvm);
-void kvm_apicv_init(struct kvm *kvm, bool enable);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
 			      unsigned long bit);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0d6ec34d1e4b..84f58e8b2f49 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4438,7 +4438,6 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
-	kvm_apicv_init(kvm, enable_apicv);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e9ba10e9c2d..697dd54c7df8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7000,7 +7000,6 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
-	kvm_apicv_init(kvm, enable_apicv);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23fdbba6b394..22a1e2b438c3 100644
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
@@ -10739,6 +10738,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
+	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
 	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
-- 
2.31.1

