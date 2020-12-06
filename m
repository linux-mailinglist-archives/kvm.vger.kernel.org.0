Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59A92D06B2
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 19:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgLFS51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 13:57:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgLFS50 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 13:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607280960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TJv54j6i8iOuNb5cgwW4vcH7LWLUemKzrpTz+i6TyMo=;
        b=E0wDumpJpYwRYrAFMVG+aZdyRm+REZXv9B20r+UfR/2RpfxwHd8J7hJI23d87ydV6X26//
        Orqcz0v2TAvdEAziRbq7t0lgZXU9wDayWOqCJVklVz2bGtFfg2b78Hqvp7ZiciUjgAjsrq
        J2X06dhP3a64hdhIquou5u8vmSoJwK4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-o4MdmFisNiG3JWDH5uWb2w-1; Sun, 06 Dec 2020 13:55:58 -0500
X-MC-Unique: o4MdmFisNiG3JWDH5uWb2w-1
Received: by mail-wm1-f71.google.com with SMTP id l5so3281538wmi.4
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 10:55:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TJv54j6i8iOuNb5cgwW4vcH7LWLUemKzrpTz+i6TyMo=;
        b=fs8O6Tqbi8Qm09+srDWVHmU/oAlIHhxKtvFUotWVaxg7ATPSvoV+8See0zTvCm7KFS
         gorKGRe4LjX3h5QALVnsKTxTn41NaXEjv69/RLMSvVwzjL9EsDgTh7vgdU1r0Hyi9A/o
         Bv+ojCqyX7bmwvT0JOpYcBrf7ywR7pzSGs+iePSKHAT+KO2cmLsME2pf1VLmZH2E1qIu
         UOd8pwqi4FYqDAqtk+v9FJsd3UZWIyZdpO+DgWC6PzRZeebzTwQ7N/UP6zwJorsiouH7
         neYB4Ppa+n6lMkOOAfh156NR6hUSupyu3YtC3k2feafamO7ZFBxrJeFFNV6paxgzxL2M
         nyaQ==
X-Gm-Message-State: AOAM530L01tOGpz0QuYPGcaslxGRSxTJFlD3NL6QgQ3Pj2ScRj18bnM0
        Z5KGMgKjBjBtzvKECUXqKarJaTZzFoVWQ4iVsTxnY7g+Xzv85rZt7E0cWspcSB4vW9yv8A5bC34
        lrEfRGbcaoBjq
X-Received: by 2002:a5d:540f:: with SMTP id g15mr7837215wrv.397.1607280957359;
        Sun, 06 Dec 2020 10:55:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaQWa5KUxTpGy2U2kfc8S05U9x2ntHy5AYmvHAQPO8HICDiiXk9/Erff4S29pCdX8ZlczzjA==
X-Received: by 2002:a5d:540f:: with SMTP id g15mr7837200wrv.397.1607280957219;
        Sun, 06 Dec 2020 10:55:57 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id f199sm10894749wme.15.2020.12.06.10.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:55:56 -0800 (PST)
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
Subject: [PATCH 8/8] gitlab-ci: Add Xen cross-build jobs
Date:   Sun,  6 Dec 2020 19:55:08 +0100
Message-Id: <20201206185508.3545711-9-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206185508.3545711-1-philmd@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build ARM and X86 targets with only Xen accelerator enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds-xen.yml | 14 ++++++++++++++
 .gitlab-ci.yml                   |  1 +
 MAINTAINERS                      |  1 +
 3 files changed, 16 insertions(+)
 create mode 100644 .gitlab-ci.d/crossbuilds-xen.yml

diff --git a/.gitlab-ci.d/crossbuilds-xen.yml b/.gitlab-ci.d/crossbuilds-xen.yml
new file mode 100644
index 00000000000..9c4def4feeb
--- /dev/null
+++ b/.gitlab-ci.d/crossbuilds-xen.yml
@@ -0,0 +1,14 @@
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
diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 5f607fc7b48..9765c2199f7 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -17,6 +17,7 @@ include:
   - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
   - local: '/.gitlab-ci.d/crossbuilds-kvm-ppc.yml'
   - local: '/.gitlab-ci.d/crossbuilds-kvm-mips.yml'
+  - local: '/.gitlab-ci.d/crossbuilds-xen.yml'
 
 .native_build_job_template: &native_build_job_definition
   stage: build
diff --git a/MAINTAINERS b/MAINTAINERS
index 5f26626a512..1581e120629 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -488,6 +488,7 @@ F: include/hw/xen/
 F: include/sysemu/xen.h
 F: include/sysemu/xen-mapcache.h
 F: stubs/xen-hw-stub.c
+F: .gitlab-ci.d/crossbuilds-xen.yml
 
 Guest CPU Cores (HAXM)
 ---------------------
-- 
2.26.2

