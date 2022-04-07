Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAC24F844E
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345344AbiDGQAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 12:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345357AbiDGP7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:59:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84076D95C1
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649347061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IJ2Vgk74sDWyEWQ+SIKJGSpw8vilP+eCSCMx/I4v0m0=;
        b=BpeOn3Ia62nmYX0fRxxCpwk2alVPDusAn0nh78DbGJmgEhdYOLEyVmyqy90+EFyGfSriWQ
        2U4Hu2or7DSsFCV74EnNHNbiuDxJYA/ZtDKcnp6re7IRdmoEfFKeZsx4reoN/crCuzp7nx
        /wrbrdpey8aCZ6PKUmaG7ree8nFA6qI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-Wn8NwDQ8OHW8QHHPxwGzcA-1; Thu, 07 Apr 2022 11:57:35 -0400
X-MC-Unique: Wn8NwDQ8OHW8QHHPxwGzcA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA15085A5BE;
        Thu,  7 Apr 2022 15:57:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE205427852;
        Thu,  7 Apr 2022 15:57:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 21/31] KVM: selftests: Better XMM read/write helpers
Date:   Thu,  7 Apr 2022 17:56:35 +0200
Message-Id: <20220407155645.940890-22-vkuznets@redhat.com>
In-Reply-To: <20220407155645.940890-1-vkuznets@redhat.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

set_xmm()/get_xmm() helpers are fairly useless as they only read 64 bits
from 128-bit registers. Moreover, these helpers are not used. Borrow
_kvm_read_sse_reg()/_kvm_write_sse_reg() from KVM limiting them to
XMM0-XMM8 for now.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 70 ++++++++++---------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 37db341d4cc5..9ad7602a257b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -296,71 +296,73 @@ static inline void cpuid(uint32_t *eax, uint32_t *ebx,
 	    : "memory");
 }
 
-#define SET_XMM(__var, __xmm) \
-	asm volatile("movq %0, %%"#__xmm : : "r"(__var) : #__xmm)
+typedef u32		__attribute__((vector_size(16))) sse128_t;
+#define __sse128_u	union { sse128_t vec; u64 as_u64[2]; u32 as_u32[4]; }
+#define sse128_lo(x)	({ __sse128_u t; t.vec = x; t.as_u64[0]; })
+#define sse128_hi(x)	({ __sse128_u t; t.vec = x; t.as_u64[1]; })
 
-static inline void set_xmm(int n, unsigned long val)
+static inline void read_sse_reg(int reg, sse128_t *data)
 {
-	switch (n) {
+	switch (reg) {
 	case 0:
-		SET_XMM(val, xmm0);
+		asm("movdqa %%xmm0, %0" : "=m"(*data));
 		break;
 	case 1:
-		SET_XMM(val, xmm1);
+		asm("movdqa %%xmm1, %0" : "=m"(*data));
 		break;
 	case 2:
-		SET_XMM(val, xmm2);
+		asm("movdqa %%xmm2, %0" : "=m"(*data));
 		break;
 	case 3:
-		SET_XMM(val, xmm3);
+		asm("movdqa %%xmm3, %0" : "=m"(*data));
 		break;
 	case 4:
-		SET_XMM(val, xmm4);
+		asm("movdqa %%xmm4, %0" : "=m"(*data));
 		break;
 	case 5:
-		SET_XMM(val, xmm5);
+		asm("movdqa %%xmm5, %0" : "=m"(*data));
 		break;
 	case 6:
-		SET_XMM(val, xmm6);
+		asm("movdqa %%xmm6, %0" : "=m"(*data));
 		break;
 	case 7:
-		SET_XMM(val, xmm7);
+		asm("movdqa %%xmm7, %0" : "=m"(*data));
 		break;
+	default:
+		BUG();
 	}
 }
 
-#define GET_XMM(__xmm)							\
-({									\
-	unsigned long __val;						\
-	asm volatile("movq %%"#__xmm", %0" : "=r"(__val));		\
-	__val;								\
-})
-
-static inline unsigned long get_xmm(int n)
+static inline void write_sse_reg(int reg, const sse128_t *data)
 {
-	assert(n >= 0 && n <= 7);
-
-	switch (n) {
+	switch (reg) {
 	case 0:
-		return GET_XMM(xmm0);
+		asm("movdqa %0, %%xmm0" : : "m"(*data));
+		break;
 	case 1:
-		return GET_XMM(xmm1);
+		asm("movdqa %0, %%xmm1" : : "m"(*data));
+		break;
 	case 2:
-		return GET_XMM(xmm2);
+		asm("movdqa %0, %%xmm2" : : "m"(*data));
+		break;
 	case 3:
-		return GET_XMM(xmm3);
+		asm("movdqa %0, %%xmm3" : : "m"(*data));
+		break;
 	case 4:
-		return GET_XMM(xmm4);
+		asm("movdqa %0, %%xmm4" : : "m"(*data));
+		break;
 	case 5:
-		return GET_XMM(xmm5);
+		asm("movdqa %0, %%xmm5" : : "m"(*data));
+		break;
 	case 6:
-		return GET_XMM(xmm6);
+		asm("movdqa %0, %%xmm6" : : "m"(*data));
+		break;
 	case 7:
-		return GET_XMM(xmm7);
+		asm("movdqa %0, %%xmm7" : : "m"(*data));
+		break;
+	default:
+		BUG();
 	}
-
-	/* never reached */
-	return 0;
 }
 
 static inline void cpu_relax(void)
-- 
2.35.1

