Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD45D73F35B
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 06:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjF0E14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 00:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjF0E1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 00:27:33 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73271998;
        Mon, 26 Jun 2023 21:26:59 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6687096c6ddso2009132b3a.0;
        Mon, 26 Jun 2023 21:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687840019; x=1690432019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AX8+X8PxMH5T2DKkZ18GUodMLEHk3QVmfoTQyZgaOx0=;
        b=AHE8jyOGU3wI6fRziHWkoDA57d8OCnLbP92dwxvNvYiZ6ew80efVyhEeCJjUJM8uNM
         2If/YRkJVMtgavz6/orlGgXjuqZFCiaYWtzBzlSPqJAr1mKLGIjcZtB712MmGh8ApwKx
         Ez9/p8exS2/ayT9FCx8J0yz96T5ls6iNcWMUTl/hPp7ikUXXcdmINF+wNC/VKHqW51sT
         SXKEuAcrQJdu4F49nMnOBBsHoXWsUTpxGag3W/pBp4cheoLTeGIXtfxWNo5K38SepZFt
         5L1G/vXKFsiacU2JS2QykPkeyYr+Ukis64SyPLXzhad0/WcDupYIW5NmNgjOcv1Ugds1
         WlsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687840019; x=1690432019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AX8+X8PxMH5T2DKkZ18GUodMLEHk3QVmfoTQyZgaOx0=;
        b=YhyEVnB7VjNbEvqVn0U4u1ODdwNQcIO9Y8Y551n0LYl7cIsr3TdGlR/jsN0qmodZgy
         nTnBJsLyobccJ4Dydmda3V1pyUwAKIgVjqiz/H3UdlIoQCr06CEp8ftTfdIB6OEb2488
         XwVH76kgEIj1rquREz/cBVqpRche7OOWoWg9kIRXSZK6jUgbsaS4EIkpAEq6IY6RbFCP
         K0BhD9KXZuxZSYjHbkYtHmJw30Pkgpi8JrccP3OvUWs4IhzRhLdR81SiHp8ivjpZ6oxK
         SrddhvmvScl+p5JYG0NPlGe7JKgEGXROakNpcSHZWq6HuvFa0ej9C1Fw+J1kZyPzfA31
         lLSA==
X-Gm-Message-State: AC+VfDwT2wGeHj6eAR0DtplPqyIp18r6PbXpQspYvJqQy8v2wNGP8o4+
        Ou/2ixsfS03ISBaMvKO4dF1uvujmGZ3glWiRS14=
X-Google-Smtp-Source: ACHHUZ5EZ5D4+9bALrcv2PJTwgMmHyn6r5o2POGTE+kEHXgGQPMg2nf9wYi2QkWnZo3w7MoZ6QeF0w==
X-Received: by 2002:a05:6a00:2193:b0:66a:365c:a0e6 with SMTP id h19-20020a056a00219300b0066a365ca0e6mr14389504pfi.13.1687840019251;
        Mon, 26 Jun 2023 21:26:59 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4-20020a62ea04000000b00659b8313d08sm4506055pfh.78.2023.06.26.21.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 21:26:58 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Move the lockdep_assert of mmu_lock to inside clear_dirty_pt_masked()
Date:   Tue, 27 Jun 2023 12:26:39 +0800
Message-ID: <20230627042639.12636-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
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

From: Like Xu <likexu@tencent.com>

Move the lockdep_assert_held_write(&kvm->mmu_lock) from the only one caller
kvm_tdp_mmu_clear_dirty_pt_masked() to inside clear_dirty_pt_masked().

This change makes it more obvious why it's safe for clear_dirty_pt_masked()
to use the non-atomic (for non-volatile SPTEs) tdp_mmu_clear_spte_bits()
helper. for_each_tdp_mmu_root() does its own lockdep, so the only "loss"
in lockdep coverage is if the list is completely empty.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 512163d52194..0b4f03bef70e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1600,6 +1600,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 						   shadow_dirty_mask;
 	struct tdp_iter iter;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
@@ -1646,7 +1648,6 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_mmu_page *root;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
 	for_each_tdp_mmu_root(kvm, root, slot->as_id)
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }

base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
-- 
2.41.0

