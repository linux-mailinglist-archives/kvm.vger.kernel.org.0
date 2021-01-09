Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6032EFC55
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbhAIAsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbhAIAsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:48:18 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5E4C061757
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 16:47:38 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k7so17298169ybm.13
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 16:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vDh4eKmFYAmn/pACCaUYHAK8byzvJFHct+dqDkZvWfA=;
        b=Ab+7KA0qdYGMnAlMWUILK6GjCUGeaAGIXD1IgpqBsA+n84nWw3Hu9UJnAsDhcSgg/E
         vJOCJ/HYzKN3TK4VsDF1VD7KLG8mLeDQRhDcT/kpC2PCxVmj2Z7uaDzGYH5nX5ZdUMZf
         XpVCD90r9FJ+UE30VWduFe/RfljbpsZsnAfgsv7S0aiICdA3UzSwRxKpPUpuj9e+5Y9V
         6prkzbU2veqaKHV6H7tNxm/EMvVW2ciZFiXMxv65XkiRkO7M3shcIHwtk6Buxg1s6qzM
         ZCQLN2K5UHdNrLG4UL2Ouikn2MEiZVvNbSExcgR501mWeMJRWw3BtRLva4c5x2SnJLr1
         wn2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vDh4eKmFYAmn/pACCaUYHAK8byzvJFHct+dqDkZvWfA=;
        b=fQdRWMSqJLNF1PpDidFy/ub2eUwu+MVjZQw9UnzZnrbiY2ZH8B2dIlI2rmFmKKh5rr
         8DUnUBTNlYS1UZMBu3xtjdsqSG+kJKII5tGOqyfrtfEP1Ab6kaFQoc12We5UqACWHmc3
         5IF+hZnx2gwnOGEuaV6rVUmYt6REZZj6CXJ5528LST+SoqAsGog9bAXCFQZwuLx+Byc7
         ENCNhs+B8AzkINtQppiNlbS7pS30SM9P6c1lkgWg0l+fagTOFWU7uSxXomw3CBpqtw20
         PwflK9obekXeRVaI8TO4qCP1INiPD0ucMjj8nj/2OD83telKNjv8LUWbf3kfqphnaxBu
         djkQ==
X-Gm-Message-State: AOAM5304bhUwz2ZHGlgl3+Brods/eaiCjGvbyUu31GqBscjwAE/VvWxt
        u7lrSgAm6utgmFHn9tDp0Yr0ato9xRg=
X-Google-Smtp-Source: ABdhPJzFpFPedRE22hMJwVQdeGOf/7DAB6URy8FyAahzhV7B7CbCorTQlmBb0br5xFhkKkBa7AoYbUOolUU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a05:6902:6d4:: with SMTP id
 m20mr9411689ybt.434.1610153257450; Fri, 08 Jan 2021 16:47:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Jan 2021 16:47:02 -0800
In-Reply-To: <20210109004714.1341275-1-seanjc@google.com>
Message-Id: <20210109004714.1341275-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210109004714.1341275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 01/13] KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
it will be leaked as sev_hardware_teardown() frees the bitmaps if and
only if SEV is fully enabled (which obviously isn't the case if SEV
setup fails).

Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c8ffdbc81709..0eeb6e1b803d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1274,8 +1274,10 @@ void __init sev_hardware_setup(void)
 		goto out;
 
 	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
-	if (!sev_reclaim_asid_bitmap)
+	if (!sev_reclaim_asid_bitmap) {
+		bitmap_free(sev_asid_bitmap);
 		goto out;
+	}
 
 	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
 	sev_supported = true;
-- 
2.30.0.284.gd98b1dd5eaa7-goog

