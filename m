Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032F06CC947
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjC1Rbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjC1Rbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:31:44 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23135C140
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:31:41 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id q7-20020a05600c46c700b003ef6e809574so4749683wmo.4
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680024699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6MbnN+0f617dsehwYtlh7IWt8dwxE1cjBMBOmowF/jo=;
        b=Vi8NBOJNIaL4iwmKYW/PpwzdiWYsFRvUddBLaqryeDI70WY0Oy2d73T0GBar8fT1NB
         66DvxYsstnj/vPT+JA6j4E6VyKP0irgJ2/Iy5ci1ndgoiAomaEnQExlQNt644ZApOjSM
         5gf0M9tQLUsBOniL4N9ajmop5HVjbUwLVpkn+q2VAZmgnJb7AVenFfmumtwiQITOsfEx
         t6iYLRcYqbJIfGaFb3NtjMhcApH/+SO/c5MkJFyb8hau3tmKfNx+qt97wNW+SjNkaMCG
         bsEWeGqllJ7zZKuyYylIGdXnif/MpVMTc7V+uiwStXJ2mx1S9wZRsAJS7VsHHxBCQmJT
         w8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680024699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6MbnN+0f617dsehwYtlh7IWt8dwxE1cjBMBOmowF/jo=;
        b=2ISI/REb9sK0wmV0aKy3QjG5ANb0+yH7oGnCBGH6x3hVaVNQK4KIvvGzCNwP4bqm8p
         8tkCf3WVr0uiVS7JyQX8kSy09ug3xM2MwFTPOLNdxNuTbIjD9IKhTGnqkLDfex+hWCDl
         ee6I1Vhlo50FD/y8dD3v5KkYRrV3imbkm+SFyUNRHs/pTtzac20kGs/+GjMMvG3qw8Ff
         RpbnMT62OoEeYmRtaMz1sI9rlITdyamRXJcP1WX+LNnVDoFrCG+4Lk9QvsDGoWMiI/FS
         KHuI6RtB312Pqn4J1mvIjR2Job7YZtrNgO7JdIZ3TmaiRm9zA7DlU0Om6FrcyZW6XbIJ
         TM9w==
X-Gm-Message-State: AO0yUKVIf+ap4gDxFx4WAiqL5zI+cuo82ZpV6Qiv3e5wSGAkx/7Wjq/Y
        Hj43yd6dO/aQapd+YL9dhrUQeg==
X-Google-Smtp-Source: AK7set8Mmo+1n3OHQ5g4OfvYMwrs4HJlZZH0POTRPmIjvHUca6eFRX/JiDgvHoeOv6WIKTuIxEEAQA==
X-Received: by 2002:a05:600c:21d8:b0:3ed:2b49:eefc with SMTP id x24-20020a05600c21d800b003ed2b49eefcmr13475865wmj.3.1680024699656;
        Tue, 28 Mar 2023 10:31:39 -0700 (PDT)
Received: from localhost.localdomain ([176.187.210.212])
        by smtp.gmail.com with ESMTPSA id n10-20020a05600c3b8a00b003ede3f5c81fsm13483453wms.41.2023.03.28.10.31.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Mar 2023 10:31:39 -0700 (PDT)
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
Subject: [PATCH-for-8.0 v2 3/3] softmmu: Restore use of CPU watchpoint for all accelerators
Date:   Tue, 28 Mar 2023 19:31:17 +0200
Message-Id: <20230328173117.15226-4-philmd@linaro.org>
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

