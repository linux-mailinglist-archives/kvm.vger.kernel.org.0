Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BFC5A64FA
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiH3NiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiH3NiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:38:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C77E8687
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=chPmOM7qhlrImHiruqIlAyoMO1lUXpPxIodNACRsyik=;
        b=MIoZct1hLLa0RhQuDAkmUPg0o+HXVEVRb7I8o5sKVVlG1PBOapD1dXZ9cU47FSn3UZMkac
        J6Wa/BSPFeMQMCQ3wdfe7w/EnwU0llAEz2oI4Y1vK3BnQWvkW+QG7eDG7Bvg96AbqBJ+Uj
        X4CvVscbTVwzGnVBa/BAd8KvYkv9VU4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-6ItNH4xKPFKIhrgQYBZXKQ-1; Tue, 30 Aug 2022 09:37:50 -0400
X-MC-Unique: 6ItNH4xKPFKIhrgQYBZXKQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C2A72999B44;
        Tue, 30 Aug 2022 13:37:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D0612166B26;
        Tue, 30 Aug 2022 13:37:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 04/33] KVM: x86: Check for existing Hyper-V vCPU in kvm_hv_vcpu_init()
Date:   Tue, 30 Aug 2022 15:37:08 +0200
Message-Id: <20220830133737.1539624-5-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

When potentially allocating/initializing the Hyper-V vCPU struct, check
for an existing instance in kvm_hv_vcpu_init() instead of requiring
callers to perform the check.  Relying on callers to do the check is
risky as it's all too easy for KVM to overwrite vcpu->arch.hyperv and
leak memory, and it adds additional burden on callers without much
benefit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 611c349a08bf..8aadd31ed058 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -936,9 +936,12 @@ static void stimer_init(struct kvm_vcpu_hv_stimer *stimer, int timer_index)
 
 static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu_hv *hv_vcpu;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	int i;
 
+	if (hv_vcpu)
+		return 0;
+
 	hv_vcpu = kzalloc(sizeof(struct kvm_vcpu_hv), GFP_KERNEL_ACCOUNT);
 	if (!hv_vcpu)
 		return -ENOMEM;
@@ -962,11 +965,9 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 	struct kvm_vcpu_hv_synic *synic;
 	int r;
 
-	if (!to_hv_vcpu(vcpu)) {
-		r = kvm_hv_vcpu_init(vcpu);
-		if (r)
-			return r;
-	}
+	r = kvm_hv_vcpu_init(vcpu);
+	if (r)
+		return r;
 
 	synic = to_hv_synic(vcpu);
 
@@ -1660,10 +1661,8 @@ int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	if (!host && !vcpu->arch.hyperv_enabled)
 		return 1;
 
-	if (!to_hv_vcpu(vcpu)) {
-		if (kvm_hv_vcpu_init(vcpu))
-			return 1;
-	}
+	if (kvm_hv_vcpu_init(vcpu))
+		return 1;
 
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
@@ -1683,10 +1682,8 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	if (!host && !vcpu->arch.hyperv_enabled)
 		return 1;
 
-	if (!to_hv_vcpu(vcpu)) {
-		if (kvm_hv_vcpu_init(vcpu))
-			return 1;
-	}
+	if (kvm_hv_vcpu_init(vcpu))
+		return 1;
 
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
@@ -2000,7 +1997,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	if (!to_hv_vcpu(vcpu) && kvm_hv_vcpu_init(vcpu))
+	if (kvm_hv_vcpu_init(vcpu))
 		return;
 
 	hv_vcpu = to_hv_vcpu(vcpu);
-- 
2.37.2

