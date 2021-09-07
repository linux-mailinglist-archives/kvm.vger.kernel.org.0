Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003FE402CE5
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343595AbhIGQgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:36:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245473AbhIGQgm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 12:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631032536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d7P/NNV3COGnyOtvU4IPpGxMeqh1NqSkekuXhYHEkos=;
        b=HCJKpkT+FAn3aHFLh1rb89PxSWhKKRZbiyzNJu2/+qLOQ5fg31X67BwdF16jsrRcpHrfH6
        o1cyDdHnGzV4uYRhwVipXUTCYapk9ZPsTctcxuxql+X3Tf2DiRcxiKCjj0k3sJEmjTd5PN
        SM5hl4JbYsPyi9orTChE5en8ayNRO9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-mWjfO9G3NMaZzJ1frh6-nw-1; Tue, 07 Sep 2021 12:35:34 -0400
X-MC-Unique: mWjfO9G3NMaZzJ1frh6-nw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B20B835DF0;
        Tue,  7 Sep 2021 16:35:33 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B328710BD;
        Tue,  7 Sep 2021 16:35:31 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Filter out all unsupported controls when eVMCS was activated
Date:   Tue,  7 Sep 2021 18:35:30 +0200
Message-Id: <20210907163530.110066-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Windows Server 2022 with Hyper-V role enabled failed to boot on KVM when
enlightened VMCS is advertised. Debugging revealed there are two exposed
secondary controls it is not happy with: SECONDARY_EXEC_ENABLE_VMFUNC and
SECONDARY_EXEC_SHADOW_VMCS. These controls are known to be unsupported,
as there are no corresponding fields in eVMCSv1 (see the comment above
EVMCS1_UNSUPPORTED_2NDEXEC definition).

Previously, commit 31de3d2500e4 ("x86/kvm/hyper-v: move VMX controls
sanitization out of nested_enable_evmcs()") introduced the required
filtering mechanism for VMX MSRs but for some reason put only known
to be problematic (and not full EVMCS1_UNSUPPORTED_* lists) controls
there.

Note, Windows Server 2022 seems to have gained some sanity check for VMX
MSRs: it doesn't even try to launch a guest when there's something it
doesn't like, nested_evmcs_check_controls() mechanism can't catch the
problem.

Let's be bold this time and instead of playing whack-a-mole just filter out
all unsupported controls from VMX MSRs.

Fixes: 31de3d2500e4 ("x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 12 +++++++++---
 arch/x86/kvm/vmx/vmx.c   |  9 +++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 0dab1b7b529f..ba6f99f584ac 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -353,14 +353,20 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		ctl_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
 		break;
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		ctl_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+		break;
+	case MSR_IA32_VMX_PINBASED_CTLS:
+		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
+		break;
+	case MSR_IA32_VMX_VMFUNC:
+		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
 		break;
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..d7c5257eb5c0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1837,10 +1837,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				    &msr_info->data))
 			return 1;
 		/*
-		 * Enlightened VMCS v1 doesn't have certain fields, but buggy
-		 * Hyper-V versions are still trying to use corresponding
-		 * features when they are exposed. Filter out the essential
-		 * minimum.
+		 * Enlightened VMCS v1 doesn't have certain VMCS fields but
+		 * instead of just ignoring the features, different Hyper-V
+		 * versions are either trying to use them and fail or do some
+		 * sanity checking and refuse to boot. Filter all unsupported
+		 * features out.
 		 */
 		if (!msr_info->host_initiated &&
 		    vmx->nested.enlightened_vmcs_enabled)
-- 
2.31.1

