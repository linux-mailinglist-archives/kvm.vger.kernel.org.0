Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AB23F6892
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 19:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbhHXSAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 14:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239998AbhHXSAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 14:00:06 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F22C081B04;
        Tue, 24 Aug 2021 10:41:03 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g184so1939718pgc.6;
        Tue, 24 Aug 2021 10:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oxK1ob4roXyy3ZVWd2lGw+F2XcCDp2ZaJLGKfR9pxws=;
        b=HDvxvaUjpfMgRDj4dWlcYeWDABASwvKL7ZvT5EKy/RWIvIE2tKdrxYWNwGQe+aJ1fX
         ZQE2EzzdyHwGFost5ha1A+TvvrDUBEaOmqscAW/L8v5p23jARGujtGcW64CFKAMPKmRk
         REKKKVTLutfhajHfWie5Op8XGv9BZCopIr3ZWN52FXP0qqP8AfueLuDixoL7B7Wa6tov
         V4T+wAOoS5d5d/Gcg9FjuLpJ9XDp/pTyFO2btXZHvRqPhuuwE+k46bGQ8UmsycCgDr5y
         Car34QB2PEtQpSOAnoO74l6foIYuGPjtTZQvWyI8Tp5EUbUrBYC+13EZHgGOuAJY9+JW
         lXJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oxK1ob4roXyy3ZVWd2lGw+F2XcCDp2ZaJLGKfR9pxws=;
        b=CqEDdvtuJlWMoSLYa4gPMkyX/L7yt3U1z1hKU+uYucJnmpK5+mD0Bvmhy9dkf8mW/6
         6sKLEOdibsXXqZ1fqLz5SHBV4RoO6RItKGhY/8aFMNgONBAM1KTVu75DscFiQmJ225K8
         xh7LxhxaYYcyoVqamaAbPvhGCCmCy4ksIgkcdWOVeTx8W4M08S8I+EDpiDCpHZ1gHYGM
         1wUL/jgQj1oZqDZnBdYShD466A5GNWBaCCuvKf1/o1qiypbM2/3hasmzHPnNnAEuBdor
         5LKh0JHQmzyFi0CSaoPeeZSlgn6GZkP9JlaT/N8Mp3TXhefbFYUiVJ4kzrUhw8JtrL8f
         CErA==
X-Gm-Message-State: AOAM530R3I9SeScAHXb5FYGWLceLltiFZEPlH91xm8EESf188Qxvs7d6
        jzcOuVzfokjOnj/TWAhDJsCVMFPjGQU=
X-Google-Smtp-Source: ABdhPJwqCL9QBsjJIO99s99jw+KW1jy+uuibJU69apR7Algqobe5j4qu9COofBgzBmfvZzojKBk1Wg==
X-Received: by 2002:a63:8748:: with SMTP id i69mr15760614pge.92.1629826863346;
        Tue, 24 Aug 2021 10:41:03 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id h127sm3005172pfe.191.2021.08.24.10.41.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 10:41:03 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH 6/7] KVM: X86: Don't check unsync if the original spte is writible
Date:   Tue, 24 Aug 2021 15:55:22 +0800
Message-Id: <20210824075524.3354-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210824075524.3354-1-jiangshanlai@gmail.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

If the original spte is writable, the target gfn should not be the
gfn of synchronized shadowpage and can continue to be writable.

When !can_unsync, speculative must be false.  So when the check of
"!can_unsync" is removed, we need to move the label of "out" up.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/spte.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b68a580f3510..a33c581aabd6 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -150,7 +150,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
-		if (!can_unsync && is_writable_pte(old_spte))
+		if (is_writable_pte(old_spte))
 			goto out;
 
 		/*
@@ -171,10 +171,10 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 	if (pte_access & ACC_WRITE_MASK)
 		spte |= spte_shadow_dirty_mask(spte);
 
+out:
 	if (speculative)
 		spte = mark_spte_for_access_track(spte);
 
-out:
 	WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
-- 
2.19.1.6.gb485710b

