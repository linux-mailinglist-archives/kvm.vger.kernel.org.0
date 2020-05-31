Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC711E98E2
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgEaQjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32652 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728166AbgEaQjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/VDoQzlI3PMEip7rZs9mnHodIncfMhzQDNkbQhv2i8=;
        b=YB41BauQ0Gy9rKCkjMb1x/m/FhT1T3QD+JRtIML+rB0UigF1NepNvDqOJCOLH85HliCoxa
        4egba3X/d7DL2dq/m5mv4NCs9PWf8R27cuxo63EkT10ZuBy3s3u3CxsRNp9BEoMKmQycjD
        nyNReZC0Jd7It+lwLG5WWuUNhIweDaM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-yxLiOb1fP_OLe8FMiQCLjQ-1; Sun, 31 May 2020 12:39:01 -0400
X-MC-Unique: yxLiOb1fP_OLe8FMiQCLjQ-1
Received: by mail-wm1-f72.google.com with SMTP id v23so1917567wmj.0
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C/VDoQzlI3PMEip7rZs9mnHodIncfMhzQDNkbQhv2i8=;
        b=CdF7428BRcI0KrfwnkCm1doEiGgIjUOCXESlbsb6rsEGhNm45xwyInl1cZhikThU8h
         vQHYC6uPh+cJniyf0gWkTotbh70AbAXASi28438jaYDd1kt76GOm9Y0g5zCFlHgigSrS
         HzvonII82EW7GWCGQZekExc+ziEYGoSLe3CpgqTOq2FyWq5jBUYTCP6INtUfzXwRfgH1
         TSUqd1tUXbHvBEn83cbcwkfF0Exy8sDW4mU7dPcfXKKpgJ7iOGthB83Zpx3xR6NPlfes
         TLC5zNPTwWkQfZBmp+GUYV09l9+/Oh0pAG9oumnyc0roa52q8/bwQtF4LMzsASmowMOS
         HL1g==
X-Gm-Message-State: AOAM530eradmNwaIwvxtviiTJaCWrxdBf1BqLg4MhRJOZQb+ZaLWNiUr
        ZGWb+LV3amSfORH7TKBkMD2Ej8EYAn8JJg2xoO2B4bfDIASvpj3rFsOKS2yN4JXBu7Ux/zKQ0ri
        +83m7lw6Le4bx
X-Received: by 2002:a1c:29c4:: with SMTP id p187mr17760833wmp.73.1590943140356;
        Sun, 31 May 2020 09:39:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIEiALGuV93Ro6dhnxfm0LVwVkfTLG/HYDNsHae0Cpu2iwY0tKkx4JmUw+UJ4NEDJTtGPkpg==
X-Received: by 2002:a1c:29c4:: with SMTP id p187mr17760818wmp.73.1590943140155;
        Sun, 31 May 2020 09:39:00 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id d2sm17217183wrs.95.2020.05.31.09.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:38:59 -0700 (PDT)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>
Subject: [PULL 02/25] scripts/qemu-gdb: Use Python 3 interpreter
Date:   Sun, 31 May 2020 18:38:23 +0200
Message-Id: <20200531163846.25363-3-philmd@redhat.com>
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

From: Philippe Mathieu-Daudé <f4bug@amsat.org>

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: John Snow <jsnow@redhat.com>
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
Message-Id: <20200512103238.7078-3-philmd@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/qemu-gdb.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/qemu-gdb.py b/scripts/qemu-gdb.py
index f2a305c42e..e0bfa7b5a4 100644
--- a/scripts/qemu-gdb.py
+++ b/scripts/qemu-gdb.py
@@ -1,5 +1,5 @@
-#!/usr/bin/python
-
+#!/usr/bin/env python3
+#
 # GDB debugging support
 #
 # Copyright 2012 Red Hat, Inc. and/or its affiliates
-- 
2.21.3

