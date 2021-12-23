Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555B147E94E
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350455AbhLWWX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350421AbhLWWXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:23:53 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833A6C061763
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:50 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id x15-20020a63b20f000000b0033ff865bb09so3888484pge.2
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fpIDrpWZwmj6BNONuDX3BQPSQp/TrPoIB2oyQBfGSwo=;
        b=GRcaaHwNTlE7NbCGNV/wpojHO94gvVAt5hXaCqZRlKal8bVZDb3AR7GVeWbPVCBIp3
         JylcRrzpPNy4j7rzIblndCS2J2VE68MPO0n1sfCMr0Snbg06HoeuO8+GnBfNtMljOxvQ
         rjLPLHtz/rbxAA/maMsbXxnkiXxNQ/1D2UPVOJowJrFNEVjrLljnelDNEvtmMqcKH9h/
         iDERCmRJOGePmwwt6T+JwDLSqX8CFOqZ2n6mILxbTJ2mao/zYUoKYGTo/nZYbgQTbRgX
         6w9HzzMk/m/xRaxtf+jplH3oB6AfmUi6TgqUVA9fcdhQHIsvOZIyUFBPw5j6mk4OppQV
         +baQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fpIDrpWZwmj6BNONuDX3BQPSQp/TrPoIB2oyQBfGSwo=;
        b=EMqNoUQNmWxCztyyzXYx1qtDIR6fQHm/AAZv/IwUxCyj25fd/1ngSv+b9bjyESPIA/
         /AwXbPk1vn2bKgR/CWQaXmcnBzpmKayjoDgYxSGaM00v2jDVJtmU2Z6ow/5s0cbCihr8
         s1UzU2MePgAGTK9qK+19GRO2NcAmtt1ML/N2QbJxGg79k7naqsSG5JH0SPt4ctkeL6Jx
         RarESL0IJrmChgpgyn4u4oui9MFOXppS1f4cerSYXRgiVVNPO6yXRqgXz4RI2OLdDyWJ
         AB0rTH4OF7SXmdXwDQK5BOMSsA4KmZnK+6pP27rNY8JV22oY7DfzUWzLLlZZJMQwZnvF
         cBtA==
X-Gm-Message-State: AOAM5321h4RPi2eTbFbAN17npSPuxg8NVuNxIUs1B/k4nz7dXeU+7Yrz
        IMuvyORhQbR22nsEC4tAEfSF87IJI30=
X-Google-Smtp-Source: ABdhPJyclXLRTwW6GJeCEWsyo4Kj1bo3ZQ/06TQEYE++AKaw4dOta3j54//LgcIFPrdnUSZzHL2DS03/7L0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7797:b0:143:88c3:7ff1 with SMTP id
 o23-20020a170902779700b0014388c37ff1mr3972429pll.22.1640298230048; Thu, 23
 Dec 2021 14:23:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:22:53 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-6-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 05/30] KVM: x86/mmu: Check for present SPTE when clearing
 dirty bit in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly check for present SPTEs when clearing dirty bits in the TDP
MMU.  This isn't strictly required for correctness, as setting the dirty
bit in a defunct SPTE will not change the SPTE from !PRESENT to PRESENT.
However, the guarded MMU_WARN_ON() in spte_ad_need_write_protect() would
complain if anyone actually turned on KVM's MMU debugging.

Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 41e975841ea6..fcbae282af6f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1239,6 +1239,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
 		if (spte_ad_need_write_protect(iter.old_spte)) {
 			if (is_writable_pte(iter.old_spte))
 				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
-- 
2.34.1.448.ga2b2bfdf31-goog

