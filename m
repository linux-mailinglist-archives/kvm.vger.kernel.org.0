Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CF04579D3
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236347AbhKTACB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbhKTABa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:30 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0D3C061748
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:27 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id e9-20020a170902ed8900b00143a3f40299so5346901plj.20
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uqSYlC0I4Uk2XD+zNrdVsAZt4a+qWQj6Ntf9g58LQWo=;
        b=P9HLJnd2hqrk7R1hBa7mNX+eUKE5kMKsrjwFcRk92RKrM91rqw8SOkSghTTbn3U03d
         eevfFxQlHqv2hJEO4FImj39bDFZphCuB9U6ErvYdIZg+p3dCfEqVl39iyqS+CaJ85Rhw
         bK8VgZmWNtAfVF3RbhISGhoRtrVEa0QnB9SWPDsBytwwHya0eLtGVtlKxH+SJZCvTXat
         h4cSx4h/92ba9pKyI1grNIHB/E/YGvatUaJwO8gcj9qouWYkEshau9Wht23bdsDAk0Qd
         c6B+P0oGUsPmbOnb3sfe5nJxL6QgjPFMu8cxVcLud46aneF525+ZwOcoT/+y3uxY7QWm
         DToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uqSYlC0I4Uk2XD+zNrdVsAZt4a+qWQj6Ntf9g58LQWo=;
        b=I1cYd6kxaD5UQmXVBwMLBrpnNl9GCTtimiLl220ebAJCQkgw52XHet3+9VFM91D6+J
         Bf0VzW5MVNC68SGYwFogyfvjywDx9oY5dLkL3nU46h5V9VCHv0OuxGSxd3e7KzIy2DiP
         u7RhQtCHWz482GoYJOi7riV9dTlLhNFbCWY9rEH9v3jIqq8m45sJRyWBYU8baTlV4yuG
         ZKcb84cZT0WxPP1n7ypjizhlFLN2cs4VF/hwvLMNShWI9UHYhRuULLCPNuO7Q6bUMIgy
         HgrTzXw0VxVDVe2+eNamBI49O9Nu1VYP0p9lTEyt7rlWv6IrogsL/XgZMGGNSCCZoNj+
         gcbw==
X-Gm-Message-State: AOAM533JV5Q1nNcxcUlfH3LDhDBKdgGDYc24s83JfLXyG2mYuMP598Bz
        uqP9Oz0H5jJC5SrqaovpNiqYVZQbNRHxCg==
X-Google-Smtp-Source: ABdhPJxcg2JjViS0WdcZ+sawcs+yC2AKTIBpMSdDQfvAmUoPeRvcuAZMaCu87WehH8mc83diCZLWNMf0F/s9oQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:b70b:b0:143:74b1:7e3b with SMTP
 id d11-20020a170902b70b00b0014374b17e3bmr82697946pls.26.1637366306591; Fri,
 19 Nov 2021 15:58:26 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:54 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 10/15] KVM: x86/mmu: Abstract need_resched logic from tdp_mmu_iter_cond_resched
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Abstract out the logic that checks whether or not we should reschedule
(including the extra check that ensures we make forward progress) to a
helper method. This will be used in a follow-up commit to reschedule
during large page splitting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f8c4337f1fcf..2221e074d8ea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -645,6 +645,15 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
 			 _mmu->shadow_root_level, _start, _end)
 
+static inline bool tdp_mmu_iter_need_resched(struct kvm *kvm, struct tdp_iter *iter)
+{
+	/* Ensure forward progress has been made before yielding. */
+	if (iter->next_last_level_gfn == iter->yielded_gfn)
+		return false;
+
+	return need_resched() || rwlock_needbreak(&kvm->mmu_lock);
+}
+
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
  * to the scheduler.
@@ -664,11 +673,7 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 					     struct tdp_iter *iter, bool flush,
 					     bool shared)
 {
-	/* Ensure forward progress has been made before yielding. */
-	if (iter->next_last_level_gfn == iter->yielded_gfn)
-		return false;
-
-	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
+	if (tdp_mmu_iter_need_resched(kvm, iter)) {
 		rcu_read_unlock();
 
 		if (flush)
-- 
2.34.0.rc2.393.gf8c9666880-goog

