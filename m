Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FDD45C497
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354119AbhKXNtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354127AbhKXNsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:48:50 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3C5C0698FE;
        Wed, 24 Nov 2021 04:22:08 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso2506963pjo.3;
        Wed, 24 Nov 2021 04:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ipgekMz1dQYxmFsnp10QERJe8oTU3RcrTtPUiJD8omE=;
        b=UngOg6uYgkJ7NZYcYZpAzFTHxAaYuEUUwRKq4T3LC8TY8DEVyha30lsp2U+1reag2l
         IJL9WsBg9Xw64vX5vt1MRg7ddptjkQMv+DK/3IBTK7cjFIV0NbMF8e46CpsvK+EtHwci
         eBv2MkvWdTuhHSakICYcT4JcQaTkDMyXAN8NPaaobCsdwvWCjMv0gX+Y/ACk1gipPPm9
         Hj0keMMaOP9cPyCb30b8hyV5QtyP8k9HQVUp7IZS8s+kQjnQlQPbrIbr+8AoMmHxdEWW
         YYx6+eHxpFPz5mY6D7zsnI8UVV/VumFBbri5uOZBcfvGNhH6OE2rqfz5BKDMNgxA3zL3
         C69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ipgekMz1dQYxmFsnp10QERJe8oTU3RcrTtPUiJD8omE=;
        b=Rl3Q9H7plPynQHS4nj/X9gZWk2bLCaVFYuA2ASPaiUXUBI8GoccWovHcdpJv8bbsTF
         lV7aUH+jREB0EkgSmLohPr0uecOlKsZrWUB2naUHDDYqcTIpOYxvJMjW5WPXxxFiCn97
         uXLgpyMbIGxHCXo/wN1CeFLIMNGHH2rRxQ8mlUkv0lUW+1RjeKtqR2smNalPmR/zKdUa
         euIl1dCv2Ty2+6Sn8KZfdx9fY+DNKrMJEvqseQjys4Qapx/jZf+0yEURpAgBNBReNVFP
         tll95SUkefq1eRwpG8aog8KZw7IhybK4V24/lRQg1mX4IGJNqLzDr/k57bLVdvmseT8/
         kRgw==
X-Gm-Message-State: AOAM531lxoP+N6yxLdJYW2t1GetQG2fHU3eoJKdMtgC22xtFRL6J9y7N
        K70HVW3rTfeqxtd9DoNp0sX7Vx1nXeA=
X-Google-Smtp-Source: ABdhPJzMNQQGJlZPjoa6d5VTTJH5BC84NpuwHjSfJHej66TPu/R3R4JsayFZDCqWOs5PeOPxbfo+TA==
X-Received: by 2002:a17:90b:1d0f:: with SMTP id on15mr8243263pjb.144.1637756527768;
        Wed, 24 Nov 2021 04:22:07 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id o2sm17110436pfu.206.2021.11.24.04.22.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:22:07 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 11/12] KVM: X86: Check root_level only in fast_pgd_switch()
Date:   Wed, 24 Nov 2021 20:20:53 +0800
Message-Id: <20211124122055.64424-12-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

If root_level >= 4, shadow_root_level must be >= 4 too.
Checking only root_level can reduce a check.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9fb9927264d8..1dc8bfd12ecd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4136,8 +4136,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
 	 * later if necessary.
 	 */
-	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
-	    mmu->root_level >= PT64_ROOT_4LEVEL)
+	if (mmu->root_level >= PT64_ROOT_4LEVEL)
 		return cached_root_available(vcpu, new_pgd, new_role);
 
 	return false;
-- 
2.19.1.6.gb485710b

