Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18412A0E53
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfH1Xlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 19:41:46 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:50925 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbfH1Xlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:41:46 -0400
Received: by mail-vk1-f202.google.com with SMTP id s80so551013vkb.17
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 16:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3vgRlAdiubv4FD8plCY+AKTSbCzEQadgBmoXvPUQnV8=;
        b=sD40BLYw+Yf8j9JZzygEL7lxywdE/gIzKyrx2ChyuqAsWlffKJJebL2/ZFsA827sOP
         g/Q+Cn//0hwb0pEteCDY7melHoRj4XA2lkKe2pvcWVE8/gKYFEIXyLaUiAXbON73VIUi
         QuJHv6zF6rcccBZGvXQ4ZtNO3VNJulu2iy0Bjl18ifaP2oTzvKhskhkY+vzE8BkUHabG
         UQ4OuzLXrAFhzWpt/SqXsA6GfvbRiK0nvViw/FNm32DKOi491I61GBv8G0/3T5fsZcnp
         3iMxwCIhEz+OYvIL/M3I79OAjZjINo8U7+jScyrS5+MtQKsfOElMbLP8Uxw39hDl4DGD
         ouYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3vgRlAdiubv4FD8plCY+AKTSbCzEQadgBmoXvPUQnV8=;
        b=UYFWm3ATV8B5jG1c25iq7emrwwKd8QyayLpyrAm0dw5EM/D2XLze9eRtlCpZ74IXzT
         xLpdlWvAZpHo8rvS67Es4PJBqMY93igk94iOTF9PoBD0mx46y11YN41lSO3QFnbn1/8x
         RfZXekuAjUzQig83jbVVjkbe8iaY5HInYE5t8iktZ4l3+lWFWtlSaTiZC4a0bAMDs85P
         tGstCNl2seg1NmSTKRp16ewQcgll8pr9+4Jdaljv7QLHTQKchAHL1C+wamMdWR4SQgwS
         LW7355F8eld5yRV9ff0nuni5brgeevpALpxHs8pF7nBsfXInhpf1fbsh2hT0K1Z34n1e
         nI+Q==
X-Gm-Message-State: APjAAAVH32hBwoV0a1xYkwf0pt9dKRIPpi4ahmwWFxlSu35DtAKGibnw
        YbcGkzZLrZIiK9Bw9xfFlyii2poNyMvFZa4YzfKM5X+eV1kSQaOevDghDqeFs39gDiHraC2O7v2
        /C5yBmCx+HkNMFzl/y1h9F23mDYp3sCOr1nqNsXBrBbD0/OINIfA5rITLeg==
X-Google-Smtp-Source: APXvYqzFghpjrkPZx7c6kAXS/z73mE8TvAVkrmeGe4EVrPonCiZy/GzQaq4vZYwXYwj0vI15xuV8MrviSho=
X-Received: by 2002:ab0:5ad1:: with SMTP id x17mr3627273uae.52.1567035704746;
 Wed, 28 Aug 2019 16:41:44 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:41:29 -0700
In-Reply-To: <20190828234134.132704-1-oupton@google.com>
Message-Id: <20190828234134.132704-3-oupton@google.com>
Mime-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH 2/7] KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on vmentry
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the "load IA32_PERF_GLOBAL_CTRL" bit on the VM-entry control is
set, the IA32_PERF_GLOBAL_CTRL MSR is loaded from GUEST_IA32_PERF_GLOBAL_CTRL
on VM-entry. Adding condition to prepare_vmcs02 to set
MSR_CORE_PERF_GLOBAL_CTRL if the "load IA32_PERF_GLOBAL_CTRL" bit is set.

Suggested-by: Jim Mattson <jmattson@google.com>
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

