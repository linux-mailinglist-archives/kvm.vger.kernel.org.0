Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDABE457B8B
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbhKTEzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbhKTEyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:43 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8BEC0617A2
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:13 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p16-20020a170902e75000b0014271728fd6so5700026plf.18
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9UpU4BE6VFo1yV37uGFOyLOiPpm09nWvBtlMWiwFN2c=;
        b=Uu4CsIhMP3+cMa1fhkvrE8BfxHMibIcsUwThV/W74PSvsBKNkgzf3eDebBCnJhnavS
         ARX1Md/3uCA5OsEEZYJXFSHVPvSqgeMkkFJDN2lnWsp2ftADf3+ZVMXuEozWh00mzMK0
         lYaIw8Xc6C8Px2tICCiphBwTYNLTV73WjQk+1aQAe0h4N/EVdlndBrBd8j2brHWpIFRe
         qxyrD+fuTMybPbVOp33wQExUmFNQcdzjbc7c3eKqWzn2CpcYAgZDfcbGZrgyJft4fFrt
         qS6IDfmiT0Z+ZLf168qo4vtcdI9zlC9TvmO9aUQrvQqzu6YnTMkWDc75Wd80nlfow3+o
         q2Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9UpU4BE6VFo1yV37uGFOyLOiPpm09nWvBtlMWiwFN2c=;
        b=xEIUh96B26iJ/A0l2+nc7VgZ9Oc1iTjEbMuWIX/AgFp6c1EQQgLkwqm/ajflVjDDuN
         SiDk/EDXQZozOXYCM0J94iMODzggt0oAXUdwEyRwvYLN9ayzU+cnZ3t9WNh871KFwP0g
         n8Y+ZK1TjroTmsLVUi9KqaSL5Ta7Se2yB/zlY0socoPAWgm58h3dkCF9XOWu9QOCUdWh
         jOmGELIputMyAyQotV0J2w7kYZOCfb+/sSKyiZ+rL/UacEdIeqWi4yDMmPLyL2G9KazO
         5lyNSpWpYvzO8GYJC2kQCqCtWiBClQi5HqQrNyiq+Zx8/0N7K6bYgpskd+BlchykTA7z
         SGdQ==
X-Gm-Message-State: AOAM532ncl5yN1qCEUMaiMg7QsCeQcrFVX/vYWL3QlbaEFaoMEjnH5Gy
        GQFJZNyYTslY7a4OpBkOW9/VMxHOjqg=
X-Google-Smtp-Source: ABdhPJznjPegzC1rG8W9ZRF82xewliW8LitZrqmb/apQMZE5Itj2eER1+glAZ5x+5+M7a2aPuhx3Qq0KrWQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1816:b0:49f:cd0d:b51b with SMTP id
 y22-20020a056a00181600b0049fcd0db51bmr68908861pfa.6.1637383873184; Fri, 19
 Nov 2021 20:51:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:30 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-13-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 12/28] KVM: x86/mmu: Batch TLB flushes from TDP MMU for MMU
 notifier change_spte
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

Batch TLB flushes (with other MMUs) when handling ->change_spte()
notifications in the TDP MMU.  The MMU notifier path in question doesn't
allow yielding and correcty flushes before dropping mmu_lock.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8e446ef03022..06b500fab248 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1182,13 +1182,12 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
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
2.34.0.rc2.393.gf8c9666880-goog

