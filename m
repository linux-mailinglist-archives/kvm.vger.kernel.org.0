Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A25C606457
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiJTPYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiJTPYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68B1AE5E
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=plE5PXqTVXyjNb02TVLSSRdKr0a5q/P979m4Yd3263s=;
        b=S5ZN+hEakDYVUtyfSYSCNnudExSH5G3VKF2y60gMWSxTI/VaQ9i8GqHm/wIg/NnfCn2DbN
        zDwFKlnppiWx5cCricMYGENFzVAVXPVyWqpcQt0Surg0/ATxPWf9qNTOw4n6A9FOhJUl6k
        iw8mWFjA0p1o0dNy9MzvUAE13hM/sfg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-54kGgvkZMGWnD7VUYA34CA-1; Thu, 20 Oct 2022 11:24:26 -0400
X-MC-Unique: 54kGgvkZMGWnD7VUYA34CA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CAE78027EB
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:26 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3F962024CBB;
        Thu, 20 Oct 2022 15:24:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 11/16] svm: add svm_suported
Date:   Thu, 20 Oct 2022 18:23:59 +0300
Message-Id: <20221020152404.283980-12-mlevitsk@redhat.com>
In-Reply-To: <20221020152404.283980-1-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/svm_lib.h | 5 +++++
 x86/svm.c         | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
index 04910281..2d13b066 100644
--- a/lib/x86/svm_lib.h
+++ b/lib/x86/svm_lib.h
@@ -4,6 +4,11 @@
 #include <x86/svm.h>
 #include "processor.h"
 
+static inline bool svm_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_SVM);
+}
+
 static inline bool npt_supported(void)
 {
 	return this_cpu_has(X86_FEATURE_NPT);
diff --git a/x86/svm.c b/x86/svm.c
index e4e638c7..43791546 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -343,7 +343,7 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
 	ac--;
 	av++;
 
-	if (!this_cpu_has(X86_FEATURE_SVM)) {
+	if (!svm_supported()) {
 		printf("SVM not available\n");
 		return report_summary();
 	}
-- 
2.26.3

