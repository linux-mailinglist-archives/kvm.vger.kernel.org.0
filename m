Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1566BAF0C
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 12:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjCOLUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 07:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjCOLUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 07:20:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8471B76F41
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 04:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678879089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dKufXWfDgT0CA64z31FmWiaMc4lke7nLK+zVzTewluo=;
        b=NfDH9aPDFjt50HxJrH/m15+JtnUP8Vj8YH3zkof+aAdaJgstk+XkWHlEMMfcX4wnlLhIlt
        BNeed5bMHWwSxfr35eAOmYUB9Ly55ulmfvVGKhzf3WRlNz+hQGEFOrB8Fp+XbHuWimHYUu
        uTudTUrT/7LbBOnKurpQk6zfrmWZrF4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-wDi_qgVLOLa2kntmHkztqA-1; Wed, 15 Mar 2023 07:07:41 -0400
X-MC-Unique: wDi_qgVLOLa2kntmHkztqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D156A185A78B;
        Wed, 15 Mar 2023 11:07:40 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D66272027040;
        Wed, 15 Mar 2023 11:07:38 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 3/6] arm: pmu: Add extra DSB barriers in the mem_access loop
Date:   Wed, 15 Mar 2023 12:07:22 +0100
Message-Id: <20230315110725.1215523-4-eric.auger@redhat.com>
In-Reply-To: <20230315110725.1215523-1-eric.auger@redhat.com>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mem access loop currently features ISB barriers only. However
the mem_access loop counts the number of accesses to memory. ISB
do not garantee the PE cannot reorder memory access. Let's
add a DSB ISH before the write to PMCR_EL0 that enables the PMU
and after the last iteration, before disabling the PMU.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>

---

This was discussed in https://lore.kernel.org/all/YzxmHpV2rpfaUdWi@monolith.localdoman/
---
 arm/pmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index b88366a8..dde399e2 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -301,6 +301,7 @@ static void mem_access_loop(void *addr, long loop, uint32_t pmcr)
 {
 	uint64_t pmcr64 = pmcr;
 asm volatile(
+	"       dsb     ish\n"
 	"       msr     pmcr_el0, %[pmcr]\n"
 	"       isb\n"
 	"       mov     x10, %[loop]\n"
@@ -308,6 +309,7 @@ asm volatile(
 	"       ldr	x9, [%[addr]]\n"
 	"       cmp     x10, #0x0\n"
 	"       b.gt    1b\n"
+	"       dsb     ish\n"
 	"       msr     pmcr_el0, xzr\n"
 	"       isb\n"
 	:
-- 
2.38.1

