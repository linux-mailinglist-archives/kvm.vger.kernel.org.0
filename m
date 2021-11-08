Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368FD447E86
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbhKHLNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238989AbhKHLNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:36 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D4EC061570;
        Mon,  8 Nov 2021 03:10:52 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so8541670pje.0;
        Mon, 08 Nov 2021 03:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X+nMYBrxv4is7m+WcubKQVDiaz00Mm9SeNl5OqcCjdI=;
        b=am42H2uJYs6pP+WeST9R69GCMrRDkynBQzwbrWCzoLXhqoLqTJU70Ho5946yCl7tdj
         PLvcxtwyfwnvg74lzTJ1kBz7jnjYA/SPQYHWXGY3donFGia0jAsP6+lcQ6jojTd4/+ai
         saDueQZS7Y5Oe0IDwsWnm+lRa5s/ceqo4Jbo0UbYtmP2DgBNzDG46p+xetoC7dJd4f7p
         TJC4OyPrMEcBH+YYAgUuFBaASseT8bTttkmq5nfbEcQFGZuJ/7JrV6xhwkuxrhjT5ZQl
         pQyGshgQruJEQllkQVA3PdfQDTLJKPiMHp/jJmep12JZm/S4RDx+3Kq7bPE0Abt5+Rkh
         x1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X+nMYBrxv4is7m+WcubKQVDiaz00Mm9SeNl5OqcCjdI=;
        b=3TdRdf9pNY4QegcAEj3CQGUCuEeYVuBqazpKGec/+ht/gJS7nKfokM+9Ar3XIvMUuR
         e9ZgDItd7rB6+kJ7g3son5WKWy49hjKzSOa3EXLENwakkLcmZSVCfco9rAHicfdBAawR
         mhFG/BAtr9rzNuBDIBlznGu1xiJLd3QjKJYmZ2Da1nfW1oyfX56WDjT84+7zsOCjw17D
         rj9CffajxT4jvRW6xfeHcVKIPuR4+Ho8iDs3HXp3+rTFWYX58G5roYb+sJ+l7EWn4AY1
         D6Ne1saNyHtmmiJZmpOGS9ZdkPPNJMuD/CDlw8ygtvLct2/ZNsVjM61vMtGgPEBHJKQ2
         hONg==
X-Gm-Message-State: AOAM533/inq0FKUMHnqWRvRFu8VheKFpSgG3Y+Ma+WoStK8al7T21uWa
        geY1HAb5QPmmuq1hzZnEt2U=
X-Google-Smtp-Source: ABdhPJxxjXugJY+GGBkOwP1Ttfe8uW3w/F/sKfmAkC523oQovf/T8V61YUC8TSoDcfsFRCXNz82BFQ==
X-Received: by 2002:a17:90a:e7d0:: with SMTP id kb16mr50999038pjb.22.1636369851910;
        Mon, 08 Nov 2021 03:10:51 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ne7sm16559483pjb.36.2021.11.08.03.10.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:10:51 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] KVM: x86: Move kvm_ops_static_call_update() to x86.c
Date:   Mon,  8 Nov 2021 19:10:28 +0800
Message-Id: <20211108111032.24457-4-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108111032.24457-1-likexu@tencent.com>
References: <20211108111032.24457-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The kvm_ops_static_call_update() is defined in kvm_host.h.
That's completely unnecessary, it should have exactly one caller,
kvm_arch_hardware_setup().  As a prep match, move
kvm_ops_static_call_update() to x86.c, then it can reference
the kvm_pmu_ops stuff.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 8 --------
 arch/x86/kvm/x86.c              | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c2a4a362f3e2..c2d4ee2973c5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1536,14 +1536,6 @@ extern struct kvm_x86_ops kvm_x86_ops;
 #define KVM_X86_OP_NULL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
-static inline void kvm_ops_static_call_update(void)
-{
-#define KVM_X86_OP(func) \
-	static_call_update(kvm_x86_##func, kvm_x86_ops.func)
-#define KVM_X86_OP_NULL KVM_X86_OP
-#include <asm/kvm-x86-ops.h>
-}
-
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 775051070627..0aee0a078d6f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11300,6 +11300,14 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
+static inline void kvm_ops_static_call_update(void)
+{
+#define KVM_X86_OP(func) \
+	static_call_update(kvm_x86_##func, kvm_x86_ops.func)
+#define KVM_X86_OP_NULL KVM_X86_OP
+#include <asm/kvm-x86-ops.h>
+}
+
 int kvm_arch_hardware_setup(void *opaque)
 {
 	struct kvm_x86_init_ops *ops = opaque;
-- 
2.33.0

