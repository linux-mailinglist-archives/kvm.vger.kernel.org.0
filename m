Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4461D4A6E22
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 10:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245614AbiBBJvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 04:51:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245593AbiBBJvx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 04:51:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643795512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+5zAxO3o7/6DgJdypYrIU0Jd0XAIUeE1mVBNMKw/BA=;
        b=G9dus0CQkO1WSgKkD1N0LXTbOPQv/TSqjcQBapI9l9aW3IBwY31Th92YEll+22q9BAXsq8
        6mW3lvbwPvkEXyz69q2uLez3Z2KR3LAKF1ESqSGQ+oI3jkrx3ZK0sZccGJYML1oLWcw2Ld
        JMcLWYE08mS/TggmKXoyxmr9ZBq1Z1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-kgvENJD5Pc64-wfR2_zfSw-1; Wed, 02 Feb 2022 04:51:49 -0500
X-MC-Unique: kgvENJD5Pc64-wfR2_zfSw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62A05107B27C;
        Wed,  2 Feb 2022 09:51:48 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D85DC752AA;
        Wed,  2 Feb 2022 09:51:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] KVM: x86: Make kvm_hv_hypercall_enabled() static inline
Date:   Wed,  2 Feb 2022 10:50:58 +0100
Message-Id: <20220202095100.129834-3-vkuznets@redhat.com>
In-Reply-To: <20220202095100.129834-1-vkuznets@redhat.com>
References: <20220202095100.129834-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 6e38a7d22e97..ec01ec9992d4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2017,11 +2017,6 @@ int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
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
2.34.1

