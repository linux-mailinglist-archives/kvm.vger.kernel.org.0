Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2373754E3
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhEFNjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:39:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234466AbhEFNjT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620308301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtnD1U4zAjjBX9oA9uBgg0xbiA9djz1nnWZVPwnN9No=;
        b=E/hX3FD+jj21UDon5hGG5vq5140HF3H9GHxZhMjjyYFxDJPdvhtuT239XCREI3SqisyA2p
        z63rMCDYe0rU5q7eKgCfjvmCPgtmmLfq0E2c4P3MGDffoNFxhNq6rh9jni4Ab2uDlLTKVV
        eiBBrzGC/GE23M8kAWc5RNJjuCD/nsU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-KAa5CyKqO2aQziOW-RYybA-1; Thu, 06 May 2021 09:38:16 -0400
X-MC-Unique: KAa5CyKqO2aQziOW-RYybA-1
Received: by mail-wm1-f71.google.com with SMTP id n24-20020a7bcbd80000b029014287841063so1346518wmi.3
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:38:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rtnD1U4zAjjBX9oA9uBgg0xbiA9djz1nnWZVPwnN9No=;
        b=DXTXGoAsLgZvJTvGIiDf1oy7C1ipW4NtxFEcV6ulin0FnqG8jNAbz2uvukw1Z6Co9m
         beAA2MMg81rhmH1ejtvzD967VhpKg7xaiHtn5/warYdnE2xoPCONLlGapprz7fs0t3Ap
         m2g7JTxSP2w5v2bBLYIknWSwTtxBEKmYOQl+9tVSw+iqr/fdcVrUvC1ym5XAzBKDO890
         gKFxXm7GP7B9V8l7ZNdpphuv8UnSnJRnnPSXEqMqPoj4a3c01U3AYfC6pzOweK150ZgT
         jk/M8YTM538OVjs1eYpBHU+wEp1Gw+Z9wqkIA+zS9IduGKMzz+thnEyBVmzpBuS4O+u9
         00wQ==
X-Gm-Message-State: AOAM530AHyBDsk3RuuqR10V4H79ICQSwNnOGNw1OB8fyQjF/wR5gizwR
        fyIrtdjdJOzQ2VATgFILc9y+sTjFvKhr8kbstuALoPX+eIKsobbyYN8b7kqNyMWx/Rj7WjmR9nI
        2sY2rchXrJWUr
X-Received: by 2002:a1c:c28a:: with SMTP id s132mr15033742wmf.145.1620308295092;
        Thu, 06 May 2021 06:38:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9zr0u80TiOLaMnzP6Zw8/LeB0azlBgPsu0O1udkYDmO7GAIcBjFqIX7hcrVdU+Gtn8cUBtA==
X-Received: by 2002:a1c:c28a:: with SMTP id s132mr15033720wmf.145.1620308294899;
        Thu, 06 May 2021 06:38:14 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id o15sm4312755wru.42.2021.05.06.06.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:38:14 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v2 3/9] backends/tpm: Replace g_alloca() by g_malloc()
Date:   Thu,  6 May 2021 15:37:52 +0200
Message-Id: <20210506133758.1749233-4-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210506133758.1749233-1-philmd@redhat.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ALLOCA(3) man-page mentions its "use is discouraged".

Replace a g_alloca() call by a g_malloc() one, moving the
allocation before the MUTEX guarded block.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 backends/tpm/tpm_emulator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/backends/tpm/tpm_emulator.c b/backends/tpm/tpm_emulator.c
index e5f1063ab6c..d37a6d563a3 100644
--- a/backends/tpm/tpm_emulator.c
+++ b/backends/tpm/tpm_emulator.c
@@ -124,10 +124,9 @@ static int tpm_emulator_ctrlcmd(TPMEmulator *tpm, unsigned long cmd, void *msg,
     CharBackend *dev = &tpm->ctrl_chr;
     uint32_t cmd_no = cpu_to_be32(cmd);
     ssize_t n = sizeof(uint32_t) + msg_len_in;
-    uint8_t *buf = NULL;
+    g_autofree uint8_t *buf = g_malloc(n);
 
     WITH_QEMU_LOCK_GUARD(&tpm->mutex) {
-        buf = g_alloca(n);
         memcpy(buf, &cmd_no, sizeof(cmd_no));
         memcpy(buf + sizeof(cmd_no), msg, msg_len_in);
 
-- 
2.26.3

