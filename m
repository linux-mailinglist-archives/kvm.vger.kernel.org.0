Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D432F3811
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405419AbhALSMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404623AbhALSMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:09 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E1DC0617AB
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:56 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h75so3231131ybg.18
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6HOAnRul988JJcHPRX8SIpofrQYmL4UmifPvTiFwC5E=;
        b=LmD+Ye0gR0HZbJIPEvD4VMC4cKzk725zV2/I/TjwpnVJLuYfqqLkO0eIEa2hZOetTC
         ZjhPYAo3MAhSjXnYSpfZljfHlU/c9zjss8vB7Vc8RSEnJmeceI4VXTEoaArE+NVbSO58
         LUF7knuZiZ3BTP7c4FYkC9dbj1lDMNOgURs0nNOH2RTWSa6dNSNKsjlznWFVUbWVe8ZS
         Lb1Zx1dstLkNo2eOYo4LCQ5SxK02ud96DUmzsCP6V7FzdI7TdiBzzbDx+GRqg3bHMFry
         hSO0cGIoQLqOoNsUiDsAQjcQonWePyD/XXEyUSLb5StZU+RSVwUpaoajF6NUy0J5EFpa
         GxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6HOAnRul988JJcHPRX8SIpofrQYmL4UmifPvTiFwC5E=;
        b=HGeeYAvJgSKNRedJA3Jbuc3bd3BEpK5tvXhQaANI51xxMD/YCCOrbE4ZcmTHbCwrPV
         PZ7O/CUvfPSUz2MHYHfsRV8NIszmFng4w//vkJuyVEf02+FPHFbQvkBN2oN2e1o4uPcc
         j+AtIMmDOn3I/2cX0BAXckYvlX8YNPxEltrOXQa7qvNdBDFM+r4G5WDN14RvBfrpT/lZ
         aoqt/ITPNY4oViF9XgY6EcckftqDRcAB/yxk+qev5gwBMrNPi1JjcsFZkhsNvXCehOnS
         YZJiavzqO8Ig2qnpFMrMdCwmH3IaP8+GxOq+8xmhbo0HP8EkWAcD1UUG1CGSGDtirndl
         +T2A==
X-Gm-Message-State: AOAM530uNBrvd4U5znwJDYdu+uRIeZM4nBX69nqT8gSCxLLCTDO1+Uby
        QQubuE6i17NNX4Yl7dar8xMSoo0j6Uye
X-Google-Smtp-Source: ABdhPJyu8CadpvpA1fsQat/u/JMloS9CaK7kdDmHf9MbN/B1p2uMNEhZ0ffseqJyFcQP6mrEVPryUpTHf8XJ
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a25:5f41:: with SMTP id
 h1mr975579ybm.159.1610475055930; Tue, 12 Jan 2021 10:10:55 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:23 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-7-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 06/24] kvm: x86/mmu: Skip no-op changes in TDP MMU functions
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

Skip setting SPTEs if no change is expected.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1987da0da66e..2650fa9fe066 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -882,6 +882,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		if (!(iter.old_spte & PT_WRITABLE_MASK))
+			continue;
+
 		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
 
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
@@ -1079,6 +1082,9 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
+		if (iter.old_spte & shadow_dirty_mask)
+			continue;
+
 		new_spte = iter.old_spte | shadow_dirty_mask;
 
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

