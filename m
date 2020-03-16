Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72498186FD8
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732024AbgCPQSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:18:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47625 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731674AbgCPQSj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:18:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZbHLr8MN7Y181YkXNU9q35GGyibM63M9cMs0mFzNFC4=;
        b=TFnLWEK2AyH8pyhInKP2lXJpOBPjjjtAchbkUOq9493fZNnnTnuPG6pmNi26LtvvpoCEF7
        +jINnITt0reGLAq1OIwbQlhnqdvptQVcPL+EmRkhvn098LibAj+WJVVGJD30VUaUZqPo0v
        CmUfA1rjaV6yUsthH+nkR48crrAyT0M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-US0_RaMUM4K3Ip0mzlr96g-1; Mon, 16 Mar 2020 12:07:28 -0400
X-MC-Unique: US0_RaMUM4K3Ip0mzlr96g-1
Received: by mail-wm1-f70.google.com with SMTP id p4so5070418wmp.0
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZbHLr8MN7Y181YkXNU9q35GGyibM63M9cMs0mFzNFC4=;
        b=hs8CnZgWppLuBUEi/4MWT6x/l6hyDwDQB6rylNivmyi3ZE147y/3G66mhOOtJ6eSho
         NY5IH0tl9Wnug6jG/rF2p9m6UHH4XkEOHyZC98vA3c3lWhV0STlsckEMLTR6WG2Q66Q3
         IjQ6FgPJNpG1oVRjABzf4vXiOFrXWNtzdYNAza1qe96AbzMZkkB3SnlegUbnd8oa8Kh9
         PgduF3H1Qr7NCMuF+Ng7iAI+eZXD/NhI6PqvGyujnBN3sa4atni4hmrACwVDifK4CABf
         TMhGcT2jthRjP8pxXFgfApUdw22C5dqBs7DvZhepWl67MnXcAXkQpH7VjkBqr+2RkNK0
         elBg==
X-Gm-Message-State: ANhLgQ0WrwstUiXtbx7KsFxSYLbswaQqj1iO8cMoBW+rNZ7Nxv1dIo5Z
        0/Yf9oM014d/fX7BRqm5lQmpOO4unsPyEEhb0QszccgvSbAAhSEg8u2uA3gwUKf8aSefYJvC3eH
        0Ah5gBE9FmKVa
X-Received: by 2002:a1c:de82:: with SMTP id v124mr27908591wmg.70.1584374847177;
        Mon, 16 Mar 2020 09:07:27 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvmhZSbs8NzLKXqUjgdCfW3w9WctLHdMyXVqEBO9jZ0UEFAr0Le+jcnqG4RZo4FMyA5CMMs0Q==
X-Received: by 2002:a1c:de82:: with SMTP id v124mr27908565wmg.70.1584374846997;
        Mon, 16 Mar 2020 09:07:26 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id k5sm221948wmj.18.2020.03.16.09.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:26 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 09/19] target/arm: Move ARM_V7M Kconfig from hw/ to target/
Date:   Mon, 16 Mar 2020 17:06:24 +0100
Message-Id: <20200316160634.3386-10-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARM_V7M is a concept tied to the architecture. Move it to the
target/arm/ directory to keep the hardware/architecture separation
clearer.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/arm/Kconfig     | 3 ---
 target/Kconfig     | 2 +-
 target/arm/Kconfig | 2 ++
 3 files changed, 3 insertions(+), 4 deletions(-)
 create mode 100644 target/arm/Kconfig

diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index e5a876c8d1..e3d7e7694a 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -285,9 +285,6 @@ config ZYNQ
     select XILINX_SPIPS
     select ZYNQ_DEVCFG
 
-config ARM_V7M
-    bool
-
 config ALLWINNER_A10
     bool
     select AHCI
diff --git a/target/Kconfig b/target/Kconfig
index 8b13789179..130d0c7a85 100644
--- a/target/Kconfig
+++ b/target/Kconfig
@@ -1 +1 @@
-
+source arm/Kconfig
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
new file mode 100644
index 0000000000..e68c71a6ff
--- /dev/null
+++ b/target/arm/Kconfig
@@ -0,0 +1,2 @@
+config ARM_V7M
+    bool
-- 
2.21.1

