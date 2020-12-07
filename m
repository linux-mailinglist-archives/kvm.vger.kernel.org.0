Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF9E2D0EF6
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgLGLZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:25:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726405AbgLGLZx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607340266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SEo8ObuiWti6ikwYfSkzOi/pKrNqwxWSbgMNYO8oMYs=;
        b=Px2khBKQl+ncOkHrje3ZxzsjkwomljsUShZRcq9Fo1SQfN7EgwSfUwHnY5OumVqUrfDRM9
        B5g+BklnwkfRvVYvbUww84w949hzAPXAVxjAQHcER1VYEF1jC0YqhxnE7jP3fQ970ji3XF
        +YouDcRH6BGztwqRc6l+b/IwLfMZeL0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-N0YNpj1BMP6sSCy62QplrA-1; Mon, 07 Dec 2020 06:24:24 -0500
X-MC-Unique: N0YNpj1BMP6sSCy62QplrA-1
Received: by mail-wm1-f72.google.com with SMTP id k126so2277272wmb.0
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 03:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SEo8ObuiWti6ikwYfSkzOi/pKrNqwxWSbgMNYO8oMYs=;
        b=GvUFzoyhEmUwU0nX8O/LhRi/oAcC2A2NsiGks7+kTd9/iYGM0AmwKUwnxVq2f5FEV8
         GkSrXd8v3ODCmkTUVlcg6ca64jvPLDpAyzqZ/BEPbpw5Yo/FhT2XUlVDYNoYPqlxzLq/
         Zvz/a8dbZgw+zZCB2fu5CUY/wUG5D1Cx8aC2VNmt+lgJSLNs+/Ej8C/Yj2oiJcJZ2yHj
         AuGwdRABB8hU10StswxOOspAE2Rt+uP0KMBCSkOeXt5BMh3joruQKS6S1ZznZkEtMhoD
         yE3dJ0v8GHEkk3a+T54WHgNRRdLnyRHtQWf7CRs9bS4iAC+4pOPuVqpvYGMmJAduvG5y
         /sOQ==
X-Gm-Message-State: AOAM532z0RYBSG7C75+XzBVOiv8LlICcNzuuHXhYi7BOs4O0+8VwUgoK
        3BK9xwEJVqBWtWSHAVasaI1m0ARHX0JX3PyHKQHGE7RzUa3Pe+7e9G1R/3LNHu/tXv5q/22kkdB
        g0xN4iKghlxB2
X-Received: by 2002:a7b:c1d7:: with SMTP id a23mr17761617wmj.62.1607340263563;
        Mon, 07 Dec 2020 03:24:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDr6itnK8hiEddAxr/Psf+fnJpJGiFVhvH4Vq5j5+wSxG6IJIVGf7oSHkC7/zpJDDY93Vnkg==
X-Received: by 2002:a7b:c1d7:: with SMTP id a23mr17761592wmj.62.1607340263423;
        Mon, 07 Dec 2020 03:24:23 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id m4sm8219391wrw.16.2020.12.07.03.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 03:24:22 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>, qemu-s390x@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: [PATCH v2 5/5] gitlab-ci: Add Xen cross-build jobs
Date:   Mon,  7 Dec 2020 12:23:53 +0100
Message-Id: <20201207112353.3814480-6-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207112353.3814480-1-philmd@redhat.com>
References: <20201207112353.3814480-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build ARM and X86 targets with only Xen accelerator enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds.yml | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index 7a94a66b4b3..31f10f1e145 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -135,3 +135,18 @@ cross-win64-system:
   extends: .cross_system_build_job
   variables:
     IMAGE: fedora-win64-cross
+
+cross-amd64-xen:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-amd64-cross
+    ACCEL: xen
+    TARGETS: i386-softmmu,x86_64-softmmu
+    ACCEL_CONFIGURE_OPTS: --disable-tcg --disable-kvm
+
+cross-arm64-xen:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-arm64-cross
+    ACCEL: xen
+    TARGETS: aarch64-softmmu
-- 
2.26.2

