Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9748D4CFD88
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiCGMA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiCGMAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:00:25 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E19A30F67;
        Mon,  7 Mar 2022 03:59:31 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id bx5so13213617pjb.3;
        Mon, 07 Mar 2022 03:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jh3v+1Csj30lZYGCWAn43l7jGDiammyLY3L2oPwu+04=;
        b=Q78y4ZM1Z9JI1/DSMUiz8ACIFbwlzbrnOTOlsFA6La9X0XRPkNilH+Df9WjtEUl7z+
         AymPlWc0ae/3DvVt8xZvcmTYDylaado/srYjncKTNeeYFUZ4iW9iO69+qpM3AgYeAPGj
         9j0BMxlpk6k928THSVpQH6yTg8peXnZj2iA2zVIlvdUr1Gl3Q5ewvfB95CUZQf2XtIzz
         X2i0AoFHFukVv31t3Pqyx1Gm19D0u4E0YexSOIQSNz4PRy81jhq2MCbspAtR5oQZlnqP
         PU65X9rYyNtnE4S9R3ulLpcYNkAa2kn+SFqavE/yeQ2PMFiOE3DcbJ5mociHw7PAcfcF
         F3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jh3v+1Csj30lZYGCWAn43l7jGDiammyLY3L2oPwu+04=;
        b=AZXZGQD2gxj9C4pr8+04xyqSebfXkRdL32QVJgtIoZDBS3ANTBKyytQxvteZJ31un6
         MAiKvZy1mo+8L04Jasgo9OFsNVj3O1/nWbQ1daXPKDjVmeVvMHonkezAQvVGVi9w0xOW
         GvNMp/cH44o/LrHb3RNe+yMKM2GEKnHmg5/a/P8OS/47MShgcmRWXqWIkMDaDZo4I6+T
         g99PUhY/fJBZs+8oqHRxjWCyicFyLkhovFYAAiquN9QE/aFrUeNBVFFimWIZc4c1dyWc
         JzlxMpP2A47IbuZYwoeLIgiihRV0otFZA0/O5JYc5UeG4+gaI0biC9c0xrtuwX8IW02A
         Bq3Q==
X-Gm-Message-State: AOAM533SVFCO8qBV69wQe3+1wbDVANC8VYExJJoht3eI4Y03W5kr1mvt
        DpXwuepSD6be/mqFoMHCa0k=
X-Google-Smtp-Source: ABdhPJzsrzr1mD0+QDXJEDsbt51O1o73uqZYxwzerf9jjh4KizWTCXxr4775vRGPdnfSKOVL6kGGUA==
X-Received: by 2002:a17:90a:2b0f:b0:1bf:37d6:a49d with SMTP id x15-20020a17090a2b0f00b001bf37d6a49dmr12721082pjc.30.1646654371052;
        Mon, 07 Mar 2022 03:59:31 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m6-20020a62f206000000b004e152bc0527sm15323164pfh.153.2022.03.07.03.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:59:30 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] KVM: x86: Move kvm_ops_static_call_update() to x86.c
Date:   Mon,  7 Mar 2022 19:59:17 +0800
Message-Id: <20220307115920.51099-2-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307115920.51099-1-likexu@tencent.com>
References: <20220307115920.51099-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The kvm_ops_static_call_update() is defined in kvm_host.h. That's
completely unnecessary, it should have exactly one caller,
kvm_arch_hardware_setup().  As a prep match, move
kvm_ops_static_call_update() to x86.c, then it can reference
the kvm_pmu_ops stuff.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 14 --------------
 arch/x86/kvm/x86.c              | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index da2f3a21e37b..fdb62aba73ef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1541,20 +1541,6 @@ extern struct kvm_x86_ops kvm_x86_ops;
 #define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
-static inline void kvm_ops_static_call_update(void)
-{
-#define __KVM_X86_OP(func) \
-	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
-#define KVM_X86_OP(func) \
-	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
-#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
-#define KVM_X86_OP_OPTIONAL_RET0(func) \
-	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
-					   (void *)__static_call_return0);
-#include <asm/kvm-x86-ops.h>
-#undef __KVM_X86_OP
-}
-
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f79bf4552082..7b4e84d80b57 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11507,6 +11507,20 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
+static inline void kvm_ops_static_call_update(void)
+{
+#define __KVM_X86_OP(func) \
+	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
+#define KVM_X86_OP(func) \
+	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
+#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_RET0(func) \
+	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
+					   (void *)__static_call_return0);
+#include <asm/kvm-x86-ops.h>
+#undef __KVM_X86_OP
+}
+
 int kvm_arch_hardware_setup(void *opaque)
 {
 	struct kvm_x86_init_ops *ops = opaque;
-- 
2.35.1

