Return-Path: <kvm+bounces-6559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4C6B83669F
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:05:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6357B287BC3
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE7848788;
	Mon, 22 Jan 2024 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GkPRlpCH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764FC481DB
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935387; cv=none; b=pCAY4ONhpkna4K5RkUXxTOUsYhQW4Npdjr5oKBQTblvIFCylrsD2cM6W4x14ayuiNL34Af3KoYGm7Yah1F/9wsVa9XvOXz5vgPSSOeeQ2e/3zv9I3Wfv/ErTfwUTf5kw8c+KvX25gmgisjThkcsJqI5BUZ0HwN6hWwtuftfY3ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935387; c=relaxed/simple;
	bh=3h6eCmYIatSKyxVCRygBZpdZyaTGz355IWQk8GtFqoo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MPLcMb02Xn1DhI8aZQrOSh+o3KkNxCezv3hfuSLn9wHJQAUl64958lBf0UO5UW0aHar6f5wrL3TwFF5K25ebDYsmca2olXt5XNruwqTC/mfcnXB6Yr15mOLy8Rle1HGCsj8qcs6zDDoTL0iS6AJ/0Y+FMastIx214s1rErQ63ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GkPRlpCH; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3367a304091so3607300f8f.3
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 06:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935384; x=1706540184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KOWdwJWZtoTWqDMqrzzZRyWBV4iieoAaX695nl5QEU=;
        b=GkPRlpCH63djNjDVDzfhOorOcjEDPiyHwe2JjclftgSYa7nicPoOZHshWTgTSqn9ti
         gOrH+pxawaou79SUGIXs40mJB2qBGCzF4yZHfSQTsZGbpXT8a8p0FmdNJ6ZFdHeAY3zz
         be7luU7l6mxmsUl91htXHstXujUkpB9XR36K+mW/qQeJDzP7Kw8P6nIrUuyeVZamVSk9
         SdgSxoxw5ZAZ/TpBJpVTdGgxkXhzki3gtjVyIuhXfm+eZIg8WAmC66XyGIqAVaC4eEqw
         r5z5pbadLXZ7RdThb7c46jkAXcMiS/dgI4/9icMuK9tSVvyOSTWrWSpvm9l8o8TeEAdz
         AoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935384; x=1706540184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3KOWdwJWZtoTWqDMqrzzZRyWBV4iieoAaX695nl5QEU=;
        b=iPIkLnNAK0d8gbtTkNqlW7xaTLUbVg+k0T9WyguDGuffpwR0i34UJp4r7StHLnk1Lp
         z0kmiL7T/uG31XMP/plfHRUZT5ZcyUB1Fa47mSAQEugcH0Q2yS3tZ7o2gqJYHi7y/uhS
         4P5P0UuVBpZfh4io+haSsPHkWDswOK8Z9GUozE/YK0awRPybuOQBq1FgmFOrTVyXsvLO
         O2tfDTv3WvUUYxplRnCUYa96Z881/O7myPMpCPvVJQXBWhqkn9DFC1Ff4vBV+G2pVmHN
         BAUd7ttan93MnaTWZXKVsDo1a+bzCwD5+QrTX5NqKGQjozVQVG9TbJYVOp0xG7j/NX8L
         gLIg==
X-Gm-Message-State: AOJu0YwRvUYKvjdp8aEYDppZhvNX0tFvlL+Kfp4SS6oVJS0UXjVF1T3S
	LN6S1PYgNh80/1vtGl66L1B/P4J42M+VEqLCzqpaey+OBMyRyOcYfeaGIeBNpEY=
X-Google-Smtp-Source: AGHT+IHYdWbJ3oJ8yxGR3dSKr3DfBPsGhNRpkZOVjh0y9b4fwfaSBiz2ySUSvfsKhK3QnGLayw/0nQ==
X-Received: by 2002:adf:f20e:0:b0:337:bfe1:16f3 with SMTP id p14-20020adff20e000000b00337bfe116f3mr1368564wro.13.1705935383847;
        Mon, 22 Jan 2024 06:56:23 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id k2-20020a5d6282000000b0033838c2c169sm9307734wru.108.2024.01.22.06.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 06:56:19 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 7D83E5F932;
	Mon, 22 Jan 2024 14:56:12 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-ppc@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	John Snow <jsnow@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Cleber Rosa <crosa@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Paul Durrant <paul@xen.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v3 14/21] gdbstub: Add members to identify registers to GDBFeature
Date: Mon, 22 Jan 2024 14:56:03 +0000
Message-Id: <20240122145610.413836-15-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122145610.413836-1-alex.bennee@linaro.org>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akihiko Odaki <akihiko.odaki@daynix.com>

These members will be used to help plugins to identify registers.
The added members in instances of GDBFeature dynamically generated by
CPUs will be filled in later changes.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Message-Id: <20240103173349.398526-36-alex.bennee@linaro.org>
Message-Id: <20231213-gdb-v17-10-777047380591@daynix.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/exec/gdbstub.h  |  3 +++
 gdbstub/gdbstub.c       | 12 +++++++++---
 target/riscv/gdbstub.c  |  4 +---
 scripts/feature_to_c.py | 14 +++++++++++++-
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index 82a8afa237f..da9ddfe54c5 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -13,12 +13,15 @@
 typedef struct GDBFeature {
     const char *xmlname;
     const char *xml;
+    const char *name;
+    const char * const *regs;
     int num_regs;
 } GDBFeature;
 
 typedef struct GDBFeatureBuilder {
     GDBFeature *feature;
     GPtrArray *xml;
+    GPtrArray *regs;
     int base_reg;
 } GDBFeatureBuilder;
 
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 801eba9a0b0..420ab2a3766 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -419,9 +419,10 @@ void gdb_feature_builder_init(GDBFeatureBuilder *builder, GDBFeature *feature,
     builder->feature = feature;
     builder->xml = g_ptr_array_new();
     g_ptr_array_add(builder->xml, header);
+    builder->regs = g_ptr_array_new();
     builder->base_reg = base_reg;
     feature->xmlname = xmlname;
-    feature->num_regs = 0;
+    feature->name = name;
 }
 
 void gdb_feature_builder_append_tag(const GDBFeatureBuilder *builder,
@@ -440,10 +441,12 @@ void gdb_feature_builder_append_reg(const GDBFeatureBuilder *builder,
                                     const char *type,
                                     const char *group)
 {
-    if (builder->feature->num_regs < regnum) {
-        builder->feature->num_regs = regnum;
+    if (builder->regs->len <= regnum) {
+        g_ptr_array_set_size(builder->regs, regnum + 1);
     }
 
+    builder->regs->pdata[regnum] = (gpointer *)name;
+
     if (group) {
         gdb_feature_builder_append_tag(
             builder,
@@ -469,6 +472,9 @@ void gdb_feature_builder_end(const GDBFeatureBuilder *builder)
     }
 
     g_ptr_array_free(builder->xml, TRUE);
+
+    builder->feature->num_regs = builder->regs->len;
+    builder->feature->regs = (void *)g_ptr_array_free(builder->regs, FALSE);
 }
 
 const GDBFeature *gdb_find_static_feature(const char *xmlname)
diff --git a/target/riscv/gdbstub.c b/target/riscv/gdbstub.c
index 68d0fdc1fd6..d9b52ffd09b 100644
--- a/target/riscv/gdbstub.c
+++ b/target/riscv/gdbstub.c
@@ -266,11 +266,9 @@ static GDBFeature *riscv_gen_dynamic_csr_feature(CPUState *cs, int base_reg)
         }
         predicate = csr_ops[i].predicate;
         if (predicate && (predicate(env, i) == RISCV_EXCP_NONE)) {
-            g_autofree char *dynamic_name = NULL;
             name = csr_ops[i].name;
             if (!name) {
-                dynamic_name = g_strdup_printf("csr%03x", i);
-                name = dynamic_name;
+                name = g_strdup_printf("csr%03x", i);
             }
 
             gdb_feature_builder_append_reg(&builder, name, bitsize, i,
diff --git a/scripts/feature_to_c.py b/scripts/feature_to_c.py
index e04d6b2df7f..807af0e685c 100644
--- a/scripts/feature_to_c.py
+++ b/scripts/feature_to_c.py
@@ -50,7 +50,9 @@ def writeliteral(indent, bytes):
         sys.stderr.write(f'unexpected start tag: {element.tag}\n')
         exit(1)
 
+    feature_name = element.attrib['name']
     regnum = 0
+    regnames = []
     regnums = []
     tags = ['feature']
     for event, element in events:
@@ -67,6 +69,7 @@ def writeliteral(indent, bytes):
                 if 'regnum' in element.attrib:
                     regnum = int(element.attrib['regnum'])
 
+                regnames.append(element.attrib['name'])
                 regnums.append(regnum)
                 regnum += 1
 
@@ -85,6 +88,15 @@ def writeliteral(indent, bytes):
     writeliteral(8, bytes(os.path.basename(input), 'utf-8'))
     sys.stdout.write(',\n')
     writeliteral(8, read)
-    sys.stdout.write(f',\n        {num_regs},\n    }},\n')
+    sys.stdout.write(',\n')
+    writeliteral(8, bytes(feature_name, 'utf-8'))
+    sys.stdout.write(',\n        (const char * const []) {\n')
+
+    for index, regname in enumerate(regnames):
+        sys.stdout.write(f'            [{regnums[index] - base_reg}] =\n')
+        writeliteral(16, bytes(regname, 'utf-8'))
+        sys.stdout.write(',\n')
+
+    sys.stdout.write(f'        }},\n        {num_regs},\n    }},\n')
 
 sys.stdout.write('    { NULL }\n};\n')
-- 
2.39.2


