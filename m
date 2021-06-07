Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E5039D82D
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhFGJEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:04:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231140AbhFGJEk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623056568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a1x3cJ7fuESoDFA2zX8IZr7gZ6GLRtHzGjGBjFpYGZ8=;
        b=IMeHzOlleX60rqTN/jLtNkDAObohCtWVgRydY3KssF2VQpGuK4lHGRqQAk6jrLe2FtAf0p
        rXlzyMAOKXHuHSuKfcEgagw5leAO+0Z+abUtdVVqVoxkL2gZOwas9ISzD1conBgmYWg2oQ
        wAzB84s/PlQPsI18iD2mhHJWlY9NonI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-noBIeJHeP4qSUWHqOcnSlg-1; Mon, 07 Jun 2021 05:02:45 -0400
X-MC-Unique: noBIeJHeP4qSUWHqOcnSlg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D555800D62;
        Mon,  7 Jun 2021 09:02:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3906B100EB3D;
        Mon,  7 Jun 2021 09:02:38 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 5/8] KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES
Date:   Mon,  7 Jun 2021 12:02:00 +0300
Message-Id: <20210607090203.133058-6-mlevitsk@redhat.com>
In-Reply-To: <20210607090203.133058-1-mlevitsk@redhat.com>
References: <20210607090203.133058-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to the rest of guest page accesses after a migration,
this access should be delayed to KVM_REQ_GET_NESTED_STATE_PAGES.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c45189898a64..0acdda85f36a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1105,7 +1105,8 @@ static bool nested_vmx_transition_mmu_sync(struct kvm_vcpu *vcpu)
  * Exit Qualification (for a VM-Entry consistency check VM-Exit) is assigned to
  * @entry_failure_code.
  */
-static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
+static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
+			       bool nested_ept, bool reload_pdptrs,
 			       enum vm_entry_failure_code *entry_failure_code)
 {
 	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3))) {
@@ -1117,7 +1118,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 	 * If PAE paging and EPT are both on, CR3 is not used by the CPU and
 	 * must not be dereferenced.
 	 */
-	if (!nested_ept && is_pae_paging(vcpu) &&
+	if (reload_pdptrs && !nested_ept && is_pae_paging(vcpu) &&
 	    CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))) {
 		*entry_failure_code = ENTRY_FAIL_PDPTE;
 		return -EINVAL;
@@ -2486,6 +2487,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
  * is assigned to entry_failure_code on failure.
  */
 static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
+			  bool from_vmentry,
 			  enum vm_entry_failure_code *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2570,7 +2572,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	/* Shadow page tables on either EPT or shadow page tables. */
 	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
-				entry_failure_code))
+			from_vmentry, entry_failure_code))
 		return -EINVAL;
 
 	/*
@@ -3111,6 +3113,17 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	struct page *page;
 	u64 hpa;
 
+	if (!nested_cpu_has_ept(vmcs12) && is_pae_paging(vcpu)) {
+		/*
+		 * Reload the guest's PDPTRs since after a migration
+		 * the guest CR3 might be restored prior to setting the nested
+		 * state which can lead to a load of wrong PDPTRs.
+		 */
+		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, vcpu->arch.cr3)))
+			return false;
+	}
+
+
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
 		/*
 		 * Translate L1 physical address to host physical
@@ -3355,7 +3368,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
-	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
+	if (prepare_vmcs02(vcpu, vmcs12, from_vmentry, &entry_failure_code)) {
 		exit_reason.basic = EXIT_REASON_INVALID_STATE;
 		vmcs12->exit_qualification = entry_failure_code;
 		goto vmentry_fail_vmexit_guest_mode;
@@ -4204,7 +4217,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * Only PDPTE load can fail as the value of cr3 was checked on entry and
 	 * couldn't have changed.
 	 */
-	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &ignored))
+	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, true, &ignored))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_PDPTE_FAIL);
 
 	nested_vmx_transition_tlb_flush(vcpu, vmcs12, false);
-- 
2.26.3

