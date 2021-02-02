Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FD930CAE6
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbhBBTEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239134AbhBBTC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:02:28 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7210C061A2D
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:20 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id bg11so12606346plb.16
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=7arfRLL2Z2CtnM0YUHBbJ+FLJFgLhV7kQmsV+ql5Wjw=;
        b=I4XvQXp2ht+2a41TenE/roJ1Ett778dW7gHugcfOPCOJRwFKzXH81fcTcsBv2atCd9
         AYPcKfbLDHtPedau0a9TVeDLqDORxZH01r3RoKiBwxAyM8FrDzlNsvMJu8q7pqY8g+et
         4xmVbVRZ8BLTu8bBGlfAfBmH1MLqhoZXHiQocMogRtc/GgebeTKNxUWsPZmHTNInLhd3
         EwH5KJICDoGq5rc2HGa0tM6u3GgbFGSWXSzCFnCrz0dp3uI+unkeBajE55ILXgaiilCl
         FKbtJVgy9le9npYsArei5igdzuUaCSjknWA2xeapzvgej/A6m4+74B3Tn5+BAgLFV0kD
         5euw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7arfRLL2Z2CtnM0YUHBbJ+FLJFgLhV7kQmsV+ql5Wjw=;
        b=MFXqRvqN8x5yNDEUNqQAW0sqjZlRKQBFBV9UyUl6ZOR9H7E52nmfLl12MnMREDtnJW
         9j8SDIg440oPi2Ml/b3d4+j/cw34c6h5wEIvwAeOdptG1Tr09Jqx4idmsG0YtNNwq9au
         BLCoeA/quKk+juW9h4xaFVCxVDxUChjBiLCqVw9YiswfCiOSuNlJE24bC9bF2Jbwg5tU
         TdGRGFq3aL6tD45vW+4RVXqevlUtbOmNzezZ5z+Rb+FwPS1oXZRHPcN+eOb9Miz/HNQ0
         gij/RjOle1ABU2GsFIAj1zXPRU/62LA2v3GK8DzuynV2xYJ/nwkpb4xDngyJLLReS+XK
         yBCA==
X-Gm-Message-State: AOAM532Kv0CgSGJI1ZvoifHzZTABcxVh1V/BgZJphfaZyimomTvcUdKm
        TDzXPxpwBYEGCEKw9N3oL+jlTLSLdr07
X-Google-Smtp-Source: ABdhPJzXNvUKye10Fi3gdAai/uJC9OZeI8HcXCz3jyHrLKGlj9WEWKBgFqLkRaBCXC1/W6Dl77imlc+CAAZX
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a17:90b:1247:: with SMTP id
 gx7mr5877515pjb.22.1612292300509; Tue, 02 Feb 2021 10:58:20 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:29 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-24-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 23/28] KVM: x86/mmu: Allow parallel page faults for the TDP MMU
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

Make the last few changes necessary to enable the TDP MMU to handle page
faults in parallel while holding the mmu_lock in read mode.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b4d6709c240e..3d181a2b2485 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3724,7 +3724,12 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		return r;
 
 	r = RET_PF_RETRY;
-	write_lock(&vcpu->kvm->mmu_lock);
+
+	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		read_lock(&vcpu->kvm->mmu_lock);
+	else
+		write_lock(&vcpu->kvm->mmu_lock);
+
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
@@ -3739,7 +3744,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				 prefault, is_tdp);
 
 out_unlock:
-	write_unlock(&vcpu->kvm->mmu_lock);
+	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		read_unlock(&vcpu->kvm->mmu_lock);
+	else
+		write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
-- 
2.30.0.365.g02bc693789-goog

