Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B4C2D0EF5
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgLGLZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:25:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726405AbgLGLZr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:25:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607340261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MSG4LDxzGyW4ZC1IxX3fWcY4XCf9aUhCu+WzuAKC2lo=;
        b=arAYHgRDljPWHYGpL+Rq2lHGCIBZRjqGaIWjgzfJI5wbZte7WlSrS+pskFSnwzcHnKXWQM
        0DxyH3l6SoSPPLCHoj/TBaJvvoqYkKkXPOgr3N2I291s8EzXdJmSMXbuC6Y2cSvNyosl2f
        2HcwK9mePFk5AcnKlGaaQHsDzNg7Ads=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-EY9L8bkOOpSm8f_zbvU_KA-1; Mon, 07 Dec 2020 06:24:19 -0500
X-MC-Unique: EY9L8bkOOpSm8f_zbvU_KA-1
Received: by mail-wm1-f71.google.com with SMTP id y187so5213992wmy.3
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 03:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MSG4LDxzGyW4ZC1IxX3fWcY4XCf9aUhCu+WzuAKC2lo=;
        b=Ky6CeDRKgbpEotZrf/kMeOU0n/ImcvgbFYV1ByyFqVhrWvYzFwgh2MwfiFoQ6xtatr
         1hU7iaQJlewEDQdJI+224WuSzGxV/x8c3ddbNJqmPBSXQYvCJlYZssYy/gUb0rjCeq2F
         reWk2SeVbJbbIZxTQfWfrX5+4vcY8zj7hTC+/2wsvL1k9MQSQWVsCBhx78zza8LEa2hz
         OMGFrA8ct0f+NN2ZdvORdVY7dIFLzfRTfxNuXl+xEPljECEorfXekbsSc6hqNY1CoD0a
         n+2sdAzRdgAYsNAID0zb/4iFonDOiGDDDmsBb2NbQ3T8FZdS6GKvZmQ3EIiXDxktLwNq
         szWg==
X-Gm-Message-State: AOAM532Egat+yY9u5S+E1TsUoYi7psggpebTiPQ2AfvGe2+R7HuJ+iWW
        fau95/7G1oRtwlbUjznV2/9ENzUYd5JkVBdTSqAvkyeYvclhRmQtcOthXlSaJrbIR1CcVfMZS9O
        dtpsGJlNVqVr/
X-Received: by 2002:adf:e444:: with SMTP id t4mr19219660wrm.152.1607340258415;
        Mon, 07 Dec 2020 03:24:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoNIgHdpMpGp2bUcwaH+FdRRx2uvKYslTLHSrs8jOZKgCeWvKJMTuuRmK450fuWJjSTjvKmw==
X-Received: by 2002:adf:e444:: with SMTP id t4mr19219640wrm.152.1607340258267;
        Mon, 07 Dec 2020 03:24:18 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id e16sm4243619wra.94.2020.12.07.03.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 03:24:17 -0800 (PST)
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
Subject: [PATCH v2 4/5] gitlab-ci: Add KVM s390x cross-build jobs
Date:   Mon,  7 Dec 2020 12:23:52 +0100
Message-Id: <20201207112353.3814480-5-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207112353.3814480-1-philmd@redhat.com>
References: <20201207112353.3814480-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build s390x target with only KVM accelerator enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds.yml | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index d8685ade376..7a94a66b4b3 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -1,4 +1,3 @@
-
 .cross_system_build_job:
   stage: build
   image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
@@ -120,6 +119,13 @@ cross-s390x-user:
   variables:
     IMAGE: debian-s390x-cross
 
+cross-s390x-kvm:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-s390x-cross
+    TARGETS: s390x-softmmu
+    ACCEL_CONFIGURE_OPTS: --disable-tcg
+
 cross-win32-system:
   extends: .cross_system_build_job
   variables:
-- 
2.26.2

