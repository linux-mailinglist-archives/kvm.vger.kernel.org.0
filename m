Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAE35A64F0
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiH3NiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiH3NiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:38:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7EFDF67E
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LrzmbPm+tycZBHhI1G8vuHQjq7oQ9rfR1GCodDG7KWI=;
        b=a1u4PsdWP8eswdPFyG+pCD5KIib3Ks7T9u+tjJx6ieTfmFJVrI+6FKn6zqA2+JeUY7XWwZ
        y1XWh95rPD4Dl7fe2xbvlIDPOi9mdSA3dxZwQoUGN0YJtQXenEfEftMHkX/0iZ7xLIhM4O
        ry79rr88pYNLPsVylModU/umYVaJRp4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-NbRcTKNIPVa_7kabNhyQYQ-1; Tue, 30 Aug 2022 09:37:47 -0400
X-MC-Unique: NbRcTKNIPVa_7kabNhyQYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 358EF85A58A;
        Tue, 30 Aug 2022 13:37:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34A962166B26;
        Tue, 30 Aug 2022 13:37:45 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 03/33] KVM: x86: Zero out entire Hyper-V CPUID cache before processing entries
Date:   Tue, 30 Aug 2022 15:37:07 +0200
Message-Id: <20220830133737.1539624-4-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wipe the whole 'hv_vcpu->cpuid_cache' with memset() instead of having to
zero each particular member when the corresponding CPUID entry was not
found.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
[sean: split to separate patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ed804447589c..611c349a08bf 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2005,31 +2005,24 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 
 	hv_vcpu = to_hv_vcpu(vcpu);
 
+	memset(&hv_vcpu->cpuid_cache, 0, sizeof(hv_vcpu->cpuid_cache));
+
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
 	if (entry) {
 		hv_vcpu->cpuid_cache.features_eax = entry->eax;
 		hv_vcpu->cpuid_cache.features_ebx = entry->ebx;
 		hv_vcpu->cpuid_cache.features_edx = entry->edx;
-	} else {
-		hv_vcpu->cpuid_cache.features_eax = 0;
-		hv_vcpu->cpuid_cache.features_ebx = 0;
-		hv_vcpu->cpuid_cache.features_edx = 0;
 	}
 
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO);
 	if (entry) {
 		hv_vcpu->cpuid_cache.enlightenments_eax = entry->eax;
 		hv_vcpu->cpuid_cache.enlightenments_ebx = entry->ebx;
-	} else {
-		hv_vcpu->cpuid_cache.enlightenments_eax = 0;
-		hv_vcpu->cpuid_cache.enlightenments_ebx = 0;
 	}
 
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
 	if (entry)
 		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
-	else
-		hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
 }
 
 int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
-- 
2.37.2

