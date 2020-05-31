Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A9D1E98F6
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgEaQkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52483 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728272AbgEaQkZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:40:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hSfG89j1yh/LShH9lpHtA4pkqoFK62nXlpymRDXmlAY=;
        b=Kvz9phEn7O0IqmCrW4I0vQt+h+Bgeq1AdRia/HyeEJ1cd6yufPkJ1jNnW+GuVv4EkLK2pR
        wauYnQ5G4w4uvD4b/fMs+Vvj8nJfnWY+g6X0EWTzfm9Q5GxrlPY2aRjGZqRChGdoUMlkR4
        kRg2hcPWvsP4FUoEgvBhu+/GRlg4SWk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-LApTHkjDMjectnAYlb-44g-1; Sun, 31 May 2020 12:40:17 -0400
X-MC-Unique: LApTHkjDMjectnAYlb-44g-1
Received: by mail-wm1-f70.google.com with SMTP id g84so1916908wmf.4
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hSfG89j1yh/LShH9lpHtA4pkqoFK62nXlpymRDXmlAY=;
        b=WwZ+iukNlm5o3zYQ0C7vqfwKBzMT/4XuvSBcstOTZMa4JFWl9B5zv8GRmBA9Pu/W4v
         0rOPVWjNYRU/hdIDs9GW+H2D/vOIgryU67JfITtHgw/6/ogDiMvra1PZwbRdSREddRmL
         8GnWa8W5lWs0Byy8gMvFC97rRjDi3rpPCHEbk0heGI/Oo8ykoDTbCoQQgRa0m7NRXIRZ
         Mlywfggwx2LprkJnoyRCLi0wkQxHeA/lCE4nYiiN61WwCQBFZzzkaA2zKHF4SfkYGvAP
         Kyrss4CLJLyNAA59AcvO9rv442FWE6ZKNOXWSfQ0OGXGjJM9fIEiTu3g7P78sWPrtSPw
         i9XQ==
X-Gm-Message-State: AOAM531YZ/0PZ76dmZ5Gikhav5z0vro3d74d/QYfqX3WX7d/Sq6VL/hu
        +4ZvgugDP/Bhzus+Qwxl655CxO2p5VZdR/4zScKgMmYosy3sek9+wP4eZIEHxVgLZMrjAqDW1Y+
        SOWQ+je8oGzRx
X-Received: by 2002:a7b:c5d7:: with SMTP id n23mr19218261wmk.185.1590943216325;
        Sun, 31 May 2020 09:40:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzh77KlO64phqJTcDuJt0gPKNWkW2egnQKIXztLKi9l6mDsg1cRYoXGChGRkZq/Axxfqzi/sw==
X-Received: by 2002:a7b:c5d7:: with SMTP id n23mr19218248wmk.185.1590943216159;
        Sun, 31 May 2020 09:40:16 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id b187sm8297281wmd.26.2020.05.31.09.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:15 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        John Snow <jsnow@redhat.com>
Subject: [PULL 17/25] python/qemu/qtest: Check before accessing _qtest
Date:   Sun, 31 May 2020 18:38:38 +0200
Message-Id: <20200531163846.25363-18-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200531163846.25363-1-philmd@redhat.com>
References: <20200531163846.25363-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: John Snow <jsnow@redhat.com>

It can be None; so add assertions or exceptions where appropriate to
guard the access accordingly.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200514055403.18902-30-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/qtest.py | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/python/qemu/qtest.py b/python/qemu/qtest.py
index 4c88590eb0..888c8bd2f6 100644
--- a/python/qemu/qtest.py
+++ b/python/qemu/qtest.py
@@ -121,7 +121,8 @@ def _pre_launch(self):
         super()._pre_launch()
         self._qtest = QEMUQtestProtocol(self._qtest_path, server=True)
 
-    def _post_launch(self):
+    def _post_launch(self) -> None:
+        assert self._qtest is not None
         super()._post_launch()
         self._qtest.accept()
 
@@ -129,6 +130,13 @@ def _post_shutdown(self):
         super()._post_shutdown()
         self._remove_if_exists(self._qtest_path)
 
-    def qtest(self, cmd):
-        '''Send a qtest command to guest'''
+    def qtest(self, cmd: str) -> str:
+        """
+        Send a qtest command to the guest.
+
+        :param cmd: qtest command to send
+        :return: qtest server response
+        """
+        if self._qtest is None:
+            raise RuntimeError("qtest socket not available")
         return self._qtest.cmd(cmd)
-- 
2.21.3

