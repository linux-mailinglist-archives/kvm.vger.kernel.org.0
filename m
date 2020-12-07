Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B940C2D11A7
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 14:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgLGNQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 08:16:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbgLGNQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 08:16:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607346926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LrpyM62Xrmp0dmj6zHS9IbusrVswsePAgvUQq8W1ha4=;
        b=iYVyhUlO7Zg+2vqUm7Wcdm4bsG18bLtBV4hSs+wqhvKK6vb9+sutl90vA4N8eMqEZi4iUC
        NsK9NTsM+q9TxAnVPZ3XS3syAmz13qNdVHLg4ikUy4q5IUeFiO3w2zJPiE5IP2iHbJfE+x
        QiF4zHRa+QkUI/H9qRAfFzIvfzaeRCc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-PA7PCwsdPHKAeIERfWPTvw-1; Mon, 07 Dec 2020 08:15:24 -0500
X-MC-Unique: PA7PCwsdPHKAeIERfWPTvw-1
Received: by mail-wr1-f70.google.com with SMTP id y5so825767wrs.15
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 05:15:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LrpyM62Xrmp0dmj6zHS9IbusrVswsePAgvUQq8W1ha4=;
        b=aEWRPGwxui4aDfprFh2Uu+TDVnYXOkZVpYQ0Ju6/8ojHcQUHTdM7DaH2kn4RhrRCEX
         OIv0ccPzHPnbM+xEhH9v8o4o8IAQ+2gKHw35gdl1voseK5jHM1Ljp1PItr6Oi8HPWbse
         lmf67Khzvj58Il5UemRffbkEYwo12jJ2DUvd6wOqwCUQCDP+4QHgjFsT8KmQ5us0Fhqu
         HZyjU/BlXoRZt2FTcKTGdFnZDmsI33Hv7B7f5i2wMHShsdsxp4cwXCG6f4Zhf/SXZXYl
         DJ3KH92aG/fGssCoKlkJK0GIxSBrgD0i4j19Ph26b/OyH5R7R2TDXBoi0Pb+kAN+sJdX
         8QXg==
X-Gm-Message-State: AOAM5339R4CzvvsoPHn0QwPlYnELin4iXp9RszY8Wa001kyPlKed0Yz8
        FIPGIDfVHfiT+4WLyefE55HCCAL8Qbm0sQ5o2RIAw1/l0nEUq97cTy0mpXLmOsCtyoDoN7jHroU
        tlvDIbqt2Im76
X-Received: by 2002:adf:eec6:: with SMTP id a6mr7411033wrp.239.1607346923076;
        Mon, 07 Dec 2020 05:15:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrSsP/k6tbNGXTd5ADaSfYhwBX1LosPwHROoqvLj3ywUi8jkYDiFzi1eqHTc0kTww1719V1w==
X-Received: by 2002:adf:eec6:: with SMTP id a6mr7411023wrp.239.1607346922931;
        Mon, 07 Dec 2020 05:15:22 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id b3sm14942829wrp.57.2020.12.07.05.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 05:15:22 -0800 (PST)
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
Subject: [PATCH v3 3/5] gitlab-ci: Introduce 'cross_accel_build_job' template
Date:   Mon,  7 Dec 2020 14:15:01 +0100
Message-Id: <20201207131503.3858889-4-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207131503.3858889-1-philmd@redhat.com>
References: <20201207131503.3858889-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a job template to cross-build accelerator specific
jobs (enable a specific accelerator, disabling the others).

The specific accelerator is selected by the $ACCEL environment
variable (default to KVM).

Extra options such disabling other accelerators are passed
via the $ACCEL_CONFIGURE_OPTS environment variable.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds.yml | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index 099949aaef3..b59516301f4 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -13,6 +13,23 @@
           xtensa-softmmu"
     - make -j$(expr $(nproc) + 1) all check-build
 
+# Job to cross-build specific accelerators.
+#
+# Set the $ACCEL variable to select the specific accelerator (default to
+# KVM), and set extra options (such disabling other accelerators) via the
+# $ACCEL_CONFIGURE_OPTS variable.
+.cross_accel_build_job:
+  stage: build
+  image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
+  timeout: 30m
+  script:
+    - mkdir build
+    - cd build
+    - PKG_CONFIG_PATH=$PKG_CONFIG_PATH
+      ../configure --enable-werror $QEMU_CONFIGURE_OPTS --disable-tools
+        --enable-${ACCEL:-kvm} $ACCEL_CONFIGURE_OPTS
+    - make -j$(expr $(nproc) + 1) all check-build
+
 .cross_user_build_job:
   stage: build
   image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
-- 
2.26.2

