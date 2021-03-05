Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0293332DEDD
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhCEBLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhCEBLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:23 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51054C06175F
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:23 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id b18so277046qtt.6
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bwWmsfKbRJfV8/+Fm2c/LUlXd7iO+HWaAYiyWCQXxfU=;
        b=U7lGCiWjmHB0z1Bdaswlr989f90JI/0sCy4z5iS62dl19Q02XbnDo6l7vIbmx0GgCm
         v9hpEGJiqp+tZPo5dBGeXXje6uFoG4AXj4zM+caKcWaJbk7ELoPxzC39GLyhH9zFD/xg
         KjZAjp85Z2M1WwtVPeYnXo+0z2eyhVHPiy+LxxGsPEdQTRqDZjPqeIOnbMV8Dvx2CkAj
         Pxts+2zz962epVbW6hKDxscpI3k5fjKeC+4ivEbiRuvjtl1BydfPwzqigkGstRbxO6xW
         un/CeNjvVml/GgGNKCnv+nZZK7im8DYMN6iZONLrwOqweUinlrPhfNhWNTsTDNu2co/3
         vNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bwWmsfKbRJfV8/+Fm2c/LUlXd7iO+HWaAYiyWCQXxfU=;
        b=Sm3ey6IHlertWEZ0nfRlMTFGgv6iKUYP/PboBdo9YxrKomrwHW2yNhhOSaJC/TYdQI
         N+ecWdux5J3JZMoLtd11SasFRN1KA3MBPQ8SZ9c9wiPlOfuPpLYKQiWv0vQ5Ck+2538F
         FAw7lYc2DZR7X98bJ3Wi0rmlAh3bjN9b/0zDO/x07sdBj0EhTWY0SxzTEP/aP7ebjIhO
         Xpe//fjaLlTc886QfiSxlh4gYaAD/3eX36GpYI4fh+WApUhA81VN+L+PKsiz7s4ns0bT
         HTr6bP4WPaTSAW8GG16Cb204H4wAG+V3Av+PFbDByM382srFbE8giH0r6WN9lpRKLq6H
         bGGw==
X-Gm-Message-State: AOAM530N4kMPA9lGusv4ljEzZWoS84DBGQvyK55T/fL1vTjxs/fborJv
        hfrRXI0bh98R6K5xTKcavH5N7RQh6BM=
X-Google-Smtp-Source: ABdhPJyKhBQdbiAnarpfnqG9GFRqou15P8VO9icFY/IzrVPYTSCUm2afkPKq9taANSKp2bAeEy6Mr4Kbpn8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a0c:b4a8:: with SMTP id c40mr6983168qve.60.1614906682447;
 Thu, 04 Mar 2021 17:11:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:51 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 07/17] KVM: x86/mmu: Check PDPTRs before allocating PAE roots
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check the validity of the PDPTRs before allocating any of the PAE roots,
otherwise a bad PDPTR will cause KVM to leak any previously allocated
roots.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7ebfbc77b050..9fc2b46f8541 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3269,7 +3269,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 pdptr, pm_mask;
+	u64 pdptrs[4], pm_mask;
 	gfn_t root_gfn, root_pgd;
 	hpa_t root;
 	int i;
@@ -3280,6 +3280,17 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (mmu_check_root(vcpu, root_gfn))
 		return 1;
 
+	if (mmu->root_level == PT32E_ROOT_LEVEL) {
+		for (i = 0; i < 4; ++i) {
+			pdptrs[i] = mmu->get_pdptr(vcpu, i);
+			if (!(pdptrs[i] & PT_PRESENT_MASK))
+				continue;
+
+			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
+				return 1;
+		}
+	}
+
 	/*
 	 * Do we shadow a long mode page table? If so we need to
 	 * write-protect the guests page table root.
@@ -3309,14 +3320,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		MMU_WARN_ON(VALID_PAGE(mmu->pae_root[i]));
 
 		if (mmu->root_level == PT32E_ROOT_LEVEL) {
-			pdptr = mmu->get_pdptr(vcpu, i);
-			if (!(pdptr & PT_PRESENT_MASK)) {
+			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
 				mmu->pae_root[i] = 0;
 				continue;
 			}
-			root_gfn = pdptr >> PAGE_SHIFT;
-			if (mmu_check_root(vcpu, root_gfn))
-				return 1;
+			root_gfn = pdptrs[i] >> PAGE_SHIFT;
 		}
 
 		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
-- 
2.30.1.766.gb4fecdf3b7-goog

