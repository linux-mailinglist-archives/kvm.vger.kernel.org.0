Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E906ADD44
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 12:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCGL3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 06:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjCGL2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 06:28:50 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0395B3B0C4
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 03:28:48 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p26so7516298wmc.4
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 03:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678188526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NpHgHHJcO9P9YY4y05zXj+B7UDNA2tYv+R1DwR2UQ0=;
        b=LDOhaUxAR+lE9e9uOQ4DrQ8xtL4H+V0Mq5qjEATE3EcyEoWE0CN7ARVyxZl5cCRhD9
         2JqXf6skriwPvRTC7w+8DCIeNgpCSeuvzrPaRYXzBiNp7lggEZQeESfX9+3SPcxDPiOF
         YIUGUTl5GmiFPKNbY00Nnr40E3A1pymHgDI89JVx6/rfoN2iZTXrXGbWhqOMvN1Yv4Pe
         w1ocXTez46XorcVExritLrskAdAv1mAAknlUS9MK/q/zh5+HICh+/ORP2eqAYjbFT0tS
         1OY5YYwYEeP5hkeETCd4WzsA0M54ZS9TnSq28txFc2Pyw55HARz59AQqMCKlMerSMULs
         UgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678188526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/NpHgHHJcO9P9YY4y05zXj+B7UDNA2tYv+R1DwR2UQ0=;
        b=mkckrxtwhCrSyCCIuIhsl39QZymfUbMHq2zZSdKX4I/Xyrz3NvFhQwoMeCcDeYYKdO
         1Zl3sAzdWK0KdYhMEjha6AnzqsptbAlO0oxwROjEsUUjeFjTVAD3CMWyiMSa+fuAzSVI
         VfAMjHww0VscCDy/tC1tG6eFHpzOaRH8ZvDo8Nd4IHANQ3WelcNx+geBIRmUHamJWwhP
         SWLmlFx22/sFhrN3mRUNnNN1LXgynHUPhWKk+j9UPoOORGxp8AIzHyibuGOww6tCW0p0
         NviZTcInwG5/qQu/RW+iExHdnL90j1TQJT44khd4cnqKQnS9+vV2AP8tFSaiastsBNo7
         ZLzw==
X-Gm-Message-State: AO0yUKWfRq6JBDy3IY1BgBF6HihcNAhYY0FXGR5AbI2XFimDrSvGZvAu
        nbzLCddADl/3j9XYXZtcwx6q1g==
X-Google-Smtp-Source: AK7set/j9ovj0CFUUtv3ykxWrPRvhqbtXL2N9dsysSaUAlaQ0uFTi5LvTj/bxwKZiR+m6qk7FlHIGA==
X-Received: by 2002:a05:600c:3b95:b0:3eb:2da5:e19 with SMTP id n21-20020a05600c3b9500b003eb2da50e19mr12222106wms.27.1678188526577;
        Tue, 07 Mar 2023 03:28:46 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id h19-20020a05600c30d300b003db06224953sm12347034wmn.41.2023.03.07.03.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:28:46 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B4A491FFBA;
        Tue,  7 Mar 2023 11:28:45 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v10 2/7] add .gitpublish metadata
Date:   Tue,  7 Mar 2023 11:28:40 +0000
Message-Id: <20230307112845.452053-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307112845.452053-1-alex.bennee@linaro.org>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows for users of git-publish to have default routing for kvm
and kvmarm patches.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 .gitpublish | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 .gitpublish

diff --git a/.gitpublish b/.gitpublish
new file mode 100644
index 00000000..39130f93
--- /dev/null
+++ b/.gitpublish
@@ -0,0 +1,18 @@
+#
+# Common git-publish profiles that can be used to send patches to QEMU upstream.
+#
+# See https://github.com/stefanha/git-publish for more information
+#
+[gitpublishprofile "default"]
+base = master
+to = kvm@vger.kernel.org
+cc = qemu-devel@nongnu.org
+cccmd = scripts/get_maintainer.pl --noroles --norolestats --nogit --nogit-fallback 2>/dev/null
+
+[gitpublishprofile "arm"]
+base = master
+to = kvmarm@lists.cs.columbia.edu
+cc = kvm@vger.kernel.org
+cc = qemu-devel@nongnu.org
+cc = qemu-arm@nongnu.org
+cccmd = scripts/get_maintainer.pl --noroles --norolestats --nogit --nogit-fallback 2>/dev/null
-- 
2.39.2

