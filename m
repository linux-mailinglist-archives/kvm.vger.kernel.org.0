Return-Path: <kvm+bounces-29496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 946249AC954
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6ADCB21C39
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC341AB6DC;
	Wed, 23 Oct 2024 11:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mJwJGB+t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCD71AAE37
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683848; cv=none; b=txsPy8lUizU5GfUw7FIUSkzyZXjHnH6FMi6+7/ylVuXjtIGsnqBViOlL9+mrtmv553ZvG+5iwyJVxDlqoSvIdIJlVrfCM6q6ZJaheAY5VxkcPTtzpW8S3mhXPWACWWmqwiiptEEPahcCzbUJOCxUcnS9qHgs0gw4Y8Z61dMUTVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683848; c=relaxed/simple;
	bh=rb3f1U6P64o9JDmRzVN/42YTd7peCfGvE1Ae01sbveQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qqUxOqio+hk0ysyCGCoS8KrFVFFrnsYK+L1sA5MSCWsIemmxPRVWK/WZetQYtG5Ru5QYL1gJRhXAcGijGXTpO1kkcnqbEIjBxfoxp+JV1FDHJJ3wkD+427L5JWv+MR/Dp//hziehCp/P2BeLdrLgGquVJ9JO8w0adptG08kD8kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mJwJGB+t; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539e7e73740so5990280e87.3
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683845; x=1730288645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=goM9TWkvUJk023ZZ8+wq0WOvMkki4+LOppFI2tLZ0P4=;
        b=mJwJGB+tTCUA1l0SMupmB8Qlk3+o4JgmE6PXnOvjV0uXCA0z2KOBDmBuKSKiuNGXCD
         q2ME6svMTZcFBRzBx8SOaET0Q1sC3fZzIv5GOj9o9khoyPBHxa4E567r/I8RjVzgs7vp
         L8PBz4hdORRCG9elYIsNhvFJnNBzvQa84D+nt8bJ8ZWbX59ziADFFbbEEDhylsjOKZAt
         I+ze9aTh6J1a6nGJeMguR0lpUsOk/1HkbfoPb40C1KzYr8inxjA771jkWoRH+6ug4am1
         wrRpKP0yl0B8z1NT5vD5UdDfB4iDbyWvSMbSOEu+ZzMbroTl/IzV8n2xEkSdqYLXyYS2
         vX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683845; x=1730288645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=goM9TWkvUJk023ZZ8+wq0WOvMkki4+LOppFI2tLZ0P4=;
        b=ZUrvfkKm9xokU91gA1Wystw6WMGdIKyMsfdnpkpwWD/+/H2mRYAP1d4gSu26icNkvV
         bZyNhr2LxuvZoXmkiNByqMVo5Icn9b0VNsmWWW+eIN7361P3HOLmkAP4PCOOfOuzW+xJ
         hYC0AJj3Oqs/pkdITp5wA0xWqC16VwFvW1yFLmOsordlWxNAVNFPLk+MmKJr96OlZxNm
         Hpu60PfYTeTBYMLEvnhE+wCpPwjiqwhEfVGrmEnQafOVPL94NPhWT5S+zu+vSSbqXVqx
         9tQnEmZT0h8Gu6o+gJxik1tRf5N3AFDoC4pCqkQWGHC9mwsAaudn4Vz7hLpA3VP2JC8r
         3UfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfB/QCcfyV/yVu6nY6pTBwQCt8XTzeGlsWPW41qBXBTQojL2chgcP7sw1ObcnmFsEvYcs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNpZ3dbSTQdnriDBEMJWifnNBteVEhHzhfV020kSeiji1TWCUR
	0rm6pfHQtqnDAz09MbIiOP48lKSzPkv87+WQf+NuToTJmOcwGK4tLJA4hvb/ahU=
X-Google-Smtp-Source: AGHT+IHDtHU0ccJr5rc5xz8My9arnYk+SlnudjoCir3kQRdzjKiDoRSU1ko8s5OGs4YQqLHIEVXPxQ==
X-Received: by 2002:a05:6512:398a:b0:539:f2f6:c70f with SMTP id 2adb3069b0e04-53b1a2fed80mr1092099e87.8.1729683844676;
        Wed, 23 Oct 2024 04:44:04 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91370e54sm462834566b.102.2024.10.23.04.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:44:03 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 6AE8B5FC0F;
	Wed, 23 Oct 2024 12:34:08 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	devel@lists.libvirt.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Beraldo Leal <bleal@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Gustavo Romero <gustavo.romero@linaro.org>
Subject: [PATCH v3 15/18] testing: Enhance gdb probe script
Date: Wed, 23 Oct 2024 12:34:03 +0100
Message-Id: <20241023113406.1284676-16-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241023113406.1284676-1-alex.bennee@linaro.org>
References: <20241023113406.1284676-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gustavo Romero <gustavo.romero@linaro.org>

Use list and set comprehension to simplify code. Also, gently handle
invalid gdb filenames.

Signed-off-by: Gustavo Romero <gustavo.romero@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Message-Id: <20241022105614.839199-16-alex.bennee@linaro.org>
Message-Id: <20241015145848.387281-1-gustavo.romero@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 scripts/probe-gdb-support.py | 75 +++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 36 deletions(-)

diff --git a/scripts/probe-gdb-support.py b/scripts/probe-gdb-support.py
index 6dc58d06c7..6bcadce150 100644
--- a/scripts/probe-gdb-support.py
+++ b/scripts/probe-gdb-support.py
@@ -19,58 +19,61 @@
 
 import argparse
 import re
-from subprocess import check_output, STDOUT
+from subprocess import check_output, STDOUT, CalledProcessError
+import sys
 
-# mappings from gdb arch to QEMU target
-mappings = {
-    "alpha" : "alpha",
+# Mappings from gdb arch to QEMU target
+MAP = {
+    "alpha" : ["alpha"],
     "aarch64" : ["aarch64", "aarch64_be"],
-    "armv7": "arm",
+    "armv7": ["arm"],
     "armv8-a" : ["aarch64", "aarch64_be"],
-    "avr" : "avr",
+    "avr" : ["avr"],
     # no hexagon in upstream gdb
-    "hppa1.0" : "hppa",
-    "i386" : "i386",
-    "i386:x86-64" : "x86_64",
-    "Loongarch64" : "loongarch64",
-    "m68k" : "m68k",
-    "MicroBlaze" : "microblaze",
+    "hppa1.0" : ["hppa"],
+    "i386" : ["i386"],
+    "i386:x86-64" : ["x86_64"],
+    "Loongarch64" : ["loongarch64"],
+    "m68k" : ["m68k"],
+    "MicroBlaze" : ["microblaze"],
     "mips:isa64" : ["mips64", "mips64el"],
-    "or1k" : "or1k",
-    "powerpc:common" : "ppc",
+    "or1k" : ["or1k"],
+    "powerpc:common" : ["ppc"],
     "powerpc:common64" : ["ppc64", "ppc64le"],
-    "riscv:rv32" : "riscv32",
-    "riscv:rv64" : "riscv64",
-    "s390:64-bit" : "s390x",
+    "riscv:rv32" : ["riscv32"],
+    "riscv:rv64" : ["riscv64"],
+    "s390:64-bit" : ["s390x"],
     "sh4" : ["sh4", "sh4eb"],
-    "sparc": "sparc",
-    "sparc:v8plus": "sparc32plus",
-    "sparc:v9a" : "sparc64",
+    "sparc": ["sparc"],
+    "sparc:v8plus": ["sparc32plus"],
+    "sparc:v9a" : ["sparc64"],
     # no tricore in upstream gdb
     "xtensa" : ["xtensa", "xtensaeb"]
 }
 
+
 def do_probe(gdb):
-    gdb_out = check_output([gdb,
-                            "-ex", "set architecture",
-                            "-ex", "quit"], stderr=STDOUT)
+    try:
+        gdb_out = check_output([gdb,
+                               "-ex", "set architecture",
+                               "-ex", "quit"], stderr=STDOUT, encoding="utf-8")
+    except (OSError) as e:
+        sys.exit(e)
+    except CalledProcessError as e:
+        sys.exit(f'{e}. Output:\n\n{e.output}')
+
+    found_gdb_archs = re.search(r'Valid arguments are (.*)', gdb_out)
 
-    m = re.search(r"Valid arguments are (.*)",
-                  gdb_out.decode("utf-8"))
+    targets = set()
+    if found_gdb_archs:
+        gdb_archs = found_gdb_archs.group(1).split(", ")
+        mapped_gdb_archs = [arch for arch in gdb_archs if arch in MAP]
 
-    valid_arches = set()
+        targets = {target for arch in mapped_gdb_archs for target in MAP[arch]}
 
-    if m.group(1):
-        for arch in m.group(1).split(", "):
-            if arch in mappings:
-                mapping = mappings[arch]
-                if isinstance(mapping, str):
-                    valid_arches.add(mapping)
-                else:
-                    for entry in mapping:
-                        valid_arches.add(entry)
+    # QEMU targets
+    return targets
 
-    return valid_arches
 
 def main() -> None:
     parser = argparse.ArgumentParser(description='Probe GDB Architectures')
-- 
2.39.5


