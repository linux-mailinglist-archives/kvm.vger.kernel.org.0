Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED61E10CF
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404081AbgEYOm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:42:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57878 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404061AbgEYOmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 10:42:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E5DiB+MWHZo7YMaEZxoZmOa2F6h0GpMlsmbKYOyDmac=;
        b=GbIjdqLsa0qZLJgCw9vDS3uIywgak6B1oJQO16NWEH5CJbMsHTgnnm9u0H4D+tPNQ4aOBB
        pPMkRo40dbimsi0yeyAzYVR5PyVg7LLbEoRfZSL4sZejB8WIGpqRtieyFjlQBg6I6IfQEj
        X2D+ukq1+K/w/Ggt7Mpxpqy59zUgag4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-emavy1G_PZuaGhGn5c5tGA-1; Mon, 25 May 2020 10:42:08 -0400
X-MC-Unique: emavy1G_PZuaGhGn5c5tGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B08091005510;
        Mon, 25 May 2020 14:42:06 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F0865D9C5;
        Mon, 25 May 2020 14:42:02 +0000 (UTC)
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
Subject: [PATCH v2 09/10] KVM: x86: drop KVM_PV_REASON_PAGE_READY case from kvm_handle_page_fault()
Date:   Mon, 25 May 2020 16:41:24 +0200
Message-Id: <20200525144125.143875-10-vkuznets@redhat.com>
In-Reply-To: <20200525144125.143875-1-vkuznets@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
 arch/x86/kvm/mmu/mmu.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7fa5253237b2..1bb7a8c6c28e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4178,6 +4178,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len)
 {
 	int r = 1;
+	u32 flags = vcpu->arch.apf.host_apf_flags;
 
 #ifndef CONFIG_X86_64
 	/* A 64-bit CR2 should be impossible on 32-bit KVM. */
@@ -4186,28 +4187,22 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 #endif
 
 	vcpu->arch.l1tf_flush_l1d = true;
-	switch (vcpu->arch.apf.host_apf_flags) {
-	default:
+	if (!flags) {
 		trace_kvm_page_fault(fault_address, error_code);
 
 		if (kvm_event_needs_reinjection(vcpu))
 			kvm_mmu_unprotect_page_virt(vcpu, fault_address);
 		r = kvm_mmu_page_fault(vcpu, fault_address, error_code, insn,
 				insn_len);
-		break;
-	case KVM_PV_REASON_PAGE_NOT_PRESENT:
+	} else if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
 		vcpu->arch.apf.host_apf_flags = 0;
 		local_irq_disable();
 		kvm_async_pf_task_wait(fault_address, 0);
 		local_irq_enable();
-		break;
-	case KVM_PV_REASON_PAGE_READY:
-		vcpu->arch.apf.host_apf_flags = 0;
-		local_irq_disable();
-		kvm_async_pf_task_wake(fault_address);
-		local_irq_enable();
-		break;
+	} else {
+		WARN_ONCE(1, "Unexpected host async PF flags: %x\n", flags);
 	}
+
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
-- 
2.25.4

