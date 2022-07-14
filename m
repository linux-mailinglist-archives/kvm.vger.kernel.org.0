Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EDF574810
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiGNJOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbiGNJNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:13:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 243FC101EB
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657790028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WWnZMuOiNOxV4y5n13xEbB3VoK6AwgRUiY+UTOUdEwY=;
        b=eE6yMCaoS8K55OPzIBT13V7of43DDymVzULAKLLHi0lNqLbi2rSH+1tZdRhiBl523MIdCN
        0FSJfvHSggg2zxr6pjjznI2tK5aCUER9PEfDEfo1KdA1wwVokZOfRTpGrXAgj0Qtsn1QhV
        liZnLEafidErGoQZIQImTaCfNgPrLn4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-Dzf1HZ7WN3WCQWmCPMplRw-1; Thu, 14 Jul 2022 05:13:45 -0400
X-MC-Unique: Dzf1HZ7WN3WCQWmCPMplRw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BC0B3C01DE2;
        Thu, 14 Jul 2022 09:13:45 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C3692166B26;
        Thu, 14 Jul 2022 09:13:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/25] KVM: x86: hyper-v: Cache HYPERV_CPUID_NESTED_FEATURES CPUID leaf
Date:   Thu, 14 Jul 2022 11:13:08 +0200
Message-Id: <20220714091327.1085353-7-vkuznets@redhat.com>
In-Reply-To: <20220714091327.1085353-1-vkuznets@redhat.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM has to check guest visible HYPERV_CPUID_NESTED_FEATURES.EBX CPUID
leaf to know which Enlightened VMCS definition to use (original or 2022
update). Cache the leaf along with other Hyper-V CPUID feature leaves
to make the check quick.

While on it, wipe the whole 'hv_vcpu->cpuid_cache' with memset() instead
of having to zero each particular member when the corresponding CPUID entry
was not found.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/hyperv.c           | 17 ++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index de5a149d0971..077ec9cf3169 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -616,6 +616,8 @@ struct kvm_vcpu_hv {
 		u32 enlightenments_eax; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
 		u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
 		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
+		u32 nested_eax; /* HYPERV_CPUID_NESTED_FEATURES.EAX */
+		u32 nested_ebx; /* HYPERV_CPUID_NESTED_FEATURES.EBX */
 	} cpuid_cache;
 };
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index e08189211d9a..a8e4944ca110 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2005,31 +2005,30 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 
 	hv_vcpu = to_hv_vcpu(vcpu);
 
+	memset(&hv_vcpu->cpuid_cache, 0, sizeof(hv_vcpu->cpuid_cache));
+
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES, 0);
 	if (entry) {
 		hv_vcpu->cpuid_cache.features_eax = entry->eax;
 		hv_vcpu->cpuid_cache.features_ebx = entry->ebx;
 		hv_vcpu->cpuid_cache.features_edx = entry->edx;
-	} else {
-		hv_vcpu->cpuid_cache.features_eax = 0;
-		hv_vcpu->cpuid_cache.features_ebx = 0;
-		hv_vcpu->cpuid_cache.features_edx = 0;
 	}
 
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
 	if (entry) {
 		hv_vcpu->cpuid_cache.enlightenments_eax = entry->eax;
 		hv_vcpu->cpuid_cache.enlightenments_ebx = entry->ebx;
-	} else {
-		hv_vcpu->cpuid_cache.enlightenments_eax = 0;
-		hv_vcpu->cpuid_cache.enlightenments_ebx = 0;
 	}
 
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES, 0);
 	if (entry)
 		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
-	else
-		hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
+
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_NESTED_FEATURES, 0);
+	if (entry) {
+		hv_vcpu->cpuid_cache.nested_eax = entry->eax;
+		hv_vcpu->cpuid_cache.nested_ebx = entry->ebx;
+	}
 }
 
 int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
-- 
2.35.3

