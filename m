Return-Path: <kvm+bounces-29371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C439AA09C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DA541F25F88
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E5319D881;
	Tue, 22 Oct 2024 10:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XGvCGT30"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A4619AD8D
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594593; cv=none; b=hT0ZSmwSgVnCNC98k0jiJJR5omU8hG4TDTTQakJWCDaf88kXe5vXBKH6Zn7z4ByZME2nWZ/u0Z642pqKb6dCmO5idx0KEn1OhhZgwj2E2zMMtKs7k6R9UxmleHxOBiWtwKMPpCtYT/8GQavvkaDANKemiikyF13O1FJONAkYt9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594593; c=relaxed/simple;
	bh=lpxl7MPf0Wbio1YTPaq7dXRDfcIsws51Vanz7vypfTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QvYKTg45CQp4wNcVTkERkVNY9AYsmOKwgZiR4KYjtBpsW964fe1dzA5AXSRiqAXIeHzipe6VFAWlZAdZk3K0UF5+A2q8q/UzcRpEPc/gVWL6jEsP0GJ3Z7Ci5TIOJRD2h+qp2CZvhJCKFSpB+e2vxGSX0hvdUAFnnYJ64LaI0tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XGvCGT30; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a628b68a7so711067066b.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594590; x=1730199390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLOsiFp7nSYSKf/se2Emh5FqkyaR/LV5KofnrCQ0C68=;
        b=XGvCGT30eJniLJsaD6TdeDgajZ0R2yPtywHUkY/xHmMvzNIEHH8YzHNLb72/S9Bl71
         KTv/k+ddMPFkVvc/C0K7Bs/AUWklgF1cZUp1oUXgxpq9IocdkgJ89UMV2chWnHPTZ7Gk
         RwD5+PA/UcH+5rtiGhCYP2qTMvujUL1+C7lbCJt3h3pRaLQ5yEnnh0U8oEp781BsKyQb
         TfpGj0/LGinkRQUDF4PWZlTk19uildT8Dv+gsiGd4Y80aqCnYiTFacGNxjxiQfiYInOs
         9sHNyT7RjxMQ6uKrcv8acFbmVQSvSibhZFXYT69xKt9UryolPJKE1BMYQt1osDVSqBwR
         prxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594590; x=1730199390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rLOsiFp7nSYSKf/se2Emh5FqkyaR/LV5KofnrCQ0C68=;
        b=XvMc3rADtUDqgY6dajTUlTAH6KGYSo1b7/VYgdnQOHJXrNvJBjPNgXCPaTvAh9A4TA
         VnXXW2LypIsMjwYgW1WoZZcQHOLdxEe6eEOIzBG66byNLw9IvFK4bgDrqeIE7Fv1eD6A
         lWPmvkBrMMIJNfb1qevIs/tPoxO/0VO8ZDScTnxLqSjnUMhMWiJZFYAsq+DrfrDf1TZF
         oPBSwjZWg3XBInOv9YYUbFMZjeRVFKjLq6mrjOgm/XH9AI5Ks0n6Pm4/8fYrEQBdIdfs
         JElH2P9X5iTgcCGpxWgF8+O03HFQQRiZu/in/uiV1hL5kENZEoCKQNZyrSf+8HhMZSq/
         coww==
X-Forwarded-Encrypted: i=1; AJvYcCXLcmnF1zC6Ynh36ha4AzTArQED2urAmrDg8NvQC5ruKok10iGUBZyWLKdmIXHrzSnChIo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2Ldhug8Jre2ldFgBL5ud8ILgpZte+9F1zEUY+zdPb6/oFAhV/
	9QMCkowfbMBsm57Cr5gy9gJsxQH2aaoK7Lc7wsnp5Y9ne4QXW+X36VsSBYeSJoA=
X-Google-Smtp-Source: AGHT+IFvlb/CmT8eWULIjRtzdfUNfGcd5+oEeP4MY3wCJkBrE+WrjT0rHQJ8GXb9kTKmNzYQI1ufsA==
X-Received: by 2002:a17:907:3182:b0:a9a:a7fd:d840 with SMTP id a640c23a62f3a-a9aa7fdd87bmr350993366b.1.1729594590177;
        Tue, 22 Oct 2024 03:56:30 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d6355sm324467166b.37.2024.10.22.03.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:28 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id ECA855FC11;
	Tue, 22 Oct 2024 11:56:15 +0100 (BST)
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
	Paolo Bonzini <pbonzini@redhat.com>,
	Gustavo Romero <gustavo.romero@linaro.org>
Subject: [PATCH v2 15/20] testing: Enhance gdb probe script
Date: Tue, 22 Oct 2024 11:56:09 +0100
Message-Id: <20241022105614.839199-16-alex.bennee@linaro.org>
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

From: Gustavo Romero <gustavo.romero@linaro.org>

Use list and set comprehension to simplify code. Also, gently handle
invalid gdb filenames.

Signed-off-by: Gustavo Romero <gustavo.romero@linaro.org>
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


