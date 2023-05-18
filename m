Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20BA708602
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjERQXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjERQXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:23:03 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4268810E2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:41 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-643bb9cdd6eso2377797b3a.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426955; x=1687018955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+MDCRro9Xf50+QJNvlhYGv12fy+n0EAq9lKznlrmn0=;
        b=dI2lUVtcWdnnndgRtINY/ZSV1RMXEiah5l8Nv2d4Tb3ZnEkqMkveETcc7/S8uOoNyS
         QwmLuihecc+W7fdv7QLY5dikWZjluTxnEpFQxuce39ldhA37AyqT3GrBwg3RidIWy71u
         le+Ht0tz3SkDK/BcQ6Pf5bAy/35uWXUMMDCoQdgXQeGHh3Qb4vphOosBl8KtXOOMmaIF
         ZV8MyqmvnbaawWMpKaZErCjgtjymx7Dsw5obx9dcxU3/5sFxSboJEiPd6z/0/8K5s6TA
         /gmwokF5YRtQ6/J2RS5VU8s/JT2nkFu7fUEXpgUOBS6V8XKnv9RSnhUWoJNu6R5SRAR7
         Yvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426955; x=1687018955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N+MDCRro9Xf50+QJNvlhYGv12fy+n0EAq9lKznlrmn0=;
        b=ejN9JJcG10+51+wne1uQiujEOek1GJtETBtpOl0Bt1UxDWAXXHpDwfKfk+66Ie5/DQ
         5tsBG51/6dtBiTwsc7hMEjO9mIfsNSgw1iivtzGZ+HOFGW6DBU8Z7uPzIRK4WAJRFAkd
         9YLFY5+7gSJ1MCZ/yHH0Ybsj1OaYiWMpnAxKqZzYa9VPmOVSDpkgTPgOJHYzkl0RvAZq
         cN7wH7Bu6bb6gURkaDtJY7Pnw0QhXguJ2jwZulWUSc+kj0zdHv5PRt9dNiWnpqhk3v0f
         qfietyabDScuutkCaAEtb+HqK6Lq+7c7NGBAkspAHVw5MPo6cXfdRpDoUqENL4U1fV9/
         sORQ==
X-Gm-Message-State: AC+VfDzMAzmfcgW+QEG1MItCMewLDn8n1K/7HGnVrJ4xQjcYpUatMQjE
        YbgriJfa4cGnMnYl3Zjnh1F22A==
X-Google-Smtp-Source: ACHHUZ5lZGUdhh230ULPpQTyLuMbqnQU18JBqRp6StmIPyw1vtFKIhtu4JXH5qp913PbkJwmAtmtvA==
X-Received: by 2002:a05:6a00:b45:b0:64c:c5c0:6e01 with SMTP id p5-20020a056a000b4500b0064cc5c06e01mr6494433pfo.31.1684426954742;
        Thu, 18 May 2023 09:22:34 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:22:34 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Evan Green <evan@rivosinc.com>,
        Vincent Chen <vincent.chen@sifive.com>
Subject: [PATCH -next v20 24/26] riscv: Add documentation for Vector
Date:   Thu, 18 May 2023 16:19:47 +0000
Message-Id: <20230518161949.11203-25-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch add a brief documentation of the userspace interface in
regard to the RISC-V Vector extension.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
Co-developed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
Changelog v20:
 - Drop bit-field repressentation and typos (Björn)
 - Fix document styling (Bagas)
---
 Documentation/riscv/index.rst  |   1 +
 Documentation/riscv/vector.rst | 120 +++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+)
 create mode 100644 Documentation/riscv/vector.rst

diff --git a/Documentation/riscv/index.rst b/Documentation/riscv/index.rst
index 175a91db0200..95cf9c1e1da1 100644
--- a/Documentation/riscv/index.rst
+++ b/Documentation/riscv/index.rst
@@ -10,6 +10,7 @@ RISC-V architecture
     hwprobe
     patch-acceptance
     uabi
+    vector
 
     features
 
diff --git a/Documentation/riscv/vector.rst b/Documentation/riscv/vector.rst
new file mode 100644
index 000000000000..5d37fd212720
--- /dev/null
+++ b/Documentation/riscv/vector.rst
@@ -0,0 +1,120 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================================
+Vector Extension Support for RISC-V Linux
+=========================================
+
+This document briefly outlines the interface provided to userspace by Linux in
+order to support the use of the RISC-V Vector Extension.
+
+1.  prctl() Interface
+---------------------
+
+Two new prctl() calls are added to allow programs to manage the enablement
+status for the use of Vector in userspace:
+
+* prctl(PR_RISCV_V_SET_CONTROL, unsigned long arg)
+
+    Sets the Vector enablement status of the calling thread, where the control
+    argument consists of two 2-bit enablement statuses and a bit for inheritance
+    mode. Other threads of the calling process are unaffected.
+
+    Enablement status is a tri-state value each occupying 2-bit of space in
+    the control argument:
+
+    * :c:macro:`PR_RISCV_V_VSTATE_CTRL_DEFAULT`: Use the system-wide default
+      enablement status on execve(). The system-wide default setting can be
+      controlled via sysctl interface (see sysctl section below).
+
+    * :c:macro:`PR_RISCV_V_VSTATE_CTRL_ON`: Allow Vector to be run for the
+      thread.
+
+    * :c:macro:`PR_RISCV_V_VSTATE_CTRL_OFF`: Disallow Vector. Executing Vector
+      instructions under such condition will trap and casuse the termination of the thread.
+
+    arg: The control argument is a 5-bit value consisting of 3 parts, and
+    accessed by 3 masks respectively.
+
+    The 3 masks, PR_RISCV_V_VSTATE_CTRL_CUR_MASK,
+    PR_RISCV_V_VSTATE_CTRL_NEXT_MASK, and PR_RISCV_V_VSTATE_CTRL_INHERIT
+    represents bit[1:0], bit[3:2], and bit[4]. bit[1:0] accounts for the
+    enablement status of current thread, and the setting at bit[3:2] takes place
+    at next execve(). bit[4] defines the inheritance mode of the setting in
+    bit[3:2].
+
+        * :c:macro:`PR_RISCV_V_VSTATE_CTRL_CUR_MASK`: bit[1:0]: Account for the
+          Vector enablement status for the calling thread. The calling thread is
+          not able to turn off Vector once it has been enabled. The prctl() call
+          fails with EPERM if the value in this mask is PR_RISCV_V_VSTATE_CTRL_OFF
+          but the current enablement status is not off. Setting
+          PR_RISCV_V_VSTATE_CTRL_DEFAULT here takes no effect but to set back
+          the original enablement status.
+
+        * :c:macro:`PR_RISCV_V_VSTATE_CTRL_NEXT_MASK`: bit[3:2]: Account for the
+          Vector enablement setting for the calling thread at the next execve()
+          system call. If PR_RISCV_V_VSTATE_CTRL_DEFAULT is used in this mask,
+          then the enablement status will be decided by the system-wide
+          enablement status when execve() happen.
+
+        * :c:macro:`PR_RISCV_V_VSTATE_CTRL_INHERIT`: bit[4]: the inheritance
+          mode for the setting at PR_RISCV_V_VSTATE_CTRL_NEXT_MASK. If the bit
+          is set then the following execve() will not clear the setting in both
+          PR_RISCV_V_VSTATE_CTRL_NEXT_MASK and PR_RISCV_V_VSTATE_CTRL_INHERIT.
+          This setting persists across changes in the system-wide default value.
+
+    Return value:
+        * 0 on success;
+        * EINVAL: Vector not supported, invalid enablement status for current or
+          next mask;
+        * EPERM: Turning off Vector in PR_RISCV_V_VSTATE_CTRL_CUR_MASK if Vector
+          was enabled for the calling thread.
+
+    On success:
+        * A valid setting for PR_RISCV_V_VSTATE_CTRL_CUR_MASK takes place
+          immediately. The enablement status specified in
+          PR_RISCV_V_VSTATE_CTRL_NEXT_MASK happens at the next execve() call, or
+          all following execve() calls if PR_RISCV_V_VSTATE_CTRL_INHERIT bit is
+          set.
+        * Every successful call overwrites a previous setting for the calling
+          thread.
+
+* prctl(PR_RISCV_V_GET_CONTROL)
+
+    Gets the same Vector enablement status for the calling thread. Setting for
+    next execve() call and the inheritance bit are all OR-ed together.
+
+    Return value:
+        * a nonnegative value on success;
+        * EINVAL: Vector not supported.
+
+2.  System runtime configuration (sysctl)
+-----------------------------------------
+
+To mitigate the ABI impact of expansion of the signal stack, a
+policy mechanism is provided to the administrators, distro maintainers, and
+developers to control the default Vector enablement status for userspace
+processes in form of sysctl knob:
+
+* /proc/sys/abi/riscv_v_default_allow
+
+    Writing the text representation of 0 or 1 to this file sets the default
+    system enablement status for new starting userspace programs. Valid values
+    are:
+
+    * 0: Do not allow Vector code to be executed as the default for new processes.
+    * 1: Allow Vector code to be executed as the default for new processes.
+
+    Reading this file returns the current system default enablement status.
+
+    At every execve() call, a new enablement status of the new process is set to
+    the system default, unless:
+
+      * PR_RISCV_V_VSTATE_CTRL_INHERIT is set for the calling process, and the
+        setting in PR_RISCV_V_VSTATE_CTRL_NEXT_MASK is not
+        PR_RISCV_V_VSTATE_CTRL_DEFAULT. Or,
+
+      * The setting in PR_RISCV_V_VSTATE_CTRL_NEXT_MASK is not
+        PR_RISCV_V_VSTATE_CTRL_DEFAULT.
+
+    Modifying the system default enablement status does not affect the enablement
+    status of any existing process of thread that do not make an execve() call.
-- 
2.17.1

