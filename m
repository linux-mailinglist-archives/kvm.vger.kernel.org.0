Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A4840B4AC
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhINQbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:31:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229836AbhINQbp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:31:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631637027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qtoBiqvKIa1ntm/IOUGUeV3ZBqN/wXnpYPsNwZcWn+8=;
        b=hKdar0dRk3G4lb4G6Qi/LkPiwRoZdG1RlyP2IZ2vrFtZJtxraaFoFl7YSDVCHnkZzTEEUH
        KO5GF6Q1hbsY2Ss5Kd2WdLK0vBjCzcAWtL2fjqRtPNf8o5IgDEPr2dIYrW8uGfvmF/5G/d
        m4AatDA6pMO5wwRiPJYYE6oh2mx0ke4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-H7FWIBnoPESqbZu5xbq4Mw-1; Tue, 14 Sep 2021 12:30:25 -0400
X-MC-Unique: H7FWIBnoPESqbZu5xbq4Mw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 740471006AA0
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 16:30:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 991E11972E;
        Tue, 14 Sep 2021 16:30:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/4] few fixes for pmu_lbr test
Date:   Tue, 14 Sep 2021 19:30:07 +0300
Message-Id: <20210914163008.309356-4-mlevitsk@redhat.com>
In-Reply-To: <20210914163008.309356-1-mlevitsk@redhat.com>
References: <20210914163008.309356-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* don't run this test on AMD since AMD's LBR is not the same as Intel's LBR
and needs a different test.

* don't run this test on 32 bit as it is not built for 32 bit anyway

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/pmu_lbr.c     | 8 ++++++++
 x86/unittests.cfg | 1 +
 2 files changed, 9 insertions(+)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 3bd9e9f..5d6c424 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -68,6 +68,12 @@ int main(int ac, char **av)
 	int max, i;
 
 	setup_vm();
+
+	if (!is_intel()) {
+		report_skip("PMU_LBR test is for intel CPU's only");
+		return 0;
+	}
+
 	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
 	eax.full = id.a;
 
@@ -83,6 +89,8 @@ int main(int ac, char **av)
 	printf("PMU version:		 %d\n", eax.split.version_id);
 	printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
 
+
+
 	/* Look for LBR from and to MSRs */
 	lbr_from = MSR_LBR_CORE_FROM;
 	lbr_to = MSR_LBR_CORE_TO;
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d5efab0..e3c8a98 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -180,6 +180,7 @@ extra_params = -cpu max
 check = /proc/sys/kernel/nmi_watchdog=0
 
 [pmu_lbr]
+arch = x86_64
 file = pmu_lbr.flat
 extra_params = -cpu host,migratable=no
 check = /sys/module/kvm/parameters/ignore_msrs=N
-- 
2.26.3

