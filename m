Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F272AB3E4
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 10:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgKIJp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 04:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728866AbgKIJp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 04:45:57 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C96C0613CF
        for <kvm@vger.kernel.org>; Mon,  9 Nov 2020 01:45:55 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id p1so7918411wrf.12
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 01:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1o8lO3koG16AlBbmrKd/snSNhrR/M4yhMjnc+WbIftA=;
        b=lfFJ0JNb2rBiiklBvMRWfCR2xuij+pgMCgqsLCy81HP4dnZsGa9ab/tral6KSdVN/S
         b4DSOQga0Gi+UYhfqO328qbmbgMW+VMAqCGR4HrGkoy2LrW1g6x80sYavGnSv1s98F5v
         XumyaGK5Or9PB2BeK7vAxuNBbdg1E3V2cPYRJ40N7a7NeO4KY70hCSOoP1Uy4dCvDKWA
         RqBJfzxMsqqYdwpfdzrM+vVZk8hugomSvGJeExtnJemU135/1Bsnwnhi1ipEEk0qTuVT
         rRrW9PLQOu7nPQq052VIQSaJT5fJF4/YsBg78TsY0MfddTYxudPiqIVcZgwELwdU5ejr
         4nwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=1o8lO3koG16AlBbmrKd/snSNhrR/M4yhMjnc+WbIftA=;
        b=OtyJmlU8Qo1NP+gWAKEucyDgKAgftNUzxBPCYBetpuUlBFgK/bvHFlvGQ3iqkOmwji
         SeSdokeG6KiNWLhtvINA+0Ju1vddbInR9twdb8cEG90YMF0oWIRwCMK51q7qUgQMDiDi
         U41JG0hlY3J4TW2C6Uh5/r5yxefTCQp3EAjt1Et1I1vDs39P358kwyrqSIyhkCVZTdIM
         jsm2yXEyrJER2XRy7KQs1ap4dtHdWdymuWnz+DG0CBl8pOm0S5wGuXl+yQ98PmNICjY0
         nE1uytQ1idAEpReNAiEZ3zuTlbcfmMgbg3MycGC2PugWgIzCAy9iXMNMdAIrpj4MNBwt
         LedQ==
X-Gm-Message-State: AOAM530kblgysvjgrKf2vgFmPfNBkZZtDJACvz0labTSEFr8m3J4SDe/
        GK81xLp/2DD5/XpjdnzvhRU=
X-Google-Smtp-Source: ABdhPJxc4TZdtgyhqebFbBYMGgeJ98UQ+2SDOy/fHp3mL6Ipg+mK+zm9sk7kmSq1DbuRl+juTBkF8g==
X-Received: by 2002:adf:e64e:: with SMTP id b14mr16979874wrn.68.1604915154540;
        Mon, 09 Nov 2020 01:45:54 -0800 (PST)
Received: from localhost.localdomain (234.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.234])
        by smtp.gmail.com with ESMTPSA id z191sm12223304wme.30.2020.11.09.01.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 01:45:53 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 1/3] accel: Only include TCG stubs in user-mode only builds
Date:   Mon,  9 Nov 2020 10:45:45 +0100
Message-Id: <20201109094547.2456385-2-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201109094547.2456385-1-f4bug@amsat.org>
References: <20201109094547.2456385-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We only require TCG stubs in user-mode emulation.
Do not build stubs restricted to system-mode emulation
in a user-mode only build.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 accel/meson.build | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/accel/meson.build b/accel/meson.build
index b26cca227a4..609772f129b 100644
--- a/accel/meson.build
+++ b/accel/meson.build
@@ -1,10 +1,12 @@
 softmmu_ss.add(files('accel.c'))
 
-subdir('qtest')
-subdir('kvm')
 subdir('tcg')
-subdir('xen')
-subdir('stubs')
+if have_system
+  subdir('qtest')
+  subdir('kvm')
+  subdir('xen')
+  subdir('stubs')
+endif
 
 dummy_ss = ss.source_set()
 dummy_ss.add(files(
-- 
2.26.2

