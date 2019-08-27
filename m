Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8869EFA8
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 18:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbfH0QEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 12:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729671AbfH0QEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 12:04:11 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 888332A09AB
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 16:04:10 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id u21so1251026wml.4
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 09:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VhVONP1yOZ9qqPvIKZXfSIL1EWyqy2BDr9yNoXDMCHw=;
        b=EHmNeSx45OpPCG7zpjVVgC1B2inGdu+3oGC2JPh3hyfJi+L04QQLzM4IBLmOCdVFZe
         SqQ6yEHYtLuBF5BOyBWRH2O0u590Bj9YVwT0t3wlp9+UyhVz3p/xxxKwI4OZt6Lzp8P1
         V4uXa2qcO3lI4HvLs0GebY0QyVzuXmRT0mkxVygjU+NgDWjOZ3sUEvErkBhB7UA89Ykt
         V0oHCenXPWwNa0idH5u5O4hQ9B8IATJrCvF1o7dVQVAzUXuODUGNrpfj/CUas42z7fjh
         ludOikRpR3WuayC7YHVoEYODccqLPrYN+wGix1W+wI44rUhliTaWhu3RKWVgWNfBtxan
         Vduw==
X-Gm-Message-State: APjAAAXTw7ajOFzceHIV7CP51Kub2ROa18T/+SWb0lv/CYCaSbhpeYCE
        O1MjVqYt7dOSJyo4FEpiBDse+d7RcCLvBheCvLg8K9+lHedFHFK1B7rx+ltWyJqIASIRLhWghlp
        oae4MhwjNdtlR
X-Received: by 2002:a1c:f110:: with SMTP id p16mr28612684wmh.59.1566921848499;
        Tue, 27 Aug 2019 09:04:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwQuwukGsraHaatE4hAj0LDnedGOIKHMZOGMIdh4CEFhBseJtI9ADNJhCCUprGZX99+Uaeilg==
X-Received: by 2002:a1c:f110:: with SMTP id p16mr28612666wmh.59.1566921848295;
        Tue, 27 Aug 2019 09:04:08 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n8sm13461246wro.89.2019.08.27.09.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 09:04:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH 1/3] KVM: x86: hyper-v: don't crash on KVM_GET_SUPPORTED_HV_CPUID when kvm_intel.nested is disabled
Date:   Tue, 27 Aug 2019 18:04:02 +0200
Message-Id: <20190827160404.14098-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190827160404.14098-1-vkuznets@redhat.com>
References: <20190827160404.14098-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If kvm_intel is loaded with nested=0 parameter an attempt to perform
KVM_GET_SUPPORTED_HV_CPUID results in OOPS as nested_get_evmcs_version hook
in kvm_x86_ops is NULL (we assign it in nested_vmx_hardware_setup() and
this only happens in case nested is enabled).

Check that kvm_x86_ops->nested_get_evmcs_version is not NULL before
calling it. With this, we can remove the stub from svm as it is no
longer needed.

Fixes: e2e871ab2f02 ("x86/kvm/hyper-v: Introduce nested_get_evmcs_version() helper")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c  | 5 ++++-
 arch/x86/kvm/svm.c     | 8 +-------
 arch/x86/kvm/vmx/vmx.c | 1 +
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 58bf61b17431..3f5ad84853fb 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1785,7 +1785,7 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args)
 int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 				struct kvm_cpuid_entry2 __user *entries)
 {
-	uint16_t evmcs_ver = kvm_x86_ops->nested_get_evmcs_version(vcpu);
+	uint16_t evmcs_ver = 0;
 	struct kvm_cpuid_entry2 cpuid_entries[] = {
 		{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
 		{ .function = HYPERV_CPUID_INTERFACE },
@@ -1797,6 +1797,9 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 	};
 	int i, nent = ARRAY_SIZE(cpuid_entries);
 
+	if (kvm_x86_ops->nested_get_evmcs_version)
+		evmcs_ver = kvm_x86_ops->nested_get_evmcs_version(vcpu);
+
 	/* Skip NESTED_FEATURES if eVMCS is not supported */
 	if (!evmcs_ver)
 		--nent;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 572c7c4ca974..40175c42f116 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7122,12 +7122,6 @@ static int svm_unregister_enc_region(struct kvm *kvm,
 	return ret;
 }
 
-static uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
-{
-	/* Not supported */
-	return 0;
-}
-
 static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 				   uint16_t *vmcs_version)
 {
@@ -7344,7 +7338,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.mem_enc_unreg_region = svm_unregister_enc_region,
 
 	.nested_enable_evmcs = nested_enable_evmcs,
-	.nested_get_evmcs_version = nested_get_evmcs_version,
+	.nested_get_evmcs_version = NULL,
 
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3c936e7366b9..c81e5210b159 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7812,6 +7812,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_nested_state = NULL,
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
+	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 };
-- 
2.20.1

