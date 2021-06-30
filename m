Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920C73B8A33
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 23:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhF3Vux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 17:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhF3Vuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 17:50:52 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4DAC061756
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:23 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id c17-20020ac87dd10000b0290250fd339409so2037713qte.6
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MWYYk9Sr8HKYlfAS2NHSlFPP/eKAy+6T+SEm5ULRBgE=;
        b=q+c1Q3WcUvx9b5dZrgTHagM+IM3jIXcjW40U79ExET56cSUFS2poOMLEtjQuvyUa3d
         +E+8lRvLOEA65qIxRru5VVAWYC7AHlPCo0ccaYGaltik+EheZUkoj4ozlE6m0DyPm+cy
         USx/H9SYRAF6d53fZBlbJMnZG2I7phaLYYG8SGGTRNwnmTrkqPt67kgqP4DRrklWs92A
         O6Gq3VcfR7NSwZeb0s72SY4G5Rco/BfjFaCAKxnKBYdSQTW2Vn7hK5ez2LB/WXVroiOx
         owxLPBGQzJTRl8G5KXB/H1CuGmbsRzWAkSd8E4W0ZjAz7QYdvryRME46YHUtcd+qX8tu
         BPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MWYYk9Sr8HKYlfAS2NHSlFPP/eKAy+6T+SEm5ULRBgE=;
        b=ufDWIf1R263wEew9c7squgbQC27ai9vwnGZpLnEfPWKt46tFmKKZ9/qdifivKQwwLU
         eiDhG3boiFwkc+4+2x9Xes1qnlNXwUDkqOZ9OMAnnz4zCPDZnAgEANPMyQ8WyHvEpZX2
         BGbYTg1g1SVR4iP8A7pndpS/Thv84KpjST3tD9/wNFUw2ZIGlJlyPnhV8jd2Xf81KvDi
         DkOrpdmUhnEJv7zmNce/TGLZOcGcI+RGSF4EBULSvHlaP2whdtRgHU7Ogx81VQHzG0VL
         EmNSq7Te9BMQcefs/cMCTibUqUz72Pvsa+HWR277YoPiQqXayVuwxwTz1dV0CZ+YKkmL
         Wk0Q==
X-Gm-Message-State: AOAM531LIIbjVM1F+4GS3as96lh0tUKvrdFWJYB139MMFJ1wS8duvUgz
        BH8nOuXK0KNq4bFr2kC1SS3iC3II2Wq/YT1SMDrSSGnt3czTBO3qNZ9rOnblNkIUoAPSNUzBDwb
        iyzPeSOXf02jECH8YrZHRqJspsRPg4AKrMB35arxQoSZ6B06KaInk6RGWRCumAgw=
X-Google-Smtp-Source: ABdhPJySf6pu89+nwMZgxjcqOXquBVQqyRpYf27QInfPRVYjrw70yBB+TIUWLuKxKlWtGN8YDSkhZYlM74eaLw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a0c:dd8c:: with SMTP id
 v12mr15116890qvk.23.1625089702229; Wed, 30 Jun 2021 14:48:22 -0700 (PDT)
Date:   Wed, 30 Jun 2021 21:47:58 +0000
In-Reply-To: <20210630214802.1902448-1-dmatlack@google.com>
Message-Id: <20210630214802.1902448-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20210630214802.1902448-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 2/6] KVM: x86/mmu: Fix use of enums in trace_fast_page_fault
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enum values have to be exported to userspace since the formatting is not
done in the kernel. Without doing this perf maps RET_PF_FIXED and
RET_PF_SPURIOUS to 0, which results in incorrect output:

  $ perf record -a -e kvmmmu:fast_page_fault --filter "ret==3" -- ./access_tracking_perf_test
  $ perf script | head -1
   [...] new 610006048d25877 spurious 0 fixed 0  <------ should be 1

Fix this by exporting the enum values to userspace with TRACE_DEFINE_ENUM.

Fixes: c4371c2a682e ("KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmutrace.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index efbad33a0645..55c7e0fcda52 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -244,6 +244,9 @@ TRACE_EVENT(
 		  __entry->access)
 );
 
+TRACE_DEFINE_ENUM(RET_PF_FIXED);
+TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
+
 TRACE_EVENT(
 	fast_page_fault,
 	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
-- 
2.32.0.93.g670b81a890-goog

