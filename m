Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF90F515468
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 21:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbiD2T3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 15:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbiD2T3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 15:29:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67B7981483
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 12:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651260355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=f98T4BJHfJan6nA7b2NKA9Mwn0L7MATFzgHNudByTF0=;
        b=ehPdrvPa55MOODsD+uo1dWHEpce6/XH/nsNdUg+6fBdOHrHZ+oEQVS/ciZSUaPKOwZ1Mpd
        jeAaZ8PY/Kv4ZhMwNsouKLbm/pdzpjf8pP8x+Wmsyuaoyon1QwKl6wwC+YK0qDjbmbcIqp
        NAg9UCAcgK1gQXtH6yiELDCtKDOcJvI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-XS1Nj7v1OguIBsNbGBb46w-1; Fri, 29 Apr 2022 15:25:53 -0400
X-MC-Unique: XS1Nj7v1OguIBsNbGBb46w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 516593834C02;
        Fri, 29 Apr 2022 19:25:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34E7BC15D70;
        Fri, 29 Apr 2022 19:25:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: work around QEMU issue with synthetic CPUID leaves
Date:   Fri, 29 Apr 2022 15:25:53 -0400
Message-Id: <20220429192553.932611-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Synthesizing AMD leaves up to 0x80000021 caused problems with QEMU,
which assumes the *host* CPUID[0x80000000].EAX is higher or equal
to what KVM_GET_SUPPORTED_CPUID reports.

This causes QEMU to issue bogus host CPUIDs when preparing the input
to KVM_SET_CPUID2.  It can even get into an infinite loop, which is
only terminated by an abort():

   cpuid_data is full, no space for cpuid(eax:0x8000001d,ecx:0x3e)

To work around this, only synthesize those leaves if 0x8000001d exists
on the host.  The synthetic 0x80000021 leaf is mostly useful on Zen2,
which satisfies the condition.

Fixes: f144c49e8c39 ("KVM: x86: synthesize CPUID leaf 0x80000021h if useful")
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b24ca7f4ed7c..598334ed5fbc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1085,12 +1085,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 0x80000000:
 		entry->eax = min(entry->eax, 0x80000021);
 		/*
-		 * Serializing LFENCE is reported in a multitude of ways,
-		 * and NullSegClearsBase is not reported in CPUID on Zen2;
-		 * help userspace by providing the CPUID leaf ourselves.
+		 * Serializing LFENCE is reported in a multitude of ways, and
+		 * NullSegClearsBase is not reported in CPUID on Zen2; help
+		 * userspace by providing the CPUID leaf ourselves.
+		 *
+		 * However, only do it if the host has CPUID leaf 0x8000001d.
+		 * QEMU thinks that it can query the host blindly for that
+		 * CPUID leaf if KVM reports that it supports 0x8000001d or
+		 * above.  The processor merrily returns values from the
+		 * highest Intel leaf which QEMU tries to use as the guest's
+		 * 0x8000001d.  Even worse, this can result in an infinite
+		 * loop if said highest leaf has no subleaves indexed by ECX.
 		 */
-		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC)
-		    || !static_cpu_has_bug(X86_BUG_NULL_SEG))
+		if (entry->eax >= 0x8000001d &&
+		    (static_cpu_has(X86_FEATURE_LFENCE_RDTSC)
+		     || !static_cpu_has_bug(X86_BUG_NULL_SEG)))
 			entry->eax = max(entry->eax, 0x80000021);
 		break;
 	case 0x80000001:
-- 
2.31.1

