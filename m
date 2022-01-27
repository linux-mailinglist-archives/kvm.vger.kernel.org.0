Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDE049D8CC
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 04:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiA0DJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 22:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiA0DJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 22:09:05 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C62C06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:04 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id ik14-20020a170902ab0e00b0014c84153eb0so264212plb.17
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y8xiYhpGFxFKO0m5kKEQAv7sJcYQ8XNaG5VWu+Ph1Do=;
        b=FEdpoVYgU4JntAof5I9WPwlqD9ZAVq8CUvLK6LaYoB1EHNTpqXFRq12cfq0POmb7u4
         iwYEykWf5MFxuGpvTqbIeaHJmgchKLL9KC1XEH+L+9QbWZJDbn3bZc8H3/u00ZPHtr0X
         VuRcbdSQdY18NlDVx9MBPJBs/5uX5ghdFrbf4hHJDui+jCFIRSYmq3J+/k2aAAZQ2crs
         x98ADrn7phtxBIpgPUpS+kmW4QqRruyi9+Wrds4PZGFQa3+cEBJTeyV1aUaSgBE6VrRr
         ui92v01imlYes9h9PEykIb9PDmtvZK5kxw/IFLpZcaPVIrnzb6DRfnLa/aXe2eLRHe0a
         qJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y8xiYhpGFxFKO0m5kKEQAv7sJcYQ8XNaG5VWu+Ph1Do=;
        b=PF8ANe5rtOu8bvWdjHyj51lT1seOaiTdYhlOy558s3BsqFUHTJLYdToWc++K6skBA8
         vV9YuFfLlKLn5f0lqerLH2DDoLtcmWC2jsAujtDkllsy00t+OBcC6CVcSc4/GGaWr51s
         Oh8EXgTdb4UrMP3dkGJZJ8B1+4zedg6HGara2PdftGRglKGN+LgfcLKRTo3EZ5sEkEDD
         gfNWb+mhz7gXEdgjAckejTmo1q9Z45xI4ZuFHOW103J+ZpoTl5xeSQw/U9ZTZeG7K2ku
         qTRXN8ZZBkXwXbJ/L/aSLH6OWN/1TZN5fpZJ+cQSH2mk5Z7+0pCvLf6b5Zw4JBk9+T2Q
         tQbA==
X-Gm-Message-State: AOAM531UXnSO+rlWeGD3sJPNr54BrwW5/AFlQ730BayqGzcluRE8DNsk
        EMaOXL2JMDvLP0TXwlvvzrgf6KRuDGnkChdIrzGnZWTDZaVxo2VQD3NX7sop8vS4s7lqk4wonEQ
        Nc5ZkSK+sYbQXsV7OnjcIMObHu+PUnr/Ot16BhIyUDuJCu/UFrTm8zgwRbjO5BwM=
X-Google-Smtp-Source: ABdhPJxmaasoGq2r0NV2rJ2gM2vKa93DMcKl2L+uSImOPLZd8TXUisygF0ba4SClaxCVIoaZZ4OxxQkMcxetyw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:d943:: with SMTP id
 e3mr1310151pgj.427.1643252944210; Wed, 26 Jan 2022 19:09:04 -0800 (PST)
Date:   Wed, 26 Jan 2022 19:08:54 -0800
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
Message-Id: <20220127030858.3269036-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 1/5] kvm: selftests: aarch64: fix assert in gicv3_access_reg
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The val argument in gicv3_access_reg can have any value when used for a
read, not necessarily 0.  Fix the assert by checking val only for
writes.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 00f613c0583c..e4945fe66620 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -159,7 +159,7 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 	uint32_t cpu_or_dist;
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
-	GUEST_ASSERT(*val < (1U << bits_per_field));
+	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
 	/* Some registers like IROUTER are 64 bit long. Those are currently not
 	 * supported by readl nor writel, so just asserting here until then.
 	 */
-- 
2.35.0.rc0.227.g00780c9af4-goog

