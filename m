Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8054B515A
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354051AbiBNNQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:16:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351749AbiBNNQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:16:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67537F9
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644844579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SObs/WM0TlQfiyXmJdgla+LXta8yXXdvgV2nYM+mHOs=;
        b=OSip7ZZsskYVAz7G9HVBHRF4c0vbRuSAMix0J9Wa0k45ZViW+XOQTLqMaDR9fdtyj5RUZX
        GXXXh5bjoU5I8TjYIFVjvGs7wmV2//5+/yta3ikNYs0aDRMNQZqlinpp0ZXwTOFka2dbH3
        UQLFJ43t9B44OZ4btAVem94txZIjE28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-bG9v6obhOt-APrDj41zcyw-1; Mon, 14 Feb 2022 08:16:18 -0500
X-MC-Unique: bG9v6obhOt-APrDj41zcyw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 290A01091DA1;
        Mon, 14 Feb 2022 13:16:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F189106F75B;
        Mon, 14 Feb 2022 13:16:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 3/5] KVM: x86: warn on incorrectly NULL static calls
Date:   Mon, 14 Feb 2022 08:16:12 -0500
Message-Id: <20220214131614.3050333-4-pbonzini@redhat.com>
In-Reply-To: <20220214131614.3050333-1-pbonzini@redhat.com>
References: <20220214131614.3050333-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the newly corrected KVM_X86_OP annotations to warn about possible
NULL pointer dereferences as soon as the vendor module is loaded.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e3f7d958c150..5dce6fbd9ab6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1546,9 +1546,10 @@ extern struct kvm_x86_ops kvm_x86_ops;
 
 static inline void kvm_ops_static_call_update(void)
 {
-#define KVM_X86_OP(func) \
+#define KVM_X86_OP_OPTIONAL(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
-#define KVM_X86_OP_OPTIONAL KVM_X86_OP
+#define KVM_X86_OP(func) \
+	WARN_ON(!kvm_x86_ops.func); KVM_X86_OP_OPTIONAL(func)
 #include <asm/kvm-x86-ops.h>
 }
 
-- 
2.31.1


