Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D7231DBD1
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhBQO7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:59:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233605AbhBQO7P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613573869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d7hdrmggGz0IX+vXiyJwgHKownPeIRNtGuiBFLCAaUw=;
        b=Z3oxzDAsRXXEpRBtPkaQ1r0xFv7T4U0LSS0B5Rk3ncNq1INyFDDjhlkNw67Tgd+EHF/UST
        xJ/93FrDDXCXOtlJp9HZpQKe20yZZNCC6kD57736E+o8q7AT1scFen7ZuRmmvdHeW1XTTl
        NPhPH7+j/bDQm/nCEgn7wrBycblG5MY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-0hpgskSyOPycxJdIbXKYSA-1; Wed, 17 Feb 2021 09:57:46 -0500
X-MC-Unique: 0hpgskSyOPycxJdIbXKYSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F9BB192AB78;
        Wed, 17 Feb 2021 14:57:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE8BB10023AF;
        Wed, 17 Feb 2021 14:57:41 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 6/7] KVM: nVMX: don't load PDPTRS right after nested state set
Date:   Wed, 17 Feb 2021 16:57:17 +0200
Message-Id: <20210217145718.1217358-7-mlevitsk@redhat.com>
In-Reply-To: <20210217145718.1217358-1-mlevitsk@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just like all other nested memory accesses, after a migration loading
PDPTRs should be delayed to first VM entry to ensure
that guest memory is fully initialized.

Just move the call to nested_vmx_load_cr3 to nested_get_vmcs12_pages
to implement this.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f9de729dbea6..26084f8eee82 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2596,11 +2596,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		return -EINVAL;
 	}
 
-	/* Shadow page tables on either EPT or shadow page tables. */
-	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
-				entry_failure_code))
-		return -EINVAL;
-
 	/*
 	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
 	 * on nested VM-Exit, which can occur without actually running L2 and
@@ -3138,11 +3133,16 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	enum vm_entry_failure_code entry_failure_code;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_host_map *map;
 	struct page *page;
 	u64 hpa;
 
+	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
+				&entry_failure_code))
+		return false;
+
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
 		/*
 		 * Translate L1 physical address to host physical
@@ -3386,6 +3386,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	}
 
 	if (from_vmentry) {
+		if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3,
+		    nested_cpu_has_ept(vmcs12), &entry_failure_code))
+			goto vmentry_fail_vmexit_guest_mode;
+
 		failed_index = nested_vmx_load_msr(vcpu,
 						   vmcs12->vm_entry_msr_load_addr,
 						   vmcs12->vm_entry_msr_load_count);
-- 
2.26.2

