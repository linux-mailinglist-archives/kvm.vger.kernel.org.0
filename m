Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCCF457B85
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbhKTEzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbhKTEyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:46 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA4CC0613B4
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:21 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id r7-20020a63ce47000000b002a5cadd2f25so5035545pgi.9
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vpW88SHzUFzeY5wxWhNM8yjnTiJb1vYPDMtlKPeZFAI=;
        b=cGp/JVnUNA505xbBtYaIj0kTLVg9Gu72kOlFwL/+VoR+2UbeLH+zToWHCo9VNiYu0r
         Jzyn+QLlxffEwXLmYAaW+NGsqSGIP1txIjQGp5bonnElZKfHMji/sWWpJ+3r+dqqkQGI
         DoveicQe4HuT0J6dSJI2EcyBpbh6Vlw60oi4LNW58k5P84wKGpSzWbDtbiNK0Kvuv9wz
         L1wC7A+L64bY6R0XlY0HFDm6eDp5q/GOHn8Ogic4Fgwn5DUeTSJp+9u4sL9n7oKoH3uA
         EfGzEY7rEJcfxuTE77+yfXcdpj7prbToP4kFo6IeWibUJUVeF5FRnhENPO45lzNu9/Ok
         P4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vpW88SHzUFzeY5wxWhNM8yjnTiJb1vYPDMtlKPeZFAI=;
        b=uPJq29YPo3qOHBH4w0qlTvdOUaOIMiux7LqLvyfCEwTapBa1EW7rP/Ba8SN/DZGSB9
         wD4e/rLd7flLOrWciSDTEopLCcWiYg+RlXuhqGf1eiH+yjvOQm5i9NxlhDYI7uebuOqO
         fvTKm2ac5X3zCdrR0ejhqciGIi7CWL9tgGP1Fk3kMzOtBe8tKXlNjgKTMWILvf8JDEEM
         uJ9b3rIsf+Zyx3HsEg5l+GtGffjucmIS8PmyNzIH9NXU35czzMUBARZjZWAWFXOWDFlH
         OQjRHNzyKOApHQWyeRCIQe2b5E9Ogmc3GgcPAUAQ7vHszMEWjkQIzx5xmGtW8fyJ4jZA
         HN7A==
X-Gm-Message-State: AOAM533rwUfED3l0q9UGP7Is4h6IIVF8nsPFOqVTINLVIRSvw/T8tjHj
        rcWCV/YsXmZYGSxGYOHkQT4n2iQWEKY=
X-Google-Smtp-Source: ABdhPJwqRpo1Fz2u4UcrRfyLEP+GCsURIO87vhqvcbYCyfL/Rg5Q/gyNo/Tg+Vl/2jEjFjuKQCR8gGLLLOI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c2:b0:142:76f:3200 with SMTP id
 o2-20020a170902d4c200b00142076f3200mr83849749plg.53.1637383880914; Fri, 19
 Nov 2021 20:51:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:35 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-18-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 17/28] KVM: x86/mmu: Terminate yield-friendly walk if invalid
 root observed
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

Stop walking TDP MMU roots if the previous root was invalidated while the
caller yielded (dropped mmu_lock).  Any effect that the caller wishes to
be recognized by a root must be made visible before walking the list of
roots.  Because all roots are invalided when any root is invalidated, if
the previous root was invalidated, then all roots on the list when the
caller first started the walk also were invalidated, and any valid roots
on the list must have been added after the invalidation event.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d9524b387221..cc8d021a1ba5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -140,16 +140,21 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	lockdep_assert_held(&kvm->mmu_lock);
 
 	/*
-	 * Restart the walk if the previous root was invalidated, which can
-	 * happen if the caller drops mmu_lock when yielding.  Restarting the
-	 * walke is necessary because invalidating a root also removes it from
-	 * tdp_mmu_roots.  Restarting is safe and correct because invalidating
-	 * a root is done if and only if _all_ roots are invalidated, i.e. any
-	 * root on tdp_mmu_roots was added _after_ the invalidation event.
+	 * Terminate the walk if the previous root was invalidated, which can
+	 * happen if the caller yielded and dropped mmu_lock.  Because invalid
+	 * roots are removed from tdp_mmu_roots with mmu_lock held for write,
+	 * if the previous root was invalidated, then the invalidation occurred
+	 * after this walk started.  And because _all_ roots are invalidated
+	 * during an invalidation event, any root on tdp_mmu_roots was created
+	 * after the invalidation.  Lastly, any state change being made by the
+	 * caller must be effected before updating SPTEs, otherwise vCPUs could
+	 * simply create new SPTEs with the old state.  Thus, if the previous
+	 * root was invalidated, all valid roots are guaranteed to have been
+	 * created after the desired state change and don't need to be updated.
 	 */
 	if (prev_root && prev_root->role.invalid) {
 		kvm_tdp_mmu_put_root(kvm, prev_root, shared);
-		prev_root = NULL;
+		return NULL;
 	}
 
 	/*
-- 
2.34.0.rc2.393.gf8c9666880-goog

