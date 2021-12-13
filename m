Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B37472A9F
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhLMKsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:48:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235112AbhLMKsu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 05:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639392530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOCjHHsPFgaO4I7ekXyOaxYIjaRIzYI5BxBxhwzZrN8=;
        b=Ne0AbHXER5RRsSeb8TilTDJ6FTQ/XqvXsvrpX1njfeEnn3GyOu4uek8cnPBc844mk1iRT5
        R0p/+8HJMAcU5HaTwN5na123PiQpKJxpQo32Z/YmjLD+y0OJpJYmZLSkrvC4gDZEXM2Ep5
        w4Di06AcN01I55VSOKv7h2YZBdknJVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-KNkLwAAyMIG_Bzts0B2haA-1; Mon, 13 Dec 2021 05:48:47 -0500
X-MC-Unique: KNkLwAAyMIG_Bzts0B2haA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DBA8193F560;
        Mon, 13 Dec 2021 10:48:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 399F218035;
        Mon, 13 Dec 2021 10:48:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 4/5] KVM: x86: don't touch irr_pending in kvm_apic_update_apicv when inhibiting it
Date:   Mon, 13 Dec 2021 12:46:33 +0200
Message-Id: <20211213104634.199141-5-mlevitsk@redhat.com>
In-Reply-To: <20211213104634.199141-1-mlevitsk@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_apic_update_apicv is called when AVIC is still active, thus IRR bits
can be set by the CPU after it was called, and won't cause the irr_pending
to be set to true.

Also the logic in avic_kick_target_vcpu doesn't expect a race with this
function.

To make it simple, just keep irr_pending set to true and
let the next interrupt injection to the guest clear it.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index baca9fa37a91c..6e1fbbf4c508b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2312,7 +2312,10 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		apic->irr_pending = true;
 		apic->isr_count = 1;
 	} else {
-		apic->irr_pending = (apic_search_irr(apic) != -1);
+		/*
+		 * Don't touch irr_pending, let it be cleared when
+		 * we process the interrupt
+		 */
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
 }
-- 
2.26.3

