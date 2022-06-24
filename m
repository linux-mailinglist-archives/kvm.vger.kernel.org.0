Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AD755A37C
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiFXVbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiFXVa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:30:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18967E00F
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:30:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d129-20020a621d87000000b005228d4cbcc4so1631239pfd.12
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=FBTaEZTEg5GSVpewRBYKdCI+FLeByH1Vcwz0M7m4O+0=;
        b=SWbZ73EHxyjh8o5NT5+YNokKeaatVJ46ekafm3q2KaueYufnteAQ+nNnv0g8VuQmzQ
         dHdFDYemFGBvCT+4wkiipM0eUtXvZUQYQ/2yu1xl/ziQv8ITCGWREJevCH/qZKYhaPqx
         JGlwkxDPC2I9qUSoxy/vzMyPDYGWqWUePXYQNHNloS7yfJiyjPmc5xjvxftfm3WGFA4x
         Ws8ly60Yx3TPDrBH5Iy6hhgA1rHtTn7701i3Tn/rhUObgTU8LfBPMX/VmGPMyk4xFrsf
         cd+bqJ0ZwVcILvOgSExuBkQ2KKX58+0nCQINRuuQjWpSwdslQIsAuu7Bxm1i+TquTdws
         OeYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=FBTaEZTEg5GSVpewRBYKdCI+FLeByH1Vcwz0M7m4O+0=;
        b=fCDX1+d5rSpkkEPr3d6mbqL1izpLZBAkRntIiX4c+Sv6nlKR1Z4owVqSG7jwXao+WE
         zPYDXvNQa7wPpQOyTlEK0nEPm3cGrKvQ+aq8sw30w4m4ZiCb0W/Jt42VaHoaoYr6du0H
         w0F7c41Gle3b0ZS9HeWGwGWuseiy4HpMXoFU2gNlzy9jeU0U2DJFJiKcgIRcS54hHlQS
         ck+7Zdg9yocJGHTM6l+uqh/XygJ29Y6F1QOKbOQb2pkb8L2rqsmui4vBO+n8jIyxai+b
         44UQTz5+WESDwU0ncEkAdvRwSeaB789z8nonitlDBkKfTs4kuzpYdwBcCEXOHjBybvwT
         x9lg==
X-Gm-Message-State: AJIora8jms4IrmuD7yrT/P5BedH5Dbp9ZmInXpMxASfg+oLl8ZDAoPWd
        y5Rufx99LtQhRV5Gy3CGGzyzKDG562s=
X-Google-Smtp-Source: AGRyM1sugnfEsmqVDhbHA4jyTxXo0iuQG8dGD8pRvqXU8Z2EFcOSud0AzOY1pj5YaZMeBTqxatGprCqYfyI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c4:b0:16a:5c48:8312 with SMTP id
 n4-20020a170902d2c400b0016a5c488312mr1169374plc.45.1656106257561; Fri, 24 Jun
 2022 14:30:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 21:30:39 +0000
In-Reply-To: <20220624213039.2872507-1-seanjc@google.com>
Message-Id: <20220624213039.2872507-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220624213039.2872507-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2 4/4] KVM: x86/mmu: Buffer nested MMU split_desc_cache only
 by default capacity
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Buffer split_desc_cache, the cache used to allcoate rmap list entries,
only by the default cache capacity (currently 40), not by doubling the
minimum (513).  Aliasing L2 GPAs to L1 GPAs is uncommon, thus eager page
splitting is unlikely to need 500+ entries.  And because each object
is (currently) a non-trivial 128 bytes (see struct pte_list_desc), those
extra ~500 entries means KVM is in all likelihood wasting ~64kb of memory.

Link: https://lore.kernel.org/all/YrTDcrsn0%2F+alpzf@google.com
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eae5c801e442..52664c3caaab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6123,17 +6123,26 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)
 
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
+	 * MMUs is uncommon as KVM needs to use a list if and only if there is
+	 * more than one rmap entry for a gfn, i.e. requires an L1 gfn to be
+	 * aliased by multiple L2 gfns and/or from multiple nested roots with
+	 * different roles.  Aliasing gfns when using TDP is atypical for VMMs;
+	 * a few gfns are often aliased during boot, e.g. when remapping BIOS,
+	 * but aliasing rarely occurs post-boot or for many gfns.  If there is
+	 * only one rmap entry, rmap->val points directly at that one entry and
+	 * doesn't need to allocate a list.  Buffer the cache by the default
+	 * capacity so that KVM doesn't have to drop mmu_lock to topup if KVM
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

