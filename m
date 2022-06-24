Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986AE559F9F
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiFXRS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiFXRSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:17 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9011D2DAAF
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m17-20020a170902d19100b0016a0e65a433so1568228plb.8
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=M0UiwptlSyW8L+ANHt+ZpR61B6xI8IZ3E4fBNYs6MYg=;
        b=XrRDk09dnK9G28hf25NsPO2C2O+/LCbUKVT9HMDoIVz3XYOG2M5T+Ff+QUGBKbWeQ+
         lzl8ylTlJL2SO4Yb+KkHcwOmjaU7KyMkKX+2mkEGnOnKcaBtAU4laopLRua2YlgYbzni
         CrgEpoEvRdSlzEOrR4SjYkbLiAQMILSTc20i2WoG3Yd8n1Qu1T7g4zjiqTZXApodAnQA
         GMDSui5nHkJYMdalw4RAeTDx1Ch3xlqDHebtZvpC1DT+9ynLlvlwIcUQRPI2zj65BTlE
         69wCilA/Soh7oQqcHPhvrYxTf0elWBUfQLoDoIaSeasZTWBWk0iNP67J/TBttFEqwDWu
         a/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=M0UiwptlSyW8L+ANHt+ZpR61B6xI8IZ3E4fBNYs6MYg=;
        b=lVfCsrJZHGcA0aWM7FJKimB/D3F1/MvUfrQlDb+EJyulmq/D5Z4ettr5X8vwa709Lt
         gJhvWV13IbTLchzDdxFsZqsRfxIkcFtjzxTp/qqh1pzLWthD46Qn21cOWa9Gf7lNBKOX
         KvCwv3aVLtC95mp64KB+gvvaFUKp9d41OGVXsItB1WpEppH3lnocLtPAHYUOG0I/sU4+
         fHz8NkPOLGqcw2tjjtdAPDvWqoInTlfxHokI/YGznbYdqoKRdgK//4WgIGkuGFSFz+kV
         Ecjto1yGs/VsXtGVWMtae6HhfH61NjNrevGQ/+wd7AbnkNZK0n1d6wDC2opjiVo0k4Jw
         JJNA==
X-Gm-Message-State: AJIora+H9ugyw0t9MXQZ7C6yH9FW8533CG7lWetKArnoOL6/u46m1VKG
        D1whUaLgP9zqj4LdDxJB0gtMpzfCEs4=
X-Google-Smtp-Source: AGRyM1vZh/Fkd6KxNePHgTeQcVycyBP64A6qITCO6uIzEtiy7++NE/gKLrH2ufPgnbUrWMrwnL3Xlb3MaU0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c94b:b0:16a:3f98:84fd with SMTP id
 i11-20020a170902c94b00b0016a3f9884fdmr120863pla.70.1656091095691; Fri, 24 Jun
 2022 10:18:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 17:18:08 +0000
In-Reply-To: <20220624171808.2845941-1-seanjc@google.com>
Message-Id: <20220624171808.2845941-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220624171808.2845941-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 3/3] KVM: x86/mmu: Buffer nested MMU split_desc_cache only by
 default capacity
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Buffer split_desc_cache, the cache used to allcoate rmap list entries,
only by the default cache capacity (currently 40), not by doubling the
minimum (513).  Aliasing L2 GPAs to L1 GPAs is uncommon, thus eager page
splitting is unlikely to need 500+ entries.  And because each object is a
non-trivial 128 bytes (see struct pte_list_desc), those extra ~500
entries means KVM is in all likelihood wasting ~64kb of memory per VM.

Link: https://lore.kernel.org/all/YrTDcrsn0%2F+alpzf@google.com
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2213eeadebc..069ddf874af1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6125,17 +6125,25 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)
 
 static int topup_split_caches(struct kvm *kvm)
 {
-	int r;
-
-	lockdep_assert_held(&kvm->slots_lock);
-
 	/*
-	 * Setting capacity == min would cause KVM to drop mmu_lock even if
-	 * just one object was consumed from the cache, so make capacity
-	 * larger than min.
+	 * Allocating rmap list entries when splitting huge pages for nested
+	 * MMUs is uncommon as KVM needs to allocate if and only if there is
+	 * more than one rmap entry for a gfn, i.e. requires an L1 gfn to be
+	 * aliased by multiple L2 gfns.  Aliasing gfns when using TDP is very
+	 * atypical for VMMs; a few gfns are often aliased during boot, e.g.
+	 * when remapping firmware, but aliasing rarely occurs post-boot).  If
+	 * there is only one rmap entry, rmap->val points directly at that one
+	 * entry and doesn't need to allocate a list.  Buffer the cache by the
+	 * default capacity so that KVM doesn't have to topup the cache if it
+	 * encounters an aliased gfn or two.
 	 */
-	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache,
-					 2 * SPLIT_DESC_CACHE_MIN_NR_OBJECTS,
+	const int capacity = SPLIT_DESC_CACHE_MIN_NR_OBJECTS +
+			     KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
+	int r;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache, capacity,
 					 SPLIT_DESC_CACHE_MIN_NR_OBJECTS);
 	if (r)
 		return r;
-- 
2.37.0.rc0.161.g10f37bed90-goog

