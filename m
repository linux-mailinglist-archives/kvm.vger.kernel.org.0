Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B3A457B6E
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhKTEzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbhKTEyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:46 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D92BC061370
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:26 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y17-20020a25bb91000000b005f6b36b28b9so257898ybg.22
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ET9uUH9CL1d6Cca0FcVDgzduHiKP9j7LmRDv1gQGbwE=;
        b=BpEuNQ/k9nc/NnkuJPGLVKfzjYSKDe/Hen9rSNiVeablfm+B+HGG73//nyfkG3UjSZ
         r17JcZizr/6XAXQ81H60Mg0IiI2dfSENqicQj3NCDslrcJRE0J9y5srRlYbE2vlbKFg0
         eraxf0IisbM+1/igJjQcCgP9ea4Kokxgz0WztAh9GV31ZvGFw7X5HM/pn0t1WLZ4Puu3
         +Cv/Q0WHVV65CR/vZNAAXRu4hEdmbQJ4psGKjwkznIOC5QfgWCBww5f4bWTDTtXrlW8Y
         quG3v+XJYh1VllvpEEgyBRTjEhKI9dvMbInHCmYzvqmOuq7qUuhyboVvrQzVizmBwV9T
         +g6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ET9uUH9CL1d6Cca0FcVDgzduHiKP9j7LmRDv1gQGbwE=;
        b=HUcCRRSAHWZnpbsr7j2IxATRqnDFjSkz8yFi38Zk0m3IXU37ld+3tHgOc7/GNft8N6
         WFJlWkMP6ijuEjjtitlZm0EYmwOU/qTSF1gZkshULgOIyhtBV/dT+SL/SMLId4cN4tfY
         3BEabmBMtLR6J7u909HCuFt/uXXTNUyW9lEuOW/2ZivJQFJWNY7R3QrBZbdfTPo0EE+9
         EV66sDFa2Xf9bNqVtANnikk+NRxEhZlf5KF6CUPIFFu9Xq88o+YcqWPo6sn0lPw30sRw
         kDCDMKT2F3ya5BR/sbKR/PBkUdjcSwGVlClyS2rjmW/qPQyRv9eplAhiICZKvAzb3UqE
         QsIw==
X-Gm-Message-State: AOAM530EQ+C3c3329vRtYI+ZfgucQSh0RyEOOa2zKJd1hh72qDSkkuHH
        gB8PiYlyylcNWfrkEh5MGBR0O/86oh0=
X-Google-Smtp-Source: ABdhPJybmBN7p+6Bmb7Br2BWJmVRY6KsYOmD1KU4uaw6O9EQUdYhQxFuf6+R/6rDdKViycGF71VKR0+46Pc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:3252:: with SMTP id y79mr42298126yby.5.1637383885848;
 Fri, 19 Nov 2021 20:51:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:38 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-21-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 20/28] KVM: x86/mmu: Use common TDP MMU zap helper for MMU
 notifier unmap hook
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the common TDP MMU zap helper when hanlding an MMU notifier unmap
event, the two flows are semantically identical.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ea6651e735c2..9449cb5baf0b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1112,13 +1112,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
-	struct kvm_mmu_page *root;
-
-	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
-		flush = zap_gfn_range(kvm, root, range->start, range->end,
-				      range->may_block, flush, false);
-
-	return flush;
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
+					   range->end, range->may_block, flush);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
-- 
2.34.0.rc2.393.gf8c9666880-goog

