Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91606351D09
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbhDASXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:23:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237580AbhDASTe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9aUFvHt7mQEVQvq6O/qae5XzUKivnWMmQmmtY0Fkd8Q=;
        b=T+AH+xRyJdoxQ2KTftJlEzrCfz44jQ8ovo1Fvw/G7ZIEXG5imY+jUHRSzHTvw9PZ2CPVHQ
        xpNSSR8muTIlxOBIytI7cZc3/jDpKA5VmnoP7WK7WgnRQpfI4IGiQ1RBkDgkkivXT0MqMD
        RMyrfx+xkSKmqrTdeo+zSlfCRGPal5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-lb7iUHZ0PTuPMwlwpDYC3g-1; Thu, 01 Apr 2021 10:19:05 -0400
X-MC-Unique: lb7iUHZ0PTuPMwlwpDYC3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 334FD108BD0C;
        Thu,  1 Apr 2021 14:18:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7729559464;
        Thu,  1 Apr 2021 14:18:20 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/6] KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES
Date:   Thu,  1 Apr 2021 17:18:09 +0300
Message-Id: <20210401141814.1029036-2-mlevitsk@redhat.com>
In-Reply-To: <20210401141814.1029036-1-mlevitsk@redhat.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to the rest of guest page accesses after migration,
this should be delayed to KVM_REQ_GET_NESTED_STATE_PAGES
request.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fd334e4aa6db..b44f1f6b68db 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2564,11 +2564,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
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
@@ -3109,11 +3104,16 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
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
@@ -3357,6 +3357,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
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

