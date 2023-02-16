Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A136699913
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjBPPkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjBPPkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:40:35 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CD8564BB;
        Thu, 16 Feb 2023 07:40:30 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id e1so1519894pgg.9;
        Thu, 16 Feb 2023 07:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+P2V/rDJHh3791vsFkos1nlRJ7X5Lj2yIGz2MSJGxnc=;
        b=lP/cnq8Y0MQbnwJSe62IO03UHEUfyoey/rrq8diUr3a1B80t2Te/gLBLDfwqeBZcwO
         fVTeoTmAboWBd1jDUrzqbU9g9mlLD4/ZwY1xn0ubM4oAp15rg1MKZL4F+Ojt2Va4kJHX
         QBQrFyEb5pSSCnI6EolRND/PdXmlP4bNGCd0Eqtb0sg1yuoTHY0hTbS4edZWJAJS7RGE
         CA7GBlv+ytVTYkQXx/9V/OEhFQ9yeVMGakh7Ts+8CUlMkQ8V535dC761h5vWV+BlHPku
         lJeq1fX3WAVK6RRKlpsFlPv7ByO5lBhCgFd7XOlPwN1Ai4Br1Oc/hinkP/sXdNCxI3z9
         0mnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+P2V/rDJHh3791vsFkos1nlRJ7X5Lj2yIGz2MSJGxnc=;
        b=TmqlMSHHya7EZs6dqAAFdbbeG26BWzE+hGeMfhwHwsE1POzerMLK1z1r2tzKPkY7/r
         F1cqliKbLct+3BIV3taaMFKmWfjEJIwm2JDFRH4yOsKqJMX9579ZS/4ZHOV/AUnYw6wo
         ReeYI7eSChKfsbffYVtwSxmpMD1hvfCnu6sAVe9q7/X5INcS5hOCXo3/hodNrgfJFpDG
         gBO8fRMH1a7ak09qSkF1ZQRYYD/mjlwYe0GoxhSL6GZPpXAyCpCQAYlfwR/LJiaUSgKB
         T8849tpt8LIFZHpoxeSlula7mjYZKAL8g6a1of+GNud8tQmUdHA917h+Z1hIHJumHpyK
         CN9Q==
X-Gm-Message-State: AO0yUKX1Fw9VyfKfduxLB9oB0CZ6a9cv7Oz+CXNQiak3O0hMH+7fLF8d
        ZGSNwiEio4GIPmL6pPDDF6hpfx5ulh0=
X-Google-Smtp-Source: AK7set9uYPFO0kw2jfhmKM+AGVZL6KU14Eu0HeelFCJFLWNeUhO3snG1u9Yut6QHFZt08f4tAsYkZw==
X-Received: by 2002:a62:7b85:0:b0:5a8:b649:99d4 with SMTP id w127-20020a627b85000000b005a8b64999d4mr5218013pfc.7.1676562029757;
        Thu, 16 Feb 2023 07:40:29 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id w2-20020aa78582000000b005a8cc32b23csm276684pfn.20.2023.02.16.07.40.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:40:29 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 04/14] kvm: x86/mmu: Set mmu->sync_page as NULL for direct paging
Date:   Thu, 16 Feb 2023 23:41:10 +0800
Message-Id: <20230216154115.710033-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216154115.710033-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
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

mmu->sync_page for direct paging is never called.

And both mmu->sync_page and mm->invlpg only make sense in shadow paging.
Setting mmu->sync_page as NULL for direct paging makes it consistent
with mm->invlpg which is set NULL for the case.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 69ab0d1bb0ec..f50f82bb3662 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1789,12 +1789,6 @@ static void mark_unsync(u64 *spte)
 	kvm_mmu_mark_parents_unsync(sp);
 }
 
-static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
-			       struct kvm_mmu_page *sp)
-{
-	return -1;
-}
-
 #define KVM_PAGE_ARRAY_NR 16
 
 struct kvm_mmu_pages {
@@ -4510,7 +4504,7 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
-	context->sync_page = nonpaging_sync_page;
+	context->sync_page = NULL;
 	context->invlpg = NULL;
 }
 
@@ -5198,7 +5192,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->cpu_role.as_u64 = cpu_role.as_u64;
 	context->root_role.word = root_role.word;
 	context->page_fault = kvm_tdp_page_fault;
-	context->sync_page = nonpaging_sync_page;
+	context->sync_page = NULL;
 	context->invlpg = NULL;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
-- 
2.19.1.6.gb485710b

