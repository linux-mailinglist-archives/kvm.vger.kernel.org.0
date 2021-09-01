Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837FC3FE553
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 00:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344171AbhIAWLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344979AbhIAWLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:11:31 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5C5C061760
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 15:10:33 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h186-20020a3785c3000000b00425f37f792aso952886qkd.22
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 15:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=85Auo0aSzk3nfNcW1bmCTcsI/q3yXEtuah9rbZbe7Sk=;
        b=ROwUg/uj+ZrimUXkCPG5t+P2y2tppRQbkZdxqZrhDxW2EpuA0pWV+iEvA7EJJQKGyJ
         C+GTFyS745S8iRNSo8iXu7f6NZQ4awEGkvMntG+d6PFYsvSrAB3CgRsJnqvhTLr9I4vs
         ZNu/+4bhUhHFv6DcUdKeilS1PHNb4XNDkwa74dBRM5bNDfeKhoaRg38XbLaNvknCdPVM
         BlrbbJsN1XnvVtvv+g1huLZk9bz6EvElWqO5GNj8ZnB2//+4WwMbpYOoQ05f3OcQcRH7
         JQUsM1gG/WAudUBFC18CqNk3AKfsgiTCARxJPzYoimzKjz9V17EgybtCJNKK4Ofo76rp
         43lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=85Auo0aSzk3nfNcW1bmCTcsI/q3yXEtuah9rbZbe7Sk=;
        b=NCJe2UfWhYun3HLcZoSX5+2gYBh376I+lkPCLmKhLyHB5aLWoeaIYcbe2XuTSkB9VX
         LCdpeOElPV8FeagYAwPEZRi0+TiqV2XT6cCyiduShaf+OXOCqaehWGORkrZWkZtf8knJ
         wNodoZf2AGKlrSzV1Omq94tJBMGS91MtFGkvCLYZZHKQ/uVA1FRv7oJYgkSXshjG7Hol
         q/Z35D80B/uWD9WekUrmqMlQVj4Yz7p1nEMIpraC6/PoQLiAy/gN3Fp6WFrnnJ5F4y/w
         ssXZJ9/wwxsI3WyAA0ZIi8J2rsn7bsYpjqp//UmyOuCWVrgNOZPkQVTwgJxwNJEWwxpK
         BkJQ==
X-Gm-Message-State: AOAM530dz3PAofWWIP3oshnkzA6J0qzDpJu/IU6fjsKH8u4Y5qXsl1a5
        8opJ5d4sPut48YAJlgLgErNldk1G0JM=
X-Google-Smtp-Source: ABdhPJwq0TFETxJvrtioq/apVCW5kBI0Q3UH87046kBtvkT8VELH8XWus5fY34hy82yjtG2oTotp25+ZJ5U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:9935:5a5e:c7b6:e649])
 (user=seanjc job=sendgmr) by 2002:a05:6214:acd:: with SMTP id
 g13mr125496qvi.23.1630534233010; Wed, 01 Sep 2021 15:10:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  1 Sep 2021 15:10:23 -0700
In-Reply-To: <20210901221023.1303578-1-seanjc@google.com>
Message-Id: <20210901221023.1303578-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210901221023.1303578-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 3/3] KVM: x86/mmu: Move lpage_disallowed_link further "down"
 in kvm_mmu_page
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia He <justin.he@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move "lpage_disallowed_link" out of the first 64 bytes, i.e. out of the
first cache line, of kvm_mmu_page so that "spt" and to a lesser extent
"gfns" land in the first cache line.  "lpage_disallowed_link" is accessed
relatively infrequently compared to "spt", which is accessed any time KVM
is walking and/or manipulating the shadow page tables.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 4b06e6040e90..cae932afc8d3 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -31,9 +31,12 @@ extern bool dbg;
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
 struct kvm_mmu_page {
+	/*
+	 * Note, "link" through "spt" fit in a single 64 byte cache line on
+	 * 64-bit kernels, keep it that way unless there's a reason not to.
+	 */
 	struct list_head link;
 	struct hlist_node hash_link;
-	struct list_head lpage_disallowed_link;
 
 	bool tdp_mmu_page;
 	bool unsync;
@@ -59,6 +62,7 @@ struct kvm_mmu_page {
 	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
+	struct list_head lpage_disallowed_link;
 #ifdef CONFIG_X86_32
 	/*
 	 * Used out of the mmu-lock to avoid reading spte values while an
-- 
2.33.0.153.gba50c8fa24-goog

