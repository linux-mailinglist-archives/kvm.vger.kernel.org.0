Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11A3D6611
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhGZRNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 13:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbhGZRNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 13:13:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEE7C061765
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 10:54:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a6-20020a25ae060000b0290551bbd99700so15027153ybj.6
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 10:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=btPFck1XzpE3aBH1Nm3kzDvWZMQLegGwPNOaeKtJDeI=;
        b=Uw2Y7dstn1klTtFavjKJYv6imv/nRJZdjGus8S7vEDypmeFKTEeiTiAPic5mjTvmN1
         SmFPjksQQazwFhsaqlxv9rSFVtbtkGRmdSPSI3iwLrtUahPoCVWTAZj73EDjzLbLFAdQ
         AIrh+YYmw7qYqA59UIL2dy0K5Gfk10WTJiXEe2RSPZgYZAalpxsTnCrG+xu/Wa3055QL
         UdRKL4B7EG/FY7iKu6xGvo/UGhmNLgrxgfR8P16tABrGA6zgEsawICui24GeBiHI0u9D
         YVjIS+7JOy/MX9Jymr2azwpOE2vUjy7RuOKBL94dNVcD2VUFU4lXki6FOyasHwnuXMAu
         i96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=btPFck1XzpE3aBH1Nm3kzDvWZMQLegGwPNOaeKtJDeI=;
        b=Bj18LqF8zYYHpe8Y/yPtbcOvD2XIc69RCyIkQimiGcVqy5Kh2sHOxz+0m0cD3zGQbd
         ZRvGhlPtKRRM4hxbFjV3cna3fThYZWygY+atoHuKj85cxqUqAV7q0w3FDNzYfMDC3B46
         U2D42MnKMkUzCUL3u3J7bXfKTvp/cx1MVUlExMeu1ztqI1RT3e/TbxTC/1bzI/kwytbd
         0dfgPUvyiDmUdpzqNKt/RWmmrWfnBKB8oHzwpEKclBRmFS/nky/UI6siJQhGTRMK/qea
         lBmTJZ4lG6oPsCqJ766SKJ8W3TF0mIN18iPNvq4bjZKDgcj+038gdikL/4WAAjo/wmjM
         uqLg==
X-Gm-Message-State: AOAM531Mv6CkA4qE2IlWIj7HQ2Zsv0Goc8ZzytjMm7mYgy9UN1f4D5cR
        I1hsaJoQPmJLarEl14f97vL/U4fOOwZu
X-Google-Smtp-Source: ABdhPJxbWjqm+qvuS5zbnPd0y4Yutx6fHaBzxcJFAe0ph999LdcGRPHqHceXJ/pOUHzCB2QSmmaKGjh4nkGh
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:93c5:105:4dbc:13cf])
 (user=mizhang job=sendgmr) by 2002:a25:188b:: with SMTP id
 133mr24756922yby.80.1627322046468; Mon, 26 Jul 2021 10:54:06 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 26 Jul 2021 10:53:55 -0700
In-Reply-To: <20210726175357.1572951-1-mizhang@google.com>
Message-Id: <20210726175357.1572951-2-mizhang@google.com>
Mime-Version: 1.0
References: <20210726175357.1572951-1-mizhang@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 1/3] KVM: x86/mmu: Remove redundant spte present check in mmu_set_spte
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
 arch/x86/kvm/mmu/mmu.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b888385d1933..442cc554ebd6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2690,15 +2690,13 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	trace_kvm_mmu_set_spte(level, gfn, sptep);
-	if (!was_rmapped && is_large_pte(*sptep))
-		++vcpu->kvm->stat.lpages;
 
-	if (is_shadow_present_pte(*sptep)) {
-		if (!was_rmapped) {
-			rmap_count = rmap_add(vcpu, sptep, gfn);
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
2.32.0.432.gabb21c7263-goog

