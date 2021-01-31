Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8304309BD3
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 13:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhAaL55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 06:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhAaLz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:55:29 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FA8C061574
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:16 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id e15so10755859wme.0
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sHwmePAwBZnB/6MQG332p6aeurp1aOW9YUVHNzJgQQk=;
        b=gl98KYub5B29/tDooPia1xnr8+DmGiIx/UpfjZiG2dzed7ztMbOcE8dmG/zmD7gDo/
         m3xjb2iOLwq4AAnp936pJB2UouZ3Pp0jvFX0EsfKlRJ2IQmdAGNbxE9BodCmgzqA3Ct0
         TLXHEvox2NBLbAcOgZDzUhtVagwSvVh+EsbIlZWKE051QySQy3QpembGI0HzfLJ9puRy
         Xc9uTGEJSYwRLljm4PblNNWj8OU/kwtZNbNwvbfxiI6dFrNbjLw1T9pEqCv3Q5LxRi+F
         3FtUQXdmzCR18IAHolP9KhcEobiw7hrsRc8eUqk1F42n4Xisy1QOrEZgC5TAU0cnF0oB
         3m4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=sHwmePAwBZnB/6MQG332p6aeurp1aOW9YUVHNzJgQQk=;
        b=Y3KU0vqhBiWIkX+xcTuT+r7vIW7XlhPopIbfGMAIIkOE9SHtLbw40z0Wzx+Yj4jXuc
         5eJBaAYf0ifMeLj0IRxSD32brYAeg4iMYeq5rGGlprmmlFhJG6blDgMMgwecv2d0asTy
         XBBfr6gB/NATPN6Z/hdyiq0g3EyTcqHNdy6Zuq0im+Sdnsi1VtOI/d+GzVUnHmIrbm2R
         qTEoZC3Nc4h6tdpgDxl1i4ySnLkwTu67av0AvVNzktxeCnnMwPJr3Sq50dM84/q0bHVM
         an9Ut0EPFiuN5TEwemQkbSbnI73inzRfRdTklkyVP3FbD36rSOvCSUumn0l7hBOJLUEW
         iKpA==
X-Gm-Message-State: AOAM5303sOKIwQCOTM5B6j9cktf7D7G7+TpJmgW753u+u7haESWTmVRX
        WK9myAnHLlGRzBDgZ3fHDNE=
X-Google-Smtp-Source: ABdhPJy9DTxPrkq+mLcZ2GZAl5OyfPZtxNOXX4s39rpFzMKgY9kX7aWG61oNhcsR+ZIgBSBAHI6dug==
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr11134979wml.16.1612093875310;
        Sun, 31 Jan 2021 03:51:15 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id r16sm1563538wrt.68.2021.01.31.03.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:51:14 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v6 09/11] target/arm: Reorder meson.build rules
Date:   Sun, 31 Jan 2021 12:50:20 +0100
Message-Id: <20210131115022.242570-10-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210131115022.242570-1-f4bug@amsat.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <philmd@redhat.com>

Reorder the rules to make this file easier to modify.
No logical change introduced in this commit.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/meson.build | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 6c6081966cd..aac9a383a61 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -14,31 +14,36 @@
 
 arm_ss = ss.source_set()
 arm_ss.add(gen)
+arm_ss.add(zlib)
 arm_ss.add(files(
   'cpu.c',
-  'crypto_helper.c',
-  'debug_helper.c',
   'gdbstub.c',
   'helper.c',
+  'vfp_helper.c',
+))
+
+arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+  'cpu64.c',
+  'gdbstub64.c',
+))
+
+arm_ss.add(files(
+  'crypto_helper.c',
+  'debug_helper.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
   'op_helper.c',
   'tlb_helper.c',
   'translate.c',
   'vec_helper.c',
-  'vfp_helper.c',
   'cpu_tcg.c',
 ))
-arm_ss.add(zlib)
-
 arm_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
 arm_ss.add(when: 'CONFIG_TCG', if_false: files('m_helper-stub.c'))
 
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c', 'kvm64.c'), if_false: files('kvm-stub.c'))
 
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
-  'cpu64.c',
-  'gdbstub64.c',
   'helper-a64.c',
   'mte_helper.c',
   'pauth_helper.c',
-- 
2.26.2

