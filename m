Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DF93DE5A7
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 06:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhHCEqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 00:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhHCEqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 00:46:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F33C061796
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 21:46:28 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id n4-20020a17090ac684b0290177656cfbc7so2272437pjt.7
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 21:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uvGN8o0svNEgNpDAlc6hd0uZYNG8aDJpGIKyIlckztA=;
        b=EstkdbR37/abuK+nZocc83eoDyxbAueC4xW7VBFBL+11H/s8A7Nj3uKtpONLq5G/80
         3A7l15GjFqzxPajJGMmk70pYdv1YC1UE8P0m9zC/39TbfL61vU0RPUIOK5R5SwNsNabe
         IzkvkvPu9WCs2VagDvbLQNJpDjTpgnUs2FfQCESqF+GoSNgq/+wM/IYW7yNtaYy8lPBN
         ggEN1Q6XqsdfJPdBJGzFtVTl1EKWycwQ7oJI+LlHeeiJcCG6f5XS3KkRiTyk99EbYbWI
         MAP7GBEINtiboJmngr63BAc2Hj7CRxN2bqDyDY9RZRKzUvpYTR80oNAHdOu2Nb17IFWR
         e30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uvGN8o0svNEgNpDAlc6hd0uZYNG8aDJpGIKyIlckztA=;
        b=TSgVOGrTIKflXDskea82vfE6PEfAya8wepR5LycDrX2PAAmqJ+6ZZ5wgTxvitmmvQj
         2YOw5rUxZknwjBF7pvyMUAZoYQPFKBzQeSEovr033AtuJ5Lk1/X72ZjCdL1a8GE1W+Ka
         cJxULAYyEIPsXHNP9rSia4VIAFxiCdvgaKWiUArBvIIFVLTZ3LpfBQite1uLIhLRXV/V
         4PXMYIS2Vr8/BIUe0N4mFJC5PBunr6Q7W4YD8xaRUxLR0rCvdE0qc99E1m3U+KXlrMDq
         ol3UjpWhRAZ/GetEzct7N7/ULKVwxvf9HuTnCw5F3mqatZmNKDwDxSRQeZNFUTyr40U7
         1OFQ==
X-Gm-Message-State: AOAM533jTPlVblmJ87smZl6OCQFiD2zD2a1vNM+ESzQYnBrxyZKJtpLS
        nHqi/hURDRATXwV46hQhOxPI4aMLeaa/
X-Google-Smtp-Source: ABdhPJyaw9WJ7iFBQaTLk0jwa6AM5CsSnxVzPD4B9jsp6ckJsVDFg8I3HQCXj6lroq4+P5FfD6XYc6lJFXoZ
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:4304:2e3e:d2f5:48c8])
 (user=mizhang job=sendgmr) by 2002:a17:902:e88f:b029:12c:c949:36dd with SMTP
 id w15-20020a170902e88fb029012cc94936ddmr1292433plg.84.1627965987962; Mon, 02
 Aug 2021 21:46:27 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  2 Aug 2021 21:46:05 -0700
In-Reply-To: <20210803044607.599629-1-mizhang@google.com>
Message-Id: <20210803044607.599629-2-mizhang@google.com>
Mime-Version: 1.0
References: <20210803044607.599629-1-mizhang@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v4 1/3] KVM: x86/mmu: Remove redundant spte present check in mmu_set_spte
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
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

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8cdfd8d45c4..f614e9df3c3b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2734,17 +2734,13 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	trace_kvm_mmu_set_spte(level, gfn, sptep);
-	if (!was_rmapped && is_large_pte(*sptep))
-		++vcpu->kvm->stat.lpages;
 
-	if (is_shadow_present_pte(*sptep)) {
-		if (!was_rmapped) {
-			rmap_count = rmap_add(vcpu, sptep, gfn);
-			if (rmap_count > vcpu->kvm->stat.max_mmu_rmap_size)
-				vcpu->kvm->stat.max_mmu_rmap_size = rmap_count;
-			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-				rmap_recycle(vcpu, sptep, gfn);
-		}
+	if (!was_rmapped) {
+		if (is_large_pte(*sptep))
+			++vcpu->kvm->stat.lpages;
+		rmap_count = rmap_add(vcpu, sptep, gfn);
+		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
+			rmap_recycle(vcpu, sptep, gfn);
 	}
 
 	return ret;
-- 
2.32.0.554.ge1b32706d8-goog

