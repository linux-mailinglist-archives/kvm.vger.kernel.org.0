Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD6830CB4B
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbhBBTUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239217AbhBBS6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:58:25 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECC9C061793
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:57:44 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id u66so18226570qkd.13
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Cra3FPzbCtRzIcvq0e9H9YxXh60eEn/9H2dqE2N9TfU=;
        b=p823Z4ilFYZxxy9UpoD/iwe6gt9jgEy5kxVKN9i9/tHseeVNazzD9Lo54JAfCVpxoK
         vFAls/EJDEFnWDrNGgu9B8XoE6aKqgfQtkBDXfphCZfmlgDS0pq142+e3O3o6SfEjh1w
         LkNH3ejAwSVl9T+Qdo3jwJMTJVz48aOLAumqDUa8XYWeStDE5kAdGYxBvNdhpspdCH0E
         OTZXIdKVfdA5ny6I6rZJAQsglB4StEN6zW5olpmaglwNLLgMNBKi7GP1lUaGw5WLkLbs
         QS2t56MjAkXwkt/id6yGPy1l9Fq1Qli34MlZDv/p8gKUKnkphe5WUqEN1146rBtOg7Hm
         GTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Cra3FPzbCtRzIcvq0e9H9YxXh60eEn/9H2dqE2N9TfU=;
        b=qt/949FAUEHw+ppVzqQ+79yi9X55P7cSykJK6N2gzi3l+FEVEWDeVp8Ghgi7si4wzX
         9wCjlzlHS9eqrI3TRJpUuH7RYiL/RTc6+G9Kl/pdNmzQ1fJgGm9i6o+RbibwNb3ew99W
         AlC80yk+Uq8f6mPZ9VdDDQqfZux4y9jsY0vuhc2EPF6u65rcD0aiQaAknHcM5cDs/Gmp
         zltrK84jlpcHmodeQAPlydNnl3FSKauEcyY9pIWDAFJ6fXuHt+KoJLgo0HWzTiyy8TyT
         5+/i3POn+oyrAeMSyo0Wm6i2Z2oAkKdZNeUd+SFAdTgXJGvpom1MU+9Z0ZACfcmlED72
         nQRA==
X-Gm-Message-State: AOAM531CNa7RjZUdO4gQfq57uR4JeTBx3YK2FUvswfqo1zmXnEN6GuGu
        tXnA2G1yqWmVtiMF/+Vu2lUASedxWjs9
X-Google-Smtp-Source: ABdhPJynRt6E/nk50AlfkYVFuCNBExPQoQBYs/j6qqmjMLVk2sU/q5KZSY/y9Kp24h0PIcJub0x9og/NUiwG
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a0c:b509:: with SMTP id
 d9mr2910426qve.29.1612292264016; Tue, 02 Feb 2021 10:57:44 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:09 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 03/28] KVM: x86/mmu: Add lockdep when setting a TDP MMU SPTE
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add lockdep to __tdp_mmu_set_spte to ensure that SPTEs are only modified
under the MMU lock.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3d8cca238eba..b83a6a3ad29c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -381,6 +381,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
+	lockdep_assert_held(&kvm->mmu_lock);
+
 	WRITE_ONCE(*iter->sptep, new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-- 
2.30.0.365.g02bc693789-goog

