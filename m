Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16FE614D8A
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiKAO64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiKAO6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:58:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE941D0CB
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8RkknGfcm0LOErzFkwWM5NLjH7yVFTkyAhgBOJ0pFng=;
        b=RMtdcu0KXfZLENDKicbKpG0l5ifoLHfuB0hv7jSrsUMCoL/CgWfixAvHX+/NIziuTr9Myt
        gMqc4I56pxOvtz6GrZOmRWwqXudLa8ykdHIo+l9chkRg3ffN3K2Q5jNmA3TGP67aTAfltK
        uF/J84c+ZscIgURMTUVyVAnY+DcLv5U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-PXb7bexJOvKEmj-HqbKxMg-1; Tue, 01 Nov 2022 10:56:02 -0400
X-MC-Unique: PXb7bexJOvKEmj-HqbKxMg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3D028060A1;
        Tue,  1 Nov 2022 14:56:01 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 881A9C15BA5;
        Tue,  1 Nov 2022 14:55:59 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 30/48] KVM: selftests: Better XMM read/write helpers
Date:   Tue,  1 Nov 2022 15:54:08 +0100
Message-Id: <20221101145426.251680-31-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

set_xmm()/get_xmm() helpers are fairly useless as they only read 64 bits
from 128-bit registers. Moreover, these helpers are not used. Borrow
_kvm_read_sse_reg()/_kvm_write_sse_reg() from KVM limiting them to
XMM0-XMM8 for now.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 70 ++++++++++---------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e8ca0d8a6a7e..dbd75717dc3b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -436,71 +436,73 @@ static inline bool this_cpu_has(struct kvm_x86_cpu_feature feature)
 	return gprs[feature.reg] & BIT(feature.bit);
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
2.37.3

