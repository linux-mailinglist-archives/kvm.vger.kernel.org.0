Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA21553719
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352562AbiFUP7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353462AbiFUP6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:58:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EED8ABF0
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655827120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fEdjnqcwdrP4ky6Ydkpn9hPwr/5/PhNfBhkdDi68CEI=;
        b=HJ+EgJJ1RpmHdwbKxVw/FEmGwL/5IDAnkDw0Th14Ar36mL+SBcROdzUOF+KjtryjzXlLgk
        33lTClzWzgcI3zBz+DhvL32c6AmA8lH6gA7vRsDZfMPKnG8O2IaTlZ2VbsCsfJFOldZYJD
        8oCo3ZsW8pm8hQdyF7uSpcsc2D3Z5sA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-QwavBVFYP1iX3GUw0rbBlQ-1; Tue, 21 Jun 2022 11:58:36 -0400
X-MC-Unique: QwavBVFYP1iX3GUw0rbBlQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66DFE895683;
        Tue, 21 Jun 2022 15:58:36 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 512CB2026985;
        Tue, 21 Jun 2022 15:58:34 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] KVM: x86: hyper-v: Expose access to debug MSRs in the partition privilege flags
Date:   Tue, 21 Jun 2022 17:58:20 +0200
Message-Id: <20220621155830.60115-2-vkuznets@redhat.com>
In-Reply-To: <20220621155830.60115-1-vkuznets@redhat.com>
References: <20220621155830.60115-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For some features, Hyper-V spec defines two separate CPUID bits: one
listing whether the feature is supported or not and another one showing
whether guest partition was granted access to the feature ("partition
privilege mask"). 'Debug MSRs available' is one of such features. Add
the missing 'access' bit.

Fixes: f97f5a56f597 ("x86/kvm/hyper-v: Add support for synthetic debugger interface")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c             | 1 +
 include/asm-generic/hyperv-tlfs.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index e2e95a6fccfd..e08189211d9a 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2496,6 +2496,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->eax |= HV_MSR_RESET_AVAILABLE;
 			ent->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
 			ent->eax |= HV_ACCESS_FREQUENCY_MSRS;
+			ent->eax |= HV_ACCESS_DEBUG_MSRS;
 			ent->eax |= HV_ACCESS_REENLIGHTENMENT;
 
 			ent->ebx |= HV_POST_MESSAGES;
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index fdce7a4cfc6f..1d99dd296a76 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -70,6 +70,8 @@
 #define HV_MSR_GUEST_IDLE_AVAILABLE		BIT(10)
 /* Partition local APIC and TSC frequency registers available */
 #define HV_ACCESS_FREQUENCY_MSRS		BIT(11)
+/* Debug MSRs available */
+#define HV_ACCESS_DEBUG_MSRS			BIT(12)
 /* AccessReenlightenmentControls privilege */
 #define HV_ACCESS_REENLIGHTENMENT		BIT(13)
 /* AccessTscInvariantControls privilege */
-- 
2.35.3

