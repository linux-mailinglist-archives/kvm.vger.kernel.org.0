Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784334D37C8
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbiCIRPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238424AbiCIROY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:14:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F641130196
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 09:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646845774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/o3sPCCWF9DwYJSFG90KCzdlkqUEgVretFfIHQN8Mo=;
        b=Vb3UoZoV4KBfPGn7MtVO9YVx/pMaaLMB7wvfln4Qeq197X5Mj7uteRxslu8sRppneMZHED
        zAHlTNNw4r8TVqGNPUPaHCS7JVGSpMzAS4hH38bChiABoTZ+4t4cZI7yl9w7arJofofvlB
        GC8AEbX6JZXgo69Z8VoBJKJd1bm1vV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-T5WUUdbbMmGXVTHoigC-hA-1; Wed, 09 Mar 2022 12:09:31 -0500
X-MC-Unique: T5WUUdbbMmGXVTHoigC-hA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BAEE1854E2A;
        Wed,  9 Mar 2022 17:09:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA28B866F1;
        Wed,  9 Mar 2022 17:09:29 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, jmattson@google.com
Subject: [PATCH 2/2] KVM: x86: synthesize CPUID leaf 0x80000021h if useful
Date:   Wed,  9 Mar 2022 12:09:28 -0500
Message-Id: <20220309170928.1032664-3-pbonzini@redhat.com>
In-Reply-To: <20220309170928.1032664-1-pbonzini@redhat.com>
References: <20220309170928.1032664-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guests should have X86_BUG_NULL_SEG if and only if the host has the bug.
Use the info from static_cpu_has_bug to form the 0x80000021 CPUID leaf
that was defined for Zen3.  Userspace can then set the bit even on older
CPUs that do not have the bug, such as Zen2.

Do the same for X86_FEATURE_LFENCE_RDTSC as well, since various processors
have had very different ways of detecting it and not all of them are
available to userspace.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 30832aad402f..58b0b4e0263c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -723,6 +723,19 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 		/* Hypervisor leaves are always synthesized by __do_cpuid_func.  */
 		return entry;
 
+	case 0x80000000:
+		/*
+		 * 0x80000021 is sometimes synthesized by __do_cpuid_func, which
+		 * would result in out-of-bounds calls to do_host_cpuid.
+		 */
+		{
+			static int max_cpuid_80000000;
+			if (!READ_ONCE(max_cpuid_80000000))
+				WRITE_ONCE(max_cpuid_80000000, cpuid_eax(0x80000000));
+			if (function > READ_ONCE(max_cpuid_80000000))
+				return entry;
+		}
+
 	default:
 		break;
 	}
@@ -1069,6 +1082,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 0x80000000:
 		entry->eax = min(entry->eax, 0x80000021);
+		/*
+		 * Serializing LFENCE is reported in a multitude of ways,
+		 * and NullSegClearsBase is not reported in CPUID on Zen2;
+		 * help userspace by providing the CPUID leaf ourselves.
+		 */
+		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC)
+		    || !static_cpu_has_bug(X86_BUG_NULL_SEG))
+			entry->eax = max(entry->eax, 0x80000021);
 		break;
 	case 0x80000001:
 		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
@@ -1155,6 +1176,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 *   EAX      13     PCMSR, Prefetch control MSR
 		 */
 		entry->eax &= BIT(0) | BIT(2) | BIT(6);
+		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
+			entry->eax |= BIT(2);
+		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+			entry->eax |= BIT(6);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
-- 
2.31.1

