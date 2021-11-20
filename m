Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A625D457B94
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhKTE4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbhKTEym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:42 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC54C061784
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:07 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id a4-20020a170902ecc400b00142562309c7so5712910plh.6
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hIrkLcH8rv7fQ+FYWepEW67ofcvrqQgpVgfFv1pyez8=;
        b=cIGkqH0/fjQWsd8RxvLqU1ee7ZogoYD7jllLMRcxpslHeaF/koeApADlhtszqCnMnl
         WLkjjq7xaKfUC7Yk9dVRrdpOZD+jA7JfxVQORUbmNwbxeP6p0d7kHf/CvPIwVa1P5t0V
         zDOXyq2AIzpF3CdbShmQvJtWVqNXQa3owVBN+BOod0zkeW7JottwdDLpfeP6s6gfSsQ3
         vGgsKGE2PGEx6ns81A+JZpDTe2lr25j0AtJrUDaRuucdFVS6nW5a4bb5jZCST3AAOYVC
         JF/Dz0F0aTWnqKo398D5IybbLbvXk1l5NpeotUDbLj+k9LDdf+KoB9MI5j+T/CWP3iWz
         XxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hIrkLcH8rv7fQ+FYWepEW67ofcvrqQgpVgfFv1pyez8=;
        b=AZ8bjwm6c7d06Eh2lsUKq+vPxvZk2lLqN/3juDdleOVAqN4VeOnfEOJKZ8AywiOsoc
         yyQG7rKDj+YsyUzWA8G5JOrVw0Ilflx1r0fRjs6j9YkC5fxwIJ1t8Q4FUexWWOQhhlC8
         b6G5vagqJOlpK80cUXk1R3kliw33oAEBgNjq5dsuDNzbV2jFE0gqtFwIUEZs9NG5ul9m
         TJ1ASE1t3R+wMJc4zrJDvRZWfBHh0Hle3NQLiuyieqoj3EyNHB4UQkGuPkyC2UbX3OZo
         WcrFyX35dhPf6xK6C6w+cpSHZrLnEIumQXBbl2Pbc3IsS5XlLgRwWs5qx1m1RRN1FK1j
         hf/Q==
X-Gm-Message-State: AOAM533mqoIWTACcxkiefXz07D7De+9kB2YJ1FUrR0+mbf6PQfFlPNP2
        pihtfP9BHL8WAVFLau5BFEnMoH4m/LY=
X-Google-Smtp-Source: ABdhPJyp/o6q599dpVqneWFCpwJ2yVqPC2fEKI4NffP4IWUHeXOr4EINptvXQjp0ZbZprEkM/Cx2Z+jcYC0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8f94:b0:143:8e81:3ec1 with SMTP id
 z20-20020a1709028f9400b001438e813ec1mr83023505plo.52.1637383866904; Fri, 19
 Nov 2021 20:51:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:26 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-9-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 08/28] KVM: x86/mmu: Drop unused @kvm param from kvm_tdp_mmu_get_root()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the unused @kvm param from kvm_tdp_mmu_get_root().  No functional
change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++---
 arch/x86/kvm/mmu/tdp_mmu.h | 3 +--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4305ee8e3de3..12a28afce73f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -129,9 +129,10 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
 						   typeof(*next_root), link);
 
-	while (next_root && !kvm_tdp_mmu_get_root(kvm, next_root))
+	while (next_root && !kvm_tdp_mmu_get_root(next_root))
 		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-				&next_root->link, typeof(*next_root), link);
+						  &next_root->link,
+						  typeof(*next_root), link);
 
 	rcu_read_unlock();
 
@@ -211,7 +212,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
-		    kvm_tdp_mmu_get_root(kvm, root))
+		    kvm_tdp_mmu_get_root(root))
 			goto out;
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3899004a5d91..599714de67c3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -7,8 +7,7 @@
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 
-__must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
-						     struct kvm_mmu_page *root)
+__must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
 	if (root->role.invalid)
 		return false;
-- 
2.34.0.rc2.393.gf8c9666880-goog

