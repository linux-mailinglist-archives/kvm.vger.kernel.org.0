Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FD6351D11
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhDASXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:23:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235939AbhDASVV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WlBzUmQIaLiHOw5/yjj3BVYLHvfo1ik70BDKHEskwu8=;
        b=UdWKTfC9Dzrb7vKR8T4FVKF2LzV9hr4C9AIE5ZgV4kLz5ZbTSvS1fnUSdNS23yMze/ukTF
        eF95e2/tV3QpxrX+4Tv40J9aqzzKnojoTXXeOYHqAYL+wS5xy0HZvuLVrURN6D1D3reaZe
        JfYSZL7vu4pAQbszkFz/ZG6rGnRUmKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-ImBqt0amPAeNy_P23ZThQQ-1; Thu, 01 Apr 2021 10:18:52 -0400
X-MC-Unique: ImBqt0amPAeNy_P23ZThQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93372100A67B;
        Thu,  1 Apr 2021 14:18:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D42E659464;
        Thu,  1 Apr 2021 14:18:43 +0000 (UTC)
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
Subject: [PATCH 6/6] KVM: nVMX: avoid loading PDPTRs after migration when possible
Date:   Thu,  1 Apr 2021 17:18:14 +0300
Message-Id: <20210401141814.1029036-7-mlevitsk@redhat.com>
In-Reply-To: <20210401141814.1029036-1-mlevitsk@redhat.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

if new KVM_*_SREGS2 ioctls are used, the PDPTRs are
part of the migration state and thus are loaded
by those ioctls.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b44f1f6b68db..f2291165995e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1115,7 +1115,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 	 * must not be dereferenced.
 	 */
 	if (!nested_ept && is_pae_paging(vcpu) &&
-	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
+	    (cr3 != kvm_read_cr3(vcpu) || !kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))) {
 		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))) {
 			*entry_failure_code = ENTRY_FAIL_PDPTE;
 			return -EINVAL;
@@ -3110,6 +3110,14 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	struct page *page;
 	u64 hpa;
 
+	if (vcpu->arch.reload_pdptrs_on_nested_entry) {
+		/* if legacy KVM_SET_SREGS API was used, it might have loaded
+		 * wrong PDPTRs from memory so we have to reload them here
+		 * (which is against x86 spec)
+		 */
+		kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
+	}
+
 	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
 				&entry_failure_code))
 		return false;
@@ -3357,6 +3365,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	}
 
 	if (from_vmentry) {
+		kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
 		if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3,
 		    nested_cpu_has_ept(vmcs12), &entry_failure_code))
 			goto vmentry_fail_vmexit_guest_mode;
@@ -4195,6 +4204,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * Only PDPTE load can fail as the value of cr3 was checked on entry and
 	 * couldn't have changed.
 	 */
+	kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
 	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &ignored))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_PDPTE_FAIL);
 
-- 
2.26.2

