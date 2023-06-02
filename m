Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B1472070B
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbjFBQKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbjFBQK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:10:29 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD29E62
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:09:56 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b0314f0aadso15276985ad.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722181; x=1688314181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rivHDhk0ioxMpP1XynwGaSZFsNZDBBbqgVAGbR7E/X8=;
        b=IxpZG4TkYuPd8UtpcDQplKJDDIpAs6lGKWZe95duADLUk5Xly6SRvjrVvCEGB/Fk1a
         E9X3IJECzkdQ25Bkjejj4IbXek6JqPY58HRA50EOI/YFTzUpFaA/bzGSlAOm+5PEvo+T
         6jKSmBS0KSmdPni70wpBlwTPrvyYGZvMtxSC3Fbri9jwwzePk7OY91lpj01vmu9g7PZn
         a5J+YN0h1Qu/z/w7ubpNpCMDwcQqYWttGGXgoLeySgwUxIZDyVDmv/3Bk/4OJqAcfD0+
         gHcpPqAo0vTPvSXpzWrIqDWuTjrALALhGQwaLZCyItTHvmVctEjS/JfpfTvctKcX+1gM
         QFLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722181; x=1688314181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rivHDhk0ioxMpP1XynwGaSZFsNZDBBbqgVAGbR7E/X8=;
        b=ZVr52YiNcbwTATQpafF4FDeea2D5EDncprLTRyMZrodBo5JD7GG087ahLGs2jm6W6x
         GvR1q2dXlfzaCU3+4O6pHSkvMcbt0VVlhywLAD59YfKaM0uZlswkIc6DCA0uIDNpYmkk
         GYGzRf6O9SAwJ9IlQskLGIuKcY9Gq0xdv/Sb5a+kjoZFTmPIT9YGt/k6bNSXI0wuhix2
         7RWldakVh8BYF2kgqq26jrVoFG3dLV7mHK/p7/29n1snJbBdqRmCtuMeoGC68NNHB/Ic
         YUExKy4pddsQ9yFbW56sz17iMW2nvUQa4TOEZYChdlcSOA/V3IxZ48l513842/ZDabFd
         H56Q==
X-Gm-Message-State: AC+VfDzh2wsVZfOEPqalHupNHB2TTVqkYuirPx20JF1mbfZaB7tZ9ltU
        aMEvxJy56Z8W3oQaGaxJ6idhWy77A68+
X-Google-Smtp-Source: ACHHUZ4crxpGe15BxcOcaGOZO2WjPbibX9jRmjl7rSrwdD8Z6/aya1uE9CJM9AhjU7HHArKs+z3PEQeSOj8s
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:e3c5:b0:1b1:c90e:b7aa with SMTP id
 r5-20020a170902e3c500b001b1c90eb7aamr56727ple.4.1685722181662; Fri, 02 Jun
 2023 09:09:41 -0700 (PDT)
Date:   Fri,  2 Jun 2023 09:09:09 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-12-vipinsh@google.com>
Subject: [PATCH v2 11/16] KVM: arm64: Use KVM_PGTABLE_WALK_SHARED flag instead
 of KVM_PGTABLE_WALK_HANDLE_FAULT
From:   Vipin Sharma <vipinsh@google.com>
To:     maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de,
        anup@brainfault.org, atishp@atishpatra.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, seanjc@google.com, pbonzini@redhat.com,
        dmatlack@google.com, ricarkol@google.com
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check against shared page table walker flag instead of fault handler
flag when determining if walk should continue or not.

vCPU page fault handlers uses shared page walker and there are no
other shared page walkers in Arm. This will change in future commit when
clear-dirty-log will use shared page walker and continue, retry or
terminate logic for a walk will change between shared page walkers.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bc8c5c4ac1cf..7f80e953b502 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -191,7 +191,7 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
 	 * Callbacks can also return ENOENT when PTE which is visited is not
 	 * valid.
 	 *
-	 * In the context of a fault handler interpret these as a signal
+	 * In the context of a shared walker interpret these as a signal
 	 * to retry guest execution.
 	 *
 	 * Ignore these return codes altogether for walkers outside a fault
@@ -199,7 +199,7 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
 	 * with the page table walk.
 	 */
 	if (r == -EAGAIN || r == -ENOENT)
-		return !(walker->flags & KVM_PGTABLE_WALK_HANDLE_FAULT);
+		return !(walker->flags & KVM_PGTABLE_WALK_SHARED);
 
 	return !r;
 }
-- 
2.41.0.rc0.172.g3f132b7071-goog

