Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523B468DD70
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjBGP5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjBGP4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:56:50 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4E03E0B6;
        Tue,  7 Feb 2023 07:56:35 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 78so10713068pgb.8;
        Tue, 07 Feb 2023 07:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOnDqaG2XhUHB/WmsQz/FiP9408Q1azUvig3p3fnFEw=;
        b=BDo/Q+Rwl0qIWD2sVWQsUQDfJsileXeDrgFTGRu1b0HAlYjUeI1pg6kUmFNmYm6GaG
         qTPQksTq2H3cqau/VKs22+LzQbHh6z1UlhEnKr/NFRTGSkwXD4YbIOvbCZdo3ZFuPWwD
         5xgLXLhQBLnmNpERxLNYIzT0YFNIadpfAmkru0PYMbiy8QrZYtaFecFaviAwXWErZmZK
         Yw8pTLkOKRQsuj0BR483beNc281YtoiIcCmJG9PbjyjwbnjCK5ntWMIXeJn/Xb5w+EIi
         5JJ4q3pcSFV1imNvs4pIfWVkSqk99peCsc3pZ2m+qeOMNmdlLcX5fUnqbrfgxtjmoudR
         NJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOnDqaG2XhUHB/WmsQz/FiP9408Q1azUvig3p3fnFEw=;
        b=kng+cMoPHZaIZfnjKaTzlVM/mpNdZI2vPWgScC7dMIFQsgIgCykrLg600gykcSTBmA
         h5+jrS14krlyarBW3MXneli9c3z02iW3kj6eUNbpyvfS9GHjLYh22TqsngVv8802wlQH
         Gjhshu0jSXafK6cwpAyyucqLlP5dNPHceJm0Io5kdneRP7ZEVaQS0TGl/mgBUX3hQdew
         +2efRCghgg8QgXiCs00HqoSWEMMwDVDFfnrv2rmwORNFLgeCcU0YqqeVYd4Ra7wocG1X
         L3IcMNS3sQ8NP+7pcxKEnSbphcKdpB6E2fNaSy8oDYfFG2SGloXSqzD3ZBwl8/Zr1fX7
         zzYQ==
X-Gm-Message-State: AO0yUKU47HBO/9Rxz11GawlXCg7DJl5ymVD7T+h0KM5SdnTqFXXet8JB
        jJMewLP5T91Mb8OlVrjrfG3YzC5pRuo=
X-Google-Smtp-Source: AK7set90ZmmklO1BbI+kvC5qGbxtQneKMdFglsTQL/UbG0r3+oXsj8983bu1zrphuNABhnM5SeIdVw==
X-Received: by 2002:a62:1457:0:b0:593:d46b:ab73 with SMTP id 84-20020a621457000000b00593d46bab73mr3039040pfu.29.1675785394567;
        Tue, 07 Feb 2023 07:56:34 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id n24-20020a056a0007d800b005897f5436c0sm9363725pfu.118.2023.02.07.07.56.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:56:34 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V2 4/8] kvm: x86/mmu: Set mmu->sync_page as NULL for direct paging
Date:   Tue,  7 Feb 2023 23:57:30 +0800
Message-Id: <20230207155735.2845-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230207155735.2845-1-jiangshanlai@gmail.com>
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
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

And both mmu->sync_page and mm->invlpg only make sense in shadowpaging.
Setting mmu->sync_page as NULL for direct paging makes it consistent
with mm->invlpg which is set NULL for the case.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e03cf5558773..e30ca652f6ff 100644
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
@@ -4469,7 +4463,7 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
-	context->sync_page = nonpaging_sync_page;
+	context->sync_page = NULL;
 	context->invlpg = NULL;
 }
 
@@ -5157,7 +5151,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
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

