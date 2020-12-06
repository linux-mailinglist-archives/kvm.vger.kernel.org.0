Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6228E2D06AF
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 19:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgLFS5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 13:57:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727874AbgLFS5L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 13:57:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607280945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ICTgDX+4v4WDebhKXLX3qGQtibzA3mRvScrd6C7n6Ec=;
        b=aRApqZ4PbsbUtaZMEJs3B1XVmD/Ebgu2jnyneijYMZ4hMVCKlArNDBR80AO+1dVGh7VBH/
        09YDmKab6pg4m8tC3hBnDGm2kIwzHg88fdeMTrjEqJJr6NSmz2yECvWgMLgJ2bIKjq8Th2
        5GOZCzm3Ex9WAj7lgc6+6F5ZVoSH67U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-oH62SAeRNAS7bKnS_kSnlw-1; Sun, 06 Dec 2020 13:55:41 -0500
X-MC-Unique: oH62SAeRNAS7bKnS_kSnlw-1
Received: by mail-wm1-f71.google.com with SMTP id g198so3222019wme.7
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 10:55:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ICTgDX+4v4WDebhKXLX3qGQtibzA3mRvScrd6C7n6Ec=;
        b=La1W9v3dIyI5jsg+5S04nHXc+mnTjuRWvOFl/g47SVCF2yAsP7D2wPXhZlsvu/91io
         3UGvOAr8e/1coGZedS+BapIO3kgL1Rc1xA76mk7zTO0VuNxnYDkAo31CNgOw6NxPxEiK
         MPGJaCwRkWTmW0F86xb37led41wcZA+VZdxlcQWejS6yHbIbox7GOaFFerCtt/jZzQs6
         FPqWK73kCcy0gyGxa/CId4p7l5DRhwApOaqQBe6mZ6YWyFhoeICPL7fHpbQTuqAyo+QG
         3fSryEOHZweyeg59k4D/HRqHCWvmFiBbOjcosrWLwsHGlxrp7MkGcdtkiEoF86llUou0
         Eagw==
X-Gm-Message-State: AOAM531XvW3Y9kQcvEsSXZHRY+2pkaGDB+DWmcHv5FhJKmFAwHb0DQ+4
        rFKiVYmsbVOAxurua3o0+OKEmQ5X43QXbr2JJokrt6g/qHYNOBYXV/A9i5IlqKuJus+K46ugA1y
        SIfWaJlRd/B3w
X-Received: by 2002:a1c:9d8b:: with SMTP id g133mr14902014wme.189.1607280940114;
        Sun, 06 Dec 2020 10:55:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwS0gmyZIlDu9x3zdPI4XoBOwxS0bhZqQbF0DZUVSQQ25mAYsGy/bDy2iLLg12EuoAvmHTkDA==
X-Received: by 2002:a1c:9d8b:: with SMTP id g133mr14902001wme.189.1607280939914;
        Sun, 06 Dec 2020 10:55:39 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id l1sm5951733wrq.64.2020.12.06.10.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:55:39 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Claudio Fontana <cfontana@suse.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org
Subject: [PATCH 5/8] gitlab-ci: Add KVM s390x cross-build jobs
Date:   Sun,  6 Dec 2020 19:55:05 +0100
Message-Id: <20201206185508.3545711-6-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206185508.3545711-1-philmd@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build s390x target with only KVM accelerator enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds-kvm-s390x.yml | 6 ++++++
 .gitlab-ci.yml                         | 1 +
 MAINTAINERS                            | 1 +
 3 files changed, 8 insertions(+)
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-s390x.yml

diff --git a/.gitlab-ci.d/crossbuilds-kvm-s390x.yml b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
new file mode 100644
index 00000000000..1731af62056
--- /dev/null
+++ b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
@@ -0,0 +1,6 @@
+cross-s390x-kvm:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-s390x-cross
+    TARGETS: s390x-softmmu
+    ACCEL_CONFIGURE_OPTS: --disable-tcg
diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 573afceb3c7..a69619d7319 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -14,6 +14,7 @@ include:
   - local: '/.gitlab-ci.d/crossbuilds.yml'
   - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
   - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
+  - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
 
 .native_build_job_template: &native_build_job_definition
   stage: build
diff --git a/MAINTAINERS b/MAINTAINERS
index 40271eba592..d41401f6683 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -417,6 +417,7 @@ F: hw/intc/s390_flic.c
 F: hw/intc/s390_flic_kvm.c
 F: include/hw/s390x/s390_flic.h
 F: gdb-xml/s390*.xml
+F: .gitlab-ci.d/crossbuilds-kvm-s390x.yml
 T: git https://github.com/cohuck/qemu.git s390-next
 T: git https://github.com/borntraeger/qemu.git s390-next
 L: qemu-s390x@nongnu.org
-- 
2.26.2

