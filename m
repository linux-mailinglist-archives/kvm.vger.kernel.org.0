Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E71A487416
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 09:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiAGI0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 03:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiAGI0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 03:26:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03660C061245
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 00:26:03 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso9770512pjm.4
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 00:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jAWQmEyiwo1vMVzdgI77xHxKQLi1aYgS9jZkmo90ZHI=;
        b=c+5gdx0wvxZTh+BJ2PRDcwTsWCl0XBKB5WFj+XJtT4jEoYIjv4DWiCTG7+bFgu7TME
         j4/p8VLakUW2p5h6m3vQ/RKpkRJh6MkF3t9egJ4ugeVDEADGu5GtYSWiryUK8acTF6A0
         ynibTFZ547GW3H9DChQRDtmeXBec8zlwvjmhU+0Snd59YM/9WCLVtXPyPx2Sb1hRaIMF
         sQIZlVNpfRWRblQkvU4uk3RIrsE+k7ZcZT/Bxa6ZYeMW1EsP9dyV3xEKEeBbu+MaxUmV
         DgOUJGHYNstWHctV49M9jeMdUaTdoR4Noo+DzIRsVrT44E3C4n5Emd+zXaZII0VDbUZW
         mDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jAWQmEyiwo1vMVzdgI77xHxKQLi1aYgS9jZkmo90ZHI=;
        b=EVcQYWJn/zM9zWO0YOql8CDOmIrhu75xMRBCmco6ze0aaz/N/JmfM6cYD932NRLmHW
         WNvC/91nhbqUoALhs1EW+xnZnXh9EpdjENhdnE9SUQW8PBQH+t0VgLNS3h3f/sNxGa7D
         kq8fQDUKN47pddmTQqaeQWF9uWllK/SQ3NMlxvIDIjD8rhjwrAOpVfNoTjkUxylTWPNF
         UTmccnEykbWjyqR818d8g9cxkSbgMTO9SriUnZgiunQ2BABTdHQLlcWD+VKdvi2pWumc
         UpRfDMUiP+pEsmIN8SJkVwcxk0SuwRDOmj8DhddjuJyEC5+2WDYewkvSZYdZwPBKcCbV
         kqfA==
X-Gm-Message-State: AOAM532Gis18yNyAH6BMs+qRWnVd//3jRK2CxDYy3I41MuHyqO2WUOrM
        6476zsGh+9iGG61l7YeV6qg=
X-Google-Smtp-Source: ABdhPJzM4D7v0QbRiU9iqshjPjQCnUJzedEgwCyzzrEe74OeVkdsSXljmmh3AIr+tY9XPz25clEAow==
X-Received: by 2002:a17:903:1ca:b0:149:2125:9a13 with SMTP id e10-20020a17090301ca00b0014921259a13mr63097243plh.73.1641543962532;
        Fri, 07 Jan 2022 00:26:02 -0800 (PST)
Received: from localhost.localdomain ([103.81.94.99])
        by smtp.gmail.com with ESMTPSA id q9sm6792629pjg.1.2022.01.07.00.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 00:26:02 -0800 (PST)
From:   Vihas Mak <makvihas@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Vihas Mak <makvihas@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: x86: move the can_unsync and prefetch checks outside of the loop
Date:   Fri,  7 Jan 2022 13:55:54 +0530
Message-Id: <20220107082554.32897-1-makvihas@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu_try_to_unsync_pages() performs !can_unsync check before attempting
to unsync any shadow pages.
This check is peformed inside the loop right now. 
It's redundant to perform it every iteration if can_unsync is true, as
can_unsync parameter isn't getting updated inside the loop.
Move the check outside of the loop.

Same is the case with prefetch.

Signed-off-by: Vihas Mak <makvihas@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/kvm/mmu/mmu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1d275e9d7..53f4b8b07 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2586,6 +2586,11 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
 		return -EPERM;
 
+	if (!can_unsync)
+		return -EPERM;
+
+	if (prefetch)
+		return -EEXIST;
 	/*
 	 * The page is not write-tracked, mark existing shadow pages unsync
 	 * unless KVM is synchronizing an unsync SP (can_unsync = false).  In
@@ -2593,15 +2598,9 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 * allowing shadow pages to become unsync (writable by the guest).
 	 */
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
-		if (!can_unsync)
-			return -EPERM;
-
 		if (sp->unsync)
 			continue;
 
-		if (prefetch)
-			return -EEXIST;
-
 		/*
 		 * TDP MMU page faults require an additional spinlock as they
 		 * run with mmu_lock held for read, not write, and the unsync
-- 
2.30.2

