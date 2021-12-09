Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E9C46E7D8
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbhLIL7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:59:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236968AbhLIL7R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 06:59:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639050944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yagb3IyDVUo5Ixj+pfr6/7pSxG/9QhwXDe7MZlTrvyU=;
        b=Odl7S5ftDSTmiaYRa5p9G6Yw+tRNLSul2Cs00nDrY9CYop1UwSk9u3a3Dn20hmiZcs87yF
        6TkYT6XgEb3ovsP+/DmBDoMo//2WyL+K8Rpvab6BQObLO26nPGiklptQlHLz00WFuh9QLR
        7TRIYkrL1WANMnHOfe3IpDcFzMolGzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-cQOK2d6zPHGJ1ddnulDLeQ-1; Thu, 09 Dec 2021 06:55:41 -0500
X-MC-Unique: cQOK2d6zPHGJ1ddnulDLeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 836EC85B664;
        Thu,  9 Dec 2021 11:55:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 676F660657;
        Thu,  9 Dec 2021 11:55:35 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5/6] KVM: x86: never clear irr_pending in kvm_apic_update_apicv
Date:   Thu,  9 Dec 2021 13:54:39 +0200
Message-Id: <20211209115440.394441-6-mlevitsk@redhat.com>
In-Reply-To: <20211209115440.394441-1-mlevitsk@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is possible that during the AVIC incomplete IPI vmexit,
its handler will set irr_pending to true,
but the target vCPU will still see the IRR bit not set,
due to the apparent lack of memory ordering between CPU's vIRR write
that is supposed to happen prior to the AVIC incomplete IPI
vmexit and the write of the irr_pending in that handler.

The AVIC incomplete IPI handler sets this boolean, then issues
a write barrier and then raises KVM_REQ_EVENT,
thus when we later process the KVM_REQ_EVENT we will notice
the vIRR bits set.

Also reorder call to kvm_apic_update_apicv to be after
.refresh_apicv_exec_ctrl, although that doesn't guarantee
that it will see up to date IRR bits.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 3 ++-
 arch/x86/kvm/x86.c   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c5028e6b0f96..ecd6111b9a0d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2314,7 +2314,8 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		apic->irr_pending = true;
 		apic->isr_count = 1;
 	} else {
-		apic->irr_pending = (apic_search_irr(apic) != -1);
+		if (apic_search_irr(apic) != -1)
+			apic->irr_pending = true;
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26cb3a4cd0e9..ca037ac2ea08 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9542,8 +9542,8 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		goto out;
 
 	vcpu->arch.apicv_active = activate;
-	kvm_apic_update_apicv(vcpu);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
+	kvm_apic_update_apicv(vcpu);
 
 	/*
 	 * When APICv gets disabled, we may still have injected interrupts
-- 
2.26.3

