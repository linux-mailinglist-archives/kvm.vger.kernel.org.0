Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD34E453B18
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhKPUn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhKPUn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:43:57 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A77C061764
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:00 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id q12so218536pgh.5
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZXu/eaACaGA7uvtwoJon0fQRTaY9vT6/mcPLe7D+atE=;
        b=QeE/llGvywprPHzB6mA/XolU81TJx3wVfDf9ZUlZ0jdcuGDs1ucwqoWeo5HGomfPfY
         d06ErHpn3ysHTvIDAIu6jme6g4NoCfvDb24JjGJRx68jsanoqax51XwQhZeNDLp04Fm4
         MpK3xPlGr5QMvRHHrgYJxQ8Mk4b1eNTcleZjykVYg92VwuRnVbeODKr/r6oVZNhu/S9U
         +6LRbr/TRLmWU4BpodSbyt5mbKGYHGmhRIkHsuqcnbhTl06DhcpZ6zJwHO34CKpMUZ8T
         BAriopX6Z/VUFHg3E/fHpKUAnTAGUMoKJPY4nr7TsKxRltqA9YIAQvBDCxMnTWaP3cvH
         CcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZXu/eaACaGA7uvtwoJon0fQRTaY9vT6/mcPLe7D+atE=;
        b=YQKhEssakx0XsP+f/Otw+2Nu4R6WbGyMlnYGwg1d/HdlhHHmDsYogenZizOl5jB0mb
         foCv0U0rRt9FaiC6H/2y68XBsqiMH5TTE1G8QD0XV/lDhI/bLAmBDu0UP8uHo5w1CEFZ
         W4Wby/abNFtc6fDYXZR/dmG+VoMWPjmD3UPvWPxoiqweZYyEnk5n3raSTIZrgl0zjXD+
         k1nyRVjVaHDRD45ATqfVTStt29ALvQFkB+t1hY/COV9VTa9ZH6JFrPx1EEemg6VpdZ68
         H9Jm8s76yuAnWq/vJ7KyRKFdE0WDUCUDp3+T0Izq6wGgQR01cVobHGmqjpXw/YsbWcPW
         9XDg==
X-Gm-Message-State: AOAM533Vv0cTIshwYah6oSgKYBCTEWUpCpZ4km+bVYRAHn143eOigcBj
        /+2++O7r7gcrTNWqIOsDtWU91559BS7DMA==
X-Google-Smtp-Source: ABdhPJzscxv9e0xDIv8Ix4ntoQkJ9cMd/fb19sAlKsdjBWokqFhBF3HJBlwbmG8pPR6WVsU45PSv3A==
X-Received: by 2002:aa7:83d6:0:b0:494:690e:e66b with SMTP id j22-20020aa783d6000000b00494690ee66bmr1899403pfn.53.1637095259217;
        Tue, 16 Nov 2021 12:40:59 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id lp12sm3652359pjb.24.2021.11.16.12.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:40:58 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v2 03/10] x86 AMD SEV: Skip SEV-ES if SEV is unsupported
Date:   Tue, 16 Nov 2021 12:40:46 -0800
Message-Id: <20211116204053.220523-4-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116204053.220523-1-zxwang42@gmail.com>
References: <20211116204053.220523-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Skip the SEV-ES setup if SEV is unsupported. Also update the printf to
include error codes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/setup.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 86ff400..68ee74c 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -300,29 +300,24 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	}
 
 	status = setup_amd_sev();
+	/* Continue if AMD SEV is not supported, but skip SEV-ES setup */
+	if (status == EFI_UNSUPPORTED) {
+		goto continue_setup_after_sev;
+	}
+
 	if (status != EFI_SUCCESS) {
-		switch (status) {
-		case EFI_UNSUPPORTED:
-			/* Continue if AMD SEV is not supported */
-			break;
-		default:
-			printf("Set up AMD SEV failed\n");
-			return status;
-		}
+		printf("AMD SEV setup failed, error = 0x%lx\n", status);
+		return status;
 	}
 
 	status = setup_amd_sev_es();
-	if (status != EFI_SUCCESS) {
-		switch (status) {
-		case EFI_UNSUPPORTED:
-			/* Continue if AMD SEV-ES is not supported */
-			break;
-		default:
-			printf("Set up AMD SEV-ES failed\n");
-			return status;
-		}
+	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
+		printf("AMD SEV-ES setup failed, error = 0x%lx\n", status);
+		return status;
 	}
 
+continue_setup_after_sev:
+
 	reset_apic();
 	setup_gdt_tss();
 	setup_idt();
-- 
2.33.0

