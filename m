Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E654BA7AD
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 19:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbiBQSI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 13:08:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244004AbiBQSIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 13:08:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6736315DB3D
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 10:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645121318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s7fWuoXldmh0bz49CnTiNZWwsovHYbPOq1Hj86Bdtoc=;
        b=UF8PgjONe6qVF8t649M7KOcsCgRyXssLWDyBOT/AkbCepSmxVAYdl4Nignf5sDVULoxQyP
        5QUe6soVUllvyFjR4o9BtbzTyk11aKaOQEf5I30xI5JcrPsMbg8hUmlYp8q0hGYwM7swyG
        WljcPqLD48cns9akg4QBQIHOGM2BG2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-ZF-W6gpgNsC5UM9RJHJVLw-1; Thu, 17 Feb 2022 13:08:35 -0500
X-MC-Unique: ZF-W6gpgNsC5UM9RJHJVLw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A4A7180A0A3;
        Thu, 17 Feb 2022 18:08:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF4BD8276C;
        Thu, 17 Feb 2022 18:08:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v3 4/6] KVM: x86: warn on incorrectly NULL members of kvm_x86_ops
Date:   Thu, 17 Feb 2022 13:08:29 -0500
Message-Id: <20220217180831.288210-5-pbonzini@redhat.com>
In-Reply-To: <20220217180831.288210-1-pbonzini@redhat.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
 arch/x86/include/asm/kvm_host.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7d733f601106..a7e82fc1f1f3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1545,10 +1545,13 @@ extern struct kvm_x86_ops kvm_x86_ops;
 
 static inline void kvm_ops_static_call_update(void)
 {
-#define KVM_X86_OP(func) \
+#define __KVM_X86_OP(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
-#define KVM_X86_OP_OPTIONAL KVM_X86_OP
+#define KVM_X86_OP(func) \
+	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
+#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
+#undef __KVM_X86_OP
 }
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
-- 
2.31.1


