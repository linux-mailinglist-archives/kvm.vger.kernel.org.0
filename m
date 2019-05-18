Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E04B2258E
	for <lists+kvm@lfdr.de>; Sun, 19 May 2019 01:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbfERXd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 May 2019 19:33:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52347 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfERXd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 May 2019 19:33:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id y3so9939150wmm.2
        for <kvm@vger.kernel.org>; Sat, 18 May 2019 16:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QbMogAlFCKl6rxuvPrp+ad2VR5iQojPzXrxanFb9b+o=;
        b=FDpYwASymHEyqfiP79XshcwaDLIjX82ixTAci2aanYLoytyz5hxsgJI4vGDZcmVqDR
         oh8Arc35TRXK8IMLoCq9VvT0+NHFL9lxXJo3y7+vNkJAWL+HpdodS0Zea+Wu8/rrj8ix
         L97OcCuTyqsao+d3mH+g8LTuOc4LEoHaCA1bl9gVqIa9cZDO2/XMA44Z7E9UNHvisvmx
         1v/s5kkVHZOjw8Yb5hmvBiptthaJ+6M1lmeXRQCyIes7OE+itTFkrsYltN0w/4rWYE0f
         j+Ph90HvWL9enIvzbAF0/8u5XaqKyzSTvfxoJ2WZ1cEN7mpvC52MD41gqnkLy6rdHUmZ
         KFNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QbMogAlFCKl6rxuvPrp+ad2VR5iQojPzXrxanFb9b+o=;
        b=tyYceNK+E34MHY6iYGztjvlewcm42s9nTpz2oe3Q4cViBOzsct8vDkrRlE++1kpTXl
         tM6LSe5FSI27EYSOl/Cp19aRVou9PjSK72bb1myxtMaQeyyVmck0VQvjGDXAwkPdS9La
         Z9Y0DWwyGrDG3uEjfkylC3471UrcgGQIWPwurVguKXbHT1ZiL6SHAcOtVf56m2zayNpf
         x34ElohVkmYEaqH4Mvzre7cZpu16YCCtza1rSe29HAyNGh/jajn73l89qaikSZbrunwT
         dFJUZ5DhfXjsYmreCz7qcFjMy4j0qa3/UfeMf+Yx8c+Cn0eftM3YIpp4tef+ovvqIda+
         9uhQ==
X-Gm-Message-State: APjAAAVe3nHbR7OxaI23zZZ8au0IaUUK2T5CEZ2I0ot4ppCpKKE1/XwX
        ScXrWRsoMwshbcsTNva0jZo=
X-Google-Smtp-Source: APXvYqyQJRH+8zKk53xuGIJn9KZzHOimimmENZGbGsih+PJ9hdZ5KFUrsOodsANxrxxUoLzaxz9ieg==
X-Received: by 2002:a1c:4843:: with SMTP id v64mr31811002wma.73.1558222405461;
        Sat, 18 May 2019 16:33:25 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id t194sm47395wmt.3.2019.05.18.16.33.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 16:33:24 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Nadav Amit <nadav.amit@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [kvm-unit-tests PATCH v2] x86: Restore VMCS state when test_tpr_threshold_values() is done
Date:   Sat, 18 May 2019 09:13:21 -0700
Message-Id: <20190518161321.5155-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VMCS fields of APIC_VIRT_ADDR and TPR_THRESHOLD are modified by
test_tpr_threshold_values() but are not restored to their original
value. Save and restore them.

Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>

---

v1->v2: Fix commit log, which had the wrong function name [Krish]
---
 x86/vmx_tests.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0ca5363..d0ce1af 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4432,6 +4432,8 @@ static void test_tpr_threshold_values(void)
 static void test_tpr_threshold(void)
 {
 	u32 primary = vmcs_read(CPU_EXEC_CTRL0);
+	u64 apic_virt_addr = vmcs_read(APIC_VIRT_ADDR);
+	u64 threshold = vmcs_read(TPR_THRESHOLD);
 	void *virtual_apic_page;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_TPR_SHADOW))
@@ -4451,11 +4453,8 @@ static void test_tpr_threshold(void)
 	report_prefix_pop();
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
-	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | CPU_VIRT_APIC_ACCESSES)))) {
-		vmcs_write(CPU_EXEC_CTRL0, primary);
-		return;
-	}
-
+	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | CPU_VIRT_APIC_ACCESSES))))
+		goto out;
 	u32 secondary = vmcs_read(CPU_EXEC_CTRL1);
 
 	if (ctrl_cpu_rev[1].clr & CPU_VINTD) {
@@ -4505,6 +4504,9 @@ static void test_tpr_threshold(void)
 	}
 
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
+out:
+	vmcs_write(TPR_THRESHOLD, threshold);
+	vmcs_write(APIC_VIRT_ADDR, apic_virt_addr);
 	vmcs_write(CPU_EXEC_CTRL0, primary);
 }
 
-- 
2.17.1

