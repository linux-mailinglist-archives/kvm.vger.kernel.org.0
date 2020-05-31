Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421E81E98FC
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgEaQkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39170 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728370AbgEaQkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:40:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KEU6cF8wx9dT9DR4quAwHsy5LYVVtSbv+hQRMIt0K90=;
        b=ed5UW8wxOOVe8bwi6Tg3d2UnK6ccgSCym/dCcE6Zz5QZIQcGuYVVhjitFcQ400T+mvEavj
        xboZbayJpgjDchh5kjPN9vR1ieEFmaSdyWkn6/8scDmg1Ss/LwluYebwoJ7eiVEEej0ys+
        +KiqqCfk0ciD7tCm6wT0lhrDiMn0vUo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-QxTWf2GnOqu9LMYTuocZvw-1; Sun, 31 May 2020 12:40:42 -0400
X-MC-Unique: QxTWf2GnOqu9LMYTuocZvw-1
Received: by mail-wr1-f69.google.com with SMTP id h6so3649523wrx.4
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KEU6cF8wx9dT9DR4quAwHsy5LYVVtSbv+hQRMIt0K90=;
        b=riZsWdlqYpjvFlI6rA4MFLr4nncvX7xIk7AHBwg4E9iOCgcB70j84lmfiXwo3R9W9f
         i9Nwbn/ELhhcMqUkyBp9Kzh7bJgQQ5qF/sSioIOgansTqC9UJlZ4fm9Xo1M//FT3WC/a
         H7JIpBRJ0avnNX54zlXsRyEA98nWck9EXJfuercKPgdge5eVX0FconGmLGTXewPFWuJU
         VZBuO7AIv/ftlzIlo61AX4Aay2X2khKV/Q+vz2dH4Hj+v0o0xnF/eeEH3QpR4d7z2x3C
         xRnNkUlCLZdAGN/tEzQIkfC9qVn2z+1vDHu1Jj8Xe96DGTzaOyVaPRDDaaTThW5RaILC
         huNw==
X-Gm-Message-State: AOAM530xgEzTTbPuO7FkbVgzPHvbrriTzf0v5hy/sKoQS1ZFYX6bl2hA
        zhXiXTtIMvF76bWT2D0vVo69OfMZcUwKdWVdc8K8nx/uOeXxqWTXHbj8Px1R8TQwdhqQX+shT/S
        v5SQj589kyqJ1
X-Received: by 2002:adf:8041:: with SMTP id 59mr17259543wrk.278.1590943241715;
        Sun, 31 May 2020 09:40:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzImNvZeAhhQ1GMFMgecKFJ9XA4/OBogYQBVHGi7VCZ3PzFb8gTmqybziOivHHumywOwku1CA==
X-Received: by 2002:adf:8041:: with SMTP id 59mr17259527wrk.278.1590943241554;
        Sun, 31 May 2020 09:40:41 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id z25sm8585383wmf.10.2020.05.31.09.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:41 -0700 (PDT)
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
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PULL 22/25] tests/acceptance/migration.py: Wait for both sides
Date:   Sun, 31 May 2020 18:38:43 +0200
Message-Id: <20200531163846.25363-23-philmd@redhat.com>
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

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

When the source finishes migration the destination will still be
receiving the data sent by the source, so it might not have quite
finished yet, so won't quite have reached 'completed'.
This lead to occasional asserts in the next few checks.

After the source has finished, check the destination as well.
(We can't just switch to checking the destination, because it doesn't
give a status until it has started receiving the migration).

Reported-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200528112404.121972-1-dgilbert@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 tests/acceptance/migration.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/acceptance/migration.py b/tests/acceptance/migration.py
index 0365289cda..792639cb69 100644
--- a/tests/acceptance/migration.py
+++ b/tests/acceptance/migration.py
@@ -35,6 +35,10 @@ def assert_migration(self, src_vm, dst_vm):
                       timeout=self.timeout,
                       step=0.1,
                       args=(src_vm,))
+        wait.wait_for(self.migration_finished,
+                      timeout=self.timeout,
+                      step=0.1,
+                      args=(dst_vm,))
         self.assertEqual(src_vm.command('query-migrate')['status'], 'completed')
         self.assertEqual(dst_vm.command('query-migrate')['status'], 'completed')
         self.assertEqual(dst_vm.command('query-status')['status'], 'running')
-- 
2.21.3

