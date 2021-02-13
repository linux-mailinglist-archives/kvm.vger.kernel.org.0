Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5D631A8FC
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhBMAvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhBMAvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:51:41 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B815C06178A
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:26 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 6so1554687ybq.7
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=i+ZGhrnKuPWM2EUTyjRTEqFvmRgkb+1SD/2rklmgcTk=;
        b=KqaYODfcV7nggQfaJ4scLLVmaifGfME/RMcIJIdgowvyGEWXW9E8lqApJYsKmfDrlF
         rjLe25VECS2mTpwRLbDq1JHOKHjlQUvkCf0nGaanW2J8XmTGoTHrQGgc1pu19DeG8QdM
         i4EQaOC2+MzIa22bqqVekL/UoA6S6HGSPFnYfPgxaeVK4ZATE/ItsocqH3HJdT9kOlF9
         XsRxpBvtjQunUw4OW98zBktnPUK4Ml4EW+cgBF3AMsaRxVkY9KcVdjSIV6sOEfnkCEjC
         Z0D2mcMiOSjglDyPduEYnkyBwib9myX0ATDli2qavK69zmg/dpL29Y0u/JcAX/gx2z0p
         qgrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=i+ZGhrnKuPWM2EUTyjRTEqFvmRgkb+1SD/2rklmgcTk=;
        b=merExqAe8jTZWJdiwu19BeySBoW63xWBx0JrZgQNjTcGbnUiDI4ATdeOIv51pH0y0z
         Ncm2P5oNsmnRF4elDG+4AxiUIbk0hacaSvLcfXI3Y3UdFNtPjRPCiOd42bVvKnx04Hpm
         WMUftLey2/+zspqkUwyMLKCJ8uCemh/kFd5qltzm3rJykSxCVgtc0XNG6mdCJfO3Fdju
         II6dcChL+SoQ55LpDnLXaCm51PuS5PPnMEoBsokz7OBvMFkdNAiLdq5RpdPZoNCzAhrr
         Pd3DqOYKq24IfsbnTVqQzaihXg5s9vpirrQK65Hf34+nkGFoXcoLzRGlE+zzwnkid4Bj
         QtZA==
X-Gm-Message-State: AOAM533eT/BQtDjt97l5cMp6gkcxzowlvsibZc+HgsmjcOd5Bw3+5RBv
        LPCTwRf7SQFK1AqzbhHCEHmzvMcdVlI=
X-Google-Smtp-Source: ABdhPJydadXiqwiePPV/u2nRZxbP9oNG8qal8CxU4l+Y3inZUDXFtfyb9NoV3cZws6bGobKUJ1RK+HH9dPk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a5b:44f:: with SMTP id s15mr7978526ybp.85.1613177425898;
 Fri, 12 Feb 2021 16:50:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:03 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 02/14] KVM: x86/mmu: Don't unnecessarily write-protect small
 pages in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Respect start_level when write-protect pages in the TDP MMU for dirty
logging.  When the dirty bitmaps are initialized with all bits set, small
pages don't need to be write-protected as they've already been marked
dirty.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e507568cd55d..24325bdcd387 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5500,7 +5500,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
 	if (is_tdp_mmu_enabled(kvm))
-		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
+		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
 	write_unlock(&kvm->mmu_lock);
 
 	/*
-- 
2.30.0.478.g8a0d178c01-goog

