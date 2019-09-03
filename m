Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D769DA769B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfICV6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:58:11 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:47518 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfICV6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:58:11 -0400
Received: by mail-pf1-f201.google.com with SMTP id t65so6822141pfd.14
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fcoVJDUBj34OIRUUO2z2NksJF6mZCBPDrz/OCdU83nk=;
        b=j7BQYA63JpJqVOR5aEh4D6opVG/GYwcDtirUeR+Ydzume/HQNBBbIUcYglPCgXEdF9
         6/asZ9/8VREqh454J+sOuIoMO5vTF5SgMDFxB1BHJjd3DfcCHJ5HV+n/djK8+PNM6ht6
         bV7faZAXSXo0nOC6AqsiNUsN7TLXOaDQHpErnh+J9iQQZQ/niGSKnr0M+u5OfMvXyJTh
         cSlESh+hTZBjVqgyXgrObxS6GtZF7ae/dMvCiGoyGWHukS/Ai/Ui4hWwWNdszSVjNyyu
         bbTv/eci8dlEfXr6/dSz1VhUrIoxxVUGjfc/697GH3D3GxDW55KqZDQ/rK9UlihhCQ6s
         ye3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fcoVJDUBj34OIRUUO2z2NksJF6mZCBPDrz/OCdU83nk=;
        b=qFjnBFnO8HqHl39NufiYQKYHX5pKCeEZaFMiNaoQ2gOafeVO1bH2zTHnqeQOS3akmN
         Cpa4cV1uty7FhIGxj0gU7XZuSc9lkGsk3Sf6PDsBkLYvqdm4M8ElD95d89kV/3RWpavm
         gmroXJHDhy3vWiUnjuqEDadI6le0Y/C0oWAPqccnqeBoGZI0mtwzmimAAW4JAeZ98Bvb
         yk8tnQtqGSF5YKBHCdONUkTlNSjxlmdPiD42pUlgJSscdFkRM2dV5lpW8+EHRLGInCkE
         wWHylBvd+VzYG47m5V8fXq1knXkMY5D2jVgoN3gEXY0VpLmXF6TrB5VUTZAHQnbpdmMe
         tN4A==
X-Gm-Message-State: APjAAAUnS8NTSj/wvw7JfZtTSFxf4FwzcWyhghgXqtD/dI6cmQ6wU24U
        rvJteNB4Yw3JfIGSGCOMK6evv1AG22GEue5RTzkDvzRZG18x/NlGO5F7sZirRGym2ucVSDLxCXu
        sRdwMZZ5MzqGNkL8i4h8twuNBnNR5IO1Mm4QEBT6Ky1t3GZWHa8HCm022Fw==
X-Google-Smtp-Source: APXvYqxWgOK4N6r7+8i9Jga2cqoWS7suhD2Oxa0gNlgODI2Z/700nGhN1P83tbtmf6Yg4/PM4l/9likjiiE=
X-Received: by 2002:a65:6114:: with SMTP id z20mr32656978pgu.141.1567547889917;
 Tue, 03 Sep 2019 14:58:09 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:57:55 -0700
In-Reply-To: <20190903215801.183193-1-oupton@google.com>
Message-Id: <20190903215801.183193-3-oupton@google.com>
Mime-Version: 1.0
References: <20190903215801.183193-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v3 2/8] KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on vm-entry
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add condition to prepare_vmcs02 which loads IA32_PERF_GLOBAL_CTRL on
VM-entry if the "load IA32_PERF_GLOBAL_CTRL" bit on the VM-entry control
is set. Use kvm_set_msr() rather than directly writing to the field to
avoid overwrite by atomic_switch_perf_msrs().

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b0ca34bf4d21..9ba90b38d74b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2281,6 +2281,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
+	struct msr_data msr_info;
 	bool load_guest_pdptrs_vmcs12 = false;
 
 	if (vmx->nested.dirty_vmcs12 || hv_evmcs) {
@@ -2404,6 +2405,16 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (!enable_ept)
 		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
+		msr_info.host_initiated = false;
+		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
+		msr_info.data = vmcs12->guest_ia32_perf_global_ctrl;
+		if (kvm_set_msr(vcpu, &msr_info))
+			pr_debug_ratelimited(
+				"%s cannot write MSR (0x%x, 0x%llx)\n",
+				__func__, msr_info.index, msr_info.data);
+	}
+
 	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
 	kvm_rip_write(vcpu, vmcs12->guest_rip);
 	return 0;
-- 
2.23.0.187.g17f5b7556c-goog

