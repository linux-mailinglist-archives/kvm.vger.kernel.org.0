Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA17C49F00A
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344871AbiA1Axz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344847AbiA1Axl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:41 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D57C061763
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:29 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l9-20020a170903120900b0014a4205ebe3so2305816plh.11
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XZfdfe5GuGm3RtP1jRjs71xAECkK02JG77i8V+SPhgY=;
        b=fLi9UoMtBQY+5NnVWk1/LbWEFc66cLYpS/U8lPFBMQRbsdgHjVaZzWNIBDbl0JqBff
         dDy1n+xJfvOz8vbj+6KuGvmkF+U6wwIdry9D/40FPi+N5koa3hMqqLR5jemkMeTGw0jo
         IDyYteQCPYKpRlAES9YFLxHDF+FFvKSyjqV2GVbxwg4689veOdLJXhDkWFszDQTNBhcH
         XrX5U4lMV/B8sQGc3NRta4aJCohFPbKEM6bkdmMeALfPI74m/r9Q6TprrkARCF1zWIsM
         Y1YKtLA/dMZElji6XTOthHX4qGFEt/kVcVstJJ50mH56BgEnhYe2cSTiUsWGj1Rs9lRG
         UnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XZfdfe5GuGm3RtP1jRjs71xAECkK02JG77i8V+SPhgY=;
        b=kCSkxRTG+T68yUzvktoiARe0VfhKu6c32icM82649xf1XUe7X735kf1TGljmwQXgBA
         tWYYYRiLHYUlFnKXFpDktVt5Uu3k85cPx1qSLA6V4ngZc8Ez0H0xIME1ZsDTPjTQMQuQ
         Y9Kasn0KO/ABl/loYcscw8dKN5iNsy/5YyWTT7zMT4wrZhwzcz66QKiCrwXfMl85S/+j
         O76DgtVxI4CZBn0qb9cv7MNJ9obCJnp+uEsWl1Af0OJKQFK1xSxMQHWW9HyalNCbM1Mv
         T9bPZIIc360h9cscuGu7cGD1soYmSDEdXVLmGLU+5V3lqODppUGYGA74q+BEQJPYlzaN
         +YbQ==
X-Gm-Message-State: AOAM533cPj+fVlAkGHp4iF0obBFJov45Jx1Yge/5Bhz59flTjyfRZ8O7
        vSszw+huBzU5RjuNH4RQIsgXDnhb+2o=
X-Google-Smtp-Source: ABdhPJxsZetChpy8Z4l8tP/qGFSveiiGe0+jG2DjXVNvHspUVM9gdS0zRinWI1bET9voX2MWzyCWWquS6v0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4ad2:: with SMTP id
 mh18mr16905329pjb.51.1643331208942; Thu, 27 Jan 2022 16:53:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:55 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 09/22] KVM: x86: Uninline and export hv_track_root_tdp()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Uninline and export Hyper-V's hv_track_root_tdp(), which is (somewhat
indirectly) the last remaining reference to kvm_x86_ops from vendor
modules, i.e. will allow unexporting kvm_x86_ops.  Reloading the TDP PGD
isn't the fastest of paths, hv_track_root_tdp() isn't exactly tiny, and
disallowing vendor code from accessing kvm_x86_ops provides nice-to-have
encapsulation of common x86 code (and of Hyper-V code for that matter).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/kvm_onhyperv.c | 14 ++++++++++++++
 arch/x86/kvm/kvm_onhyperv.h | 14 +-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index b469f45e3fe4..ee4f696a0782 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -92,3 +92,17 @@ int hv_remote_flush_tlb(struct kvm *kvm)
 	return hv_remote_flush_tlb_with_range(kvm, NULL);
 }
 EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
+
+void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
+{
+	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
+
+	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
+		spin_lock(&kvm_arch->hv_root_tdp_lock);
+		vcpu->arch.hv_root_tdp = root_tdp;
+		if (root_tdp != kvm_arch->hv_root_tdp)
+			kvm_arch->hv_root_tdp = INVALID_PAGE;
+		spin_unlock(&kvm_arch->hv_root_tdp_lock);
+	}
+}
+EXPORT_SYMBOL_GPL(hv_track_root_tdp);
diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 1c67abf2eba9..287e98ef9df3 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -10,19 +10,7 @@
 int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range);
 int hv_remote_flush_tlb(struct kvm *kvm);
-
-static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
-{
-	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
-
-	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
-		spin_lock(&kvm_arch->hv_root_tdp_lock);
-		vcpu->arch.hv_root_tdp = root_tdp;
-		if (root_tdp != kvm_arch->hv_root_tdp)
-			kvm_arch->hv_root_tdp = INVALID_PAGE;
-		spin_unlock(&kvm_arch->hv_root_tdp_lock);
-	}
-}
+void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
 static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
-- 
2.35.0.rc0.227.g00780c9af4-goog

