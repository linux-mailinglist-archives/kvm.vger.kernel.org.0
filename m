Return-Path: <kvm+bounces-51431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D1E2AF712E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2221A4E5A94
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DBC12E4249;
	Thu,  3 Jul 2025 10:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DHJm2Ryd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1EE2E3360
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540294; cv=none; b=mx5fezLSWrvY0KABJIUiIqMBvHNczcI4pknllyLutZCYKtSk8Tjjgy1RXPFkZPI8qzR8PnywEwvwbN0yz2auVAoocRld894+16WHtzYpg3esUcS/eASWAlMD4Xk4lr2xAjMsnrXCcDSxaCpGuWxQFnZmAPaNefVt8uJTD3elF6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540294; c=relaxed/simple;
	bh=qoBqwRrnJBC7tXsO/ZRMw7ZZ6/F0bHQ7HtugyI9clmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fTpSiNetB9Jh9KXaTNAg98OwXjFMHv0r2h+ZT/ut2JeZtS8dOmiO0FMfkPkkemxcyELGGF5C+A2Akxl/515/LncMKzPJuX2irCjrHupvh0SqFvfvm0sQZLzZwMg5prYJllMPA69ry6DvhqleEEgPNydrdE/lti/1ZH269b+xvCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DHJm2Ryd; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a4f379662cso4653674f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540291; x=1752145091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KIKdQEQMhRvU2if5P5ei68jHnjUcTCqPA9NR4/HOCwU=;
        b=DHJm2RydI3cSlh8NCMcagzWuu5LFM+ZXPsVbbPTuT4Bw6nrBHJkJ+DkbGPvz1SM7c3
         r4lMOOP6fnbawc2llFF15EhKXzhe+ctwc+CITfzAe1XXrmIxGBRRGfazE+U4tQkngVL/
         eH65KYUqGTnJhtWjbVUkQSf+pJIOjmwJ9ziRpDR4/YEi5/k9XlJ7tkJsReRG3kSCBljx
         e+5PkY9IF+nQikqR1UlxrJfY9KeguoQHBAWPoCG0zrQ57HTd2UWgOc4T73/fX8j3/j6E
         w/7hVJrCevwiaxPHJXH7tAD50RN0hkx0A9IMtRLyUJ7qCqiIkxWSJvkuKDDSPbjFvbPd
         zEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540291; x=1752145091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KIKdQEQMhRvU2if5P5ei68jHnjUcTCqPA9NR4/HOCwU=;
        b=ASg8xPQgK9OZEDbteoJB8P2rTZJpSPV45NCFUJLT8fHgrj2u93vlgW722k2zvXRhZV
         uRom1gLy3cjGBB51A9/qYazeF1d5Hy0L7mbckeIoRmNSSA24hckH598kEwHZ0t30/iVX
         jzoXyvqixsAJ3QsduPxPZvO7Rf4JIVvaRpXZ+NH6PGOY/DbqSD9fk+8qB3NJaYgMB3X5
         yMnm1IGLY8FRxPkQRhD4ATk/mDqPVksNMyakfn1xaYh0ZO+z/q1xXoWcv67CNiQtHGnj
         aNB5YktttuFRXX9TVVv3hgE+pyZELyxSM/RKE3ZnQocC7o04DvWbyBvdvEOSSIi9hirL
         I6eQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUnNzc87f6uh7cyuutffCYOac+9JYV5I1ZBJiJu4VHUHAzrvz8dmEBWDS1+8RBJSq06eo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiQfqS+WooUVZSuwOIXysHgCtwotpQvqHLO135kiSFZxlmJqxY
	CV1n41rh/Vdbw3j5oVpVvB1ftgoPDT02LEgSocqBmpBkRWOud/Rulra34Eq77OKHJlM=
X-Gm-Gg: ASbGncsrib/8d+VSl03NkX1hSVoylDZFdtwpzBQOT2/6VshhHEPmyRNzETlp07UBVAF
	M7Py1yr3l9Eg3OP3Xo7PxkLFtXWEbMvER0Zl030DBKIyw0L+9EX+HpncDYKf9nPtmRHWOLerhve
	+rn5U4m5XACdJxtZSBjFROA5m5/VdjEQoRmXLYKtJbDeC4sKhk57LcE2O7A9e4rOjaRlLpJv4Ex
	Z+xcpY6JuOKPK8WficuoKDIWLLeZ3EtLoSX/jEJe95uewXHnT4Lpnf1ICAz/KoXUFrZUepLyzHU
	3k54eHLlkxHH2fkWltA+st+d9X92Tj6mSEBTIvveJr4bWdgVYgK4UVWH5VvshsWtGCphWh1wjU5
	wE9AAaqptTbA=
X-Google-Smtp-Source: AGHT+IHwgKk5VrVHFX9rm+LGEdeJ7fke42sHffpGrRf9jRGQsl8mPqZf5MQ41AzswLHhRi5K9UL9vQ==
X-Received: by 2002:a05:6000:4611:b0:3a6:ec1d:1cba with SMTP id ffacd0b85a97d-3b1fea90838mr5549124f8f.20.1751540290789;
        Thu, 03 Jul 2025 03:58:10 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52bb3sm18652440f8f.56.2025.07.03.03.58.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:10 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [PATCH v5 28/69] qapi: Move definitions related to accelerators in their own file
Date: Thu,  3 Jul 2025 12:54:54 +0200
Message-ID: <20250703105540.67664-29-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Extract TCG and KVM definitions from machine.json to accelerator.json.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS                |  1 +
 qapi/accelerator.json      | 57 ++++++++++++++++++++++++++++++++++++++
 qapi/machine.json          | 47 -------------------------------
 qapi/qapi-schema.json      |  1 +
 accel/tcg/monitor.c        |  2 +-
 hw/core/machine-hmp-cmds.c |  1 +
 hw/core/machine-qmp-cmds.c |  1 +
 qapi/meson.build           |  1 +
 8 files changed, 63 insertions(+), 48 deletions(-)
 create mode 100644 qapi/accelerator.json

diff --git a/MAINTAINERS b/MAINTAINERS
index b1cbfe115bc..c3ce0d37779 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -507,6 +507,7 @@ F: accel/Makefile.objs
 F: accel/stubs/Makefile.objs
 F: cpu-common.c
 F: cpu-target.c
+F: qapi/accelerator.json
 F: system/cpus.c
 
 Apple Silicon HVF CPUs
diff --git a/qapi/accelerator.json b/qapi/accelerator.json
new file mode 100644
index 00000000000..00d25427059
--- /dev/null
+++ b/qapi/accelerator.json
@@ -0,0 +1,57 @@
+# -*- Mode: Python -*-
+# vim: filetype=python
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+##
+# = Accelerators
+##
+
+{ 'include': 'common.json' }
+
+##
+# @KvmInfo:
+#
+# Information about support for KVM acceleration
+#
+# @enabled: true if KVM acceleration is active
+#
+# @present: true if KVM acceleration is built into this executable
+#
+# Since: 0.14
+##
+{ 'struct': 'KvmInfo', 'data': {'enabled': 'bool', 'present': 'bool'} }
+
+##
+# @query-kvm:
+#
+# Return information about KVM acceleration
+#
+# Returns: @KvmInfo
+#
+# Since: 0.14
+#
+# .. qmp-example::
+#
+#     -> { "execute": "query-kvm" }
+#     <- { "return": { "enabled": true, "present": true } }
+##
+{ 'command': 'query-kvm', 'returns': 'KvmInfo' }
+
+##
+# @x-query-jit:
+#
+# Query TCG compiler statistics
+#
+# Features:
+#
+# @unstable: This command is meant for debugging.
+#
+# Returns: TCG compiler statistics
+#
+# Since: 6.2
+##
+{ 'command': 'x-query-jit',
+  'returns': 'HumanReadableText',
+  'if': 'CONFIG_TCG',
+  'features': [ 'unstable' ] }
diff --git a/qapi/machine.json b/qapi/machine.json
index acf6610efa5..e4713c405e8 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -454,35 +454,6 @@
 ##
 { 'command': 'inject-nmi' }
 
-##
-# @KvmInfo:
-#
-# Information about support for KVM acceleration
-#
-# @enabled: true if KVM acceleration is active
-#
-# @present: true if KVM acceleration is built into this executable
-#
-# Since: 0.14
-##
-{ 'struct': 'KvmInfo', 'data': {'enabled': 'bool', 'present': 'bool'} }
-
-##
-# @query-kvm:
-#
-# Return information about KVM acceleration
-#
-# Returns: @KvmInfo
-#
-# Since: 0.14
-#
-# .. qmp-example::
-#
-#     -> { "execute": "query-kvm" }
-#     <- { "return": { "enabled": true, "present": true } }
-##
-{ 'command': 'query-kvm', 'returns': 'KvmInfo' }
-
 ##
 # @NumaOptionsType:
 #
@@ -1729,24 +1700,6 @@
   'returns': 'HumanReadableText',
   'features': [ 'unstable' ] }
 
-##
-# @x-query-jit:
-#
-# Query TCG compiler statistics
-#
-# Features:
-#
-# @unstable: This command is meant for debugging.
-#
-# Returns: TCG compiler statistics
-#
-# Since: 6.2
-##
-{ 'command': 'x-query-jit',
-  'returns': 'HumanReadableText',
-  'if': 'CONFIG_TCG',
-  'features': [ 'unstable' ] }
-
 ##
 # @x-query-numa:
 #
diff --git a/qapi/qapi-schema.json b/qapi/qapi-schema.json
index a8f66163cb7..616e04970ef 100644
--- a/qapi/qapi-schema.json
+++ b/qapi/qapi-schema.json
@@ -55,6 +55,7 @@
 { 'include': 'introspect.json' }
 { 'include': 'qom.json' }
 { 'include': 'qdev.json' }
+{ 'include': 'accelerator.json' }
 { 'include': 'machine-common.json' }
 { 'include': 'machine.json' }
 { 'include': 'machine-s390x.json' }
diff --git a/accel/tcg/monitor.c b/accel/tcg/monitor.c
index adb9de5a1c6..d5dd677f2a4 100644
--- a/accel/tcg/monitor.c
+++ b/accel/tcg/monitor.c
@@ -9,7 +9,7 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "qapi/type-helpers.h"
-#include "qapi/qapi-commands-machine.h"
+#include "qapi/qapi-commands-accelerator.h"
 #include "monitor/monitor.h"
 #include "system/tcg.h"
 #include "internal-common.h"
diff --git a/hw/core/machine-hmp-cmds.c b/hw/core/machine-hmp-cmds.c
index 65eeb5e9cc2..15ae5864d16 100644
--- a/hw/core/machine-hmp-cmds.c
+++ b/hw/core/machine-hmp-cmds.c
@@ -18,6 +18,7 @@
 #include "monitor/monitor.h"
 #include "qapi/error.h"
 #include "qapi/qapi-builtin-visit.h"
+#include "qapi/qapi-commands-accelerator.h"
 #include "qapi/qapi-commands-machine.h"
 #include "qobject/qdict.h"
 #include "qapi/string-output-visitor.h"
diff --git a/hw/core/machine-qmp-cmds.c b/hw/core/machine-qmp-cmds.c
index ab4fd1ec08a..f37fd220c2d 100644
--- a/hw/core/machine-qmp-cmds.c
+++ b/hw/core/machine-qmp-cmds.c
@@ -14,6 +14,7 @@
 #include "hw/mem/memory-device.h"
 #include "qapi/error.h"
 #include "qapi/qapi-builtin-visit.h"
+#include "qapi/qapi-commands-accelerator.h"
 #include "qapi/qapi-commands-machine.h"
 #include "qobject/qobject.h"
 #include "qapi/qobject-input-visitor.h"
diff --git a/qapi/meson.build b/qapi/meson.build
index 3b035aea339..ca6b61a608d 100644
--- a/qapi/meson.build
+++ b/qapi/meson.build
@@ -57,6 +57,7 @@ qapi_all_modules = [
 ]
 if have_system
   qapi_all_modules += [
+    'accelerator',
     'acpi',
     'audio',
     'cryptodev',
-- 
2.49.0


