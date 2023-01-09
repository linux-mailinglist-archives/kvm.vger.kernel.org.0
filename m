Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FDA663390
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237806AbjAIVyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237311AbjAIVyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:54:20 -0500
Received: from mail-oa1-x4a.google.com (mail-oa1-x4a.google.com [IPv6:2001:4860:4864:20::4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882113BEBC
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:54:09 -0800 (PST)
Received: by mail-oa1-x4a.google.com with SMTP id 586e51a60fabf-15a1e0ce4dbso1206509fac.21
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OYPMgEiPrxU+CobVMeoQJZAp/V2pR2BlGHT0msnI4jA=;
        b=gyqy+T4vgLafFMd0I72XmEQLYVlQTS+qhprWpdg3mEk77/0NG6F6Vo9alqxnGmqKdb
         WZvjupvvlPafMfSMJ2s+wpXfxi6b6ezq2somnPaIa5uD4SQ7TWF30I0YFqDDXo5mQ3bh
         79QWb0qRKtavRZqsJV+vpoW2IclN8C/BLnslNlOGvS72sL3JOCAzgoDtI/GUtCetTbKM
         YHg5XDnlWZE66YvINnBXAwLe5dKRNCj7Ol15d31EPXsjblFs/A0QhZ2iW6tmwtEi98nt
         pwcuo1f6vJWFJMbxln1e1WzOxTvCZkL1qdGaMkN2BvtMAA13Fq5oW+Cscfw1n6sJ1KOq
         CPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OYPMgEiPrxU+CobVMeoQJZAp/V2pR2BlGHT0msnI4jA=;
        b=uP4pSO18PrbPvOMRzcCa+5YJRp8Ylq3Afux0C+S5rRHkQv4aQmlvMKNpVQtfv9l+2T
         DP++nNJCBtV9DYhuAQi4QYS8hgMTLDp7GYggmyRuUqxeVCY7A1IWY1K0zA1bqubDz7Dn
         04bCPbA7uAcCauwGIMgV+xU401OxsEfSvI2nvSp5LxL2axPEdEN97AYYsiCgWyX/Xgzv
         pcNWl/LE/VxjCjL1k1oALQyLljgi2vBKBBlsTLkNrcJVbETHbtw6D9+mrbuRjdujEyWD
         THp5//HOuR+an2Qh7gZe32jrR+ZxtaXy6iPqkS9l9C3PIcYkeL1zp+PdvsUedRx5IqAh
         1Rbg==
X-Gm-Message-State: AFqh2koqCsQhiQMqpdDVPw0R3AraH69N4uX5Fe4gB8MoO7AdN7jyliGw
        8O9Qm/jGOZjxUpdevKQQoCMkXpT6+Rfp
X-Google-Smtp-Source: AMrXdXtbj9JAAHI73qaN+iD7WOKh4IAZdRGGbBS99shwFb5KWNNXJ3O7u4NPvmn0Z64VJQ7npOOB1EfCbLio
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a9d:193:0:b0:66e:be75:d63f with SMTP id
 e19-20020a9d0193000000b0066ebe75d63fmr2993190ote.294.1673301248299; Mon, 09
 Jan 2023 13:54:08 -0800 (PST)
Date:   Mon,  9 Jan 2023 21:53:45 +0000
In-Reply-To: <20230109215347.3119271-1-rananta@google.com>
Mime-Version: 1.0
References: <20230109215347.3119271-1-rananta@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109215347.3119271-5-rananta@google.com>
Subject: [RFC PATCH 4/6] KVM: arm64: Optimize TLBIs in the dirty logging path
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the dirty-logging paths, including
kvm_arch_flush_remote_tlbs_memslot() and kvm_mmu_wp_memory_region()
ivalidates the entire VM's TLB entries using kvm_flush_remote_tlbs().
As the range of IPAs is provided by these functions, this is highly
inefficient on the systems which support FEAT_TLBIRANGE. Hence,
use kvm_flush_remote_tlbs_range() to flush the TLBs instead.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c | 7 ++++++-
 arch/arm64/kvm/mmu.c | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 00da570ed72bd..179520888c697 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1433,7 +1433,12 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 					const struct kvm_memory_slot *memslot)
 {
-	kvm_flush_remote_tlbs(kvm);
+	phys_addr_t start, end;
+
+	start = memslot->base_gfn << PAGE_SHIFT;
+	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	kvm_flush_remote_tlbs_range(kvm, start, end);
 }
 
 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 70f76bc909c5d..e34b81f5922ce 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -976,7 +976,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_range(kvm, start, end);
 }
 
 /**
-- 
2.39.0.314.g84b9a713c41-goog

