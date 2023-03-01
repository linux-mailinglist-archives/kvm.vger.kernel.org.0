Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B906A75EA
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCAVJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCAVJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:09:45 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9754BEA5
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:09:44 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id v15-20020a17090a458f00b0023816b2f381so4347038pjg.2
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 13:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DqA9XPbdG72ij8bnt7P1FG5k/aZwFU14SdlEVjUmaeQ=;
        b=Di8RI9KA4HPs+lwFiOVEWU1f+4M8cDSY9XVJ/MlMifv+lFD1Kx+kz15kGAQ26n33Rw
         mLMjSPzYRJ/nA8sEBvn7Ge1ky3/HXLI5lzHK4ddEk0XvH3x3kphbhtm2NM7a3PFMtPmw
         dQu24XlzT/OTKwnEC/dX6oZ2++xnNEzNw/S7IoZ/bPVBy0rcJX8g0cGQuCqBcc1oczET
         V/5F98DdOOcXw+2cKe9nhAEnUrJiEpuL9jW+tdG8YqbPnTlKBoXpgbkwU9UMxbh05YRH
         sWwwgixDq//SOtNAEZI7n+RQGa2bY6wjv3xzSj98H8ReMzzb+wnY20jIzezLmA09eWVj
         IbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqA9XPbdG72ij8bnt7P1FG5k/aZwFU14SdlEVjUmaeQ=;
        b=VohlXrtomed3yadSeCnDbORvyk8NxX199ocZkuyEjm4NFDQvrcaeH04ZGXX+ZyTzG8
         pQM8zQTaybmPtXpfpRijZDHtAJPRsmV7et6/ODucy/9+ZL3ghPI/KkNkdstzaMNXZosg
         dnzXEYTmdwh8rqFA2K9BB7DoEamliQUIfuN8Q2ylpHZyr79lXhVdONUAqMEnhCnAcwg6
         6Sjg0Qrttto73VnL/bodFm6Hy6s0yuXmzGCBnO3CYjSKWkMfdmEh7NKgGkkKxhrFN0WS
         hUF+fEUAJQlBqk6bhip/fzfq8kdyY+tMTccERk4qCRqfhQqEkDluTMzrB9OPOEJsBGPb
         4WSw==
X-Gm-Message-State: AO0yUKVWQMPC/JN4m48YD1TjwM0xea/e1YHCandeFJIDmcgRdomwZx6R
        jhC35gOHDJY4RBMFQymwY1BNxeCFMVyBjw==
X-Google-Smtp-Source: AK7set9aWhP2GLViX6xifcLL83bOgHSFy+VYxOzjjIe65tdTxY8xZL1AY5Jg738RWC0IZjRmQr5q+r1hn95JbQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:903:187:b0:19b:36:30e0 with SMTP id
 z7-20020a170903018700b0019b003630e0mr3105569plg.5.1677704983960; Wed, 01 Mar
 2023 13:09:43 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:09:23 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-8-ricarkol@google.com>
Subject: [PATCH v5 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export kvm_are_all_memslots_empty(). This will be used by a future
commit when checking before setting a capability.

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..8c5530e03a78 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -991,6 +991,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
 	return RB_EMPTY_ROOT(&slots->gfn_tree);
 }
 
+bool kvm_are_all_memslots_empty(struct kvm *kvm);
+
 #define kvm_for_each_memslot(memslot, bkt, slots)			      \
 	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
 		if (WARN_ON_ONCE(!memslot->npages)) {			      \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384b5ae0..3940d2467e1b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4604,7 +4604,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return -EINVAL;
 }
 
-static bool kvm_are_all_memslots_empty(struct kvm *kvm)
+bool kvm_are_all_memslots_empty(struct kvm *kvm)
 {
 	int i;
 
-- 
2.39.2.722.g9855ee24e9-goog

