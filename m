Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E8B53DA88
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345248AbiFEGnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244254AbiFEGnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:02 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158C334B83;
        Sat,  4 Jun 2022 23:43:00 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 15so10354877pfy.3;
        Sat, 04 Jun 2022 23:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dDNkyiYQibCgf/rVCghm4F/yjFWHN7ySeP2Yb3nvzmc=;
        b=jJ3i1ndXvgUe3bVZ1KiEPg7d7J8wl20/W0DXpd4iDs1QmFmBftn0Z5h8JJlEsSoE+V
         bfkbz0NaECSkC/9Rv04c5VmAlrvAlgfzyI92saVJ/czrtAhNoThBxQXftVjtf7aviWU2
         wGEfCID2dFvWXvsOM6YvABN45a83Vnzv7L30YRwi6PS/YDJvzpA1CMh+Y2NijZN98zig
         S8H0VSpAuuYjja2n9qs0dvFc7AM/9ehsV0bgG6ZkPXeD6/MhnUAj+KiQDt7qNR6n1vpH
         XsjZmJtVCl2vmjZ5NLP5bNFP0QMJdn40NwGyoJHewxKUD+uHGqHdt47v4FMQm/XkWc5D
         5+vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dDNkyiYQibCgf/rVCghm4F/yjFWHN7ySeP2Yb3nvzmc=;
        b=cgvmWUfT67mA1wsxKyrRlm9oL2VM+73Xw8RJMkcPEt99r72xUlOfCEJS52NsbqJ3+/
         i8Ss8XCU8g2ZQ2F3JAXLPFxBmTopDh2PQwOO8NTLSClOdcT0dPAR3dhY8sYWNxFiwrI1
         jg5ljdoPuDmn8ll7I1z/qkk1VCo4Jp+Lc5oeuuaB0Su4WFdnayiXlJXLB10jmTwKxh+U
         r0F033BuRGk9bbrq2brVcG3Jqr/BadP51v96rZcPkrr/kHi+xI8bDomY7DAnRH77GQtq
         Kw7DEhNaCAxEHy9q9u5d1ad5Gwqr5BjdRnqPUmudibeqfyCWmM7QNaOiljtqDHzCohQF
         OlJw==
X-Gm-Message-State: AOAM532vYsF2DoJSJyu5zu8iwlqzwP/z5lbqIeDRP9rRvbaQ2LWgc+Wd
        KcM35gIaENUzp8R1evNjkc4mqBVhKHA=
X-Google-Smtp-Source: ABdhPJwdH0lclPyZGPsa51Rk3cJQFvD4yz2VwKFWA/YVSobyo48r9HKeUzZ72GdREO7t+e8Q6QGRjw==
X-Received: by 2002:a05:6a00:894:b0:518:7f19:f21d with SMTP id q20-20020a056a00089400b005187f19f21dmr73517227pfj.4.1654411379289;
        Sat, 04 Jun 2022 23:42:59 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090add4200b001cd8e9ea22asm10167510pjv.52.2022.06.04.23.42.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:42:59 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 02/12] KVM: X86/MMU: Rename kvm_unlink_unsync_page() to kvm_mmu_page_clear_unsync()
Date:   Sun,  5 Jun 2022 14:43:32 +0800
Message-Id: <20220605064342.309219-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605064342.309219-1-jiangshanlai@gmail.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

"Unlink" is ambiguous, the function does not disconnect any link.

Use "clear" instead which is an antonym of "mark" in the name of the
function mark_unsync() or kvm_mmu_mark_parents_unsync().

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f61416818116..c20981dfc4fd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1825,7 +1825,7 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
 	return __mmu_unsync_walk(sp, pvec);
 }
 
-static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void kvm_mmu_page_clear_unsync(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	WARN_ON(!sp->unsync);
 	trace_kvm_mmu_sync_page(sp);
@@ -1987,7 +1987,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 		}
 
 		for_each_sp(pages, sp, parents, i) {
-			kvm_unlink_unsync_page(vcpu->kvm, sp);
+			kvm_mmu_page_clear_unsync(vcpu->kvm, sp);
 			flush |= kvm_sync_page(vcpu, sp, &invalid_list) > 0;
 			mmu_pages_clear_parents(&parents);
 		}
@@ -2326,7 +2326,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 		unaccount_shadowed(kvm, sp);
 
 	if (sp->unsync)
-		kvm_unlink_unsync_page(kvm, sp);
+		kvm_mmu_page_clear_unsync(kvm, sp);
 	if (!sp->root_count) {
 		/* Count self */
 		(*nr_zapped)++;
-- 
2.19.1.6.gb485710b

