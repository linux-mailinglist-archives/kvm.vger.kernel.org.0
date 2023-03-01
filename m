Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8F26A675E
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCAFet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjCAFeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:34:46 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2298618169
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:45 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id t11-20020a170902e84b00b0019e399b2efaso1708828plg.11
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677648884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nV6aVRBny4wt8k71zP/EmiTrdxTWxBk1zUWSbiL8uGU=;
        b=S/7svbGRA1qwhgbCnVr9N63YJy3/PMXRGq60L3N0+atayGoX8bw2dxurKMc1zKoCe+
         oOyMAz8shNr01LgUvNL9tst7cC/n8Z1E9gMc3lhz7xjmU1prpi0i+i2W8Y66BDPbAE7d
         C+VVUaQnZ32QzNz7bog3KeZxB/33QfVyxj4Nj1P5vgaDBc+fqtOLNDcfzML9FEy3AYS8
         uUl+q5trkJVJ+87e1Cy6O9x0xAVf1qZNvZETWXDiqA8IPYxy/mvausQ3qrKLG31Z+VxU
         GZz1IZIZMb4K2bAd8IZNmvgTfSCgFRgwhXX5vjfEEbEbnJ05BSi8uOta380VUogD3wpT
         X12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677648884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nV6aVRBny4wt8k71zP/EmiTrdxTWxBk1zUWSbiL8uGU=;
        b=634NZv/qAiK4faor/obFKqePYmk0bjqhFGeTsjHZ5qZYhE6Ng95xDAapSJ9bxDC45G
         fOtSyrT1BhRK1vPsOe4k702+PH38aWMwGXN7KeYpWcbeNQHWuuBMn5vfSayJIEXf0sLB
         UURcilocSXilUJ4HpLKqxflap/xBiQ6I7nDKIk8JMjJbrofl62+YSyFFtuIHmnD4hwlh
         RjWKx4zx4ZsZXxREu0IT2ZNVPDjbOGX3wEeb8S9xVWkeQoWhb+NB/5xZ/BmQkphvmFi8
         7lsJfaN7J6lDueP+l3kohmc9JVdMDxOPZ1udO29HI1e5nqLV2rBSwAN5W3aAwBBTuUQb
         37RQ==
X-Gm-Message-State: AO0yUKU2ILSF8oCbYu2I/LV7L17lGpYT6pOCtOPOqyVg8IHql5+JjUwD
        ODEWUt8YykHJjDQgoR+1qU2RuTgA2Ik8a8/VEp8ERjCsxop3rCseM3KY0e98MZI2uOfH05gpFH2
        gg1/3M0vfHi5CcW4qwWVlhG7FG+B/s9MWBkmmKyFElfGr472GDCvcF0C2t1LlspGe98W5
X-Google-Smtp-Source: AK7set8gyYkISxg+mXiqmbBtNoRYr4O/nynetQbynRrHquVtIrUMnIOLwbmXWU47BOCx6wnAGpTKBW+yYoP1zCA4
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:ef8a:b0:19b:456:6400 with SMTP
 id iz10-20020a170902ef8a00b0019b04566400mr1867315plb.7.1677648884455; Tue, 28
 Feb 2023 21:34:44 -0800 (PST)
Date:   Wed,  1 Mar 2023 05:34:20 +0000
In-Reply-To: <20230301053425.3880773-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301053425.3880773-4-aaronlewis@google.com>
Subject: [PATCH 3/8] KVM: selftests: Add strnlen() to the string overrides
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add strnlen() to the string overrides to allow it to be called in the
guest.

The implementation for strnlen() was taken from the kernel's generic
version, lib/string.c.

This will be needed when printf is introduced.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile              | 1 +
 tools/testing/selftests/kvm/lib/string_override.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 84a627c43795..cda631f10526 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -197,6 +197,7 @@ endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end \
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
+	-fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
 	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
diff --git a/tools/testing/selftests/kvm/lib/string_override.c b/tools/testing/selftests/kvm/lib/string_override.c
index 632398adc229..5d1c87277c49 100644
--- a/tools/testing/selftests/kvm/lib/string_override.c
+++ b/tools/testing/selftests/kvm/lib/string_override.c
@@ -37,3 +37,12 @@ void *memset(void *s, int c, size_t count)
 		*xs++ = c;
 	return s;
 }
+
+size_t strnlen(const char *s, size_t count)
+{
+	const char *sc;
+
+	for (sc = s; count-- && *sc != '\0'; ++sc)
+		/* nothing */;
+	return sc - s;
+}
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

