Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D78303F63
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405368AbhAZNzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:55:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405375AbhAZNuE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tpsY0e0xviLlijfaujrdZsNWzvwO2UnQqRCCRzazCpE=;
        b=a4PbkbI4Gpu1tTJT8FCRHhlYCybXe47ZcAQpjIiGLcs0ZD3+QLzgxPSxy/8vK4dMtnogTf
        kFZzg5NahBIrGBm19N7CWwXy/4GUgHFwFYqyqEHCCGE8NwoNhUqzNp6z75LKPABPG4OXV6
        FkqN3ezjSVvfIui2N+NhydX4bn+t8sM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-RVy6_fGnNcCBtfbakesy3Q-1; Tue, 26 Jan 2021 08:48:33 -0500
X-MC-Unique: RVy6_fGnNcCBtfbakesy3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6924D800FF0;
        Tue, 26 Jan 2021 13:48:32 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B3CE5D9C2;
        Tue, 26 Jan 2021 13:48:30 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 07/15] KVM: x86: hyper-v: Rename vcpu_to_hv_syndbg() to to_hv_syndbg()
Date:   Tue, 26 Jan 2021 14:48:08 +0100
Message-Id: <20210126134816.1880136-8-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu_to_hv_syndbg()'s argument is  always 'vcpu' so there's no need to have
an additional prefix. Also, this makes the code more consistent with
vmx/svm where to_vmx()/to_svm() are being used.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 ++++----
 arch/x86/kvm/hyperv.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 840628a21282..83748e016b4d 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -293,7 +293,7 @@ static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
 
 static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
 {
-	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+	struct kvm_hv_syndbg *syndbg = to_hv_syndbg(vcpu);
 	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
 
 	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNDBG;
@@ -310,7 +310,7 @@ static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
 
 static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 {
-	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+	struct kvm_hv_syndbg *syndbg = to_hv_syndbg(vcpu);
 
 	if (!kvm_hv_is_syndbg_enabled(vcpu) && !host)
 		return 1;
@@ -349,7 +349,7 @@ static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 
 static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 {
-	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+	struct kvm_hv_syndbg *syndbg = to_hv_syndbg(vcpu);
 
 	if (!kvm_hv_is_syndbg_enabled(vcpu) && !host)
 		return 1;
@@ -1855,7 +1855,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		}
 		fallthrough;
 	case HVCALL_RESET_DEBUG_SESSION: {
-		struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+		struct kvm_hv_syndbg *syndbg = to_hv_syndbg(vcpu);
 
 		if (!kvm_hv_is_syndbg_enabled(vcpu)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_CODE;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 48fcabacd339..220849cc12e5 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -73,7 +73,7 @@ static inline struct kvm_vcpu *hv_synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
 	return hv_vcpu_to_vcpu(container_of(synic, struct kvm_vcpu_hv, synic));
 }
 
-static inline struct kvm_hv_syndbg *vcpu_to_hv_syndbg(struct kvm_vcpu *vcpu)
+static inline struct kvm_hv_syndbg *to_hv_syndbg(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->kvm->arch.hyperv.hv_syndbg;
 }
-- 
2.29.2

