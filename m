Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBD56CC946
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjC1Rbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC1Rbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:31:36 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C00BDDC
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:31:34 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id y14so13051349wrq.4
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680024693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtiprwlUv8RpyZHXqJVAug6oqdjSRp6/2zuWFlQJTRs=;
        b=jRrDLlb5Rr0/bjgs0sXnPhocTF2kfFeBSzLF6bstz/3ygI64v/eWDrZCogYGgynYQP
         A3hrl61AOTFeEGUhH99GhdE3G0beq7SNPicGoCu/67HMpRZ7OOxl/8FYyDGxYfostrQF
         O9jrP876HInNbbghyBLQwnS2deq8MHy5UCkIqOGupZNO/yjTu2Ytzvs1ahaP6Zg8hVqW
         iuw9CwKVPjBDtUPPo0bcuhM26bnS9Re/sMKECuZ6iP7XHy3eu1ZQllM5QS6B13i8Aa2s
         VUk9MjN7Pf8XFoXdNmBGvfruTlKaVjDP1NjyanfzO+a7iGGWHKkI/AjIDvpQQ8SDgTht
         gO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680024693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtiprwlUv8RpyZHXqJVAug6oqdjSRp6/2zuWFlQJTRs=;
        b=Jngq5qFcg+v58FPQMTUyAc55+zGRAxlonZjMHDHX3aMzK8rWAP0xSRNI9AvkzQpJDc
         trTLlQbyLqlboZodn3y2I8MEmlSx8P4kbQ01THqy9l5mvSXxoJf3qZvpirN3WnXhmxLe
         dvHrwPV+/8D+pXLK4WPTYC4P7iTpL53zaML6pwPHT+KAvueRiexrnxVI52e5ZCSWDAcq
         RGdZ+D01xkFPY+zgKwG74Tu95pKFae5zDeqULKW2HnIHFx9R+ASdU0QfS6JJlOEJDYvM
         bcn2hakKB6AMDv5y+LT7lvKCLAHoC9t1Y5jjjy33GyvxM/fpB1m+5vcA7ecIWHGS/JAL
         OD0Q==
X-Gm-Message-State: AAQBX9fTnE4szGSKiJp8ELbqNV7hhiBysQUNslb89CU2wXrFz5TaDOHp
        B2Niwl0r1gjxm3Na4EIv0c3hgA==
X-Google-Smtp-Source: AKy350YcLKf496WO/PMS7jSwOOzxrOynCtjMnJtsPQhvloi8lsidFYl2ZcxsFhfyhqCqdSMllBmsSg==
X-Received: by 2002:a5d:428a:0:b0:2d1:6104:76ab with SMTP id k10-20020a5d428a000000b002d1610476abmr12558802wrq.2.1680024693303;
        Tue, 28 Mar 2023 10:31:33 -0700 (PDT)
Received: from localhost.localdomain ([176.187.210.212])
        by smtp.gmail.com with ESMTPSA id c8-20020adfe708000000b002cde626cd96sm27997076wrm.65.2023.03.28.10.31.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Mar 2023 10:31:32 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org, Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH-for-8.0 v2 2/3] softmmu/watchpoint: Add missing 'qemu/error-report.h' include
Date:   Tue, 28 Mar 2023 19:31:16 +0200
Message-Id: <20230328173117.15226-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230328173117.15226-1-philmd@linaro.org>
References: <20230328173117.15226-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cpu_watchpoint_insert() calls error_report() which is declared
in "qemu/error-report.h". When moving this code in commit 2609ec2868
("softmmu: Extract watchpoint API from physmem.c") we neglected to
include this header. This works so far because it is indirectly
included by TCG headers -> "qemu/plugin.h" -> "qemu/error-report.h".

Currently cpu_watchpoint_insert() is only built with the TCG
accelerator. When building it with other ones (or without TCG)
we get:

  softmmu/watchpoint.c:38:9: error: implicit declaration of function 'error_report' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
        error_report("tried to set invalid watchpoint at %"
        ^

Include "qemu/error-report.h" in order to fix this for non-TCG
builds.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 softmmu/watchpoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/softmmu/watchpoint.c b/softmmu/watchpoint.c
index ad58736787..9d6ae68499 100644
--- a/softmmu/watchpoint.c
+++ b/softmmu/watchpoint.c
@@ -19,6 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/main-loop.h"
+#include "qemu/error-report.h"
 #include "exec/exec-all.h"
 #include "exec/translate-all.h"
 #include "sysemu/tcg.h"
-- 
2.38.1

