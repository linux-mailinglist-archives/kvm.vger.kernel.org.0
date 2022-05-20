Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1704752F2D2
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 20:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352786AbiETScX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 14:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352770AbiETScQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 14:32:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1BCC3A18E
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 11:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653071532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VnDeD39IvybXHC84Uj1x3dcmPSqV3QgrXgQ76MlDqww=;
        b=NB75HHLDAhTdHGuXNGveig95vAj2GkZ7Dh35V8B326olXUr8q1e8OozMQpLheI553Wlxas
        Afy4gIeJdNGm5GkS67XPYwzIOxM2ydKO69wH2Pyu8X8qtH30lsgGu1REUj+u2KZz+EdGrJ
        lAxb9YEXxCyblHSUqh5ndUz39AqQ0bs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-iuD8Z0jwN-u_R-GzorFBaw-1; Fri, 20 May 2022 14:32:08 -0400
X-MC-Unique: iuD8Z0jwN-u_R-GzorFBaw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F20A811E75;
        Fri, 20 May 2022 18:32:08 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3D9A1410DD9;
        Fri, 20 May 2022 18:32:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     likexu@tencent.com
Subject: [PATCH kvm-unit-tests] x86: do not overwrite bits 7 and 12 of MSR_IA32_MISC_ENABLE
Date:   Fri, 20 May 2022 14:32:07 -0400
Message-Id: <20220520183207.7952-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bits 7 and 12 of MSR_IA32_MISC_ENABLE represent the configuration of the
vPMU, and latest KVM does not allow the guest to modify them.  Adjust
kvm-unit-tests to avoid failures.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/msr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/x86/msr.c b/x86/msr.c
index 44fbb3b..2eb928c 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -19,6 +19,7 @@ struct msr_info {
 	bool is_64bit_only;
 	const char *name;
 	unsigned long long value;
+	unsigned long long keep;
 };
 
 
@@ -27,6 +28,8 @@ struct msr_info {
 
 #define MSR_TEST(msr, val, only64)	\
 	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64 }
+#define MSR_TEST_RO_BITS(msr, val, only64, ro)	\
+	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64, .keep = ro }
 
 struct msr_info msr_info[] =
 {
@@ -34,7 +37,8 @@ struct msr_info msr_info[] =
 	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, false),
 	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, false),
 	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889, false),
+	// read-only: 7, 12
+	MSR_TEST_RO_BITS(MSR_IA32_MISC_ENABLE, 0x400c50809, false, 0x1080),
 	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, false),
 	MSR_TEST(MSR_FS_BASE, addr_64, true),
 	MSR_TEST(MSR_GS_BASE, addr_64, true),
@@ -59,6 +63,8 @@ static void test_msr_rw(struct msr_info *msr, unsigned long long val)
 	 */
 	if (msr->index == MSR_EFER)
 		val |= orig;
+	else
+		val = (val & ~msr->keep) | (orig & msr->keep);
 	wrmsr(msr->index, val);
 	r = rdmsr(msr->index);
 	wrmsr(msr->index, orig);
-- 
2.31.1

