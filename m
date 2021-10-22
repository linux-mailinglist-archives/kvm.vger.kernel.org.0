Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D41436F38
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 03:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhJVBCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 21:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJVBC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 21:02:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF2FC061764
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 18:00:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h185-20020a256cc2000000b005bdce4db0easo2212761ybc.12
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 18:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tfzEGlsF6ydFjGENDgk5t9ypFeU6Wu831H4Ly6n5KZI=;
        b=eqKNefxFjpWs8RvYPeXzjU0dbNjtKAURlt+n7C1E+dDYcU2CXBKq4sNEPdwfHitpbA
         gVtNaYSndbHcp8s8+KQpc8IxdcDgolmAWyOMsQtjZkXeGjxLJffTJmDLAD9/tnVeNd32
         ZOraYVgjj+c1iRewsphawp86ettzfHEwgvKIlahJ+3t7To1RzJ7EhqkETembo4cLnOln
         pG9kOOk+0qG9cxDQuQo9aeQeYy8yI4YZA8aRbUFEYtz3xD2ZAM/4hPuJsjRCsS8ztfJc
         r53LxcIa1xEZgN9LUZ6BsMfsngORw/nECDK4jABkk+4Y+vJZSd7jb0fIB408cFAMk3WI
         3i6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tfzEGlsF6ydFjGENDgk5t9ypFeU6Wu831H4Ly6n5KZI=;
        b=LEn4a04ytKal5DXtnogVAXyXzM6cb91GXgBit/nWBVlHIS7Ebav7YB0PO3qlssD3VX
         QTw3cqUSYDzgHmuRgocc2WgLyZmBWm6ffX+4Uqd5CbCIB4Vc9YQQl9DyekfLVTOhKwU6
         JUB39Y7r9/NoJLuRL6lRhnWJYddr/YGjSJfcHWpeCrIn6z/6X8qt92Uw+6Q7cOH4F2up
         OVgPgc1FbN26nErcEQGtFU3vnr0RyvNdUopAblSw9NDtY4RLr9+J/gtHx0q9hWHfne5j
         rhqTJkVnGY/i+FrSe2gVoj6NY8pXpMyUKfK+TEAzmEdrXjd/RijdmgjQ52q4bZkRzM8g
         7d9Q==
X-Gm-Message-State: AOAM533I3+zUkaYWm1GkQbIReSQLJTTx/vCtho3t8zsRGIA4c5YMdDoI
        uJrDlbZ5VIVP+qs9R3bSEwpcbu2YXvI=
X-Google-Smtp-Source: ABdhPJzZgE7RiGa+gowciszx8dDcOkW5McLZTjeLbkkkAniObK4rJlJduXorUjVGqX0ZnLXHOP8DLiIzo1o=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:db63:c8c0:4e69:449d])
 (user=seanjc job=sendgmr) by 2002:a05:6902:50c:: with SMTP id
 x12mr10492149ybs.139.1634864410395; Thu, 21 Oct 2021 18:00:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Oct 2021 18:00:03 -0700
In-Reply-To: <20211022010005.1454978-1-seanjc@google.com>
Message-Id: <20211022010005.1454978-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211022010005.1454978-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 1/3] KVM: x86/mmu: Drop a redundant, broken remote TLB flush
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A recent commit to fix the calls to kvm_flush_remote_tlbs_with_address()
in kvm_zap_gfn_range() inadvertantly added yet another flush instead of
fixing the existing flush.  Drop the redundant flush, and fix the params
for the existing flush.

Fixes: 2822da446640 ("KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with_address")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ddb042b281..f82b192bba0b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5709,13 +5709,11 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
 							  gfn_end, flush);
-		if (flush)
-			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-							   gfn_end - gfn_start);
 	}
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
+		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
+						   gfn_end - gfn_start);
 
 	kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
 
-- 
2.33.0.1079.g6e70778dc9-goog

