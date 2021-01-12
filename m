Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD062F3840
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406028AbhALSMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405515AbhALSMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:21 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20226C0617BA
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:00 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id t7so2037151qtn.19
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=uJIhZwyTggvAIsz1r7Cjfa0SqM+enCeDole0gREFf2c=;
        b=kI2M99CFZuMrZy2Pp6gDd3rhx8uwKAp6t4NbQ8xEzvlxXrEe6lyhpSSaps8IyM4nho
         N++QVOOag0/KeQ+RbSiJD7jJ+lGRDAdEh08SMwjwy58bYGACGJSEsA6ztWoTu6QSJR6T
         bdAZcHbqSlJ6hzu5xSz7LHFKlla+eDePrpeJAuBTKJmI2E7dc8f3EJzYz03+8z2xCbFC
         66o7+BiUOs2LPKXK/xzLkgrjwuhxUehpnJTDEVm8AKAm/7DPziC5+tspyHN0OFyrDPbu
         OPP8UODwyqzbPbR3n2TG1l8vifPwddCUaR0x/NbT1MbT/NE+LuPXF/Vu1pDMLnnF3NUJ
         Fj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uJIhZwyTggvAIsz1r7Cjfa0SqM+enCeDole0gREFf2c=;
        b=lnhp9uXci73WVI+pzdG59cymJCjJYYMKkIlrmSLeDq0Z38u1Ge76GRSplGdUIuicrz
         UvXZ8GOvZUoQPk8uirJv18e37kaMWtB/sFuHmz6seFRXQ1xxuYtmfdn4zNUXx0voxswJ
         0vpEs2Dm6aHd15lVLsXU/hyBlfhdWIGK6HqqmfacSzS4d93Iz7vfyn0Y0m1EbdsVkzIb
         Dv0zBzDCP4D5GGJAMwbAKps0c4zyvIxHPNwLmEHEmvvevxQuvclncY6zTAlElNR3FV4M
         nR5hYqXIBQXbe5VtaHBrRcbJX1J76WYG3H9GaSFZ1kJsyBqAU+91X3pALHd1tICynfUs
         1m2g==
X-Gm-Message-State: AOAM531q9j5Q7j/RwedOBvRWXhwC7+63qjRidXdezj0FPB8r+cVowR/n
        ZWf7My08EiyHWEEWp1N2+dNY/lo4hNIE
X-Google-Smtp-Source: ABdhPJwQUuuKOtixV5Ldw9Q4x8pMIL/6dkmC+Mnk58e2Azlqio5Z+jZ+cPrDV8xvPzyeUT5gPymeTeesiWuE
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:ad4:4e09:: with SMTP id
 dl9mr221822qvb.44.1610475059257; Tue, 12 Jan 2021 10:10:59 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:25 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-9-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 08/24] kvm: x86/mmu: Add lockdep when setting a TDP MMU SPTE
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

Add lockdep to __tdp_mmu_set_spte to ensure that SPTEs are only modified
under the MMU lock. This lockdep will be updated in future commits to
reflect and validate changes to the TDP MMU's synchronization strategy.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b033da8243fc..411938e97a00 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -381,6 +381,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
+	lockdep_assert_held(&kvm->mmu_lock);
+
 	WRITE_ONCE(*iter->sptep, new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-- 
2.30.0.284.gd98b1dd5eaa7-goog

