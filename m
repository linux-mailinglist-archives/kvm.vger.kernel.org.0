Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C15A2D06AD
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 19:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgLFS5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 13:57:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727852AbgLFS46 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 13:56:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607280931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zj+VAsR2ZoGWNnB8pF1RFhJWmR0T2bfs3Brc/xrE4Jk=;
        b=eOjZ2gvY9aHksYNUJDp52FT47A5P6K4RubxOFKoEd9HpdjDLpHaWtEioazmo8xDuzBtTI+
        Yr1kKKbRgBovNZ4Qfi8Zd0MoI94kziJAyqLrHfDD1jrNKm9zs8d/k/kUpOx7zwlMr+MK12
        Je077ACTFDNQmt35UwBDGJaLxibUXQA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-it50OpIGMOaPAALfCFBAXg-1; Sun, 06 Dec 2020 13:55:29 -0500
X-MC-Unique: it50OpIGMOaPAALfCFBAXg-1
Received: by mail-wm1-f72.google.com with SMTP id f12so4294732wmf.6
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 10:55:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zj+VAsR2ZoGWNnB8pF1RFhJWmR0T2bfs3Brc/xrE4Jk=;
        b=sp/GuZkPeT+3dJAPLkIGyRBQg/0BqDu1Jfn0FgCqoehxDDGV4qQ+afdyMFAaRpqn7A
         djn5Roz5NecLXLOIsDik0k3TM7e4q3K9ww5P9J8GxR0NK70iQETSxXqborJ/6YQ1SIzE
         xYGeQsw9RIqcCgQUOdZJo1sc2DozfhAKbhQXPrMqWdj3ZJdF/FNKT0qtnElKyDBTvAnN
         MKab+7QcNJpZ7KeSTOZiLqEURvY4vn5WtIg1kALgZ6/MWStu8DEWOK0e4W3fpOA/a34I
         jiLAQVHKA0mE/LnSx3NyxKJ5OwB+hMh58Ep1i3kIhKZvb23Bw7JIvXZ3P+3sqbviRVMF
         aXsQ==
X-Gm-Message-State: AOAM533XL6icPAe55/OHZ2yEJpNGPIbhch8RrLtWmC2j0GAXAN2yDTYq
        K3b4IRDbQEYHLfFspbjUZgauV2MaHUh8+FWd7BoC265VZeYiy2lW3zEqlx4UGp7bYQDItWCqntJ
        iO+NloiaowWsG
X-Received: by 2002:a1c:a501:: with SMTP id o1mr9847442wme.44.1607280928821;
        Sun, 06 Dec 2020 10:55:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjfkR9jOQCSNmbsQLisARRNPGgWAcGrUN24/vbSdXT+mIj5Zt7/jygW8L9ukGbdalO0fSF2A==
X-Received: by 2002:a1c:a501:: with SMTP id o1mr9847417wme.44.1607280928628;
        Sun, 06 Dec 2020 10:55:28 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id i5sm12530329wrw.45.2020.12.06.10.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:55:28 -0800 (PST)
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
Subject: [PATCH 3/8] gitlab-ci: Add KVM X86 cross-build jobs
Date:   Sun,  6 Dec 2020 19:55:03 +0100
Message-Id: <20201206185508.3545711-4-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206185508.3545711-1-philmd@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build x86 target with only KVM accelerator enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds-kvm-x86.yml | 6 ++++++
 .gitlab-ci.yml                       | 1 +
 MAINTAINERS                          | 1 +
 3 files changed, 8 insertions(+)
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-x86.yml

diff --git a/.gitlab-ci.d/crossbuilds-kvm-x86.yml b/.gitlab-ci.d/crossbuilds-kvm-x86.yml
new file mode 100644
index 00000000000..9719a19d143
--- /dev/null
+++ b/.gitlab-ci.d/crossbuilds-kvm-x86.yml
@@ -0,0 +1,6 @@
+cross-amd64-kvm:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-amd64-cross
+    TARGETS: i386-softmmu,x86_64-softmmu
+    ACCEL_CONFIGURE_OPTS: --disable-tcg
diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index d0173e82b16..cdfa1f82a3d 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -12,6 +12,7 @@ include:
   - local: '/.gitlab-ci.d/opensbi.yml'
   - local: '/.gitlab-ci.d/containers.yml'
   - local: '/.gitlab-ci.d/crossbuilds.yml'
+  - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
 
 .native_build_job_template: &native_build_job_definition
   stage: build
diff --git a/MAINTAINERS b/MAINTAINERS
index 68bc160f41b..8d7e2fdb7e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -427,6 +427,7 @@ L: kvm@vger.kernel.org
 S: Supported
 F: target/i386/kvm.c
 F: scripts/kvm/vmxcap
+F: .gitlab-ci.d/crossbuilds-kvm-x86.yml
 
 Guest CPU Cores (other accelerators)
 ------------------------------------
-- 
2.26.2

