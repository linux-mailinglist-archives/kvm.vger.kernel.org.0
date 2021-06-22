Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385CC3B0C44
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhFVSFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbhFVSEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:04:41 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F70C061146
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:26 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id z4-20020ac87f840000b02902488809b6d6so81689qtj.9
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SUdiAi8V1y7Z3MBnbTcTkMuuwqyidzgCcsX7sikEJEQ=;
        b=J1cfKg6xHabJrWb5g4kR0m+FmJsMCgYM/sH2Vkm0Hume9zJNWLXNMMNex29SDqNSup
         Ck1Hb7C8NT3hu22sk6V03qdNP9N5XUDZIYzxxu3ocjy1KkQ3O1kkKu9jIvzBXl9E0uvo
         jadWdl8W6QX0BsoeyZOEc7zCLQPfSfd6sxlzz77qU11Tu0EEAn/qkdTi/Kj42hwsf93b
         J71Cwi6DSSfGK/P91N8SQzHa5bC48CS5vj/EgdvVOdFoHvWoCpJY5ZvNU7a9PGx7UMpA
         Byuacb32QnUz0MuQpSzvfkRn5Pm/v/0Bj6onuXBv4kxUxsdZDfx/jXiZNo4UWQ8mTvtC
         Up4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SUdiAi8V1y7Z3MBnbTcTkMuuwqyidzgCcsX7sikEJEQ=;
        b=MV3bF+n5qQLRpfk21udq294TINQvxve9Te/NzWzXt/cLDkwBCC1tak+TVkVhpH3hR7
         kUfh05f117V8jYbv5x0g8SBnHNsqWUJjk4AZDVM3WMy9puftnliDi4GDedBgqvAgOIdG
         p6S9PYcUoQLyIZbF0h+xnQzPwFRMldvwvnYsjqjBgYJ+QAdd0fFyRtqxEsQBRLfFV/mo
         uo65UTWC5AKP2Py8EOGRmUhiVaMMvnVracFr9ES1BjVyQY9+knb/lEq7/UDngV2RjVxZ
         dEBxQbIkoGP0o6smLtP+kwJJUN21IkzcNLQB7bsIgP58DVRkF9ZzLK9lyzoktKdMnpGc
         qCLA==
X-Gm-Message-State: AOAM531eZ/keUVnlWQzXbAQfreqf6RjSpkkzZ2hKmWqOsJYYJHn4z4LM
        Xs1K89do4ARxMwIxkTJAhGi3pNqCmEI=
X-Google-Smtp-Source: ABdhPJxhmqfC37t7ov4Yduhj/jsrJVlsWvs45r1W3NgB4VVTQrxoRM5IXJVU557xrk4EB9ew9XNMQiZcYEY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:c9c7:: with SMTP id z190mr6597910ybf.21.1624384765584;
 Tue, 22 Jun 2021 10:59:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:24 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-40-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 39/54] KVM: x86/mmu: Get nested MMU's root level from the
 MMU's role
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

Initialize the MMU's (guest) root_level using its mmu_role instead of
redoing the calculations.  The role_regs used to calculate the mmu_role
are initialized from the vCPU, i.e. this should be a complete nop.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6c4655c356b7..6418b50d33ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4874,6 +4874,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	g_context->get_guest_pgd     = get_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
+	g_context->root_level        = new_role.base.level;
 
 	/*
 	 * L2 page tables are never shadowed, so there is no need to sync
@@ -4890,19 +4891,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	 * the gva_to_gpa functions between mmu and nested_mmu are swapped.
 	 */
 	if (!is_paging(vcpu)) {
-		g_context->root_level = 0;
 		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
 	} else if (is_long_mode(vcpu)) {
-		g_context->root_level = is_la57_mode(vcpu) ?
-					PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
 		reset_rsvds_bits_mask(vcpu, g_context);
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else if (is_pae(vcpu)) {
-		g_context->root_level = PT32E_ROOT_LEVEL;
 		reset_rsvds_bits_mask(vcpu, g_context);
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else {
-		g_context->root_level = PT32_ROOT_LEVEL;
 		reset_rsvds_bits_mask(vcpu, g_context);
 		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
 	}
-- 
2.32.0.288.g62a8d224e6-goog

