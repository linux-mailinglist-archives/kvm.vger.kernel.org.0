Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE7B443F65
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 10:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhKCJcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 05:32:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231575AbhKCJcA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 05:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635931763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fIqHvaj2F37ywtGbTbgChe6nRz2xCacD+23S/GYTSiw=;
        b=CLKBgod5zkGbfH4iC9wxtcu44v25VnBThSxnlQvtzWFKf7sh9ljZoHe0offGWO4kQ4gfXb
        n8leDlW2Vm60kwIEWpzP2Z87pOGEijlbmqg+UHgU4sGanh9T1hwVaqK+Dz6stxGmhoiayA
        hAl9gI7Sk71hdq2tscnQsDH9KM3Dfw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-yU_l-TfjNveEGtmTnsY7Ig-1; Wed, 03 Nov 2021 05:29:20 -0400
X-MC-Unique: yU_l-TfjNveEGtmTnsY7Ig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11232879500;
        Wed,  3 Nov 2021 09:29:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95BC91017E27;
        Wed,  3 Nov 2021 09:29:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ active
Date:   Wed,  3 Nov 2021 11:29:12 +0200
Message-Id: <20211103092912.425128-1-mlevitsk@redhat.com>
In-Reply-To: <e508be0ecda6db330d83b954f4e4d1ad12c08c64.camel@redhat.com>
References: <e508be0ecda6db330d83b954f4e4d1ad12c08c64.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
standard kvm's inject_pending_event, and not via APICv/AVIC.

Since this is a debug feature, just inhibit it while it
is in use.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/avic.c         | 3 ++-
 arch/x86/kvm/vmx/vmx.c          | 3 ++-
 arch/x86/kvm/x86.c              | 3 +++
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd7..8f6e15b95a4d8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1034,6 +1034,7 @@ struct kvm_x86_msr_filter {
 #define APICV_INHIBIT_REASON_IRQWIN     3
 #define APICV_INHIBIT_REASON_PIT_REINJ  4
 #define APICV_INHIBIT_REASON_X2APIC	5
+#define APICV_INHIBIT_REASON_BLOCKIRQ	6
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8052d92069e01..affc0ea98d302 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -904,7 +904,8 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
-			  BIT(APICV_INHIBIT_REASON_X2APIC);
+			  BIT(APICV_INHIBIT_REASON_X2APIC) |
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
 
 	return supported & BIT(bit);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71f54d85f104c..e4fc9ff7cd944 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7565,7 +7565,8 @@ static void hardware_unsetup(void)
 static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
-			  BIT(APICV_INHIBIT_REASON_HYPERV);
+			  BIT(APICV_INHIBIT_REASON_HYPERV) |
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
 
 	return supported & BIT(bit);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b0..eb3b8d2375713 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10747,6 +10747,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vcpu->arch.singlestep_rip = kvm_get_linear_rip(vcpu);
 
+	kvm_request_apicv_update(vcpu->kvm,
+			!(vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ),
+			APICV_INHIBIT_REASON_BLOCKIRQ);
 	/*
 	 * Trigger an rflags update that will inject or remove the trace
 	 * flags.
-- 
2.26.3

