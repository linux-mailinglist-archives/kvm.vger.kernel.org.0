Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D70570FB9
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiGLB4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiGLB4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:56:05 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210653A4A8
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id k7-20020a17090a62c700b001ef9c16ba10so6751989pjs.1
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=x8hGnQGu+TvLoNX/lMBZXMk6ueNBJ63tvcwEjiE74A0=;
        b=NpwIJ4rTQn6uFIpOi3K/qjN6ir94/cFp6kvxo+/rzokC7IixIq4YbRe6iqqI6i0iPV
         8VoH51o0XES5Nhdo7ZwOCxrrTOJ7IPQV6uVFCOHgepoZVDkzg/94+5hg4GjDJnZce5Lm
         dzs0Jbz+Gu8ioS0gPIvW5FOxrwNgJr30UtOAU/P7rvIkzz5fBo3LjE5rAJ6cj2nUTR9Z
         U8SVr+wn0hg54CDS1Cc8FSeYrRu7oySeMlY21VQH9rNDuWQUgr4rs8ea0zLtf3gkO2a/
         IeXWU3u4Xzzqu4YPiVeHBwyVnZ56Bym2IDzJzd/wIvdllfG0PqllHDgLgUTtCDd79bKI
         fX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=x8hGnQGu+TvLoNX/lMBZXMk6ueNBJ63tvcwEjiE74A0=;
        b=C17IupuB0Egn8smWiAcwWz/19sFbGVcfKXomyT47Zg67N9gt7b7iLEjubeQgWzWrea
         E7D2GMR1VmmTnhmGmsJhAhNGNcMsGzjOSoHYk5W4HA1pWrDdXlZfXq24gVrgtD9thkXI
         3ScaFS0sr/i/qupEU12DiqvhwGMTIL8Tg8tc8T+NiJs8noAjQWKZ0tsRo/8L9RGq1kqW
         4e9K5hhiVfABvu5coNz93BRRQswVZBEVstHR4iSXXK4mXIHPKM1Tc+6FuOOsY9N66bS3
         QjZRLYm8UDmdjMq5cZ1YKV2zZb8XokdIxtEJv+7ag3bX8IqSVLR+J57iYwYw1L6wrbTQ
         zTDQ==
X-Gm-Message-State: AJIora+l8KKffsHbd2moWkRpZZ5el0YqHQCafMjjKtiBcc2CLoHoyN+J
        jspBV4a9xc8g5un0oOI9YwzQX0KuJLw=
X-Google-Smtp-Source: AGRyM1tVehKyCGq7CmihonY0Z7mBNOc9uJhBx26VsPzpgF14z2+zZ3LBeFfhk3GSUT5o3xfyxevM9thX+NM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:778c:b0:16a:6cd5:469f with SMTP id
 o12-20020a170902778c00b0016a6cd5469fmr21837101pll.102.1657590963692; Mon, 11
 Jul 2022 18:56:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 01:55:54 +0000
In-Reply-To: <20220712015558.1247978-1-seanjc@google.com>
Message-Id: <20220712015558.1247978-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220712015558.1247978-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 1/5] KVM: x86/mmu: Return a u64 (the old SPTE) from mmu_spte_clear_track_bits()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return a u64, not an int, from mmu_spte_clear_track_bits().  The return
value is the old SPTE value, which is very much a 64-bit value.  The sole
caller that consumes the return value, drop_spte(), already uses a u64.
The only reason that truncating the SPTE value is not problematic is
because drop_spte() only queries the shadow-present bit, which is in the
lower 32 bits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f7fa4c31b7c5..2605d6ebc193 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -529,7 +529,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  * state bits, it is used to clear the last level sptep.
  * Returns the old PTE.
  */
-static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
+static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 {
 	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
-- 
2.37.0.144.g8ac04bfd2-goog

