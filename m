Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BAC602FA7
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 17:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJRP2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 11:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJRP2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 11:28:38 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6666BBC46A;
        Tue, 18 Oct 2022 08:28:36 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1370acb6588so17192659fac.9;
        Tue, 18 Oct 2022 08:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CYftzAS7d7PwCedU9T1W1h069tO+3o3734rFDNbR850=;
        b=Sp2vQd7VInnrK7L3fy/MhgrAVqhrdZnXhY+bQj7UU3XtfDqQZKS2vGemUdsfTAVQdd
         JTOmEk3LlWo+d7f5J1CRyPHEIhA+bSGJdnBcuVn/13hWVk0otPXzQzg7wOClCj3C7ojQ
         acccD2kfwl+MP8qgTGuWn3bGLq3F911LZO1afOGDA1N1L8yKPJGiBvXSd0xZiFWa32yK
         9BrVuIwZwgVudddqepfGIpazbNUElksZt7XjVX2KYsc+orZ6IRYxTy8kOQ7QZ1TpjW7B
         GBrZ/cOX59dv8YiTxkwM5nIxbR3UwuYC211MYyJErIcyj7pofaNAnuZjA1mIImZqAqPs
         PApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CYftzAS7d7PwCedU9T1W1h069tO+3o3734rFDNbR850=;
        b=VAxr8QWklrWmb38kdPMcAk4HAAvvea/iHID1UhTEggAI9shx/ym+3pwmzrle1SLhHp
         iKCcbZF9mi3xzFBytveBTH5KQdjeMIT29gcMmhSbT6jYoAnI9FTV4mV8RimP/rGkImOt
         to63JdAmYB4dSkwmthJGZ54ryWSR35GAL+y4Bd6VoMY2agFfSWV93HZm1fnXicVyjW27
         L7awqp1CwDiJsZ5JYr2oyiX8iKr+GD01SFl/CgT0viObKgaH2HfJqSOYWaK8GC/8TAiR
         U8Wb+W7kLIaGb64z/IrRdT86GKrsWwr5PkoZz0i4Dz3jmAaEnJQqzJs5Jz0O2ng2cWtz
         +n7w==
X-Gm-Message-State: ACrzQf0yVVqUAwP177pcU5wbVTZiH1c2HnOJuP5Lno5lci3WqiVRpfVp
        ijqpcmp+yfqeG1wcDElYEi0=
X-Google-Smtp-Source: AMsMyM6AFQq2Q8K01yvxi3/2VEwS9wBtaryEYa6kov0vQLmTmSqFfWYmyzrzANWozBiwFecxJ7nZiQ==
X-Received: by 2002:a05:6870:e242:b0:137:2c18:681e with SMTP id d2-20020a056870e24200b001372c18681emr1849845oac.161.1666106916069;
        Tue, 18 Oct 2022 08:28:36 -0700 (PDT)
Received: from macondo.. ([2804:431:e7cc:1855:1146:49fe:83c4:7bb])
        by smtp.gmail.com with ESMTPSA id d24-20020a056830045800b006618b23df05sm6057348otc.21.2022.10.18.08.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 08:28:35 -0700 (PDT)
From:   Rafael Mendonca <rafaelmendsr@gmail.com>
To:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sinan Kaya <okaya@codeaurora.org>
Cc:     Rafael Mendonca <rafaelmendsr@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio: platform: Do not pass return buffer to ACPI _RST method
Date:   Tue, 18 Oct 2022 12:28:25 -0300
Message-Id: <20221018152825.891032-1-rafaelmendsr@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ACPI _RST method has no return value, there's no need to pass a return
buffer to acpi_evaluate_object().

Fixes: d30daa33ec1d ("vfio: platform: call _RST method when using ACPI")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 55dc4f43c31e..1a0a238ffa35 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -72,12 +72,11 @@ static int vfio_platform_acpi_call_reset(struct vfio_platform_device *vdev,
 				  const char **extra_dbg)
 {
 #ifdef CONFIG_ACPI
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	struct device *dev = vdev->device;
 	acpi_handle handle = ACPI_HANDLE(dev);
 	acpi_status acpi_ret;
 
-	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, &buffer);
+	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, NULL);
 	if (ACPI_FAILURE(acpi_ret)) {
 		if (extra_dbg)
 			*extra_dbg = acpi_format_exception(acpi_ret);
-- 
2.34.1

