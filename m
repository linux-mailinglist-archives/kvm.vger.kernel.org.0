Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3324A7D1D
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348647AbiBCBBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241392AbiBCBBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:02 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7441C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:02 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id h11-20020a170902eecb00b0014cc91d4bc4so274836plb.16
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bGFCrw73QNhf8q3al57zaK6xaZK1SHXoQE5u16lUVeY=;
        b=ooceTLI2YahhNYRyruUQirthjAMCPz1D7/s5nigLxsc2TDYJFv5YjG0bjRNjdkZ6de
         sbcEiso+Sa6kkNFHnic4y8S4qNCuf8Lem32wOmypQwZmZTcOuZZcTC28Bm9BKgvzdczR
         F8Is035jijRZi1TT6qzmZNIZvM8i88vmo7enqJu+dLdaGzNls0vY8u8hffPtrMJ4OAGa
         Mp687JHDmFKsBb5BveJYvioVwo9NfJ6DEVCIlGGrFZOnPL+RwVFPHcDQUNXrTCLBsuIg
         M1h7YEOYI3EqQ6s8fPjzyUhpek6uFYAkOdPT82DjScyOtGvjfATl5YORtog/UyIpMq6m
         vjaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bGFCrw73QNhf8q3al57zaK6xaZK1SHXoQE5u16lUVeY=;
        b=FF9xOzDMRkTtY7VHORSTSM8ANpsneKNJe3qCahIVG6RmDyfGbC/X0w2CDYnBvdsdZO
         p/h+wLr3yoDkwJdaPMn3QFpu+hmFn0wo1Z/A8uV0l9C2xinKCGRUJLyUKIhomMHjSXde
         ZV9xKkXwq/A7JZr7plmDdS1TkhSqazezEWbiG6gmEaU6PU3PQ3kZ/F9FkdCySM3FL3ns
         6RTWUA/8DxANOk8buZcU600p3RHlclYhOA5GZctZBnjDnNZWasc29KpPRHbDzo0BFn3d
         gGvzRhEDdi6XiMlOOl0OzoxozuvlBMTxLj+BBLfSr97CrhEFok5KJZmhz+BbVGswvi4B
         rf/A==
X-Gm-Message-State: AOAM533/ZnxSYORf6y3HDL3KJ7z2qEWKMnAmxBBHKT0FyLcBZXvKnBRq
        6R3JJPwMtCRSGO6FkUehhGQHaqAS7DCunA==
X-Google-Smtp-Source: ABdhPJww6OZq+QWEavKLmOGrJ7r+vgeszLp3RkgqsuOc5dX81fXxEH6QtgXeqExqzMbHcGAEoJM4B++UL4E+ww==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:8205:: with SMTP id
 x5mr22694118pln.29.1643850062201; Wed, 02 Feb 2022 17:01:02 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:29 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 01/23] KVM: x86/mmu: Optimize MMU page cache lookup for all
 direct SPs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
fully direct MMUs") skipped the unsync checks and write flood clearing
for full direct MMUs. We can extend this further and skip the checks for
all direct shadow pages. Direct shadow pages are never marked unsynced
or have a non-zero write-flooding count.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 296f8723f9ae..6ca38277f2ab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2052,7 +2052,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     int direct,
 					     unsigned int access)
 {
-	bool direct_mmu = vcpu->arch.mmu->direct_map;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2093,7 +2092,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
-		if (direct_mmu)
+		/* unsync and write-flooding only apply to indirect SPs. */
+		if (sp->role.direct)
 			goto trace_get_page;
 
 		if (sp->unsync) {
-- 
2.35.0.rc2.247.g8bbb082509-goog

