Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BC265E872
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 10:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjAEJ6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 04:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbjAEJ6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 04:58:07 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0A65017A;
        Thu,  5 Jan 2023 01:58:06 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so1502309pjg.5;
        Thu, 05 Jan 2023 01:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qA9L3HAkjkk/belL4oNcpN0xg0KHFKgsF2/LCYlKyHk=;
        b=mCSvXwVqp3va7cuGh/Xm0kRBByIew6A9DS/Q7Sln/ri7qpvF01Mn0miRWwaNpru8t8
         hkGNhMUiAAuS+sSmADq1d29akmHpFeM4AnEopl3IO5nFV15iMj2fWc4yq2qYlBlfRDeH
         3cFtHntSU6JBcVIynGUJDdGfnVP1FjGwW4kL/3ARr4mZkeLHRDaZKIFxtbCz4d8w9sYH
         CChsNzsBG9MwIAjonXxqbu8ngpLvV2XxS+M0S7emsQzu0PORim4CICREqKyC3T/B/jna
         8OQAuW0lBWq7eA9Eb8Yflv9CHyvxkCszyG1zLvcxs1PXiUU6kDxhvCG+pbkTZzRu9hLh
         Qc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qA9L3HAkjkk/belL4oNcpN0xg0KHFKgsF2/LCYlKyHk=;
        b=fyWHGowgPvZTvkchyQ4p87JQ8/jXBUOscG60Em02ptQXKBPODpDyGxiALCYfydUXSu
         GRPzGQfPou5a4bOYXpJnrqm7ozR2/lLdN0Y+d7Ya5gs+4OVvZ1SPCPNBPB2kZRdkyJRX
         C+noNSgGg+XhzwZgIAG2dNqJtu8CkxbHwLRaIjTLWlwHqQS2Rn6pPhuw5u0B61gIfbcJ
         hFUDQ3piG97b1TN2uV+a0Ben4TNJ67/Z4scF3DS5xoWXEl01juelSUBis3YlgbQkuk4e
         51FWkmiOi2t+NQfysK4AFUyg60/eDzSMWlT3r2MLW0jZAhLBLkJ+/wglts8ShWoT7zXY
         onkA==
X-Gm-Message-State: AFqh2kq0Esn4wMnjCcNJ20wHE6uv2czSgFWKOdY7y6jjLRE3Kt1u1obY
        N0TGkQpVo9+2bVGjQXhASXSIm1d6IoQ=
X-Google-Smtp-Source: AMrXdXvJEZeuKTe83nfCXPEZ5ZvG3fkEosCwGlFSD5uo7L6HCSJ2lz6sl6/L7rjtlp/uzcjZkYmBNg==
X-Received: by 2002:a05:6a20:3aa3:b0:b1:dcf1:6996 with SMTP id d35-20020a056a203aa300b000b1dcf16996mr52483351pzh.54.1672912685802;
        Thu, 05 Jan 2023 01:58:05 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id y17-20020a626411000000b00575b6d7c458sm23980624pfb.21.2023.01.05.01.58.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2023 01:58:05 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH 7/7] kvm: x86/mmu: Remove @no_dirty_log from FNAME(prefetch_gpte)
Date:   Thu,  5 Jan 2023 17:58:48 +0800
Message-Id: <20230105095848.6061-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230105095848.6061-1-jiangshanlai@gmail.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
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

FNAME(prefetch_gpte) is always called with @no_dirty_log=true.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 62aac5d7d38c..2db844d5d33c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -519,7 +519,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 
 static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
+		     u64 *spte, pt_element_t gpte)
 {
 	struct kvm_memory_slot *slot;
 	unsigned pte_access;
@@ -535,8 +535,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn,
-			no_dirty_log && (pte_access & ACC_WRITE_MASK));
+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, pte_access & ACC_WRITE_MASK);
 	if (!slot)
 		return false;
 
@@ -605,7 +604,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		if (is_shadow_present_pte(*spte))
 			continue;
 
-		if (!FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i], true))
+		if (!FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i]))
 			break;
 	}
 }
-- 
2.19.1.6.gb485710b

