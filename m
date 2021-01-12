Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC812F3817
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406129AbhALSMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406109AbhALSMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:23 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE067C061382
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:07 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k7so3252468ybm.13
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=dO4IqxqIqKBoqVoUqd2f3S75b5ltVbr4dkjOrW+PVUI=;
        b=e5/8YvUL2mRX71HltI4Oq0TkfCluL9Io4FlT3gEHnD5j8uAUpd3DG4yaWnIsvX12gP
         2IrpmG+LwrpAC7swQktZeRnZFVmRXj2WnqLZfng8u2VXO+PkZcTI5FwSlYu3ypwqn0fh
         8sHSCYYnQ8Cfya4lgl9hwlRI7qRtFuFUxKNLOceabKf9D6zmTnak/L4RmfVdqVgumHBP
         R0mOegLGCUoyuK8NL3749Q4sYOKkMkOdiRkFm7O74UAJiOIivXyP8a7DBBv2f7Z7oSDD
         C9w0yDuANFFlp5g55Qk4ZDWMGw6Idki1mTnQLmFVUQ5PThobhi66rXZsEJ9eipmFnF57
         Opxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dO4IqxqIqKBoqVoUqd2f3S75b5ltVbr4dkjOrW+PVUI=;
        b=ThiG7U4FmGYsE11K8jvQ4x2yC29DWtS9vHevLaQd671brHST6I8EhuVN1OcYGbkw1z
         r+zncnigXBGJHRbm+eSGRDSX3bTfsqWPUt7j5IPev9ZgVHN15yJZV2v4tFBGOYRW2wot
         Vu1Sxt8KDBgSVLRk2v2vyA5Sf1T3nZqHIRJ1SDDzTyFr3dWObgbeIuR5JGSW0GqETlKg
         MivlDt/iPi7no+MZQJAoj69vT9sA1rvWnrZ4Y6a7FVJdZqadkMoraKPI8xFlrwtjwTWG
         WmGdzlnKaWtNCBog33VCVFCvsqAZ/i8UXEkAfFO2kSKZDWWck/dCHBBkwjljKX/4Om+0
         GrzA==
X-Gm-Message-State: AOAM5310TC1ABtqPvM1RId6T3vVX9vWP1kcqLnVK3NpcWJHwngbwMHQW
        qwI9ML/67aQsYAE0ghh1USc3pyH6flAW
X-Google-Smtp-Source: ABdhPJyl2Qzej4S94jfATT+lkwvUU2Z5QsbfCIAXjwg1DUK8GrqZaajn6dNog3SgwEww2CH9SuE0eLHB7T2E
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a25:190b:: with SMTP id
 11mr965985ybz.236.1610475066803; Tue, 12 Jan 2021 10:11:06 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:29 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-13-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 12/24] kvm: x86/kvm: RCU dereference tdp mmu page table links
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

In order to protect TDP MMU PT memory with RCU, ensure that page table
links are properly rcu_derefenced.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 87b7e16911db..82855613ffa0 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -49,6 +49,8 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
  */
 u64 *spte_to_child_pt(u64 spte, int level)
 {
+	u64 *child_pt;
+
 	/*
 	 * There's no child entry if this entry isn't present or is a
 	 * last-level entry.
@@ -56,7 +58,9 @@ u64 *spte_to_child_pt(u64 spte, int level)
 	if (!is_shadow_present_pte(spte) || is_last_spte(spte, level))
 		return NULL;
 
-	return __va(spte_to_pfn(spte) << PAGE_SHIFT);
+	child_pt = __va(spte_to_pfn(spte) << PAGE_SHIFT);
+
+	return rcu_dereference(child_pt);
 }
 
 /*
-- 
2.30.0.284.gd98b1dd5eaa7-goog

