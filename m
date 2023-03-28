Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6C36CC765
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbjC1QCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbjC1QCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:02:35 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB7CEC75
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:02:28 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id y14so12782875wrq.4
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680019347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6MbnN+0f617dsehwYtlh7IWt8dwxE1cjBMBOmowF/jo=;
        b=VJZ0iiE81gahmAHh33wdnxu9f+fm7PWswjCh7eESenZk4qw+MBxuSDrdCRJA0VrjEI
         +C7aKvPD13wY3jABL63HkqOa9uMkiu9Mbn2+aR07oiNg+xMVJQrsjvj4hLMsKVcydEBY
         nwiqU5BDc6N6afTuF03JZqD8tCyzkYo3IEfdUUPofFV4GZMfjkRzf6rM6AHXt6J9wY2r
         HMQigzyW+2RXu4nay6XAGfMfQXkEWxNc2j8yR2sEAbCMcg6+rBtCdJvepi60ZidtWN9n
         c0gEDCsuxeLXDQAbKpXAHz6BYiGfYjVotey3OfXSQsTFqFBrXE/2h/6xbGPnvH2z/hHT
         0Cpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680019347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6MbnN+0f617dsehwYtlh7IWt8dwxE1cjBMBOmowF/jo=;
        b=lL8R9ot5IHYDbAP5wgMVAJPZ8FF4MOFFoEtWlWtD4woulGUT/6jqKnA1Fuz12opFoz
         gXLMpOw0sPauOnAbDwEJmotjg0F+XNlJlq8WhV4qLgxlMh8WCQF7ZM57RouX2spgsVGq
         yQdql0Yi88qrCKb1vSzJYfy7el5pCfB8TurZOfvUpSTm2mzyRMadarnhqETfC4k5l+7r
         H75saiIYImDqa/JAQb8RS8OJsquw7I81OsSRf1dadFgbLcOs2iqOsLyQfS0Y3XLOGHos
         RRiPNxxRwVOXWkhJU2bxO3JGs6l3ytmj9IqELzrZTl0o6l9KC/oR7gMeFgZrBxdc19gb
         9BqA==
X-Gm-Message-State: AAQBX9ekG3tlMKOfHRR883187LxmOEg1KNXup2nNrHPHkJ8Gk1YBNQpe
        zJrh1qE0WJV2tg3s9tha8ANL3w==
X-Google-Smtp-Source: AKy350ZFQOfZ6NGkv37Y8Zyt4NAfhytXhLygwXOKe3bf5X+CGLXdwq0Za3H95yZDpyNDB1L/YK+wcg==
X-Received: by 2002:adf:f4c2:0:b0:2ce:ad40:7705 with SMTP id h2-20020adff4c2000000b002cead407705mr13934370wrp.25.1680019346740;
        Tue, 28 Mar 2023 09:02:26 -0700 (PDT)
Received: from localhost.localdomain ([176.187.210.212])
        by smtp.gmail.com with ESMTPSA id f11-20020a5d4dcb000000b002cfe3f842c8sm27713200wru.56.2023.03.28.09.02.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Mar 2023 09:02:26 -0700 (PDT)
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
Subject: [PATCH-for-8.0 3/3] softmmu: Restore use of CPU watchpoint for all accelerators
Date:   Tue, 28 Mar 2023 18:02:03 +0200
Message-Id: <20230328160203.13510-4-philmd@linaro.org>
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

CPU watchpoints can be use by non-TCG accelerators.

KVM uses them:

  $ git grep CPUWatchpoint|fgrep kvm
  target/arm/kvm64.c:1558:        CPUWatchpoint *wp = find_hw_watchpoint(cs, debug_exit->far);
  target/i386/kvm/kvm.c:5216:static CPUWatchpoint hw_watchpoint;
  target/ppc/kvm.c:443:static CPUWatchpoint hw_watchpoint;
  target/s390x/kvm/kvm.c:139:static CPUWatchpoint hw_watchpoint;

See for example commit e4482ab7e3 ("target-arm: kvm - add support
for HW assisted debug"):

     This adds basic support for HW assisted debug. The ioctl interface
     to KVM allows us to pass an implementation defined number of break
     and watch point registers. [...]

This partially reverts commit 2609ec2868e6c286e755a73b4504714a0296a.

Fixes: 2609ec2868 ("softmmu: Extract watchpoint API from physmem.c")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h | 2 +-
 softmmu/watchpoint.c  | 4 ++++
 softmmu/meson.build   | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index ce312745d5..397fd3ac68 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -949,7 +949,7 @@ static inline bool cpu_breakpoint_test(CPUState *cpu, vaddr pc, int mask)
     return false;
 }
 
-#if !defined(CONFIG_TCG) || defined(CONFIG_USER_ONLY)
+#if defined(CONFIG_USER_ONLY)
 static inline int cpu_watchpoint_insert(CPUState *cpu, vaddr addr, vaddr len,
                                         int flags, CPUWatchpoint **watchpoint)
 {
diff --git a/softmmu/watchpoint.c b/softmmu/watchpoint.c
index 9d6ae68499..5350163385 100644
--- a/softmmu/watchpoint.c
+++ b/softmmu/watchpoint.c
@@ -104,6 +104,8 @@ void cpu_watchpoint_remove_all(CPUState *cpu, int mask)
     }
 }
 
+#ifdef CONFIG_TCG
+
 /*
  * Return true if this watchpoint address matches the specified
  * access (ie the address range covered by the watchpoint overlaps
@@ -220,3 +222,5 @@ void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
         }
     }
 }
+
+#endif /* CONFIG_TCG */
diff --git a/softmmu/meson.build b/softmmu/meson.build
index 0180577517..1a7c7ac089 100644
--- a/softmmu/meson.build
+++ b/softmmu/meson.build
@@ -5,11 +5,11 @@ specific_ss.add(when: 'CONFIG_SOFTMMU', if_true: [files(
   'physmem.c',
   'qtest.c',
   'dirtylimit.c',
+  'watchpoint.c',
 )])
 
 specific_ss.add(when: ['CONFIG_SOFTMMU', 'CONFIG_TCG'], if_true: [files(
   'icount.c',
-  'watchpoint.c',
 )])
 
 softmmu_ss.add(files(
-- 
2.38.1

