Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F42D11A6
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 14:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgLGNQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 08:16:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbgLGNQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 08:16:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607346922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qWT6ZPuFzyJ7mCL37uXEPVzuEPlsDzCAhcDUmllvAYo=;
        b=HtCFp4DEkTji63ssPhKhH7q9z/FrdSdOs4FF/I9b2CsJuJZEVQnrt63hwIcUDdzgeeD3ST
        qHxdHi9n3HQLhXuLeNXuJkp5LEAtfoDWNBRz/9xrf7G36dGDYL1xm52o6mJ09DMLoyRaiz
        5iEQ/we62MhgE8vY+LVyN1GwBdrfIaI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-2BwICmX-M7-UGe6R0Jt8pQ-1; Mon, 07 Dec 2020 08:15:19 -0500
X-MC-Unique: 2BwICmX-M7-UGe6R0Jt8pQ-1
Received: by mail-wm1-f71.google.com with SMTP id r1so5332991wmn.8
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 05:15:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qWT6ZPuFzyJ7mCL37uXEPVzuEPlsDzCAhcDUmllvAYo=;
        b=krHPSotoziXFmxS+QpIqStPorsvOUPtKZn9y8/BaZAI2PG+UWGQm7sAYTTDggGoDo5
         AC4tGPna/CSINs5RlmohVu7rIe8KFyb5jBGm9z4C5uYeJPqjd0gIi0rnq8HZlLWZA6My
         9HA3TnxkHAQY8bX6ilNQW13VaFDI8NyjqLxQuhjdYV2OjLFjBwPGgr8F+z0M4FiEFEzQ
         AtF2STss2KE4o1VUbEBQpGfEElaVbFHWxLhHTQNnlhjTi8ktb63aKOwpSG11GO8BuqC8
         0Ys15ceDl8wkJTdIeZsSC3NJSTZEpsyEfHsM/nroQCtStJZygib0Qm2yz3DDZZCMaBqR
         7cLQ==
X-Gm-Message-State: AOAM533LrLQ4YvGgaL7nj7TPyaX9hgIFW0z7i80QShurbtMTcBPnFeR7
        TEp9Cnn0kgkCaX5DxQtJM4zlW9ulwYCtCP4T81HiIOxyButkZWqHDiNrE0tFo4pGiiDLy9VcpPY
        86TEMMlPhPSCA
X-Received: by 2002:a1c:61c3:: with SMTP id v186mr18343490wmb.146.1607346917872;
        Mon, 07 Dec 2020 05:15:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5+KW+PFE10MP9jLpogYR1x1fZIHiIwppZYhRhxY3siG36Pzyg4Q4bF1rYwvWWqwdmc6Rj+g==
X-Received: by 2002:a1c:61c3:: with SMTP id v186mr18343465wmb.146.1607346917703;
        Mon, 07 Dec 2020 05:15:17 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 65sm12953670wri.95.2020.12.07.05.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 05:15:17 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        qemu-s390x@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Cornelia Huck <cohuck@redhat.com>,
        xen-devel@lists.xenproject.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH v3 2/5] gitlab-ci: Replace YAML anchors by extends (cross_system_build_job)
Date:   Mon,  7 Dec 2020 14:15:00 +0100
Message-Id: <20201207131503.3858889-3-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207131503.3858889-1-philmd@redhat.com>
References: <20201207131503.3858889-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'extends' is an alternative to using YAML anchors
and is a little more flexible and readable. See:
https://docs.gitlab.com/ee/ci/yaml/#extends

More importantly it allows exploding YAML jobs.

Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds.yml | 40 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index 03ebfabb3fa..099949aaef3 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -1,5 +1,5 @@
 
-.cross_system_build_job_template: &cross_system_build_job_definition
+.cross_system_build_job:
   stage: build
   image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
   timeout: 80m
@@ -13,7 +13,7 @@
           xtensa-softmmu"
     - make -j$(expr $(nproc) + 1) all check-build
 
-.cross_user_build_job_template: &cross_user_build_job_definition
+.cross_user_build_job:
   stage: build
   image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
   script:
@@ -24,91 +24,91 @@
     - make -j$(expr $(nproc) + 1) all check-build
 
 cross-armel-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-armel-cross
 
 cross-armel-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-armel-cross
 
 cross-armhf-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-armhf-cross
 
 cross-armhf-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-armhf-cross
 
 cross-arm64-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-arm64-cross
 
 cross-arm64-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-arm64-cross
 
 cross-mips-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-mips-cross
 
 cross-mips-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-mips-cross
 
 cross-mipsel-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-mipsel-cross
 
 cross-mipsel-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-mipsel-cross
 
 cross-mips64el-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-mips64el-cross
 
 cross-mips64el-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-mips64el-cross
 
 cross-ppc64el-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-ppc64el-cross
 
 cross-ppc64el-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-ppc64el-cross
 
 cross-s390x-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-s390x-cross
 
 cross-s390x-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-s390x-cross
 
 cross-win32-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: fedora-win32-cross
 
 cross-win64-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: fedora-win64-cross
-- 
2.26.2

