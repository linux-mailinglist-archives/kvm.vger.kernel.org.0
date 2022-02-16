Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2AB4B8EBF
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 18:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbiBPRCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 12:02:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236846AbiBPRCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 12:02:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6D8DA9A5B
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 09:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645030918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvYsYjiMdNO2IwOFNDIRwJN9TVOSF0ptJ2lKgEOmWUQ=;
        b=Bb65U3LezHLsqxvwYoaRpJBC8n23Tj7XPbKtPBRrO6pTAL6xCJPvL9BjLMg6ygkFxFPmg4
        IOYaDm5drmdNbNafvTUZ1erlRnOcfsa7jCMYl/BisHPSUScQQ7IeP+KYOLbQv3blNjOfs+
        rVhpFKj2deRP3wfO4A0gmtH5QDlBt60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-HIlglMb8NzWRgjKfmAhkNg-1; Wed, 16 Feb 2022 12:01:54 -0500
X-MC-Unique: HIlglMb8NzWRgjKfmAhkNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFB3C1006AA4;
        Wed, 16 Feb 2022 17:01:53 +0000 (UTC)
Received: from virtlab612.virt.lab.eng.bos.redhat.com (virtlab612.virt.lab.eng.bos.redhat.com [10.19.152.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 615EA7B9F7;
        Wed, 16 Feb 2022 17:01:53 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [kvm-unit-tests v3 PATCH 3/3] vmx: Correctly refresh EPTP value in EPT accessed and dirty flag test
Date:   Wed, 16 Feb 2022 12:01:49 -0500
Message-Id: <20220216170149.25792-4-cavery@redhat.com>
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

If ept_ad is not supported by the processor or has been
turned off via kvm module param, test_ept_eptp() will
incorrectly leave EPTP_AD_FLAG set in variable eptp
causing the following failures of subsequent
test_vmx_valid_controls calls:

FAIL: Enable-EPT enabled; reserved bits [11:7] 0: vmlaunch succeeds
FAIL: Enable-EPT enabled; reserved bits [63:N] 0: vmlaunch succeeds

Use the saved EPTP to restore the EPTP after each sub-test instead of
manually unwinding what was done by the sub-test, which is error prone
and hard to follow.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/vmx_tests.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 617f9dd..1269829 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4751,8 +4751,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
-
-	eptp = (eptp & ~EPT_MEM_TYPE_MASK) | 6ul;
+	eptp = eptp_saved;
 
 	/*
 	 * Page walk length (bits 5:3).  Note, the value in VMCS.EPTP "is 1
@@ -4771,9 +4770,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
-
-	eptp = (eptp & ~EPTP_PG_WALK_LEN_MASK) |
-	    3ul << EPTP_PG_WALK_LEN_SHIFT;
+	eptp = eptp_saved;
 
 	/*
 	 * Accessed and dirty flag (bit 6)
@@ -4793,6 +4790,7 @@ static void test_ept_eptp(void)
 		eptp |= EPTP_AD_FLAG;
 		test_eptp_ad_bit(eptp, false);
 	}
+	eptp = eptp_saved;
 
 	/*
 	 * Reserved bits [11:7] and [63:N]
@@ -4811,8 +4809,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
-
-	eptp = (eptp & ~(EPTP_RESERV_BITS_MASK << EPTP_RESERV_BITS_SHIFT));
+	eptp = eptp_saved;
 
 	maxphysaddr = cpuid_maxphyaddr();
 	for (i = 0; i < (63 - maxphysaddr + 1); i++) {
@@ -4831,6 +4828,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
+	eptp = eptp_saved;
 
 	secondary &= ~(CPU_EPT | CPU_URG);
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
-- 
2.31.1

