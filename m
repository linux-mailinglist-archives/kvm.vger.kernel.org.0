Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A02F440D4B
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 06:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhJaF7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 01:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhJaF7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 01:59:16 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EEEC061714
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:45 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g184so14116368pgc.6
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sNcO4ibyEoUEN8Dd5WdiBof8ChwMLkTeLNeAxVmxfok=;
        b=qsOi42wzaB6RWKrjOyfTKcs1obiU7gL0Y7FdgLPVkYX5d7T8yl0B+KkwEt9EgVABHG
         aJ5vp9x6l6Xst5x/W3Q3ntuOzQqSQXED4PLBkxRXT/WM67UtzBEJHKYGisJuJufsVIC4
         Y1a0rOUTIyFPnsENakwX6uT57VESOXLaY4OUSVhWGDU3dYtWFv7TissQgoBObc3VgtXK
         1MsfEIjIEjOY2LGZ81cCiTCh0mvFSJLeODeEFzhntRpvMKMaXpC10gt+dSyPCNJoNcGl
         d/gXHcBg0M+jTXdrHLawdOc+Mpl9fSxJ/XtswrXq22YhilFel4aYRa9tOC0IrGFChd8s
         9yKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sNcO4ibyEoUEN8Dd5WdiBof8ChwMLkTeLNeAxVmxfok=;
        b=gxBym+Qq4TLilzqM55Xq85ALshR3OjcWLVXLGx0Iq8UMjl3QEktIoXP3pmst8cFTQ2
         vw31FiLL+aOPZP6jtoGfbiFSdmrYKeGw3aVkUxv2Hcex5Ih3Wv7HOfAuX4jwWj6yRqYi
         vhn1H03k1ySeZ4QziZGpj81UHkXkwGAU/is4qYaoI0G0WvX4RHb2vBEpNwAeyni/NCw0
         SEXZTYvRENhNAmweOPPO7lMgs0faUd0itXFxSD2gW/fkkoced6EDL41eqoxLVLiBt8lF
         vS0Ff2pzGZKLlSLsB23eARdgC5jOA+ERSIHjSh+pfnGCQEIf0D6mle7YUsMD4HXy/ykp
         Juag==
X-Gm-Message-State: AOAM530ZzTx4rbs5GJ0dKYj3t0eoh8NGYBRUW5OiiL0DXZbfyn0zoywV
        Of7qzaE2Hwcj40w6OtV6HcSFx1CzsCPPwQ==
X-Google-Smtp-Source: ABdhPJwCWyvcFXfMMwAO40D+5pJ5OV3GqEzWvWjuHWZ1V1uhM9CLPfkyvVqZ+wd1drYOsEP7fZTBIA==
X-Received: by 2002:a62:e901:0:b0:47b:f1bc:55e4 with SMTP id j1-20020a62e901000000b0047bf1bc55e4mr21252575pfh.0.1635659804346;
        Sat, 30 Oct 2021 22:56:44 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id j19sm11403179pfj.127.2021.10.30.22.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 22:56:43 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 5/7] x86 UEFI: Exit QEMU with return code
Date:   Sat, 30 Oct 2021 22:56:32 -0700
Message-Id: <20211031055634.894263-6-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211031055634.894263-1-zxwang42@gmail.com>
References: <20211031055634.894263-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zxwang42@gmail.com>

kvm-unit-tests runner scripts parse QEMU exit code to determine if a
test case runs successfully. But the UEFI 'reset_system' function always
exits QEMU with code 0, even if the test case returns a non-zero code.

This commit fixes this issue by replacing the 'reset_system' call with
an 'exit' call, which ensures QEMU exit with the correct code.

Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
---
 lib/efi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index 99eb00c..cc0386c 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -87,7 +87,7 @@ efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table)
 
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
-	int ret;
+	unsigned long ret;
 	efi_status_t status;
 	efi_bootinfo_t efi_bootinfo;
 
@@ -134,14 +134,14 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	ret = main(__argc, __argv, __environ);
 
 	/* Shutdown the guest VM */
-	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, ret, 0, NULL);
+	exit(ret);
 
 	/* Unreachable */
 	return EFI_UNSUPPORTED;
 
 efi_main_error:
 	/* Shutdown the guest with error EFI status */
-	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, status, 0, NULL);
+	exit(status);
 
 	/* Unreachable */
 	return EFI_UNSUPPORTED;
-- 
2.33.0

