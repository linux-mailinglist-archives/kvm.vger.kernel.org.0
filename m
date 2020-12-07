Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8732D0EF1
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgLGLZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:25:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbgLGLZh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:25:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607340250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qWT6ZPuFzyJ7mCL37uXEPVzuEPlsDzCAhcDUmllvAYo=;
        b=Y4k6VTzG9Lbv4K30ansu4EIhpmbDWkasotoChAJCX8eVb9e4AcBVXNkCYVoxEpmH36NnjV
        m3Omt51AmrtV31vtvduYVdrl/e6YrtjH4UtAcSSL503fw9lMw+msHfNVY8h57Mkbcy1itj
        Cc3CKaeefQv18/PMMbu27XRKoEWGL50=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-xVnchmTXOTuXv4vomadEJg-1; Mon, 07 Dec 2020 06:24:09 -0500
X-MC-Unique: xVnchmTXOTuXv4vomadEJg-1
Received: by mail-wm1-f71.google.com with SMTP id a130so8911864wmf.0
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 03:24:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qWT6ZPuFzyJ7mCL37uXEPVzuEPlsDzCAhcDUmllvAYo=;
        b=DuygAJgLdRWiPZ4SJX8URCjcP2ecKtBg5Uumrqwj211fOz9dxZ9l1zXGIRNH2/BigT
         CwTKtlPiM9u6z0Argzp6UzWuVjM5cDKe7C4FVAiWxSY4U7yAdC2ex+TluekG0xgtm208
         +Lkv3e5llP/nY6LYexO39E3y2j2iFda7SBHLpba6DcZ+5qfu2ViDBVAArarZajIdmci1
         LxGKZBoZmfZWAk/dfAP9z2VrboRheUR82OtE9BSiTg7RVAhuW90Qnd4WLrQOVMhSE6UA
         cqQSM3827mxbLfytWvGK+P4OQAxztKdZiuOIauzwrxSW43YYN3HYn0RToFEYM9IM0PcD
         0T0g==
X-Gm-Message-State: AOAM5304YRJaSy9dlOKMNLjx+xfOFcJkTx9Bq5FkCD+XwtIDMeQ+7i0b
        C0aJ5nbOU68XP3FabDqKEHZSB66cWOguFZlEd+ShTEq359VYdJv+abb3bsks0gVPslnsFqP7yX8
        xz5FpY6FTItht
X-Received: by 2002:a1c:5585:: with SMTP id j127mr18475768wmb.169.1607340247878;
        Mon, 07 Dec 2020 03:24:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxIRAJGBFvdVDfI+WpRVMoiiAV8K3/VaE7nYgOrcybS4c3NMHXNtf5dyFYLhSziHnu/8RZlw==
X-Received: by 2002:a1c:5585:: with SMTP id j127mr18475737wmb.169.1607340247750;
        Mon, 07 Dec 2020 03:24:07 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id m81sm13320148wmf.29.2020.12.07.03.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 03:24:07 -0800 (PST)
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
Subject: [PATCH v2 2/5] gitlab-ci: Replace YAML anchors by extends (cross_system_build_job)
Date:   Mon,  7 Dec 2020 12:23:50 +0100
Message-Id: <20201207112353.3814480-3-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207112353.3814480-1-philmd@redhat.com>
References: <20201207112353.3814480-1-philmd@redhat.com>
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

