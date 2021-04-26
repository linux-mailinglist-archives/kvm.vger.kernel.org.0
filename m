Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF80A36B22B
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 13:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhDZLPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 07:15:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233175AbhDZLPA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 07:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619435659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TKfvE8oibA5Af5AMQD+FUNvDXP+Vag8vnYKYwkJFS8A=;
        b=HE8sTVdpThWWo+wYx029RU/ImN/HO86tRmpVbLTL+M8adFvVLRnrejF9bYNP4XxsVDJIPD
        cSmc5OLT16pWkACsxkrGPma8BobobnPAU0Hz+U97h4oB7iA4ZtdbVNWMtrUE0W2rh6gsbP
        qlQlT3CyVCxed/FaDQOB8HfPGofVL0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-M_ftKx9SM5yO3MfvTUGC2g-1; Mon, 26 Apr 2021 07:14:15 -0400
X-MC-Unique: M_ftKx9SM5yO3MfvTUGC2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A0051083EA3;
        Mon, 26 Apr 2021 11:13:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56E075D9D0;
        Mon, 26 Apr 2021 11:13:46 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/6] KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES
Date:   Mon, 26 Apr 2021 14:13:29 +0300
Message-Id: <20210426111333.967729-3-mlevitsk@redhat.com>
In-Reply-To: <20210426111333.967729-1-mlevitsk@redhat.com>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 00339d624c92..764781ab805b 100644
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
 	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
 		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))) {
 			*entry_failure_code = ENTRY_FAIL_PDPTE;
@@ -2488,6 +2489,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
  * is assigned to entry_failure_code on failure.
  */
 static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
+			  bool from_vmentry,
 			  enum vm_entry_failure_code *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2572,7 +2574,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	/* Shadow page tables on either EPT or shadow page tables. */
 	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
-				entry_failure_code))
+			from_vmentry, entry_failure_code))
 		return -EINVAL;
 
 	/*
@@ -3120,6 +3122,17 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
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
@@ -3356,7 +3369,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
-	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
+	if (prepare_vmcs02(vcpu, vmcs12, from_vmentry, &entry_failure_code)) {
 		exit_reason.basic = EXIT_REASON_INVALID_STATE;
 		vmcs12->exit_qualification = entry_failure_code;
 		goto vmentry_fail_vmexit_guest_mode;
@@ -4205,7 +4218,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * Only PDPTE load can fail as the value of cr3 was checked on entry and
 	 * couldn't have changed.
 	 */
-	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &ignored))
+	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, true, &ignored))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_PDPTE_FAIL);
 
 	nested_vmx_transition_tlb_flush(vcpu, vmcs12, false);
-- 
2.26.2

