Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024E233CA07
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhCOXit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbhCOXiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:38:16 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E10C061762
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:38:16 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id o70so25540811qke.16
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bVFbFclWH6TVYcwCc+4Ci62XlhbttvVSTzGI6/A6UWQ=;
        b=bnmsw1QoRPS3s1v5bLuw2O+C1XzhjnLkvJZUHsa6fsbxPrVE7xckFD+pctBDSa8UJt
         YUTztapQGgjjwidq0KXl5UhkhBLOpJ3Vd13vu8+qDuerXA+zT0v8TvvH/Ocztju7/3+t
         24IYgEXsan4t7lO/9liC0yb4s3lghkEi+/gt7HE8yYE5LY6YgSwEBKosuUtU7LaBYlBx
         WMUPDSrcmql1hyxO1REX18EA8HXV6A+yAvYiNO7MXrvOs/U7XYG+5sY/l0dQv2EeT4UH
         oJgXt3eZVSfrw1xRueBaqMQuhzGmrnwbirr7Sx7+vlJ7l6LZxwnX+SyMV19mCEDCssfn
         wxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bVFbFclWH6TVYcwCc+4Ci62XlhbttvVSTzGI6/A6UWQ=;
        b=Deb0vaw+Mh4piuksPDnjUFST2SyvsFu7u1cmLW3BQW4dCENZfwq9LtWtNX8uiBFym0
         ZdX+jjg2omu1Uq+5W+Dwp1JmqMfrMY4KEACxCQwfeoLeZkKU+GUK40+R2CI9Fbb1M1NL
         8BDNqLQjPVooUak4s7H6EmH5VmTQwl9hxRAGznx2ysJ6v9/MPZEWfhSvejHOA/0MxsUa
         Ws77G8xVS15iRKmwC7TFezmyWq102JrkD5OMcjr8GdQ9LfHlDwDcqDhgzpIV4CLP9+Ha
         E7Scz7X1J1TsojHuSXc+oV0s/GwQdRO4JRYMeV6K+3c6ItLhCGirNVc0Wm7q5VmbgBbX
         tEpw==
X-Gm-Message-State: AOAM530bxTARhcEg6UgZdUGbbdQbROUMEpI4kaVr4W0SjvorbQkFYWm8
        YGQ0vE4vSQwJjfBukIiaO+8xxgSQkE3l
X-Google-Smtp-Source: ABdhPJyl9fl0/XiZ1Ci+Juu9xR/Oj+P6JLoVt2VTtmcqgs2461zw5PNZ3kkWaevlIWn7QJ6rL4eqGk0kyUaW
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:888a:4e22:67:844a])
 (user=bgardon job=sendgmr) by 2002:a05:6214:2623:: with SMTP id
 gv3mr12868051qvb.35.1615851495631; Mon, 15 Mar 2021 16:38:15 -0700 (PDT)
Date:   Mon, 15 Mar 2021 16:38:01 -0700
In-Reply-To: <20210315233803.2706477-1-bgardon@google.com>
Message-Id: <20210315233803.2706477-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210315233803.2706477-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v3 2/4] KVM: x86/mmu: Fix RCU usage when atomically zapping SPTEs
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a missing rcu_dereference in tdp_mmu_zap_spte_atomic.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index db2936cca4bf..946da74e069c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -543,7 +543,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * here since the SPTE is going from non-present
 	 * to non-present.
 	 */
-	WRITE_ONCE(*iter->sptep, 0);
+	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
 
 	return true;
 }
-- 
2.31.0.rc2.261.g7f71774620-goog

