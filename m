Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E918465E88D
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 11:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbjAEKDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 05:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjAEKC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 05:02:57 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A3013D16;
        Thu,  5 Jan 2023 02:02:00 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id j8-20020a17090a3e0800b00225fdd5007fso1541163pjc.2;
        Thu, 05 Jan 2023 02:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dIL5BQ5kiCN7aWb7s9J+mPjf4X7P7/oQ9fGAS1Y2L0E=;
        b=f5KnFQOrQ2JEr8F86AehTNd+ZROpDhAlBdTHW+sQYV6yM5KDjBEMCyvZ12qrjFD9CK
         hWZ7SJN5l4EG1gwNCGgMxUE3jBJwNHyb7wBjuiPJ9OWEi5v7qW9S/vqRI08wD7kB71IL
         adHmoDoeTFpkJUSpteSRZ/ctlaKAqqb5fnN5O81WvxGj/UBSH1c2OsyJnmegGrAnJ2It
         sNixLzo9UMmY7SvTZLaNPVvhflJ8zmTX0ZGIpX+8gNZ9kkQZ+zjxxBN9WbgvMFw6upf7
         CLs7RzP4YPEBeU1POophBkGzSWq5RB70+1BTpU05eCNxV4xHCXEPCauCt72Rjga+PYUH
         UiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dIL5BQ5kiCN7aWb7s9J+mPjf4X7P7/oQ9fGAS1Y2L0E=;
        b=AcchJOY78jjYuaDAlK2VvMn9YQAR6E+qISskHq6U1gClrtj1EW0NZME9TmalQ7GW3b
         Gqg+yDMvy50z1fLdJmJUGI1OMJr+M621xiayhJmtxWEczIvxHwAeIseEKFTnqE/awdgb
         dHYEkgThjeePyUVvf3dstwJM0QRopFzAFK5d4OOygCjs799wieyd7IIEDFxXvsDynFbR
         A6qqOaf7htHl3Woq0cSA0sy/RB31QNIdr7CAc1rTSNhx+vK6YK98VIUVmDjh54+XMzZn
         gMEruRNdHdOw0WBpTUcfnoCULmqJjz8op+HuB68NFYF+Fq+z7d08YSFTStT/F7FpSKtD
         Z5pw==
X-Gm-Message-State: AFqh2kp8G+dZBCitjdnEUycHB0pqXf1+/bynF2FAINXeGkOEssREOw4z
        xHfQd9XcOZEMX7GR7Hui8w2wNvFTK1A=
X-Google-Smtp-Source: AMrXdXvz9VmRiK/nF4+b56vm0SwVXF2WbbUpzjI9Cd6uxuBQIS9oHmSJq79WwnzTS7r+ImhHatuGXw==
X-Received: by 2002:a05:6a20:94c4:b0:aa:806:7b91 with SMTP id ht4-20020a056a2094c400b000aa08067b91mr65167272pzb.39.1672912919124;
        Thu, 05 Jan 2023 02:01:59 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id mp10-20020a17090b190a00b00213202d77d9sm1006086pjb.43.2023.01.05.02.01.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2023 02:01:58 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH] kvm: x86/mmu: Don't clear write flooding for direct SP
Date:   Thu,  5 Jan 2023 18:03:10 +0800
Message-Id: <20230105100310.6700-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Although there is no harm, but there is no point to clear write
flooding for direct SP.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 79da423ee4cb..11f17efbec97 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -649,12 +649,12 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		goto out_gpte_changed;
 
-	for (shadow_walk_init(&it, vcpu, fault->addr);
-	     shadow_walk_okay(&it) && it.level > gw->level;
-	     shadow_walk_next(&it)) {
+	for_each_shadow_entry(vcpu, fault->addr, it) {
 		gfn_t table_gfn;
 
 		clear_sp_write_flooding_count(it.sptep);
+		if (it.level == gw->level)
+			break;
 
 		table_gfn = gw->table_gfn[it.level - 2];
 		access = gw->pt_access[it.level - 2];
@@ -706,8 +706,6 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	trace_kvm_mmu_spte_requested(fault);
 
 	for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
-		clear_sp_write_flooding_count(it.sptep);
-
 		/*
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
-- 
2.19.1.6.gb485710b

