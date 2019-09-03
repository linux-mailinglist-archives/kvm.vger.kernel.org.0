Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8724BA7634
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfICVbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:31:10 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:34927 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfICVbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:31:10 -0400
Received: by mail-ua1-f73.google.com with SMTP id s1so2156809uao.2
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fcoVJDUBj34OIRUUO2z2NksJF6mZCBPDrz/OCdU83nk=;
        b=WLPCL2L5YeNIPU/YmwQrpiM+HdUhizYqnrcslkBpXahaDpIxBeCvesMsA6jgf8fPKN
         Oc91eToXaxkEYr4GCr9/c36kBI5l6z3u5I6yIMZJc6awUsTAwCTe2yHn5GIhliTpLXan
         MUk62gyEzlcyFMWKwrRjw9wYbWwdE5g+40afJpdBAFOhgP2moKbUQNDzPBxUYvQ0NVu/
         fjKrpYwKNH5VDz19yhDbD3THnK6OsDbzgdafDD4JaMyeHDoMk5FggRYChqKdYZkNXk44
         1IulWRpSljwoQlovKaZ/9PjWlPw4oTQoIOCrjjYPkfEh1EIxChophn3SgaDPqdRx1FW+
         HeQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fcoVJDUBj34OIRUUO2z2NksJF6mZCBPDrz/OCdU83nk=;
        b=LMbyFPALmiHUw+/Vba9o372vvTFJUoeakUYV1f2BUZj19X+Bm5IJx0lRcjhsumU4H6
         I7Pz/qPUaEM31FdU+7zctNCmu/1waAXjVTNF36GD0AiY/dXZhGtfhn5ENF72jikxHx7Q
         7FCp/77tFU6DxkVrHUZMwmVPGFKRhyYsKpHhrE/X6tSTxUMuc2S3ycwL3VYD7Q6j9xLG
         NvO32qcoj0Cg25lsHeK9WkkcXL+Edn2DzQmLPe+j3jlQqe4sgrFE3SrRdyLiO6d/pvZt
         hNUBvDDo+YT0EMrPkNKMrNqpqL+wsyOQpqbMx2HrFi1nZvBouX0he/bKs8W6ZhhvrVeg
         +MXQ==
X-Gm-Message-State: APjAAAUfui1EDVKY/dF8HZoMk3IocgwEfH5RGq7mhghKvqIg/+k6sVaI
        F+xz9K/S+XLnmQsNjyRvoz5zs4ZkN2HBFTZdHRc91gRKUniSOV2U7l5IHxTv0mPC3amPCZm7xA7
        xr6bRNVq+oZRjWbbDFE0QGe2NFRiqK9UMzYHZUaWBpyHgDPk7aZ7SHYw5uw==
X-Google-Smtp-Source: APXvYqxrr3wfOVp7zgG/pfTfSidkFKi/xVlRkEvGmbuuEcKs3LmA0d/RbfM1Gq7tVnF8xoxQMgSwoGaW+0M=
X-Received: by 2002:a67:ff93:: with SMTP id v19mr20214983vsq.109.1567546269033;
 Tue, 03 Sep 2019 14:31:09 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:30:38 -0700
In-Reply-To: <20190903213044.168494-1-oupton@google.com>
Message-Id: <20190903213044.168494-3-oupton@google.com>
Mime-Version: 1.0
References: <20190903213044.168494-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v2 2/8] KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on vm-entry
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

