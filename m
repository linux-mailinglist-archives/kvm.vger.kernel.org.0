Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99584AD902
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350236AbiBHNQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356186AbiBHMWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:22:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D4C3C03FEC0
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 04:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644322919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HqzNxaGM36JoPEAx/atp62YyCvUTyjd1fhGLAv2y2rI=;
        b=LytC25Zfg+v6/xRQr0H5+oswrt1JNg7vRhnRzQIjyNDOrEOoLN17KN7hFyWH19mdPo5NYq
        N9Dnk05SRDfZ95Q+Zv0Bg+IkqRhvAye99E6KnS0B2a4+9LwJcyUO/Uyod/h1rHkbUfPwjD
        Vg48KJQMYkApFyJ3CjV4KGV1V9JaNGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-hXeHZbQiM2miAY7sD3Mlvw-1; Tue, 08 Feb 2022 07:21:58 -0500
X-MC-Unique: hXeHZbQiM2miAY7sD3Mlvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3235F6415B
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 12:21:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3291E7EBF5;
        Tue,  8 Feb 2022 12:21:55 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/7] svm: intercept shutdown in all svm tests by default
Date:   Tue,  8 Feb 2022 14:21:45 +0200
Message-Id: <20220208122148.912913-5-mlevitsk@redhat.com>
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

If L1 doesn't intercept shutdown, then L1 itself gets it,
which doesn't allow it to report the error that happened.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index 3f94b2a..62da2af 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -174,7 +174,9 @@ void vmcb_ident(struct vmcb *vmcb)
 	save->cr2 = read_cr2();
 	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
 	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
-	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) | (1ULL << INTERCEPT_VMMCALL);
+	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
+			  (1ULL << INTERCEPT_VMMCALL) |
+			  (1ULL << INTERCEPT_SHUTDOWN);
 	ctrl->iopm_base_pa = virt_to_phys(io_bitmap);
 	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
 
-- 
2.26.3

