Return-Path: <kvm+bounces-29377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 572609AA0A5
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:58:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF6D51F26456
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D731E19DF7D;
	Tue, 22 Oct 2024 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mcai016h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D88019D090
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594599; cv=none; b=i5DFYlmpA/T0YmhQ2BUg2CUZ/oDM9bh5jhxFpZkx6jckISQ5pg18t8u0vogUi2g7pSvDwVyUQSmi1MPAVA+WUpdNKIpnlwXXCJnK2++RSjMcRqkvs0Y8rhjE7M2zpO3beR0T/h5bk/VY5n+1EjjHv21mgQEjovYV3q92VgKwQCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594599; c=relaxed/simple;
	bh=y2yqgDvf+xSMqKWaI5eABRrwqp58kC8YfNhhuIyptUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewS+YcO34inh+sKRBBMVNZx5x5HIx5cfpALnUenaTegTH6ptQ3XOKV15dzjwEpid+iSHqONTK30B00HEsQFHrFEy6lZRJe+EcWei5qOvh1+j0ibIKXt03XHTkX2RiYK6/sxdRpIURfsmZJ7W1b4OSxX/JdndxuLjOVhqPQ/Obs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mcai016h; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a0cee600aso691045466b.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594596; x=1730199396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59EXaptdsAtTsnL7N0QHtzvibi/ktz9wJ6DO/DYK14s=;
        b=mcai016hu6ljeCX+IX1Teg261Snih2INiTt0UswfqQhWMyl1ByeGrrf2s+VA0uK7hT
         wkEX9QLjw0nyTnTvYxVU5i2fK4O6M5UmOkfewpOKC1BqqL3W6EM1oMN05CssFHsY1cD1
         syxCN8jIs9uX6ogl6Ubu0QolPFnB0DEUySuXH+HNTWTrEKhGviMwtj9EoWPITDm0xmYY
         KWIM/kETiEgeJy+/rb21R5Q1D4EpYBuskMHmiykBs5MCn1TiMyxa8+81SrpYwPVhHqbP
         21aiCx2XO7RfF5fKCNW1eTNkHySO9MfIGBbFsaA78eQMhma7QJJ4J/NLegNvYKJJ6auv
         ijDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594596; x=1730199396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=59EXaptdsAtTsnL7N0QHtzvibi/ktz9wJ6DO/DYK14s=;
        b=hAg15D0rAYbtjImlFx0ThzSo34wedWQda8xyOBQFADkbYqAsQrw0PwUhGW9b3vKXiN
         1qaiZ3OXMYAr+JRBACCG1rPAu0YwrqGVSnlsrq8fqfe5fD+8qpndjOAjpt0KkkzHoF44
         s9ri2/stDSVRm3odllqjsfjbs2a5Hf/5dPjqTWcO+JeGEuxC70pL/k62o35iSdSkL7Cw
         qr4ht4RfirnS8tZBcJl725plkdl2q6Oc874JQe5417ZBXpYuwqlg4djonl2QQh5aEjAb
         bqjJsVKS4DfoKe4SNgrCdJvyClB+pg5C18eeeuLyOjFDG+B5B4nB7cm8UnAeQJtz/rYW
         E7pw==
X-Forwarded-Encrypted: i=1; AJvYcCWq36IWkOc7JBWsZcn1IPksTCfM3xbYN6AIMJH38l/ET0es3M5aA6ZRnzlqyX9EJiBNzQs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTG2rUXl5LD7KM/RDt5OKEbxbhaWVeUDHBZTlwq65iC0HeBBDG
	lEctqkttJhJ+Ba1AUrs0IBFaNFfWgR2p1P8IAXw83UqYcij4M7sU2rZFRnT8/34=
X-Google-Smtp-Source: AGHT+IESzzC72mFFjVxSlJ9yKckkgejJYGt9NcC+1VBYY14emqGj0/mOgmagBB965bWs6j/k5E+0qQ==
X-Received: by 2002:a17:907:d2a:b0:a9a:5e3a:641d with SMTP id a640c23a62f3a-a9aad376421mr153636366b.59.1729594595748;
        Tue, 22 Oct 2024 03:56:35 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a915a48aesm326490066b.221.2024.10.22.03.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:32 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 394875FC3D;
	Tue, 22 Oct 2024 11:56:16 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	devel@lists.libvirt.org,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 18/20] meson: build contrib/plugins with meson
Date: Tue, 22 Oct 2024 11:56:12 +0100
Message-Id: <20241022105614.839199-19-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241022105614.839199-1-alex.bennee@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Tried to unify this meson.build with tests/tcg/plugins/meson.build but
the resulting modules are not output in the right directory.

Originally proposed by Anton Kochkov, thank you!

Solves: https://gitlab.com/qemu-project/qemu/-/issues/1710
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Message-Id: <20240925204845.390689-2-pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 meson.build                 |  4 ++++
 contrib/plugins/meson.build | 23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 contrib/plugins/meson.build

diff --git a/meson.build b/meson.build
index bdd67a2d6d..3ea03c451b 100644
--- a/meson.build
+++ b/meson.build
@@ -3678,6 +3678,10 @@ subdir('accel')
 subdir('plugins')
 subdir('ebpf')
 
+if 'CONFIG_TCG' in config_all_accel
+  subdir('contrib/plugins')
+endif
+
 common_user_inc = []
 
 subdir('common-user')
diff --git a/contrib/plugins/meson.build b/contrib/plugins/meson.build
new file mode 100644
index 0000000000..a0e026d25e
--- /dev/null
+++ b/contrib/plugins/meson.build
@@ -0,0 +1,23 @@
+t = []
+if get_option('plugins')
+  foreach i : ['cache', 'drcov', 'execlog', 'hotblocks', 'hotpages', 'howvec',
+               'hwprofile', 'ips', 'lockstep', 'stoptrigger']
+    if host_os == 'windows'
+      t += shared_module(i, files(i + '.c') + 'win32_linker.c',
+                        include_directories: '../../include/qemu',
+                        link_depends: [win32_qemu_plugin_api_lib],
+                        link_args: ['-Lplugins', '-lqemu_plugin_api'],
+                        dependencies: glib)
+
+    else
+      t += shared_module(i, files(i + '.c'),
+                        include_directories: '../../include/qemu',
+                        dependencies: glib)
+    endif
+  endforeach
+endif
+if t.length() > 0
+  alias_target('contrib-plugins', t)
+else
+  run_target('contrib-plugins', command: find_program('true'))
+endif
-- 
2.39.5


