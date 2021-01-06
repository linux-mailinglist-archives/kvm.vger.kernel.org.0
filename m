Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083272EC39C
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 20:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbhAFTAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 14:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbhAFTAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 14:00:37 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C67C06134D
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 10:59:57 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id o23so2240808pji.9
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 10:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=dDiuE/L+TEOVkofWeADZyQOWx+prBVUG+hG/zE7qjqw=;
        b=sxBZ/PNfezx3O5EO5q8uIXj23Iiuw2N5oK1j8hRxd93uewJtpVeV1h4vS1cObRAiPf
         9c9/eilpVtkkzOH+lKQriRvEm5l4a1+HhItCQJm81G6gc91KjUpcOyyqj5Xcbrgkq1S8
         Xtc2riJFLYE/c+yMu0gaIZNV+hZA2SvuWgrrxivZJrsGil1fHPbdzPMbyydDm2oLYYFi
         GXTfnwLBdzEPFex/ZpP3xhpJ8pSInWKT91K4DIiofyjy5DKAAzYvIeUw/E/zbTgWjW+6
         zUPZJVBR8av0PrGwMPj7NS+VO69Y1X44GSQGvx1+Dp/J8DanZW7+jWLBwBcynyzgyyg+
         3ThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dDiuE/L+TEOVkofWeADZyQOWx+prBVUG+hG/zE7qjqw=;
        b=VlohtpVQrkwi2D6BFm10ctBDeNz67RZCUQ15YOyzrkihJ9M24g1IvvL1tkvT85K1GP
         5E95YdaXLVkjtgAl7RXepKIPEvAqHBFPpe9F9e0z6zBiyz+orqAYxwozMja9y7Q6bWT1
         HUh0gNUt02d3gnUn/4n2LcpaSlHeXONfoA4WWseP6l2kPz1PLCdL6ovgI6mlS8XPX+1p
         yjxAGV4C7GTfuhO9yhxhjyEycxhxmmQw+nkuY9fLB2Pq9Cgxxtvruhb/YOHp8grQCPUA
         vcOQMv0c6CYCkkArRsQ7kfp6ujwpWm0VACbf0Lm2vMsuZcU7FKUVIimAGGrGt3XrlVNn
         j+SA==
X-Gm-Message-State: AOAM531hL+XuW2Q2klAGVxO1ZHAsj1pzMfIhnQzj/13CzReDLGIKXtQ5
        e2XF4LTTcSYLbqFDAu1WI9EYdeuGgN6d
X-Google-Smtp-Source: ABdhPJxPsRsQny1NjyuL9Xk4FVKrWFkNuPbaAv7cxHnPpj8wguRj/YIUx8EXUWlThlt7mr71VYCm+zyYL1Ap
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90a:4096:: with SMTP id
 l22mr5523604pjg.114.1609959596956; Wed, 06 Jan 2021 10:59:56 -0800 (PST)
Date:   Wed,  6 Jan 2021 10:59:51 -0800
In-Reply-To: <20210106185951.2966575-1-bgardon@google.com>
Message-Id: <20210106185951.2966575-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210106185951.2966575-1-bgardon@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v2 2/2] KVM: x86/mmu: Clarify TDP MMU page list invariants
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The tdp_mmu_roots and tdp_mmu_pages in struct kvm_arch should only contain
pages with tdp_mmu_page set to true. tdp_mmu_pages should not contain any
pages with a non-zero root_count and tdp_mmu_roots should only contain
pages with a positive root_count, unless a thread holds the MMU lock and
is in the process of modifying the list. Various functions expect these
invariants to be maintained, but they are not explictily documented. Add
to the comments on both fields to document the above invariants.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 39707e72b062..2389735a29f3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1010,9 +1010,21 @@ struct kvm_arch {
 	 */
 	bool tdp_mmu_enabled;
 
-	/* List of struct tdp_mmu_pages being used as roots */
+	/*
+	 * List of struct tdp_mmu_pages being used as roots.
+	 * All struct kvm_mmu_pages in the list should have
+	 * tdp_mmu_page set.
+	 * All struct kvm_mmu_pages in the list should have a positive
+	 * root_count except when a thread holds the MMU lock and is removing
+	 * an entry from the list.
+	 */
 	struct list_head tdp_mmu_roots;
-	/* List of struct tdp_mmu_pages not being used as roots */
+
+	/*
+	 * List of struct tdp_mmu_pages not being used as roots.
+	 * All struct kvm_mmu_pages in the list should have
+	 * tdp_mmu_page set and a root_count of 0.
+	 */
 	struct list_head tdp_mmu_pages;
 };
 
-- 
2.29.2.729.g45daf8777d-goog

