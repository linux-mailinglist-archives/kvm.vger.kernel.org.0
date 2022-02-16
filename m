Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77EF4B8EBE
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 18:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbiBPRCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 12:02:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236846AbiBPRCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 12:02:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CAF7A2782
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 09:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645030915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dg4CoZxLLQPzYDMCA+YGovkDyZRkYV8T1FDo2veP/SI=;
        b=NWKzh9w58+y2zuxWgVQO5GVeuG5Cr9ejdImSHJ+lOLkBbn0nKTBV/Y/PwI/yCXstX+cGCI
        +h6k6nNJee9veuCN48VpYvdL8zPN8c9COouNOUza5SLIlDpPX2nkPNZD2ULgOQNRS7zqO4
        4JghXesqokgWQnerHS2bPC9PTy6VEk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-t7xm4oSbOIi6oQIjAoBpNA-1; Wed, 16 Feb 2022 12:01:54 -0500
X-MC-Unique: t7xm4oSbOIi6oQIjAoBpNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4960C1091DA3;
        Wed, 16 Feb 2022 17:01:53 +0000 (UTC)
Received: from virtlab612.virt.lab.eng.bos.redhat.com (virtlab612.virt.lab.eng.bos.redhat.com [10.19.152.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 501EE7B9D8;
        Wed, 16 Feb 2022 17:01:50 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [kvm-unit-tests v3 PATCH 2/3] vmx: Explicitly setup a dummy EPTP in EPT accessed and dirty flag test
Date:   Wed, 16 Feb 2022 12:01:48 -0500
Message-Id: <20220216170149.25792-3-cavery@redhat.com>
In-Reply-To: <20220216170149.25792-1-cavery@redhat.com>
References: <20220216170149.25792-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

test_ept_eptp is not explicitly calling setup_dummy_ept() to initialize
EPTP to a good starting value resulting in test failures when it is called
in isolation or when EPTP has been changed by some previous test.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/vmx_tests.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0dab98e..617f9dd 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4714,12 +4714,11 @@ static void test_ept_eptp(void)
 {
 	u32 primary_saved = vmcs_read(CPU_EXEC_CTRL0);
 	u32 secondary_saved = vmcs_read(CPU_EXEC_CTRL1);
-	u64 eptp_saved = vmcs_read(EPTP);
 	u32 primary = primary_saved;
 	u32 secondary = secondary_saved;
-	u64 eptp = eptp_saved;
 	u32 i, maxphysaddr;
 	u64 j, resv_bits_mask = 0;
+	u64 eptp_saved, eptp;
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT))) {
@@ -4727,6 +4726,9 @@ static void test_ept_eptp(void)
 		return;
 	}
 
+	setup_dummy_ept();
+	eptp = eptp_saved = vmcs_read(EPTP);
+
 	/* Support for 4-level EPT is mandatory. */
 	report(is_4_level_ept_supported(), "4-level EPT support check");
 
-- 
2.31.1

