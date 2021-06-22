Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A193B0C26
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhFVSDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbhFVSCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:02:21 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC38C06115D
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:57 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id cj11-20020a056214056bb029026a99960c7aso13381148qvb.22
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qAcUYJ4rE26wRwaKw91Gj9RXBCVMndz9HvCWXXEKSPo=;
        b=b3fhx18283K9MrGgUv2p+x9vmN1eeEC2DosmQpwSkN7MMhwHqCVITVymBqSdok21IU
         k63f4Hewz0OStALS9LOygpQG5GszV/EIm7TdtQdvXnnQXtmfSMzlJTG2VygNS5r7wcG4
         Uab9zWTysmrg740A33vzoHWOQSfl4YsZ/YOPP4PWDpNBV9GyGFWFZXg7WIka4TYCH5kq
         VMM94LXLZeE9WImPqiFtF7AYR4dlkH2noqBkjEcyX5+4T38MkqXylKcpaVpr6zju23o+
         SUBf6Qd+YrxQzwad0UnFR0MDzpxrYiUiu/fuDscKQMm9cN74980J+CO43SuLj69tSNxA
         3hjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qAcUYJ4rE26wRwaKw91Gj9RXBCVMndz9HvCWXXEKSPo=;
        b=m6cEkZ3yMAUitm0gIxrEZpsTjhrvrQRfAhzbRUuV1zVNW0BcFcb/uUGJTJQPXj7GgC
         vnDcvrmbGlIA+Wz6/pewB2b7SafYZ5hevpw05IqHOUJq1oJbD1tG9/OkOGwXQE1jRwVe
         xZns8KuMsXogeV2DJsnEJgUQ0Okris3lSAXD4zoJPXZ+hxUukt4y87b4OZ/tEmt8z/OH
         tGwu0shCJwznDEuHNpnJLf4BYJX1RunkIQ0q8nhga113AyE5eD4w1HAKmVQZw7c3s+Uo
         IxQwQJqqknBkaZmvYDK3Z/ihN1C54UZJIn28qfnpb+YxIatEIiXzled4WPF5rLmPxjEE
         W5Gg==
X-Gm-Message-State: AOAM533TuCrnsX0c4Y8xcy1baJ5RlsOZEDNnW8pKcZ3ZSpCd3YcQC0mD
        TPGDOGY7rHXZtBzeaOSq7CBz/U1/QfY=
X-Google-Smtp-Source: ABdhPJyuyA1zqsVUtxZb9k71pRg2M4/qRtFktf7xtlsblvbmAp7JLRlfHWCd6hsYvpmfV+y9QBdR6xxXFbY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:cc8b:: with SMTP id l133mr6594068ybf.518.1624384736176;
 Tue, 22 Jun 2021 10:58:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:11 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-27-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 26/54] KVM: x86/mmu: Do not set paging-related bits in MMU
 role if CR0.PG=0
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't set CR0/CR4/EFER bits in the MMU role if paging is disabled, paging
modifiers are irrelevant if there is no paging in the first place.
Somewhat arbitrarily clear gpte_is_8_bytes for shadow paging if paging is
disabled in the guest.  Again, there are no guest PTEs to process, so the
size is meaningless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index be95595b30c7..0eb77a45f1ff 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4568,13 +4568,15 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 {
 	union kvm_mmu_extended_role ext = {0};
 
-	ext.cr0_pg = ____is_cr0_pg(regs);
-	ext.cr4_pae = ____is_cr4_pae(regs);
-	ext.cr4_smep = ____is_cr4_smep(regs);
-	ext.cr4_smap = ____is_cr4_smap(regs);
-	ext.cr4_pse = ____is_cr4_pse(regs);
-	ext.cr4_pke = ____is_cr4_pke(regs);
-	ext.cr4_la57 = ____is_cr4_la57(regs);
+	if (____is_cr0_pg(regs)) {
+		ext.cr0_pg = 1;
+		ext.cr4_pae = ____is_cr4_pae(regs);
+		ext.cr4_smep = ____is_cr4_smep(regs);
+		ext.cr4_smap = ____is_cr4_smap(regs);
+		ext.cr4_pse = ____is_cr4_pse(regs);
+		ext.cr4_pke = ____is_cr4_pke(regs);
+		ext.cr4_la57 = ____is_cr4_la57(regs);
+	}
 
 	ext.valid = 1;
 
@@ -4588,8 +4590,10 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 	union kvm_mmu_role role = {0};
 
 	role.base.access = ACC_ALL;
-	role.base.efer_nx = ____is_efer_nx(regs);
-	role.base.cr0_wp = ____is_cr0_wp(regs);
+	if (____is_cr0_pg(regs)) {
+		role.base.efer_nx = ____is_efer_nx(regs);
+		role.base.cr0_wp = ____is_cr0_wp(regs);
+	}
 	role.base.smm = is_smm(vcpu);
 	role.base.guest_mode = is_guest_mode(vcpu);
 
@@ -4680,7 +4684,7 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
 
 	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
 	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
-	role.base.gpte_is_8_bytes = ____is_cr4_pae(regs);
+	role.base.gpte_is_8_bytes = ____is_cr0_pg(regs) && ____is_cr4_pae(regs);
 
 	return role;
 }
-- 
2.32.0.288.g62a8d224e6-goog

