Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440192F3814
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405554AbhALSMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404494AbhALSMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:12 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968EEC061575
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:01 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id 98so1970582pla.12
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=W0JHfjmfnxHKf2KI8mDZYKQfzNwrieJpg4TDviTJuJA=;
        b=OZR2XS2wu1SIfSOY7z9UqFZW6+1Ao4td++fjUL/YO0IpVbUC8TW7X8LfQv20YCjHZc
         jTNW5MV5uqC1dSRZUkTaO7IXSG8sBQAGIcrabx16Nw2I18yXHS2/J9Q6J83ay93xEott
         3fTyxv6mLtQvMzdx5e+s8wYklZKZ49NhTOP/Tt47BLJCdnxDOsmGNDFDFc+fVL7wPp+J
         5dsiPi5J7zTNwkhBDVlvqJZXBdQOyM2N8jp0b3LVSgBLdSxwhJjhgoNWGrpqeFiG2Bmg
         JVLq01gBFKyooNNabQ28AP6AxcB0LQoQoxqVQ0JwsHR7F65da4Y/J9xgTQeCInCyh63R
         fnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W0JHfjmfnxHKf2KI8mDZYKQfzNwrieJpg4TDviTJuJA=;
        b=StxCE9TVPTc9caqikSBIhF2PBRlF+gvVLg+4kXujq3KLhwC9xK1YmUq9LuTS41ZlSF
         APChGRqQ/XAVjcpGWgqCdYU2LzvxgdxCujwmPxxPL92FGCbpR8S6rYYHXXv3oJYy/ESC
         wvLp2CM+hS0g8CP5pwTAUo2txA5xzta4mSSc/KwXpGSR8rC6GQWI2C/XZsNZ6S8dNUOr
         drlbP7Ge1hixbcf3FHATP9xXe30nAdttLZ0diJCoCtpstlAZBAK2DZJnw/clP14b/tJQ
         fTmFZK0/lhldUBA3g0zmbhx67elssmzG85seqEn4s9+X0KVjCHS3ZgAC5QyEkV8yceBR
         mPhw==
X-Gm-Message-State: AOAM533jCDs47/3wF4eZ57Z81K2qoiacpO6MzJU5t8nxF4LMOEYUGizU
        XoloVkMBVANQMY9F+z8HTkp88YMVDZGx
X-Google-Smtp-Source: ABdhPJwW40lcFfs/Thl05pWnSw40XLyYUcm72yWABZV24LMePwMOXTV9j9umbwRl2OuKGbF6tDxbT6+LVNR9
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:724b:b029:de:229a:47f1 with SMTP
 id c11-20020a170902724bb02900de229a47f1mr427024pll.10.1610475061143; Tue, 12
 Jan 2021 10:11:01 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:26 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-10-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 09/24] kvm: x86/mmu: Don't redundantly clear TDP MMU pt memory
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM MMU caches already guarantee that shadow page table memory will
be zeroed, so there is no reason to re-zero the page in the TDP MMU page
fault handler.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 411938e97a00..55df596696c7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -665,7 +665,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
 			list_add(&sp->link, &vcpu->kvm->arch.tdp_mmu_pages);
 			child_pt = sp->spt;
-			clear_page(child_pt);
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

