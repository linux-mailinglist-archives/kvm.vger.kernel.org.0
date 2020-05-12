Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B5A1CF284
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgELKdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:33:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24246 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729515AbgELKdN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 06:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589279592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eW6bfQ4PBPfgnbJADVXdHyk1e9elM2KC/4eDs8BhUVc=;
        b=OgDDXfc6+l5VAultsME/p+0QOaz/J+R5Ih/DTYhb5YkTxKYnlYYoeaYs89Y8XMjOYG6+fW
        nd2RZ1xJA1ak1PlVDIX1IBfj4wsX8QglMt/TYsHpA11IRhioYP0CfB4uGuq8+vz0RM5URp
        xz99pbI0PV0lteu7a5AlGnAcZnx7X/Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-QhwaqcciM02jcHuPyHjZXQ-1; Tue, 12 May 2020 06:33:10 -0400
X-MC-Unique: QhwaqcciM02jcHuPyHjZXQ-1
Received: by mail-wr1-f70.google.com with SMTP id 30so6720181wrq.15
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 03:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eW6bfQ4PBPfgnbJADVXdHyk1e9elM2KC/4eDs8BhUVc=;
        b=HcwVIngizecdc2RsSVktMG+Dsibr/l+ZQz7FCjkpv260aGmO+/syVFlBg5VQBp0JIk
         9xV+tlaLEwb/YRqe/riujMFKk55oQ6tDcvfz/VeeYVhm81qXOSyXevydYS8qsMZbRkND
         lsqnfTbRsOI5fcQ+KyT1d6lxekxZnwaObwJBEjuWCgZMZiIF+92i32C3S+vcjDyaE2iQ
         ouD+EQ0pN+UqC+adiKxn/KZMt0j8cPj3eFjImQ9wLnCmEQurYyyTRDHf6q0EWM6JiJbq
         p+XqPZPSEifiWydv8dTp0FoUtfisccUdKicF/uq9D1Hq3bObmATuajlZcuO0kYSE7B+Y
         2s2Q==
X-Gm-Message-State: AGi0PubCml1jpYfKMheBGfqNKTCGJXQDlxxz4StIE2ZCvX73Ysmf2rXg
        ys2bR87w35+ue/Ry+3HqJUL91y/xi1BWwMuzjM+T8v/MTUAOqjZxCqbhsxW3D2F2e7rENv3fm5T
        DsrSNNuKpUqzX
X-Received: by 2002:a5d:526f:: with SMTP id l15mr23961461wrc.367.1589279589596;
        Tue, 12 May 2020 03:33:09 -0700 (PDT)
X-Google-Smtp-Source: APiQypKAy4y1dqGWaojxWwDczmxiyvjplmoiyIK4YplpgxZqaLOv7U32GRAJXJeKUMX6KRAwfFepYQ==
X-Received: by 2002:a5d:526f:: with SMTP id l15mr23961434wrc.367.1589279589392;
        Tue, 12 May 2020 03:33:09 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id y3sm21421190wrt.87.2020.05.12.03.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 03:33:08 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        qemu-trivial@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>
Subject: [PATCH v4 6/6] tests/migration/guestperf: Use Python 3 interpreter
Date:   Tue, 12 May 2020 12:32:38 +0200
Message-Id: <20200512103238.7078-7-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200512103238.7078-1-philmd@redhat.com>
References: <20200512103238.7078-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 tests/migration/guestperf-batch.py | 2 +-
 tests/migration/guestperf-plot.py  | 2 +-
 tests/migration/guestperf.py       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/migration/guestperf-batch.py b/tests/migration/guestperf-batch.py
index cb150ce804..f1e900908d 100755
--- a/tests/migration/guestperf-batch.py
+++ b/tests/migration/guestperf-batch.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Migration test batch comparison invokation
 #
diff --git a/tests/migration/guestperf-plot.py b/tests/migration/guestperf-plot.py
index d70bb7a557..907151011a 100755
--- a/tests/migration/guestperf-plot.py
+++ b/tests/migration/guestperf-plot.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Migration test graph plotting command
 #
diff --git a/tests/migration/guestperf.py b/tests/migration/guestperf.py
index 99b027e8ba..ba1c4bc4ca 100755
--- a/tests/migration/guestperf.py
+++ b/tests/migration/guestperf.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Migration test direct invokation command
 #
-- 
2.21.3

