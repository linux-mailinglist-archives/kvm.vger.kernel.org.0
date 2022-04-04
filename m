Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953364F2055
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 01:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiDDXoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 19:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiDDXoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 19:44:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9568B66AF9
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 16:42:03 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id p9-20020a63f449000000b0035ec8c16f0bso6359273pgk.11
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 16:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CaD5i7uWV8aXENdqT5/Q1IvKQzX6yvHELCk0D3aIz+A=;
        b=jZKt3Q4Wq9KSvffmXMldabyC+4MvZErOoCul5wp26X3fVT7avqVOywE6dRTV5JJo11
         Lm4ZyJkQKcU6bzStWVXFKpng/HMzb0ZtmfE6Nd/d6RU6cNkQ84Wt3BpalH6kyvulvAYr
         zShnZTa4A2gBE2r/kwAWzJBueRGlu4o86+XfaQ68iLhbvA/N2T1r2CnXE7LYiv3IBC9b
         3CL7MFjQ40fQAwER6JcDbx/XuT0DGvKUPlXuLZNEWli6lVkHQPjWTLNfDUk4OjPqLTYU
         2oyOjUsiPjPTpHWPApftGdp/0I5gf1OiMGXydG4zv0rrxfDYablQdArb0FX9DyXUBsbK
         23jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CaD5i7uWV8aXENdqT5/Q1IvKQzX6yvHELCk0D3aIz+A=;
        b=Lus0nOiYXfejjwSya+g6plSuGlfGZe0vgDrqoiIFKQO5o62xNUDPZQ9Ro8k3zCyJBa
         geunFgQJsuSxryeaMipRxz1ZuAE9x6z0tXkqWTRmxu14AXKOF+6g5w0Zetq7JLZ6Tp0/
         HU0EcXR0gsc8kxo315hFfaqjS19Kf2KESYdt6INaxiJtCbXhQdNnEGCX9t3z76aJ4iwj
         dF6dFRzisnwDEJW220usrYndAllGNDYLhfGgvvhCdaeiaA0f6jZtm9PlaQh6l4Peipfi
         OfLwMsAFlTJnbx8S7Tp8Al9R+h5pwHAXndX4yeNVvEgLrB1lf9NMcwVxbh1LKQl0XoFe
         2Ggw==
X-Gm-Message-State: AOAM531uX6k82d6xKgq6LcqOw+iN/ox8I56luY83L9GD7rwvquax5eo7
        2ZGy3ENEe4ecwGNJnSy5X1VaUr3ypK64xalt
X-Google-Smtp-Source: ABdhPJznx5CPgiI0z19F0ZkzF+3RdCQG8+R2KZlvfK7h7Xj/Uh7x/vARspwj7iObyoaIy9/NWmWCwv74G/ufbWL6
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90a:db48:b0:1ca:ab67:d75 with SMTP
 id u8-20020a17090adb4800b001caab670d75mr73933pjx.1.1649115722406; Mon, 04 Apr
 2022 16:42:02 -0700 (PDT)
Date:   Mon,  4 Apr 2022 23:41:50 +0000
In-Reply-To: <20220404234154.1251388-1-yosryahmed@google.com>
Message-Id: <20220404234154.1251388-2-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220404234154.1251388-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 1/5] KVM: mm: add a helper to account page table pages used
 by KVM.
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     mizhang@google.com, David Matlack <dmatlack@google.com>,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yosry Ahmed <yosryahmed@google.com>
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

Add a helper to account pages used by KVM for page tables as pagetable
stats. This function will be used by subsequent patches in different
archs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/kvm_host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..ca46b68e7086 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2221,6 +2221,15 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If nr > 1, we assume virt is the address of the first page of a block of
+ * pages that were allocated together (i.e accounted together).
+ */
+static inline void kvm_account_pgtable_pages(void *virt, int nr)
+{
+	mod_lruvec_page_state(virt_to_page(virt), NR_PAGETABLE, nr);
+}
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
-- 
2.35.1.1094.g7c7d902a7c-goog

