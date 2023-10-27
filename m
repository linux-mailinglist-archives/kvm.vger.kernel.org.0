Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DF87D9ED7
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjJ0R0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjJ0R0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:26:46 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C65E1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 10:26:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7c97d5d5aso23504097b3.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 10:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698427604; x=1699032404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h7zgIHGY1fMUAUPEVpzUQCosT/suKTQ/PWlcIQnXnng=;
        b=n+LoqulZmLHZ90Y9TO0GNu49Pcqo8DPEHDnY+UBUxXuaEqn0C3iasZjZWYW+6oL1vv
         kwT4AtRkkmVB4Z9DiX/ytnCLdPcz0tRgcbkfQID9t+lUSd/KlZubFq2k+JzuA/OUVb5k
         WcX1hl/pS7JNjQEjjFakRBznxif4ZnaAZwMDB+Z6t7J3PbJo6zN9ttKMRHLFUeN6MSgA
         b7CKJYXsWOrqjAwp9Gr+ZDV8Ys1i/j1zJNpR6AP5D5NGqhM/+xFN8Xec4s/JPwf/KYUE
         zMYcc9zBG9DsGyEZ5O008FU1AkCsHeS6WqD3KHZDefaztcEz5P+lfFuHrDKjYlpcHvik
         5uSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698427604; x=1699032404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h7zgIHGY1fMUAUPEVpzUQCosT/suKTQ/PWlcIQnXnng=;
        b=tkkWugMu6UyQGwAwGrmo2A8n8zYVknrL65SOGNhQ4UYYZc9/0SRNyw3rV4Lh4G8489
         +eIpSNT0IDHH1GaPd/b+eaitdvYHBaQ6Iv1htqqc3PMo2zN+m4X//qQgu50RW07Pe0sQ
         A/3h2pFhyq2q4Q0gxNyxlwE6JCRAYQnEY8ujaAthG9h1Fe/1+3BUbZ3g4o5Xwc3/CcEf
         HoNEBWjpSFlCFpkWJWUmgujGvMGQxzWCZAKHMu3JPE3ObtVOJAZZUtEhu6Dtg29hHCzR
         NfOY3u/jUvqx84TXtbW7yAq4ys0G6/ZiLaXoaYzHrRK6KDqTwPIzK/WR0Dna37kKJ4U2
         5Iog==
X-Gm-Message-State: AOJu0YxwQgyPyWDQZsO2XNieXk9fiMMMeMSth2qUwHVnUqmrja8JZlVp
        Fo5YmHaO4isOtQwLKqdfHJU9YjOibiCdMQ==
X-Google-Smtp-Source: AGHT+IF+n56F/crcXR3VXYV/sH+3egVuaMavWLMNmhpVGT46qzZ23sCD1A5phOdoTLqreV5yBvrgEKoNtjIl8g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:ca8d:0:b0:5a7:ba3f:3407 with SMTP id
 m135-20020a0dca8d000000b005a7ba3f3407mr62840ywd.9.1698427603890; Fri, 27 Oct
 2023 10:26:43 -0700 (PDT)
Date:   Fri, 27 Oct 2023 10:26:38 -0700
In-Reply-To: <20231027172640.2335197-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20231027172640.2335197-1-dmatlack@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027172640.2335197-2-dmatlack@google.com>
Subject: [PATCH 1/3] KVM: x86/mmu: Fix off-by-1 when splitting huge pages
 during CLEAR
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix an off-by-1 error when passing in the range of pages to
kvm_mmu_try_split_huge_pages() during CLEAR_DIRTY_LOG. Specifically, end
is the last page that needs to be split (inclusive) so pass in `end + 1`
since kvm_mmu_try_split_huge_pages() expects the `end` to be
non-inclusive.

At worst this will cause a huge page to be write-protected instead of
eagerly split, which is purely a performance issue, not a correctness
issue. But even that is unlikely as it would require userspace pass in a
bitmap where the last page is the only 4K page on a huge page that needs
to be split.

Reported-by: Vipin Sharma <vipinsh@google.com>
Fixes: f2928aae8b9a ("UPSTREAM: KVM: x86/mmu: Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f7901cb4d2fa..6aa966631cab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1382,7 +1382,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
 
 		if (READ_ONCE(eager_page_split))
-			kvm_mmu_try_split_huge_pages(kvm, slot, start, end, PG_LEVEL_4K);
+			kvm_mmu_try_split_huge_pages(kvm, slot, start, end + 1, PG_LEVEL_4K);
 
 		kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
 
-- 
2.42.0.820.g83a721a137-goog

