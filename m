Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82A63173EE
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhBJXIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbhBJXHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:07:54 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E4AC06178A
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:39 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c12so4250069ybf.1
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GEZo8w0hgK50yVJrGIa5NClbFF0q/1wZWPqztqSAI8U=;
        b=rn5yL60zWHOSQ+4padKHXvkuITHPNRNSNM+Cf+9acwDztaCvEP/GBVQ46b4K61tWUh
         0rBN1xLJTmrJEjlUWrvyxWAHzpYRU+matvsXKhc05IbcvNWPj8T75zjBFATONuPPrZxP
         omSVOmXteiC47KavBtmbXLlzcOdxpao3dOCmu9aeF4UKwlt2bQGEahNFJY4aBRP2PtFc
         rlr6BsK92Pffqxz8x+FWpJtjLmil2U1AXIjWuvO10GvEQ8DFttN4VfIiO+5fHXVjSRjP
         NwL5raeTygbl0rz7OCb3GgcHwErhtvIBEGR9Qc3TDbNsP7D8Sj/4OdNyyeNmRr5kUGvI
         yULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GEZo8w0hgK50yVJrGIa5NClbFF0q/1wZWPqztqSAI8U=;
        b=V17eR4FBZyCHU64SxAS9qb3iOCK5C1sgD2AJPxGEIn6uRAmnIijP1LPBwfH+RUOrbj
         7YRO7My4bIuEov1HpIOrQ3f8/i6cm2CDiFupexrhANVbFaRtWywPGJaGk+MEfreamG9x
         2+H+yc4g4pqyZMhqrkookCHT9D2257waI0g4WN/B2hU0Ir2jViwG/IjZDgVe095C1R9l
         lFk0uhznG1Mly0X7vLwUxfR6saWBygaiHZ5X5L0coxVUXUaY402jhwuexyPv4LrmvsP+
         4LDzEqYl+8G79Ft8DjMAfGM5/45Ir6KUrkzFWIBLPL49/wZx9hGDY9CP5Ju0KK0ZkPrE
         RwaQ==
X-Gm-Message-State: AOAM531wTeiD2VCA20u7Re1wJB/H7ykXxpdZXZwG+JHih5HUH2Fxaie+
        M99wpOtg6ooqxD4m8Sbc/FzWNhU+Xrs=
X-Google-Smtp-Source: ABdhPJyKAtmGiuCuTcqrHgv9sAQanTocQ/PtnpyWOrlk2ZIw5XLV1hGfoeCCdeS0VxjghnW0oJbtesz/eSA=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a25:a241:: with SMTP id b59mr7767318ybi.289.1612998399020;
 Wed, 10 Feb 2021 15:06:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:13 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 03/15] KVM: selftests: Align HVA for HugeTLB-backed memslots
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Align the HVA for HugeTLB memslots, not just THP memslots.  Add an
assert so any future backing types are forced to assess whether or not
they need to be aligned.

Cc: Ben Gardon <bgardon@google.com>
Cc: Yanan Wang <wangyanan55@huawei.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 584167c6dbc7..deaeb47b5a6d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -731,8 +731,11 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	alignment = 1;
 #endif
 
-	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
+	if (src_type == VM_MEM_SRC_ANONYMOUS_THP ||
+	    src_type == VM_MEM_SRC_ANONYMOUS_HUGETLB)
 		alignment = max(huge_page_size, alignment);
+	else
+		ASSERT_EQ(src_type, VM_MEM_SRC_ANONYMOUS);
 
 	/* Add enough memory to align up if necessary */
 	if (alignment > 1)
-- 
2.30.0.478.g8a0d178c01-goog

