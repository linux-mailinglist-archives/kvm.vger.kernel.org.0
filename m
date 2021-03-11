Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E8F338155
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 00:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhCKXSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 18:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbhCKXRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 18:17:51 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D31BC061574
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 15:17:51 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id da16so16334477qvb.2
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 15:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AxoBB0NhGnhe+D+L5sVMK+GdUudXG/INmmMF914oWWE=;
        b=tV0hnmCWulMFsIisLAiMtfKadjwWmccSr25Mj2NNio4ERe4PSU7RdV9axRNPcqXREO
         QzDbeeCe+XS9y5iQkXOb8Gp4u2dvVW8xryU2q5HRS/f9q4WqtoXX1pGPlcTZceHizTZA
         BB4PjRjUasTTCwpj1xSVPdNgufMeo1Jv7PJgbqwYsLeZw2g4mjRl7US3Ed/sV6cGyuxy
         WUHpPDYbwmlsO190YBidzsaiPhVptf91n+xklkvn7FUeQePqIvdzooRAU30rfMYpgFoV
         tko8SL2UPfXOSrW+hLZxzen1dT24Yg9dT+fbMZeSA2JyzrbjBG6wcGTbCMYZNacq+PdE
         Uj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AxoBB0NhGnhe+D+L5sVMK+GdUudXG/INmmMF914oWWE=;
        b=SgBVX9Fzkvhr+PMdXtrqwWnpceP8YaJJ1Fbk+4Yhe0I+dcflPjQlUYi6Ee6q7TvWnl
         FZ9ITZfTtvnYI+50Tb9pojhubUJOm/r4/aRjGsAnEsvlDKyh5h04yK0mjUxBn8BwMtOK
         PJ5RS4KJpT9rQ/SZ5pfFNMJ5E2xyDwcoh2mUKWOechnMbEbXtg1YmupQSQ9FOyTUPFCp
         js3egeuB+HxiyO8yoHnGdUkOewOPQ2XWWA/5Y0G/fJfDNbt26catb2Vc7GnKLu9d7f9e
         60nvvjbaqEFoeld8tNKA4KWyrrbnSR7R6RV94YbYI7kJ/14oxcQzc/gqhvWwLHVjpYBJ
         PLLw==
X-Gm-Message-State: AOAM533cv5jcBBRGkCitRyQurDDlaGZMBhnkmHpkM+kdzwJ2RF+69w+B
        FWG0F9mjaTicP1e4kZ8S5YbmMt4RkzRB
X-Google-Smtp-Source: ABdhPJxKfRDBF4vpCW1d/v+gDvm9EvkTeBEqeDYcfg+fH48GtcYfPkfKEHXH5oumo6ocbbv0gsB5JiCzK02v
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b4d4:7253:76fa:9c42])
 (user=bgardon job=sendgmr) by 2002:a0c:e385:: with SMTP id
 a5mr9900907qvl.12.1615504670412; Thu, 11 Mar 2021 15:17:50 -0800 (PST)
Date:   Thu, 11 Mar 2021 15:16:57 -0800
In-Reply-To: <20210311231658.1243953-1-bgardon@google.com>
Message-Id: <20210311231658.1243953-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210311231658.1243953-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 3/4] KVM: x86/mmu: Fix RCU usage when atomically zapping SPTEs
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a missing rcu_dereference in tdp_mmu_zap_spte_atomic.

Reported-by: kernel test robot <lkp@xxxxxxxxx>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6c8824bcc2f2..a8fdccf4fd06 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -532,7 +532,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * here since the SPTE is going from non-present
 	 * to non-present.
 	 */
-	WRITE_ONCE(*iter->sptep, 0);
+	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
 
 	return true;
 }
-- 
2.31.0.rc2.261.g7f71774620-goog

