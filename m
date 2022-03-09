Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AD74D36E4
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbiCIRPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238403AbiCIROT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:14:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4EE412F162
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 09:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646845771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=We3EN0WBNbBd0dp5yY6VG/gbbkfuqHO4cLRFYWTCIpg=;
        b=BV6pDUKmA5qVmaxXYp7TNht6AJ9Wy2Eeneon9mBzvNPKseJC5q0K4OKGtcJEmROHipPCJr
        axcnaBKQL6XHe6XJHAmIo6TIlQBErW9imyZXMid54VCFM6yVDNbECCADf6DZDpiMv+CBEk
        n+spV5Jakj2Ib8q2zyItJjOD3S7XREM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-tV7UOu1pPHygsB9q5W9NLw-1; Wed, 09 Mar 2022 12:09:30 -0500
X-MC-Unique: tV7UOu1pPHygsB9q5W9NLw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF67480734E;
        Wed,  9 Mar 2022 17:09:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5277D866F1;
        Wed,  9 Mar 2022 17:09:29 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, jmattson@google.com
Subject: [PATCH 1/2] KVM: x86: add support for CPUID leaf 0x80000021
Date:   Wed,  9 Mar 2022 12:09:27 -0500
Message-Id: <20220309170928.1032664-2-pbonzini@redhat.com>
In-Reply-To: <20220309170928.1032664-1-pbonzini@redhat.com>
References: <20220309170928.1032664-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID leaf 0x80000021 defines some features (or lack of bugs) of AMD
processors.  Expose the ones that make sense via KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 419eb8e14f79..30832aad402f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1068,7 +1068,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x8000001f);
+		entry->eax = min(entry->eax, 0x80000021);
 		break;
 	case 0x80000001:
 		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
@@ -1139,6 +1139,23 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->ebx &= ~GENMASK(11, 6);
 		}
 		break;
+	case 0x80000020:
+		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		break;
+	case 0x80000021:
+		entry->ebx = entry->ecx = entry->edx = 0;
+		/*
+		 * Pass down these bits:
+		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
+		 *    EAX      2      LAS, LFENCE always serializing
+		 *    EAX      6      NSCB, Null selector clear base
+		 *
+		 * Other defined bits are for MSRs that KVM does not expose:
+		 *   EAX      3      SPCL, SMM page configuration lock
+		 *   EAX      13     PCMSR, Prefetch control MSR
+		 */
+		entry->eax &= BIT(0) | BIT(2) | BIT(6);
+		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/
-- 
2.31.1


