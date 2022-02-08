Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92DF4AD908
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350290AbiBHNQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356088AbiBHMV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:21:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDA20C03FECA
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 04:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644322915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CIGw+zZpVgXOAcn0Ub5iZavubEJfoPdYMKNIlAsa2Y4=;
        b=EtD7sMoiD55L47kgBtkFANTaX0zLoyIg0ggzaX18m6NcxNWxzXSxre9NCIFBmdgf187mmL
        j4SxleHqlKAOS7gubfsLfrt3/gj/zTq4jkhIYD8Y5A68ybGs5wZH4LP+xOgwW6xR0eMpW1
        bsUe1n9VtfH8YGmz65wnZZ9B4pQ4ZiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-Qp-WgZHwPnWe_Fk65NEIFQ-1; Tue, 08 Feb 2022 07:21:53 -0500
X-MC-Unique: Qp-WgZHwPnWe_Fk65NEIFQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBD611091DD6
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 12:21:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E795E7B9E3;
        Tue,  8 Feb 2022 12:21:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/7] pmu_lbr: few fixes
Date:   Tue,  8 Feb 2022 14:21:42 +0200
Message-Id: <20220208122148.912913-2-mlevitsk@redhat.com>
In-Reply-To: <20220208122148.912913-1-mlevitsk@redhat.com>
References: <20220208122148.912913-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* don't run this test on AMD since AMD's LBR is not the same as Intel's LBR
and needs a different test.

* don't run this test on 32 bit as it is not built for 32 bit anyway

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/pmu_lbr.c     | 6 ++++++
 x86/unittests.cfg | 1 +
 2 files changed, 7 insertions(+)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 5ff805a..688634d 100644
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
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 9a70ba3..89ff949 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -179,6 +179,7 @@ check = /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
 
 [pmu_lbr]
+arch = x86_64
 file = pmu_lbr.flat
 extra_params = -cpu host,migratable=no
 check = /sys/module/kvm/parameters/ignore_msrs=N
-- 
2.26.3

