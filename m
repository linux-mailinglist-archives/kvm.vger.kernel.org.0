Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B414E47E1
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbiCVU6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiCVU5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:57:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9D23F7C
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CIGw+zZpVgXOAcn0Ub5iZavubEJfoPdYMKNIlAsa2Y4=;
        b=XQ026265X9o5gCDim2EuHseHZaLuHQprRada46HWlUNP8Ey9vh+0xirHTCkVFrVPheBqzv
        M7zmZAqewevNLuefUOPhaw5DfiVg8McWva+rLEQTD9u6U4uXiYxU42W1kDzp35VUPKs+1B
        xQIxi/zM82d+hx0yM4eF4PiNKhamqNc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-5RwCOCTCMHq8TIfUASZnzQ-1; Tue, 22 Mar 2022 16:56:17 -0400
X-MC-Unique: 5RwCOCTCMHq8TIfUASZnzQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DE991C068C0
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:56:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00E08C27E80;
        Tue, 22 Mar 2022 20:56:15 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 1/9] pmu_lbr: few fixes
Date:   Tue, 22 Mar 2022 22:56:05 +0200
Message-Id: <20220322205613.250925-2-mlevitsk@redhat.com>
In-Reply-To: <20220322205613.250925-1-mlevitsk@redhat.com>
References: <20220322205613.250925-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

