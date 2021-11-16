Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F05453B1B
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhKPUoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhKPUoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:44:00 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AB0C061746
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:03 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u11so224806plf.3
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2/AVP8Zq6uyC9VI9QdGVIbCSITCn5Jm+/LDPwBstTZI=;
        b=WX160uVdk/xuIB9uLy0b0H+DyP+zM7foNxBbH0AYRv55ROUdDBHzx8KxrfwtAmlfCi
         eKsCiSE0fkhz1qnBxuKl21+K2ep8AEI7jmIuRRFHRsdIc+1LConDtXZEBTx2LYCX012+
         RmzH5yJOSKE6TaziOHSm+KHrXBcc6lKhf2dSnv4mTBNHTsoY9qf0HDxYFwwUkgnbiC68
         e6Y0JzNRt94gnsPl26QYiqxVlpVMYmGZJ/aEZGLP9ivLU2JCrdVf2idkys3gpK5zpkVc
         7+nV3272PweDftZO3Mj/1ed3jddNYY/5Z1MZysx2ZPnn+rEmsO2vPbdIwL2UK8M+4A2g
         tNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2/AVP8Zq6uyC9VI9QdGVIbCSITCn5Jm+/LDPwBstTZI=;
        b=2mVwnGV9ei2I1uXMKB3AzyErMeBAgcKX1MQLykR0byxSnUEe0Ah9ZJY8uwHg1SfZZU
         wvYQnK/rw8qKUfA+OzJ/jZvCnd2IPiE1b4ZgTgeHHIWH3EuAuIsLYqhGOz7ZDZPEbpkg
         hU8iu2uNFrHMnD8KDNyCna/Amo19VcBAvfKWNZ5kM9D6EMGhh6EpvsM7g6p44k31/tlS
         YPj+SUprBVYp/Jizhs1+9aVW67dIfjJ4wAQ/147LT4ibSEfV4Ftl0O5MR58wAipoTCwr
         j+yjEOk28XjtX13pYuPHNZytUsJPoMF2ABLSIo0nAwoarSYLgASquzYbdRfsxHhzyOXy
         OZlQ==
X-Gm-Message-State: AOAM531mp6XVoMl6iNDrO31rdhHiSv1t2ZsSb2G3igJ4uYtfUPh+71MA
        gROELhmF2QDt/CDvGbrno0Wu2Z9Foms0fA==
X-Google-Smtp-Source: ABdhPJwAyHMKvuHqedpYzwySrVsT8yYr2QixIEc8+/ADken5WbWK16XVLouVPGo5nKmW3wgKzPudYg==
X-Received: by 2002:a17:90a:fa18:: with SMTP id cm24mr2295112pjb.241.1637095262855;
        Tue, 16 Nov 2021 12:41:02 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id lp12sm3652359pjb.24.2021.11.16.12.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:41:02 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v2 06/10] x86 UEFI: Exit QEMU with return code
Date:   Tue, 16 Nov 2021 12:40:49 -0800
Message-Id: <20211116204053.220523-7-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116204053.220523-1-zxwang42@gmail.com>
References: <20211116204053.220523-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zxwang42@gmail.com>

kvm-unit-tests runner scripts parse QEMU exit code to determine if a
test case runs successfully. But the UEFI 'reset_system' function always
exits QEMU with code 0, even if the test case returns a non-zero code.

This commit fixes this issue by calling 'exit' function to exit QEMU
with the correct code.

Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
---
 lib/efi.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index 99eb00c..64cc978 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -85,6 +85,17 @@ efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table)
 	return EFI_NOT_FOUND;
 }
 
+static void efi_exit(efi_status_t code)
+{
+	exit(code);
+
+	/*
+	 * Fallback to UEFI reset_system() service, in case testdev is
+	 * missing and exit() does not properly exit.
+	 */
+	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, code, 0, NULL);
+}
+
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	int ret;
@@ -134,14 +145,14 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	ret = main(__argc, __argv, __environ);
 
 	/* Shutdown the guest VM */
-	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, ret, 0, NULL);
+	efi_exit(ret);
 
 	/* Unreachable */
 	return EFI_UNSUPPORTED;
 
 efi_main_error:
 	/* Shutdown the guest with error EFI status */
-	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, status, 0, NULL);
+	efi_exit(status);
 
 	/* Unreachable */
 	return EFI_UNSUPPORTED;
-- 
2.33.0

