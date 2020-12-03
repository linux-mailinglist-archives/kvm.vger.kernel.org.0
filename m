Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093FB2CD947
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436616AbgLCOfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:35:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436598AbgLCOfI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 09:35:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607006022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1XqBhc/70x5UiCX+gliKZSRAhGKjt02d3xbD8cQLd3A=;
        b=UqO0jNHp7Gy5jPvUVFieqKSdNpUajrPKQUX0Dn5YcGLFEpvxac4sWhV8b3DET538hqMR1z
        5aRuQKbQBgoCpfqjokMwyyjt1Wg1pU/O1V2kySeDSDCHMouFgOJRWEg6XMkDTr/AM9fycI
        4CJk8HrCekdFzf6/0N8yyhl9swQaKNA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-sEQTVC7HM7iPVfFkzPwXPA-1; Thu, 03 Dec 2020 09:33:40 -0500
X-MC-Unique: sEQTVC7HM7iPVfFkzPwXPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 841931076029;
        Thu,  3 Dec 2020 14:33:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D839D5B4A0;
        Thu,  3 Dec 2020 14:33:25 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/1] KVM: x86: ignore SIPIs that are received while not in wait-for-sipi state
Date:   Thu,  3 Dec 2020 16:33:19 +0200
Message-Id: <20201203143319.159394-2-mlevitsk@redhat.com>
In-Reply-To: <20201203143319.159394-1-mlevitsk@redhat.com>
References: <20201203143319.159394-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the commit 1c96dcceaeb3
("KVM: x86: fix apic_accept_events vs check_nested_events"),

we accidently started latching SIPIs that are received while the cpu is not
waiting for them.

This causes vCPUs to never enter a halted state.

Fixes: 1c96dcceaeb3 ("KVM: x86: fix apic_accept_events vs check_nested_events")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e3ee597ff5404..6a87623aa578e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2892,14 +2892,15 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 		else
 			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
 	}
-	if (test_bit(KVM_APIC_SIPI, &pe) &&
-	    vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
+	if (test_bit(KVM_APIC_SIPI, &pe)) {
 		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
-		/* evaluate pending_events before reading the vector */
-		smp_rmb();
-		sipi_vector = apic->sipi_vector;
-		kvm_vcpu_deliver_sipi_vector(vcpu, sipi_vector);
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
+			/* evaluate pending_events before reading the vector */
+			smp_rmb();
+			sipi_vector = apic->sipi_vector;
+			kvm_vcpu_deliver_sipi_vector(vcpu, sipi_vector);
+			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		}
 	}
 }
 
-- 
2.26.2

