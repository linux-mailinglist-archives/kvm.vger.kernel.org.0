Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA682D1EA9
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgLGX5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgLGX5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:57:04 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174CAC061257
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:56:09 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id qw4so22033477ejb.12
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fXIIajBmYb1UTSbWfTKRq6sJ1Saykn5Ztt68M0JOMdc=;
        b=OQ0aZVig5WznsdWT71WWazlA6LanlAzD7zkuFKg5rPC09Pnk4r0TedIAM8S5PJcsJ0
         PBNo3lPkvEOQ9PfXxA3WfjKWAFc8KI+mtPvMUB1jEw4mnl7VpplxxraeHwTW8W2UE0lA
         F9Om+8mc1pX/rmEIo7w7LYTVnV1veaj2T50LeQypiWqdOSw8CR6IfMT5sDc25NGdfSAs
         l32RaOECFmLhFDuS+x75tcTAAi3QqUxEJzHDFtz1aQxvBgs1xIEH3OCIv+0tCL03b5Gj
         vD7Mg+jrp8EC6thbMGK0JZ5T9sDWm5kBm5Sg2TyPzNVfB6h6XiDGk1CpV/ZPfnBJeGNN
         otew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=fXIIajBmYb1UTSbWfTKRq6sJ1Saykn5Ztt68M0JOMdc=;
        b=gDSj5yKpP/mToFy3I1t3hwI8O8l2rjQ3z3o/Cw9/NQo7RDOBQ5FVTBrmz8g1wNu1mi
         dZrIswThOgZ2Wwkja8bdDOmSrxxzvS8MeH1N8YAyayn3ce7p4E5OGT2G8+ud9GoIVkBq
         CNiV9GAEOuYs8itdW93Mzt4QK3uIelc1emdzvyS8Fh0K+yz3dzDRyUQd6oIpsEehhcbn
         l3U6diwRywyAdFmmj9ffQuTMFOfK3xLDlrpnmr6IYZdtHGSNf948cflyKJ1NCi7Z8OW/
         VIszCldrE9XBAjCA7gJRoelZXLbDIZwjldShml+HV+mik/72haIcWHT4kLwYSBV2EJ7O
         W+Uw==
X-Gm-Message-State: AOAM533vT5mG6thw/HhFESpDSJNjkQCTaX3Ct7iD7xDewIFTB+5jDvBl
        osYmjwdP1eGceXVzKTnb+QE=
X-Google-Smtp-Source: ABdhPJyqV/nOBCIw3MeA/Og51hKn/shzih1DJe/HHRvTMHe0yOmQ2xe4/ceBW//ESc15aqER1j2rbw==
X-Received: by 2002:a17:907:447d:: with SMTP id oo21mr21376886ejb.367.1607385367893;
        Mon, 07 Dec 2020 15:56:07 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id n1sm13709974ejb.2.2020.12.07.15.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:56:07 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 5/7] target/mips/fpu_helper: Remove unused headers
Date:   Tue,  8 Dec 2020 00:55:37 +0100
Message-Id: <20201207235539.4070364-6-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207235539.4070364-1-f4bug@amsat.org>
References: <20201207235539.4070364-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/fpu_helper.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/mips/fpu_helper.c b/target/mips/fpu_helper.c
index 7d949cd8e3a..a3c05160b35 100644
--- a/target/mips/fpu_helper.c
+++ b/target/mips/fpu_helper.c
@@ -21,15 +21,11 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu/main-loop.h"
 #include "cpu.h"
 #include "internal.h"
-#include "qemu/host-utils.h"
 #include "exec/helper-proto.h"
 #include "exec/exec-all.h"
 #include "exec/cpu_ldst.h"
-#include "exec/memop.h"
-#include "sysemu/kvm.h"
 #include "fpu/softfloat.h"
 #include "fpu_helper.h"
 
-- 
2.26.2

