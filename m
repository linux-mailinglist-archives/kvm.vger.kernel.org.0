Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F57445763
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 17:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhKDQn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 12:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbhKDQnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 12:43:55 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BC2C061203
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 09:41:17 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id z19-20020aa79593000000b0049472f5e52dso511615pfj.13
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 09:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BLpO0fOkHXhU49HszP9J7IBUy0ZTyjUC3dOvZNy0mdE=;
        b=TCwN7LDAPJdrI3JQ0PhC2yCcI5yLMhPl7ApX+9DhRmXyfPHERawX2DwxsXfzQpe9j7
         aiStPhF6p6Nc0rQj0cQ6Mr+Q2jbguwuqGoltihH6LYnjeNZb1UignEIOlPkm8hFbdlgN
         yVynl+h5lLQhr4jXpCj1CaYf7Rkv4LndwkROKDmusS+uaL/A6tmofBzuYAEpvgY3MF+w
         6pOCDVv8jBPc3PnWz2YdpXTN+WHrksH3DawZW7qu7EHw0YH3LzXmKSA2r4O46Hfslcwg
         adnajvryDs/Nm5UcX0GdIbmqjM7LYEUxG51G5Dy6nlYavqc2vn+hQO5BP+l8Bw+wIvLC
         LD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BLpO0fOkHXhU49HszP9J7IBUy0ZTyjUC3dOvZNy0mdE=;
        b=tJ0s/t+0xcTpzVpipg+jP7cGA/57tBSRQHZK5Wv9G+2tHrbq1Jv1OnkqX83peB7kDW
         ZXZ8iT9Scp+44JhiWT5tUG9wtsdk4mDcap0JU3dHx6mLy/HmJ8yBDkmDMH1yHV68COHS
         k1zV8EIZ+erHO0D5Gz+vQXQLsnbZhvDx8PJYo7P56Zkod0mjxP2xG8odIJRkR2RiqIVz
         GHMA7UBxJ2HXgUXI0onMiwpzomJkVKq2O2APRTmRPu5FQLuNWnkIdJLb9GYgjS0chMSC
         9t4QBMKehFIM0jQ1aYE3JqYzL3s26wDkkBDnP6VamO7aRGqiP6gZZdu8xG1hnMQOxdoE
         PsEg==
X-Gm-Message-State: AOAM530+X9AqlPUL7xwJPLpofEy6RGe4T1o6yw7ZRcJnol+aYvvS4VPD
        d7gMQjcTSUuU3a/ghvSYzwq+B1Pn8jc=
X-Google-Smtp-Source: ABdhPJxBUNyqMmxEzIJpo0JuZDNZmWIY5euPfVSkwAjseNfVPNvFjkbOibNRD+fI58d1ZSdMDQWSia9J8WI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:a50b:b0:141:dc7b:b2dc with SMTP id
 s11-20020a170902a50b00b00141dc7bb2dcmr29202914plq.4.1636044076879; Thu, 04
 Nov 2021 09:41:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 16:41:06 +0000
In-Reply-To: <20211104164107.1291793-1-seanjc@google.com>
Message-Id: <20211104164107.1291793-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211104164107.1291793-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 1/2] KVM: RISC-V: Unmap stage2 mapping when deleting/moving a memslot
From:   Sean Christopherson <seanjc@google.com>
To:     Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Atish Patra <atish.patra@wdc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unmap stage2 page tables when a memslot is being deleted or moved.  It's
the architectures' responsibility to ensure existing mappings are removed
when kvm_arch_flush_shadow_memslot() returns.

Fixes: 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index d81bae8eb55e..fc058ff5f4b6 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -453,6 +453,12 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
+	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
+	phys_addr_t size = slot->npages << PAGE_SHIFT;
+
+	spin_lock(&kvm->mmu_lock);
+	stage2_unmap_range(kvm, gpa, size, false);
+	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-- 
2.34.0.rc0.344.g81b53c2807-goog

