Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A87325805
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhBYUwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbhBYUtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:49:46 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF214C0617A9
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:14 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id d8so7628062ybs.11
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GGYOzagFvlgTV2DLbo1famwEs6BMX66WYjRN/mJyFWY=;
        b=def5dczjvOSFaygZDthc8G/k41Q0O9ImhfMPy0gokapJeX4wWXG0CiMoWynAaidCAb
         z4w7OttBdvVv7x9NRq76IdfJnc83a7yn5iZkZ+Af38EZRfDdqCx+Hf+tTvQWG9hxMfOr
         4zG7XMjtqwqiTgP3trFnwX2nHFX1EsRBOEdfiRg2J+FV4cTAAgRtF/cCs401WQrLo/G+
         /g/jBeW4Xopfs1vYrMkGqCJ806IED62PRYqs6BXNiUc69/qGzyy6uRn6nAk+UpX+D6R/
         h8KlSD1uWNa5v0L6FjknDlHPAE2zzrUduOIAPUKO32qCWPfGRBILEUC/MUhKE0fHiXzK
         8NhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GGYOzagFvlgTV2DLbo1famwEs6BMX66WYjRN/mJyFWY=;
        b=iLG4XXCT/zStmrx11efOIEazdGwL/A1i7gfaKURsMxW/6vkcMLnQFQHqolADmZI0S0
         CRY9w0X9Cudo25WLFZAPoSjoz51ygsbelUdnq5TGEWcZSwi5cAR7O2ixE/iwrljvy5+t
         0yuMJdfMfzXMWH70PMcefB147XjQ0yN1yRn5H5HiWUAhojolRiqSTnHtqB7v4/PwKs/L
         SX0LgZ/c5QWK9CFsiTjPjujt5pDvNVc7UYp821qbkM71xmew0PrjfmJ8WbX0CwxriNfT
         PYmJDvZzeuZ317i2oC9tzGwhBtQZPnpVcjpSPmUfHMTG4OFE1U5xp6U14pvpPXgHs1qa
         27Jg==
X-Gm-Message-State: AOAM531E39Nr2mPlgqgxaPZx0L02OUv/6KqXEQSy223rmoFhRQwj4z3v
        dRYYQ+0s6L9QUUsTivq7hVT2WIsrrls=
X-Google-Smtp-Source: ABdhPJxsRGocUYYsgIXuSfNkZVwB2TL+p6dacMVjtRSo83IsWBrw/MSeItmOSD8NkeYW2maoZl6E/gQekc4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:cbcb:: with SMTP id b194mr6942867ybg.174.1614286094048;
 Thu, 25 Feb 2021 12:48:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:31 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 06/24] KVM: x86/mmu: Don't install bogus MMIO SPTEs if MMIO
 caching is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If MMIO caching is disabled, e.g. when using shadow paging on CPUs with
52 bits of PA space, go straight to MMIO emulation and don't install an
MMIO SPTE.  The SPTE will just generate a !PRESENT #PF, i.e. can't
actually accelerate future MMIO.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 12 +++++++++++-
 arch/x86/kvm/mmu/spte.c |  7 ++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9eb5ccb66e31..37c68abc54b8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2946,9 +2946,19 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 		return true;
 	}
 
-	if (unlikely(is_noslot_pfn(pfn)))
+	if (unlikely(is_noslot_pfn(pfn))) {
 		vcpu_cache_mmio_info(vcpu, gva, gfn,
 				     access & shadow_mmio_access_mask);
+		/*
+		 * If MMIO caching is disabled, emulate immediately without
+		 * touching the shadow page tables as attempting to install an
+		 * MMIO SPTE will just be an expensive nop.
+		 */
+		if (unlikely(!shadow_mmio_value)) {
+			*ret_val = RET_PF_EMULATE;
+			return true;
+		}
+	}
 
 	return false;
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 9ea097bcb491..dcba9c1cbe29 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -51,6 +51,8 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 mask = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
+	WARN_ON_ONCE(!shadow_mmio_value);
+
 	access &= shadow_mmio_access_mask;
 	mask |= shadow_mmio_value | access;
 	mask |= gpa | shadow_nonpresent_or_rsvd_mask;
@@ -258,7 +260,10 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
 				  SHADOW_NONPRESENT_OR_RSVD_MASK_LEN)))
 		mmio_value = 0;
 
-	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
+	if (mmio_value)
+		shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
+	else
+		shadow_mmio_value = 0;
 	shadow_mmio_access_mask = access_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
-- 
2.30.1.766.gb4fecdf3b7-goog

