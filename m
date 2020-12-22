Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6A42DAF0A
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgLOOgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbgLOOgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:36:02 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A1BC06179C
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:35:21 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a9so39897024lfh.2
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jHo9eRpcVbowVem3+A/2C+0RJYKD+KBjZqYkwvwjgmE=;
        b=QLDx14aQMb+UuKM/FWXhNMbv+GprX9K9cAWs0Lz/YUFM/vjU3ojksLrIfKT7B1mtwA
         PHosrhOnnO86SbgKDJ2TP2YTgZ88oPLUQC6pGZArum3yvJyUwpWM0ecEXg/sv4QXPHG+
         1321P2lfo+/8Vj7UVfGVcPx1Uf5cFVKQEnDV8Kf9Rb9muBKt1HHZVSeE2oXVuZMgQ9mR
         XLzx/SdL2L/jYkBUc5CCuQnY9Sxwmyd8Cu0u05YUBDxmSKAqfE+Et3UDIeLtbaMqLtwq
         14VER2XtOYtSORk2jGXjSoc9upbmLHBdVu1w+KdeTwH4kH2J2QB16ppis8i3ry5MgWAt
         1TGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jHo9eRpcVbowVem3+A/2C+0RJYKD+KBjZqYkwvwjgmE=;
        b=gECbPIrHtQuqz2Q0eUKqARs0M2fgEkNDGMk6w59W4j5QGodqGBNR+rHcbnQOxmcrO1
         uxdjQI4i5WoRGLoWXfVS84YAsTvWQ0kl+CnnVJka/HUww/UIZ6Z7HdigCn/2hqXjh8i7
         smcX4u5cbf+BYISSfuY0N2EiEjV0kYMrPfxjjT637gjSPR6KK0nY74mlfCFZ7fS5oN9F
         cbsS/TuzCjqEanuss1U0ExGLKt9hO6d6267q7WKGV3HHzAJKSQnQJW/QQ8c1eAaMJdxm
         jrEQtU7AqNbfLYsM4YigEt0Gnr+UpDQZaTYXDRSXE/7fn/W2fRrKhfznMWrHlir4V7r4
         4KxQ==
X-Gm-Message-State: AOAM530izVKyUlVbWW8DOveGHlrOQhkwWRu1mzNB2FCbBB1q8fPhVSRN
        DBud51HhDtbTSGeI2nM3rBhsXUDHMEsmsRm1
X-Google-Smtp-Source: ABdhPJw8N1OdDLRB1QGHnXvUDAFeNKyzffcK4rvBCFsVaBdj1x3PfYRv8RT1fxhIB4FWawiAeU1nkg==
X-Received: by 2002:a2e:7c01:: with SMTP id x1mr8676155ljc.397.1608042919073;
        Tue, 15 Dec 2020 06:35:19 -0800 (PST)
Received: from localhost.localdomain (109-252-202-142.dynamic.spd-mgts.ru. [109.252.202.142])
        by smtp.gmail.com with ESMTPSA id o26sm2365749ljg.55.2020.12.15.06.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 06:35:18 -0800 (PST)
From:   Sergey Temerkhanov <s.temerkhanov@gmail.com>
To:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Sergey Temerkhanov <s.temerkhanov@gmail.com>
Subject: [PATCH kvmtool] pci: Deactivate BARs before reactivating
Date:   Tue, 15 Dec 2020 17:35:12 +0300
Message-Id: <20201215143512.559367-1-s.temerkhanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Deactivate BARs before reactivating them to avoid breakage.
Some firmware components do not check whether the COMMAND
register contains any values before writing BARs which leads
to kvmtool errors during subsequent BAR deactivation

Signed-off-by: Sergey Temerkhanov <s.temerkhanov@gmail.com>
---
 pci.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/pci.c b/pci.c
index 2e2c027..515d9dc 100644
--- a/pci.c
+++ b/pci.c
@@ -320,10 +320,6 @@ static void pci_config_bar_wr(struct kvm *kvm,
 	 */
 	if (value == 0xffffffff) {
 		value = ~(pci__bar_size(pci_hdr, bar_num) - 1);
-		/* Preserve the special bits. */
-		value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
-		pci_hdr->bar[bar_num] = value;
-		return;
 	}
 
 	value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
-- 
2.25.1

