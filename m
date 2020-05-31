Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5693E1E98E5
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgEaQjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55770 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728212AbgEaQjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sMv0WAWso8oUAufIgFUwjed/SkQYQOJci7UGvUEGULg=;
        b=O2rReB+fiBqs0kk2lnP2VUBQAheDQaiCEGKiBUFxXwa3nPn662vy55K+GO2ZqDrYX1yrvb
        +thhklU9o1/KGf8U8BK19iO/FTPzrJPfnY6V0nWdGL8OZzbNRvfbAbBySV8jI4uIWNBm8U
        TFhrYHSrMj2+p3d4jGuvOUydg6IkY0g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-wrY9PkhxPb6QN_CAfsydtQ-1; Sun, 31 May 2020 12:39:11 -0400
X-MC-Unique: wrY9PkhxPb6QN_CAfsydtQ-1
Received: by mail-wm1-f72.google.com with SMTP id v23so1917582wmj.0
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sMv0WAWso8oUAufIgFUwjed/SkQYQOJci7UGvUEGULg=;
        b=efk1gJ3AGl5x9ibhaPNbogsNQSopKb5Gp5Y0vUSsUIlU3Y0LNUch1ICItwY49YR3d3
         IydhSfFtjrKBsJzjybqgivqvu1q0eQMtKWurk95PKqNSzincSDCue/lQ0MiXn722sl0Z
         +H/bPYe6scM65HKUSN2/y7GbKpw5nP22YlXyLdy3xWdB2zMHObwasHai7M6MN4+D/aNQ
         QxKQYUjOSYvCAFesku8xieLTZHHDX44QRvY1cgx96sN5euQoBt56aEjocLqOL98BYuS8
         c0P4AkQpu+BZS3v+LfUfoN8K/1I4uoJnrhEFO8DfNEck0FwHSCVrhxquobHRe1f7V9/F
         CIPw==
X-Gm-Message-State: AOAM533rKXTC+uHzngQe+YKNidLU0tTx2oS9ZwlRe0Bo9nSLiFQ996Ps
        D8nvDiOsjJj3MRrCTUaLibDB6M+D0RkWL5GkbLp0AP1yzlMh6/Xw/1QNPjvYy1fviqe5QYfroVG
        p8gEaHfvrJrL6
X-Received: by 2002:a5d:514f:: with SMTP id u15mr19116195wrt.132.1590943150627;
        Sun, 31 May 2020 09:39:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyG/iDkpGxrVd4v54lbHxHsAujyHTlU/e7fh0d4gw7L74BATUg8tOFaSEYyfJzJ1sFZwdHjKQ==
X-Received: by 2002:a5d:514f:: with SMTP id u15mr19116175wrt.132.1590943150481;
        Sun, 31 May 2020 09:39:10 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id v7sm8920858wme.46.2020.05.31.09.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:09 -0700 (PDT)
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
Subject: [PULL 04/25] scripts/kvm/vmxcap: Use Python 3 interpreter and add pseudo-main()
Date:   Sun, 31 May 2020 18:38:25 +0200
Message-Id: <20200531163846.25363-5-philmd@redhat.com>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: John Snow <jsnow@redhat.com>
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
Message-Id: <20200512103238.7078-5-philmd@redhat.com>
---
 scripts/kvm/vmxcap | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/kvm/vmxcap b/scripts/kvm/vmxcap
index 971ed0e721..6fe66d5f57 100755
--- a/scripts/kvm/vmxcap
+++ b/scripts/kvm/vmxcap
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # tool for querying VMX capabilities
 #
@@ -275,5 +275,6 @@ controls = [
         ),
     ]
 
-for c in controls:
-    c.show()
+if __name__ == '__main__':
+    for c in controls:
+        c.show()
-- 
2.21.3

