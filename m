Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843CC722B94
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbjFEPnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbjFEPmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:42:35 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2CCE78
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:42:14 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b011cffe7fso22518415ad.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979734; x=1688571734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQpOfl8clKnd1O4gu74PSUiT4R3rCnMiThuoNKoAYLc=;
        b=dGIoYaTIu/Go0aZBEJDRNP5bu0ysEvnifzxjUTmQ7mGdMzkbzkinDQqDiPgMIKsSeq
         Ym8QRUeTI5rCwPZwfSEOHk/wxdk8DFHr1eHQnbcksySVaY6hz03rTPeuaDXtZpvK++pX
         oFu5BlBhLvkuBcR16vlbpSoHbf0Fthcw1u8Q9rRKwp8vPdW14gNni4kpC2No1tkBQUv4
         vvMydl8riJBK26l7+we9Nyunz+D6OxLs38UInhGoJCYtIlnBaS5gVcX8YfyCsJOkgsSy
         O44vtV1RrSqGaBvNoR+pZnTMYLobVs2CRbUU9WxtEVmSuD4ChyeQQA/f+K4OyIsR5c7R
         Kvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979734; x=1688571734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LQpOfl8clKnd1O4gu74PSUiT4R3rCnMiThuoNKoAYLc=;
        b=UMaQDmlTHFIUZI94FyO2Yds+N7iv5trB4JToh2dGEtnqxM/wjIG6ZOxoxYwW5nLZtT
         +q5MK29Iw2NtuSW+k6pdG1nogf3JPqieBk9rGE6VrWHU3b7LhGDBlskU+F6GErqp6kKe
         pWMhCAP41PoR32vHQztz0uPo6mrvJanQXXam43Z/9+OOudnznByh4XHciMNftFSOOSxp
         8/giQZKCNdLDHuEXMmWGpAZQ5TW67MexI5FQjsDHQSZKKjdZdGTiKRbJM8ksG2SVg7uz
         AdOgWz6gEABWTlId2fWY0+e4S/C0U0iCpdaHQdmlf0f9HDpX+ActVi9NqOwUQ58k2QTR
         93JQ==
X-Gm-Message-State: AC+VfDyqslAwiQdN8VsuirRHCqgdfB414aVP0kf9khoJMe95rBb++ZBB
        Mna7a6/Hkhb6GN67Uj2de1+RRg==
X-Google-Smtp-Source: ACHHUZ4HarBlrt7w5wC3w0gMuu62+7K9H3G8hOHQlJBusTnGINtatoDEV8k+cJjf2CL5U7wLG/4/dQ==
X-Received: by 2002:a17:903:1108:b0:1b0:4883:2e03 with SMTP id n8-20020a170903110800b001b048832e03mr4028898plh.40.1685979733979;
        Mon, 05 Jun 2023 08:42:13 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:42:13 -0700 (PDT)
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
        Conor Dooley <conor.dooley@microchip.com>,
        Evan Green <evan@rivosinc.com>,
        Vincent Chen <vincent.chen@sifive.com>
Subject: [PATCH -next v21 25/27] riscv: Add documentation for Vector
Date:   Mon,  5 Jun 2023 11:07:22 +0000
Message-Id: <20230605110724.21391-26-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
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
Changelog v21:
- add usage guideline into doc (Rémi)
Changelog v20:
 - Drop bit-field repressentation and typos (Björn)
 - Fix document styling (Bagas)
---
 Documentation/riscv/index.rst  |   1 +
 Documentation/riscv/vector.rst | 132 +++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)
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
index 000000000000..48f189d79e41
--- /dev/null
+++ b/Documentation/riscv/vector.rst
@@ -0,0 +1,132 @@
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
+status for the use of Vector in userspace. The intended usage guideline for
+these interfaces is to give init systems a way to modify the availability of V
+for processes running under its domain. Calling thess interfaces is not
+recommended in libraries routines because libraries should not override policies
+configured from the parant process. Also, users must noted that these interfaces
+are not portable to non-Linux, nor non-RISC-V environments, so it is discourage
+to use in a portable code. To get the availability of V in an ELF program,
+please read :c:macro:`COMPAT_HWCAP_ISA_V` bit of :c:macro:`ELF_HWCAP` in the
+auxiliary vector.
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
+    Note that ELF programs are able to get the availability of V for itself by
+    reading :c:macro:`COMPAT_HWCAP_ISA_V` bit of :c:macro:`ELF_HWCAP` in the
+    auxiliary vector.
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

