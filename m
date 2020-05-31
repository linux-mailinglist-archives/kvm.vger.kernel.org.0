Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF61F1E98E4
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgEaQjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23841 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728145AbgEaQjK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBN0He0hnRiO6mOUWUzXjmIAL9Om1ymVuyqwTdVM/HE=;
        b=MZC7U8QL6dSsQTSOsgMqiQI+yHf0+vSZdaGboGj8KoouvkLUvIMDH62/ZLFI5Mj4+3nutO
        eHXoyW3AsdmctyPTs4RB70g53hw2nOJspiPu2xKVITf6+fnFbKzPR7rIgXUWZeDdxLRb/m
        9gIGHQmejwdOQn79sO4SdqbHYtuuPbE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-Ws7IgrkGMiqLiL1-RcdoSA-1; Sun, 31 May 2020 12:39:06 -0400
X-MC-Unique: Ws7IgrkGMiqLiL1-RcdoSA-1
Received: by mail-wr1-f69.google.com with SMTP id m14so1788950wrj.12
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yBN0He0hnRiO6mOUWUzXjmIAL9Om1ymVuyqwTdVM/HE=;
        b=rncPwohv1h7kenOdZndKVCPKjfsvmcA9QMARm7CT7bMwGL1vWCKBEmtfR73I9YRiQk
         +M5FPYwh3YqQJoR2dGEYsHmHN+luZSvTsLkTNO4MG9xd16OFLE4P07TdnuS/fKjSY7e2
         2FiKal2Y7IWKxHOWstzsW6/QW1mzbgDLRzHKObmW7KLzXxTpXSLSwupGwb5cMGiWVK8M
         +9yR1/BnOpNDJ4TAn7zVgeQ0LIYOYXrBTNe3QlE0mAgVpu055f16n2fShrpYGDfjU6+L
         DXm98MR+wJBT0bTpY7ucyTosqFBj7QmkPJWESe+0q3k/T3R399cOQgonRj6LcnAELdl6
         alDQ==
X-Gm-Message-State: AOAM5339qt329yWlgt2KeLmZ2jygrzVS48bqlyesTms3M/H+TH2oX+Ir
        IhtesfuBuZNn+mdL8liz7ARNpnzRWXUVxMiQm3qCHinX5f7WJAD+FKlVEZ1DleJV/obbnqhgFht
        D9/qkWrBJYjA4
X-Received: by 2002:adf:f0d2:: with SMTP id x18mr17834378wro.250.1590943145452;
        Sun, 31 May 2020 09:39:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+gCJF6HcUNgazMBl80tT6OrlhUIFDpGWEUH3j0u8boakYALkjhYWx7zPVPFdQkkPf5lo8sQ==
X-Received: by 2002:adf:f0d2:: with SMTP id x18mr17834358wro.250.1590943145303;
        Sun, 31 May 2020 09:39:05 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id 5sm7692633wmz.16.2020.05.31.09.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:04 -0700 (PDT)
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
Subject: [PULL 03/25] scripts/qmp: Use Python 3 interpreter
Date:   Sun, 31 May 2020 18:38:24 +0200
Message-Id: <20200531163846.25363-4-philmd@redhat.com>
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
Message-Id: <20200512103238.7078-4-philmd@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/qmp/qom-get  | 2 +-
 scripts/qmp/qom-list | 2 +-
 scripts/qmp/qom-set  | 2 +-
 scripts/qmp/qom-tree | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/qmp/qom-get b/scripts/qmp/qom-get
index 007b4cd442..7c5ede91bb 100755
--- a/scripts/qmp/qom-get
+++ b/scripts/qmp/qom-get
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 ##
 # QEMU Object Model test tools
 #
diff --git a/scripts/qmp/qom-list b/scripts/qmp/qom-list
index 03bda3446b..bb68fd65d4 100755
--- a/scripts/qmp/qom-list
+++ b/scripts/qmp/qom-list
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 ##
 # QEMU Object Model test tools
 #
diff --git a/scripts/qmp/qom-set b/scripts/qmp/qom-set
index c37fe78b00..19881d85e9 100755
--- a/scripts/qmp/qom-set
+++ b/scripts/qmp/qom-set
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 ##
 # QEMU Object Model test tools
 #
diff --git a/scripts/qmp/qom-tree b/scripts/qmp/qom-tree
index 1c8acf61e7..fa91147a03 100755
--- a/scripts/qmp/qom-tree
+++ b/scripts/qmp/qom-tree
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 ##
 # QEMU Object Model test tools
 #
-- 
2.21.3

