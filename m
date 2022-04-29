Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8684C515644
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 23:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381208AbiD2VEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 17:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381176AbiD2VD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 17:03:59 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C93D3AD9
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:40 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z132-20020a63338a000000b003844e317066so4230645pgz.19
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oVHyIBszbDyqiN0B8KQ/gaGeKqiBcFYqK348Whkf25k=;
        b=bHSvSCXEnTRlSKz9TJdTHolfFAIJ5mv5KXa90YK5sNIw1dDpT7ynOAc6ZfQuzdhZoc
         CPVvxgkxvFJeKWtamHyMP2S38WjV5YgRF7iUsNZX/uvXqyvOX/Mo0jsMAb6yeTiZrlxK
         Ar8AKwJgRX812sAM5Criwkt2G1TlF+95FD+aY86fDqDuIaS9z4nzGggEIljvikFmZKA9
         +vUp2TitWs1TkNd4SgOWNpmFsTrbUTbg0XrzstiYYKHdDnlrrFemJXteYa5sW4nsxQ/C
         7ZzOki7/Pm2n0FaJoEQ4WKGD8xaGDZ7ACMsRgJ68PASufILGXdyU7LVk1pHoz4Y8j13K
         sLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oVHyIBszbDyqiN0B8KQ/gaGeKqiBcFYqK348Whkf25k=;
        b=o5w5B1OFzfVJaj0sde6xGU+CQ36VoanjR6ymmnWOhWTRm3WmOLNqgNdFlsOJc9qJlz
         de2gcqQml7/SXDK0W5/qMJwpj5QvTPOb7OZnVwd9qtCaeJ0pgNqwSm8t+J0lK8h8yI5M
         MhkqPEY+M4wls3ahDGgoKVH+m/z9/Uq9x0Azjwc19YKnfaIyClsOgrEryQU/BfiMdETs
         F4YWFweKKzdhTHHdPUUvy36O3dbdFo8dRDOHXNZT3Bj9cxh4HPCiVjYAi9R92Syz9BV/
         cxP2gPloiox/s2YIpeJTY6oY9MfIAgXToZoy0rD7Nwy82P+vBsf9Qw9rvA+nV+fSIGpV
         aW4w==
X-Gm-Message-State: AOAM530spi6Dfm2e0AtG+gVvQucAh7md3Uuu7BGssaFXuJWLSeugHo6Q
        iaty6bHiAOk9ynlchx509uc4rx4a8X4=
X-Google-Smtp-Source: ABdhPJznDy/XL7iYypgDUM2Vbyu+1rRgbREm4VNBI3n8aEqkpL+OB6uGl7AgT7gb/929JVQsmuabyqt3iUo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3442:b0:1d9:8af8:28ff with SMTP id
 lj2-20020a17090b344200b001d98af828ffmr979126pjb.201.1651266039638; Fri, 29
 Apr 2022 14:00:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 21:00:23 +0000
In-Reply-To: <20220429210025.3293691-1-seanjc@google.com>
Message-Id: <20220429210025.3293691-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220429210025.3293691-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v3 6/8] KVM: Fully serialize gfn=>pfn cache refresh via mutex
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protect gfn=>pfn cache refresh with a mutex to fully serialize refreshes.
The refresh logic doesn't protect against concurrent refreshes with
different GPAs (which may or may not be a desired use case, but it's
allowed in the code), nor does it protect against a false negative on the
memslot generation.

If the first refresh sees a stale memslot generation, it will refresh the
hva and generation before moving on to the hva=>pfn translation.  If it
then drops gpc->lock, a different user of the cache can come along,
acquire gpc->lock, see that the memslot generation is fresh, and skip
the hva=>pfn update due to the userspace address also matching (because
it too was updated).

The refresh path can already sleep during hva=>pfn resolution, so wrap
the refresh with a mutex to ensure that any given refresh runs to
completion before other callers can start their refresh.

Cc: stable@vger.kernel.org
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_types.h |  2 ++
 virt/kvm/pfncache.c       | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index ac1ebb37a0ff..f328a01db4fe 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -19,6 +19,7 @@ struct kvm_memslots;
 enum kvm_mr_change;
 
 #include <linux/bits.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/spinlock_types.h>
 
@@ -69,6 +70,7 @@ struct gfn_to_pfn_cache {
 	struct kvm_vcpu *vcpu;
 	struct list_head list;
 	rwlock_t lock;
+	struct mutex refresh_lock;
 	void *khva;
 	kvm_pfn_t pfn;
 	enum pfn_cache_usage usage;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 05cb0bcbf662..eaef31462bbe 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -157,6 +157,13 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	if (page_offset + len > PAGE_SIZE)
 		return -EINVAL;
 
+	/*
+	 * If another task is refreshing the cache, wait for it to complete.
+	 * There is no guarantee that concurrent refreshes will see the same
+	 * gpa, memslots generation, etc..., so they must be fully serialized.
+	 */
+	mutex_lock(&gpc->refresh_lock);
+
 	write_lock_irq(&gpc->lock);
 
 	old_pfn = gpc->pfn;
@@ -248,6 +255,8 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  out:
 	write_unlock_irq(&gpc->lock);
 
+	mutex_unlock(&gpc->refresh_lock);
+
 	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
 
 	return ret;
@@ -288,6 +297,7 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 
 	if (!gpc->active) {
 		rwlock_init(&gpc->lock);
+		mutex_init(&gpc->refresh_lock);
 
 		gpc->khva = NULL;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
-- 
2.36.0.464.gb9c8b46e94-goog

