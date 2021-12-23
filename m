Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2949E47E95D
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350478AbhLWWY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350542AbhLWWYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:01 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D9DC06175B
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:00 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id i3-20020a628703000000b004ba462357d6so3977694pfe.23
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tXPFxhfZ38aogkCCFXR452Gm2Zs80lNiXFSNHzjj/7o=;
        b=p7+PPvAqhGGhQ5aEVa1JNV8vAw5XpTM3/Wrv87i5kJeKFT+kaipf8ekswCgoZUrLbI
         MKVRtcz4gr4Zvo3LqAnyL3cJ3xL5UU9626f0vTktOe4OuXhzBNfo0UfAx0LS7wuR2Mkb
         evpm+bunpn6FMxR8usQd7RrYCnyymmX6HLX7hyRuV4rppD5LGI0q3KrnB7lp4ZYbCN9u
         DnW5BigL08AoHCEnr4bRyG3fPuHzCzEUdX/zj80SrzDoBmGLi3v2F9MjIDFOn4KLRi+k
         ZfYElpUe4qJt8s8Y/wc6NhsSjCv0kP5rtFPkauhbNtJrB6jfwoWYJDtyo0mBs5ivyomB
         6qJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tXPFxhfZ38aogkCCFXR452Gm2Zs80lNiXFSNHzjj/7o=;
        b=Ea8PTaImnHgPds5hsX3XGFeSLDvXNNxgpPEXG/fQGHjV5+jHgEZIBA1fvVTMyl9iF2
         +LomoBgk2kHWfWBqwLJBfb2EoIfGfHPWw82yrIv6Td9x2zRP32XTtp2YpuZZSSaZj0ct
         uDos3u9PlX556C31qCOOy7wVSF9neH0GHfU/7gI4pN0YFqZTlP0ZOkfDIFaNmBAGsd1s
         xZqm1D18kBRRWoOzV1Frhh/Qi6ukzxjCEdbhtn57JE1pzGIhWer2axGhVEPwCKW+XWJn
         /YXyG3ezIluWAZU3AwB5wKBGiU03VDlT2Bttu5S9Wzwaal/+2Qp+8T4+RqkIr77ITZn4
         23lg==
X-Gm-Message-State: AOAM530iT8gqjgku4SYsmKiH76z3crSdV0RGE6T67aMVsTdYiwUA9h7/
        l4Kj+V+92GrHYg/cBbTHzJhAteELeoM=
X-Google-Smtp-Source: ABdhPJxlR40Lrq8sq395rYUNf+4uJtceakhLDojMiy+LdkXIUmsw0PNh1W6lOHb3Ww3/W19kz2FPjVsshCI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:1f52:: with SMTP id q18mr3702466pgm.386.1640298240415;
 Thu, 23 Dec 2021 14:24:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:00 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-13-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 12/30] KVM: x86/mmu: Batch TLB flushes from TDP MMU for MMU
 notifier change_spte
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Batch TLB flushes (with other MMUs) when handling ->change_spte()
notifications in the TDP MMU.  The MMU notifier path in question doesn't
allow yielding and correcty flushes before dropping mmu_lock.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 05f35541ff2f..6c51548d89b1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1174,13 +1174,12 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
  */
 bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool flush = kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
-
-	/* FIXME: return 'flush' instead of flushing here. */
-	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, range->start, 1);
-
-	return false;
+	/*
+	 * No need to handle the remote TLB flush under RCU protection, the
+	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
+	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
+	 */
+	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
 }
 
 /*
-- 
2.34.1.448.ga2b2bfdf31-goog

