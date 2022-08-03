Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA661588FA9
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbiHCPu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238028AbiHCPu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CACE2271C
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659541824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psYHeyeefyckM8qqiGafKX9oY62tjOLZwMmaha8+kwM=;
        b=M0RnN+52ZFCiCPZ3RX+rPQQ+jvsjfW9BPxoSvL8RMvq1ZMIGqULh4PW14qV4i0dd2lbfqy
        wCQPzJZ58V75ucQd4GsmYBSO6sN9d2A+NPCoT4djd2HWqmXhzVQVxDVZ6q77WZOzrLjiI7
        u8Kug6ajw21tB114DJ0GoZGCN0dG0pQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-Ug3rWSMHO2yf6usSNZ-GxQ-1; Wed, 03 Aug 2022 11:50:21 -0400
X-MC-Unique: Ug3rWSMHO2yf6usSNZ-GxQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31A298041B5;
        Wed,  3 Aug 2022 15:50:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C5BB1121314;
        Wed,  3 Aug 2022 15:50:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 01/13] bug: introduce ASSERT_STRUCT_OFFSET
Date:   Wed,  3 Aug 2022 18:49:59 +0300
Message-Id: <20220803155011.43721-2-mlevitsk@redhat.com>
In-Reply-To: <20220803155011.43721-1-mlevitsk@redhat.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ASSERT_STRUCT_OFFSET allows to assert during the build of
the kernel that a field in a struct have an expected offset.

KVM used to have such macro, but there is almost nothing KVM specific
in it so move it to build_bug.h, so that it can be used in other
places in KVM.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmcs12.h | 5 ++---
 include/linux/build_bug.h | 9 +++++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 746129ddd5ae02..01936013428b5c 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -208,9 +208,8 @@ struct __packed vmcs12 {
 /*
  * For save/restore compatibility, the vmcs12 field offsets must not change.
  */
-#define CHECK_OFFSET(field, loc)				\
-	BUILD_BUG_ON_MSG(offsetof(struct vmcs12, field) != (loc),	\
-		"Offset of " #field " in struct vmcs12 has changed.")
+#define CHECK_OFFSET(field, loc) \
+	ASSERT_STRUCT_OFFSET(struct vmcs12, field, loc)
 
 static inline void vmx_check_vmcs12_offsets(void)
 {
diff --git a/include/linux/build_bug.h b/include/linux/build_bug.h
index e3a0be2c90ad98..3aa3640f8c181f 100644
--- a/include/linux/build_bug.h
+++ b/include/linux/build_bug.h
@@ -77,4 +77,13 @@
 #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
 
+
+/*
+ * Compile time check that field has an expected offset
+ */
+#define ASSERT_STRUCT_OFFSET(type, field, expected_offset)	\
+	BUILD_BUG_ON_MSG(offsetof(type, field) != (expected_offset),	\
+		"Offset of " #field " in " #type " has changed.")
+
+
 #endif	/* _LINUX_BUILD_BUG_H */
-- 
2.26.3

