Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C773242941F
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 18:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhJKQGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 12:06:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231197AbhJKQGh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 12:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633968276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VE5d3qtVIgtuQN+sYrF0cciRxqV/T6DzbUq3njMBHRM=;
        b=CX3A1B+TAaZNtT3btixP7+Q88DoSWvw1k72TlahDHtUW38t97Av2tYLZK9D1o0Ki7QnG38
        a+XZ8unuLRdQ3t8WNfi6FbT5OxWAZRxaYvZ6hbltrXYqW004InB/+zriydAP7uiYX3moWD
        LEtXlggYC6SpH2HyScJo8LQkXZi9ROg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-KyYlGzIfMn2nw3jZ5Kjr8w-1; Mon, 11 Oct 2021 12:04:35 -0400
X-MC-Unique: KyYlGzIfMn2nw3jZ5Kjr8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EB3319253C0
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 16:04:34 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B93810023AE;
        Mon, 11 Oct 2021 16:04:21 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests] arm64: gic-v3: Avoid NULL dereferences
Date:   Mon, 11 Oct 2021 18:04:20 +0200
Message-Id: <20211011160420.26785-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LPI allocation requires that the redistributors are configured first.
It's unlikely that offline cpus have had their redistributors
configured, so filter them out right away. Also, assert on any cpu,
not just the calling cpu, in gicv3_lpi_alloc_tables() when we detect
a unit test failed to follow instructions. Improve the assert with a
hint message while we're at it.

Cc: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/gic-v3.c       | 6 +++---
 lib/arm64/gic-v3-its.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index 2c067e4e9ba2..2f7870ab28bf 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -171,17 +171,17 @@ void gicv3_lpi_alloc_tables(void)
 	u64 prop_val;
 	int cpu;
 
-	assert(gicv3_redist_base());
-
 	gicv3_data.lpi_prop = alloc_pages(order);
 
 	/* ID bits = 13, ie. up to 14b LPI INTID */
 	prop_val = (u64)(virt_to_phys(gicv3_data.lpi_prop)) | 13;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		u64 pend_val;
 		void *ptr;
 
+		assert_msg(gicv3_data.redist_base[cpu], "Redistributor for cpu%d not initialized. "
+							"Did cpu%d enable the GIC?", cpu, cpu);
 		ptr = gicv3_data.redist_base[cpu];
 
 		writeq(prop_val, ptr + GICR_PROPBASER);
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
index c22bda3a8ba2..2c69cfda0963 100644
--- a/lib/arm64/gic-v3-its.c
+++ b/lib/arm64/gic-v3-its.c
@@ -104,7 +104,7 @@ void its_enable_defaults(void)
 	/* Allocate LPI config and pending tables */
 	gicv3_lpi_alloc_tables();
 
-	for_each_present_cpu(cpu)
+	for_each_online_cpu(cpu)
 		gicv3_lpi_rdist_enable(cpu);
 
 	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
-- 
2.31.1

