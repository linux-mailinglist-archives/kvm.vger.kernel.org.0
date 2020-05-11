Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A641CE0F0
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 18:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgEKQs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 12:48:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47189 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730826AbgEKQs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 12:48:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589215735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8L7h7D0ZYrLjNfJnLUVqpCrchUXXgbyRVZhx5BAtmY=;
        b=eGR/GXA9pDrHZ5jVJTg/sCc6E1VYGqnfshHqAZUGOqMdlrYvJ5bedO7Mnw4r6zxXFQmUKx
        xisi12yeD06WYkOhHsnuTqig1MFNhxifdaPgA252rPVYnb26asEvNkxuFHIaijVeN5vFzQ
        8kge0fvbm9VT3zQentYm0epSYPMNrPg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-KuiF88lPMBKdzDRTKad1FQ-1; Mon, 11 May 2020 12:48:51 -0400
X-MC-Unique: KuiF88lPMBKdzDRTKad1FQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE8C71899520;
        Mon, 11 May 2020 16:48:49 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63CE6341FF;
        Mon, 11 May 2020 16:48:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] KVM: x86: drop KVM_PV_REASON_PAGE_READY case from kvm_handle_page_fault()
Date:   Mon, 11 May 2020 18:47:52 +0200
Message-Id: <20200511164752.2158645-9-vkuznets@redhat.com>
In-Reply-To: <20200511164752.2158645-1-vkuznets@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM guest code in Linux enables APF only when KVM_FEATURE_ASYNC_PF_INT
is supported, this means we will never see KVM_PV_REASON_PAGE_READY
when handling page fault vmexit in KVM.

While on it, make sure we only follow genuine page fault path when
APF reason is zero. If we happen to see something else this means
that the underlying hypervisor is misbehaving. Leave WARN_ON_ONCE()
to catch that.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8071952e9cf2..5a9fca908ca9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4187,7 +4187,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 
 	vcpu->arch.l1tf_flush_l1d = true;
 	switch (vcpu->arch.apf.host_apf_reason) {
-	default:
+	case 0:
 		trace_kvm_page_fault(fault_address, error_code);
 
 		if (kvm_event_needs_reinjection(vcpu))
@@ -4201,12 +4201,8 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 		kvm_async_pf_task_wait(fault_address, 0);
 		local_irq_enable();
 		break;
-	case KVM_PV_REASON_PAGE_READY:
-		vcpu->arch.apf.host_apf_reason = 0;
-		local_irq_disable();
-		kvm_async_pf_task_wake(fault_address);
-		local_irq_enable();
-		break;
+	default:
+		WARN_ON_ONCE(1);
 	}
 	return r;
 }
-- 
2.25.4

