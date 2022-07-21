Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DD557C917
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbiGUKgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 06:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiGUKgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 06:36:09 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC18867155;
        Thu, 21 Jul 2022 03:36:05 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b133so1376772pfb.6;
        Thu, 21 Jul 2022 03:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Ym1FB+/JJQNox/gaxXHdeqZtRcvY1gpDzJL3fRppc8=;
        b=QBkmWhfEU8U0o5GNBUv8rEQRlOYAJQ+vTkBO40BEjnLDJlROYBfKQJ2fzGQBlj8a8w
         a06a3ov8Maworp4uiXMcyEcfWOGJM6uGOQ+HoJEiEluHOkxBml3JgLCC5wWzuQ7CDbyp
         biT/kMvdUywg98YTHoetMxYer+lkN7YX8ZJG+7zmesfqFILkOXYs/V2weUwDSJJoW0Yb
         3sXZu2Ry6NSB0FnrrAYkZBi5O0rjmhU1JRY/qvu5g//Z9twsgOBkFVb1JTUZLmX+Isoi
         Gfej0IrjXTIOEFUso7pI8mk380IS+rWpbP4ymtY2AiWZV8MdKaFt74ICHnWsu98hEvDN
         O5ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Ym1FB+/JJQNox/gaxXHdeqZtRcvY1gpDzJL3fRppc8=;
        b=I+iIGGk6z5HDWRUhDQsOZlb3B9SmaeNpHLaeiuYUIqgthuiEChz7+CDqZO8A+cExJw
         x28c5NYZUC2V46P7ZSYXG3UYoVTA9hHMY3jHJaKbHNw9zWF2JVbDNAJpA0tzagPkZzPL
         5CsBxUXpmRuFYh0TtcwDfsTO1Aa9pBxfViJTmlPefEvZaKuOTSSiqTVZizCHdZblIP6K
         KULBOC+W2IN9fId4nH61Et29kilD2gb/FmNCXB8nfC9ao5g7Zt1R9iA5azPuIE2T47Im
         WKhXBBtu7zx6Qi30CL0OOSx9ythqwmhoPBFCBFhe3O2gd46DWfhBaKc3n9zw5pVms85K
         q5Qg==
X-Gm-Message-State: AJIora9UCg557qseC+ykrhXBwmTuB/Cr0A1r9nxEEVxghcgpqcCPhJb6
        lyjPYA1MB0fwYfcGV65QRRA=
X-Google-Smtp-Source: AGRyM1vB9s6zBC9K5Is/MIZjEzvQtPMT3Wb6hEsyvFEVyXHFhrnT+i4vcHnFWgMOj4wj1uZ18D1/IA==
X-Received: by 2002:a62:5bc5:0:b0:528:c346:9632 with SMTP id p188-20020a625bc5000000b00528c3469632mr43099409pfb.48.1658399765341;
        Thu, 21 Jul 2022 03:36:05 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12-20020a65494c000000b00419aa0d9a2esm1161887pgs.28.2022.07.21.03.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:36:05 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 4/7] KVM: x86/pmu: Don't generate PEBS records for emulated instructions
Date:   Thu, 21 Jul 2022 18:35:45 +0800
Message-Id: <20220721103549.49543-5-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220721103549.49543-1-likexu@tencent.com>
References: <20220721103549.49543-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

KVM will accumulate an enabled counter for at least INSTRUCTIONS or
BRANCH_INSTRUCTION hw event from any KVM emulated instructions,
generating emulated overflow interrupt on counter overflow, which
in theory should also happen when the PEBS counter overflows but
it currently lacks this part of the underlying support (e.g. through
software injection of records in the irq context or a lazy approach).

In this case, KVM skips the injection of this BUFFER_OVF PMI (effectively
dropping one PEBS record) and let the overflow counter move on. The loss
of a single sample does not introduce a loss of accuracy, but is easily
noticeable for certain specific instructions.

This issue is expected to be addressed along with the issue
of PEBS cross-mapped counters with a slow-path proposal.

Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 02f9e4f245bd..390d697efde1 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -106,9 +106,19 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 		return;
 
 	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
-		/* Indicate PEBS overflow PMI to guest. */
-		skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
-					      (unsigned long *)&pmu->global_status);
+		if (!in_pmi) {
+			/*
+			 * TODO: KVM is currently _choosing_ to not generate records
+			 * for emulated instructions, avoiding BUFFER_OVF PMI when
+			 * there are no records. Strictly speaking, it should be done
+			 * as well in the right context to improve sampling accuracy.
+			 */
+			skip_pmi = true;
+		} else {
+			/* Indicate PEBS overflow PMI to guest. */
+			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
+						      (unsigned long *)&pmu->global_status);
+		}
 	} else {
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 	}
-- 
2.37.1

