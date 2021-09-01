Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB73FE54D
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 00:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344125AbhIAWL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244785AbhIAWL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:11:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A152C061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 15:10:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e137-20020a25698f000000b0059b84c50006so1033827ybc.11
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 15:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=o7drrmYkMMXhmENtBmn5mfC88PE2AVZ7fqjwLEMjttc=;
        b=cjfCKLEh4/31w32c+biherhQM6snpdy8qpIgU1dpeHu0TAKAMJNi8HoM/aiaghWEAS
         0flfFqgpvFsxxolar54YhupbXhYgs+9VDhtP8SNuDwd2mCvtJOss97oawfnsp8yN1uhz
         LIjQmv0j0jojsLc1jcWXS8S7f6EE4lZRMdwtQowRBgLduY7aAk+vm5uZscJFwYWLGYqZ
         Vh2qpxPlA9JdZOyYw7RkdZfOmXCr3U6ER/uX1R7ZPxoN3YUtZeJAKtAGwP7U08ZU0qNm
         E9udqgo7AsAYbLhsW2zbFITXM9esdsTEonDEv9XBiUOajzjVlw/bR5eezWItXURg7yrz
         d9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=o7drrmYkMMXhmENtBmn5mfC88PE2AVZ7fqjwLEMjttc=;
        b=Jn3SfvC5/il3QjjBcjxKpSGtf+oC3LFqRoSetWY4dK8wLq7r+oLaOWVwlKtxAsd9Vm
         svCTumt5/VHzq24GsSmwPE1SgJKQwlpB0Zr577jcDGPKKKrF1w8qNdWVDYrPBlwcqZ9Q
         QRxovE70hYVZY2epQb1NU3O7+fsu6q898utUcNL9tplM90B73dH+p0JnvBDwV7zK28Km
         ZhVQhq9LdVxqWf+4mRTZkXLQD12+KWcRZ2gzu7AD7JU5wSAFtqYD9zyL0EB9RGB6BdtZ
         UNJBeyjqNlwhuWuFplXiNRd2oyoyVCkYqJIj1zfEm1QWYUOWajEsdYvKdgx00JqkvrEK
         08Dg==
X-Gm-Message-State: AOAM530MZK3ExGXTPe+pBj/thsm52ShRsiYfoMFseeos5v2TKzjUwFX2
        HMUtn/NGzUheYXt2snPV76qWfSo+TFE=
X-Google-Smtp-Source: ABdhPJzJTSshTtpw3rT5SOCOl+orErewcwP9XqnAnqqITyMAnz8/V1P77jvGa8tq+OEBCWB0dTFN8Xrn4pA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:9935:5a5e:c7b6:e649])
 (user=seanjc job=sendgmr) by 2002:a25:7a03:: with SMTP id v3mr191297ybc.202.1630534228717;
 Wed, 01 Sep 2021 15:10:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  1 Sep 2021 15:10:21 -0700
In-Reply-To: <20210901221023.1303578-1-seanjc@google.com>
Message-Id: <20210901221023.1303578-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210901221023.1303578-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 1/3] KVM: x86/mmu: Remove unused field mmio_cached in struct kvm_mmu_page
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

From: Jia He <justin.he@arm.com>

After reverting and restoring the fast tlb invalidation patch series,
the mmio_cached is not removed. Hence a unused field is left in
kvm_mmu_page.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jia He <justin.he@arm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 658d8d228d43..9bfa46b35201 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -37,7 +37,6 @@ struct kvm_mmu_page {
 
 	bool unsync;
 	u8 mmu_valid_gen;
-	bool mmio_cached;
 	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
 
 	/*
-- 
2.33.0.153.gba50c8fa24-goog

