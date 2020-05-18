Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857941D7D75
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 17:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgERPxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 11:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbgERPxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 11:53:20 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D97C061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:19 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z72so33121wmc.2
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cD0HVhIueot6xPtNOGreyU0JTmhLcSi0Ka6Qp1Nps5Q=;
        b=UzUkQrcnedIIS0eyBH/lUMfwWEMl0dN7u8jvYptYKbxkrDH/d7z9FHA5lgbVk4b94O
         9YAsA3AZn2b3y23TJXdtQz1KIUNf5Kvipq/cnwubNhPTe53nxW24cMT50ESHX3H4/wcQ
         izcXRSOCK5zCoYLLjt/KGEQqmZ2xpp7fgYwN6WliyF/fNgU4etLfxeZKj8Dfe4i9Q/Sr
         k+accbUYJeyeAfmxcwQTfyKvG3PYOmsnm3vdHwfVqIiDFu1ZpptTbNsUCxJf+JeIb1C8
         vxCoLsu7zynaFKgFBWTWnh3KBOoSK1a7SAlaqYJ94LEYAqcFAYBIpjyYkeJlDWSWQwVo
         QmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=cD0HVhIueot6xPtNOGreyU0JTmhLcSi0Ka6Qp1Nps5Q=;
        b=m5zhDRlepKZNRhKRDOdN2ZLrCEYw699GYNRyb+kVrfx//sDcREos7wf90M/+XiiUrp
         2/lFKPhr1XVoPw/ah0z35XD3x5UH998rqalHdsQH2AKd71yF/8PgluuSla3fxMNN5F5Q
         jKNxeByS43ojlsHSQHK/Jy9wniYJC8sW5QjRhkqqb6OZA+oLgb3hyaM9NJtLVLf0aUUI
         d8l0ItmYBW0FcH1OguvIFx1+Xk7Oyu6S2SAFvKtfw/zJfEwZXuh0BHsSnIm8PoCd5jX2
         M0Ha+r7EA6QWybkV1ExrcmQv1oAKaWr6Wq9ybGk4JVbyK+T1HWk+4R4YuINrESRZEALW
         pGfg==
X-Gm-Message-State: AOAM530nbGbEWiNY16PFlsBVXwxKKXbKWLajFYcR0aF6UOiXeN4lijp1
        vvL915rGNcWBEctsgc3EvzE67sDy160=
X-Google-Smtp-Source: ABdhPJzPg4xQnJ1fbHB57rgtpUNAn887oqh+iTpxfl6MyQ6sTjdHGtlxSB7D9n1FDS3I8jeo+FDEwA==
X-Received: by 2002:a1c:7e03:: with SMTP id z3mr52303wmc.88.1589817198412;
        Mon, 18 May 2020 08:53:18 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id 7sm17647462wra.50.2020.05.18.08.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:53:17 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [RFC PATCH v2 7/7] hw/core/loader: Assert loading ROM regions succeeds at reset
Date:   Mon, 18 May 2020 17:53:08 +0200
Message-Id: <20200518155308.15851-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200518155308.15851-1-f4bug@amsat.org>
References: <20200518155308.15851-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we are unable to load a blob in a ROM region, we should not
ignore it and let the machine boot.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
RFC: Maybe more polite with user to use hw_error()?
---
 hw/core/loader.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/hw/core/loader.c b/hw/core/loader.c
index 8bbb1797a4..4e046388b4 100644
--- a/hw/core/loader.c
+++ b/hw/core/loader.c
@@ -1146,8 +1146,12 @@ static void rom_reset(void *unused)
             void *host = memory_region_get_ram_ptr(rom->mr);
             memcpy(host, rom->data, rom->datasize);
         } else {
-            address_space_write_rom(rom->as, rom->addr, MEMTXATTRS_UNSPECIFIED,
-                                    rom->data, rom->datasize);
+            MemTxResult res;
+
+            res = address_space_write_rom(rom->as, rom->addr,
+                                          MEMTXATTRS_UNSPECIFIED,
+                                          rom->data, rom->datasize);
+            assert(res == MEMTX_OK);
         }
         if (rom->isrom) {
             /* rom needs to be written only once */
-- 
2.21.3

