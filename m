Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7906713CA71
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 18:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgAORKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 12:10:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28871 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729025AbgAORKX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 12:10:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579108222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gSI+9ZFmzhwau+7pGCHRYVf7K5e/ts+rnUbmZcA7/DU=;
        b=DMUUJi9fk2ezS7YsVWwbPck2r8aGf1qVlMBVCp1TTTuf20bn5BFQDGJe8t4oRB942a8cYt
        TMxUn5z4K+QagrjW9IpqkXu1em+SNPZxsxzRNC6Q7PzZrSR7Nu6JM6BHbnZ21YH6ZofaIK
        AMmprF+rVOS1mAWFVkIeAIr7CYDEkIQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-0ZORqEl7N_-rWhhQLpUAtQ-1; Wed, 15 Jan 2020 12:10:20 -0500
X-MC-Unique: 0ZORqEl7N_-rWhhQLpUAtQ-1
Received: by mail-wm1-f70.google.com with SMTP id 7so96018wmf.9
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 09:10:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gSI+9ZFmzhwau+7pGCHRYVf7K5e/ts+rnUbmZcA7/DU=;
        b=I6Nyc6ztAJsluCng9CjOpGl1lAsYOX7jLvI8oQeDS8bQyOwAFuVfCBJaEEzUN3aa30
         qcT+tcChTfP1BGJWqcgwKaOmpqAjTiT2VoFpm2Bnxm1Kdtw8oT6JVDaDjOso5kJy9OU2
         pbIDHxBepa70ZnP60KvNnhpJ9rY+fShmyfKp1nQDA12RGfNyYPejvIiWXxQnUcgQlwwg
         OUxvYwUHpgCdAM3BZjJB4uNqmU/1uykFRkSqjucUmxyKEaCajYC+22UHR9drrEuxykQi
         mL7frqDkLJekMmuP8giT/531D6/ftZv1ezH35PJvGgn5PRxy2+QTyObpt3OHutVmZ6yU
         5r2A==
X-Gm-Message-State: APjAAAX60BVRmUdZKNgNdJJ5/dUXTV56W4ynsHyUteX03YY4cYNhJ7fJ
        kASLr+aqtHZ0fX4uv8p9fOofz/M3vweFEK7ezjuy3vp8dKmtywL5l3rPv8yPoIHpMWacLaWtvSq
        dvP5OrQoneefR
X-Received: by 2002:a1c:e108:: with SMTP id y8mr852716wmg.147.1579108219183;
        Wed, 15 Jan 2020 09:10:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqwooCNRjva1ReNTUjIwvyiUsGeGB/7NwFSnSMiE2Ww25Pqyumx/tXtSDOemmBM4vZewR+hQwA==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr852697wmg.147.1579108218968;
        Wed, 15 Jan 2020 09:10:18 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y20sm525071wmi.25.2020.01.15.09.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 09:10:18 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
Date:   Wed, 15 Jan 2020 18:10:13 +0100
Message-Id: <20200115171014.56405-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115171014.56405-1-vkuznets@redhat.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
with default (matching CPU model) values and in case eVMCS is also enabled,
fails.

It would be possible to drop VMX feature filtering completely and make
this a guest's responsibility: if it decides to use eVMCS it should know
which fields are available and which are not. Hyper-V mostly complies to
this, however, there is at least one problematic control:
SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
which Hyper-V enables. As there is no 'apic_addr_field' in eVMCS, we
fail to handle this properly in KVM. It is unclear how this is supposed
to work, genuine Hyper-V doesn't expose the control so it is possible that
this is just a bug (in Hyper-V).

Move VMX controls sanitization from nested_enable_evmcs() to vmx_get_msr(),
this allows userspace to keep setting controls it wants and at the same
time hides them from the guest.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 38 ++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/evmcs.h |  1 +
 arch/x86/kvm/vmx/vmx.c   | 10 ++++++++--
 3 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 89c3e0caf39f..b5d6582ba589 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -346,6 +346,38 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
        return 0;
 }
 
+void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
+{
+	u32 ctl_low = (u32)*pdata, ctl_high = (u32)(*pdata >> 32);
+	/*
+	 * Enlightened VMCS doesn't have certain fields, make sure we don't
+	 * expose unsupported controls to L1.
+	 */
+
+	switch (msr_index) {
+	case MSR_IA32_VMX_PINBASED_CTLS:
+	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
+		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
+		break;
+	case MSR_IA32_VMX_EXIT_CTLS:
+	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
+		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+		break;
+	case MSR_IA32_VMX_ENTRY_CTLS:
+	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
+		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+		break;
+	case MSR_IA32_VMX_PROCBASED_CTLS2:
+		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+		break;
+	case MSR_IA32_VMX_VMFUNC:
+		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
+		break;
+	}
+
+	*pdata = ctl_low | ((u64)ctl_high << 32);
+}
+
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version)
 {
@@ -356,11 +388,5 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	if (vmcs_version)
 		*vmcs_version = nested_get_evmcs_version(vcpu);
 
-	vmx->nested.msrs.pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
-	vmx->nested.msrs.entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
-	vmx->nested.msrs.exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
-	vmx->nested.msrs.secondary_ctls_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
-	vmx->nested.msrs.vmfunc_controls &= ~EVMCS1_UNSUPPORTED_VMFUNC;
-
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 07ebf6882a45..b88d9807a796 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -201,5 +201,6 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
+void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e3394c839dea..8eb74618b8d8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1849,8 +1849,14 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
-		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
-				       &msr_info->data);
+		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
+				    &msr_info->data))
+			return 1;
+		if (!msr_info->host_initiated &&
+		    vmx->nested.enlightened_vmcs_enabled)
+			nested_evmcs_filter_control_msr(msr_info->index,
+							&msr_info->data);
+		break;
 	case MSR_IA32_RTIT_CTL:
 		if (pt_mode != PT_MODE_HOST_GUEST)
 			return 1;
-- 
2.24.1

