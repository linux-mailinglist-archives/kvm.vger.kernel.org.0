Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEC847AFF1
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 16:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbhLTPWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 10:22:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238970AbhLTPWB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 10:22:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640013720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FP3DwunQx7p6srKc46gw0D0pDBIx3Pbid5fjKPk+1z8=;
        b=Quwt9c52/Q9vPiKMFWJV62qNQusdEWzZno8IsEV+6KatjDuzcEX3gWaq2WLl4Di6INQ1/J
        S8BoeRVI/0lrZ6QmKSEJ7FysKRihdTYBwNoAj/oHEflQ+kbCVuhHB/Qwv0rZ+UvZKgweW7
        XYkxYM4gZIaLsPGL31OzCDzFpVfNtJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-apiiwdqpPOCVBpP9d8oF0Q-1; Mon, 20 Dec 2021 10:21:57 -0500
X-MC-Unique: apiiwdqpPOCVBpP9d8oF0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23F4E10144E3;
        Mon, 20 Dec 2021 15:21:56 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A6B07B6CE;
        Mon, 20 Dec 2021 15:21:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] KVM: x86: Make kvm_hv_hypercall_enabled() static inline
Date:   Mon, 20 Dec 2021 16:21:38 +0100
Message-Id: <20211220152139.418372-5-vkuznets@redhat.com>
In-Reply-To: <20211220152139.418372-1-vkuznets@redhat.com>
References: <20211220152139.418372-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for using kvm_hv_hypercall_enabled() from SVM code, make
it static inline to avoid the need to export it. The function is a
simple check with only two call sites currently.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 5 -----
 arch/x86/kvm/hyperv.h | 6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a91424ed436d..c008522112f6 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2014,11 +2014,6 @@ int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
 	return ret;
 }
 
-bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.hyperv_enabled && to_kvm_hv(vcpu->kvm)->hv_guest_os_id;
-}
-
 static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
 {
 	bool longmode;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index ed1c4e546d04..e19c00ee9ab3 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -89,7 +89,11 @@ static inline u32 kvm_hv_get_vpindex(struct kvm_vcpu *vcpu)
 int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host);
 int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host);
 
-bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu);
+static inline bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.hyperv_enabled && to_kvm_hv(vcpu->kvm)->hv_guest_os_id;
+}
+
 int kvm_hv_hypercall(struct kvm_vcpu *vcpu);
 
 void kvm_hv_irq_routing_update(struct kvm *kvm);
-- 
2.33.1

