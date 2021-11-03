Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4C94445C3
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 17:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhKCQVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 12:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhKCQVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 12:21:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8689FC061203
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 09:18:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b126-20020a251b84000000b005bd8aca71a2so4682859ybb.4
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 09:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=eD9dW/j7qWODztQefqhaj/ToXeE3Wj/nmDQbWVvMxKk=;
        b=B7Tuyg6FcQjL73pK9DX41IC4JAWwExMKgucji0qg2qjeczLxUp2CqLYXrZvtjFGdBT
         9U1MeUl7T5LeunTuiPha8fNH/D7LkXVMJkCYXYerQRPnEGobJrzvN1E9qVLrXT6K9jIi
         GfsJbk0YI9inqzgSD/fABK+2I/RLQ0jhjvpB21M/7jOSoEg98GTB0WYtQtLTTa3l5zle
         CJ/XX4fZdpfd915ZBeqxyPM9YNhI0P4vrI7pxhdZfowe84rrA0uhzHhkK9BzCkC1B/vq
         Yu4eGUx3D2mf6guZzhRBf+S1PsFUY+8cdKAihax7iSPWUFkQ4FPUSqA90SKJPGMNwAn5
         20yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=eD9dW/j7qWODztQefqhaj/ToXeE3Wj/nmDQbWVvMxKk=;
        b=3nqMo/tOo4DxGklkmK1DOwLHEy2FgP+G/dz8BAc0k5t3i/dewdFn2rwZwU1CVN84Hf
         aebhuaevK9AVd9jpAwxQvoUq18GK3DK2AJlmgXf5zYlt7e8LxapSKfqj8o2EZBBE0e8w
         q45R8dY3Zv2epffeSm9Vu57IMGzMg89KEMu0h9DVuCVoiCrU73CnbzwGWGCaPadx2Xdy
         JzHtQhxXkZfDuaNX0yOuB6B7MbnYMG+ltIhcci00TS9SV5ejeSDv7htmX26Dq8mSVHMz
         90kuqY/yX+hG0WFEluzJYahx88FRLQyx3RMj6SjldvN3PeHOPIgC2zg17l9Z7lF30xsh
         tlbg==
X-Gm-Message-State: AOAM532bLK1u7wRnUa6vn5rACsPwUKOA9kkFQgzTilsO+MsLp28rhw9T
        CSXUJUF9UO1k5SI9VKo62daq7rnkMkw=
X-Google-Smtp-Source: ABdhPJwIxMNQnF6M/364DJH8bbgO+NKWv62p+iKm6Tzw44h2sXOq0ZJtujfou4G2qzCC+VnUbJkNvuaAqjE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e8d5:d0cd:12fd:266e])
 (user=seanjc job=sendgmr) by 2002:a25:d15:: with SMTP id 21mr27811929ybn.141.1635956316718;
 Wed, 03 Nov 2021 09:18:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Nov 2021 09:18:33 -0700
Message-Id: <20211103161833.3769487-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH] KVM: x86/mmu: Properly dereference rcu-protected TDP MMU
 sptep iterator
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap the read of iter->sptep in tdp_mmu_map_handle_target_level() with
rcu_dereference().  Shadow pages in the TDP MMU, and thus their SPTEs,
are protected by rcu.

This fixes a Sparse warning at tdp_mmu.c:900:51:
  warning: incorrect type in argument 1 (different address spaces)
  expected unsigned long long [usertype] *sptep
  got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep

Fixes: 7158bee4b475 ("KVM: MMU: pass kvm_mmu_page struct to make_spte")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c5dd83e52de..a54c3491af42 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -897,7 +897,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 					  struct kvm_page_fault *fault,
 					  struct tdp_iter *iter)
 {
-	struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
+	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(iter->sptep));
 	u64 new_spte;
 	int ret = RET_PF_FIXED;
 	bool wrprot = false;
-- 
2.33.1.1089.g2158813163f-goog

