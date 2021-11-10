Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95DC44CCBC
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhKJWdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhKJWdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:07 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2EBC061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:19 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s22-20020a056a0008d600b00480fea2e96cso2742010pfu.7
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FRB6mm7PujoNC1Ip5uFqQse8luP5YPrMmL6VDyk5GCE=;
        b=Nt5BR3PiOgQTw8FUcX5skE2ch2lPLxQWVTBrDMy4YFLGVgQYZag+CKculiu8sqrIfL
         DdobjvG46z80R2cYmz8B0PcUayjlB/PhMaYxLLSlSWl92Og7lK9BU2+InmmStyUjz7ae
         mu4PD2iilAOO5bTrtvN9BT9iwgj9rxiV22MQQqWXEhJ6Hkg2hM1vfgZg42wFeroYe9iq
         VxfIG3SAo5XZHo8FmgYOkuunLEvsADqvNd4jak+eDW5DNggcXceHLAeTxnzMHKu12qg+
         60gSIOxPDC9fPUFv1x8/bA0/ejnnZML2Bjq+2dR9r7JlD63lEoGp/xvimaPcc0HeIpnR
         fqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FRB6mm7PujoNC1Ip5uFqQse8luP5YPrMmL6VDyk5GCE=;
        b=jZbQxJAv6N884QAIN4KA/CuafxCWUadj9ibAHh09a4xenlt7i9ElDL2VPsrP5anrt4
         fl+TYSKB8JwKGDfU8ktghE538w4TQbXq9OYxXAuBmkr/2CpXwPnqDLiMJHV06L4KiS7C
         u5BPyyKRgAs7sXVDl3gCpMicSnP05Do1V+niIyWV8kjOQI/UpDU5Qg5m9tc5jsqqp0e7
         GTM+07NFhvoKQCaezb7ZFDAoGMNVCXYB28GWyfrLccqswHJ98xy3UNiiYLUbFkI6N3EE
         tIhtPZvNjWYmJ++/4vKU+mZrYEyz6qGNhOmPEfIQFQz900ZBDhuAcYvrx9hBDxOa8Efp
         f6+w==
X-Gm-Message-State: AOAM532KYL7XUB+swTo5vW8qnC8Yls+1Wshphg+pLtDqrxiFTL/6Dr+Z
        cHaZmY6BaOPJqa6YUZ4NwbM64622vurl
X-Google-Smtp-Source: ABdhPJzkseJVP2CacQrpdbltO1iscfhno95GIazSs8qQiDiZsu7BWitWeqFF2GfZtoXwDIwG/N18FYwEt/RS
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:902:7086:b0:143:6ba3:9b27 with SMTP id
 z6-20020a170902708600b001436ba39b27mr2875988plk.60.1636583418880; Wed, 10 Nov
 2021 14:30:18 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:29:52 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-2-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 01/19] KVM: x86/mmu: Fix TLB flush range when handling
 disconnected pt
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When recursively clearing out disconnected pts, the range based TLB
flush in handle_removed_tdp_mmu_page uses the wrong starting GFN,
resulting in the flush mostly missing the affected range. Fix this by
using base_gfn for the flush.

Fixes: a066e61f13cf ("KVM: x86/mmu: Factor out handling of removed page tables")
CC: stable@vger.kernel.org

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c5dd83e52de..866c2b191e1e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -374,7 +374,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 				    shared);
 	}
 
-	kvm_flush_remote_tlbs_with_address(kvm, gfn,
+	kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
 					   KVM_PAGES_PER_HPAGE(level + 1));
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
-- 
2.34.0.rc0.344.g81b53c2807-goog

