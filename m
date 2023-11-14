Return-Path: <kvm+bounces-1672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DA157EB29B
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:40:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 499062812AE
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E3A41746;
	Tue, 14 Nov 2023 14:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E1PUaRm1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063DA41747
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:40:32 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761B2185
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:40:30 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9d216597f64so867250466b.3
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972829; x=1700577629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=85224ACu16xcahxMJd73na2pr08geUP2BaqK8DQk41g=;
        b=E1PUaRm1NYxy59keC1dubEsXuF91chxN3q/2e3QtP7K0e5DIuXmyWeZ0WDTMwa+4z1
         oA8SKd6r20VqeRqr09rExjqsR38forvBdtXa5CKMA275WEMwSbfPEZ/z6RmmoUpGlCPC
         9IoeSwSD1gCmn9VXNLoPFPquj/P7Qwvtx9XfcaDi3P61SGeSOthWjUeftHdhpteUzJJB
         6kONfCaQCTqoKCq3uYWXHUjbUTh/n3TW+2HTDOAmXfhtk9OEWRVeQVXyRJztAhG0Nr5Z
         QHaOOci38fUrnAU9sAMfhwDX6l+ikStAUMd2Acj+oAJwojCqbC+dtSo9Zfw+mVHHEQ8+
         Mhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972829; x=1700577629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=85224ACu16xcahxMJd73na2pr08geUP2BaqK8DQk41g=;
        b=mh/BNJfP4cdacLvz1s0UBdr/b11WWOeB5hMI96YQ1qTtgFE8g5NT8/XLqWSpQF0o4n
         GM/B1EDGJ94YBFMsuCfQTSlErC1VK+kIcOXWrrm80J2Q/Yai3pPDks10IlV2kDRdXUDw
         tIzqBPexYfmQoGpnbzA/BcMkak73Acvy0WBfTD0x4VMzCHRVThUt1Kaz+NDdEcTJTB6C
         QcLy3MUpUSTxQy68ymLIMwXiuIp+Whx20fj6chcYizshwaPYqRWojET1sC6sCe3OxT17
         WouMXQ8CM8DEucHkSxBZSsuXTHkOgGEUS+vFKwp/kMa84I4X0enlcwKnPd0vegxYFBKu
         uUsg==
X-Gm-Message-State: AOJu0YwZ7lkNqLK+bmP+39AkjIURNYmBpyH3wetuKUPGKZiPZp1Ljbwm
	RR9SXgO7J7HErzLsYVDw0pbxwg==
X-Google-Smtp-Source: AGHT+IE4fe4f8bleIo+ydEdJnHpXElyEFzfSvfuN7IjKmK4sPC2Xb+6oIBNsyuQ4jtW9IDSYhgY52Q==
X-Received: by 2002:a17:907:969f:b0:9eb:af0e:39da with SMTP id hd31-20020a170907969f00b009ebaf0e39damr3096379ejc.46.1699972828864;
        Tue, 14 Nov 2023 06:40:28 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id t25-20020a1709066bd900b0099c53c4407dsm5561943ejs.78.2023.11.14.06.40.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:40:28 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: David Woodhouse <dwmw@amazon.co.uk>,
	qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>
Subject: [PATCH-for-9.0 v2 19/19] hw/xen: Have most of Xen files become target-agnostic
Date: Tue, 14 Nov 2023 15:38:15 +0100
Message-ID: <20231114143816.71079-20-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231114143816.71079-1-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Previous commits re-organized the target-specific bits
from Xen files. We can now build the common files once
instead of per-target.

Only 4 files call libxen API (thus its CPPFLAGS):
- xen-hvm-common.c,
- xen_pt.c, xen_pt_graphics.c, xen_pt_msi.c

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Reworked since v1 so dropping David's R-b tag.
---
 accel/xen/meson.build          |  2 +-
 hw/block/dataplane/meson.build |  2 +-
 hw/xen/meson.build             | 21 ++++++++++-----------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/accel/xen/meson.build b/accel/xen/meson.build
index 002bdb03c6..455ad5d6be 100644
--- a/accel/xen/meson.build
+++ b/accel/xen/meson.build
@@ -1 +1 @@
-specific_ss.add(when: 'CONFIG_XEN', if_true: files('xen-all.c'))
+system_ss.add(when: 'CONFIG_XEN', if_true: files('xen-all.c'))
diff --git a/hw/block/dataplane/meson.build b/hw/block/dataplane/meson.build
index 025b3b061b..4d8bcb0bb9 100644
--- a/hw/block/dataplane/meson.build
+++ b/hw/block/dataplane/meson.build
@@ -1,2 +1,2 @@
 system_ss.add(when: 'CONFIG_VIRTIO_BLK', if_true: files('virtio-blk.c'))
-specific_ss.add(when: 'CONFIG_XEN_BUS', if_true: files('xen-block.c'))
+system_ss.add(when: 'CONFIG_XEN_BUS', if_true: files('xen-block.c'))
diff --git a/hw/xen/meson.build b/hw/xen/meson.build
index d887fa9ba4..403cab49cf 100644
--- a/hw/xen/meson.build
+++ b/hw/xen/meson.build
@@ -7,26 +7,25 @@ system_ss.add(when: ['CONFIG_XEN_BUS'], if_true: files(
   'xen_pvdev.c',
 ))
 
-system_ss.add(when: ['CONFIG_XEN', xen], if_true: files(
+system_ss.add(when: ['CONFIG_XEN'], if_true: files(
   'xen-operations.c',
-))
-
-xen_specific_ss = ss.source_set()
-xen_specific_ss.add(files(
   'xen-mapcache.c',
+))
+system_ss.add(when: ['CONFIG_XEN', xen], if_true: files(
   'xen-hvm-common.c',
 ))
+
 if have_xen_pci_passthrough
-  xen_specific_ss.add(files(
+  system_ss.add(when: ['CONFIG_XEN'], if_true: files(
     'xen-host-pci-device.c',
-    'xen_pt.c',
     'xen_pt_config_init.c',
-    'xen_pt_graphics.c',
     'xen_pt_load_rom.c',
+  ))
+  system_ss.add(when: ['CONFIG_XEN', xen], if_true: files(
+    'xen_pt.c',
+    'xen_pt_graphics.c',
     'xen_pt_msi.c',
   ))
 else
-  xen_specific_ss.add(files('xen_pt_stub.c'))
+  system_ss.add(when: ['CONFIG_XEN'], if_true: files('xen_pt_stub.c'))
 endif
-
-specific_ss.add_all(when: ['CONFIG_XEN', xen], if_true: xen_specific_ss)
-- 
2.41.0


