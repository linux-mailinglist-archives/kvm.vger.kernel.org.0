Return-Path: <kvm+bounces-4099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9BA380D9C8
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 19:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 182CBB2182C
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F4452F72;
	Mon, 11 Dec 2023 18:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OlDU8Www"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBE5B4
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:19 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d09a64eaebso42352875ad.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702320979; x=1702925779; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VkVfXdG+QchtPbEMXByOmfoGEr5gxV3bgAp3Ue9WKBk=;
        b=OlDU8WwwYirlPxIPiUALjFzGr74ysf3deCI8s6KIV14bvMk7HvEIDopw+YfUiPl+TJ
         4f2Wd2vgjic5a9kbtfW9kV/Zjd5apkffWIpNkLzrzbcQoxdg+mYkc7Vu7BvzVane9Hge
         TNwFTUMv1+npugwjNkmIxv+GfORQAXCRldgxaMIm3rfgfNJyDa1MfOoMgi64CfNvq3ht
         UC4qaXRqDe3kV5TKFUhbIi2AizckghXciHW2RcPhCq2c18fy4+GVIGGprNmfTG4S1is7
         nhJ/GBejxBAoa+BcXF1Fwr6fZZ4gDQ+lBzFQa2Fo94D4vSLakYedtEU4871C4dytnj3+
         vEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702320979; x=1702925779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VkVfXdG+QchtPbEMXByOmfoGEr5gxV3bgAp3Ue9WKBk=;
        b=UuECLm3YQWyNsWHhs4aXYGt5+SdQc+Zp95d7OGaf7Yhm2iFelY90TR4nemI/0GOVxf
         2nk4/nvMRC0G5SmyHJw6BFz6GpKTUxJUfwFpf57Z3grkkK35jkjX+DISfl2BZ+oCd39E
         wSHMxZiGrPEJMEWFpYpRoxeu1EmPcHKKyjU4qloN/YJ2IJgyjgfXgOddO0BS1QUaHods
         MeNgVrx7XPVnEu7OzeFFPZK8J3Smau334VKwcsjBCQubR7pq3fLzEJS6MVxoezCUpBnR
         R1pvz7KMHi1YaDQYxNysZzrP9cFJvTeBpCfbmHpxgecGwzruph67vCXMvKuEC4m97glH
         BkiA==
X-Gm-Message-State: AOJu0Yy4bRO0DO5lma/t8dJ957JODIH/CZ20pK7HSWMJcWKUidt7HZf/
	q6SOPoPWjWZJ+TvBj0d7thyZLvWJSIMSUg==
X-Google-Smtp-Source: AGHT+IFL4UQzOvYAyDIIpaw0aAqRTom59VMXLtIlj+xaSPYrZIOI0q5ojn0k3THzW2KqLplKG0RsLxjFEcNI7w==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:cecf:b0:1d0:5878:d4e4 with SMTP
 id d15-20020a170902cecf00b001d05878d4e4mr36544plg.3.1702320978937; Mon, 11
 Dec 2023 10:56:18 -0800 (PST)
Date: Mon, 11 Dec 2023 10:55:51 -0800
In-Reply-To: <20231211185552.3856862-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231211185552.3856862-1-jmattson@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231211185552.3856862-5-jmattson@google.com>
Subject: [kvm-unit-tests PATCH 4/5] nVMX: add self-IPI tests to vmx_basic_vid_test
From: Jim Mattson <jmattson@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: "Marc Orr (Google)" <marc.orr@gmail.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: "Marc Orr (Google)" <marc.orr@gmail.com>

Extend the VMX "virtual-interrupt delivery test", vmx_basic_vid_test,
to verify that virtual-interrupt delivery is triggered by a self-IPI
in L2.

Signed-off-by: Marc Orr (Google)  <marc.orr@gmail.com>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/vmx_tests.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ce480431bf58..a26f77e92f72 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10720,6 +10720,7 @@ enum Vid_op {
 	VID_OP_SET_ISR,
 	VID_OP_NOP,
 	VID_OP_SET_CR8,
+	VID_OP_SELF_IPI,
 	VID_OP_TERMINATE,
 };
 
@@ -10779,6 +10780,9 @@ static void vmx_basic_vid_test_guest(void)
 		case VID_OP_SET_CR8:
 			write_cr8(nr);
 			break;
+		case VID_OP_SELF_IPI:
+			vmx_x2apic_write(APIC_SELF_IPI, nr);
+			break;
 		default:
 			break;
 		}
@@ -10817,7 +10821,7 @@ static void set_isrs_for_vmx_basic_vid_test(void)
  *   tpr_virt: If true, then test VID during TPR virtualization. Otherwise,
  *       test VID during VM-entry.
  */
-static void test_basic_vid(u8 nr, u8 tpr, bool tpr_virt, u32 isr_exec_cnt_want,
+static void test_basic_vid(u8 nr, u8 tpr, enum Vid_op op, u32 isr_exec_cnt_want,
 			   bool eoi_exit_induced)
 {
 	volatile struct vmx_basic_vid_test_guest_args *args =
@@ -10838,15 +10842,23 @@ static void test_basic_vid(u8 nr, u8 tpr, bool tpr_virt, u32 isr_exec_cnt_want,
 	 * However, PPR virtualization, which occurs before virtual interrupt
 	 * delivery, sets VPPR to VTPR, when SVI is 0.
 	 */
-	vmcs_write(GUEST_INT_STATUS, nr);
 	args->isr_exec_cnt = 0;
-	if (tpr_virt) {
-		args->op = VID_OP_SET_CR8;
+	args->op = op;
+	switch (op) {
+	case VID_OP_SELF_IPI:
+		vmcs_write(GUEST_INT_STATUS, 0);
+		args->nr = nr;
+		set_vtpr(0);
+		break;
+	case VID_OP_SET_CR8:
+		vmcs_write(GUEST_INT_STATUS, nr);
 		args->nr = task_priority_class(tpr);
 		set_vtpr(0xff);
-	} else {
-		args->op = VID_OP_NOP;
+		break;
+	default:
+		vmcs_write(GUEST_INT_STATUS, nr);
 		set_vtpr(tpr);
+		break;
 	}
 
 	enter_guest();
@@ -10903,15 +10915,18 @@ static void vmx_basic_vid_test(void)
 			if (nr == 0x20)
 				continue;
 
+			test_basic_vid(nr, /*tpr=*/0, VID_OP_SELF_IPI,
+				       /*isr_exec_cnt_want=*/1,
+				       /*eoi_exit_induced=*/false);
 			for (tpr = 0; tpr < 256; tpr++) {
 				u32 isr_exec_cnt_want =
 					task_priority_class(nr) >
 					task_priority_class(tpr) ? 1 : 0;
 
-				test_basic_vid(nr, tpr, /*tpr_virt=*/false,
+				test_basic_vid(nr, tpr, VID_OP_NOP,
 					       isr_exec_cnt_want,
 					       /*eoi_exit_induced=*/false);
-				test_basic_vid(nr, tpr, /*tpr_virt=*/true,
+				test_basic_vid(nr, tpr, VID_OP_SET_CR8,
 					       isr_exec_cnt_want,
 					       /*eoi_exit_induced=*/false);
 			}
@@ -10930,8 +10945,8 @@ static void test_eoi_virt(u8 nr, u8 lo_pri_nr, bool eoi_exit_induced)
 	u32 *virtual_apic_page = get_vapic_page();
 
 	set_virr_bit(virtual_apic_page, lo_pri_nr);
-	test_basic_vid(nr, /*tpr=*/0, /*tpr_virt=*/false,
-		       /*isr_exec_cnt_want=*/2, eoi_exit_induced);
+	test_basic_vid(nr, /*tpr=*/0, VID_OP_NOP, /*isr_exec_cnt_want=*/2,
+		       eoi_exit_induced);
 	TEST_ASSERT(!get_virr_bit(virtual_apic_page, lo_pri_nr));
 	TEST_ASSERT(!get_virr_bit(virtual_apic_page, nr));
 }
-- 
2.43.0.472.g3155946c3a-goog


