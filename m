Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7166CC75F
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjC1QCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjC1QCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:02:18 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FA9DBE1
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:02:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id p34so7280609wms.3
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680019333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtiprwlUv8RpyZHXqJVAug6oqdjSRp6/2zuWFlQJTRs=;
        b=YBqnn50nc5BI6U2W2Uz+dLXQxn1NXHOzSypufKCyjOjT+cy3R7s0R4aqhwiDm1EzRC
         TQRA8apn7ceclv47/0cw5P4cRiGgwQUuwq3Zo4MRQ58HSywEWli1lhc4vczj5tBN5cT2
         EH6UeGV8Y9V6THfP62La39VWMa8enqO41YrD6+m0WRymZ4gzfu0oHhnvJXWPG3aJ6bV/
         RZ+0MTo57uraXhRjNX2vobjAzL7jx5j4xTzbwv14WIC2WUvqtGkqyidF5A9rKft4ryjm
         QF9nr+Thu0ERZdq6QCcmboo4d90zZPpJf/uvYLxXMjBgcjG+0wXDMEo0kibI+mce/6jE
         Dgbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680019333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtiprwlUv8RpyZHXqJVAug6oqdjSRp6/2zuWFlQJTRs=;
        b=GI6RGU9ajysfvFRou+abOHK31DudNRE7hpEom1op8c93gDi56XD5O8UmWOp1BFNsR+
         rnheLnp5RsuG8pYTtW5VDNdCjPG2NJF5v/H4Ifk+tpcn2tqZ61f9Wz0kTvsYhDXeqTNG
         cSCDvzGpMGZMy9Ewq56QYN5XWlXONrUA58QfEyomjn5mStB7aZZkFmfy+CVQrq5w4qRG
         Vk1wiHn5bnVmPdDfoWmpFmIXYB3M5M8NRDCXeCds5l6VWsKMXiRAhHD0ptIDBlq5QKWe
         6nc6hWV5oAGd82vQnl3cr1O3rvxTUDrab9lLI0x1paXn4A1B4dJ7/FAWX5BF8ljS44mY
         ffuw==
X-Gm-Message-State: AO0yUKVoCIJxmZxIfK/0I5ImTqWOKGI+9qEFUraT3JGGWSGWoBAg0wo9
        HKzX+t7poFyXPdav5cBRwNVNDA==
X-Google-Smtp-Source: AK7set+wy+rcXei80pJmoUp0mvVFmGsR4Dmw3o1mOxbaDnbESYJxnRRG7eE/MMueHWRFm/HPkvRUVw==
X-Received: by 2002:a05:600c:204:b0:3ea:d620:57a7 with SMTP id 4-20020a05600c020400b003ead62057a7mr13068749wmi.8.1680019333682;
        Tue, 28 Mar 2023 09:02:13 -0700 (PDT)
Received: from localhost.localdomain ([176.187.210.212])
        by smtp.gmail.com with ESMTPSA id s3-20020a05600c45c300b003ed51cdb94csm12936005wmo.26.2023.03.28.09.02.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Mar 2023 09:02:13 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        qemu-s390x@nongnu.org, Fabiano Rosas <farosas@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Yanan Wang <wangyanan55@huawei.com>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-8.0 1/3] softmmu/watchpoint: Add missing 'qemu/error-report.h' include
Date:   Tue, 28 Mar 2023 18:02:01 +0200
Message-Id: <20230328160203.13510-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230328160203.13510-1-philmd@linaro.org>
References: <20230328160203.13510-1-philmd@linaro.org>
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

