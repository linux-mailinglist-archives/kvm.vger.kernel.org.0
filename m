Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91BB2D06AE
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 19:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgLFS5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 13:57:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgLFS5D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 13:57:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607280937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vxt3MEZXS260piBfvrRF2LPibTg2rLk2j2FgrTceEtE=;
        b=T1jvEwq7Em4yW6lMzfI7oJLiCIkSa8+/UyCu9k+LsvbEN9LhiFDZzIWacmQfXrWwIrR+yx
        j6YbvI6AwHBhUZ0jhKYwD5FPkUQoWlDhSTI0LpO2OnmFUolxyRKTDPm0m93DzbAKiUVy0P
        TVqRflLAPBnWrRF0McAk9zEiMGy3FSo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-IXZ-Xy-wMLaRMlGvjmyCBA-1; Sun, 06 Dec 2020 13:55:35 -0500
X-MC-Unique: IXZ-Xy-wMLaRMlGvjmyCBA-1
Received: by mail-wm1-f69.google.com with SMTP id z12so4305321wmf.9
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 10:55:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vxt3MEZXS260piBfvrRF2LPibTg2rLk2j2FgrTceEtE=;
        b=oh3oIpJfuEsKSrHR1zZS7IK40TDs8MM5opeNqftpF8v/yFcsXCDm6AbHLaxd2BhQnF
         sbiG6d7izTRWxjW3ay0BEQmfPRXf2dLvZMi1atX8QUVtOZ7An7mme94g/QT9OXUyuvGs
         XQOS9Xtx5GtaESueZfzVJLKXRYLBW7Y55P7IsosgjOUMnBQ01uSN8BHvLzcQDAwXRYfU
         kPLO9Cr/ozvAIxYFMyq/Al1RCm6gttcKvG5lfCR3JfUmmcBhL5C1ERFRYtCO6EH8SCqd
         iZNJc/dN0npNbEYUszFJV5/ELdoGBpsCC5qJJME8nZE2XS0jP7KNNDnos7jEYnjnWxeH
         Lw0A==
X-Gm-Message-State: AOAM533kiagYPaSq0PawOD+DDflAuaYvFniW2nj+Z1jYJk8jly3YsET3
        FTNttNgCC7RTssCEuGBxMWXLdxZWM0r0pw20j7praC/yRLNxPYpmqIJaDpWdRm8gLnwMpzfr0MW
        8ePgBmmjUhiRk
X-Received: by 2002:a1c:48d:: with SMTP id 135mr14975788wme.147.1607280934465;
        Sun, 06 Dec 2020 10:55:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4k4/YkSarxB89UuEp4wGBYMDt9qPp414ZW0Hy6JgLmQ1zgyBWhlkGZseJ8x91ebcKHRE8vw==
X-Received: by 2002:a1c:48d:: with SMTP id 135mr14975772wme.147.1607280934329;
        Sun, 06 Dec 2020 10:55:34 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id l8sm12023533wmf.35.2020.12.06.10.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:55:33 -0800 (PST)
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
Subject: [PATCH 4/8] gitlab-ci: Add KVM ARM cross-build jobs
Date:   Sun,  6 Dec 2020 19:55:04 +0100
Message-Id: <20201206185508.3545711-5-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206185508.3545711-1-philmd@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build ARM aarch64 target with KVM and TCG accelerators enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
later this job will build KVM-only.
---
 .gitlab-ci.d/crossbuilds-kvm-arm.yml | 5 +++++
 .gitlab-ci.yml                       | 1 +
 MAINTAINERS                          | 1 +
 3 files changed, 7 insertions(+)
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-arm.yml

diff --git a/.gitlab-ci.d/crossbuilds-kvm-arm.yml b/.gitlab-ci.d/crossbuilds-kvm-arm.yml
new file mode 100644
index 00000000000..c74c6fdc9fb
--- /dev/null
+++ b/.gitlab-ci.d/crossbuilds-kvm-arm.yml
@@ -0,0 +1,5 @@
+cross-arm64-kvm:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-arm64-cross
+    TARGETS: aarch64-softmmu
diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index cdfa1f82a3d..573afceb3c7 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -13,6 +13,7 @@ include:
   - local: '/.gitlab-ci.d/containers.yml'
   - local: '/.gitlab-ci.d/crossbuilds.yml'
   - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
+  - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
 
 .native_build_job_template: &native_build_job_definition
   stage: build
diff --git a/MAINTAINERS b/MAINTAINERS
index 8d7e2fdb7e2..40271eba592 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -386,6 +386,7 @@ M: Peter Maydell <peter.maydell@linaro.org>
 L: qemu-arm@nongnu.org
 S: Maintained
 F: target/arm/kvm.c
+F: .gitlab-ci.d/crossbuilds-kvm-arm.yml
 
 MIPS KVM CPUs
 M: Huacai Chen <chenhc@lemote.com>
-- 
2.26.2

