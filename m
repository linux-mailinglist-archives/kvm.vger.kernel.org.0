Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D857A4203
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2019 06:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfHaEBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Aug 2019 00:01:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36191 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfHaEBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Aug 2019 00:01:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id p13so9363316wmh.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 21:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2SGBxTSihRQiNkFL8Y8qSe9MWq+oc5ynCFmmFdrSUI0=;
        b=Tu757sYJZlC6KA38K4FKyW9rfsuiCGmEN3yhmJU3AcbIDMeCC8NQV+6tq24W7k/nhD
         LmzU0BNTqvLWk1UyHoViFJZrmqzue0sji87S3PfPfqh+wv+kDrnizDBzqwiAvr/jZoMq
         QQOMJ69dubmW7wx4/jdjwBEW1t0E3h3qLXUq2Te1vTu+dBqoLidWh8dL0GnyiRAXPbTg
         mUXUt+27tiopnJ7gZRhRpWi+vZG2CX/3BvSIQM5au//DToZBme7k8/msdvmv1wCOF+jb
         v8DWhvdokcxuzAmsEdwUw0T/4cDrCSGzGLW9ef+ZGCEjPOstNymnTaDncugswtalANwV
         FJog==
X-Gm-Message-State: APjAAAW+3dO4Zeh3WablKEOnQx6Hbka8e7omvevN7ri+5E4xc12LRA30
        vI+a8wHo/JQ8scefVYkF4e4=
X-Google-Smtp-Source: APXvYqx0yIl/NtI15eaBMBmfavZ2e7vBFi7OAxtpzQ6pgxIeQfVaaP5urLMLf7M+NFYmVoq1ocPP8Q==
X-Received: by 2002:a1c:cfc9:: with SMTP id f192mr7396348wmg.85.1567224070632;
        Fri, 30 Aug 2019 21:01:10 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id e4sm4656470wro.21.2019.08.30.21.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 21:01:10 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: nVMX: Fix wrong reserved bits of error-code
Date:   Fri, 30 Aug 2019 13:40:31 -0700
Message-Id: <20190830204031.3100-3-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830204031.3100-1-namit@vmware.com>
References: <20190830204031.3100-1-namit@vmware.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SDM indeed says that "If deliver-error-code is 1, bits 31:15 of the
VM-entry exception error-code field are 0." However, the SDM is wrong,
and bits that need to be zeroed are 31:16.

Our engineers confirmed that the SDM is wrong with Intel. Fix the test.

Note that KVM should be fixed as well.

Fixes: 8d2cdb35a07a ("x86: Add test for nested VM entry prereqs")
Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/vmx_tests.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4ff1570..37c56df 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4306,15 +4306,15 @@ skip_unrestricted_guest:
 
 	/*
 	 * If deliver-error-code is 1
-	 * bits 31:15 of the VM-entry exception error-code field are 0.
+	 * bits 31:16 of the VM-entry exception error-code field are 0.
 	 */
 	ent_intr_info = ent_intr_info_base | INTR_INFO_DELIVER_CODE_MASK |
 			INTR_TYPE_HARD_EXCEPTION | GP_VECTOR;
 	report_prefix_pushf("%s, VM-entry intr info=0x%x",
-			    "VM-entry exception error code[31:15] clear",
+			    "VM-entry exception error code[31:16] clear",
 			    ent_intr_info);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	for (cnt = 15; cnt <= 31; cnt++) {
+	for (cnt = 16; cnt <= 31; cnt++) {
 		ent_intr_err = 1U << cnt;
 		report_prefix_pushf("VM-entry intr error=0x%x [-]",
 				    ent_intr_err);
-- 
2.17.1

