Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3733DAC1CD
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389682AbfIFVD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:27 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:41902 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389219AbfIFVD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:26 -0400
Received: by mail-pg1-f202.google.com with SMTP id b18so4069510pgg.8
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rIn9NPomClL1C1oR3Sx9MHzrgkplOyHVIQJ1ZFuFtgk=;
        b=Wpc0JhFKhKf2jELl00nIWioGMa0TuumuUqIOxwZWJ5qRS7GI6xjZn7htlgZwZzcg/p
         cOzD/tqnhgfS9sgUp7Gv3rwHpZu9DEXDvdP/RJGMTCAtidYkopO37e2oS7AmgAf2cYRl
         7XVLAYcgMeBuAu0L23OIAX0D41b7mZ8xV9oEiKjo+5fkkrv6MX3c4xWJ5bhhk+JFjLjd
         z1Xlt440va2e+Cl7ILatq1+zz2ccB/C0Fm4OvIcBPnPYR+mdiKbexdk0gjAFFXXX9Bxw
         tfUyt7I7VU4GGgqooK7yvyl1VTyPw9QJRcy71m/JHoIvjDh+RgXQ3OnJSRA5ObuzRCPF
         GFKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rIn9NPomClL1C1oR3Sx9MHzrgkplOyHVIQJ1ZFuFtgk=;
        b=G3wHBuFe5xQI0DcJAFuCvJ1wxyq1R7TGBVRR/svhsXLeDjdFOlOGUUXjV083d2xXIC
         AMw+5Qhlm+lh+G9jUDbRbOc5LwxEw5aRf452wucb/daPxTFIwf14RqerLqLNu7ktDktZ
         NTWOElgzJqb8xNi0CTLMFmCpMsnlCY1/VHN8s/v16MO4wihCPHRgYoX5TcvLIV5RLEDD
         Qg4zizrduq8u/hOr1wzWY2iezpWSTdbaAC8EVd0sZf8vOGMyaaJHkqvrdzQYndux8V6d
         JMH5amE1sBk+PC/J1qxVgzwUUaa5Rycz6iO2g6/yLt+xG53MHqlqNvknOun7kZFCDije
         tyHw==
X-Gm-Message-State: APjAAAV4Ea5hcCmAmHrKj/RKiMoRePc5lRiCDJZAgaW31mV+YiuXXW+l
        PX6tiUfK8UXHXj2XDAPmOttnHvLg6DKuncH/D0WQpVDVo5T8yL3JOP8X/NigbZeLbClpTj0t3dq
        eW33q7B6AuAeuyoAkcsmdKV7r8AMxlN8+grEBDJ/53ddtfmqAI20FkC+f9g==
X-Google-Smtp-Source: APXvYqygPzW1l5uTdUKeMI1Pnj+mb6YzqUmAc9BbGV1djyKuVgOdZYM1b1kcZBh8tGCiCthy0YOLQUKCTQ4=
X-Received: by 2002:a65:6093:: with SMTP id t19mr9679273pgu.79.1567803805621;
 Fri, 06 Sep 2019 14:03:25 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:06 -0700
In-Reply-To: <20190906210313.128316-1-oupton@google.com>
Message-Id: <20190906210313.128316-3-oupton@google.com>
Mime-Version: 1.0
References: <20190906210313.128316-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v4 2/9] KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on vm-entry
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
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
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

