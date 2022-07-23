Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DAA57EB93
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 04:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbiGWCny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 22:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGWCnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 22:43:53 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112B672EC4
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 19:43:53 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31e9b1be83eso33939507b3.8
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 19:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rbqoVGvRY7Kcx6taFE37v47m40ytsdeb3PlRHcKhlwU=;
        b=BvO2HI3dTYXFmq+JDC6Z2fnPyrjcAUg2CYEwH5DNJZX+Sj768/rqn0veokIeLRyQzO
         6zXavecjFYWEPZbr/9CXcGIkCZeZse5k7fiCeJhny4aT9Y+Gy15PpiW3gG1tAaI37Xh/
         dFwZZIdkAN3JJv0chXkdY3uNZx+KThSalhpCU8wHfIfdTEN66s5ETnc9tltOzx2xb89p
         BuUvT9iG1f6W5SU9SngHwBqMXRVG0f1NaIBUxxLczTogRxAtdRs8IXfm1psL7x93nnNq
         9d0mlpzLFnOb2AZ8tP1yXghqCQ/qMoVEqxJReu8Hn/PRZqauZZTnAAAPCMBUAhgnI5GJ
         1/2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rbqoVGvRY7Kcx6taFE37v47m40ytsdeb3PlRHcKhlwU=;
        b=QGdUIjg/YuwW+TFUr371RWA8CXgdylU7gk34oLyaS42TAlNsj9P0cQbe5UweYf4g+6
         Hw8S1ogwXY4QHtE76yzf0qHbnTEG6YxPMxanNApigXOe77Tashn8yTZuu1SawEpZi331
         ZCszkAQyC+cbbhOCac0zS4M+teiVLhoWhb2uhnnKgMzu+AoUq2zTWxNdgwzSuHfcHkx7
         I8iXoD/iLSI/2mnAQjNETQ6XamNYLUK5kMB5ivuRgESNldmIfIAnVcWRfiWs7+sT865N
         LV3zvCr4KP4CpwqkcUR5XaudMqq1hwxeg9+2PLejYRoNblX/KkPPXoaEKspYyz1B4i3U
         1mlw==
X-Gm-Message-State: AJIora/aDx4NfIN53vRkHBX3YLfbbnI2FUf1suD/ZgkKDI6xiMWuzCa2
        20tO1VZFXJKb0HWqWNUEIlNwI7iIU3suBtSlzia7zZGN8Bh9XvEgy6sHjUsaK+M0f/djXYBbG6x
        qzyUncqV1vkpgXPBYW5IX8ZFi+KzWIXtm0ueWROuAChe6KJADdUL60FeVt4bw
X-Google-Smtp-Source: AGRyM1tZ+a6RD7SfA1Bu8ReIeCjcTebIBfU5UyCUh1iJ+SynBJJLTrskvZzbtgpZivV4dE3he/zwNbRCJaXN
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2d4:203:3131:3935:802a:97ba])
 (user=junaids job=sendgmr) by 2002:a5b:e87:0:b0:670:4766:5713 with SMTP id
 z7-20020a5b0e87000000b0067047665713mr2354079ybr.119.1658544232329; Fri, 22
 Jul 2022 19:43:52 -0700 (PDT)
Date:   Fri, 22 Jul 2022 19:43:16 -0700
Message-Id: <20220723024316.2725328-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH] kvm: x86: mmu: Drop the need_remote_flush() function
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, dmatlack@google.com
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

This is only used by kvm_mmu_pte_write(), which no longer actually
creates the new SPTE and instead just clears the old SPTE. So we
just need to check if the old SPTE was shadow-present instead of
calling need_remote_flush(). Hence we can drop this function. It was
incomplete anyway as it didn't take access-tracking into account.

This patch should not result in any functional change.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f0d7193db455..39959841beee 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5333,19 +5333,6 @@ void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu)
 	__kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.guest_mmu);
 }
 
-static bool need_remote_flush(u64 old, u64 new)
-{
-	if (!is_shadow_present_pte(old))
-		return false;
-	if (!is_shadow_present_pte(new))
-		return true;
-	if ((old ^ new) & SPTE_BASE_ADDR_MASK)
-		return true;
-	old ^= shadow_nx_mask;
-	new ^= shadow_nx_mask;
-	return (old & ~new & SPTE_PERM_MASK) != 0;
-}
-
 static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
 				    int *bytes)
 {
@@ -5491,7 +5478,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			mmu_page_zap_pte(vcpu->kvm, sp, spte, NULL);
 			if (gentry && sp->role.level != PG_LEVEL_4K)
 				++vcpu->kvm->stat.mmu_pde_zapped;
-			if (need_remote_flush(entry, *spte))
+			if (is_shadow_present_pte(entry))
 				flush = true;
 			++spte;
 		}

base-commit: a4850b5590d01bf3fb19fda3fc5d433f7382a974
-- 
2.37.1.359.gd136c6c3e2-goog

