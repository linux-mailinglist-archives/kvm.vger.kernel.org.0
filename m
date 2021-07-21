Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627153D0822
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 07:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhGUEdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 00:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbhGUEcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 00:32:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F378C061762
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 22:13:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a4-20020a25f5040000b029054df41d5cceso1725432ybe.18
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 22:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9I8kvfv5vG3vEdo50f//Yo9C8reQVqyT8SACyEwJ4Ic=;
        b=JnlAUk5S0RhnnffkXK0G4vaaasewgr5jlAttWZTzpyNRuVZOi8a2HF+srPr0iclt7s
         Y/cKsyQ3AU2OPCsiqUowNAuhkzpwYW9Jd23b0Fxr8+PD/ZHOW3Ny9oXheNOjEzbXrjTR
         PRS5K0P0jdl6x9nzzwL6AgfC5Ff+ufKMsiUE3MSyQZQEUO7tqk3b51/hRoFjevQP7g32
         zca/kAHbznTtaz5TbipULXP2e9TwGw15buUnYvCF1NBoDhY9gbvqIuVX+cCBz7zFI15l
         GbfrptFHYiYZbt0MnM9F3B8v0lOXkYiR59Axi4zbZdFf2yGyGBIf6bJTq+JMRmTsnnGD
         Gt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9I8kvfv5vG3vEdo50f//Yo9C8reQVqyT8SACyEwJ4Ic=;
        b=bvJuDORf9Xw2LVXe6y9mbqjjHTrm8iUQe9vI7Za8YHUdrX3CdMYXIHRcNgi+nD64Wy
         YU3Sg9tlWAf1Y1PJAGadxJXYEEvLtMghxFqbz35svVeGzocLKCK1+vsPiO4aFd7z8KFh
         mB4ytTuI5Dnm2WIqu2+1jyC+/65kXr9LSkDXqlvNVVxR78Jf8W+CNgkdlo49zrIv1VLJ
         TPISXdnqLdrjJllfNcEo2TBMkhUnA37q5wBr4r93XwvQEz5ZdEXMtSsrzlNhJNo6Q3Iu
         253x4Ph9XZ/Ak5sZT9kzp9Lo/5CGuGG8Augnk9qEtR4PquJ5FrUbccWrtDR4NDEKs7F0
         bPLg==
X-Gm-Message-State: AOAM531p54tp+pz5dltF0MAvEBR/W1U2UMN0vNMcXVuYUKBGEThhyV5Z
        fgnu8lXu5iKJrKrrJXPQ9wqq6t6hMuHe
X-Google-Smtp-Source: ABdhPJzBrVzuo56V0U2g15OOlBBRGgASpzCO6VpOhCQpCw/CcRXdF6+d+96F4wgqc809+uJZF2z0Sy/Uoqt7
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:4b06:fd20:8c22:9df1])
 (user=mizhang job=sendgmr) by 2002:a25:d008:: with SMTP id
 h8mr44887585ybg.215.1626844395747; Tue, 20 Jul 2021 22:13:15 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 20 Jul 2021 22:12:46 -0700
In-Reply-To: <20210721051247.355435-1-mizhang@google.com>
Message-Id: <20210721051247.355435-2-mizhang@google.com>
Mime-Version: 1.0
References: <20210721051247.355435-1-mizhang@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 1/2] kvm: mmu/x86: Remove redundant spte present check in mmu_set_spte
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop an unnecessary is_shadow_present_pte() check when updating the rmaps
after installing a non-MMIO SPTE.  set_spte() is used only to create
shadow-present SPTEs, e.g. MMIO SPTEs are handled early on, mmu_set_spte()
runs with mmu_lock held for write, i.e. the SPTE can't be zapped between
writing the SPTE and updating the rmaps.

Opportunistically combine the "new SPTE" logic for large pages and rmaps.

No functional change intended.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b888385d1933..c45ddd2c964f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2693,12 +2693,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
 
-	if (is_shadow_present_pte(*sptep)) {
-		if (!was_rmapped) {
-			rmap_count = rmap_add(vcpu, sptep, gfn);
-			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-				rmap_recycle(vcpu, sptep, gfn);
-		}
+	if (!was_rmapped) {
+		rmap_count = rmap_add(vcpu, sptep, gfn);
+		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
+			rmap_recycle(vcpu, sptep, gfn);
 	}
 
 	return ret;
-- 
2.32.0.402.g57bb445576-goog

