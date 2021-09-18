Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6A2410277
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243403AbhIRA60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243504AbhIRA6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:58:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFBCC061767;
        Fri, 17 Sep 2021 17:56:59 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso11172890pjh.5;
        Fri, 17 Sep 2021 17:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=quHOswZUn9JS3Yqwc0+Ss/CHRYeQKc2vTPvyghLjoZc=;
        b=mIifOA/aDUsdWBqZIhh3GVFXZ8EgOY28JNr3v6HS+G4domnOAt7ntJgaxkNHleA+9n
         pKboh3slCA5eYW0xxqXaLesMwMbCKy/2pUdKb6gHIBGII4QoqFW8k1OEvrvyIFwwBdM/
         u0BFL8NeODpAQFbWwO+l4XTuJYF2MySyG8PeVr2wo2gz/hKBJOn2YqcpMwj85vTJdhTZ
         2YC9HUFgJapgw6oMyqGsBZQQecUZgyaVfNXa2++FWsZWlnL7XmGmbLz7WDXt9lhsIqzA
         v8Z/l5gepNiGDNQeCPeiJ5u0IuQ1hqq99AhQxRMIP224FaXmWCQfkAen8YzJtRatISzF
         CvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=quHOswZUn9JS3Yqwc0+Ss/CHRYeQKc2vTPvyghLjoZc=;
        b=guEmOYJ7mKYSAWlgYSd63hz3xmVxrPDf/V94horGuZWD/DcqFucg8lsw6hzslrU+rE
         KDrLCi58DHvKl1nbX27o29ruop6uFjzNrrKurDsxUSJvnumYEfFXJF75BNE1dYrGTQ4o
         BoYXhMJ2O4Y3s96SAnXjGdOHHgSc9Hp0Xx0TkhrKFnaX0XUPaQIxd3zKkHhY+/iRiB3x
         LKgIxoC5l3lpgch/54S13scwy7CLStgMUapu6H8kKLoWlYLUO3qssC/MuBWOrcxnRQ4N
         xiDjKZ7PWzvypPoFXJ21F9689xC/H0KH09pj3+CzVo9SotMaERerA+dznMiQIcz80IKv
         XFkQ==
X-Gm-Message-State: AOAM532kXQhSOV+IJ/qCdWnJhPKtahsseQDO0Kg+gxxmVaCNGMbp9T7K
        T3pKugfw2kG5woSCgf3yaO3ySEEJ8Ic=
X-Google-Smtp-Source: ABdhPJweGdV429tcqqRLltDNMNkWZg3vWAvMQ50/+7YzhshbVleTcZiszdeuLodnXx//KFRRcKHpeA==
X-Received: by 2002:a17:903:24e:b0:13c:49b6:ee98 with SMTP id j14-20020a170903024e00b0013c49b6ee98mr12169444plh.51.1631926619387;
        Fri, 17 Sep 2021 17:56:59 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id d4sm6965982pfv.21.2021.09.17.17.56.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:56:59 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2 04/10] KVM: X86: Don't flush current tlb on shadow page modification
Date:   Sat, 18 Sep 2021 08:56:30 +0800
Message-Id: <20210918005636.3675-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

After any shadow page modification, flushing tlb only on current VCPU
is weird due to other VCPU's tlb might still be stale.

In other words, if there is any mandatory tlb-flushing after shadow page
modification, SET_SPTE_NEED_REMOTE_TLB_FLUSH or remote_flush should be
set and the tlbs of all VCPUs should be flushed.  There is not point to
only flush current tlb except when the request is from vCPU's or pCPU's
activities.

If there was any bug that mandatory tlb-flushing is required and
SET_SPTE_NEED_REMOTE_TLB_FLUSH/remote_flush is failed to set, this patch
would expose the bug in a more destructive way.  The related code paths
are checked and no missing SET_SPTE_NEED_REMOTE_TLB_FLUSH is found yet.

Currently, there is no optional tlb-flushing after sync page related code
is changed to flush tlb timely.  So we can just remove these local flushing
code.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c     | 5 -----
 arch/x86/kvm/mmu/tdp_mmu.c | 1 -
 2 files changed, 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c1b069a7bcf..f40087ee2704 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1934,9 +1934,6 @@ static void kvm_mmu_flush_or_zap(struct kvm_vcpu *vcpu,
 {
 	if (kvm_mmu_remote_flush_or_zap(vcpu->kvm, invalid_list, remote_flush))
 		return;
-
-	if (local_flush)
-		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 #ifdef CONFIG_KVM_MMU_AUDIT
@@ -2144,7 +2141,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 				break;
 
 			WARN_ON(!list_empty(&invalid_list));
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}
 
 		__clear_sp_write_flooding_count(sp);
@@ -2751,7 +2747,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (set_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
 		if (write_fault)
 			ret = RET_PF_EMULATE;
-		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 	}
 
 	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH || flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 548393c2bfe9..d5339fee6f2d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -958,7 +958,6 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (make_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
 		if (fault->write)
 			ret = RET_PF_EMULATE;
-		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-- 
2.19.1.6.gb485710b

