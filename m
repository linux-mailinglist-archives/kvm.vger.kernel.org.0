Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEF74B8EBC
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 18:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiBPRCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 12:02:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236457AbiBPRCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 12:02:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B28DA9A5B
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 09:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645030912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aNK6kHGv1DnuRhY6Dpkk6jcBuWgolRzua02QUtt8Q2M=;
        b=CGhs1/FxpoPwrytXDuQVxOcYqNqBQ/P/8Bijhzf7za1RQNtAgPDpZ6Mt/r2xrhNSwp+IRf
        M69QSNzEYDb0HlUjt1XljqB4M/B8a/BgSj6zfzxIQpqrdfLlHVmc9eCnqGYuN285TMm7Xz
        S1kvd0to+XoUSnAW6zAS4FOzVOms/Os=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-_9bY_-vyOmiaWztPOBZBMQ-1; Wed, 16 Feb 2022 12:01:51 -0500
X-MC-Unique: _9bY_-vyOmiaWztPOBZBMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3635D802925;
        Wed, 16 Feb 2022 17:01:50 +0000 (UTC)
Received: from virtlab612.virt.lab.eng.bos.redhat.com (virtlab612.virt.lab.eng.bos.redhat.com [10.19.152.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB4C87B9FC;
        Wed, 16 Feb 2022 17:01:49 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [kvm-unit-tests v3 PATCH 1/3] vmx: Cleanup test_vmx_vmlaunch to generate clearer and more consolidated test reports
Date:   Wed, 16 Feb 2022 12:01:47 -0500
Message-Id: <20220216170149.25792-2-cavery@redhat.com>
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

In cases when xerror is 0 ( the test is not expected to error ) and
the test does error we get a confusing test result as the vmlaunch status
is based on !xerror:

FAIL: Enable-EPT enabled; EPT page walk length 24: vmlaunch succeeds

This patch also eliminates the double call to report per launch and
clarifies the failure messages. New format suggested by seanjc@google.com

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/vmx_tests.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3d57ed6..0dab98e 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3392,14 +3392,21 @@ static void test_vmx_vmlaunch(u32 xerror)
 	bool success = vmlaunch_succeeds();
 	u32 vmx_inst_err;
 
-	report(success == !xerror, "vmlaunch %s",
-	       !xerror ? "succeeds" : "fails");
-	if (!success && xerror) {
-		vmx_inst_err = vmcs_read(VMX_INST_ERROR);
+	if (!success)
+	vmx_inst_err = vmcs_read(VMX_INST_ERROR);
+
+	if (success && !xerror)
+		report_pass("VMLAUNCH succeeded as expected");
+	else if (success && xerror)
+		report_fail("VMLAUNCH succeeded unexpectedly, wanted VM-Fail with error code = %d",
+			    xerror);
+	else if (!success && !xerror)
+		report_fail("VMLAUNCH hit unexpected VM-Fail with error code = %d",
+			    vmx_inst_err);
+	else
 		report(vmx_inst_err == xerror,
-		       "VMX inst error is %d (actual %d)", xerror,
-		       vmx_inst_err);
-	}
+		       "VMLAUNCH hit VM-Fail as expected, wanted error code %d, got %d",
+		       xerror, vmx_inst_err);
 }
 
 /*
-- 
2.31.1

