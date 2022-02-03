Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95804A8299
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 11:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244311AbiBCKqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 05:46:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242200AbiBCKqb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 05:46:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643885189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XzEcvYtnfaZXAJzdfA9k5NegZ+41H5HCCb4J6QRwe50=;
        b=PDCBRP6imELpkJ5VSyXwODYXXMhts03NnpVhmvgY9h0x3zIXPOc11V0CVc0lL6wMF1G4eP
        qVWeuOUU813ygzCNBAZJ36B04XTM9L/GLAStFUryheRvT8NHAEbuMzQVIHig9IsTwtawng
        goxCV2zubaqhjzFG9yP1doC5pz4qlII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-eWSs-cAUP4mCCiz8Dd2APQ-1; Thu, 03 Feb 2022 05:46:27 -0500
X-MC-Unique: eWSs-cAUP4mCCiz8Dd2APQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF20D81431A;
        Thu,  3 Feb 2022 10:46:25 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF6B4108BB;
        Thu,  3 Feb 2022 10:46:23 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] KVM: selftests: Adapt hyperv_cpuid test to the newly introduced Enlightened MSR-Bitmap
Date:   Thu,  3 Feb 2022 11:46:15 +0100
Message-Id: <20220203104620.277031-2-vkuznets@redhat.com>
In-Reply-To: <20220203104620.277031-1-vkuznets@redhat.com>
References: <20220203104620.277031-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID 0x40000000.EAX is now always present as it has Enlightened
MSR-Bitmap feature bit set. Adapt the test accordingly. Opportunistically
add a check for the supported eVMCS version range.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 29 +++++++++++--------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 7e2d2d17d2ed..8c245ab2d98a 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -49,16 +49,13 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 			  bool evmcs_expected)
 {
 	int i;
-	int nent = 9;
+	int nent_expected = 10;
 	u32 test_val;
 
-	if (evmcs_expected)
-		nent += 1; /* 0x4000000A */
-
-	TEST_ASSERT(hv_cpuid_entries->nent == nent,
+	TEST_ASSERT(hv_cpuid_entries->nent == nent_expected,
 		    "KVM_GET_SUPPORTED_HV_CPUID should return %d entries"
-		    " with evmcs=%d (returned %d)",
-		    nent, evmcs_expected, hv_cpuid_entries->nent);
+		    " (returned %d)",
+		    nent_expected, hv_cpuid_entries->nent);
 
 	for (i = 0; i < hv_cpuid_entries->nent; i++) {
 		struct kvm_cpuid_entry2 *entry = &hv_cpuid_entries->entries[i];
@@ -68,9 +65,6 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 			    "function %x is our of supported range",
 			    entry->function);
 
-		TEST_ASSERT(evmcs_expected || (entry->function != 0x4000000A),
-			    "0x4000000A leaf should not be reported");
-
 		TEST_ASSERT(entry->index == 0,
 			    ".index field should be zero");
 
@@ -97,8 +91,20 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 				    "NoNonArchitecturalCoreSharing bit"
 				    " doesn't reflect SMT setting");
 			break;
-		}
+		case 0x4000000A:
+			TEST_ASSERT(entry->eax & (1UL << 19),
+				    "Enlightened MSR-Bitmap should always be supported"
+				    " 0x40000000.EAX: %x", entry->eax);
+			if (evmcs_expected)
+				TEST_ASSERT((entry->eax & 0xffff) == 0x101,
+				    "Supported Enlightened VMCS version range is supposed to be 1:1"
+				    " 0x40000000.EAX: %x", entry->eax);
+
+			break;
+		default:
+			break;
 
+		}
 		/*
 		 * If needed for debug:
 		 * fprintf(stdout,
@@ -107,7 +113,6 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 		 *	entry->edx);
 		 */
 	}
-
 }
 
 void test_hv_cpuid_e2big(struct kvm_vm *vm, bool system)
-- 
2.34.1

