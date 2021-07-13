Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892D53C7967
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 00:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbhGMWMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 18:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbhGMWMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 18:12:54 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C310CC0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:10:03 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id p10-20020a17090a428ab0290175556801d5so1996212pjg.2
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2ABDjF8MB/R2dWxAlh/L8XFGX/KrVG9UAlNev/AY4Ro=;
        b=fWOB1+SWJjnWGUBoXuRGcX52L8gVHhqP6B5fG7eFi1XBkZAaQXzcZySH1fYhg/84K5
         TXHTyzh64YcBZt5H0gTZZql0maJ+aje/yv9QdsMfac0NJCT1ReCiMw8vwg9NC+8VitS1
         c2EyM+QpCExpgwBDJ0wYWY/LoqriqX+ZWeF8xZjBxDegatWVszuESP9JS6yTmYVyOlD2
         NrWgSruaOxec979iIp5TUl3O9hXWX41+xquaY7QerGHk/3AxrNZkdCMLyBEGYG3ucq01
         8ZTC4NSY449t5RcUzh0E6Xy4qt4FZgpu0Whn6Qp2UnD576tSqKo18eNK0knSyLqS2tMM
         TOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2ABDjF8MB/R2dWxAlh/L8XFGX/KrVG9UAlNev/AY4Ro=;
        b=kbqAN39Ycet2On02PtEeOHYSn3waUqMSAtbN0vgXaFjl6uN5RwZ+CYekIjrWMQYdGU
         CySrG8TkFARR5Hn3w4qCMcEoINU3NXk/f06/v/+2pJ2OnTonpFXalYbsTakCggTAA5CK
         KpkqE/am5yIvLSN+f1/eDxHlXdjstAf2Kl8jQRymMhH5ylFQ8hBxlu4JOYnBZbZDwbxG
         bPwa2dHOqiKUd5VB6qmp9PKKtRsS4Ram0D4SFaiGF/+BFfN/p/vleP13h232E5nmQkJF
         aFddRWZZ69b7POShpkvSUOSd3I5tyUWs3K7t/oYqcbYZrhKRdSldP8GDVBWzEzLHz+s5
         D90A==
X-Gm-Message-State: AOAM5326FXniCJWZMWjT2xRDkbg7mQR+4EXYv80CS3Lap5xrrgOndAeo
        D16sI7+gLpB+rKxIvMVe+QpxDh4AEziV0hAGuUOOO6stIAHG4dECoSHQiF0ATkS9Qtdv+Tq21R0
        RxqxLhKtR+/u9KW8GGqXtlDmwAjlni1VIiLpxo5GM+zbKzHlJWy5ylcrgdLKJsrA=
X-Google-Smtp-Source: ABdhPJyNQ36hT+QjX/LQi841V24Bw9vpQRl1+dMh0NcaK1JinW+vAx0I2FejaIcShBKWZj6GIVl0yIX4tZ9RVw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:4cc4:: with SMTP id
 k62mr416653pjh.110.1626214203174; Tue, 13 Jul 2021 15:10:03 -0700 (PDT)
Date:   Tue, 13 Jul 2021 22:09:52 +0000
In-Reply-To: <20210713220957.3493520-1-dmatlack@google.com>
Message-Id: <20210713220957.3493520-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20210713220957.3493520-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v3 1/6] KVM: x86/mmu: Rename cr2_or_gpa to gpa in fast_page_fault
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

fast_page_fault is only called from direct_page_fault where we know the
address is a gpa.

Fixes: 736c291c9f36 ("KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM")
Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b888385d1933..45274436d3c0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3098,8 +3098,7 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
 /*
  * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
  */
-static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-			   u32 error_code)
+static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -3115,7 +3114,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	do {
 		u64 new_spte;
 
-		for_each_shadow_entry_lockless(vcpu, cr2_or_gpa, iterator, spte)
+		for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
 			if (!is_shadow_present_pte(spte))
 				break;
 
@@ -3194,8 +3193,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, cr2_or_gpa, error_code, iterator.sptep,
-			      spte, ret);
+	trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
 	return ret;
-- 
2.32.0.93.g670b81a890-goog

